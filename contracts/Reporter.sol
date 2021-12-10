// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

import "./ITellor.sol";

contract Reporter {
    ITellor public tellor;
    ITellor public oracle;
    address public owner;
    uint256 public profitThreshold;//inTRB

    constructor(address _tellorAddress, uint256 _profitThreshold){
        tellor = ITellor(_tellorAddress);
        oracle = ITellor(
            tellor.getAddressVars(
                0xfa522e460446113e8fd353d7fa015625a68bc0369712213a42e006346440891e
            )
        );//keccak256(_ORACLE_CONTRACT)
        owner = msg.sender;
        profitThreshold = _profitThreshold;
    }
    
    function changeOwner(address _newOwner) external{
        owner = _newOwner;
    }

    function depositStake() external{
        tellor.depositStake();
    }

    function requestStakingWithdraw() external{
        tellor.requestStakingWithdraw();
    }

    function submitValue(bytes32 _queryId, bytes calldata _value, uint256 _nonce, bytes memory _queryData) external{
        require(oracle.getTimeBasedReward() > profitThreshold, "profit threshold not met");
        oracle.submitValue(_queryId,_value,_nonce,_queryData);
    }

    function submitValueBypass(bytes32 _queryId, bytes calldata _value, uint256 _nonce, bytes memory _queryData) external{
        oracle.submitValue(_queryId,_value,_nonce,_queryData);
    }

    function transfer(address _to, uint256 _amount) external{
        tellor.transfer(_to,_amount);
    }

    function withdrawStake() external{
        tellor.withdrawStake();
    }
}