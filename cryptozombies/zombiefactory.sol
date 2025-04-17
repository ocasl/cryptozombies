pragma solidity ^0.4.19;

// 导入 Ownable 合约
import "./ownable.sol";

// 定义一个名为 ZombieFactory 的智能合约
contract ZombieFactory is Ownable {

    // 添加冷却时间常量
    uint cooldownTime = 1 days;

    // 定义一个事件，当新僵尸被创建时触发，包含僵尸ID、名字和DNA
    event NewZombie(uint zombieId, string name, uint dna);

    // 定义DNA位数为16位
    uint dnaDigits = 16;
    // 计算DNA的模数：10^16，用于限制DNA的长度
    uint dnaModulus = 10 ** dnaDigits;

    // 定义僵尸结构体，包含名字、DNA、level、readyTime、winCount和lossCount
    struct Zombie {
        string name;
        uint dna;
        uint32 level;    // 使用 uint32 来节省 gas
        uint32 readyTime; // 使用 uint32 来节省 gas
        uint16 winCount;    // 添加胜利次数统计
        uint16 lossCount;   // 添加失败次数统计
    }

    // 创建一个公共的僵尸数组，存储所有创建的僵尸
    Zombie[] public zombies;

    // 映射：通过僵尸ID查找其主人的地址
    mapping (uint => address) public zombieToOwner;
    // 映射：记录每个地址拥有的僵尸数量
    mapping (address => uint) ownerZombieCount;

    // 内部函数：创建新僵尸
    function _createZombie(string _name, uint _dna) internal {
        // 将新僵尸添加到数组并获取其ID
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;  // 添加冷却时间   uint32转化时间
        // 记录这个僵尸属于msg.sender（调用者）  
        zombieToOwner[id] = msg.sender;
        // 增加调用者拥有的僵尸数量
        ownerZombieCount[msg.sender]++;
        // 触发新僵尸创建事件
        NewZombie(id, _name, _dna);
    }

    // 私有函数：根据字符串生成随机DNA
    function _generateRandomDna(string _str) private view returns (uint) {
        // 使用keccak256哈希函数生成随机数
        uint rand = uint(keccak256(_str));
        // 确保DNA符合指定位数
        return rand % dnaModulus;
    }

    // 公共函数：创建随机僵尸
    function createRandomZombie(string _name) public {
        // 要求调用者还没有僵尸
        require(ownerZombieCount[msg.sender] == 0);
        // 生成随机DNA
        uint randDna = _generateRandomDna(_name);
        // 创建新僵尸
        randDna = randDna - randDna % 100;

        _createZombie(_name, randDna);
    }
}