// SPDX-License-Identifier: GNU General Public License v3.0
pragma solidity ^0.8.13;

/**@notice Since USDT doesn't follow the ERC-20 standard by returning a bool on transfer we need an interface to interact with it.  */
interface IUSDT {
    function transferFrom(address _from, address _to, uint256 _value) external;

    function transfer(address _to, uint256 _value) external;
    
    function approve(address _spender, uint256 _value) external;

    function balanceOf(address _owner) external view returns (uint256 balance);

    function decimals() external view returns (uint8);
}


