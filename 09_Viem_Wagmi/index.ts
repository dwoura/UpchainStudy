// 获取区块高度的示例
// 导模块
import { createPublicClient, http } from "viem";
import { mainnet } from "viem/chains";

// 选择想要的链和传输协议设置client
const client = createPublicClient({
  chain: mainnet,
  transport: http(),
});

// 执行步骤
async function main() {
  const blockNumber = await client.getBlockNumber();
  console.log(blockNumber);
}

main();