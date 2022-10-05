// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

library MetadataBuilder {
    struct JSONItem {
        string key;
        string value;
        bool quote;
    }

    string constant key_name = "name";
    string constant key_description = "description";
    string constant key_image = "image";

    function encodeURI(string memory uriType, string memory result)
        internal
        pure
        returns (string memory)
    {
        return
            string.concat(
                "data:",
                uriType,
                ";base64,",
                string(Base64.encode(bytes(result)))
            );
    }

    function generateJSONARray(JSONItem[] memory items)
        internal
        pure
        returns (string memory result)
    {
        result = "[";
        string memory postfix = ",";
        for (uint256 i = 0; i < items.length; i++) {
            if (i == items.length - 1) {
                postfix = "]";
            }
            if (items[i].quote) {
                result = string(result, items[i].value, postfix);
            } else {
                result = string.concat(
                    result,
                    '"',
                    items[i].value,
                    '"',
                    postfix
                );
            }
        }
    }

    function generateJSON(JSONItem[] memory items)
        internal
        pure
        returns (string memory result)
    {
        result = "{";
        string memory postfix = ",";
        for (uint256 i = 0; i < items.length; i++) {
            if (i == items.length - 1) {
                postfix = "}";
            }
            if (items[i].quote) {
                result = string.concat(
                    result,
                    '"',
                    items[i].key,
                    '": "',
                    items[i].value,
                    '"',
                    postfix
                );
            } else {
                result = string.concat(
                    result,
                    '"',
                    items[i].key,
                    '": ',
                    items[i].value,
                    postfix
                );
            }
        }
    }

    function generateEncodedJSON(JSONItem[] memory items)
        internal
        pure
        returns (string memory)
    {
        return encodeURI("application/json", generateJSON(items));
    }
}
