#

## 
https://github.com/Uniswap/permit2
学习了permit2和可升级合约

## 题目1
1、在原来的 TokenBank 添加一个方法 depositWithPermit2()， 这个方式使用 permit2 进行签名授权转账来进行存款。
在本地环境需要大家先部署 Permit2 合约

2、修改 Token 存款前端 (也可以自己实现）让用户可以在前端通过 permit2 的签名存款。

## 题目2
实现⼀个可升级的工厂合约，工厂合约有两个方法：

deployInscription(string symbol, uint totalSupply, uint perMint) ，该方法用来创建 ERC20 token，（模拟铭文的 deploy）， symbol 表示 Token 的名称，totalSupply 表示可发行的数量，perMint 用来控制每次发行的数量，用于控制mintInscription函数每次发行的数量
mintInscription(address tokenAddr) 用来发行 ERC20 token，每次调用一次，发行perMint指定的数量。
要求：
• 合约的第⼀版本用普通的 new 的方式发行 ERC20 token 。
• 第⼆版本，deployInscription 加入一个价格参数 price  deployInscription(string symbol, uint totalSupply, uint perMint, uint price) , price 表示发行每个 token 需要支付的费用，并且 第⼆版本使用最小代理的方式以更节约 gas 的方式来创建 ERC20 token，需要同时修改 mintInscription 的实现以便收取每次发行的费用。

需要部署到测试⽹，并开源到区块链浏览器，在你的Github的 Readme.md 中备注代理合约及两个实现的合约地址。

有升级的测试用例（在升级前后状态不变）
有运行测试的日志或截图

###　答题仓库
