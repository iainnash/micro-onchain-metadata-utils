// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)

import {Base64} from "./Base64.sol";

pragma solidity ^0.8.10;

library Uri {
    function encodeURI(string memory uriType, string memory result)
        internal
        view
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
}
