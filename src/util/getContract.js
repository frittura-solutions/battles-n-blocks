import Web3 from  "web3"
import { address, ABI } from "./constants/battlesBlocksContract"
let getContract = new Promise(function(resolve, reject) {
    let web3 = new Web3(window.web3.currentProvider)
    let battlesBlocksContract = web3.eth.contract(ABI)
    let battlesBlocksContractInstance = battlesBlocksContract.at(address)
    // battlesBlocksContractInstance = () => battlesBlocksContractInstance
    resolve(battlesBlocksContractInstance)
})
export default getContract