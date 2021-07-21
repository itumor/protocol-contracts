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


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
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

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
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

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
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
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {size := extcodesize(account)}
        return size > 0;
    }
}

/**
 * @dev String operations.
 */
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


/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
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

/**
 * @dev ERC721 token with storage based token URI management.
 */
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

interface IYoloV {
    function burn(uint256 _amount) external;

    function mint(address _account, uint256 _amount) external;

    function receiveFunds(uint _amount) external;

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
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IURouter {
    function getAmountsOut(uint256 amountIn, address[] memory path)
    external
    view
    returns (uint256[] memory amounts);
}

interface IYoloSpeedsterNFT {
    function create(address _account, uint _divSpotId) external;

    function balanceOf(address account) external view returns (uint256);
}

interface IYoloLoyaltySpotNFT {
    function theGreatBurn(address _account) external;

    function canEvolveToDiv(address _account) external view returns (bool);
}

contract DivNft is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;
    uint256 public tokenSupply;

    address public U_ROUTER = 0xC2DaefF8Cb77Be50FfC921C9d4bf9AB3a02Ad98D;
    address public constant WBNB_ADDRESS = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    IYoloV public YoloV;
    IYoloSpeedsterNFT public YoloSpeedsterNft;
    IYoloLoyaltySpotNFT public LoyaltyNftContract;
    address public MARKETPLACE_ADDRESS;
    address public LP_GROWER_ADDRESS;

    IURouter public uRouter = IURouter(U_ROUTER);

    enum Rank{COMMON, RARE, EPIC, LEGENDARY}

    struct DivSpotInfo {
        uint256 totalAmount;
        uint256 startMinReq;
        Rank rank;
        address owner;
        address minter;
        uint256 id;
        uint256 mintBlock;
    }

    // index to tokenId
    uint[] public allDivSpots;

    /* Each rank has Rights(perks) */
    struct Rights {
        uint feeReduction;
        uint votingPower;
        uint bonusPercent;
        string uri;
        uint evolveBlocks;
    }

    /* Total YOLOV held */
    uint256 public totalTokenValue;
    uint256 public totalRewards;

    uint public lastMintBlock;
    uint public mintCooldown = 1;

    /* Claim Fee Distribution */
    uint public claimFee = 2000; // 20%
    uint public FOR_FOMO_FUND = 4000;
    uint public FOR_LP = 6000;

    /* Mappings */
    mapping(Rank => Rights) public rankToRights;
    mapping(uint256 => DivSpotInfo) public divSpots;
    mapping(address => uint256) public accountToId;

    address[] internal pathToBnb;

    /* Speedsters */
    struct SpeedsterInfo {
        uint256 totalAmount;
        uint256 amount;
        address owner;
        uint divSpotId;
    }

    uint public totalSpeedUp;
    uint256 public speedCycle;

    // Speedster NFT mappings
    mapping(uint => SpeedsterInfo) public speedsters;
    uint[] public allSpeedsters;
    SpeedsterInfo[][3] public historyWinners;

    uint public constant SPEEDUP_BLOCK_PER_BNB = 1200; // 0.01 BNB 1е16 = 1200 blocks [1h]
    uint public constant MIN_BNB_FOR_SPEEDUP = 33e16;
    uint public SPEED_FOR_LP = 8000;

    /* EVENTS */
    // Supply Log
    event NFTMinted(address _to, uint256 _tokenId);
    event NFTBurned(address _from, uint256 _tokenId, uint _rank);
    event ReceivedRewards(uint256 _rewardsAdded, uint256 _newTotal, uint _totalBonuses);

    // Evolution Log
    event EvolvedRarityArtAndYield(address _from, uint256 _tokenId, uint256 blockNr, uint _fromRank, uint _toRank);
    event SpeededUpEvolution(address _from, uint _tokenId, uint blocksSpeeded, uint amountSpent, uint bnbSpent);
    // Speedster Log
    event SpeedUp(address _owner, uint256 _amountBnb);
    event CycleConcluded(address[3] _top3, uint _totalAmount);

