pragma solidity ^0.4.19;


// 导入 ZombieFactory 合约
import "./zombiefactory.sol";

// 定义 CryptoKitties 合约的接口
contract KittyInterface {
    // 定义 getKitty 函数接口
    // 注意这里只需要定义函数签名，不需要具体实现
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );


//     isGestating：布尔值，表示是否正在孕育中
// isReady：布尔值，表示是否准备好
// cooldownIndex：冷却时间索引
// nextActionAt：下一次行动时间
// siringWithId：配对的猫咪ID
// birthTime：出生时间
// matronId：母本ID
// sireId：父本ID
// generation：代数
// genes：基因
}

// 定义 ZombieFeeding 合约，继承自 ZombieFactory
contract ZombieFeeding is ZombieFactory {
    // 只声明变量，不初始化
    KittyInterface kittyContract;

    // 修改修饰符名称为 onlyOwnerOf
    modifier onlyOwnerOf(uint _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }

    // 添加设置 kittyContract 地址的函数
    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    // 添加触发冷却时间的函数
    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + cooldownTime);
    }

    // 添加检查是否已经冷却完成的函数
    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= now);
    }

    // 修改使用的修饰符名称为 onlyOwnerOf
    function feedAndMultiply(uint _zombieId, uint _targetDna, string species) internal onlyOwnerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie));
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        if (keccak256(species) == keccak256("kitty")) {
            newDna = newDna - newDna % 100 + 99;
        }
        _createZombie("NoName", newDna);
        _triggerCooldown(myZombie);
    }

    // 新增 feedOnKitty 函数
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        // 调用 getKitty 函数，忽略前9个返回值，只获取最后一个值(genes)
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        // 调用 feedAndMultiply 函数
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}