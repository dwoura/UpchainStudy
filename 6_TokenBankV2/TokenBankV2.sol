// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


import "./IERC20.sol";
import "./TokenBank.sol";

contract TokenBankV2 is TokenBank {
    // 代币转账到合约后触发该函数，使得合约能够记账
    function tokensReceived(address from, address token, uint amount) public returns(bool){
        updateUserInfo(from, IERC20(token), amount);
        return true;
    }
}