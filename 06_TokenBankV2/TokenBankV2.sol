// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


import "./IERC20.sol";
import "./TokenBank.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "./ITokenReceiver.sol";
import "hardhat/console.sol";

contract TokenBankV2 is TokenBank,ITokenReceiver {
    // 定义TokenReceiver的接口id
    bytes4 private constant tokenReceiverInterfaceId = type(ITokenReceiver).interfaceId;

    constructor() {
    }
    // 代币转账到合约后触发该函数，使得合约能够记账。省去了用户 approve 和 deposit 的操作
    function tokensReceived(address, address from, uint value, bytes calldata) public returns(bool){
        // 注意限定token协议
        // 通过调用发送者地址的方法，检查接口id是否已经注册
        require(IERC165(msg.sender).supportsInterface(tokenReceiverInterfaceId) ,"not expected token");
        //(address token) = abi.decode(data,(address));
        updateUserInfo(from, IERC20(msg.sender), value);
        return true;
    }
}