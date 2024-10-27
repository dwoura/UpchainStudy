// 查询Ethereum链上最近100个区块链内的 USDC Transfer记录
// USDC: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
// 关键：使用client.createEventFilter 函数，无需使用合约ABI。但需要使用 parseAbiItem 来 parse 单条ABI

import { createPublicClient, http,parseAbiItem ,formatUnits} from "viem";
import { mainnet } from "viem/chains";
import dotenv from "dotenv";


dotenv.config();

const client = createPublicClient({
  chain: mainnet,
  transport: http(process.env.ETH_RPC_URL),
});

async function getUSDCEventsWithFilter(){
    const latestBlock:bigint = await client.getBlockNumber();

    // 创建一个 Transfer 事件的 filter
    const filter = await client.createEventFilter(
        {
            address: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48', // USDC address
            event: parseAbiItem('event Transfer(address indexed from, address indexed to, uint256 value)'), // 单条transfer事件的ABI
            fromBlock: latestBlock - BigInt(100), 
            toBlock: latestBlock
        }
    )

    // 获取 filter 所匹配的 logs 并打印出来
    const logs = await client.getFilterLogs({filter});
    console.log("打印 log")
    logs.forEach(log => {
        console.log(
            "从",
            log.args.from?.toString(),
            "转账给",
            log.args.to?.toString(),
            formatUnits(log.args.value as bigint, 6),
            "USDC, 交易ID：",
            log.transactionHash?.toString()
        );
    });
}

async function main() {
    getUSDCEventsWithFilter();
}

main();