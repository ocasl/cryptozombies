pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";
import "./safemath.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

  using SafeMath for uint256;
  
  // 添加授权映射
  mapping (uint => address) zombieApprovals;

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    // 返回 _owner 拥有的僵尸数量
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    // 返回 _tokenId 僵尸的所有者地址
    return zombieToOwner[_tokenId];
  }

  // 添加_transfer私有函数
  function _transfer(address _from, address _to, uint256 _tokenId) private {
    // 增加接收者的僵尸数量
    ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
    // 减少发送者的僵尸数量
    ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
    // 更新僵尸的所有权映射
    zombieToOwner[_tokenId] = _to;
    // 触发Transfer事件
    Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _to;
    Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint256 _tokenId) public {
    // 检查调用者是否被授权提取该僵尸
    require(zombieApprovals[_tokenId] == msg.sender);
    // 获取僵尸当前所有者
    address owner = ownerOf(_tokenId);
    // 执行转移操作
    _transfer(owner, msg.sender, _tokenId);
  }
}