    constructor (address _yoloV2Addr, address _speedsterNftAddr) ERC721("YolonautNFT", "YolonautNFT"){
        tokenCounter = 0;
        tokenSupply = 0;

        YoloV = IYoloV(_yoloV2Addr);
        YoloSpeedsterNft = IYoloSpeedsterNFT(_speedsterNftAddr);

        totalTokenValue = 0;
        totalRewards = 0;

        lastMintBlock = block.number;

        totalSpeedUp = 0;
        speedCycle = 0;
        pathToBnb = [_yoloV2Addr, WBNB_ADDRESS];

        rankToRights[Rank.COMMON] = Rights({feeReduction : 0, votingPower : 1, bonusPercent : 1, evolveBlocks : 0, uri : "https://gateway.pinata.cloud/ipfs/QmT55Szk1CRoixQyDPCQDwmxdtGYWNk7XE45cYGUagrp14"});
        // 10 days
        rankToRights[Rank.RARE] = Rights({feeReduction : 2000, votingPower : 2, bonusPercent : 90, evolveBlocks : 288000, uri : "https://gateway.pinata.cloud/ipfs/Qmbc7qzZUbw1Mh85VqpYqDjmsta7sk6bbJvWeVRn85zNBJ"});
        // 30 days
        rankToRights[Rank.EPIC] = Rights({feeReduction : 4000, votingPower : 3, bonusPercent : 200, evolveBlocks : 864000, uri : "https://gateway.pinata.cloud/ipfs/QmP7u1dAtcr9KQhWAq5p1p6Wbkrt6hiTday8859ra4katL"});
        // 60 days
        rankToRights[Rank.LEGENDARY] = Rights({feeReduction : 6000, votingPower : 5, bonusPercent : 400, evolveBlocks : 1728000, uri : "https://gateway.pinata.cloud/ipfs/QmQxA2MnYRdyxD853rGpTF9hpiHgKeoBNsJ2ogV33bzJN2"});
    }

    /* --------- Modifiers --------- */
    modifier onlyYolo() {
        require(msg.sender == address(YoloV) || msg.sender == owner(), "UnAuth");
        _;
    }

    modifier onlyLPGrowerAndYolo() {
        require(msg.sender == LP_GROWER_ADDRESS || msg.sender == address(YoloV), "UnAuth");
        _;
    }

    modifier onlyNftHolders() {
        require(this.balanceOf(msg.sender) == 1 && accountToId[msg.sender] != 0, "No NFT !");
        _;
    }

    modifier onlyLpGrowerAndOwner() {
        require(msg.sender == LP_GROWER_ADDRESS || msg.sender == owner(), "UnAuth");
        _;
    }

    modifier onlyMarketplace() {
        require(msg.sender == MARKETPLACE_ADDRESS, "UnAuth");
        _;
    }

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
        Call chain: FomoRouter -> YoloV calculates minReq -> this function.
        @params _minReq: mintPrice. Calculated in YoloV @scaleDivNftMintPrice.
    */
    function create(address _account, uint256 _minReq) external onlyYolo returns (uint256){
        if (this.canMint(_account)) {
            return _createDivSpot(_account, _minReq);
        }
        return 0;
    }

    /*
        Creation [actual / internal].
        ("Burns" LoyaltyNFT)
        * Each NFT has minReq YoloV as balance
    */
    function _createDivSpot(address _account, uint256 _minReq) internal returns (uint256) {
        uint256 newItemId = tokenCounter + 1;

        DivSpotInfo memory nftInfo = DivSpotInfo({
        totalAmount : _minReq,
        startMinReq : _minReq,
        rank : Rank.COMMON,
        owner : _account,
        minter : _account,
        id : newItemId,
        mintBlock : block.number
        });

        allDivSpots.push(newItemId);

        divSpots[newItemId] = nftInfo;
        accountToId[_account] = newItemId;
        tokenCounter++;
        tokenSupply++;
        totalTokenValue += _minReq;
        lastMintBlock = block.number;

        super._safeMint(_account, newItemId);
        super._setTokenURI(newItemId, rankToRights[nftInfo.rank].uri);

        // Because when we migrated from v1 to v2 there were already 500 holders to receive an nft.
        if (newItemId > 500) {
            LoyaltyNftContract.theGreatBurn(_account);
            emit NFTMinted(_account, newItemId);
        }
        return newItemId;
    }

