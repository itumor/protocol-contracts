//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.5;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
      * @dev Safely transfers `tokenId` token from `from` to `to`.
      *
      * Requirements:
      *
      * - `from` cannot be the zero address.
      * - `to` cannot be the zero address.
      * - `tokenId` token must exist and be owned by `from`.
      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
      *
      * Emits a {Transfer} event.
      */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

interface IERC721Metadata is IERC721 {

    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

library Address {

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {size := extcodesize(account)}
        return size > 0;
    }
}

library Strings {
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}

abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IERC721).interfaceId
        || interfaceId == type(IERC721Metadata).interfaceId
        || super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0
        ? string(abi.encodePacked(baseURI, tokenId.toString()))
        : '';
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }


    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }


    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }


    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
    private returns (bool)
    {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    // solhint-disable-next-line no-inline-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
}


abstract contract ERC721URIStorage is ERC721 {
    using Strings for uint256;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }


    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);

        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}

interface IUFactory {
    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);
}

interface IYoloV {
    function burn(uint256 _amount) external;

    function receiveFunds(uint _amount) external;

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IKeeper {
    function deposit(uint _yoloAmount, uint _loyalId) external;
}

interface IArtifact {
    function create(address _account, uint _loyaltyId) external;
}

interface IURouter {

    function getAmountsIn(uint amountOut, address[] memory path) external view returns (uint256[] memory amounts);

