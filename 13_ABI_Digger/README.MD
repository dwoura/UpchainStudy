# 深入学习 ABI
订阅事件，订阅交易，查询区块链数据

## 任务：
当合约部署者没有上传合约源代码时，我们是否能逆向分析合约的方法信息呢？  
请解析这笔交易数据所表达的意图： `0xa9059cbb0000000000000000000000005494befe3ce72a2ca0001fe0ed0c55b42f8c358f000000000000000000000000000000000000000000000000000000000836d54c`  
+ ABI：利用Cast工具逆向解码交易数据，https://decert.me/quests/0ba0f6e3-2b87-4a9b-b3aa-ae5f323459e1
+ ABI：使用 Viem 解析 以太坊USDT的 Trasnfer 日志: https://decert.me/quests/982e088b-f252-466b-8311-1a5834a7c8d1  

### 题1记录
#### 相关指令
`cast pretty-calldata "xxx"`  
```
cast abi-decode 'address,uint256' 0000000000000000000000005494befe3ce72a2ca0001fe0ed0c55b42f8c358f000000000000000000000000000000000000000000000000000000000836d54c
``` 
解码多个参数 

##### 区分合约中的`abi.decode()`函数，例如：
```
cast abi-decode "balanceOf(address)(uint256)" 
0x000000000000000000000000000000000000000000000000000000000000000a
```  
不输入参数即为解码**output**，上述函数的返回值类型是`(uint256)`，数据按照返回值类型解码。

```
cast abi-decode --input "transfer(address,uint256)" 0xa9059cbb000000000000000000000000e78388b4ce79068e89bf8aa7f218ef6b9ab0e9d0000000000000000000000000000000000000000000000000008a8e4b1a3d8000
```
解码函数参数**input**需要携带命令参数`--input`，返回该字节码中对应函数参数的值。
`(uint256 number, address addr) = abi.decode(data, (uint256, address));`  

### 题2
使用 Viem 编写 ts 脚本查询Ethereum链上最近100个区块链内的 USDC Transfer记录，要求如下：
按格式输出转账记录：
从 0x099bc3af8a85015d1A39d80c42d10c023F5162F0 转账给 0xA4D65Fd5017bB20904603f0a174BBBD04F81757c 99.12345 USDC ,交易ID：0xd973feef63834ed1e92dd57a1590a4ceadf158f731e44aa84ab5060d17336281
给出完整的 ts 脚本  

**Repository**

