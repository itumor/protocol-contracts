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

interface ICakeIFactory {
    function allPairs(uint) external view returns (address pair);
}

interface IYoloLoyaltySpotNFT {
    function onLeaveVillage(address _account) external;

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);
    // function getIdForAccount(address _acc) external view returns (uint);
    function getBlocksUntilClaim(address _account) external returns (uint);

    function getRights(uint _tokenId) external view returns (uint, uint, uint);

    function getCheckForRankReduction(address _account) external view returns (bool _hasReduced, uint _intoRank);

    function checkForRankReduction(address _account) external;

    function getIdForAccount(address _acc) external view returns (uint);

    function theGreatBurn(address _account) external;

}

interface IYoloV {
    function burn(uint256 _amount) external;

    function receiveFunds(uint _amount) external;

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IArtifact {
    function getRarity(uint256 _tokenId) external view returns (uint);

    function getIdForAccount(address _acc) external view returns (uint);

    function getOwnerOfNftID(uint256 _tokenId) external view returns (address);

    function consumeArtifact(uint _artifactId) external;

    function transferFrom(address from, address to, uint256 tokenId) external;

    function approve(address to, uint256 tokenId) external;

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function hasArtifactId(address _account, uint _tokenId) external returns (bool);
}

contract LoyaltyKeeper is Ownable {
    IYoloV public YoloV;
    IYoloLoyaltySpotNFT public LoyaltyNftContract;
    IArtifact public ArtifactContract;
    address public LP_GROWER_ADDRESS;

    /* NFT id -> YoloV Stored in Keeper */
    mapping(uint => uint) public amountStore;

    /* Withdraw Fee */
    uint public LP_GROWTH_FEE;

    constructor (address _yoloV2Addr, address _loyaltyAddr, address _lpGrowthAddr) {
        YoloV = IYoloV(_yoloV2Addr);
        LoyaltyNftContract = IYoloLoyaltySpotNFT(_loyaltyAddr);

        LP_GROWER_ADDRESS = _lpGrowthAddr;
        LP_GROWTH_FEE = 1000;
        // 10%
    }

    /* --------- MODIFIERS --------- */
    modifier onlyLoyalty() {
        require(msg.sender == address(LoyaltyNftContract), "UnAuth");
        _;
    }

    uint private unlocked = 1;
    modifier antiReentrant() {
        require(unlocked == 1, 'ERROR: Anti-Reentrant');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    /* Deposits YoloV on Loyalty NFT Evolution (Called in Loyalty.sol @evolve & @royalEvolve) */
    function deposit(uint _yoloAmount, uint _loyalId) external onlyLoyalty {
        amountStore[_loyalId] += _yoloAmount;
    }

    /*
        [LeaveVillage 1]
        Withdraws the stored YoloV received on the Loyalty NFT rank evolution.
        1. Updates Keeper & Loyalty state
        2. "Burns" the LoyaltyNFT (@theGreatBurn)
        3. Transfers back the YoloV amount after applying tax.

        * Only EOA allowed to call.
        * 10% protocol fee.
    */
    function withdraw() external antiReentrant {
        require(msg.sender == tx.origin, "No contracts allowed");

        uint nftId = LoyaltyNftContract.getIdForAccount(msg.sender);
        require(LoyaltyNftContract.ownerOf(nftId) == msg.sender, "Not your NFT -> Not your Yolo");

        uint yoloAmount = amountStore[nftId];

        // Safety Checks
        require(yoloAmount > 1e18, "Inssuficient Amount");
        require(YoloV.balanceOf(address(this)) >= yoloAmount, "Too Much!");

        // State Updates
        delete amountStore[nftId];
        LoyaltyNftContract.onLeaveVillage(msg.sender);

        // Lock NFT
        LoyaltyNftContract.theGreatBurn(msg.sender);

        // Transfer back after applying tax
        uint lpGrowthAmount = yoloAmount * LP_GROWTH_FEE / 10000;
        uint finalAmount = yoloAmount - lpGrowthAmount;

        YoloV.transfer(msg.sender, finalAmount);
        YoloV.transfer(address(LP_GROWER_ADDRESS), lpGrowthAmount);
    }

    /*
        [LeaveVillage 2]
        Same as @withdraw but consumes an ArtefactNft in order to reduce the withdrawFee.
        @params: _artifactId = Artefact to consume.
    */
    function withdrawWithArtifact(uint _artifactId) external antiReentrant {
        require(msg.sender == tx.origin, "No contracts allowed");

        // Security Checks
        uint nftId = LoyaltyNftContract.getIdForAccount(msg.sender);
        require(LoyaltyNftContract.ownerOf(nftId) == msg.sender, "Not your NFT -> Not your Yolo");
        require(
            ArtifactContract.ownerOf(_artifactId) == msg.sender
            && ArtifactContract.hasArtifactId(msg.sender, _artifactId),
            "Not your Artifact !"
        );

        uint yoloAmount = amountStore[nftId];
        require(yoloAmount > 1e18, "Inssuficient Amount");
        require(YoloV.balanceOf(address(this)) >= yoloAmount, "Too Much!");

        // Returns the amount to withdraw and the tax depending on the Artifact NFT Rarity
        (uint lpGrowthAmount, uint finalAmount) = getYoloAmountsAfterArtifactReduction(_artifactId, yoloAmount);

        // State Updates
        LoyaltyNftContract.onLeaveVillage(msg.sender);
        delete amountStore[nftId];

        // Lock Artifact in this contract (to be redeemed by DEVs later)
        ArtifactContract.consumeArtifact(_artifactId);
        // Lock NFT
        LoyaltyNftContract.theGreatBurn(msg.sender);

        YoloV.transfer(msg.sender, finalAmount);
        YoloV.transfer(address(LP_GROWER_ADDRESS), lpGrowthAmount);
    }

    /* --------- GETTERS --------- */

    /*  Returns the withdrawFee after applying the reduction of the artefact (better rarity = bigger reduction)*/
    function getTaxReductionFromArtifact(uint _artifactId) public view returns (uint feeAfterReduction){
        uint rarityNumber = ArtifactContract.getRarity(_artifactId);
        // 20%/60%/75%/95% fee reduction (10% Base Fee)
        uint[] memory reductions = new uint[](4);
        reductions[0] = 2000;
        reductions[1] = 6000;
        reductions[2] = 7500;
        reductions[3] = 9500;

        feeAfterReduction = LP_GROWTH_FEE - (LP_GROWTH_FEE * reductions[rarityNumber] / 10000);
        return feeAfterReduction;
    }

    /*
        @params _yoloAmount: usually amountStore[nftId] the YoloV amount for the LoyaltyNFT stored inside the Keeper.
        Called by @withdrawWithArtifact and by the dapp UI.
        @returns: (fee, yoloToReceive)
     */
    function getYoloAmountsAfterArtifactReduction(uint _artifactId, uint _yoloAmount) public view returns (uint lpGrowthAmount, uint finalAmount){
        uint feeAfterReduction = getTaxReductionFromArtifact(_artifactId);

        lpGrowthAmount = _yoloAmount * feeAfterReduction / 10000;
        finalAmount = _yoloAmount - lpGrowthAmount;

        return (lpGrowthAmount, finalAmount);
    }

    function getAmountInKeep(uint _loyaltyId) external view returns (uint){
        return amountStore[_loyaltyId];
    }

    /*
        Used by DEVs for giveaways and marketing.
        This contract holds the Artefact NFTs used by users when calling @withdrawWithArtifact.
    */
    function teleportArtifact(uint _artifactId) external onlyOwner {
        ArtifactContract.approve(this.owner(), _artifactId);
        ArtifactContract.transferFrom(address(this), this.owner(), _artifactId);
    }

    /* --------- SETTERS --------- */
    function setYoloContract(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        YoloV = IYoloV(_addy);
    }

    function setLoyaltyContract(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        LoyaltyNftContract = IYoloLoyaltySpotNFT(_addy);
    }

    function setAutoCompounderAddress(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        LP_GROWER_ADDRESS = _addy;
    }

    function setArtifactsContract(address _addy) external onlyOwner {
        require(_addy != address(0), "Zero address");
        ArtifactContract = IArtifact(_addy);
    }
}
