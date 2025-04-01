from solcx import compile_standard
import json
from web3 import Web3
import os
from dotenv import load_dotenv
load_dotenv()
with open("./SimpleStorage.sol","r") as file:
    contract_source_code = file.read()

compiled_sol = compile_standard({
    "language": "Solidity",
    "sources": {"SimpleStorage.sol": {"content": contract_source_code}},
    "settings":
        {
            "outputSelection": {
                "*": {
                    "*": ["abi","metadata","evm.bytecode","evm.bytecode.sourceMap"]
                }
            }
        },
},
    solc_version="0.6.0",
)
# print(compiled_sol)
with open ("compiled_code.json","w") as file:
    file.write(json.dumps(compiled_sol))

# get bytecode

bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"]["bytecode"]["object"]

# get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))
chain_id =1337
my_address = "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1"
private_key = os.getenv("private_key")
SimpleStorage = w3.eth.contract(abi=abi,bytecode=bytecode)

# get the latest transaction
nonce = w3.eth.get_transaction_count(my_address)
transaction = SimpleStorage.constructor().build_transaction({
    "chainId": chain_id,
    "from": my_address,
    "nonce": nonce,
    "gasPrice": w3.to_wei('10', 'gwei'),  # Explicitly set gas price

})
signed_txn = w3.eth.account.sign_transaction(transaction,private_key=private_key)
# send the signed transaction
tx_hash = w3.eth.send_raw_transaction(signed_txn.raw_transaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

# working with the contract
# needs ABI and contract address
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress,abi=abi)

# call() is used to read data from the blockchain
print(simple_storage.functions.retrive().call())
store_transaction = simple_storage.functions.store(15).build_transaction({
    "chainId": chain_id,
    "from": my_address,
    "nonce": nonce+1,
    "gasPrice": w3.to_wei('10', 'gwei'),  # Explicitly set gas price

})
signed_store_txn = w3.eth.account.sign_transaction(store_transaction,private_key=private_key)
transaction_hash = w3.eth.send_raw_transaction(signed_store_txn.raw_transaction)    
tx_receipt = w3.eth.wait_for_transaction_receipt(transaction_hash)
print(simple_storage.functions.retrive().call())