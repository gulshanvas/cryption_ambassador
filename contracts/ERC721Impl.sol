// pragma solidity 0.7.2;

// // import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/presets/ERC721PresetMinterPauserAutoId.sol";

// /**
//  * @dev Extension of {ERC1155} that allows token holders to destroy both their
//  * own tokens and those that they have been approved to use.
//  *
//  * _Available since v3.1._
//  */
// contract ERC721Impl is ERC721PresetMinterPauserAutoId, Ownable {
//     using SafeMath for uint256;

//     mapping(address => bool) public whitelistedMinters;

//     modifier onlyWhitelistedMinters() {
//         require(
//             whitelistedMinters[msg.sender],
//             "Only whitelisted minter allowed"
//         );
//         _;
//     }

//     constructor(string memory uri_) ERC1155(uri_) {}

//     function burn(
//         address account,
//         uint256 id,
//         uint256 value
//     ) public virtual onlyWhitelistedMinters {
//         require(
//             account == _msgSender() || isApprovedForAll(account, _msgSender()),
//             "ERC1155: caller is not owner nor approved"
//         );

//         _burn(account, id, value);

//     }

//     function mint(
//         address to,
//         uint256 id,
//         uint256 value,
//         bytes memory data
//     ) external onlyWhitelistedMinters {
//         // beforeOperationCheck(value);

//         // uint256 yfDaiTokens = value.div(2);

//         _mint(to, id, value, data);
//     }

//     function whitelistMinter(address _newMinter) external onlyOwner {
//         require(_newMinter != address(0));
//         whitelistedMinters[_newMinter] = true;
//     }

// }
