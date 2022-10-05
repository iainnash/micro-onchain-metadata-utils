// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";

library CurationMetadataBuilder {
    string constant key_name = "name";
    string constant key_description = "description";
    string constant key_image = "image";

    function encodeURI(string memory uriType, string memory result) internal pure returns (string memory) {
        return string.concat("data:", uriType, ";base64,", string(Base64.encode(bytes(result))));
    }

    function generateJSON(string[] memory keys, string[] memory values) internal pure returns (string memory) {
        string memory result = "{";
        string memory postfix = ",";
        for (uint256 i = 0; i < keys.length; i++) {
            if (i == keys.length - 1) {
                postfix = '}';
            }
            result = string(abi.encodePacked(result, '"', keys[i], '": "', values[i], '"', postfix));
        }
        return encodeURI("application/json", result);
    }
}