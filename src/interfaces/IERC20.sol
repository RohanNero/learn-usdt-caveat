// SPDX-License-Identifier: GNU General Public License v3.0
pragma solidity ^0.8.13;

/**@notice ERC20 Interface that conforms to the EIP-20 standard correctly.  */
interface IERC20 {
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

    function transfer(address _to, uint256 _value) external returns (bool success);
    
    function approve(address _spender, uint256 _value) external returns (bool success);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function decimals() external view returns (uint8);
}


