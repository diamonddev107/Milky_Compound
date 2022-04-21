// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
contract CompoundVault is Ownable {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  event Deposit(address _sender, uint id);

  address yieldAddress;
  constructor(address _yield) {
    yieldAddress = _yield;
  }

  function deposit(
    uint256 len,
    address[10] memory tokenAddr,
    uint256[10] memory amount
  ) public returns (uint256) {
    require(len <= 10, "Too many token types");
    for (uint256 i = 0; i < len; i++) {
      require(tokenAddr[i] != address(0), "Token address should not be zero");
    }

    bool success = false;
    // receive tokens from user
    for (uint256 i = 0; i < len; i++) {
      IERC20 token = IERC20(tokenAddr[i]);
      success = token.transferFrom(_msgSender(), address(this), amount[i]);
      require(success, "Failed to receive token from user");
    }

    // create compound
    uint256 id = _counter;
    _counter = _counter + 1;

    owners[id] = _msgSender();
    componentLen[id] = len;
    for (uint256 i = 0; i < len; i++) {
      tokenAddrs[id][i] = tokenAddr[i];
      amounts[id][i] = amount[i];
    }

    emit Deposit(_msgSender(), id);

    return id;
  }


}
