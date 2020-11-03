// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC20Token is ERC20, Ownable {

    mapping(address => bool) whitelist;

    modifier isInWhitelist() {
        require(whitelist[msg.sender] == true, "is not in the whitelist");
        _;
    }

    constructor() ERC20("My ERC20 Token", "MET")  public {
        
    }

    function addToWhitelist(address account) onlyOwner public {
        whitelist[account] = true;
    }

    function removeFromWhitelist(address account) onlyOwner public {
        whitelist[account] = false;
    }

    function mint(address account, uint256 amount) isInWhitelist public {
        _mint(account, amount);
    }

}