    /*
        Distributes rewards.
        1. calc baseReward per nft
        2. mint bonus (only once at end) and add to divSpots collection
        3. update state vars.
    */
    function receiveRewards(uint256 _dividendRewards) external onlyLPGrowerAndYolo {
        uint nftCount = this.totalSupply();

        uint reward = _dividendRewards / nftCount;

        uint totalBonuses;
        uint bonus;
        // Depending on each NFT rank, add bonus YOLOV yield
        for (uint i = 0; i < nftCount; i++) {
            bonus = reward * rankToRights[divSpots[allDivSpots[i]].rank].bonusPercent / 10000;
            totalBonuses += bonus;
            divSpots[allDivSpots[i]].totalAmount += reward + bonus;
        }
        totalRewards += _dividendRewards + totalBonuses;
        totalTokenValue += _dividendRewards + totalBonuses;
        // Mints the total bonuses for all NFTs and their respective ranks
        YoloV.mint(address(this), totalBonuses);

        emit ReceivedRewards(_dividendRewards, totalRewards, totalBonuses);
    }

    /*
        Claims underlying YoloV tokens and destroys NFT.
        This function is the way to "leaveVillage" and get the your yield & initial investment.
        * Protocol fee is determined based on rank (20% base at COMMON)
    */
    function burnToClaim() external onlyNftHolders antiReentrant {
        DivSpotInfo memory nftInfo = divSpots[accountToId[msg.sender]];

        uint256 underlyingYolo = nftInfo.totalAmount;

        // Fee Amounts
        uint feeReduction = rankToRights[nftInfo.rank].feeReduction;
        uint256 feeAfterReduction = claimFee - (claimFee * feeReduction / 10000);
        uint256 feedVillageFee = underlyingYolo * feeAfterReduction / 10000;

        // Distribute fees
        if (FOR_FOMO_FUND > 0) {
            uint forFomo = feedVillageFee * FOR_FOMO_FUND / 10000;
            YoloV.burn(forFomo);
            YoloV.receiveFunds(forFomo);
        }
        if (FOR_LP > 0) {
            uint forLp = feedVillageFee * FOR_LP / 10000;
            YoloV.transfer(LP_GROWER_ADDRESS, forLp);
        }

        // Transfer underlying - total fee
        YoloV.transfer(msg.sender, underlyingYolo - feedVillageFee);

        // State Updates
        totalTokenValue -= underlyingYolo;
        totalRewards -= (underlyingYolo - nftInfo.startMinReq);
        delete divSpots[nftInfo.id];
        removeDivSpotAt(nftInfo.id);
        delete accountToId[msg.sender];

        tokenSupply--;

        super._burn(nftInfo.id);

        emit NFTBurned(msg.sender, nftInfo.id, uint(nftInfo.rank));
    }

    /*
        Removes a _tokenId from allDivSpots array
        by shifting the elements after the target by 1 index backwards then popping the final element.
    */
    function removeDivSpotAt(uint _tokenId) internal returns (bool){
        uint length = allDivSpots.length;

        if (allDivSpots[length - 1] == _tokenId) {
            allDivSpots.pop();
            return true;
        }

        bool found = false;
        for (uint i = 0; i < length - 1; i++) {
            if (_tokenId == allDivSpots[i]) {
                found = true;
            }
            if (found) {
                allDivSpots[i] = allDivSpots[i + 1];
            }
        }
        if (found) {
            // delete allDivSpots[allDivSpots.length - 1];
            allDivSpots.pop();
        }
        return found;
    }

    /* Increases the rank of yolonaut nft. Based on blocks passed since mint. */
    function evolve() external onlyNftHolders antiReentrant returns (bool){
        return _evolve(msg.sender);
    }


