// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


import "./Bank.sol";
import "./IBank.sol";

contract BigBank is Bank{
    modifier LowestValue{
        require(msg.value>= 0.001 ether,"deposit value must be greater than 0.001e");
        _;
    }

    //重写增加了LowestValue修饰器
    function deposit() public payable override LowestValue{
        super.deposit();
    }

    function transferOwnership(address addr) external OnlyOwner {
        require(msg.sender==owner,"can't transfer to address which is owner");
        owner = addr;
    }
}
