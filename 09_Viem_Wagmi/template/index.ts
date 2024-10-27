//@ts-nocheck
import { createPublicClient,getContract, createWalletClient, http } from "viem";
import { mainnet } from "viem/chains";
import { privateKeyToAccount } from "viem/accounts";
import dotenv from "dotenv";
import {abi,address} from "./abi"; // need abi if you want to interact with contract

// load config
dotenv.config();

// // pvkey to account
// const account = privateKeyToAccount(`0x${process.env.PRIVATE_KEY}`);

// // read rpc
// const rpc = process.env.ETH_RPC_URL;

// // option: WalletClient to send or sign tx
// const walletClient = createWalletClient({
//   account,
//   chain: mainnet,
//   transport: http(rpc),
// });

// option: PublicClient to interact with chain
const client = createPublicClient({
  chain: mainnet,
  transport: http(), // http(rpc)
});

const contract = getContract({
    address: address,
    abi: abi,
    client: client
})

async function funcName(){
    console.log();
}

async function main() {
    const balance = await contract.read.balanceOf(['0xa5cc3c03994DB5b0d9A5eEdD10CabaB0813678AC',]);
    const hash = await contract.write.mint([69420]);
    const logs = await contract.getEvents.Transfer();
    const unwatch = contract.watchEvent.Transfer(
        {
            from: '0xd8da6bf26964af9d7eed9e03e53415d37aa96045',
            to: '0xa5cc3c03994db5b0d9a5eedd10cabab0813678ac'
        },
        { onLogs: logs => console.log(logs) }
    );
    
}

main();