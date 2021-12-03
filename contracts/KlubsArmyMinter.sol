pragma solidity ^0.5.6;

import "./klaytn-contracts/ownership/Ownable.sol";
import "./klaytn-contracts/math/SafeMath.sol";
import "./interfaces/IMix.sol";
import "./KlubsArmy.sol";

contract KlubsArmyMinter is Ownable {
    using SafeMath for uint256;

    KlubsArmy public nft = KlubsArmy(0x7cBF6b413722cb84672516027A8bA97bd4A6b58F);
    IMix public mix = IMix(0xDd483a970a7A7FeF2B223C3510fAc852799a88BF);
    uint256 public mintPrice = 18 * 1e18;
    address public feeTo = 0x22A8a7e06303AEcd8Af5DDB89a827edDB493dac0;

    function setMintPrice(uint256 _price) external onlyOwner {
        mintPrice = _price;
    }

    function setFeeTo(address _feeTo) external onlyOwner {
        feeTo = _feeTo;
    }

    uint256 public limit;

    function setLimit(uint256 _limit) external onlyOwner {
        limit = _limit;
    }

    function mint(uint256 count) external {
        require(count <= limit);
        uint256 totalSupply = nft.totalSupply();
        nft.massMint(msg.sender, totalSupply + 1, totalSupply + count);
        mix.transferFrom(msg.sender, feeTo, mintPrice.mul(count));
        limit = limit.sub(count);
    }
}
