// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.26;
// old contract
// contract MyWallet { 
//     string public name;
//     mapping (address => bool) private approved;
//     address public owner;

//     modifier auth {
//         require (msg.sender == owner, "Not authorized");
//         _;
//     }

//     constructor(string memory _name) {
//         name = _name;
//         owner = msg.sender;
//     } 

//     function transferOwernship(address _addr) public auth{
//         require(_addr!=address(0), "New owner is the zero address");
//         require(owner != _addr, "New owner is the same as the old owner");
//         owner = _addr;
//     }
// }
// 重新修改 MyWallet 合约的 transferOwernship 和 auth 逻辑，使用内联汇编方式来 set和get owner 地址。
pragma solidity ^0.8.26;
contract MyWallet { 
    string public name;
    mapping (address => bool) private approved;
    address public owner;

    modifier auth {
        require (msg.sender == owner, "Not authorized");
        _;
    }

    constructor(string memory _name) {
        name = _name;
        owner = msg.sender;
    } 

    // fixed here
    function transferOwernship(address _addr) public auth{
        address owner_;
        assembly{
            owner_ := sload(owner.slot)
        }
        require(_addr!=address(0), "New owner is the zero address");
        require(owner != _addr, "New owner is the same as the old owner");
        
        assembly{
            sstore(owner.slot, _addr)
        }
    }
}