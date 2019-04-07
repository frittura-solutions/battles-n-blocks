<template>
    <div class="main container">
        <h1>Battles & Blocks</h1>
        <!-- <ul>
            <li v-on:click="createHero">Create</li>
            <li v-on:click="heroCount">Count</li>
        </ul> -->
        <!-- <p><i aria-hidden="true"></i> {{heroName}}: Block {{heroPosition}}</p> -->
        <div class="event">
            <p v-if="hero.created"><i aria-hidden="true" class="fa "></i> {{hero.name}}: Block {{hero.position}}</p>
            <div v-else><i aria-hidden="true" class="fa"></i>
                <ul>
                    <p>Create your Hero</p>
                    <input v-model="nameEntry" placeholder="Gesu'">
                    <input v-model="strengthEntry" placeholder="0">
                    <input v-model="dexterityEntry" placeholder="0">
                    <input v-model="resistanceEntry" placeholder="0">
                    <input v-model="magicEntry" placeholder="0">
                    <li v-on:click="createHero">Create</li>
                </ul>
            </div>
            <li v-on:click="heroCount">List</li>
            <span v-html="heroList"></span>
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
            heroList: "<p></p>",
            strengthEntry: null,
            dexterityEntry: null,
            resistanceEntry: null,
            magicEntry: null,
            pending: false
        }
    },
    computed: mapState({
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
                        }
                    })
                }
            })
        },
        heroCount(event) {
            //this.$store.dispatch('getContractInstance')
            let tot = 0;
            this.heroList = "<p></p>";
            this.$store.state.contractInstance().getHeroCount({}, (err, result) => {
                if (err) {
                    console.log(err)
                } else {

                    tot = result.c[0];
                    console.log("there are ", tot, " heores")
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
                                        this.heroList += `<p>${result} ${stats}</p>`;
                                        if (result != this.$store.state.web3.coinbase) {
                                            this.heroList += `<button v:on-click="${this.attackHero(this, result)}" >Attack!</button>`;
                                        }
                                    }
                                })

                            }
                        })
                    }
                }
            })
            // this.$store.state.contractInstance().getHero(this.$store.state.web3.coinbase, {}, (err, result) => {
            //     if (err) {
            //         console.log(err)
            //     } else {
            //         console.log(result);
            //     }
            // })
            console.log(this.hero);

        },
        attackHero(event, target) {
            console.log("attacking ", target);
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