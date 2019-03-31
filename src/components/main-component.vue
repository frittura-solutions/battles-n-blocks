<template>
    <div class="main container">
        <h1>Battles & Blocks</h1>
        <h4>Create your Hero</h4>
        <input v-model="name" placeholder="Gesu'">
        <input v-model="amount" placeholder="Value 1 ETH">
        <ul>
            <li v-on:click="createHero">Create</li>
            <li v-on:click="heroCount">Count</li>
        </ul>
        <!-- <div class="event" v-if="winEvent">
      <p v-if="winEvent._status" id="has-won"><i aria-hidden="true" class="fa fa-check"></i> Congragulations, you have won {{winEvent._amount}} wei</p>
      <p v-else id="has-lost"><i aria-hidden="true" class="fa fa-times"></i> Sorry you lost, try again.</p>
    </div> -->
    </div>
</template>
<script>
export default {
    name: 'main-component',
    data() {
        return {
            name: null,
            amount: null,
            pending: false
        }
    },
    methods: {
        createHero(event) {
            console.log('Creating Hero: name', this.name, " Value: ", this.amount);
            console.log(this.$store.state.contractInstance());
            this.pending = true
            this.$store.state.contractInstance().newHero(this.name, 5, 5, {
                gas: 300000,
                value: this.$store.state.web3.web3Instance().toWei(this.amount, 'ether'),
                from: this.$store.state.web3.coinbase
            }, (err, result) => {
                if (err) {

                    console.log(err)
                    this.pending = false
                } else {
                    let LogNewHero = this.$store.state.contractInstance().LogNewHero()
                    LogNewHero.watch((err, result) => {
                        if (err) {
                            console.log('could not get event LogNewHero()')
                        } else {
                            this.newHeroEvent = result.args
                            this.newHeroEvent.name = name
                            this.pending = false
                        }
                    })
                }
            })
        },
        heroCount(event) {
            //this.$store.dispatch('getContractInstance')
            this.$store.state.contractInstance().getHeroCount({}, (err, result) => {
                if (err) {
                    console.log(err)
                } else {
                    console.log(result)
                }
            })
            this.$store.state.contractInstance().owner({}, (err, result) => {
                if (err) {
                    console.log(err)
                } else {
                    console.log(result)
                }
            })
        }
    },
    mounted() {
        console.log('dispatching getContractInstance')
        this.$store.dispatch('getContractInstance')
    }
}
</script>
<style scoped>
.main {
    margin-top: 50px;
    text-align: center;
}

#loader {
    width: 150px;
}

ul {
    margin: 25px;
    list-style-type: none;
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    grid-column-gap: 25px;
    grid-row-gap: 25px;
}

li {
    padding: 20px;
    margin-right: 5px;
    border-radius: 20%;
    cursor: pointer;
    background-color: #ffff01;
    border: -2px solid #bfad2b;
    color: black;
    box-shadow: 4px 5px #bfad2b;
}

li:hover {
    background-color: #bccd9b;
    color: black;
    box-shadow: 0px 0px #df0d9b;
}

li:active {
    opacity: 0.7;
}

* {
    color: #444444;
}
</style>