// 查询Ethereum链上最近100个区块链内的 USDC Transfer记录
// USDC: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
// 关键：使用contract.getEvents 函数，需要使用合约 ABI，因为contract 对象需要 ABI

// import * as viem from "viem"; // 方便使用但可读性较差
import { createPublicClient,getContract, http, formatUnits } from "viem";
import { mainnet } from "viem/chains";
import dotenv from "dotenv";
import { usdCimplConfig } from "../../src/generated";  // 如何相对路径??
import { Address } from 'viem'; // 强类型地址类型

dotenv.config();

const client = createPublicClient({
  chain: mainnet,
  transport: http(process.env.ETH_RPC_URL),
});

// usdc 合约对象
const contract = getContract({
    address: usdCimplConfig.address[2], // 存储合约的地址
    abi: usdCimplConfig.abi,    // 逻辑合约的 abi
    client: client
})

async function getUSDCEvents(){
    const latestBlock:bigint = await client.getBlockNumber();
    const decimals = await contract.read.decimals();

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
            formatUnits(log.args.value as bigint, decimals ),
            "USDC, 交易ID：",
            log.transactionHash.toString()
        );
    });
}

async function getLatest100EventsOfUSDC(){
    const latestBlock:bigint = await client.getBlockNumber();
    const decimals = await contract.read.decimals();
    //const filter = await contract.createEventFilter.Transfer()
    const unwatch = contract.watchEvent.Transfer(
        {
        },
        { 
            fromBlock: latestBlock, // 前一百个区块
            onLogs: logs => {
                    logs.forEach(async(log)=>{
                        const block = await client.getBlock({blockNumber: log.blockNumber});

                        console.log(
                            "从",
                            log.args.from?.toString(),
                            "转账给",
                            log.args.to?.toString(),
                            formatUnits(log.args.value as bigint, decimals ),
                            "USDC, 交易ID:",

                            log.transactionHash.toString(),
                            "时间:",
                            (new Date(Number(block.timestamp)*1000)).toLocaleString()
                        );
                    });

            },
            onError: error => console.error('Error:', error)
        }
    ); 
}

async function main() {
    getLatest100EventsOfUSDC();

    //getUSDCEvents();
    
}

main();