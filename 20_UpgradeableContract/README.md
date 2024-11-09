# 可升级合约（代理合约）
## 题1 铭文工厂（可升级代理+最小代理合约部署）
https://decert.me/challenge/ac607bb0-53b5-421f-a9df-f3db4a1495f2

实现⼀个可升级的工厂合约，工厂合约有两个方法：

deployInscription(string symbol, uint totalSupply, uint perMint) ，该方法用来创建 ERC20 token，（模拟铭文的 deploy）， symbol 表示 Token 的名称，totalSupply 表示可发行的数量，perMint 用来控制每次发行的数量，用于控制mintInscription函数每次发行的数量
mintInscription(address tokenAddr) 用来发行 ERC20 token，每次调用一次，发行perMint指定的数量。
要求：
• 合约的第⼀版本用普通的 new 的方式发行 ERC20 token 。
• 第⼆版本，deployInscription 加入一个价格参数 price  deployInscription(string symbol, uint totalSupply, uint perMint, uint price) , price 表示发行每个 token 需要支付的费用，并且 第⼆版本使用最小代理的方式以更节约 gas 的方式来创建 ERC20 token，需要同时修改 mintInscription 的实现以便收取每次发行的费用。

需要部署到测试⽹，并开源到区块链浏览器，在你的Github的 Readme.md 中备注代理合约及两个实现的合约地址。

有升级的测试用例（在升级前后状态不变）
有运行测试的日志或截图
请提交你的 github 仓库地址。
### 提交仓库
github src：https://github.com/dwoura/FoundryProject/tree/main/src/UpgradeableAndMinimalProxy/InscriptionFactory
github test：https://github.com/dwoura/FoundryProject/blob/main/test/UpgradeableAndMinimalProxyTest/InscriptionProxy.t.sol
github script: https://github.com/dwoura/FoundryProject/blob/main/script/DeployInscriptionFactoryProxy/InscriptionFactoryProxy.s.sol
github broadcast: https://github.com/dwoura/FoundryProject/blob/main/broadcast/InscriptionFactoryProxy.s.sol/11155111/run-latest.json
测试用例：附件图
== Logs ==
  logicV1 Deployed: 0x98Ee3128f4a761D35bDbED8BF3B9ef1655a2dd25
  logicV2 Deployed: 0xfF85BBcd98A410FB3Bf1148A474F5a67621a788d
  proxy Deployed: https://sepolia.etherscan.io/address/0x49c45dFFD9c839ffDe3ebEf167d62c752ef06CA8
  proxyAdmin Deployed: 0x2E4C010ddf9a139267F27A7f9B0Ba6B41cAc4d61
  inscriptionV1 Deployed: 0x9cD14d261A3F47961A6b92B4C78663CC4b68b449
  inscriptionV2 Deployed: 0x9F326bB1068B2dD7cBc2ee3A7737aBC29BBB06Ad

### 本题总结

## 题2 可升级的 NFT Market 合约
实现⼀个可升级的 NFT 市场合约：
• 实现合约的第⼀版本和这个挑战 的逻辑一致。
• 逻辑合约的第⼆版本，加⼊离线签名上架 NFT 功能⽅法（签名内容：tokenId， 价格），实现⽤户⼀次性使用 setApproveAll 给 NFT 市场合约，每个 NFT 上架时仅需使⽤签名上架。

需要部署到测试⽹，并开源到区块链浏览器，在你的Github的 Readme.md 中备注代理合约及两个实现的合约地址。

要求：

有升级的测试用例（在升级前后状态不变）
有运行测试的日志或截图
请提交你的 github 仓库地址。
### 提交仓库
暂无