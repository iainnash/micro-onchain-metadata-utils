// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Base64} from "./lib/Base64.sol";
import {Strings} from "./lib/Strings.sol";
import {MetadataMIMETypes} from "./MetadataMIMETypes.sol";

library MetadataBuilder {
    struct JSONItem {
        string key;
        string value;
        bool quote;
    }

    function generateSVG(
        string memory contents,
        string memory viewBox,
        string memory width,
        string memory height
    ) internal pure returns (string memory) {
        return
            string.concat(
                '<svg viewBox="',
                viewBox,
                '" xmlns="http://www.w3.org/2000/svg" width="',
                width,
                '" height="',
                height,
                '">',
                contents,
                "</svg>"
            );
    }

    function generateEncodedSVG(
        string memory contents,
        string memory viewBox,
        string memory width,
        string memory height
    ) internal pure returns (string memory) {
        return
            encodeURI(
                MetadataMIMETypes.mimeSVG,
                generateSVG(contents, viewBox, width, height)
            );
    }

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

    function generateJSONArray(JSONItem[] memory items)
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
                result = string.concat(result, items[i].value, postfix);
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
        return encodeURI(MetadataMIMETypes.mimeJSON, generateJSON(items));
    }
}
