// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

interface IBank {
    function deposit() external payable;
    function withdraw() external payable;
}
