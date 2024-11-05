package main

import (
	"context"
	"encoding/binary"
	"fmt"
	"github.com/ethereum/go-ethereum/crypto"
	"log"
	"math/big"
	"strconv"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
)

func main() {
	// 连接到 Sepolia 测试网节点
	client, err := ethclient.Dial("https://eth-sepolia.g.alchemy.com/v2/ozWVNCbqDXI4BIRxUQtKjpNkJpU1Iy8w")
	if err != nil {
		log.Fatalf("连接以太坊客户端失败: %v", err)
	}

	// 合约地址
	caAddr := common.HexToAddress("0x32Ef65Ed2004247C6dF7234E7AebCe512560F65b")

	slot := 0 // _locks slot
	hexSlot := strconv.FormatInt(int64(slot), 16)
	initialSlotHash := common.HexToHash(hexSlot) // 初始定义的 slot编号 0 的哈希值
	lockArrayLensBytes, err := client.StorageAt(context.Background(), caAddr, initialSlotHash, nil)
	if err != nil {
		log.Fatalf("获取插槽数据失败: %v", err)
		return
	}

	lockArrayLensByte := lockArrayLensBytes[len(lockArrayLensBytes)-1]
	lockArrayLens := int(lockArrayLensByte)

	// keccak256(hex(0)) 与 hash(hex(0))不一样！！！hash(hex(0)) 用于存储数组长度，而keccak256(hex(0))用于定位元素值
	initialSlotKeccak256Bytes := crypto.Keccak256(initialSlotHash.Bytes())
	initialSlotKeccak256Hash := common.BytesToHash(initialSlotKeccak256Bytes)

	for i := 0; i < lockArrayLens; i++ {
		index := new(big.Int).SetInt64(int64(i))
		two := new(big.Int).SetInt64(2)
		indexMulSlotNums := new(big.Int).Mul(index, two) // struct slot nums = 2

		structSlot0 := new(big.Int).Add(initialSlotKeccak256Hash.Big(), indexMulSlotNums)
		structSlot1 := new(big.Int).Add(structSlot0, new(big.Int).SetInt64(int64(1)))

		valueSlot0, err := client.StorageAt(context.Background(), caAddr, common.BytesToHash(structSlot0.Bytes()), nil)
		valueSlot1, err := client.StorageAt(context.Background(), caAddr, common.BytesToHash(structSlot1.Bytes()), nil)
		if err != nil {
			log.Fatalf("获取插槽数据失败: %v", err)
			return
		}
		// 截取插槽字节
		userAddrBytes := valueSlot0[len(valueSlot0)-20:]                      // 20 bytes
		startTimeBytes := valueSlot0[len(valueSlot0)-28 : len(valueSlot0)-20] // uint64 8 bytes
		amountBytes := valueSlot1[:32]                                        // 32 bytes

		// 数据格式转换
		userAddr := common.BytesToAddress(userAddrBytes)
		startTime := binary.BigEndian.Uint64(startTimeBytes)
		amount := new(big.Int).SetBytes(amountBytes)

		fmt.Println("locks["+strconv.Itoa(i)+"]:", "user:", userAddr, "startTime:", startTime, "amount:", amount)
	}
}
