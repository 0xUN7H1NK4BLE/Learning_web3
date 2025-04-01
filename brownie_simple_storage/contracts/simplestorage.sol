// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
contract SimpleStorage{
    uint256 favourateNumber; 
    struct people{
        uint256 favourateNumber;
        string name;
            }
    // people public person = people({favourateNumber:2, name:"tester"});
    people[] public People;
    mapping(string => uint256) public nameTOfav;
    function store(uint256 _favourateNumber) public {
        favourateNumber = _favourateNumber;

    }
    function retrive() public view returns(uint256){
        return favourateNumber;
    }
    function addperson(string memory _name, uint256 _favourateNumber ) public {
        People.push(people(_favourateNumber,_name));
        nameTOfav[_name]=_favourateNumber;
    } 
    
}

