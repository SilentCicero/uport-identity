# uPort Identity Contracts
[![npm](https://img.shields.io/npm/v/npm.svg)](https://www.npmjs.com/package/uport-identity)
![CircleCI](https://img.shields.io/circleci/project/github/uport-project/uport-identity.svg)
[![solidity-coverage](https://img.shields.io/badge/coverage-96.64%25-green.svg)](https://uport-project.github.io/uport-identity/coverage)

Please read our [Whitepaper](http://whitepaper.uport.me) for information on what uPort is, and what is currently possible as far as integration.

## Contract Deployments
### Mainnet (id: 1)
|Contract|Address|
| --|--|
|ArrayLib|[0x5bfa4582b0c48cb375b9e8322b57ac025965c148](https://etherscan.io/address/0x5bfa4582b0c48cb375b9e8322b57ac025965c148)|
|IdentityFactory|[0x12e627125abcfa989de831572f198577780d7127](https://etherscan.io/address/0x12e627125abcfa989de831572f198577780d7127)|
|IdentityFactoryWithRecoveryKey|(not deployed)|

### Ropsten testnet (id: 3)
|Contract|Address|
| --|--|
|ArrayLib|[0x957eb298a72167367fa210fc1aa3faba1d2b629c](https://ropsten.etherscan.io/address/0x957eb298a72167367fa210fc1aa3faba1d2b629c)|
|IdentityFactory|[0x1c9d9e1962985c9b8101777cae25c46279fe2a9c](https://ropsten.etherscan.io/address/0x1c9d9e1962985c9b8101777cae25c46279fe2a9c)|
|IdentityFactoryWithRecoveryKey|[0xb7d66b18fbe8eb655ce7daa5d616d908c25c32a7](https://ropsten.etherscan.io/address/0xb7d66b18fbe8eb655ce7daa5d616d908c25c32a7)|

### Rinkeby testnet (id: 4)
|Contract|Address|
| --|--|
|ArrayLib|[0xb8a00506e12d39522cd1787389ae8f83db536e46](https://rinkeby.etherscan.io/address/0xb8a00506e12d39522cd1787389ae8f83db536e46)|
|IdentityFactory|[0x6a841ba0ea1a88cfbc085220fc6b65973afca431](https://rinkeby.etherscan.io/address/0x6a841ba0ea1a88cfbc085220fc6b65973afca431)|
|IdentityFactoryWithRecoveryKey|[0xd7dc3926bc6089a5be4815215ceaa6e707591023](https://rinkeby.etherscan.io/address/0xd7dc3926bc6089a5be4815215ceaa6e707591023)|

### Kovan testnet (id: 42)
|Contract|Address|
| --|--|
|ArrayLib|[0x6a841ba0ea1a88cfbc085220fc6b65973afca431](https://kovan.etherscan.io/address/0x6a841ba0ea1a88cfbc085220fc6b65973afca431)|
|IdentityFactory|[0xd7dc3926bc6089a5be4815215ceaa6e707591023](https://kovan.etherscan.io/address/0xd7dc3926bc6089a5be4815215ceaa6e707591023)|
|IdentityFactoryWithRecoveryKey|[0xdc420f5d89ef5c729c63cf05b0ceda364d5a8b1d](https://kovan.etherscan.io/address/0xdc420f5d89ef5c729c63cf05b0ceda364d5a8b1d)|


## Using the contracts
To use the contract we provide truffle artifacts. You can use `truffle-contract` to utilize these.
```javascript
const uportIdentity = require('uport-identity')
const Contract = require('truffle-contract')

let IdentityFactory = Contract(uportIdentity.IdentityFactory)
IdentityFactory.setProvider(web3.currentProvider)
let identityFactory = IdentityFactory.deployed()
```
You can also use web3.
```javascript
let networkId = 1 // Mainnet
let IdentityFactory = web3.eth.contract(uportIdentity.IdentityFactory.abi)
let identityFactory = IdentityFactory.at(uportIdentity.IdentityFactory.networks[networkId].address)
```

## Contracts
This repository contains the contracts currently in use by uPort. This is also where you find the addresses of these contracts currently deployed on Mainnet and relevant test networks. Below you can find descriptions of each of the contracts and the rationale behind the design decisions.

### [Proxy](./docs/proxy.md)
### [TxRelay](./docs/txRelay.md)
### [IdentityManager](./docs/identityManager.md)

## Contributing
Want to contribute to uport-contracts? Cool, please read our [contribution guidelines](./CONTRIBUTING.md) to get an understanding of the process we use for making changes to this repo.
