# 1. YoloV Contract
`ERC20`
`97m Total Supply`
> The YoloVerse token ticker. It holds the logic of the various NFT reward distributions.
> It's core function is the overridden "_transfer".
> It applies the protocol fee and interacts with Loyalty NFT by minting and increasing buyVolume. 
>
- Keeps the total YoloV Reward Fund (fomoFund).
- Determines and Distributes the YoloV Rewards to Yolonaut and Loyalty NFTs.
- Applies tax on transfer to sustain the reward fund.
- Performs initial state migration from v1 Yolodraw -> v2 YoloVerse.
- Updates Loyalty NFT state upon buy-transfer (swap bnb -> yolov).
- Auto-Mints Loyalty NFT upon swap (bnb -> yolov) above mint price.

# 2. Loyalty NFT Contract
`ERC721`
`max: 3000`
`deflationary`
> A Gamified yield-generating, passive income NFT with ranking & levels, and a safety "Keeper" mechanism.
> It has deflationary supply. Only 3000 can EVER be minted. A Locking mechanism replaces Burning.
> 

- Yield Generating NFTs (YoloV rewards).
- Keeps an internal YoloV Reward Fund.
- NFT Holders receive YoloV rewards `if rank above recruit`.
- Levels based on buy volume in BNB `1 bnb = 333 levels`.
- Rank-based system based on BNB buy volume tracked.
- Rank based Perks.
- Claim Rewards every 72hrs `can be reduced`.
- Protocol fee applied on reward claim `utilized`.
- Has two special limited supply ranks -> Singularity`12` and Nirvana`1`.
- Nirvana is an on-chain trading volume competiton `buys only` `min 500 bnb volume`.
- Locks instead of burning Loyalty NFT.
- Each Evolution requires the sender to transfer YoloV to the Keeper Contract.
- Tokens are retrievable upon Keeper withdraw(). The NFT gets locked as a recruit forever.
- Mint price scaling `6 phases`.


# 3. Yolonaut NFT Contract 
`ERC721`
`max: 500`
> Yield Generating NFT for long-term hold. Acts both as a "Vault" (funds keeper) and as a reward distributor.
> 
>
- Yield Generating NFTs (YoloV rewards).
- Stores underlying YoloV for each Yolonaut NFT.
- Receives rewards from the YoloV Token distribution `every 24h`.
- Auto-harvests each Yolonaut NFT Yield daily `no need to claim`.
- Claiming the underlying accumulated Yield in the NFT burns it `opens possibility for someone else to mint`.
- Has protocol fee on burning to sustain reward fund.
- Rank-based system `evolution is based on blocktime`.
- Speedup evolution process.
- Perks such as DAO Voting, Bonus yield and more.
- Has scaling mint price in BNB based on Total Reward fund in YOLOV contract & x1 Loyalty NFT Recruit.

# 4. Artifact NFT Contract
`ERC721`
`max: 445`
`Loyalty Mint`
> Utility NFT acting as a fee reducer.
> Used by a Loyalty NFT holder upon withdraw from the Keeper Contract.
> Minted upon every N'th Loyalty NFT mint.
>
- 4 Rarities.
- Each rarity reduces Keeper Contract withdraw protocol fee significantly.
- Auto-minted for free on each N'th Loyalty NFT.
- Devs can mint limited number of each rarity for Giveaways / Marketing.

# 5. Keeper Contract
`Utility`
`Loyalty NFT`
> The Vault contract for the funds of the Loyalty NFTs. 
>
- Stores the YoloV provided upon evolving the Loyalty NFTs.
- Has two withdraw options - normal & using an artifact.
- The normal withdraw applies full protocol tax `10%`.
- The artifact withdraw reduces protocol tax significantly based on rarity.
- Upon withdraw De-ranks Loyalty NFT to Recruit and locks it forever.
 
 
