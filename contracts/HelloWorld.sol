// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorld {
    string private message;

    constructor() {
        message = "Hello World";
    }

    // 获取消息
    function getMessage() public view returns (string memory) {
        return message;
    }

    // 设置新消息
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }
} 