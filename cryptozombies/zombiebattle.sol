pragma solidity ^0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
       // 随机数生成器随机值
    uint randNonce = 0;
    // 攻击者胜利的概率
    uint attackVictoryProbability = 70;
    
 
    
    // 内部随机数生成函数
    function randMod(uint _modulus) internal returns(uint) {
        // 增加随机数种子
        randNonce = randNonce.add(1);
        // 生成随机数并返回对_modulus取模的结果
        return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
    }
    
    // 攻击函数
    function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
        // 获取僵尸存储指针
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        
        // 生成0-99之间的随机数
        uint rand = randMod(100);
        
        // 判断战斗结果并更新状态
        if (rand <= attackVictoryProbability) {
            // 我方僵尸胜利
            myZombie.winCount = myZombie.winCount.add(1);
            myZombie.level = myZombie.level.add(1);
            enemyZombie.lossCount = enemyZombie.lossCount.add(1);
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            // 我方僵尸失败
            myZombie.lossCount = myZombie.lossCount.add(1);
            enemyZombie.winCount = enemyZombie.winCount.add(1);
            // 触发冷却时间
            _triggerCooldown(myZombie);
        }
    }
} 