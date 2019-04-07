import Web3 from 'web3'
import { store } from '../store/'

let initHero = function(state) {
    let web3 = window.web3
    web3 = new Web3(web3.currentProvider)
    if (web3 && store.state.web3.web3Instance) {
        if (store.state.contractInstance) {
            store.state.contractInstance().getHero(store.state.web3.coinbase, {}, (err, result) => {
                if (err) {
                    console.log(err)
                    store.dispatch('pollWeb3', {
                        coinbase: newCoinbase,
                        balance: parseInt(newBalance, 10),
                        name: null,
                        position: null,
                        created: false
                    })
                } else {
                    store.dispatch('pollWeb3', {
                        coinbase: newCoinbase,
                        balance: parseInt(newBalance, 10),
                        name: result[0],
                        position: result[1].c[0],
                        created: true
                    })
                }
            })
        }
    }

}

export default initHero