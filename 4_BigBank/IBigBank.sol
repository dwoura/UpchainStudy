// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBank {
    function deposit() external payable;
    function withdraw() external payable;
    function getTopThreeDepositor() public view returns(address[] memory);
}
