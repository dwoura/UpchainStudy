# 以太坊签名原理学习记录
>本文从解决问题为出发点，从目前最常用的解决问题的协议--EIP2612，向前倒序简述。
## 相关发展历史
+ ERC20的缺陷--approve
erc20的成功源于 approve 与 transferFrom 的相互作用，但由于其 approve 函数使用了 msg.sender , 导致合约必须被一个外部账户调用。
为了解决这个设计限制，在EIP2612中**允许用户使用签名消息 permit** 来修改映射，放弃使用 msg.sender、allowance。
EIP2612使用到了**签名数据**，按照 **EIP712** 标准进行构建。

+ EIP2612
EIP20 在协议层面看依旧是二等代币，因为用户与以太坊交互仍然需要持有 eth 作为 gas，这也是许多提案的主题。
目前已采纳的提案如 EIP777，也由于引入了许多附加功能使得主流合约出现了意外行为。
EIP2612提出的是**替代解决方案**，目的只是为了解决一个问题：**EIP20的方法缺乏对 approve 进行抽象**

虽然看起来可以为 ERC-20 每个函数（如 transfer）添加基于签名的版本（如 transfer_by_signature），但这并不符合标准的通用性和灵活性。
因为不同用例对这些函数的需求和实现细节不同，**开发者可以利用 permit 和其他辅助合约在不改变标准的情况下实现这些功能**。（可扩展性）
这样既保持了 ERC-20 的简单性和通用性，又为开发者提供了足够的扩展自由。

+ 从EIP191升级来的EIP712

“EIP-712: 标准化结构化数据的签名”。
主要目的是更加安全的方式对结构化数据进行签名。使用 EIP-712 可以避免常见的签名错误。

+ EIP191 

## 协议简述
### EIP2612--对EIP20签名Approvals的 permit 扩展
EIP2612可以实现离线签名的操作，类似于用户写支票给别人操作指定额度的存款。
该协议拿到用户携带的 approve 签名，携带签名信息发送交易来花费 token。

**直接使用会具有缺陷**：没有符合EIP712标准，可能不太安全。但我们可以自定义成 EIP712 标准的格式。
因此我们一般会结合两种EIP：**使用EIP721格式，用 EIP2612标准实现**。

#### 协议规范

该协议在EIP20的基础上，实现了另外的三个功能。
``` solidity
function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external
function nonces(address owner) external view returns (uint)
function DOMAIN_SEPARATOR() external view returns (bytes32)
```
`permit`的执行条件如下：
+ 当前区块时间小于等于 dealine
+ owner不能为零地址
+ 未更新的nonces[owner]值等于nonce
+ r,s,v 是来自函数参数 owner 的有效的 secp256k1 签名

对于`DOMAIN_SEPARATOR()`函数，目的是为了**防止签名的重入攻击**。通过签名、特定合约以及特定的链的绑定来实现，这样能够杜绝在其他合约或链上重放签名的可能。
而`DOMAIN_SEPARATOR`是域分隔函数返回的哈希值。
下面是使用DOMAIN_SEPARATOR的示例：
``` solidity
keccak256(abi.encodePacked(
   hex"1901",
   DOMAIN_SEPARATOR,
   keccak256(abi.encode(
            keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
            owner,
            spender,
            value,
            nonce,
            deadline))
))
```
当然，为了保障安全性，DOMAIN_SEPARATOR 需要结合 **EIP712与签名、特定合约以及特定的链** 来得到：
``` solidity
DOMAIN_SEPARATOR = keccak256(
    abi.encode(
        keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
        keccak256(bytes(name)),
        keccak256(bytes(version)),
        chainid,
        address(this)
));
```
从上面代码可以看到，EIP712Domain函数正是防止重入攻击用到的几个参数。
上面这段信息也可以转换为基于 EIP712 类型结构：
```
{
  "types": {
    "EIP712Domain": [
      {
        "name": "name",
        "type": "string"
      },
      {
        "name": "version",
        "type": "string"
      },
      {
        "name": "chainId",
        "type": "uint256"
      },
      {
        "name": "verifyingContract",
        "type": "address"
      }
    ],
    "Permit": [
      {
        "name": "owner",
        "type": "address"
      },
      {
        "name": "spender",
        "type": "address"
      },
      {
        "name": "value",
        "type": "uint256"
      },
      {
        "name": "nonce",
        "type": "uint256"
      },
      {
        "name": "deadline",
        "type": "uint256"
      }
    ],
  },
  "primaryType": "Permit",
  "domain": {
    "name": erc20name,
    "version": version,
    "chainId": chainid,
    "verifyingContract": tokenAddress
  },
  "message": {
    "owner": owner,
    "spender": spender,
    "value": value,
    "nonce": nonce,
    "deadline": deadline
  }
}
```
我们可以注意到，**没有任何一个定义涉及到 msg.sender**，并且 permit 函数可以被任何人调用。  

##### 小结
 EIP2612新增的三个功能 permit、nonces 和 DOMAIN_SEPARATOR，无非就是为了两点：用户无需gas操作以及保证安全性。  
 对于nonces，它是 owner 对本合约发交易次数的映射，也是为了防止重放攻击。

+ 常见用例
owner permit 给一个中介，中介可以代替 owner 进行交易（owner 不需要付 gas 了）。  
中介可以选择是否提交 perimt 的消息。  
若owner 希望 permit 永久有效，可以设置 dealine 为 uint(-1)（表示无符号整数的最大值）。  

#### 一些小问题
+ v r s是什么？怎么从签名中得到的
+ owner 可以自行提交 permit 吗？

### EIP712--类型化结构化数据哈希和签名
