pragma solidity 0.7.2;

interface IERC1155Impl {
    function mint(
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) external;

    function burn(
        address account,
        uint256 id,
        uint256 value
    ) external;
}
