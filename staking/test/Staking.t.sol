// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import "../src/Staking.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract StakingTest is Test {
    Staking staking;
    MockERC20 stakingToken;
    MockERC20 rewardToken;
    address owner = address(0x123);
    address user1 = address(0x456);
    address user2 = address(0x789);

    function setUp() public {
        // Deploy mock tokens
        stakingToken = new MockERC20("Staking Token", "STK");
        rewardToken = new MockERC20("Reward Token", "RWD");

        // Mint tokens to users
        stakingToken.mint(user1, 1e18);
        stakingToken.mint(user2, 1e18);
        rewardToken.mint(address(this), 1e18);

        // Deploy staking contract
        Staking.ContractAddress memory addresses = Staking.ContractAddress({
            rewardAddress: address(rewardToken),
            referralAddress: address(this), // Set referral if needed
            stakingToken: address(stakingToken)
        });

        Staking.Fees memory fees = Staking.Fees({
            fee: 100, // 1% fee (in basis points)
            referralFee: 50 // 0.5% referral fee (in basis points)
        });

        staking = new Staking(
            addresses,
            "Test Staking",
            block.timestamp + 1,
            block.timestamp + 1000,
            fees,
            1e18, // Supply
            1e14, // Min tokens (0.1 STK)
            1e15, // Max tokens (1 STK)
            5e17 // Max tokens per staker (0.5 STK)
        );

        vm.startPrank(owner);
        rewardToken.approve(address(staking), type(uint256).max);
        vm.stopPrank();
    }

    function testStake() public {
        vm.startPrank(user1);
        stakingToken.approve(address(staking), 1e18);

        skip(300);

        uint256 amountToStake = 1e14; // 0.1 STK

        staking.stake(amountToStake);

        (uint256 stakedAmount,,,,,,) = staking.userInfo(user1);
        assertEq(stakedAmount, 0);

        uint256 fee = staking.fee();

        uint256 fees = amountToStake * (fee) / (10000);

        assertEq(staking.totalSupply(), amountToStake - fees);

        vm.stopPrank();
    }

    // function testWithdraw() public {
    //     vm.startPrank(user1);
    //     stakingToken.approve(address(staking), 1e18);

    //     uint256 amountToStake = 5e17; // 0.5 STK
    //     staking.stake(amountToStake);

    //     staking.withdraw(amountToStake);

    //     (uint256 stakedAmount,,,,,,) = staking.userInfo(user1);

    //     assertEq(stakedAmount, 0);
    //     assertEq(staking.totalSupply(), 0);

    //     vm.stopPrank();
    // }

    // function testClaimRewards() public {
    //     vm.startPrank(user1);
    //     stakingToken.approve(address(staking), 1e18);

    //     uint256 amountToStake = 5e17; // 0.5 STK
    //     staking.stake(amountToStake);

    //     // Simulate time passing
    //     vm.warp(block.timestamp + 500);
    //     staking.claim();

    //     uint256 reward = rewardToken.balanceOf(user1);
    //     assertGt(reward, 0);

    //     vm.stopPrank();
    // }

    // function testEmergencyWithdraw() public {
    //     vm.startPrank(user1);
    //     stakingToken.approve(address(staking), 1e18);

    //     uint256 amountToStake = 5e17; // 0.5 STK
    //     staking.stake(amountToStake);

    //     staking.emergencyWithdraw(amountToStake);

    //     (uint256 stakedAmount,,,,,,) = staking.userInfo(user1);

    //     assertEq(stakedAmount, 0);
    //     assertEq(staking.totalSupply(), 0);

    //     vm.stopPrank();
    // }
}