    function getAmountsOut(uint256 amountIn, address[] memory path)
    external
    view
    returns (uint256[] memory amounts);
}

contract LoyaltyNft is ERC721URIStorage {
    uint256 public tokenCounter;
    IYoloV public YoloV;
    IKeeper public KeeperContract;
    IArtifact public ArtifactContract;

    address public DIV_NFT_ADDRESS;
    address public MARKETPLACE_ADDRESS;

    address public U_ROUTER = 0xC2DaefF8Cb77Be50FfC921C9d4bf9AB3a02Ad98D;
    address public U_FACTORY_ADDRESS = 0xA5Ba037Ec16c45f8ae09e013C1849554C01385f5;
    address public constant WBNB_ADDRESS = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    IURouter internal uRouter = IURouter(U_ROUTER);
    IUFactory internal uFactory = IUFactory(U_FACTORY_ADDRESS);

    uint internal constant MAX_SPOTS = 3000; // [Max Minted Ever] => burn = lock

    address public LP_GROWER_ADDRESS;
    uint256 public rewardFund;

    enum Rank{RECRUIT, ADJUTANT, PRIESTESS, SPECTRE, ANDROID, MATRIX, SINGULARITY, NIRVANA}

    struct LoyaltyInfo {
        uint256 id;
        address owner;
        Rank rank;
        uint level;
        address minter;
        uint256 buyVolume; // in BNB
        uint256 lastBlockClaimed;
        uint256 claimedRewards;

        uint256 lastSpeedUpVolume;
        uint256 buyVolumeInTokens;
    }

    /* Each Rank Has Certain Rights */
    struct Rights {
        uint giveawayWeight;
        uint feeReduction;
        string uri;
        uint minLevel;
    }
    /* Mappings */
    mapping(uint256 => LoyaltyInfo) public loyaltySpots;
    mapping(address => uint256) public accountToId;
    mapping(Rank => Rights) public rToR;

    uint internal lastMintBlock;

    /* Burn = send to pair = lock */
    uint[] public burnedIds;
    uint public burnIndex;

    /* when buying YoloV people are reducing their claim time. However 1 day is the under which the cooldown cant' fall. */
    uint public MIN_CLAIM_BLOCKS = 28800;
    uint internal constant CLAIM_COOLDOWN = 86400; // [72h]
    uint internal constant LEVELS = 10000; // used for ranks.
    uint internal constant LEVEL_UP_AMOUNT = 3e15; // = 1 level
    uint internal constant REDUCTION_PER_LEVEL = 9; // claim cooldown reduction
    uint public mintPriceBnb = 2e17; // startPrice

    uint public claimFee = 9000; // base (90%). Each rank has fee reduction.
    uint public EXACT_GAS_CLAIM = 5e9;

    // Tax Distribution
    uint public FOR_FOMO_FUND = 4000;
    uint public FOR_LP = 5000;
    uint public FOR_BURN = 1000;

    // All NFTs Rank 1 and above
    uint public rewardElligibleCount;

    // Singularities And Nirvana
    uint public sings;
    uint public constant MAX_SINGS = 12;

    uint public NIRVANA_VOLUME = 5e20;
    uint public constant SING_VOLUME = 2e20;

    uint public nirvanaId;
    uint[12] public singIds;

    /* Nirvana Contest */
    uint public currentTopId;
    uint public nirvConEBlock; // contest endBlock
    uint public nirvConDur = 604800; // duration [21 days]
    bool public nirv; // nirvanaActive

    event TheNirvanaWasBorn(uint _tokenId, address _account, uint volumeBnb);
    event SingCreated(uint _tokenId, address _account);

    event TheNirvanaDied(uint _tokenId, address _account);
    event SingDestroyed(uint _tokenId, address _account);

    event FeeAmountWasTooLow();
    event SpeededUpClaimTime(uint _tokenId, uint _blocks);

    event NFTMinted(address _to, uint256 _tokenId);
    event ReceivedRewards(uint256 _rewardsAdded, uint256 _newTotal);

    //Evolution
    event EvolvedRarityArt(address _from, uint256 _tokenId, uint256 blockNr, Rank _fromRank, Rank _toRank);
    event SpeededRarityEvolution(address _from, uint _tokenId, uint blocksSpeeded, uint amountSpent);
    event Evolved(address _account, uint _tokenId, bool _rankedUp, uint _newRank);
    event Devolved(address _account, uint _tokenId, uint _newRank);

    address deployer;
    constructor (address _yoloV2Addr) ERC721("YoloVerseLoyaltyNFT", "LoyaltyNFT"){
        tokenCounter = 0;
        rewardFund = 0;
        deployer = msg.sender;

        YoloV = IYoloV(_yoloV2Addr);

        /* NORMAL RANKS */
        rToR[Rank.RECRUIT] = Rights({giveawayWeight : 0, feeReduction : 0, minLevel : 0, uri : "https://gateway.pinata.cloud/ipfs/QmWBnuy48Ba7NvMAMkDMoVZFzVoREXgRt23K8cgqiwE1vB"});
        rToR[Rank.ADJUTANT] = Rights({giveawayWeight : 0, feeReduction : 0, minLevel : 800, uri : "https://gateway.pinata.cloud/ipfs/QmWPZegt5kYHHfQAFnXa7rtaptpqBqLfNb7ZsShhfgLMAo"});
        rToR[Rank.PRIESTESS] = Rights({giveawayWeight : 0, feeReduction : 1000, minLevel : 2000, uri : "https://gateway.pinata.cloud/ipfs/QmaEzJeeb5FgmkyFnMv7jFVjBcTTzhkHLxgrwvoV9YpGEb"});
        rToR[Rank.SPECTRE] = Rights({giveawayWeight : 1, feeReduction : 2500, minLevel : 4000, uri : "https://gateway.pinata.cloud/ipfs/QmdKzZ4D296krTFEfXCqcGHJPcNN4xg315f6XZ8LX86nKR"});
        rToR[Rank.ANDROID] = Rights({giveawayWeight : 2, feeReduction : 4500, minLevel : 7000, uri : "https://gateway.pinata.cloud/ipfs/Qma5ZAhNUiRdUp5UWcMegqMnrW6dP4LWLmBA2NXKpYGiQE"});
        rToR[Rank.MATRIX] = Rights({giveawayWeight : 3, feeReduction : 7000, minLevel : 9600, uri : "https://gateway.pinata.cloud/ipfs/QmXduZt6jJ9T7xCjDhMG8U5qMzuB3o7gfCGpEN2gd2ba4d"});

        /* SPECIAL RANKS */
        // 4% of Total Max Voting Power ( 0.3 % Each )
        rToR[Rank.SINGULARITY] = Rights({giveawayWeight : 20, feeReduction : 8500, minLevel : LEVELS, uri : "https://gateway.pinata.cloud/ipfs/QmTuujhiYJtYTBf1xtQK3cfYgVRTrToyjNGmV5wC3pi6QS"});
        // 5% of Total Max Voting Power
        rToR[Rank.NIRVANA] = Rights({giveawayWeight : 50, feeReduction : 9500, minLevel : LEVELS, uri : "https://gateway.pinata.cloud/ipfs/QmP1H1KyP8cmN16Wm54UNfTvE4MqTkkCLAQS3H5m3nPYhM"});
        // 7days
        nirvConEBlock = block.number + nirvConDur;
    }

    /* --------- MODIFIERS --------- */
    modifier onlyOwner() {
        require(deployer == msg.sender, "UnAuth");
        _;
    }

    modifier onlyNftHolders() {
        require(this.balanceOf(msg.sender) == 1 && accountToId[msg.sender] != 0, "No NFT !");
        _;
    }

    modifier onlyYolo() {
        require(msg.sender == address(YoloV), "UnAuth");
        _;
    }

    modifier onlyKeeper() {
        require(msg.sender == address(KeeperContract), "UnAuth");
        _;
    }

    modifier onlyLPGrowerAndYolo() {
        require(msg.sender == address(LP_GROWER_ADDRESS) || msg.sender == address(YoloV), "UnAuth");
        _;
    }

    /* we wanted to be extra safe */
    uint private unlocked = 1;
    modifier antiReentrant() {
        require(unlocked == 1, 'ERROR: Anti-Reentrant');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    /* --------- NFT Mint --------- */

    /*
        Creation [entry point].
        Called by YoloV on buy (transfer). mint = buy YoloV
    */
    function create(address _account, uint256 _buyVolumeBnb, uint256 _inTokens) external onlyYolo returns (uint256 tokenId){
        if (this.canMint(_account)) {
            return _createBuyerLoyaltyNFT(_account, _buyVolumeBnb, _inTokens);
        }
        return 0;
    }

    /*
        Creation [actual]. (internal)
        @params _buyAmount : bnb sold (getAmountsIn in YoloV transfer)
        @params _inTokens : yoloV bought.
     */
    function _createBuyerLoyaltyNFT(address _account, uint256 _buyAmount, uint256 _inTokens) internal returns (uint256) {
        uint256 newItemId = tokenCounter + 1;
        // Level Up to initial buy amount. (bnb based)
        uint level = _buyAmount / LEVEL_UP_AMOUNT;

        LoyaltyInfo memory nftInfo = LoyaltyInfo({
        id : newItemId,
        owner : _account,
        rank : Rank.RECRUIT,
        level : level,
        minter : _account,
        buyVolume : _buyAmount,
        lastBlockClaimed : block.number,
        claimedRewards : 0,
        lastSpeedUpVolume : 0,
        buyVolumeInTokens : _inTokens
        });

        loyaltySpots[newItemId] = nftInfo;
        accountToId[_account] = newItemId;
        tokenCounter++;
        // Increase mint price.
        mintPriceBnb = getNextMintPriceBnb();
        // 1 per block (@canMint)
        lastMintBlock = block.number;

        super._safeMint(_account, newItemId);
        super._setTokenURI(newItemId, rToR[Rank.RECRUIT].uri);
        /*
            Try-create Artifact if @newItemId matches artifact number.
        */
        ArtifactContract.create(_account, newItemId);

        emit NFTMinted(_account, newItemId);

        return newItemId;
    }

    /*
        1. Computes THE rank to evolve to by checking the level.
            * ex: currentRank = 0; level = 9600; ==> Can evolve to Matrix ONLY (can never become Android)
        2. Send YoloV to Keeper If both the [level] and the [tokens inside the wallet] are enough

        * Max Rank: Matrix (@royalEvolve for higher)
        * Requires approval of YoloV tokens for this contract from msg.sender.
    */
    function evolve() external onlyNftHolders antiReentrant returns (bool _success, uint _newRank){
        LoyaltyInfo memory nftInfo = loyaltySpots[accountToId[msg.sender]];

        if (nftInfo.rank == Rank.MATRIX) {
            return (false, uint(Rank.MATRIX));
        }

        // Compute THE rank to evolve to based on nft level
        (bool success, uint newRankNumber) = getPotentialRank(nftInfo.level, uint(nftInfo.rank));

        if (!success) {
            return (false, uint(nftInfo.rank));
        }

        // The required tokens to hold (they will be send to Keeper).
        uint evolveTokensRequired = this.getTokensRequiredForEvolve(uint(nftInfo.rank), newRankNumber);

        // Check if sender has enough tokens for the Keeper
        if (YoloV.balanceOf(msg.sender) < evolveTokensRequired) {
            return (false, uint(nftInfo.rank));
        }

        // State Updates.
        Rank newRank = Rank(newRankNumber);
        loyaltySpots[nftInfo.id].rank = newRank;
        super._setTokenURI(nftInfo.id, rToR[newRank].uri);

        // Increase the reward elligibility (rank1+) count
        if (nftInfo.rank == Rank.RECRUIT) {
            rewardElligibleCount++;
        }

        // Requires Approval of at least _evolveTokensRequired from nft owner to Loyalty
        KeeperContract.deposit(evolveTokensRequired, nftInfo.id);
        YoloV.transferFrom(nftInfo.owner, address(this), evolveTokensRequired);
        YoloV.transfer(address(KeeperContract), evolveTokensRequired);

        emit Evolved(msg.sender, nftInfo.id, success, newRankNumber);
        return (true, newRankNumber);
    }

    /* Returns the YoloV tokens required to be held in wallet upon calling @evolve (they will be sent to Keeper) */
    function getTokensRequiredForEvolve(uint _currentRankNumber, uint _newRankNumber) public view returns (uint tokensRequired){
        require(_currentRankNumber < _newRankNumber, "new rank must be more");
        address[] memory path = new address[](2);
        path[0] = WBNB_ADDRESS;
        path[1] = address(YoloV);
        //How much bnb
        uint evolveBnbRequired = (rToR[Rank(_newRankNumber)].minLevel
        - rToR[Rank(_currentRankNumber)].minLevel
        ) * LEVEL_UP_AMOUNT;
        //On spot estimation of YOLOV for buyVolume BNB amount per rank requirement
        uint evolveTokensRequired = uRouter.getAmountsOut(evolveBnbRequired, path)[1];

        return evolveTokensRequired;
    }

    /* Returns the potential rank based on level */
    function getPotentialRank(uint level, uint currentRank) public view returns (bool success, uint newRank){
        uint rankedUp = 0;
        uint nextRankNumber = currentRank + 1;

        Rights memory nextRights;

        for (uint r = nextRankNumber; r <= uint(Rank.MATRIX); r++) {
            nextRights = rToR[Rank(r)];

            // Check if has enough Level
            if (level >= nextRights.minLevel) {
                rankedUp++;
            } else {
                break;
            }
        }

        if (rankedUp == 0) {
            return (false, currentRank);
        }

        return (true, currentRank + rankedUp);
    }

    /*
        Evolve to Singularity OR Nirvana
        1. Checks if requirements for Nirvana or Sing are met.
        2. Deposits tokens to Keeper.

        * requires approval of YOLOV to this contract
    */
    function royalEvolve() external onlyNftHolders antiReentrant {
        bool royalCourtComplete = sings == MAX_SINGS && nirv;
        require(!royalCourtComplete, "Royal Court already complete !");

        LoyaltyInfo memory nftInfo = loyaltySpots[accountToId[msg.sender]];
        require(nftInfo.rank == Rank.RECRUIT, "Must be Recruit !");

        /* NIRVANA */
        (bool wonContest, bool enoughTokens, uint tokensRequired) = canBeNirvana(accountToId[msg.sender]);
        if (wonContest && enoughTokens) {
            KeeperContract.deposit(tokensRequired, nftInfo.id);

            // Requires Approval of at least currentTopBuyVolumeInTokens from nftInfoOwner
            // Tax evasion
            YoloV.transferFrom(nftInfo.owner, address(this), tokensRequired);
            YoloV.transfer(address(KeeperContract), tokensRequired);

            onNirvanaBorn(nftInfo.id);
            return;
        }

        /* SINGULARITY */
        (bool enoughVolume, bool enoughTokensSing, uint tokensRequiredSing) = canBeSing(accountToId[msg.sender]);
        if (enoughVolume && enoughTokensSing) {
            KeeperContract.deposit(tokensRequiredSing, nftInfo.id);

            // Requires Approval of at least  nftInfo.buyVolumeInTokens from nftInfo.Owner
            YoloV.transferFrom(nftInfo.owner, address(this), tokensRequiredSing);
            YoloV.transfer(address(KeeperContract), tokensRequiredSing);

            loyaltySpots[nftInfo.id].rank = Rank.SINGULARITY;
            super._setTokenURI(nftInfo.id, rToR[Rank.SINGULARITY].uri);

            uint count = MAX_SINGS;
            for (uint i = 0; i < count; i++) {
                if (singIds[i] == 0) {
                    singIds[i] = nftInfo.id;
                    sings++;
                    rewardElligibleCount++;
                    break;
                }
            }

            emit SingCreated(nftInfo.id, msg.sender);
        }
    }

    /*
        Requirements:
        1. Has the TOP buyVolume (in BNB) throughout the whole supply.
        2. Contests has ended.
        3. Holds at least nft.buyVolumeInTokens inside wallet.
        * This means either not selling at all or transfering tokens from another wallet
     */
    function canBeNirvana(uint _tokenId) public view returns (bool wonContest, bool enoughTokens, uint tokensRequired){
        LoyaltyInfo memory nftInfo = loyaltySpots[_tokenId];

        wonContest = !nirv
        && nftInfo.buyVolume >= NIRVANA_VOLUME
        && nftInfo.id == currentTopId
        && block.number >= nirvConEBlock;

        enoughTokens = YoloV.balanceOf(nftInfo.owner) >= nftInfo.buyVolumeInTokens;

        return (wonContest, enoughTokens, nftInfo.buyVolumeInTokens);
    }

    /*
        Requirements:
        1. Has buyVolume (in BNB) more than SING_VOLUME (200 BNB).
        2. Holds at least nft.buyVolumeInTokens inside wallet.
        * This means either not selling at all or transfering tokens from another wallet
    */
    function canBeSing(uint _tokenId) public view returns (bool enoughVolume, bool enoughTokens, uint tokensRequired){
        LoyaltyInfo memory nftInfo = loyaltySpots[_tokenId];

        enoughVolume = sings != MAX_SINGS
        && nftInfo.buyVolume >= SING_VOLUME;

        enoughTokens = YoloV.balanceOf(nftInfo.owner) >= nftInfo.buyVolumeInTokens;

        return (enoughVolume, enoughTokens, nftInfo.buyVolumeInTokens);
    }

    /* State updates (called by @royalEvolve) */
    function onNirvanaBorn(uint _tokenId) internal {
        loyaltySpots[_tokenId].rank = Rank.NIRVANA;
        rewardElligibleCount++;

        super._setTokenURI(_tokenId, rToR[Rank.NIRVANA].uri);

        nirv = true;
        nirvanaId = _tokenId;
        //Set the new nirvana volume as this current top volume
        NIRVANA_VOLUME = loyaltySpots[currentTopId].buyVolume;
        delete currentTopId;

        emit TheNirvanaWasBorn(_tokenId, msg.sender, NIRVANA_VOLUME);
    }


    /*
        Claims YoloV tokens based on sender NFT Rank.
        When a user calls this function a reward gets calculated and send to his wallet.
        The reward amount = rewardFund / rewardElligibleCount (all rank0+).
        This means that the first to call will get a higher reward.
        ex: rewardFund = 1m; rewardElligibleCount = 100; First user gets 10k YoloV, Second gets 9.9k

        Anti-Bot Protection
        * Produce Random tx ordering in block by requiring tx.gasprice
    */
    function claim() external onlyNftHolders antiReentrant returns (bool){
        // Safety Checks
        require(rewardFund > 1e18, "Not enough fund !");
        require(this.canClaim(msg.sender), "Can't claim yet !");

        if (tx.gasprice != EXACT_GAS_CLAIM) {
            return false;
        }

        LoyaltyInfo memory nftInfo = loyaltySpots[accountToId[msg.sender]];
        // Recruits can't claim!
        if (nftInfo.rank == Rank.RECRUIT) {
            return false;
        }

        // Calculate Raw Claim Amount based on total rank0+
        uint256 fullClaimAmount = rewardFund / rewardElligibleCount;

        // Calculate the Fee reduction & Amount
        uint feeReduction = rToR[nftInfo.rank].feeReduction;
        uint feeAfterReduction = claimFee - (claimFee * feeReduction / 10000);
        uint feeAmount = fullClaimAmount * feeAfterReduction / 10000;

        // Calculate the final claim amount to reach the wallet
        uint256 claimAmount = fullClaimAmount - feeAmount;
        // Deduct the full amount from fund (since we utilize tax as well)
        rewardFund -= fullClaimAmount;
        // Storage Updates.
        loyaltySpots[nftInfo.id].claimedRewards += claimAmount;
        loyaltySpots[nftInfo.id].lastBlockClaimed = block.number;

        YoloV.transfer(nftInfo.owner, claimAmount);

        // Tax Distribution
        if (feeAmount > 1e5) {
            if (FOR_BURN > 0) {
                uint forBurn = feeAmount * FOR_BURN / 10000;
                YoloV.burn(forBurn);
            }
            if (FOR_FOMO_FUND > 0) {
                uint fomoAmount = feeAmount * FOR_FOMO_FUND / 10000;
                YoloV.burn(fomoAmount);
                YoloV.receiveFunds(fomoAmount);
            }
            if (FOR_LP > 0) {
                YoloV.transfer(LP_GROWER_ADDRESS, feeAmount * FOR_LP / 10000);
            }
        } else {
            emit FeeAmountWasTooLow();
        }

        return true;
    }

    /*
        Checks if a NFT can be minted to the account.
        1. Balance = 0
        2. TotalSupply (tokenCounter) < 3000
        3. One per block
    */
    function canMint(address _account) public view returns (bool) {
        if (balanceOf(_account) == 0) {
            return (tokenCounter < MAX_SPOTS && block.number > lastMintBlock)
            || tokenCounter == 0;
        }

        return false;
    }

    /*
        Checks if the account can evolve to (at least) next rank.
        Requirement: nft.level >= nextRank.minLevel
    */
    function canEvolve(address _account) public view returns (bool){
        LoyaltyInfo memory nftInfo = getNftInfo(_account);
        Rights memory nextRights = rToR[Rank(uint(nftInfo.rank) + 1)];

        bool enoughLevel = nftInfo.level >= nextRights.minLevel;

        return enoughLevel;
    }

    /*
        Checks if account can transform Loyalty NFT to Yolonaut NFT
        Requirement: NFT rank = 0 (Recruit)
     */
    function canEvolveToDiv(address _account) public view returns (bool) {
        if (this.balanceOf(_account) == 1) {
            LoyaltyInfo memory nftInfo = getNftInfo(_account);
            if (nftInfo.rank == Rank.RECRUIT) {
                return true;
            }
        }
        return false;
    }

    /* Checks if claim cooldown has passed */
    function canClaim(address _account) public view returns (bool){
        return (getBlocksUntilClaim(_account) == 0);
    }

    /*
        Called by 2 contracts:
        1. YoloV on rewardDistribution (@sendLoyaltyRewardsToNft)
        2. LpGrower
    */
    function receiveRewards(uint256 _reward) external onlyLPGrowerAndYolo {
        rewardFund += _reward;
        emit ReceivedRewards(_reward, rewardFund);
    }

    /*
        Called upon buying YoloV.
        1. Calculates [buyVolume] -> one of the most important metrics.
           It is calculated both in BNB (buyVolume) and in YoloV (buyVolumeInTokens):
           ---> In BNB: used for levels and gaining ranks.
                Upon evolution (@evolve) getAmountsOut(buyVolume) determines the amount of YoloV send to Keeper.
           ---> In YoloV: used only for singularity & nirvana. Determines how many tokens must be held in wallet at @royalEvolve.
                Kind of DCA.
        2. Reduces claim cooldown.
        3. Updates Nirvana competition
    */
    function handleBuy(address _account, uint256 _bnbAmount, uint256 _tokensReceived) external onlyYolo {
        LoyaltyInfo memory nftInfo = loyaltySpots[accountToId[_account]];

        loyaltySpots[nftInfo.id].buyVolume += _bnbAmount;
        loyaltySpots[nftInfo.id].buyVolumeInTokens += _tokensReceived;
        // Level Up
        if (_bnbAmount >= LEVEL_UP_AMOUNT) {
            uint gainedLevels = _bnbAmount / LEVEL_UP_AMOUNT;
            loyaltySpots[nftInfo.id].level += gainedLevels;
        }

        // Claim CD Reduction
        uint claimBlock = nftInfo.lastBlockClaimed + CLAIM_COOLDOWN;

        if (claimBlock > block.number) {
            uint blocksLeft = claimBlock - block.number;
            if (blocksLeft > MIN_CLAIM_BLOCKS) {
                // Reduce CLAIM cooldown based on BNB BuyVolume
                uint maxReduction = blocksLeft - MIN_CLAIM_BLOCKS;
                uint gainedLevels = _bnbAmount / LEVEL_UP_AMOUNT;
                uint reduction = gainedLevels * REDUCTION_PER_LEVEL;
                // Max reduction to 24hrs (from 72hrs)
                if (reduction < maxReduction) {
                    loyaltySpots[nftInfo.id].lastBlockClaimed -= reduction;
                } else {
                    loyaltySpots[nftInfo.id].lastBlockClaimed -= maxReduction;
                }
            }
        }
        // Update Nirvana Competition (noNirvana & myNft.buyVolume > currentTopCompetitor.buyVolume)
        if (!nirv && loyaltySpots[nftInfo.id].buyVolume > loyaltySpots[currentTopId].buyVolume) {
            currentTopId = nftInfo.id;
        }
    }

    /* State updates. Called by Keeper when the user withdraws his funds. */
    function onLeaveVillage(address _account) external onlyKeeper {
        /* RESTART GAME */
        uint id = accountToId[_account];

        delete loyaltySpots[id].buyVolume;
        delete loyaltySpots[id].lastSpeedUpVolume;
        delete loyaltySpots[id].buyVolumeInTokens;
        delete loyaltySpots[id].level;

        if (loyaltySpots[id].rank == Rank.SINGULARITY) {
            onSingLost(id, _account);
        } else if (loyaltySpots[id].rank == Rank.NIRVANA) {
            onNirvanaLost(id, _account);
        }

        loyaltySpots[id].rank = Rank.RECRUIT;
        super._setTokenURI(id, rToR[Rank.RECRUIT].uri);

        if (rewardElligibleCount > 0) {
            rewardElligibleCount--;
        }

        emit Devolved(_account, id, 0);
    }

    /* @onLeaveVillage. Initial caller: Keeper @withdraw */
    function onNirvanaLost(uint _id, address _account) internal {
        delete nirvanaId;
        nirv = false;

        uint oldDuration = nirvConDur;
        if (oldDuration > 28800) {
            nirvConDur = (oldDuration / 2);
            nirvConEBlock = block.number + nirvConDur;
        } else {
            nirvConEBlock = block.number + 28800;
        }

        emit TheNirvanaDied(_id, _account);
    }

    /* @onLeaveVillage. Initial caller: Keeper @withdraw */
    function onSingLost(uint _id, address _account) internal {
        sings--;

        uint count = MAX_SINGS;
        for (uint i = 0; i < count; i++) {
            if (singIds[i] == _id) {
                delete singIds[i];
                break;
            }
        }

        emit SingDestroyed(_id, _account);
    }

    /* If the degen doesn't royalEvolve() in 3 days DEVs can reset the competition */
    function resetNirv(uint _contestBlocks) external onlyOwner {
        uint requiredBlocksNotBornAfterRace = 86400;
        if (!nirv && block.number >= nirvConEBlock + requiredBlocksNotBornAfterRace) {
            nirvConEBlock = block.number + _contestBlocks;
            delete currentTopId;
        }
    }

    /* Locks the NFT as Recruit in LP Pair effectively reducing supply. Called by Keeper @withdraw */
    function theGreatBurn(address _account) external {
        require(msg.sender == DIV_NFT_ADDRESS || msg.sender == address(KeeperContract), "Only Div & Keeper");
        // Get next pair address
        address burnPairAddress = getNextBurnA();

        uint id = accountToId[_account];
        burnedIds.push(id);
        // Transfer to LP Pair
        _transfer(_account, burnPairAddress, id);

        burnIndex = 0;
    }
    // Gets next LP Pair address to lock NFT into the next "BURN"
    function getNextBurnA() public view returns (address){
        uint nextCount;
        if (burnIndex != 0) {
            nextCount = burnIndex;
        } else {
            nextCount = burnedIds.length;
        }
        address pair = uFactory.allPairs(nextCount);
        return pair;
    }
    /* Overridden in order to update the custom storage collections when ownership changes */
    function _transfer(address from, address to, uint256 tokenId) internal override (ERC721) virtual {
        require(accountToId[to] == 0, "1 per account !");
        super._transfer(from, to, tokenId);
        delete accountToId[from];
        accountToId[to] = tokenId;
        loyaltySpots[tokenId].owner = to;
    }
    /* Used by the NFT Marketplace to transfer NFTs from Seller to Buyer */
    function marketTransfer(address _from, address _to, uint _nftId) external {
        require(msg.sender == MARKETPLACE_ADDRESS, "UnAuth");
        _transfer(_from, _to, _nftId);
    }

    // Gets next claim block for NFT in _account
    function getClaimBlock(address _account) public view returns (uint256){
        uint256 value = loyaltySpots[accountToId[_account]].lastBlockClaimed + CLAIM_COOLDOWN;

        return value;
    }
    // Returns the remaining blocks until claim for NFT in the _account
    function getBlocksUntilClaim(address _account) public view returns (uint){
        uint claimBlock = getClaimBlock(_account);

        if (claimBlock > block.number) {
            return (claimBlock - block.number);
        }

        return 0;
    }
    // Returns the next loyalty mint price (= BNB required in a single swap to auto-mint)
    function getNextMintPriceBnb() public view returns (uint){
        uint minInBnb = mintPriceBnb;
        uint supply = this.totalSupply();
        if (supply < 1000) {
            minInBnb += 7e14;
        } else if (supply < 2000) {
            minInBnb += 1e15;
        } else if (supply < 2500) {
            minInBnb += 8e15;
        } else if (supply < 2750) {
            minInBnb += 56e15;
        } else if (supply < 2980) {
            minInBnb += 13e16;
        } else {
            minInBnb += 275e17;
        }

        return minInBnb;
    }

    function totalSupply() public view returns (uint){
        return tokenCounter;
    }

    function getNftInfo(address _account) internal view returns (LoyaltyInfo memory) {
        return loyaltySpots[accountToId[_account]];
    }

    /* --------- GETTERS EXTERNAL --------- */
    function getMinter(uint _tokenId) external view returns (address){
        return loyaltySpots[_tokenId].minter;
    }

    function getMintPriceBnb() external view returns (uint){
        return mintPriceBnb;
    }

    function getIdForAccount(address _acc) external view returns (uint) {
        return accountToId[_acc];
    }

    function myInfo() external view returns (
        uint rank, uint level,
        uint id,
        uint possibleClaimAmount, uint blocksLeftToClaim,
        uint buyVolumeBnb, uint buyVolumeInTokens,
        uint lastSpeedUpVolume, uint claimedRewards
    )   {
        return getInfo(msg.sender);
    }

    function getInfo(address _account) public view returns (
        uint rank, uint level,
        uint id,
        uint possibleClaimAmount, uint blocksLeftToClaim,
        uint buyVolumeBnb, uint buyVolumeInTokens,
        uint lastSpeedUpVolume, uint claimedRewards
    )   {
        LoyaltyInfo memory nftInfo = getNftInfo(_account);

        if (rewardElligibleCount != 0) {
            uint claimBlock = nftInfo.lastBlockClaimed + CLAIM_COOLDOWN;
            blocksLeftToClaim = claimBlock > block.number ? claimBlock - block.number : 0;
            possibleClaimAmount = rewardFund / rewardElligibleCount;
        }

        return (uint(nftInfo.rank), nftInfo.level,
        nftInfo.id,
        possibleClaimAmount, blocksLeftToClaim,
        nftInfo.buyVolume, nftInfo.buyVolumeInTokens,
        nftInfo.lastSpeedUpVolume, nftInfo.claimedRewards);
    }

    /* --------- SETTERS --------- */
    function setMinClaimBlocks(uint _newMin) external onlyOwner {
        require(_newMin <= 72000, "Hardlimits");
        MIN_CLAIM_BLOCKS = _newMin;
    }

    function setY(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        YoloV = IYoloV(_addy);
    }

    function setA(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        ArtifactContract = IArtifact(_addy);
    }

    function setLp(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        LP_GROWER_ADDRESS = _addy;
    }

    function setD(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        DIV_NFT_ADDRESS = _addy;
    }

    function setK(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        KeeperContract = IKeeper(_addy);
    }

    function setM(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address !");
        MARKETPLACE_ADDRESS = _addy;
    }
    // In case some degen sends NFT to the next LP pair index, we can change the index. manually.
    function setBurnIndex(uint _next) external {
        require(msg.sender == 0x2674c8E1F6a793ee2cCD13a6FbD251457aF013c4 && _next < uFactory.allPairsLength(), "Not Authorized Caller!");
        burnIndex = _next;
    }
    // Apply sustainability changes to the claimFee if needed.
    function setClaimFee(uint _newFee) external onlyOwner {
        // 70%-90%
        require(_newFee >= 7000 && _newFee <= 9000, "Hardlimits !");
        claimFee = _newFee;
    }
    // Apply sustainability changes to the claimFee distribution/split/usage
    // Can rotate between burn/lpgrowth/totalfund
    function setClaimTaxDistribution(uint _fomo, uint _burnA, uint _lp) external onlyOwner {
        require(_fomo + _burnA + _lp == 10000, "Not adding up to 100%");
        FOR_FOMO_FUND = _fomo;
        FOR_LP = _lp;
        FOR_BURN = _burnA;
    }
    // Changes the bsc default gwei, in case they change it from 5gwei
    function setMaxGasClaim(uint _newGP) external onlyOwner {
        require(_newGP >= 1e9);
        EXACT_GAS_CLAIM = _newGP;
    }
    // in case we need to migrate to another DEX. Tokenomics would still work.
    function setUAddrs(address _rAdd, address _facAdd) external onlyOwner {
        U_ROUTER = _rAdd;
        U_FACTORY_ADDRESS = _facAdd;

        uRouter = IURouter(U_ROUTER);
        uFactory = IUFactory(U_FACTORY_ADDRESS);
    }
    // Update the reward fund state var to match the total YOLOV held in contract
    function syncFund() external {
        rewardFund = YoloV.balanceOf(address(this));
    }
    // Change ownership of contract (Timelocker and Governance to come)
    function transferOwnership(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address !");
        deployer = _addy;
    }
}
