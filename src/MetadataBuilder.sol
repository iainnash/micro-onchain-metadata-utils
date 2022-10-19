// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import {Strings} from "./lib/Strings.sol";
import {Uri} from "./lib/Uri.sol";
import {MetadataMIMETypes} from "./MetadataMIMETypes.sol";

library MetadataBuilder {
    struct JSONItem {
        string key;
        string value;
        bool quote;
    }

    function escapeQuotes(string memory input)
        internal
        view
        returns (string memory)
    {
        return input;
        /*
        uint256 quotesCount = 0;
        uint256 bytes32page;
        assembly {
            for {
                let inputPtr := input
                let inputEndPtr := add(input, mload(input))
            } lt(inputPtr, inputEndPtr) {

            } {
                inputPtr := add(inputPtr, 32)
                bytes32page := mload(inputPtr)

                quotesCount := add(
                    quotesCount,
                    add(
                        add(
                            eq(and(shr(24, bytes32page), 0xff), 0x22),
                            eq(and(shr(16, bytes32page), 0xff), 0x22)
                        ),
                        add(
                            eq(and(shr(8, bytes32page), 0xff), 0x22),
                            eq(and(bytes32page, 0xff), 0x22)
                        )
                    )
                )
            }
        }

        // console2.log(quotesCount);
        // if (quotesCount == 0) {
        //     return input;
        // }

        string memory outputString = new string(
            bytes(input).length + quotesCount
        );
        uint256 pageResult;
        bytes1 inputByte;

        assembly {
            for {
                let inputPtr := add(input, 32)
                let inputPtrEnd := add(input, mload(input))
                let outputPtr := add(outputString, 32)
                let inputPage := 0
            } lt(inputPtr, inputPtrEnd) {
                inputPage := add(inputPage, 32)
            } {
                pageResult := mload(inputPtr)
                inputPtr := add(inputPtr, 32)

                for {
                    let pageSlice := 256
                } gt(pageSlice, 0) {
                    pageSlice := add(pageSlice, 8)
                } {
                    inputByte := and(shr(pageSlice, pageResult), 0xff)
                    switch eq(inputByte, 0x22)
                    case 1 {
                        mstore8(outputPtr, 0x6c)
                        outputPtr := add(outputPtr, 8)
                    }

                    mstore8(outputPtr, inputByte)
                    outputPtr := add(outputPtr, 8)
                }
            }
        }
        return outputString;
        */
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

    /// @notice prefer to use properties with key-value object instead of list
    function generateAttributes(
        string memory displayType,
        string memory traitType,
        string memory value
    ) internal pure returns (string memory) {}

    function generateEncodedSVG(
        string memory contents,
        string memory viewBox,
        string memory width,
        string memory height
    ) internal view returns (string memory) {
        return
            Uri.encodeURI(
                MetadataMIMETypes.mimeSVG,
                generateSVG(contents, viewBox, width, height)
            );
    }



    function generateJSONArray(JSONItem[] memory items)
        internal
        view
        returns (string memory result)
    {
        result = "[";
        uint256 added = 0;
        for (uint256 i = 0; i < items.length; i++) {
            if (bytes(items[i].value).length == 0) {
                continue;
            }
            if (items[i].quote) {
                result = string.concat(
                    result,
                    added == 0 ? "" : ",",
                    '"',
                    escapeQuotes(items[i].value),
                    '"'
                );
            } else {
                result = string.concat(
                    result,
                    added == 0 ? "" : ",",
                    items[i].value
                );
            }
            added += 1;
        }
        result = string.concat(result, "]");
    }

    function generateJSON(JSONItem[] memory items)
        internal
        view
        returns (string memory result)
    {
        result = "{";
        uint256 added = 0;
        for (uint256 i = 0; i < items.length; i++) {
            if (bytes(items[i].value).length == 0) {
                continue;
            }
            if (items[i].quote) {
                result = string.concat(
                    result,
                    added == 0 ? "" : ",",
                    '"',
                    items[i].key,
                    '": "',
                    escapeQuotes(items[i].value),
                    '"'
                );
            } else {
                result = string.concat(
                    result,
                    added == 0 ? "" : ",",
                    '"',
                    items[i].key,
                    '": ',
                    items[i].value
                );
            }
            added += 1;
        }
        result = string.concat(result, "}");
    }

    function generateEncodedJSON(JSONItem[] memory items)
        internal
        view
        returns (string memory)
    {
        return Uri.encodeURI(MetadataMIMETypes.mimeJSON, generateJSON(items));
    }
}
