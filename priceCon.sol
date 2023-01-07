//SPDX-License-Identifier: MIT
pragma solidity 0.8.8; 
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceCon {
    
    function getPrice() internal view returns (uint256){
     //0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada
     AggregatorV3Interface priceFeed = AggregatorV3Interface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);
     (,int price,,,) = priceFeed.latestRoundData();
     return uint256(price *1e10);
    }
    function getVersion() internal view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);
        return priceFeed.version();
      
    }
    function getConversionRate(uint256 maticAmount) internal view returns (uint256){
        uint256 maticPrice = getPrice();
        uint256 maticAmountInUsd = (maticPrice*maticAmount) /1e18;
        return maticAmountInUsd;
    }
}