const { expect } = require("chai");
const { ethers } = require("hardhat");
const { parseEther } = ethers.utils
const chai = require("chai");
const chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised);
const { assert } = require("chai");

describe("AmbassadorStaker", async function () {

  let ambassadorStakerInstance, erc721Instance, erc20TokenInstance;
  let deployer;
  let allAccounts;
  before(async () => {
    allAccounts = await ethers.getSigners();
    deployer = allAccounts[0];
    const ERC20Mock = await ethers.getContractFactory('ERC20Mock');
    erc20TokenInstance = await ERC20Mock.connect(deployer).deploy(
      "Cryption Network Token",
      "CNT",
      parseEther("1000")
    );

    const ERC721Impl = await ethers.getContractFactory('ERC721PresetMinterPauserAutoId')

    erc721Instance = await ERC721Impl.connect(deployer).deploy(
      "Cryption Network Ambassador Program",
      "CNTAP",
      "https://some_ipfs_url/"
    );


    const AmbassadorStaker = await ethers.getContractFactory("AmbassadorStaker");
    ambassadorStakerInstance = await AmbassadorStaker.deploy(
      erc20TokenInstance.address,
      erc721Instance.address,
      parseEther("10")
    );

    const minterRoleHash = await erc721Instance.MINTER_ROLE();
    await erc721Instance.connect(deployer).grantRole(minterRoleHash, ambassadorStakerInstance.address);
  });

  it("should mint successfully", async function () {
    const ambassador1 = allAccounts[1];
    await erc20TokenInstance.connect(deployer).transfer(ambassador1.address, parseEther("100"));
    await erc20TokenInstance.connect(ambassador1).approve(
      ambassadorStakerInstance.address,
      parseEther("100")
    );

    await ambassadorStakerInstance.connect(ambassador1).mint(ambassador1.address);
    
    const balance = await erc721Instance.balanceOf(ambassador1.address);
    
    await ambassadorStakerInstance.connect(ambassador1).mint(ambassador1.address);

    const balanceAfterMinting = await erc721Instance.balanceOf(ambassador1.address); 

    assert.equal(
      balanceAfterMinting.eq(2),
      true
    );
    const checkOwner = await erc721Instance.tokenURI(0);
    
    await erc721Instance.connect(ambassador1).setApprovalForAll(ambassadorStakerInstance.address, true);
    
    await ambassadorStakerInstance.connect(ambassador1).burn(1);
    const balanceAfterBurn = await erc721Instance.balanceOf(ambassador1.address); 
    assert.strictEqual(
      balanceAfterBurn.eq(1),
      true
    );
  });
});
