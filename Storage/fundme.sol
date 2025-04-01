// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <=0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract Fundme {
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    constructor() public{
        owner = msg.sender;
    }
    function fund() public payable{
        addressToAmountFunded[msg.sender] += msg.value;
        // what the eth to usd conversion rate is 
        uint256 miniumUSD = 50 * 10 ** 18;
        require(getConversionrate(msg.value)>= miniumUSD, "you need to spend more eth");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    
    }
    function getVersion() public view returns(uint256){
        AggregatorV3Interface pricehed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return pricehed.version();
    }
    function getPrice() public view returns (uint256){
        AggregatorV3Interface pricehed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = pricehed.latestRoundData();
        return uint256(answer);
    }

    function getConversionrate(uint256 ethAmount) public view returns (uint256){
    uint256 ethPrice = getPrice();
    uint256 ethAmountInUsd = (ethPrice* ethAmount)/10000000000000000;
    return ethAmountInUsd;

    }

    modifier onlyowner{
        require(owner == msg.sender,"only the owner of this contract can do that action");
        _;
    }
    function withdraw() payable onlyowner public {
        msg.sender.transfer(address(this).balance);
        for (uint256 fundersIndex=0; fundersIndex < funders.length ; fundersIndex++){
            address funder = funders[fundersIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}
