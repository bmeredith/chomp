// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

import "../Enums.sol";
import "../Structs.sol";

import {IEngine} from "../IEngine.sol";
import {IEffect} from "./IEffect.sol";

contract DefaultStaminaRegen is IEffect {
    IEngine immutable ENGINE;

    constructor(IEngine _ENGINE) {
        ENGINE = _ENGINE;
    }

    function name() external pure returns (string memory) {
        return "Default Stamina Regen";
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

    function onRoundEnd(bytes32 battleKey, uint256, bytes memory, uint256) external returns (bytes memory, bool) {
        uint256 playerSwitchForTurnFlag = ENGINE.getPlayerSwitchForTurnFlagForBattleState(battleKey);
        MonState[][] memory monStates = ENGINE.getMonStatesForBattleState(battleKey);
        uint256[] memory activeMonIndex = ENGINE.getActiveMonIndexForBattleState(battleKey);

        // Update stamina for both active mons only if it's a 2 player turn
        if (playerSwitchForTurnFlag == 2) {
            for (uint256 playerIndex; playerIndex < 2; ++playerIndex) {
                int256 currentActiveMonStaminaDelta = monStates[playerIndex][activeMonIndex[playerIndex]].staminaDelta;

                // Cannot go past max stamina, so we only add 1 stamina if the current delta is negative
                if (currentActiveMonStaminaDelta < 0) {
                    ENGINE.updateMonState(playerIndex, activeMonIndex[playerIndex], MonStateIndexName.Stamina, 1);
                }
            }
        }

        // We don't need to store data
        return ("", false);
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
