///writed by willian in 03/09/2022

pragma solidity >=0.5.0 ^0.8.0;

import "Allowance.sol";

contract SharedWallet is Allowance {

    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount, string operator);
      
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "No funds in smart contract");
        if(owner() != _to ){
            reduceAllowance(_to, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() public view onlyOwner() override {
        revert("Cant renouce ownership here");
    }
        
    fallback () external payable {
        emit MoneyReceived(msg.sender, msg.value, "fallback");
    }
    
    receive () external payable {
        emit MoneyReceived(msg.sender, msg.value, "receive");
    }
}