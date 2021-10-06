// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract toVote {
    struct Candidate {
        string name;
        string party;
        uint votecount;
        uint id;
    }
    uint id = 0;
    address government;
    
    mapping (address => bool) isAdmin;
    mapping (address => bool) hasVoted;
    
    constructor() {
        government = msg.sender;
        isAdmin[msg.sender] = true;
    }
    
    modifier onlyGovernment {
        require (msg.sender == government, "only government can add an admin");
        _;
    }
    
    modifier onlyAdmin {
        require (isAdmin[msg.sender] == true , "only an admin can add candidates");
        _;
    }
    
    function addAmin (address _admin) public onlyGovernment {
        isAdmin[_admin] = true;
    }

    Candidate[] candidates;
    function addCandidate (string memory _name, string memory _party) public onlyAdmin {
        id++;
        candidates.push(Candidate(_name, _party, 0, id));
    }
    
    function voteHere (uint256 _candidateId) public {
        require (id >= _candidateId, "that id does not exist");
        require (hasVoted[msg.sender] == false, "you can only vote once");
        candidates[_candidateId - 1].votecount++;
        hasVoted[msg.sender] = true;
    }
    
    function returnCandidates() public view returns(Candidate[] memory) {
        return candidates;
    }
    
}