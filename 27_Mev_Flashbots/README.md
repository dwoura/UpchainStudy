# MEV 和 Flashbots

## 题目
https://decert.me/quests/70957dea-e3de-4b45-82c2-5c105c56c4ae
使⽤你熟悉的语⾔，利⽤ flashbot API eth_sendBundle 捆绑 OpenspaceNFT 的开启预售和 presale 交易
预售的交易(sepolia 测试⽹络)，并使⽤ flashbots_getBundleStats 查询状态，最终打印交易哈希和 stats 信息
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OpenspaceNFT is ERC721, Ownable {
    bool public isPresaleActive = true;
    uint256 public nextTokenId;

    constructor() ERC721("OpenspaceNFT", "OSNFT") Ownable(msg.sender) {
        nextTokenId = 1;
    }

    function presale(uint256 amount) external payable {
        require(isPresaleActive, "Presale is not active");
        require(msg.sender != owner(), "Disabled for owner");
        require(amount * 0.01 ether == msg.value, "Invalid amount");
        require(amount + nextTokenId <= 1024, "Not enough tokens left");

        uint256 _nextId = nextTokenId;
        for (uint256 i = 0; i < amount; i++) {
            _safeMint(msg.sender, _nextId);
            _nextId++;
        }
        nextTokenId = _nextId;
    }

    function enablePresale() external onlyOwner {
        isPresaleActive = true;
    }

    function withdraw() external onlyOwner {
        (bool success,) = msg.sender.call{ value: address(this).balance }("");
        require(success, "Transfer failed");
    }
}
```
提交内容：  
和 flashbot API 交互代码  
最终提交到 sepolia 网络的 enablePresale 和 presale 交易哈希   
flashbot flashbots_getBundleStats 对本次捆绑的返回信息。  
### 提交仓库
https://github.com/dwoura/FoundryProject/blob/main/src/Flashbot