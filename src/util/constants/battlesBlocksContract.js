const address = '0x4642221d30869861e3f12eedfb0e7f3654fd17c8'; //GANACHE
//const address = '0xcd697055a945ad2739d85550cd143c2dcb544811'; //SKALE

const ABI = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "target",
				"type": "address"
			}
		],
		"name": "attack",
		"outputs": [
			{
				"name": "res",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "changeOwner",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "name",
				"type": "string"
			},
			{
				"name": "strength",
				"type": "uint256"
			},
			{
				"name": "dexterity",
				"type": "uint256"
			},
			{
				"name": "resistance",
				"type": "uint256"
			},
			{
				"name": "magic",
				"type": "uint256"
			}
		],
		"name": "newHero",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "key",
				"type": "address"
			}
		],
		"name": "remHero",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "name",
				"type": "string"
			}
		],
		"name": "updateHero",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "sender",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "name",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "position",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "strength",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "dexterity",
				"type": "uint256"
			}
		],
		"name": "LogNewHero",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "sender",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "name",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "position",
				"type": "uint256"
			}
		],
		"name": "LogUpdateHero",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "key",
				"type": "address"
			}
		],
		"name": "LogRemHero",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "attacker",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "target",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "damage",
				"type": "uint256"
			}
		],
		"name": "LogAttack",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "sender",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "LogNewOwner",
		"type": "event"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "key",
				"type": "address"
			}
		],
		"name": "getHero",
		"outputs": [
			{
				"name": "name",
				"type": "string"
			},
			{
				"name": "position",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "getHeroAtIndex",
		"outputs": [
			{
				"name": "key",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getHeroCount",
		"outputs": [
			{
				"name": "count",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "heroes",
		"outputs": [
			{
				"name": "name",
				"type": "string"
			},
			{
				"name": "position",
				"type": "uint256"
			},
			{
				"name": "strength",
				"type": "uint256"
			},
			{
				"name": "dexterity",
				"type": "uint256"
			},
			{
				"name": "resistance",
				"type": "uint256"
			},
			{
				"name": "magic",
				"type": "uint256"
			},
			{
				"name": "HP",
				"type": "uint256"
			},
			{
				"name": "value",
				"type": "uint256"
			},
			{
				"name": "exp",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];
export {address, ABI}