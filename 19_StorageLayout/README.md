# 合约存储布局

# 任务
## 题1
使用Slot模式读取和修改Owner地址，https://decert.me/challenge/163c68ab-8adf-4377-a1c2-b5d0132edc69
## 题2
了解：第一个挖矿合约：https://github.com/sushiswap/masterchef/blob/master/contracts/MasterChefV2.sol  开启了 DeFiSummer

读取合约私有变量数据：https://decert.me/quests/b0782759-4995-4bcb-85c2-2af749f0fde9
>在 Solidity 合约中定义的私有变量（private 变量），按设计是不能被外部合约或外部用户直接读取的。然而由于区块链的透明性，所有存储在链上的数据都是公开的。通过工具，可以读取合约的存储槽（storage slots），并解析出私有变量的值。

https://learnblockchain.cn/article/4172
https://learnblockchain.cn/docs/solidity/internals/layout_in_storage.html

