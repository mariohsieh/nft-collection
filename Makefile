-include .env

NETWORK_ARGS := --rpc-url $(LOCALHOST_RPC_URL) --private-key $(DEFAULT_ANVIL_KEY) --broadcast

deploy-local:
	@forge script script/deploy-basic-nft.s.sol:DeployBasicNft $(NETWORK_ARGS)

mint:
	@forge script script/interactions.s.sol:MintBasicNft $(NETWORK_ARGS)

# deploy-sepolia:
# 	@forge script script/deploy-basic-nft.s.sol:DeployBasicNft --rpc-url $(SEPOLIA_RPC_URL) --account $(ACCOUNT) --sender $(SENDER) --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --verify
