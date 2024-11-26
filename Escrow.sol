// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Escrow {
    address public depositor;
    address public beneficiary;
    address public arbiter;

    event Approved(uint256);

    constructor(address _arbiter, address _beneficiary) payable {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;
    }

    function approve() external payable {
        require(msg.sender == arbiter);
        (bool s, ) = beneficiary.call{ value: address(this).balance}("");
        require(s);
        emit Approved(beneficiary.balance);
    }
}