    /* Internal evolution. Evolves the NFT to the maximum rank possible. */
    function _evolve(address _account) internal returns (bool){
        DivSpotInfo memory nftInfo = divSpots[accountToId[_account]];
        require(nftInfo.rank != Rank.LEGENDARY, "Already LEGENDARY ! Bows.");

        if (!canEvolve(msg.sender)) {
            return false;
        }

        uint nextRankNumber = uint(nftInfo.rank) + 1;

        Rights memory currRights;

        // Gets MAX rank possible
        for (uint i = uint(Rank.LEGENDARY); i >= nextRankNumber; i--) {
            currRights = rankToRights[Rank(i)];
            if (block.number >= nftInfo.mintBlock + currRights.evolveBlocks) {
                divSpots[nftInfo.id].rank = Rank(i);
                super._setTokenURI(nftInfo.id, currRights.uri);

                emit EvolvedRarityArtAndYield(msg.sender, nftInfo.id, block.number, uint(nftInfo.rank), i);
                return true;
            }
        }

        return false;
    }

    /* Requirement: certain amount of blocks (different for each rank - see constructor) to have passed since mint. */
    function canEvolve(address _account) public view returns (bool _canEvolve) {
        DivSpotInfo memory nftInfo = divSpots[accountToId[_account]];
        require(nftInfo.rank != Rank.LEGENDARY, "Already LEGENDARY ! Bows.");

        Rank nextRank = Rank(uint(nftInfo.rank) + 1);
        Rights memory nextRights = rankToRights[nextRank];

        return block.number >= nftInfo.mintBlock + nextRights.evolveBlocks;
    }

    /*
        Speeds Up the evolution block-time for a Yolonaut NFT.
        1. Checks if _yoloAmountForFund > 0.33 BNB (min amount) & calculates reduction @getReductionBlocksPerYolo.
        2. Try evolve.
        3. Increase speedup amount inside storage mapping speedsters.
        4. Optionally mints a simple Speedster NFT (just art) if speedUp amount > 14.4 BNB\
        * All Speedsters have already been minted (25 total)
        5. Transfers to the rewardFund of YoloV.
        * YoloV receives rewards by first burning the tokens then minting everytime a reward distribution gets triggered.
        * Requires Approval from msg.sender to this contract of at least _yoloAmountForFund.
    */
    function speedUpEvolution(uint256 _yoloAmountForFund) external onlyNftHolders antiReentrant returns (uint256 newMintBlock){
        DivSpotInfo memory nftInfo = divSpots[accountToId[msg.sender]];
        require(nftInfo.rank != Rank.LEGENDARY, "Already Max Rank");

        // Reverts if _yoloAmountForFund < 0.33 BNB
        // 1BNB / 0.01 --> 100 * 864 = 3 days
        (uint blocksToSpeedUp, uint bnb) = getReductionBlocksPerYolo(_yoloAmountForFund);
        divSpots[nftInfo.id].mintBlock -= blocksToSpeedUp;

        // try and evolve
        _evolve(msg.sender);

        uint divId = nftInfo.id;

        // Store speedup leaderboard from all ranks and users
        if (speedsters[divId].owner == address(0)) {
            _createSpeedster(msg.sender, bnb, divId);
        } else {
            speedsters[divId].amount += bnb;
            speedsters[divId].totalAmount += bnb;
        }

        // Min. 14.4 bnb worth of tokens to get Speedster NFT
        // FCFS basis
        if (nftInfo.rank == Rank.COMMON && bnb >= 14.4e18) {
            YoloSpeedsterNft.create(msg.sender, divId);
        }

        // Transfers full amount (tax excl.)
        YoloV.transferFrom(msg.sender, address(this), _yoloAmountForFund);

        uint forLPGrowth = _yoloAmountForFund * SPEED_FOR_LP / 10000;
        uint forFomoFund = _yoloAmountForFund - forLPGrowth;

        YoloV.burn(forFomoFund);
        YoloV.receiveFunds(forFomoFund);

        YoloV.transfer(LP_GROWER_ADDRESS, forLPGrowth);

        emit SpeededUpEvolution(msg.sender, nftInfo.id, blocksToSpeedUp, _yoloAmountForFund, bnb);
        return divSpots[nftInfo.id].mintBlock;
    }

