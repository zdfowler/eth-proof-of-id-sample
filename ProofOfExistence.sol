// Created for proof of concept examples.
pragma solidity ^0.4.21;

// Proof of Existence contract, modified
contract ProofOfExistenceZDF {
  // store mapping of collected proofs
  // a proof is a sha256 of a "document" (string) and the sender's address
  mapping (bytes32 => bool) private proofs;
  
  address public owner;
  
  function constructor() public {
      owner = msg.sender;
  }
      
  // store a proof of existence in the contract state
  function storeProof(bytes32 proof) internal  {
    proofs[proof] = true;
  }
  
  // Only let the owner of the contract notarize!
  // this makes this a centralized, not decentralized, system
  modifier onlyOwner {
        if (msg.sender != owner) revert() ;
        _;
  }
    
  // calculate and store the proof for a document
  function notarize(string document) public {
    bytes32 proof = proofFor(document);
    storeProof(proof);
  }
  // helper function to get a document's sha256
  // use the sender's address to combine document string, to show per-person proofs.
  function proofFor(string document) internal view returns (bytes32) {
      // This can be modified to add salting or other document IDs 
    return sha256(document, msg.sender);
  }
  // check if a document has been notarized
  function checkDocument(string document) public view returns (bool) {
    bytes32 proof = proofFor(document);
    return hasProof(proof);
  }
  // returns true if proof is stored
  function hasProof(bytes32 proof) internal constant returns(bool) {
    return proofs[proof];
  }
}
