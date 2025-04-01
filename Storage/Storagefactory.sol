// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./SimpleStorage.sol";

// contract Storagefactory {
contract Storagefactory is SimpleStorage {

    SimpleStorage[] public SimpleStorageArray;
    function createSimpleStorageContract() public {
        SimpleStorage storages = new  SimpleStorage();
        SimpleStorageArray.push(storages);

    }
    function sfStore(uint256 _ssindex, uint256 _ssnumber) public {
        // address
        SimpleStorage storagedata = SimpleStorage(address(SimpleStorageArray[_ssindex]));
        storagedata.store(_ssnumber);
    }
    function sfgat(uint256 _ssindex) public view returns (uint256){
        SimpleStorage storagedata = SimpleStorage(address(SimpleStorageArray[_ssindex]));
        return storagedata.retrive();
    }
}
