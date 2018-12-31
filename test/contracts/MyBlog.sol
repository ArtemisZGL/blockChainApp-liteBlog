pragma solidity ^0.4.17;

contract MyBlog {
  
  mapping (address => string) nickNames;
  mapping (string => address) registerNames;
  mapping (string => address) deployedContracts;
  uint totalAccounts;
  string []names;

  address admin;
  modifier onlyRegistryAdmin 
  {
    require(msg.sender == admin);
    _;
  }

  function MyBlog() public
  {
    admin = msg.sender;
    totalAccounts = 0;
  }

  function register(string name) public
  {
    address add = msg.sender;
    require(registerNames[name] == address(0));
    require(bytes(nickNames[add]).length == 0);

    nickNames[add] = name;
    registerNames[name] = add;
    totalAccounts++;
    names.push(name);
  }

  function setDeployedAdd(string name, address add) public
  {
    require (msg.sender == registerNames[name]);
    deployedContracts[name] = add;
  }

  //can used by login or someother want to get by others name
  function getDeployedAdd(string name) public constant returns (address contractAdd)
  {
    return deployedContracts[name];
  }

  function getAccountNum() public constant returns (uint _accountNum) 
  {
    return totalAccounts;
  } 

  function getAddByName(string name) public constant returns (address add)
  {
    return registerNames[name];
  }

  function getNameByAdd(address add) public constant returns (string name)
  {
    return nickNames[add];
  }
  
  function randomGetName(uint randNonce) public constant returns (string name)
  {
      uint random = uint(keccak256(now,msg.sender,randNonce))%totalAccounts;
      
      return names[random];
  }
  
}
