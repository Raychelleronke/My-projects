// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./myToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract theBank {
    
    mapping (address => uint) addressBalance;
    uint timeToWithdraw = block.timestamp;
    IERC20 myToken = IERC20(0xd9145CCE52D386f254917e481eB44e9943F39138);
    
    function deposit (uint256 _amount) public {
         myToken.transferFrom (msg.sender, address(this), _amount);
         addressBalance[msg.sender] += _amount;
    }
    
    function withdraw (uint _amount) payable public {
        uint256 charges = 1;
        if (block.timestamp <= timeToWithdraw + 100) {
            require(msg.value == charges, 'You are to pay a fee of 1 wei since you are withdrawing before time');
            myToken.transfer(address(this), msg.value);
        }
        myToken.transfer (msg.sender, _amount);
        addressBalance[msg.sender] -= _amount;
    }
    
    function bankBalance () public view returns(uint256){
        return myToken.balanceOf(address(this));
    }
    
    function individualBalance (address _address) public view returns (uint256) {
        return addressBalance[_address];
    }
    function returnWeiBalance () public view returns(uint){
        return address(this).balance;
    }
}