// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC165} from "../../../solidity之路/FoundryDigger/lib/forge-std/src/interfaces/IERC165.sol";

interface ITokenReceiver{
    function tokensReceived(address operator,address from,uint256 amount, bytes memory data) external returns(bool);
}

contract BaseERC20 is IERC165{

    string public name;
    string public symbol;
    uint8 public decimals;

    uint256 public totalSupply;

    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        // write your code here
        // set name,symbol,decimals,totalSupply
        name = "BaseERC20";
        symbol = "BERC20";
        decimals = 18;
        totalSupply = 100000000 ether;
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        // write your code here
        balance = balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        // write your code here
        require(balances[msg.sender] >= _value, "ERC20: transfer amount exceeds balance");

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // write your code here
        require(balances[_from] >= _value, "ERC20: transfer amount exceeds balance");
        require(allowances[_from][msg.sender] >= _value, "ERC20: transfer amount exceeds allowance");

        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        // write your code here
        require(_spender != address(0));

        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        // write your code here
        return allowances[_owner][_spender];
    }

    // 带钩子函数的转账
    function transferWithCallback(address _to,uint _amount, bytes memory data) public returns(bool){
        bool success;
        success = transfer(_to, _amount);
        require(success, "failed to transfer token");
        if(!isContract(_to)){
            // 不是合约地址则直接返回真，表示普通转账
            return true;
        }
        // 若为合约地址，转账后调用其tokensReceived()方法
        success = ITokenReceiver(_to).tokensReceived(address(this),msg.sender,_amount,data);
        require(success, "failed to call tokensReceived()");
        return true;
    }

    function isContract(address _addr) internal view returns(bool){
        return _addr.code.length != 0;
    }

}