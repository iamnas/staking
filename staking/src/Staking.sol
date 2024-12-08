// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface ITRC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function allowance(address owner, address spender) external view returns (uint256);
}

interface IReferral {
    function hasReferrer(address addr) external view returns (bool);

    function addReferrer(address payable referrer) external returns (bool);
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return payable(address(uint160(account)));
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-block.timestamp/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success,) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(ITRC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(ITRC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(ITRC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(ITRC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(ITRC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(ITRC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        //        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor() {}
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this;
        // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Staking is Ownable {
    using SafeMath for uint256;
    using SafeMath for uint256;
    using SafeERC20 for ITRC20;

    // Info of each user.
    struct UserInfo {
        uint256 addressIndex; // How many LP tokens the user has provided.
        uint256 amount; // How many LP tokens the user has provided.
        uint256 lastRewardPaidAt; // Last Reward Paid At
        uint256 rewardReceived; // Total Reward Received
        uint256 totalClaimed; // Total Amount Claimed
        uint256 refReward; // Referral Reward Received
        uint256 totalRefReward; // Referral Reward Received
    }

    struct ContractAddress {
        address rewardAddress;
        address referralAddress;
        address stakingToken;
    }

    struct Fees {
        uint256 fee;
        uint256 referralFee;
    }

    // Info of pool.
    address public stakingToken; // Address of LP token contract, required.
    string public name; // Name of the pool, required.
    uint256 public startAt; // Staking Starts at, required.
    uint256 public endAt; // Staking ends at, required.
    uint256 public lockEndsAt = 0; // Lock in period in seconds, default 0.
    bool public shouldLock = false; // Should use the lock period, default false.
    uint256 public fee; // Fee for staking, required.
    uint256 public referralFee; // Fee for staking, required.
    uint256 public supply; // Available supply, required.
    uint256 public maxStakers = 0; // Max number of stakers set 0 to disable, default 0.
    uint256 public minTokens; // Min amount of tokens to stake, default 0.
    uint256 public maxTokens; // Max amount of tokens to stake, default 0, 0 disabled.
    uint256 public maxTokensPerStaker; // Max amount of tokens to stake, default 0, 0 disabled.

    mapping(address => UserInfo) public userInfo;
    address[] public stakes;

    event Staked(address indexed token, address indexed staker_, uint256 requestedAmount_, uint256 stakedAmount_);
    event UnStaked(address indexed token, address indexed staker_, uint256 requestedAmount_, uint256 stakedAmount_);
    event PaidOut(address indexed token, address indexed rewardToken, address indexed staker_, uint256 reward_);
    event ReferralPayOut(address indexed token, address indexed rewardToken, address indexed staker_, uint256 reward_);

    address public rewardAddress;
    address public referral;

    uint256 public stakedTotal = 0;
    uint256 public totalReward = 0;
    uint256 public totalClaimed = 0;
    uint256 public totalStakers = 0;

    uint256 public totalFee = 0;
    uint256 public feeClaimed = 0;

    uint256 public lastUpdateTime = 0;
    uint256 public rewardRate = 0;
    uint256 public rewardsDuration;
    uint256 public rewardPerTokenStored;

    constructor(
        // address _rewardAddress,
        // address _referralAddress,
        // address _stakingToken,
        ContractAddress memory _contractAddress,
        string memory _name,
        uint256 _startAt,
        uint256 _endAt,
        Fees memory _fees,
        // uint _fee,
        // uint _referralFee,
        uint256 _supply,
        uint256 _minTokens,
        uint256 _maxTokens,
        uint256 _maxTokensPerStaker
    ) {
        require(_contractAddress.stakingToken != address(0), "Staking Token Invalid");
        require(_contractAddress.rewardAddress != address(0), "Reward Token Invalid");
        require(_contractAddress.referralAddress != address(0), "Referral Token Invalid");
        require(_startAt >= block.timestamp, "Staking Invalid Start Date");
        require(_endAt > _startAt, "Staking Invalid End Date");
        if (_minTokens > 0) {
            require(_maxTokens >= _minTokens, "Staking Invalid Max Tokens");
        }
        if (_maxTokens > 0) {
            require(_maxTokensPerStaker >= _maxTokens, "Staking Invalid Max Per Satker");
        }

        rewardAddress = _contractAddress.rewardAddress;
        referral = _contractAddress.referralAddress;
        stakingToken = _contractAddress.stakingToken;
        name = _name;
        startAt = _startAt;
        endAt = _endAt;
        rewardsDuration = endAt - startAt;
        fee = _fees.fee;
        referralFee = _fees.referralFee;
        supply = _supply;
        minTokens = _minTokens;
        maxTokens = _maxTokens;
        maxTokensPerStaker = _maxTokensPerStaker;

        lastUpdateTime = block.timestamp;
        rewardRate = (supply) / (endAt - startAt);
    }
    /* ========== VIEWS ========== */

    function currentTime() external view returns (uint256) {
        return block.timestamp;
    }

    function totalSupply() external view returns (uint256) {
        return stakedTotal;
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return block.timestamp < endAt ? block.timestamp : endAt;
    }

    function rewardPerToken() public view returns (uint256) {
        if (stakedTotal == 0) {
            return rewardPerTokenStored;
        }
        return rewardPerTokenStored.add(
            lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(stakedTotal)
        );
    }

    function earned(address account) public view returns (uint256) {
        uint256 lastRewardPaidAt = userInfo[account].lastRewardPaidAt;
        uint256 amount = userInfo[account].amount;
        uint256 reward = userInfo[account].rewardReceived;
        return amount.mul(rewardPerToken().sub(lastRewardPaidAt)).div(1e18).add(reward);
    }

    function getRewardForDuration() external view returns (uint256) {
        return rewardRate.mul(rewardsDuration);
    }

    function enableLockInPeriod(uint256 _lockEndsAt, bool _shouldLock)
        public
        onlyOwner
        _before(startAt)
        returns (bool)
    {
        if (_shouldLock == true) {
            require(_lockEndsAt > 0, "Staking Invalid Locking Period");
            require(_lockEndsAt > startAt, "Staking Invalid Locking Period");
            require(_lockEndsAt >= endAt, "Staking Invalid Locking Period");
        }
        lockEndsAt = _lockEndsAt;
        shouldLock = _shouldLock;
        return true;
    }

    function changeStartAt(uint256 _startAt) public onlyOwner _before(startAt) returns (bool) {
        require(_startAt >= block.timestamp, "Staking Invalid Start Date");
        require(endAt > _startAt, "Staking Invalid End Date");
        startAt = _startAt;
        return true;
    }

    function setMaxStakers(uint256 _maxStakers) public onlyOwner returns (bool) {
        maxStakers = _maxStakers;
        return true;
    }

    function stakeOf(address account) public view returns (uint256) {
        return userInfo[account].amount;
    }

    function stake(uint256 amount) public _positive(amount) _realAddress(msg.sender) returns (bool) {
        return _stake(msg.sender, amount);
    }

    function withdraw(uint256 amount)
        public
        _after(startAt)
        _positive(amount)
        _realAddress(msg.sender)
        _updateReward(msg.sender)
        returns (bool)
    {
        address from = msg.sender;
        claim();
        require(amount <= userInfo[from].amount, "Not enough balance");
        if (shouldLock) {
            require(lockEndsAt < block.timestamp, "Funds frozen");
        }
        userInfo[from].amount = userInfo[from].amount.sub(amount);
        stakedTotal = stakedTotal.sub(amount);
        _payDirect(from, amount, stakingToken);
        return true;
    }

    function emergencyWithdraw(uint256 amount)
        public
        _after(startAt)
        _positive(amount)
        _realAddress(msg.sender)
        returns (bool)
    {
        address from = msg.sender;
        require(amount <= userInfo[from].amount, "Not enough balance");
        if (shouldLock) {
            require(lockEndsAt < block.timestamp, "Funds frozen");
        }
        userInfo[from].amount = userInfo[from].amount.sub(amount);
        stakedTotal = stakedTotal.sub(amount);
        _payDirect(from, amount, stakingToken);
        return true;
    }

    function claim() public _updateReward(msg.sender) returns (bool) {
        claimRefReward();
        address from = msg.sender;
        uint256 reward = userInfo[from].rewardReceived;
        if (reward > 0) {
            IReferral ref = IReferral(referral);
            if (ref.hasReferrer(from)) {
                (bool success, bytes memory returndata) =
                    referral.call(abi.encodeWithSignature("accounts(address)", from));
                if (success) {
                    (address referrer,,) = abi.decode(returndata, (address, uint256, uint256));
                    uint256 refReward = reward.mul(referralFee).div(10000);
                    if (refReward > 0) {
                        userInfo[referrer].refReward = userInfo[referrer].refReward.add(refReward);
                        if (!stakeExits(referrer)) {
                            userInfo[referrer].addressIndex = stakes.length;
                            stakes.push(referrer);
                        }
                    }
                }
            }
            totalReward = totalReward.add(reward);
            _payDirect(from, reward, rewardAddress);
            userInfo[from].rewardReceived = 0;
            userInfo[from].totalClaimed = userInfo[from].totalClaimed.add(reward);
            emit PaidOut(stakingToken, rewardAddress, from, reward);
            return true;
        }
        return false;
    }

    function claimRefReward() public returns (bool) {
        address from = msg.sender;
        uint256 reward = userInfo[from].refReward;
        if (reward > 0) {
            userInfo[from].refReward = 0;
            userInfo[from].totalRefReward = userInfo[from].totalRefReward.add(reward);
            _payDirect(from, reward, rewardAddress);
            emit ReferralPayOut(stakingToken, rewardAddress, from, reward);
            return true;
        }
        return false;
    }

    function claimFee() public onlyOwner returns (bool) {
        address from = msg.sender;
        uint256 reward = totalFee.sub(feeClaimed);
        if (reward > 0) {
            feeClaimed = feeClaimed.add(reward);
            _payDirect(from, reward, stakingToken);
            return true;
        }
        return false;
    }

    function stakeExits(address from) public view returns (bool) {
        if (stakes.length == 0) return false;
        return stakes[userInfo[from].addressIndex] == from;
    }

    function poolInfo()
        public
        view
        returns (address, address, address, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
    {
        return
            (stakingToken, rewardAddress, referral, fee, referralFee, startAt, endAt, rewardRate, stakedTotal, supply);
    }

    function poolInfo(address account)
        public
        view
        returns (
            address,
            address,
            address,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        uint256 earning = earned(account);
        uint256 stakedTokens = stakeOf(account);
        return (
            stakingToken,
            rewardAddress,
            referral,
            fee,
            referralFee,
            startAt,
            endAt,
            rewardRate,
            stakedTotal,
            supply,
            stakedTokens,
            earning
        );
    }

    function getRewardAmount(uint256 amount, address token) public onlyOwner {
        _payDirect(msg.sender, amount, token);
    }

    function _stake(address staker, uint256 amount)
        private
        _after(startAt)
        _before(endAt)
        _positive(amount)
        _updateReward(staker)
        returns (bool)
    {
        if (maxStakers > 0 && totalStakers != 0 && !stakeExits(staker)) {
            require((totalStakers) < maxStakers, "Max Stakers Reached");
        }
        // check the remaining amount to be staked
        uint256 remaining = amount;
        if (minTokens > 0) {
            require(remaining >= minTokens, "Min Amount Not Satisfied");
        }
        if (maxTokens > 0) {
            require(remaining <= maxTokens, "Max Amount Not Satisfied");
        }
        if (maxTokensPerStaker > 0) {
            require((remaining + userInfo[staker].amount) <= maxTokensPerStaker, "Max Amount Per Staker Not Satisfied");
        }
        // These requires are not necessary, because it will never happen, but won't hurt to double check
        // this is because stakedTotal and stakedBalance are only modified in this method during the staking period
        require(remaining > 0, "Zero amount");
        uint256 fees = remaining.mul(fee).div(10000);
        totalFee = totalFee.add(fees);
        require(remaining.sub(fees) > 0, "No amount left after deducting fees");
        if (!_payMe(staker, remaining, stakingToken)) {
            return false;
        }
        // Transfer is completed
        remaining = remaining.sub(fees);
        stakedTotal = stakedTotal.add(remaining);
        userInfo[staker].amount = userInfo[staker].amount.add(remaining);
        if (!stakeExits(staker)) {
            userInfo[staker].addressIndex = stakes.length;
            stakes.push(staker);
            totalStakers = totalStakers.add(1);
        }
        emit Staked(stakingToken, staker, amount, remaining);
        return true;
    }

    function _payMe(address payer, uint256 amount, address token) private returns (bool) {
        return _payTo(payer, address(this), amount, token);
    }

    function _payTo(address allower, address receiver, uint256 amount, address token) private returns (bool) {
        // Request to transfer amount from the contract to receiver.
        // contract does not own the funds, so the allower must have added allowance to the contract
        // Allower is the original owner.
        ITRC20 trc20 = ITRC20(token);
        trc20.safeTransferFrom(allower, receiver, amount);
        return true;
    }

    function _payDirect(address to, uint256 amount, address token) private returns (bool) {
        if (amount == 0) {
            return true;
        }
        ITRC20 trc20 = ITRC20(token);
        trc20.safeTransfer(to, amount);
        return true;
    }

    /* ========== MODIFIERS ========== */

    modifier _updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();
        if (account != address(0)) {
            userInfo[account].rewardReceived = earned(account);
            userInfo[account].lastRewardPaidAt = rewardPerTokenStored;
        }
        _;
    }

    modifier _realAddress(address addr) {
        require(addr != address(0), "zero address");
        _;
    }

    modifier _positive(uint256 amount) {
        require(amount >= 0, "negative amount");
        _;
    }

    modifier _after(uint256 eventTime) {
        require(block.timestamp >= eventTime, "_after: bad timing for the request");
        _;
    }

    modifier _before(uint256 eventTime) {
        require(block.timestamp < eventTime, "_before: bad timing for the request");
        _;
    }
}
