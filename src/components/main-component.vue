<template>
    <div class="main container">
        <h1>Battles & Blocks</h1>
        <div class="event">
            <p v-if="hero.created"><i aria-hidden="true" class="fa "></i> {{hero.name}}</p>
            <div v-else><i aria-hidden="true" class="fa"></i>
                <ul>
                    <p>Create your Hero</p>
                    <input v-model="nameEntry" placeholder="Name">
                    <input v-model="strengthEntry" placeholder="Strength">
                    <input v-model="dexterityEntry" placeholder="Dexterity">
                    <input v-model="resistanceEntry" placeholder="Resistance">
                    <input v-model="magicEntry" placeholder="Magic">
                    <li v-on:click="createHero">Create</li>
                </ul>
            </div>
            <p>{{log}}</p>
            <div v-for="(item, key) in heroDict">
                <div style="border-style:solid;border-top-width: 10px;">
                    <p>{{item[0]}} HP: {{item[6]}} (Block {{item[1]}})</p>
                    <p>{{key}}
                        <button v-if="key != coinbase" @click="attackHero(key)">Attack!</button>
                    </p>
                    <p>Str: {{item[2]}} Dex: {{item[3]}} Res: {{item[4]}} Mag: {{item[5]}}</p>
                </div>
            </div>
            <li v-on:click="heroCount">List</li>
        </div>
    </div>
</template>
<script>
import { mapState } from 'vuex'
export default {
    name: 'main-component',
    data() {
        return {
            nameEntry: null,
            heroDict: {},
            strengthEntry: null,
            dexterityEntry: null,
            resistanceEntry: null,
            magicEntry: null,
            pending: false,
            log: ""
        }
    },
    computed: mapState({
        coinbase: state => state.web3.coinbase,
        hero: state => state.hero
    }),
    methods: {
        createHero(event) {
            console.log('Creating Hero: name', this.nameEntry);
            //console.log(this.$store.state.contractInstance());
            this.pending = true
            let amount = parseInt(this.strengthEntry) + parseInt(this.dexterityEntry) + parseInt(this.resistanceEntry) + parseInt(this.magicEntry);
            console.log("Value: ", amount);
            this.$store.state.contractInstance().newHero(this.nameEntry, this.strengthEntry, this.dexterityEntry, this.resistanceEntry, this.magicEntry, {
                gas: 300000,
                value: this.$store.state.web3.web3Instance().toWei(amount, 'ether'),
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
                            this.pending = false
                            console.log('New hero created succesfully', result)
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
                    let tot = result.c[0];
                    console.log("there are ", tot, " heores")
                    this.heroDict = {};
                    for (var i = 0; i < tot; i++) {
                        this.$store.state.contractInstance().getHeroAtIndex(i, {}, (err, result) => {
                            if (err) {
                                console.log(err)
                            } else {
                                console.log(result);
                                this.$store.state.contractInstance().heroes(result, {}, (err, stats) => {
                                    if (err) {
                                        console.log(err)
                                    } else {
                                        console.log(this.heroDict, result, stats)
                                        this.$set(this.heroDict, result, stats)
                                    }
                                })

                            }
                        })
                    }
                }
            })
        },
        attackHero(target) {
            console.log(this.coinbase, " is attacking ", target)
            this.$store.state.contractInstance().attack(target, {
                gas: 300000,
                from: this.$store.state.web3.coinbase
            }, (err, result) => {
                if (err) {
                    console.log(err)
                } else {
                    let LogAttack = this.$store.state.contractInstance().LogAttack()
                    LogAttack.watch((err, result) => {
                        if (err) {
                            console.log('could not get event LogAttack()')
                        } else {
                            console.log('Attack succesfull', result.args)
                            this.log = result.args
                            this.$store.state.contractInstance().heroes(target, {}, (err, stats) => {
                                if (err) {
                                    console.log(err)
                                } else {
                                    this.$set(this.heroDict, target, stats)
                                }
                            })
                        }
                    })
                }
            })
        }
    },
    mounted() {
        // console.log('dispatching getContractInstance')
        // this.$store.dispatch('getContractInstance')
        //this.$store.dispatch('pollWeb3')
        //this.heroCount(null);

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