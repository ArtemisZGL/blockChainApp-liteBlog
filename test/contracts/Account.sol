pragma solidity ^0.4.17;

contract Account {
  struct Blog
  {
    string context;
    uint publishTime;
    uint likeNum;
    uint dislikeNum;
    bool _private;
  }

  mapping (uint => Blog) blogs;
  uint blogNum;
  address owner;
  string[] targets;
  
  modifier onlyOwner
  {
    require(msg.sender == owner);
    _;
  }

  function Account() public
  {
    blogNum = 0;
    owner = msg.sender;
  }

  function publish (string context, bool _private) public onlyOwner
  {
    require(bytes(context).length <= 100);

    blogs[blogNum].publishTime = now;
    blogs[blogNum].context = context;
    blogs[blogNum].likeNum = 0;
    blogs[blogNum].dislikeNum = 0;
    //default is public
    blogs[blogNum]._private = _private; 
    blogNum++;
  }
  
  function deleteBlog(uint blogId) public onlyOwner
  {
      blogs[blogId].context = "@deleteBlog";
  }

  function like (uint blogId) public 
  {
    require(blogId < blogNum);
    blogs[blogId].likeNum++;
  }

  function dislike (uint blogId) public
  {
    require(blogId < blogNum);
    blogs[blogId].dislikeNum++;
  }

  function getBlog (uint blogId) public constant returns (string context, uint publishTime, uint likeNum, uint dislikeNum)
  {
    require(blogId < blogNum);

    if(blogs[blogId]._private)
      require(msg.sender == owner);

    context = blogs[blogId].context;
    publishTime = blogs[blogId].publishTime;
    likeNum = blogs[blogId].likeNum;
    dislikeNum = blogs[blogId].dislikeNum;
  }

  function getBlogNum() public constant returns (uint _blogNum) 
  {
    return blogNum;
  } 
  
  function follow(string name) public
  {
      targets.push(name);
  }
  
  function nofollow(string name) public
  {
        uint index = 0;
        for(uint i =0; i < targets.length; i++)
        {
            string memory  t = targets[i];
            if(keccak256(t) == keccak256(name))
            {
                index = i;
                break;
            }
        }
        
        for(uint j = index; j < targets.length - 1; j++)
        {
            targets[j] = targets[j + 1];
        }
        
        delete targets[targets.length - 1];
        targets.length--;
  }

    function isFollow(string name) public constant returns(bool isf)
    {
        for(uint i =0; i < targets.length; i++)
        {
            string memory  t = targets[i];
            if(keccak256(t) == keccak256(name))
                return true;
        }
        return false;
    }
  
  function getRandomTargetName(uint randNonce) public constant returns (string targetname)
  {
      uint random = uint(keccak256(now,msg.sender,randNonce))%targets.length;
      
      return targets[random];
  }
}
