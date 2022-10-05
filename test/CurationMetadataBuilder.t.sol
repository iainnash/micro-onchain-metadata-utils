// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CurationMetadataBuilder.sol";

contract CounterTest is Test {
    function testEncodeURI() public {
        assertEq(
            CurationMetadataBuilder.encodeURI(
                "application/json",
                '{"test": true}'
            ),
            ""
        );
        assertEq(
            CurationMetadataBuilder.encodeURI(
                "application/json",
                '{"test": true}'
            ),
            ""
        );
    }

    function testGenerateJSON() public {
        string[] memory keys = new string[](1);
        string[] memory values = new string[](1);
        keys[0] = "testing";
        values[1] = "okay";

        assertEq(CurationMetadataBuilder.generateJSON(keys, values), "");
    }
}
