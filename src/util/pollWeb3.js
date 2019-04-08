import Web3 from 'web3'
import { store } from '../store/'

let pollWeb3 = function(state) {
    let web3 = window.web3
    web3 = new Web3(web3.currentProvider)

    setInterval(() => {
        if (web3 && store.state.web3.web3Instance) {
            if (store.state.contractInstance) {
                store.state.contractInstance().getHero(store.state.web3.coinbase, {}, (err, result) => {
                    if (err) {
                        //console.log(err)
                        store.dispatch('pollWeb3', {
                            coinbase: store.state.web3.coinbase,
                            balance: store.state.web3.balance,
                            name: null,
                            position: null,
                            created: false
                        })
                    } else {
                        store.dispatch('pollWeb3', {
                            coinbase: store.state.web3.coinbase,
                            balance: store.state.web3.balance,
                            name: result[0],
                            position: result[1].c[0],
                            created: true
                        })
                    }
                })

            }

            if (web3.eth.coinbase !== store.state.web3.coinbase) {
                let newCoinbase = web3.eth.coinbase
                web3.eth.getBalance(web3.eth.coinbase, function(err, newBalance) {
                    if (err) {
                        console.log(err)
                    } else {
                        store.dispatch('pollWeb3', {
                            coinbase: newCoinbase,
                            balance: parseInt(newBalance, 10),
                            name: store.state.hero.name,
                            position: store.state.hero.position,
                            created: store.state.hero.created
                        })
                    }
                })
            } else {
                web3.eth.getBalance(store.state.web3.coinbase, (err, polledBalance) => {
                    if (err) {
                        console.log(err)
                    } else if (parseInt(polledBalance, 10) !== store.state.web3.balance) {
                        store.dispatch('pollWeb3', {
                            coinbase: store.state.web3.coinbase,
                            balance: polledBalance,
                            name: store.state.hero.name,
                            position: store.state.hero.position,
                            created: store.state.hero.created
                        })
                    }
                })
            }
        }
    }, 500)
}

export default pollWeb3