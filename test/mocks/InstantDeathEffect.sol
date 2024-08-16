// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "../../src/Enums.sol";
import "../../src/Structs.sol";

import {IEngine} from "../../src/IEngine.sol";
import {IEffect} from "../../src/effects/IEffect.sol";

contract InstantDeathEffect is IEffect {
    IEngine immutable ENGINE;

    constructor(IEngine _ENGINE) {
        ENGINE = _ENGINE;
    }

    function name() external pure returns (string memory) {
        return "Instant Death";
    }

    // Should run at end of round
    function shouldRunAtStep(EffectStep r) external pure returns (bool) {
        if (r == EffectStep.RoundEnd) {
            return true;
        } else {
            return false;
        }
    }

    function shouldClearAfterMonSwitch() external pure returns (bool) {
        return false;
    }

    function onRoundEnd(bytes32 battleKey, uint256, bytes memory, uint256 targetIndex)
        external
        returns (bytes memory updatedExtraData, bool removeAfterRun)
    {
        uint256 activeMonIndex = ENGINE.getActiveMonIndexForBattleState(battleKey)[targetIndex];
        ENGINE.updateMonState(targetIndex, activeMonIndex, MonStateIndexName.IsKnockedOut, 1);
        return ("", true);
    }

    // Everything below is an NoOp
    function onApply(bytes memory extraData) external returns (bytes memory updatedExtraData) {}
    function onRemove(bytes memory extraData) external {}
    function onRoundStart(bytes32 battleKey, uint256, bytes memory, uint256 targetIndex)
        external
        pure
        returns (bytes memory updatedExtraData, bool removeAfterRun)
    {}
}
