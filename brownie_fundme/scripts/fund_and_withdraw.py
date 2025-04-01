from brownie import Fundme
from scripts.helpful_script import get_account


def fund():
    fund_me = Fundme[-1]
    account= get_account()
    entrance_fee = fund_me.getEntranceFee()
    print(f"The entrance fee is {entrance_fee}")
    print("Funding")
    fund_me.fund({"from": account, "value": entrance_fee})
    print("Funded")

def withdraw():
    fund_me = Fundme[-1]
    account = get_account()
    fund_me.withdraw({"from": account})
    print("Withdrawn")

def main():
    fund()
    withdraw()
    