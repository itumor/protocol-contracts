//    _||    __   __    ___      __       ___               ___      ___      ___   __      __
//   (_-<    \ \ / /   / _ \    | |      / _ \     ___     |   \    | _ \    /   \  \ \    / /
//   / _/     \ V /   | (_) |   | |__   | (_) |   |___|    | |) |   |   /    | - |   \ \/\/ /
//   _||__    _|_|_    \___/    |____|   \___/    _____    |___/    |_|_\    |_|_|    \_/\_/
// _|"""""| _| """ | _|"""""| _|"""""| _|"""""| _|     | _|"""""| _|"""""| _|"""""| _|"""""|
// "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-'
//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.5;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The defaut value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}

interface IYoloDivSpotNFT {
    function getLastMintBlock() external view returns (uint);

    function getIdForAccount(address _acc) external view returns (uint);

    function receiveRewards(uint256 _dividendRewards) external;

    function burnToClaim() external;

    function create(address _account, uint256 _minReq) external returns (uint256);

    function getUnclaimed(address _account) external returns (uint256);

    function canMint(address _account) external view returns (bool);

    function getMinReq(uint256 _tokenId) external returns (uint256);

    function getIds() external view returns (uint[] memory);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function totalSupply() external view returns (uint);

    function getOpenDivSpotsCount() external view returns (uint);

    function getDivSpotAt(uint256 _tokenId) external view returns (uint256, uint, address, uint256, uint256);

    function myInfo() external view returns (
        uint rank,
        uint256 rewards,
        uint256 startMinReq,
        uint256 id,
        uint256 mintBlock
    );
}

interface IYoloLoyaltySpotNFT {
    function handleBuy(address _account, uint256 _amountBnb, uint256 _tokenAmount) external;

    function handleSold(address _account) external;

    function claim() external;

    function balanceOf(address owner) external view returns (uint256 balance);

    function totalSupply() external view returns (uint);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function receiveRewards(uint256 _reward) external;

    function myInfoFull() external view returns (
        uint rank, uint level,
        uint possibleClaimAmount, uint blocksLeftToClaim,
        uint buyVolumeBnb, uint sellVolumeBnb, uint lastLevelUpVolume,
        uint claimedRewards
    );

    function getIdForAccount(address _acc) external view returns (uint);

    function getBlocksUntilClaim(address _account) external returns (uint);

    function getRights(uint _tokenId) external view returns (uint, uint, uint);

    function getNextRankRights(uint _tokenId) external view returns (uint, uint, uint);

    function canEvolve(address _account) external returns (bool);

    function getClaimBlock(address _account) external returns (uint);

    function canMint(address _account) external view returns (bool);

    function create(address _account, uint256 _buyVolume, uint _yoloAmount) external returns (uint256 tokenId);

    function getMintPriceBnb() external view returns (uint);

    function getNextMintPriceBnb() external view returns (uint);

    function syncFund() external;
}

interface IURouter {
    function getAmountsIn(uint amountOut, address[] memory path) external view returns (uint256[] memory amounts);

    function getAmountsOut(uint256 amountIn, address[] memory path)
    external
    view
    returns (uint256[] memory amounts);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
}

interface IUFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface ILPLock {
    function setLpToken(address lpTokenAdd) external;
}

interface IKeeper {
    function onReceive(address _account, uint _bnbAmountIn, uint _yoloAmount) external;

    function onTransfer(address _account, uint _yolo) external;

    function withdraw(uint _yoloAmount) external;
}

