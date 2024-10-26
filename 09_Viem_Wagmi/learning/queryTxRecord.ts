// 查询Ethereum链上最近100个区块链内的 USDC Transfer记录
// USDC: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48

import { createPublicClient,getContract, createWalletClient, http } from "viem";
import { mainnet } from "viem/chains";
import dotenv from "dotenv";
import { usdCimplConfig } from "../src/generated"; // 使用相对路径前设置好 tsconfig 中的 baseUrl
import { Address } from 'viem'; // 为了解决强类型地址类型

dotenv.config();

const client = createPublicClient({
  chain: mainnet,
  transport: http(process.env.ETH_RPC_URL),
});

const contract = getContract({
    address: usdCimplConfig.address[2], // 存储合约的地址
    abi: usdCimplConfig.abi,    // 逻辑合约的 abi
    client: client
})

async function getUSDCEvents(){
    const latestBlock:bigint = await client.getBlockNumber();
    const logs = await contract.getEvents.Transfer(
        {
        },
        {
            fromBlock: latestBlock-BigInt(100),
            toBlock: latestBlock
        }
    );

    logs.forEach(log => {
        console.log(
            "从",
            log.args.from?.toString(),
            "转账给",
            log.args.to?.toString(),
            log.args.value?.toString(),
            "USDC, 交易ID：",
            log.transactionHash.toString()
        );
    });
}

// async function getLatest100EventsOfUSDC(){
//     const latestBlock:bigint = await client.getBlockNumber();
    
//     const unwatch = contract.watchEvent.Transfer(
//         {
//             from: '0x0920D73e552605a81BD5434Ca25d3743EAf199a5',
//             to: '0x0920D73e552605a81BD5434Ca25d3743EAf199a5'
//         },
//         { 
//             fromBlock: latestBlock, // 前一百个区块
//             onLogs: logs => {

//                     logs.forEach(log => {
//                         console.log(
//                             "从",
//                             log.args.from?.toString(),
//                             "转账给",
//                             log.args.to?.toString(),
//                             log.args.value?.toString(),
//                             "USDC, 交易ID：",
//                             log.transactionHash.toString()
//                         );
//                     });

//             },
//             onError: error => console.error('Error:', error)
//         }
//     ); 
// }

//从 xx 转账给 xx 99.12345 USDC ,交易ID：
async function main() {

    // console.log('Transfer logs:', logs);
    // const unwatch = contract.watchEvent.Transfer(
    //     {
    //         from: '0x0920D73e552605a81BD5434Ca25d3743EAf199a5',
    //         to: '0x0920D73e552605a81BD5434Ca25d3743EAf199a5'
    //     },
    //     { 
    //         fromBlock: BigInt(21050366), // 确保这个区块范围包含您要监听的事件
    //         onLogs: logs => {
    //             if (logs.length > 0) {
    //                 console.log('Transfer logs:', logs);
    //             } else {
    //                 console.log('No Transfer events found in the specified block range.');
    //             }
    //         },
    //         onError: error => console.error('Error:', error)
    //     }
    // );  

    //getLatest100EventsOfUSDC();
    getUSDCEvents();
}

main();