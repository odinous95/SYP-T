// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Lira is ERC20 {
    constructor(uint256 intialSupply) ERC20("Lira", "LIRA") {
        _mint(msg.sender, intialSupply);
    }
    // Additional functions can be added here if needed
    // For example, you might want to add functions for minting, burning, etc.
}