    /*
        Speedster NFT Creation.
        If speedster supply < 25 && speedup amount > 14.4 BNB (in YoloV)
    */
    function _createSpeedster(address _account, uint256 _amountBnb, uint _divSpotId) internal {
        SpeedsterInfo memory nftInfo = SpeedsterInfo({
        amount : _amountBnb,
        totalAmount : _amountBnb,
        owner : _account,
        divSpotId : _divSpotId
        });

        allSpeedsters.push(_divSpotId);
        speedsters[_divSpotId] = nftInfo;

        totalSpeedUp += _amountBnb;

        emit SpeedUp(_account, _amountBnb);
    }

    /*
        Returns the blocks reduction for a certain _yoloAmount. Called by @speedUpEvolution.
        0.01 BNB = 1200 blocks @SPEEDUP_BLOCK_PER_BNB.
    */
    function getReductionBlocksPerYolo(uint _yoloAmount) public view returns (uint blocksReduced, uint bnb) {
        bnb = uRouter.getAmountsOut(_yoloAmount, pathToBnb)[1];

        require(bnb >= MIN_BNB_FOR_SPEEDUP, "Under min. value: < 0.33 BNB");
        blocksReduced = bnb * SPEEDUP_BLOCK_PER_BNB / 1e16;

        return (blocksReduced, bnb);
    }

    /*
        Resets the Speedster race by choosing 3 winners. This is a function used by DEVs for giveaways and other perks.
        Hasn't been used yet.
    */
    function concludeSpeedsterCycle(address[3] calldata _top3) external onlyOwner {
        historyWinners[speedCycle].push(speedsters[accountToId[_top3[0]]]);
        historyWinners[speedCycle].push(speedsters[accountToId[_top3[1]]]);
        historyWinners[speedCycle].push(speedsters[accountToId[_top3[2]]]);

        for (uint i = 0; i < allSpeedsters.length; i++) {
            speedsters[allSpeedsters[i]].amount = 0;
        }
        speedCycle++;
        totalSpeedUp = 0;
        emit CycleConcluded(_top3, totalSpeedUp);
    }

    /* Overridden in order to update the custom storage collections when ownership changes */
    function _transfer(address from, address to, uint256 tokenId) internal override (ERC721) virtual {
        require(balanceOf(to) == 0 && accountToId[to] == 0, "Ownership limited to 1 per account !");

        super._transfer(from, to, tokenId);

        delete accountToId[from];
        accountToId[to] = tokenId;
        divSpots[tokenId].owner = to;
    }

    /* Used by the NFT Marketplace to transfer NFTs from Seller to Buyer */
    function marketTransfer(address _from, address _to, uint _nftId) external onlyMarketplace {
        _transfer(_from, _to, _nftId);
    }

    /*
       Requirements:
       1. One per block
       2. NFT balance = 0
       3. LoyaltyNftContract.canEvolveToDiv = account holds a Loyalty NFT rank0 (Recruit)
       * First 500 were migrated from v1.
    */
    function canMint(address _account) public view returns (bool) {
        if (super.balanceOf(_account) == 0) {
            if (
                tokenSupply < 500 && block.number >= lastMintBlock + mintCooldown
                && LoyaltyNftContract.canEvolveToDiv(_account)
            ) {
                return true;
            } else if (tokenCounter < 500) {
                /* Initial 500 have no cooldown */
                return true;
            }
        }
        return false;
    }

    function getNftInfo(address _account) internal view returns (DivSpotInfo memory) {
        return divSpots[accountToId[_account]];
    }

    /* --------- GETTERS EXTERNAL --------- */
    function totalSupply() public view returns (uint){
        return tokenSupply;
    }

    function getIds() external view returns (uint[] memory) {
        return allDivSpots;
    }

    function getOpenDivSpotsCount() external view returns (uint){
        return 500 - this.totalSupply();
    }

    /* Returns the blocks until next evolution rank */
    function getBlocksTillFullEvolution(uint256 _tokenId) external view returns (uint256) {
        uint endAt = divSpots[_tokenId].mintBlock + rankToRights[divSpots[_tokenId].rank].evolveBlocks;
        if (endAt <= block.number) {
            return 0;
        }
        return endAt - block.number;
    }

