1. YOLOV Token Contract
   [97 000 000 YOLOV Total Supply]
- Keep Total YOLOV Reward Fund
- Determine and Distribute YOLOV Rewards to Yolonaut and Loyalty NFTs
- Apply tax on transfer to sustain Total Reward Fund
- Perform initial state migration from v1 Yolodraw -> v2 YoloVerse
- Update Loyalty NFT state upon buy-transfer (swap bnb->yolov)
- Auot-Mint Loyalty NFT upon swap (bnb->yolov) above mint price

2. Loyalty NFT Contract [max 3000]
- Yield Generating NFTs (YOLOV rewards)
- Keeps Loyalty NFT YOLOV Reward Fund
- Receive rewards from YOLOV Token [if rank above recruit]
- Levels based on buy volume in BNB [1 bnb = 333levels ]
- Rank-based system based on BNB buy volume tracked
- Perks based on each rank
- Claim Rewards every 72hrs
- Protocol fee applied on reward claim [utilized]
- Evolve Loyalty NFT to higher rank
- Has two special limited count ranks -> Singularity[12] and Nirvana[1]
- Nirvana is on-chain trading volume competiton [buys only] [min 500 bnb volume]
- Locks instead of burning Loyalty NFT
- Each Evolution requires sender to give YOLOV to Keeper Contract
- Tokens retrievable upon Keeper withdraw() and NFT locked as recruit.
- Has mint price scaling [6 phases]


3. Yolonaut NFT Contract [max 500]
- Yield Generating NFTs (YOLOV rewards)
- Stores underlying YOLOV for each Yolonaut NFT
- Receive rewards from YOLOV Token
- Auto-harvests each Yolonaut NFT Yield daily [no need to claim]
- Burn NFT To Claim Total Underlying accumulated in Yolonaut NFT [opens possibility for someone else to mint]
- Has protocol fee on the burning to sustain reward fund
- Rank-based system [evolution is based on blocktime]
- Speedup evolution process
- Perks such as DAO Voting, Bonus yield and more
- Has scaling mint price in BNB[based on Total Reward fund in YOLOV contract] + x1 Loyalty NFT Recruit

4. Artifact NFT Contract [max 445]
- Utility NFT used by Loyalty NFT Holder upon withdraw from Keeper Contract
- 4 Rarities
- Each rarity reduces Keeper Contract withdraw protocol fee significantly
- Auto-minted for free on each N'th Loyalty NFT
- Devs can mint limited number of each rarity for Giveaways / Marketing

5. Keeper Contract
- Stores the YOLOV provided upon evolving Loyalty NFTs
- Has two withdraw options - Normal and using Artifact
- Normal withdraw applied full protocol tax (10% base)
- Artifact withdraw reduces protocol tax significantly based on rarity
- De-ranks Loyalty NFT to Recruit and locks it
 
 
