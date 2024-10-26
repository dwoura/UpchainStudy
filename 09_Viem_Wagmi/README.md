# Viem 上手
[Viem官网](viem.sh)
## 是什么？
Viem 是一种专为以太坊和其他 EVM 兼容区块链的 **JavaScript 库**，用于实现更加高效和灵活的链上交互。在功能和性能上被设计为替代 Ethers.js 和 web3.js。Viem 提供了对 **JSON-RPC 调用的支持、类型安全、轻量级依赖等功能**，确保与区块链的互动更加稳定和高效。
## 参考链接
https://learnblockchain.cn/article/8465
## 初始化文件夹
npm init

## 依赖安装
npm install dotenv viem
npm install -D typescript ts-node @types/node

## 在项目中初始化typescript的配置文件
npx tsc --init

## 新建一个index.ts文件，在里面写代码

## 打开根目录中的package.json，在scripts中添加"start": "ts-node index.ts"。
"scripts": {
  "test": "echo \"Error: no test specified\" && exit 1",
  "start": "ts-node index.ts"
},

## 运行pnpm start，终端会显示目前的区块高度。
> viem-scripts@1.0.0 start /viem-playground/viem-scripts
> ts-node index.ts

## 若要交互，新建一个 abi.ts 文件
我们需要 export const 文本，在变量内容末尾需要添加as const关键词，这样viem可以智能的读取里面的function信息。
末尾添加 as const 是为了精确推断类型，例如：
const example = 'hello';  // 推断为 string
const exampleConst = 'hello' as const;  // 推断为 'hello'

# Wagmi
[Wagmi 官网](wagmi.sh)  
wagmi和 viem 其实是同一家公司出品的。wagmi集成了viem，是用于构建以太坊app的框架。而 viem 是一个底层的， ethers.js 的更好的替代品。

## Wagmi CLI 
Wagmi CLI 是一个命令行界面，用于管理 ABI（来自 Etherscan/区块浏览器、Foundry/Hardhat 项目等）、**生成代码**（例如 React Hooks）等。  
#### 创建
`npm install --save-dev @wagmi/cli` 安装wagmi  
`npx wagmi init`初始化 wagmi，生成配置文件  
#### 配置
创建完后有配置文件，在里边可以对如plugins中进行配置。[插件介绍](https://wagmi.sh/cli/api/plugins)  
例如：
``` ts
import { defineConfig } from '@wagmi/cli'  // 引入配置文件
import { etherscan } from '@wagmi/cli/plugins' // 引入插件
export default defineConfig({
  out: 'src/generated.ts',
  contracts: [],
  plugins: [
    etherscan({
      apiKey: process.env.ETHERSCAN_API_KEY,
      chainId: 1,
      contracts: [
        {
          name: 'USDC',
          address: '0xecb504d39723b0be0e3a9aa33d646642d1051ee1',
        },
      ],
    }),
  ],
})
```
配置好之后，就可以通过 `npx wagmi generate` 来生成相关代码。