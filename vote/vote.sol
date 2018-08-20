pragma solidity ^0.4.18;

contract voteContract {

    mapping (address = bool) voters; 
    mapping (string = uint) candidates; 
    mapping (uint8 = string) candidateList; 

    uint8 numberOfCandidates; 
    address contractOwner;
    
    function voteContract() public {
        contractOwner = msg.sender;
    }
    
       
    function addCandidate(string cand) public {
        bool add = true;
        for (uint8 i = 0; i  numberOfCandidates; i++) {
            if(keccak256(candidateList[i]) == keccak256(cand)){
                add = false; break;
            }
            if(add) {
                candidateList[numberOfCandidates] = cand;
                numberOfCandidates++;
        }
    }
    
    function vote(string cand) public {
        if(voters[msg.sender]) { 
            
        }
        
        else{
            voters[msg.sender] = true;
            candidates[cand]++;
        }
    }
    
        
    function alreadyVoted() public constant returns(bool) {
        if(voters[msg.sender])
            return true;
        else
            return false;
    }
    
        
    function getNumOfCandidates() public constant returns(uint8) {
        return numberOfCandidates;
    }
    
       
    function getCandidateString(uint8 number) public  constant returns(string) {
        return candidateList[number];
    }
    
      
    function getScore(string cand) public constant returns(uint) {
        return candidates[cand];
    }
    
        
    function killContract() public  {
        if(contractOwner == msg.sender)
            selfdestruct(contractOwner);
        }
    }
    
    
    