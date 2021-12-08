pragma solidity 0.7.2;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/IERC1155Impl.sol";

contract AmbassadorStaker {
    using SafeMath for uint256;

    IERC20 public erc20Token;
    IERC1155Impl public erc1155Impl;

    constructor(
        string memory uri_,
        IERC20 _erc20Token,
        IERC1155Impl _erc1155Impl
    ) {
        erc20Token = _erc20Token;
        erc1155Impl = _erc1155Impl;
    }

    function mint(
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) external {
        beforeOperationCheck(value);

        uint256 yfDaiTokens = value.div(2);
        erc1155Impl.mint(to, id, yfDaiTokens, data);
    }

    function burn(
        address account,
        uint256 id,
        uint256 value
    ) public virtual {
        // require(
        //     account == _msgSender() || isApprovedForAll(account, _msgSender()),
        //     "ERC1155: caller is not owner nor approved"
        // );

        erc1155Impl.burn(account, id, value);

        erc20Token.transfer(account, value.mul(2));
    }

    function beforeOperationCheck(uint256 _amount) private {
        (bool status, uint256 remainder) = _amount.tryMod(2);

        require(status && remainder == 0, "Amount must be multiple of 2");

        require(
            erc20Token.transferFrom(msg.sender, address(this), _amount),
            "Token amount must be approved"
        );
    }
}
