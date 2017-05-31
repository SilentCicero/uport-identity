pragma solidity ^0.4.8;
import "./Proxy.sol";

contract IdentityManager {
  event IdentityCreated(
    address indexed identity,
    address indexed creator,
    address owner,
    address indexed recoveryKey);

  event OwnerAdded(
    address indexed identity,
    address indexed owner,
    address instigator);

  event OwnerRemoved(
    address indexed identity,
    address indexed owner,
    address instigator);

  event RecoveryChanged(
    address indexed identity,
    address indexed recoveryKey,
    address instigator);

  mapping(address => mapping(address => uint)) owners;
  mapping(address => address) recoveryKeys;
  mapping(address => uint) nonces;

  modifier onlyOwner(address identity) { 
    if (owners[identity][msg.sender] > 0 && (owners[identity][msg.sender] + 1 hours) <= now ) _ ;
    else throw; 
  }

  modifier onlyOlderOwner(address identity) { 
    if (owners[identity][msg.sender] > 0 && (owners[identity][msg.sender] + 1 days) <= now) _ ;
    else throw;
  }

  modifier onlyRecovery(address identity) { 
    if (recoveryKeys[identity] == msg.sender) _ ;
    else throw;
  }

  // Factory function
  // gas 289,311
  function CreateIdentity(address owner, address recoveryKey) {
    Proxy identity = new Proxy();
    owners[identity][owner] = now - 1 days; // This is to ensure original owner has full power from day one
    recoveryKeys[identity] = recoveryKey;
    IdentityCreated(identity, msg.sender, owner,  recoveryKey);
  }

  function forwardTo(Proxy identity, address destination, uint value, bytes data) onlyOwner(identity) {
    identity.forward(destination, value, data);
  }

  function metaTxForwardTo(uint8 sigV, bytes32 sigR, bytes32 sigS, Proxy identity, address destination, uint value, bytes data) {

    uint nonce = nonces[identity];
    bytes32 h = sha3(this, 'forwardTo', nonce, identity, destination, value, data);
    address addressFromSig = ecrecover(h,sigV,sigR,sigS);

    if (owners[identity][addressFromSig] > 0) {
      nonces[identity]++;
      identity.forward(destination, value, data);
    }
  }

  // an owner can add a new device instantly
  function addOwner(Proxy identity, address newOwner) onlyOlderOwner(identity) {
    owners[identity][newOwner] = now;
    OwnerAdded(identity, newOwner, msg.sender);
  }

  // an owner can add a new device instantly
  function metaTxAddOwner(uint8 sigV, bytes32 sigR, bytes32 sigS, Proxy identity, address newOwner) {

    uint nonce = nonces[identity];
    bytes32 h = sha3(this, 'addOwner', nonce, identity, newOwner);
    address addressFromSig = ecrecover(h,sigV,sigR,sigS);

    if (owners[identity][addressFromSig] > 0 && (owners[identity][addressFromSig] + 1 days) <= now) {

      nonces[identity]++;
      owners[identity][newOwner] = now;
      OwnerAdded(identity, newOwner, addressFromSig);
    }
  }

  // a recovery key owner can add a new device with 1 days wait time
  function addOwnerForRecovery(Proxy identity, address newOwner) onlyRecovery(identity) {
    if (owners[identity][newOwner] > 0) throw;
    owners[identity][newOwner] = now + 1 days;
    OwnerAdded(identity, newOwner, msg.sender);
  }

  function metaTxAddOwnerForRecovery(uint8 sigV, bytes32 sigR, bytes32 sigS, Proxy identity, address newOwner) {

    uint nonce = nonces[identity];
    bytes32 h = sha3(this, 'addOwnerForRecovery', nonce, identity, newOwner);
    address addressFromSig = ecrecover(h,sigV,sigR,sigS);

    if (owners[identity][newOwner] > 0) throw;

    if (recoveryKeys[identity] == addressFromSig) {
      nonces[identity]++;
      owners[identity][newOwner] = now + 1 days;
      OwnerAdded(identity, newOwner, addressFromSig);
    }
  }

  // an owner can remove another owner instantly
  function removeOwner(Proxy identity, address owner) onlyOlderOwner(identity) {
    owners[identity][owner] = 0;
    OwnerRemoved(identity, owner, msg.sender);
  }

  function metaTxRemoveOwner(uint8 sigV, bytes32 sigR, bytes32 sigS, Proxy identity, address owner) {

    uint nonce = nonces[identity];
    bytes32 h = sha3(this, 'removeOwner', nonce, identity, owner);
    address addressFromSig = ecrecover(h,sigV,sigR,sigS);

    if (owners[identity][addressFromSig] > 0 && (owners[identity][addressFromSig] + 1 days) <= now) {
      
      nonces[identity]++;
      owners[identity][owner] = 0;
      OwnerRemoved(identity, owner, msg.sender);
    }
  }

  // an owner can add change the recoverykey whenever they want to
  function changeRecovery(Proxy identity, address recoveryKey) onlyOlderOwner(identity) {
    recoveryKeys[identity] = recoveryKey;
    RecoveryChanged(identity, recoveryKey, msg.sender);
  }

  function metaTxChangeRecovery(uint8 sigV, bytes32 sigR, bytes32 sigS, Proxy identity, address recoveryKey) {

    uint nonce = nonces[identity];
    bytes32 h = sha3(this, 'changeRecovery', nonce, recoveryKey);
    address addressFromSig = ecrecover(h,sigV,sigR,sigS);

    if (owners[identity][msg.sender] > 0 && (owners[identity][msg.sender] + 1 days) <= now) {
      nonces[identity]++;
      recoveryKeys[identity] = recoveryKey;
      RecoveryChanged(identity, recoveryKey, msg.sender);
    }
  }
}
