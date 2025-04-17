pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    // 返回 _owner 拥有的僵尸数量
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    // 返回 _tokenId 僵尸的所有者地址
    return zombieToOwner[_tokenId];
  }

  function transfer(address _to, uint256 _tokenId) public {

  }

  function approve(address _to, uint256 _tokenId) public {

  }

  function takeOwnership(uint256 _tokenId) public {

  }
}