    function getfeeReduction(uint256 _tokenId) external view returns (uint256){
        return rankToRights[divSpots[_tokenId].rank].feeReduction;
    }

    function getMinReq(uint256 _tokenId) external view returns (uint256){
        return divSpots[_tokenId].totalAmount;
    }

    function getRank(uint _tokenId) external view returns (uint){
        return uint(divSpots[_tokenId].rank);
    }

    function getIdForAccount(address _acc) external view returns (uint) {
        return accountToId[_acc];
    }

    function getRights(uint _tokenId) external view returns (uint, uint, uint, uint){
        Rights memory rights = rankToRights[divSpots[_tokenId].rank];

        return (rights.feeReduction, rights.votingPower, rights.bonusPercent, rights.evolveBlocks);
    }

    function getNextMintBlock() external view returns (uint) {
        return lastMintBlock + mintCooldown;
    }

    function getOwnerOfNftID(uint256 _tokenId) external view returns (address){
        return divSpots[_tokenId].owner;
    }

    function myInfo() external view returns (
        uint rank,
        uint256 rewards,
        uint256 startMinReq,
        uint256 id,
        uint256 mintBlock
    ){
        return getInfo(msg.sender);
    }

    function getInfo(address _account) public view returns (
        uint rank,
        uint256 rewards,
        uint256 startMinReq,
        uint256 id,
        uint256 mintBlock
    )   {
        DivSpotInfo memory nftInfo = getNftInfo(_account);

        return (uint(nftInfo.rank),
        nftInfo.totalAmount,
        nftInfo.startMinReq,
        nftInfo.id,
        nftInfo.mintBlock
        );
    }

    function getMinter(uint _tokenId) external view returns (address){
        return divSpots[_tokenId].minter;
    }

    /* SETTERS */
    function setYoloV2Contract(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        YoloV = IYoloV(_addy);
    }

    function setYoloSpeedsterNftContract(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        YoloSpeedsterNft = IYoloSpeedsterNFT(_addy);
    }

    function setClaimFee(uint _newFee) external onlyOwner {
        require(_newFee >= 1000 && _newFee <= 3000, "Hardlimits !");
        claimFee = _newFee;
    }

    function setClaimTaxDistribution(uint _fomo, uint _lp) external onlyOwner {
        require(_fomo + _lp == 10000, "Not adding up to 100%");
        FOR_FOMO_FUND = _fomo;
        FOR_LP = _lp;
    }

    function setSpeedDistribution(uint _lp) external onlyOwner {
        require(_lp <= 10000, "Not adding up to 100%");
        SPEED_FOR_LP = _lp;
    }

    function setMintCooldown(uint _newCd) external onlyOwner {
        // 2h
        require(_newCd <= 2400, "Hardlimits !");
        mintCooldown = _newCd;
    }

    function setLpGrowerAddress(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        LP_GROWER_ADDRESS = _addy;
    }

    function setLoyaltyContract(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        LoyaltyNftContract = IYoloLoyaltySpotNFT(_addy);
    }

    function setMarketplaceAddress(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address !");
        MARKETPLACE_ADDRESS = _addy;
    }

    function setUAddr(address _rAdd) external onlyOwner {
        U_ROUTER = _rAdd;
        uRouter = IURouter(U_ROUTER);
    }

    /* Match the state variable to current YOLOV balance */
    // Distributes equally among holders
    // Can be called only from Owner and LPGrowth Contract
    // Serves as additional yield booster if needed
    function syncFund() external onlyLpGrowerAndOwner returns (bool)  {

        if (totalTokenValue > YoloV.balanceOf(address(this))) {
            totalTokenValue = YoloV.balanceOf(address(this));
            return true;
        }

        uint diff = YoloV.balanceOf(address(this)) - totalTokenValue;

        if (diff < 1e18) {
            return false;
        }

        uint nftCount = totalSupply();
        uint bonus = diff / nftCount;

        for (uint i = 0; i < nftCount; i++) {
            divSpots[allDivSpots[i]].totalAmount += bonus;
        }

        totalTokenValue += diff;
        return true;
    }
}
