from brownie import Fundme, Wei , MockV3Aggregator ,network, config # Import Fundme and Wei from brownie
from scripts.helpful_script import get_account , deploy_mocks , LOCAL_BLOCKCHAIN_ENVIRONMENTS

def deploy_fund_me():
    account = get_account()
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        print("Please switch to the network")
        price_feed_address = config["networks"][network.show_active()]["eth_usd_price_feed"]
    else:
        deploy_mocks()
        price_feed_address = MockV3Aggregator[-1].address


    fund_me = Fundme.deploy(
        price_feed_address,{'from': account }, publish_source=config["networks"][network.show_active()].get("verify"))  # Correct usage with Wei
    print(f"Contract deployed by {account}")
    print(f"Contract deployed to {fund_me.address}")
    return fund_me

def main():
    deploy_fund_me()
