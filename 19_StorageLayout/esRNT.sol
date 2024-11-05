// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
contract esRNT {
    // 声明不占用插槽，只有实例化才会
    struct LockInfo{
        address user; // 20字节
        uint64 startTime; // 64字节
        uint256 amount; // 256字节
    }
    LockInfo[] private _locks; // slot0：存储_locks 长度， 数组元素keccak256(0) + i * 2
    // 动态数组通过计算基址来确定：所在插槽存储长度， 数组元素存储在 keccak256(数组slot号) + i * 2(i 为数组索引)，
    // 若为结构体，其余第n个元素顺序存储在 keccak256(数组slot号) + i * 2 + n 中。

    constructor() { 
        for (uint256 i = 0; i < 11; i++) {
            _locks.push(LockInfo(address(uint160(i+1)), uint64(block.timestamp*2-i), 1e18*(i+1)));
        }
    }
}

// Deployer: 0xEe44CF3ad948F4edD816E26582b7d6cB910e0901
// Deployed to: 0x32Ef65Ed2004247C6dF7234E7AebCe512560F65b
// Transaction hash: 0xf77d2738c5aec6a41f2fc7c60ab683dc4b5c8bd5a330e6bc9eb5b15fd3710c3f