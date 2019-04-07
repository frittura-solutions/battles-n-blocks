const BB = artifacts.require('BattlesNBlocks')
const Ownable = artifacts.require('Ownable')
const Util = artifacts.require('Util')

const HitchensUnorderedAddressSetLib = artifacts.require('HitchensUnorderedAddressSetLib')
//const HitchensUnorderedAddressSet = artifacts.require('HitchensUnorderedAddressSet')

module.exports = function(deployer) {
	deployer.deploy(Ownable)
    deployer.deploy(Util)
    deployer.deploy(HitchensUnorderedAddressSetLib)
    
}