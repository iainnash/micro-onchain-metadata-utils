// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library MetadataJSONKeys {
   /// @notice 721 standard for name
   string constant keyName = "name";
   /// @notice 721 standard for description
   string constant keyDescription = "description";
   /// @notice 721 standard for image
   string constant keyImage = "image";
   /// @notice Opensea extension for rich content media
   string constant keyAnimationURL = "animation_url";
   /// @notice Opensea extension for external NFT website
   string constant keyExternalURL = "external_url";
   /// @notice Opensea extension for trait extension display
   string constant keyAttributes = "attributes";
   /// @notice 1155 standard for key-value properties
   string constant keyProperties = "properties";
}