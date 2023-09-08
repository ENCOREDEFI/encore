// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

interface IERC1363Receiver {
    function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4);
}

interface IERC677Receiver {
    function onTokenTransfer(address operator, address from, uint256 value, bytes calldata data) external;
}

contract ENCORE is ERC20, ERC20Snapshot, Ownable, ERC20Permit, ERC20Votes {
    string constant private _name = "ENCORE";
    string constant private _symbol = "ENC";
    uint8 constant private _decimals = 18;
    uint256 constant private _initialSupply = 3_500_000_000 * (10 ** uint256(_decimals));

    constructor() ERC20(_name, _symbol) ERC20Permit(_name) {
        _mint(msg.sender, _initialSupply);
    }

    function snapshot() public onlyOwner {
        _snapshot();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Snapshot)
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._burn(account, amount);
    }

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function onTransferReceived(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return IERC1363Receiver(address(0)).onTransferReceived.selector;
    }

    function onTokenTransfer(address operator, address from, uint256 value, bytes calldata data) external {
    }
}