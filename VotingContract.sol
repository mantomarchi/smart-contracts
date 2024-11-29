// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
        bool executed;
    }

    Proposal[] public proposals ;
    mapping(uint256 => Proposal) proposalId;
    mapping(address => bool) hasVoted;
    event ProposalCreated(uint proposalId);
    event VoteCast(uint proposalId, address voter);

    mapping(address => bool) isAllowed;

    constructor(address[] memory addresses) {
        isAllowed[msg.sender] = true;
        for(uint256 i = 0; i < addresses.length; i++){
            isAllowed[addresses[i]] = true;
        }
    }

    function newProposal(address _target, bytes memory _data) external {
        require(isAllowed[msg.sender]);
        Proposal memory proposal = Proposal({
            target: _target,
            data: _data,
            yesCount: 0,
            noCount: 0,
            executed: false
        });
        proposals.push(proposal);
        proposalId[proposals.length - 1] = proposal;
        emit ProposalCreated(proposals.length - 1);
    }

    function castVote(uint256 _proposalId, bool result) external {
        require(isAllowed[msg.sender]);
        Proposal storage proposal = proposals[_proposalId];
        
        if (!hasVoted[msg.sender]) {
            if (result) {
                proposal.yesCount++;
            } else {
                proposal.noCount++;
            }
            hasVoted[msg.sender] = true;
            
        } else {
            if (hasVoted[msg.sender]) {
                    proposal.yesCount--;
                    proposal.noCount++;
            } else {
                    proposal.yesCount++;
                    proposal.noCount--;
            }
        }
        emit VoteCast(_proposalId, msg.sender);
        if(proposal.yesCount == 10 && !proposal.executed) {
            (bool s, ) = proposal.target.call(proposal.data);
            require(s);
        }
    }    
}