// 读取指定nft地址的合约信息的示例
import { createPublicClient,getContract, createWalletClient, http } from "viem";
import { mainnet } from "viem/chains";
import { privateKeyToAccount } from "viem/accounts";
import dotenv from "dotenv";
import {abi,address} from "./abi";

dotenv.config();

const account = privateKeyToAccount(`0x${process.env.PRIVATE_KEY}`);

const rpc = process.env.ETH_RPC_URL;

// 注意区分wallet client 和public client
const walletClient = createWalletClient({
  account,
  chain: mainnet,
  transport: http(rpc),
});

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

async function readOwnerOf(tokenId: bigint){
    const nftOwner = await contract.read.ownerOf([tokenId]);
    console.log("owner of token no.1 nft is:\n",nftOwner);
}

async function readTokenUri(tokenId: bigint) {
    const nftUri = await contract.read.tokenURI([tokenId]);
    console.log("URI of token", tokenId,"nft is:\n",nftUri);
}

async function main() {
    const tokenId:bigint = BigInt(1);
    readOwnerOf(tokenId);
    readTokenUri(tokenId);
}

main();