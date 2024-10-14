// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {IBank} from "./IBank.sol";
import {BaseERC20} from "./ERC20.sol";

contract TokenBank is IBank {
    address owner;
    struct User{
        BaseERC20[] assets; // erc20 list
        mapping(address=>uint) balancesOf; // amount of specific erc20 asset
    }
    mapping(address=>User) users;

    constructor(){
        owner = msg.sender;
    }

    receive () external payable{}

    function deposit(address tokenAddr, uint amount) public payable{
        // call erc20
        // check allowance
        require(amount>0,"amount is empty");
        bool success;
        BaseERC20 token = BaseERC20(tokenAddr); // 以后记得使用接口

        // transferFrom msg.sender to bank
        success = token.transferFrom(payable(msg.sender),payable(address(this)),amount);
        require(success, "failed to call transferFrom");
        // update user info
        bool isExistInAssets;
        for(uint i=0;i<users[msg.sender].assets.length;i++){
            if(isExistInAssets){
                isExistInAssets = true;
                break;
            }
        }
        if(!isExistInAssets){
            users[msg.sender].assets.push(token);
        }

        users[msg.sender].balancesOf[address(token)] += amount;
    }

    function withdraw(address tokenAddr, uint amount) public payable{
        BaseERC20 token = BaseERC20(tokenAddr);
        uint availAmount = users[msg.sender].balancesOf[address(token)];
        require(availAmount >= amount, "available amount is not enough");
        token.transfer(msg.sender,amount);
        users[msg.sender].balancesOf[tokenAddr] -= 1;
    }

    function getBalancesOfMsgSender(address tokenAddr) public view returns(uint){
        return users[msg.sender].balancesOf[tokenAddr];
    }
}
