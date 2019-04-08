<template>
    <div class="main container">
        <h1>Battles & Blocks</h1>
        <div class="event">
            <div v-if="heroCreated" style="border-style:solid;border-color: red;">
                <p>{{hero.name}} HP: {{hero.HP}} (Block {{hero.position}})</p>
                <p>Str: {{hero.strength}} Dex: {{hero.dexterity}} Res: {{hero.resistance}} Mag: {{hero.magic}}</p>
            </div>
            <div v-else><i aria-hidden="true" class="fa"></i>
                <ul>
                    <div>
                        <input v-model="nameEntry" placeholder="Name">
                        <input v-model="strengthEntry" placeholder="Strength">
                        <input v-model="dexterityEntry" placeholder="Dexterity">
                        <input v-model="resistanceEntry" placeholder="Resistance">
                        <input v-model="magicEntry" placeholder="Magic">
                    </div>
                    <li v-on:click="createHero">Create your Hero</li>
                </ul>
            </div>
            <p>{{log}}</p>
            <div v-for="(item, key) in heroDict">
                <div v-if="key != coinbase" style="border-style:solid;border-top-width: 10px;">
                    <p>{{item.name}} HP: {{item.HP}} (Block {{item.position}})</p>
                    <p>{{key}}
                        <button @click="attackHero(key)">Attack!</button>
                    </p>
                    <p>Str: {{item.strength}} Dex: {{item.dexterity}} Res: {{item.resistance}} Mag: {{item.magic}}</p>
                </div>
            </div>
            <!-- <li v-on:click="heroCount">List</li> -->
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
        heroCreated: state => state.hero.created,
        contract: state => state.contractInstance,
        hero: function() {
            if (!this.heroCreated) {
                return {
                    name: "",
                    position: "",
                    strength: "",
                    dexterity: "",
                    resistance: "",
                    magic: "",
                    HP: "",
                    exp: ""
                }
            }
            return this.heroDict[this.coinbase]
        }
    }),
    watch: {
        contract: function() {
            this.heroCount(null)
        }
    },
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
                                        let statsDict = {
                                            name: stats[0],
                                            position: stats[1],
                                            strength: stats[2],
                                            dexterity: stats[3],
                                            resistance: stats[4],
                                            magic: stats[5],
                                            HP: stats[6],
                                            exp: stats[7]
                                        }
                                        this.$set(this.heroDict, result, statsDict)
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
                                    let statsDict = {
                                        name: stats[0],
                                        position: stats[1],
                                        strength: stats[2],
                                        dexterity: stats[3],
                                        resistance: stats[4],
                                        magic: stats[5],
                                        HP: stats[6],
                                        exp: stats[7]
                                    }
                                    this.$set(this.heroDict, target, statsDict)
                                }
                            })
                        }
                    })
                }
            })
        }
    },
    mounted() {
        //this.heroCount(null);
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