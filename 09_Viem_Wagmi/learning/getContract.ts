// getContract学习
// 读取指定nft地址的合约信息的示例
import { createPublicClient, getContract, http } from "viem";
import { mainnet } from "viem/chains";
import { privateKeyToAccount } from "viem/accounts";
import dotenv from "dotenv";
import {abi,address} from "./abi";

dotenv.config();

// 选择想要的链和传输协议设置client
const client = createPublicClient({
  chain: mainnet,
  transport: http(),
});

const contract = getContract({
    address: address,
    abi: abi,
    client: client
})

async function main() {
    // const blockNumber = await client.getBlockNumber();
    // console.log(blockNumber);
  
    const tokenId:any = 1;
    // readOwnerOf(tokenId);
    // readTokenUri(tokenId);
    const result = await contract.read.ownerOf([tokenId]); // 注意！传递参数的时候需要在[]中填入。使用数组来传参，是为了保证参数的传递形式统一。
    console.log("owner of token no.1 nft is:\n", result);
}

async function readOwnerOf(tokenId: number){
    const nftOwner = await client.readContract({
        address,
        abi,
        functionName: "ownerOf",
        args: [BigInt(1)],
    });
  
    console.log("owner of token no.1 nft is:\n",nftOwner);
}

async function readTokenUri(tokenId: number) {
    const nftUri = await client.readContract({
        address,
        abi,
        functionName: "tokenURI",
        args: [BigInt(1)],
    });
    console.log("URI of token", tokenId,"nft is:\n",nftUri);
}
main();