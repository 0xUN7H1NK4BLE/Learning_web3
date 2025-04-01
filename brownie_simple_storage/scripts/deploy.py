from brownie import accounts, config, SimpleStorage , network

def deploy_simple_storage():
    # Get the latest account
    account = get_account()
    print("Deploying from account: ", account)
    # Deploy the contract
    simple_storage=SimpleStorage.deploy({'from': account})
    print(simple_storage)
    # Get the stored value
    stored_value = simple_storage.retrive()
    print("Stored value: ", stored_value)
    # Set the stored value
    transaction = simple_storage.store(15, {'from': account})
    transaction.wait(1)
    # Get the stored value
    stored_value = simple_storage.retrive()
    print("Stored value: ", stored_value)

def get_account():
    if network.show_active() == 'development':
        return accounts[0]
    else:
        return accounts.add(config['wallets']['from_key'])

def main():
    deploy_simple_storage()