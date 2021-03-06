pragma solidity 0.5.1; 

/* 
Hitchens UnorderedAddressSet v0.92

Library for managing CRUD operations in dynamic address sets.

https://github.com/rob-Hitchens/UnorderedKeySet

Copyright (c), 2019, Rob Hitchens, the MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

THIS SOFTWARE IS NOT TESTED OR AUDITED. DO NOT USE FOR PRODUCTION.
*/

import "./Ownable.sol";
import "./HitchensUnorderedAddressSetLib.sol";

contract HitchensUnorderedAddressSet {
    
    using HitchensUnorderedAddressSetLib for HitchensUnorderedAddressSetLib.Set;
    HitchensUnorderedAddressSetLib.Set set;
    
    event LogUpdate(address sender, string action, address key);
    
    function exists(address key) public view returns(bool) {
        return set.exists(key);
    }
    
    function insert(address key) public {
        set.insert(key);
        emit LogUpdate(msg.sender, "insert", key);
    }
    
    function remove(address key) public {
        set.remove(key);
        emit LogUpdate(msg.sender, "remove", key);
    }
    
    function count() public view returns(uint) {
        return set.count();
    }
    
    function keyAtIndex(uint index) public view returns(address) {
        return set.keyAtIndex(index);
    }
    
    function nukeSet() public {
        set.nukeSet();
    }
}
