// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


import "./IBank.sol";

contract Admin{
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier OnlyOwner{
        require(owner==msg.sender,"only owner can do this");
        _;
    }

    function adminWithdraw(IBank bank) public payable OnlyOwner {

        bank.withdraw(address(bank).balance);
    }

    receive() external payable { }
}
