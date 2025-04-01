// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract Fundme {
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    AggregatorV3Interface public priceFeed;
    constructor(address _priceFeed) public{
        priceFeed = AggregatorV3Interface(_priceFeed);
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

    function getEntranceFee() public view returns (uint256){
        // minimum usd
        uint256 miniumUSD = 50 * 10 ** 18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10 ** 18;
        return (miniumUSD * precision) / price;
    }

    function getVersion() public view returns(uint256){
        return priceFeed.version();
    }
    function getPrice() public view returns (uint256){
        (,int256 answer,,,) = priceFeed.latestRoundData();
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
