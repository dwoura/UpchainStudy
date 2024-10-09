package main

import "fmt"

func main() {
	// 题1
	name := "dwoura"
	var zeros int
	println("请输入目标哈希前缀0个数")
	fmt.Scanln(&zeros)
	needTime, input, hash := proofOfWork(name, zeros)
	println("题1:")
	println(needTime.Milliseconds(), "ms", input, hash)

	// 题2
	println("题2:")
	// 生成 RSA 公私钥对
	privateKey, publicKey, err := generateKeyPair(2048)
	if err != nil {
		fmt.Println("生成 RSA key pair失败:", err)
		return
	}
	needTime, input, hash = proofOfWork(name, zeros)

	signature, _ := signMessage(privateKey, []byte(input))     // 对昵称数据签名
	err = verifySignature(publicKey, []byte(input), signature) // 对最终数据进行验证
	if err != nil {
		println("消息验证出错！")
		fmt.Println(err)
	} else {
		println("消息验证成功！")
		println(needTime.Milliseconds(), "ms", input, hash)
	}

}
