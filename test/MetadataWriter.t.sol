// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/MetadataWriter.sol";

contract MetadataWriter is Test {
    using JsonWriter for JsonWriter.Json;

    function testGenerateJSON() public {
        JsonWriter.Json memory writer;
        writer.writeStartObject();
        writer.writeProperty("testing", "okay");
        writer.writeEndObject();

        string memory jsonResult = writer.generateEncodedJSON();

        assertEq(
            jsonResult,
            "data:application/json;base64,eyJ0ZXN0aW5nIjogIm9rYXkifQ=="
        );

        assertEq(jsonResult, '{"testing": "okay"}');
        vm.parseJson(jsonResult);
    }

    function testGenerateJSONArrayFull() public {
        JsonWriter.Json memory writer;
        writer.writeStartArray();
        writer.writeValue("testing");
        writer.writeValue(23);
        writer.writeEndArray();

        string memory arrayResult = writer.value;
        assertEq(arrayResult, '["testing",23]');
    }

    function testGenerateJSONArraySingle() public {
        JsonWriter.Json memory writer;
        writer.writeStartArray();
        writer.writeValue(true);
        writer.writeEndArray();
        assertEq(writer.value, "[true]");
    }

    function testGenerateJSONArrayQuoteSingle() public {
        JsonWriter.Json memory writer;
        writer.writeStartArray();
        writer.writeValue('"the greatest ever"');
        writer.writeEndArray();
        assertEq(writer.value, '["\\"the greatest ever\\""]');
    }

    function testGenerateJSONQuoteObject() public {
        JsonWriter.Json memory writer;
        writer.writeStartObject();
        writer.writeProperty("testingkey", '"double"""troubleQuoteing""');
        writer.writeEndObject();

        assertEq(
            writer.value,
            '{"testingkey": "\\"double\\"\\"\\"troubleQuoteing\\"\\""}'
        );
        assertEq(
            writer.generateEncodedJSON(),
            "data:application/json;base64,eyJ0ZXN0aW5na2V5IjogIiJkb3VibGUiIiJ0cm91YmxlUXVvdGVpbmciIiJ9"
        );
    }

    function testGenerateJSONArrayEmpty() public {
        JsonWriter.Json memory writer;
        writer.writeStartArray();
        writer.writeEndArray();
        assertEq(writer.value, "[]");
    }

    function testGenerateJSONEmptyObject() public {
        JsonWriter.Json memory writer;
        writer.writeStartObject();
        writer.writeEndObject();
        assertEq(writer.value, "{}");
    }

    // function testGenerateJSONMoreItems() public {
    //     MetadataBuilder.JSONItem[]
    //         memory attributes = new MetadataBuilder.JSONItem[](1);
    //     attributes[0].key = "minted_at";
    //     attributes[0].value = "23004025925";
    //     attributes[0].quote = false;

    //     MetadataBuilder.JSONItem[]
    //         memory items = new MetadataBuilder.JSONItem[](2);
    //     items[0].key = "testing";
    //     items[0].value = "okay";
    //     items[0].quote = true;
    //     items[1].key = "attributes";
    //     items[1].value = MetadataBuilder.generateJSON(attributes);
    //     items[1].quote = false;

    //     assertEq(
    //         MetadataBuilder.generateEncodedJSON(items),
    //         "data:application/json;base64,eyJ0ZXN0aW5nIjogIm9rYXkiLCJhdHRyaWJ1dGVzIjogeyJtaW50ZWRfYXQiOiAyMzAwNDAyNTkyNX19"
    //     );

    //     string memory jsonResult = MetadataBuilder.generateJSON(items);
    //     assertEq(
    //         jsonResult,
    //         '{"testing": "okay","attributes": {"minted_at": 23004025925}}'
    //     );
    //     vm.parseJson(jsonResult);
    // }
}
