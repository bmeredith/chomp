// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "../../src/Enums.sol";
import "../../src/Structs.sol";

import {IEngine} from "../../src/IEngine.sol";
import {IEffect} from "../../src/effects/IEffect.sol";
import {IMoveSet} from "../../src/moves/IMoveSet.sol";

contract EffectAttack is IMoveSet {

    struct Args {
        Type TYPE;
        uint256 STAMINA_COST;
        uint256 PRIORITY;
    }

    IEngine immutable ENGINE;
    IEffect immutable EFFECT;
    Type immutable TYPE;
    uint256 immutable STAMINA_COST;
    uint256 immutable PRIORITY;

    constructor(IEngine _ENGINE, IEffect _EFFECT, Args memory args) {
        ENGINE = _ENGINE;
        EFFECT = _EFFECT;
        TYPE = args.TYPE;
        STAMINA_COST = args.STAMINA_COST;
        PRIORITY = args.PRIORITY;
    }

    function name() external pure returns (string memory) {
        return "Effect Attack";
    }

    function move(bytes32, uint256 attackerPlayerIndex, bytes memory extraData, uint256) external
    {   
        uint256 targetIndex = (attackerPlayerIndex + 1) % 2;
        ENGINE.addEffect(targetIndex, EFFECT, extraData);
    }

    function priority(bytes32) external view returns (uint256) {
        return PRIORITY;
    }

    function stamina(bytes32) external view returns (uint256) {
        return STAMINA_COST;
    }

    function moveType(bytes32) external view returns (Type) {
        return TYPE;
    }
    
    function isValidTarget(bytes32) external pure returns (bool) {
        return true;
    }
}