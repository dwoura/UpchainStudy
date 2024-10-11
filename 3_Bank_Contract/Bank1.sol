// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract Bank{
    address payable public owner;

    struct depositor{
        address addr;
        uint amount;
    }

    mapping(address=>depositor) map_depositors;
    address[] public top_three;

    constructor(){
        owner = payable(msg.sender);
    }

    modifier OnlyOwner{
        require(msg.sender == owner,"only owner can do this.");
        _;
    }


    function deposit() external payable {
        map_depositors[msg.sender].amount+=msg.value;

        if(top_three.length<3){
            top_three.push(msg.sender);
        }else{
            uint index = minValueIndexOfTopThree();
            for(uint i=0; i<top_three.length-1; i++){

                if(msg.value > map_depositors[top_three[index]].amount){

                    map_depositors[top_three[index]].amount=msg.value;
                }
            }
        }

    }

    function isExistInTopThree() internal view returns(bool){
        for(uint i=0;i<top_three.length-1;i++){
            if(top_three[i]==msg.sender){
                return true;
            }
        }
        return false;
    }

    function minValueIndexOfTopThree() public view returns (uint) {
        uint minIndex = 0;
        uint minValue = map_depositors[top_three[0]].amount;

        for (uint i = 0; i < top_three.length-1; i++) {
            if (map_depositors[top_three[i]].amount < minValue) {
                minValue = map_depositors[top_three[i]].amount;
                minIndex = i;
            }
        }

        return minIndex;
    }

    function withdraw(uint amount) external OnlyOwner{
        require(amount * 1 ether <= address(this).balance, "out of balance");
        (bool success, )=msg.sender.call{value: amount * 1 ether}("");
        require(success, "fail to send eth");
    }

}