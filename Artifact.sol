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
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {size := extcodesize(account)}
        return size > 0;
    }
}

library Strings {
    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

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
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
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

    /**
     * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
     * in child contracts.
     */
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

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
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

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
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

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
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

    /**
     * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);

        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}

contract ArtefactsNft is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;
    uint256 public tokenSupply;

    address public LOYALTY_ADDRESS;
    address public KEEPER_ADDRESS;
    address public MARKETPLACE_ADDRESS;

    enum Rarity{AMETHYST, OPAL, DIAMOND, WARP_STONE}

    /* Each Rarity Has Certain Properties */
    struct Properties {
        uint step;
        uint max;
        uint counter;
        uint nextMulti;
        string uri;
    }

    /* Mappings */
    mapping(uint => ArtifactInfo) public artifacts;
    mapping(address => uint[]) public accountToArtifacts;
    mapping(Rarity => Properties) public rarityToProp;

    /* Each Artifact has certain details */
    struct ArtifactInfo {
        address owner;
        address minter;
        uint loyaltyId;
        uint id;
        Rarity rarity;
    }

    /* MAX SUPPLY */
    uint constant MAX_MINT = 445;

    /* EVENTS */
    event ArtifactFound(address _owner, uint256 _tokenId, uint256 _loyaltyId);
    event ArtifactNotFound(address _owner, uint256 _loyaltyId);
    event ArtifactTeleported(address _previousOwner, address _newOwner, uint _tokenID, uint blockNumber, uint timeStamp);
    event ArifactSpecialReward(address _owner, uint256 _tokenId, uint256 _loyaltyId);
    event ArtifactConsumed(uint _tokenId, uint256 _loyaltyId);

    constructor (address _loyaltyAdd, address _keeperAdd) ERC721("ConsumableArtefactsNFT", "ArtefactsNFT"){
        tokenCounter = 0;
        tokenSupply = 0;
        KEEPER_ADDRESS = _keeperAdd;
        LOYALTY_ADDRESS = _loyaltyAdd;
        // n'TH Loyalty id(3000 max) -> total number artifacts minted
        // 420 --> 7 mint (+3 dev) - max 10
        // 100 --> 30 mint (+5 dev) - max 35
        // 50 --> 60 mint (+10 dev) - max 70
        // 10 --> 300 mint (+30 dev) - max 330
        rarityToProp[Rarity.AMETHYST] = Properties({step : 10, max : 330, counter : 0, nextMulti : 1, uri : "https://gateway.pinata.cloud/ipfs/QmUNVDRoTbuFgSFnfKEZCJV15TxLGg95Xrv8wNHH91KTmZ"});
        rarityToProp[Rarity.OPAL] = Properties({step : 50, max : 70, counter : 0, nextMulti : 1, uri : "https://gateway.pinata.cloud/ipfs/QmSFsDKFPSGXamanv1Lvn11KZzGjFqFmZ6KQ8whGa87ig9"});
        rarityToProp[Rarity.DIAMOND] = Properties({step : 100, max : 35, counter : 0, nextMulti : 1, uri : "https://gateway.pinata.cloud/ipfs/QmPbAQfvB48ZtA1ooLrkx2ApEDbjD48CRE2VAHte9VgrRp"});
        rarityToProp[Rarity.WARP_STONE] = Properties({step : 420, max : 10, counter : 0, nextMulti : 1, uri : "https://gateway.pinata.cloud/ipfs/QmYodiCA13cAYg4i7625QeLpcaKMsBBBDGzgaYyh72JeyV"});
    }

    /* --------- MODIFIERS --------- */
    modifier onlyLoyalty() {
        require(msg.sender == LOYALTY_ADDRESS, "UnAuth");
        _;
    }

    modifier onlyKeeper() {
        require(msg.sender == KEEPER_ADDRESS, "UnAuth");
        _;
    }

    modifier onlyMarketplace() {
        require(
            msg.sender == MARKETPLACE_ADDRESS, "UnAuth");
        _;
    }

    /* --------- Mint NFT --------- */

    /*
        [Entry point] Creation.
        Called on LoyaltyNft creation and mints only if the Loyalty ID is a certain number (n'th)
        Each rarity has a certain divisor.
        1. Multiply id by 10k.
        2. Cycle through all rarities (starting from the last one WarpStone)
        * ONLY 1 rarity can be minted (ex: 100th loy NFT will mint a Diamond and NO Opal/Amethyst)
        * However a @nextMulti for each rarity is kept in order to calculate the correct "remainder"
        3. if rarity.nextMulti * 10k == id * 10k / step --> Mints and increases nextMulti for all rarities below (@didMint)
    */
    function create(address _account, uint _loyaltyId) external onlyLoyalty {
        if (tokenSupply < MAX_MINT) {
            uint base = 10000;
            // since int division can't produce a remainder
            uint buffedLoyalty = _loyaltyId * base;

            bool didMint;
            Properties memory currentProp;
            // otherwise j goes negative on final for cycle (exception).
            uint i;
            for (uint j = uint(Rarity.WARP_STONE) + 1; j > 0; j--) {
                i = j - 1;
                currentProp = rarityToProp[Rarity(i)];
                if (
                    currentProp.counter != currentProp.max
                    && (buffedLoyalty / currentProp.step) == base * (currentProp.nextMulti)
                ) {
                    if (didMint) {
                        rarityToProp[Rarity(i)].nextMulti++;
                    } else {
                        didMint = true;
                        rarityToProp[Rarity(i)].nextMulti++;
                        _createArtifact(_loyaltyId, _account, Rarity(i));
                        emit ArifactSpecialReward(_account, _loyaltyId, i);
                    }
                }
            }
        }
    }

    /* [Actual] Creation (internal) */
    function _createArtifact(uint _loyaltyId, address _account, Rarity _rarity) internal {
        uint newItemId = tokenCounter + 1;

        ArtifactInfo memory nftInfo = ArtifactInfo({
        owner : _account,
        minter : _account,
        id : newItemId,
        loyaltyId : _loyaltyId,
        rarity : _rarity
        });

        // State Update
        artifacts[newItemId] = nftInfo;
        accountToArtifacts[_account].push(newItemId);
        tokenCounter++;
        tokenSupply++;
        rarityToProp[_rarity].counter++;

        // Mint
        super._safeMint(_account, newItemId);
        super._setTokenURI(newItemId, rarityToProp[_rarity].uri);

        emit ArtifactFound(_account, newItemId, _loyaltyId);
    }

    /*
        [Dev Giveaway] Creation.
        Used by DEVs to fund Giveaways/Marketing etc ...
        Devs have around 10% of each rarity to mint until MAX supply is reached.
    */
    function createSpecialReward(uint _loyaltyId, address _account, uint _rarity) external onlyOwner {
        Properties memory currentProp = rarityToProp[Rarity(_rarity)];
        if (currentProp.counter < currentProp.max) {
            _createArtifact(_loyaltyId, _account, Rarity(_rarity));
            emit ArifactSpecialReward(_account, _loyaltyId, _rarity);
        } else {
            emit ArtifactNotFound(_account, _loyaltyId);
        }
    }

    /* Overridden in order to update the custom storage collections when ownership changes */
    function _transfer(address from, address to, uint256 tokenId) internal override (ERC721) virtual {
        super._transfer(from, to, tokenId);

        removeArtifactAt(from, tokenId);
        accountToArtifacts[to].push(tokenId);
        artifacts[tokenId].owner = to;

        emit ArtifactTeleported(from, to, tokenId, block.number, block.timestamp);
    }

    /*
        Called by Keeper.sol on @withdrawWithArtifact. (leaveVillage)
        User uses artefact to reduce the Keeper withdraw protocol fee.
        Transfers Artifact NFT to Keeper Contract.
        Can be redeemed by DEVs in Keeper.sol by calling @teleportArtifact.
    */
    function consumeArtifact(uint _artifactId) external onlyKeeper {
        _transfer(artifacts[_artifactId].owner, address(KEEPER_ADDRESS), _artifactId);
        emit ArtifactConsumed(_artifactId, artifacts[_artifactId].loyaltyId);
    }

    /* Cant burn, sorry */
    function _burn(uint256 tokenId) internal override (ERC721URIStorage) virtual {
        tokenId;
        revert("ERROR_CANT_BURN: Artifact-Too-Powerful");
    }

    /* Used by the NFT Marketplace to transfer NFTs from Seller to Buyer */
    function marketTransfer(address from, address to, uint256 tokenId) external onlyMarketplace {
        _transfer(from, to, tokenId);
    }

    /*
        Removes a tokenId from @accountToArtifacts[_account] array
        by shifting the elements after the target by 1 index backwards then pops final element.
    */
    function removeArtifactAt(address _account, uint _tokenId) internal returns (bool){
        uint length = accountToArtifacts[_account].length;

        if (length == 0) {
            return false;
        }

        if (accountToArtifacts[_account][length - 1] == _tokenId) {
            accountToArtifacts[_account].pop();
            return true;
        }

        bool found = false;
        for (uint i = 0; i < length - 1; i++) {
            if (_tokenId == accountToArtifacts[_account][i]) {
                found = true;
            }
            if (found) {
                accountToArtifacts[_account][i] = accountToArtifacts[_account][i + 1];
            }
        }
        if (found) {
            accountToArtifacts[_account].pop();
        }
        return found;
    }

    /* --------- GETTERS --------- */
    function hasArtifact(address _account) external view returns (bool){
        uint n = accountToArtifacts[_account].length;
        if (n == 0) {
            return false;
        }
        for (uint i = 0; i < n; i++) {
            if (accountToArtifacts[_account][i] != 0) {
                return true;
            }
        }
        return false;
    }

    function hasArtifactId(address _account, uint _tokenId) external view returns (bool){
        return artifacts[_tokenId].owner == _account;
    }

    function totalSupply() external view returns (uint){
        return tokenSupply;
    }

    function getMinter(uint _tokenId) external view returns (address){
        return artifacts[_tokenId].minter;
    }

    function getRarity(uint256 _tokenId) external view returns (uint){
        return uint(artifacts[_tokenId].rarity);
    }

    function getIdsForAccount(address _acc) external view returns (uint[] memory ids) {
        ids = accountToArtifacts[_acc];
        return ids;
    }

    function getOwnerOfNftID(uint256 _tokenId) external view returns (address){
        return artifacts[_tokenId].owner;
    }

    /* --------- SETTERS --------- */
    function setMarketplaceAddress(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address !");
        MARKETPLACE_ADDRESS = _addy;
    }

    function setLoyaltyContract(address _loyNftAddress) external onlyOwner {
        require(_loyNftAddress != address(0), "Zero address !");
        LOYALTY_ADDRESS = _loyNftAddress;
    }

    function setKeeperContract(address _keeperAddress) external onlyOwner {
        require(_keeperAddress != address(0), "Zero address !");
        KEEPER_ADDRESS = _keeperAddress;
    }

}
