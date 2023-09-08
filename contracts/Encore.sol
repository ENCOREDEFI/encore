// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

// Custom interface for IERC1363Receiver
interface IERC1363Receiver {
    function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4);
}

// Custom interface for IERC677Receiver
interface IERC677Receiver {
    function onTokenTransfer(address operator, address from, uint256 value, bytes calldata data) external;
}

contract ENCORE is ERC20, ERC20Snapshot, Ownable, ERC20Permit, ERC20Votes {
    constructor() ERC20("ENCORE", "ENC") ERC20Permit("ENCORE") {
        _mint(msg.sender, 3500000000 * 10 ** decimals());
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

    // Override the _burn function to resolve the conflict
    function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._burn(account, amount);
    }

    // The following functions are overrides required by Solidity.
    
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
        // Implement the logic you want when tokens are received.
        // For example, you can use the data to process additional information.
        // Return the ERC1363_RECEIVED value to indicate success.
        return IERC1363Receiver(address(0)).onTransferReceived.selector;
    }

    function onTokenTransfer(address operator, address from, uint256 value, bytes calldata data) external {
        // Implement the logic you want when tokens are received.
        // For example, you can use the data to process additional information.
    }
}