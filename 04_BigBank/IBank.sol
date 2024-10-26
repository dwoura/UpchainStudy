// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IBank {
    function deposit() external payable;
    function withdraw(uint256 amount) external payable;
}
