-include .env

code-coverage:
	@forge coverage --report lcov && genhtml lcov.info --branch-coverage --output-dir coverage

NETWORK_ARGS := --rpc-url $(LOCALHOST_RPC_URL) --private-key $(DEFAULT_ANVIL_KEY) --broadcast

deploy-basic:
	@forge script script/deploy-nft.s.sol:Deploy_Basic_NFT $(NETWORK_ARGS)

deploy-svg:
	@forge script script/deploy-nft.s.sol:Deploy_SVG_NFT $(NETWORK_ARGS)

mint-basic:
	@forge script script/interactions.s.sol:Mint_Basic_NFT $(NETWORK_ARGS)

mint-svg:
	@forge script script/interactions.s.sol:Mint_SVG_NFT $(NETWORK_ARGS)

# deploy-sepolia:
# 	@forge script script/deploy-basic-nft.s.sol:DeployBasicNft --rpc-url $(SEPOLIA_RPC_URL) --account $(ACCOUNT) --sender $(SENDER) --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --verify
