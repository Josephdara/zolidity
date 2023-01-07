//SPDX-License-Identifier: MIT
pragma solidity 0.8.8; 

import "./PriceCon.sol";
error NotOwner();
contract FundMe{
     using PriceCon for uint256;

        uint256 public constant MINIMUM_FUND = 1 * 1e18;
        address[] public funders;
        mapping (address => uint256) public addressToAmountFunded;
        address public immutable owner;

        constructor(){
          owner =  msg.sender;
        }
   
    function fund() public payable{
        //getConversionRate(msg.value);
        require(msg.value.getConversionRate() >= MINIMUM_FUND, "Not enough Mate!!");
        funders.push(msg.sender);
          addressToAmountFunded[msg.sender] += msg.value;
    }
    
    function withdraw() public onlyOwner{
       // require(msg.sender == owner, "Not the owner")
       for(uint256 fundersID = 0; fundersID < funders.length; fundersID++){
          address funder = funders[fundersID];
          addressToAmountFunded[funder] = 0;
       }
       funders = new address[](0); 
       //1. Transfer method, has a gas limit, if not enough gas transaction fails and reverts
       // //payable(msg.sender).transfer(address(this).balance);
       //2. Send: send does not revert funds if transaction fails so we catch it 
       // //bool sent = payable(msg.sender).send(address(this).balance);
       // //require(sent, "Withdraw failed")
       //3. Call: low level commands
       (bool callSuccess,  ) = payable(msg.sender).call{value: address(this).balance}("");
       require(callSuccess, "Call Failed");


    }
    modifier onlyOwner {
        //require(msg.sender == owner, "Not the owner");
        if(msg.sender != owner){revert NotOwner();}
        _;
    }

    receive() external payable {
        fund();
    }

    fallback()external payable {
        fund();
    }


} 