contract YoloV is ERC20("YoloVerse", "YOLOV"), Ownable {
    uint256 public fomoFund;
    address public U_ROUTER = 0xC2DaefF8Cb77Be50FfC921C9d4bf9AB3a02Ad98D;
    address public U_FACTORY_ADDRESS = 0xA5Ba037Ec16c45f8ae09e013C1849554C01385f5;
    address public constant WBNB_ADDRESS = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    IYoloDivSpotNFT public DivSpotNftContract; // Div = Yolonaut
    IYoloLoyaltySpotNFT public LoyaltyNftContract;
    IKeeper public KeeperContract;

    address[] internal path; // bnb-yoloV
    address[] internal pathToBnb;
    address public FOMOV2_BNB_PAIR; // pair
    address public PORTAL_ADDRESS; // for migration only
    address public LP_GROWER_ADDRESS;
    address public FOMO_ROUTER_ADDRESS; // YoloVerse router

    IURouter internal uRouter = IURouter(U_ROUTER);
    IUFactory internal uFactory = IUFactory(U_FACTORY_ADDRESS);

    /* Tax & Metrics */
    uint internal FOMO_TAX = 400;
    uint internal LP_TAX = 200;

    uint256 public initialMinBnbforDiv = 1e19; // 10.0 BNB
    uint256 internal constant initialMinBnbforLoyalty = 2e17; // 0.2 BNB
    uint public lastLoyaltyMintPriceBnb = 2e17;

    uint internal gasRefund; // for reward distribution [sendDivRewardsToNft]
    uint256 public scaleAmount; // for yolonaut mint price
    uint256 public scaleBasis;
    uint public lpLockFeePercent; // sell tax
    uint public startTimestamp; // for reward phases

    mapping(address => bool) internal excludedBinanceHotWallets;

    uint internal DIV_REW_CD = 28800; // [24hr]
    uint internal LOY_REW_CD = 1200; // [1hr]

    uint public lastDivRewBlock;
    uint public lastLoyRewBlock;

    uint internal defaultGwei = 5e9; // anti-bot mechanics
    uint internal launchPeriodEndBlock;

    event DivDistro(uint reward, uint percent);
    event LoyaltyDistro(uint reward, uint percent);
    event Sold(address _account, uint tokens);
    event Buy(address _account, uint tokens, uint bnb);
    event ReceivedFunds(address _account, uint _tokens);

    constructor() {
        path = [WBNB_ADDRESS, address(this)];
        pathToBnb = [address(this), WBNB_ADDRESS];

        gasRefund = 1e20;

        // Div Mint Price Scaling
        scaleAmount = 3e18;
        // 1m yolov scale basis for Yolonaut mint price
        scaleBasis = 1e24;

        // 6% on SELL only
        lpLockFeePercent = 600;

        //Exclude Those {binance} Hot Wallets
        excludedBinanceHotWallets[0x631Fc1EA2270e98fbD9D92658eCe0F5a269Aa161] = true;
        excludedBinanceHotWallets[0xB1256D6b31E4Ae87DA1D56E5890C66be7f1C038e] = true;
        excludedBinanceHotWallets[0x17B692ae403a8Ff3a3B2eD7676cF194310ddE9Af] = true;
        excludedBinanceHotWallets[0x8fF804cc2143451F454779A40DE386F913dCff20] = true;
        excludedBinanceHotWallets[0xAD9ffffd4573b642959D3B854027735579555Cbc] = true;

        startTimestamp = block.timestamp;

        // Reward Fund
        fomoFund = 2e25;

        lastDivRewBlock = block.number;
        lastLoyRewBlock = block.number;
    }

    /* --------- MODIFIERS --------- */
    uint private unlocked = 1;

    /* Not required, but we left it anyway */
    modifier antiReentrant() {
        require(unlocked == 1, 'ERROR: Anti-Reentrant');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    modifier onlyYoloContracts(){
        require(
            msg.sender == owner()
            || msg.sender == address(DivSpotNftContract)
            || msg.sender == address(LoyaltyNftContract)
            || msg.sender == PORTAL_ADDRESS,
            "Unauthorized !");
        _;
    }

    modifier onlyFomoRouter(){
        require(msg.sender == FOMO_ROUTER_ADDRESS, "Not Fomo Router");
        _;
    }

    /* --------- STATE MIGRATION v1->v2 --------- */

    bool public migrationEnded;

    /* Mints tokens to YOLODRAW holders from snapshot */
    function mintFromSnapshot(address[] calldata _accounts, uint256[] calldata _amounts) external onlyOwner {
        require(!migrationEnded, "Migration has ended !");
        require(_accounts.length == _amounts.length, "Length Mismatch");

        for (uint i = 0; i < _accounts.length; i++) {
            // Mint to each address its tokens.
            if (_accounts[i] != 0xaf61230352bD52Cf9957a2De095B11320c40bD7B) {
                if (_accounts[i] != address(0) && _accounts[i] != 0xF19A0a7bDAbD710fa2C33dF432760c9BEC195011) {
                    super._mint(_accounts[i], _amounts[i]);
                }
            }
        }
    }

    /* Mints Yolonaut NFT to YoloDraw (v1) holders from snapshot */
    function createInitialDivAccounts(address[] calldata _accounts, uint[] calldata _minReqs) external onlyOwner {
        require(!migrationEnded, "Migration has ended !");
        require(_accounts.length == _minReqs.length, "Length Missmatch");

        for (uint i = 0; i < _accounts.length; i++) {
            //Transfer the Yolonaut NFT underlying
            //Users left with surplus YOLOV in wallet
            super._transfer(_accounts[i], address(DivSpotNftContract), _minReqs[i]);
            //Create the Yolonaut NFT
            DivSpotNftContract.create(_accounts[i], _minReqs[i]);
        }
    }

    function mintInitialLPTokens(uint256 _amtOfTokens) external {
        require(!migrationEnded, "Migration has ended !");
        require(msg.sender == PORTAL_ADDRESS, "Only Portal !");
        _mint(msg.sender, _amtOfTokens);

        // Set Max TX Amount, before LP is OPEN!
        launchPeriodEndBlock = block.number + uint(1000);

        // Starting Loyalty Reward Fund Amount 2M tokens
        _mint(address(LoyaltyNftContract), 2e24);
        LoyaltyNftContract.syncFund();
    }

    /* Concludes the migration process */
    function endMigration() external onlyOwner {
        migrationEnded = true;
    }

    /* --------- TRANSFER --------- */
    function _transfer(address _sender, address _to, uint _amount) internal override {
        require(_amount > 10000, "Error: Send More Tokens");

        /* [no-tax] Zone */
        // :: _sender = Loyalty -> when Loyalty sends tokens to Keeper [no-tax]
        // :: Keeper applies normal tax on withdraw()
        if (
            _sender == address(this)
            || _to == address(DivSpotNftContract)
            || _sender == address(DivSpotNftContract)
            || _to == address(LoyaltyNftContract)
            || _sender == address(LoyaltyNftContract)
            || _sender == PORTAL_ADDRESS
            || _sender == LP_GROWER_ADDRESS
            || _to == FOMO_ROUTER_ADDRESS
            || _to == LP_GROWER_ADDRESS
            || excludedBinanceHotWallets[_sender]
            || excludedBinanceHotWallets[_to]
        ) {
            super._transfer(_sender, _to, _amount);
            return;
        }

        /* [no-tax] removeLiquidity */
        if (_sender == FOMOV2_BNB_PAIR && _to == address(uRouter) || _sender == address(U_ROUTER)) {
            super._transfer(_sender, _to, _amount);
            return;
        }

        // Only first 50 minutes after launch
        if (block.number < launchPeriodEndBlock) {
            require(_amount <= uRouter.getAmountsOut(1e18, path)[1], "Max Transaction Amount Reached: Try less");
        }

        if (_to == FOMOV2_BNB_PAIR) {
            /* Sell or AddLiquidity */
            uint autoLockAmt = _amount * lpLockFeePercent / 10000;
            if (autoLockAmt > 0) {
                // Sell tax goes for the LPGrower
                super._transfer(_sender, LP_GROWER_ADDRESS, autoLockAmt);
            }
            // Sell & AddLiq do not increase Loyalty NFT buyVolume
            super._transfer(_sender, _to, (_amount - autoLockAmt));
            emit Sold(_sender, _amount);
        } else {
            /* Buy or Normal transfer */
            (uint fomoTaxDynamic, uint lpTaxDynamic, uint burnRateDynamic) = this.determineFeePhase();
            uint256 fomoTaxAmount = _amount * fomoTaxDynamic / 10000;
            uint256 amtToBurn;
            if (burnRateDynamic > 0) {
                amtToBurn = _amount * burnRateDynamic / 10000;
            }

            // amtToBurn is not 0 only in Phase 2 (rewardFund > 28m)
            super._burn(_sender, amtToBurn + fomoTaxAmount);

            uint amtForLp;
            if (lpTaxDynamic > 0) {
                amtForLp = _amount * lpTaxDynamic / 10000;
                super._transfer(_sender, LP_GROWER_ADDRESS, amtForLp);
            }

            uint finalAmount = _amount - (amtToBurn + fomoTaxAmount + amtForLp);

            fomoFund += fomoTaxAmount;
            super._transfer(_sender, _to, finalAmount);

            /* MAY THE FUN BEGIN */
            /* Loyalty NFT Minting zone*/
            {// avoids-stack-too-deep
                // [only buy]
                if (_sender == FOMOV2_BNB_PAIR) {
                    uint bnbAmountIn = uRouter.getAmountsIn(_amount, path)[0];

                    /* If _to already has Loyalty NFT, increase its buyVolume */
                    if (LoyaltyNftContract.balanceOf(_to) > 0) {
                        LoyaltyNftContract.handleBuy(_to, bnbAmountIn, finalAmount);
                    }

                    emit Buy(_sender, finalAmount, bnbAmountIn);

                    /*
                        [Anti-bot]
                        - requires base gwei
                        - max 1 per block
                     */
                    if (
                        bnbAmountIn >= lastLoyaltyMintPriceBnb
                        && LoyaltyNftContract.canMint(_to)
                        && defaultGwei == tx.gasprice
                    ) {
                        _mintLoyalty(_to, bnbAmountIn, finalAmount);
                    }
                }
            }
        }
    }

    /* = Buy Yolonaut. Can be called by anyone. */
    function mintDivSpot(address _account) external onlyFomoRouter antiReentrant {
        // Returns Yolonaut NFT Mint price in YOLOV
        (uint256 minTokensDiv,) = this.scaleDivNftMintPrice();

        // Check if _account has required YOLOV
        // 1. NFT Balance = 0
        // 2. Supply < 500
        // 3. gwei = bsc default [random tx ordering]
        // 4. Holds Loyalty NFT Rank 0 (Recruit)
        if (
            this.balanceOf(_account) >= minTokensDiv
            && DivSpotNftContract.canMint(_account)
            && defaultGwei == tx.gasprice
        ) {
            _mintDivSpot(_account, minTokensDiv);
        }
    }

    function _mintDivSpot(address _account, uint256 _minReqYolo) internal {
        uint nftId = DivSpotNftContract.create(_account, _minReqYolo);
        if (nftId != 0) {
            super._transfer(_account, address(DivSpotNftContract), _minReqYolo);
        }
    }

    /* Creates NFT.Called on buy (transfer) if nft can be minted. */
    function _mintLoyalty(address _account, uint256 _bnbAmountIn, uint _yoloAmount) internal {
        uint minBnb = LoyaltyNftContract.getMintPriceBnb();

        if (_bnbAmountIn >= minBnb) {
            uint nftId = LoyaltyNftContract.create(_account, _bnbAmountIn, _yoloAmount);
            if (nftId != 0) {
                lastLoyaltyMintPriceBnb = minBnb;
            }
        }
    }

    /* --------- REWARDS --------- */

    /*
        Triggers the distribution of the Yolonaut NFT rewards
        [every 24hrs]
        [can be called by everyone]
     */
    function sendDivRewardsToNft() external onlyFomoRouter antiReentrant {
        //Cooldown requirement
        require(lastDivRewBlock + DIV_REW_CD < block.number, "Not time yet !");

        //Get Yield amount % of total reward fund
        (uint divPercent,) = this.determineFundDistribution();
        uint rewards = fomoFund * divPercent / 10000;

        //Update total reward fund - yield sent [state]
        fomoFund -= rewards;
        lastDivRewBlock = block.number;

        //Transfer Yield Rewards to Yolonaut NFT Contract
        DivSpotNftContract.receiveRewards(rewards);
        _mint(address(DivSpotNftContract), rewards);

        //Mint gas refund to caller
        _mint(msg.sender, gasRefund * 24);

        emit DivDistro(rewards, divPercent);
    }

    /*
        Triggers the distribution of the Loyalty NFT rewards
        [every 24hrs]
        [can be called by everyone]
     */
    function sendLoyaltyRewardsToNft() external onlyFomoRouter antiReentrant {
        //Cooldown requirement
        require(lastLoyRewBlock + LOY_REW_CD < block.number, "Not time yet !");

        //Get Yield amount % of total reward fund
        (,uint loyaltyPercent) = this.determineFundDistribution();
        uint rewards = fomoFund * loyaltyPercent / 10000;

        //Update total reward fund - yield sent [state]
        fomoFund -= rewards;
        lastLoyRewBlock = block.number;

        //Transfer Yield Rewards to Loyalty NFT Contract
        LoyaltyNftContract.receiveRewards(rewards);
        _mint(address(LoyaltyNftContract), rewards);

        //Mint gas refund to caller
        _mint(msg.sender, gasRefund);
        emit LoyaltyDistro(rewards, loyaltyPercent);
    }

    /*
        Increases the total reward fund amount. Called protocol fee distributions.
        @called from: Yolonaut & Loyalty & LpGrowth contracts
    */
    function receiveFunds(uint _amount) external {
        require(
            msg.sender == address(DivSpotNftContract)
            || msg.sender == address(LoyaltyNftContract)
            || msg.sender == LP_GROWER_ADDRESS,
            "Unauthorized !");
        fomoFund += _amount;
        emit ReceivedFunds(msg.sender, _amount);
    }

    /* --------- BURN & MINT --------- */
    function burn(uint256 _amount) external {
        super._burn(msg.sender, _amount);
    }

    /*
        Called ONLY from Yolonaut.
        Triggered by @sendDivRewardsToNft.
        Yolonaut mints a small percent of the rewardAmount / totalSupply = bonusTokens.
    */
    function mint(address _account, uint256 _amount) external {
        require(address(DivSpotNftContract) == msg.sender, "Only the Div can mint !");
        _mint(_account, _amount);
    }

    function _mint(address _account, uint256 _amount) internal override {
        if (_account != PORTAL_ADDRESS) {
            require(_amount < 5e24, "Can't mint that much degen !");
        }
        super._mint(_account, _amount);
    }

    /* --------- GETTERS --------- */
    /*
        Determines the distribution of the total tax of 6%
        Phase 1: Default (rewardFund < 30%) of totalSupply
            -> totalSupply = ~95m (at time of writing)
            -> 30% = ~28m
        Phase 2: rewardFund > 30% (a lot of volume required for this to be triggered)
        @returns (% for): reward(fomo)Fund, lpGrower, burn
    */
    function determineFeePhase() external view returns (uint, uint, uint){
        bool isFundLessThanPercent = fomoFund < this.totalSupply() * 3000 / 10000;

        if (isFundLessThanPercent) {
            return (FOMO_TAX, LP_TAX, 0);
        } else {
            return (200, 0, 400);
        }
    }

    /*
        Determines the % of the total reward sent towards to Yolonaut NFT and Loyalty NFT
        @called from the 2 sendRewards functions (sendDivRewardsToNft, sendLoyaltyRewardsToNft)
        @returns: yolonautPercent, loyaltyPercent (base 10000)
    */
    function determineFundDistribution() public view returns (uint, uint) {
        if (startTimestamp + 10 days > block.timestamp) {
            return (80, 3);
        } else if (startTimestamp + 20 days < block.timestamp) {
            return (90, 4);
        } else if (startTimestamp + 40 days < block.timestamp) {
            return (100, 5);
        } else if (startTimestamp + 60 days < block.timestamp) {
            return (110, 6);
        } else {
            return (120, 7);
        }
    }

    /* Returns the CURRENT Loyalty NFT Mint Price (bnb, yolo) */
    function getLoyaltyMintPrice() external view returns (uint bnb, uint yolo){
        uint mP = LoyaltyNftContract.getMintPriceBnb();
        return (mP, uRouter.getAmountsOut(mP, path)[1]);
    }

    /* Returns the Yolonaut NFT Mint Price (yolo, bnb) */
    function scaleDivNftMintPrice() external view returns (uint256 inTokens, uint256 inBNB) {
        uint256 minInBnb = initialMinBnbforDiv;

        // If DIV Reward Fund is bigger than 10m Tokens
        // +3BNB for each 1m Tokens in Reward Fund
        // ex: fund = 18m --> 8 * 3BNB + basePrice (10bnb) = 34 BNB
        if (fomoFund >= 1e25) {
            uint bonusAmount = (fomoFund - 1e25) * scaleAmount / scaleBasis;
            minInBnb += bonusAmount;
        }
        // base price = 10 BNB
        inTokens = uRouter.getAmountsOut(minInBnb, path)[1];
        return (inTokens, minInBnb);
    }

    /* Returns the NEXT Loyalty NFT Mint Price (yolo) */
    function getNextLoyaltyMintPriceInTokens() external view returns (uint){
        uint minInBnb = LoyaltyNftContract.getNextMintPriceBnb();
        uint inTokens = uRouter.getAmountsIn(minInBnb, pathToBnb)[1];

        return inTokens;
    }

    /* Returns initial mint prices (loyalty, yolonaut) */
    function getMinNftAmounts() external view returns (uint256, uint256) {
        return (uRouter.getAmountsIn(initialMinBnbforLoyalty, path)[1], uRouter.getAmountsIn(initialMinBnbforDiv, path)[1]);
    }

    /* Returns the block for the next Loyalty reward distribution */
    function getNextLoyalBlock() external view returns (uint) {
        return lastLoyRewBlock + LOY_REW_CD;
    }

    /* Returns the block for the next Yolonaut reward distribution */
    function getNextDivBlock() external view returns (uint) {
        return lastDivRewBlock + DIV_REW_CD;
    }

    function getFomoFund1() external view returns (uint256) {
        return fomoFund / 1e18;
    }

    function getPairAddress() external view returns (address) {
        return FOMOV2_BNB_PAIR;
    }

    /* SETTERS */
    function setDefaultGwei(uint _amt) external onlyOwner {
        defaultGwei = _amt;
    }

    /* Sets Buy & Normal Transfer tax (values used only when fomoFund < 25m) */
    function setTax(uint _newFomoTax, uint _newLpTax) external onlyOwner {
        require(_newFomoTax + _newLpTax <= 700, "HardLimits");
        FOMO_TAX = _newFomoTax;
        LP_TAX = _newLpTax;
    }

    function setMinBNBForDiv(uint amt) external onlyOwner {
        // Min 5 BNB ; Max 10 BNB
        require(amt >= 1e18 && amt <= 1e20, "HardLimits");
        initialMinBnbforDiv = amt;
    }

    function setCooldownDiv(uint _newCd) external onlyOwner {
        // 12h - 3d
        require(
            _newCd >= 14400 && _newCd <= 86400,
            "HardLimits"
        );
        DIV_REW_CD = _newCd;
    }

    function setCooldownLoyal(uint _newCd) external onlyOwner {
        // 30m - 4hr
        require(
            _newCd >= 600 && _newCd <= 4800,
            "HardLimits"
        );
        LOY_REW_CD = _newCd;
    }

    function setGasRefund(uint _amount) onlyOwner external {
        require(_amount >= 1e19 && _amount <= 5e22, "HardLimits");
        gasRefund = _amount;
    }

    function setSellTax(uint _lpTax) onlyOwner external {
        require(_lpTax >= 300 && _lpTax <= 1000, "HardLimits");
        lpLockFeePercent = _lpTax;
    }

    /* Setters */
    function setPairAddress(address _addy) external onlyYoloContracts {
        require(_addy != address(0), "Zero address");
        FOMOV2_BNB_PAIR = _addy;
    }

    function setLoyaltyContract(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        LoyaltyNftContract = IYoloLoyaltySpotNFT(_addy);
    }

    function setDivSpotContract(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        DivSpotNftContract = IYoloDivSpotNFT(_addy);
    }

    function setLpGrowerAddress(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        LP_GROWER_ADDRESS = _addy;
    }

    function setPortalAddress(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        PORTAL_ADDRESS = _addy;
    }

    function setKeeperAddress(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        KeeperContract = IKeeper(_addy);
    }

    function setRouterAddress(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero Adress");
        FOMO_ROUTER_ADDRESS = _addy;
    }

    function setUAddrs(address _rAdd, address _facAdd) external onlyOwner {
        U_ROUTER = _rAdd;
        U_FACTORY_ADDRESS = _facAdd;

        uRouter = IURouter(U_ROUTER);
        uFactory = IUFactory(U_FACTORY_ADDRESS);
    }

    fallback() external payable {}

    receive() external payable {}
}
