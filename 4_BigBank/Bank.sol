// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IBank.sol";

contract Bank is IBank{
    address public owner;
    mapping(address=>uint256) balances;
    address[] public top_3;

    error WithdrawFailed();

    constructor(){
        owner = msg.sender;
    }

    modifier OnlyOwner{
        require(owner==msg.sender,"only owner can do this");
        _;
    }

    function getTopThreeDepositor() public view returns(address[] memory){
        return top_3;
    }

    function deposit() public payable virtual {
        require(msg.value>0,"deposit value must be greater than 0");
        balances[msg.sender]+=msg.value;
        //更新top3
        updateTopThree();
    }


    function updateTopThree() public{
        //前三个直接 push，但不能push 重复的地址
        if(top_3.length<3){
            bool isExist = false;
            for(uint i=0;i<top_3.length;i++){
                if(top_3[i]==msg.sender){
                    isExist = true;
                    break;
                }
            }
            //不存在则新增进top3
            if(!isExist){
                top_3.push(msg.sender);
                //排序
                sort_top3();
                return;
            }
            //若已存在则往下运行
        }

        //比较尾数组，若替换则排序
        if(balances[msg.sender]>balances[top_3[top_3.length-1]]){
            top_3[top_3.length-1]=msg.sender;
            sort_top3();
        }
    }

    function sort_top3() internal{
        for(uint i=0;i<top_3.length;i++){
            for(uint j=i+1;j<top_3.length;j++){
                if(balances[top_3[j]]>balances[top_3[i]]){
                    (top_3[i],top_3[j])=(top_3[j],top_3[i]);
                }
            }
        }
    }

    function withdraw(uint256 amount) public payable OnlyOwner  {
        require(amount * 1 ether<= address(this).balance,"no enough value");
        (bool success,)=msg.sender.call{value:amount*1 ether}("");
        if(!success){
            revert WithdrawFailed();
        }
    }

    receive() external payable{
        deposit();
    }
}
