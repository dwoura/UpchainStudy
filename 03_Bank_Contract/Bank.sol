// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address public owner;

    mapping(address => uint) public balances;
    uint[] public top_three_Balances;
    address[] public top_three_Users;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can do this");
        _;
    }

    function updateTop3(address user, uint userBalance) internal {
        for (uint i=0;i<top_three_Users.length; i++) {
            if (top_three_Users[i] == user) {
                top_three_Balances[i] = userBalance;
                sortTop3();
                return;
            }
        }

        if (top_three_Users.length<3) {
            top_three_Users.push(user);
            top_three_Balances.push(userBalance);
            sortTop3();
        } else if (userBalance>top_three_Balances[2]) {
            top_three_Users[2] = user;
            top_three_Balances[2] = userBalance;
            sortTop3();
        }
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;

        updateTop3(msg.sender, balances[msg.sender]);
    }

    function withdraw(uint amount) external onlyOwner {
        require(amount <= address(this).balance, "no enough balance");
        payable(owner).transfer(amount);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }


    function sortTop3() internal {
        for (uint i = 0; i < top_three_Users.length; i++) {
            for (uint j = i + 1; j < top_three_Users.length; j++) {
                if (top_three_Balances[i] < top_three_Balances[j]) {
                    (top_three_Balances[i], top_three_Balances[j]) = (top_three_Balances[j], top_three_Balances[i]);
                    (top_three_Users[i], top_three_Users[j]) = (top_three_Users[j], top_three_Users[i]);
                }
            }
        }
    }
}