// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IBank {
    function deposit(address tokenAddr, uint amount) external payable;
    function withdraw(address tokenAddr, uint amount) external payable;
}
