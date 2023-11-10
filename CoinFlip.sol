// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlip {
    address public owner;
    uint256 public betAmount = 1 ether;

    event CoinFlipped(bool isHeads, int256 result);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function flipCoin() external payable {
        require(msg.value == betAmount, "Incorrect bet amount. Please send 1 ether.");

        bool isHeads = getRandom() % 2 == 0;

        if (isHeads) {
            // User wins, send them 2 ether (1 ether profit)
            payable(msg.sender).transfer(2 ether);
            emit CoinFlipped(true, 1);
        } else {
            // User loses, contract keeps the 1 ether
            emit CoinFlipped(false, -1);
        }
    }

    function getRandom() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 100;
    }

    // Owner-only function to withdraw funds from the contract
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
