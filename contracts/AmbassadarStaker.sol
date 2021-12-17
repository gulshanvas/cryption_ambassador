pragma solidity 0.7.2;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/presets/ERC721PresetMinterPauserAutoId.sol";
import "./interface/IERC721Impl.sol";

contract AmbassadorStaker {
    using SafeMath for uint256;

    IERC20 public erc20Token;
    IERC721Impl public erc721Impl;
    uint256 public amountToBeLocked;

    constructor(
        IERC20 _erc20Token,
        IERC721Impl _erc721Impl,
        uint256 _amountToBeLocked
    ) {
        erc20Token = _erc20Token;
        erc721Impl = _erc721Impl;
        amountToBeLocked = _amountToBeLocked;
    }

    function mint(
        address to
    ) external {
        erc20Token.transferFrom(msg.sender, address(this), amountToBeLocked);

        erc721Impl.mint(to);
    }

    function burn(
        uint256 _tokenId
    ) public virtual {
        erc721Impl.burn(_tokenId);

        erc20Token.transfer(msg.sender, amountToBeLocked);
    }
}
