// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/MyContract.sol";

contract DeployMyContract is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new MyContract("Hello, Lisk!");  // Deploy the contract with an initial greeting

        vm.stopBroadcast();
    }
}
