pragma solidity 0.7.2;

interface IERC721Impl {
    function mint(
        address _to
    ) external;

    function burn(
        uint256 _tokenId
    ) external;
}
