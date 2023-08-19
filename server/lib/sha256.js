// const SHA256 = require('crypto-js/sha256');
//
// class Block {
//     constructor(index, timestamp, data, previousHash = '') {
//         this.index = index;
//         this.timestamp = timestamp;
//         this.data = data;
//         this.previousHash = previousHash;
//         this.hash = this.calculateHash();
//     }
//
//     calculateHash() {
//         return SHA256(this.index + this.previousHash + this.timestamp + JSON.stringify(this.data)).toString();
//     }
// }
// class BlockchainSha256 {
//     constructor() {
//         this.chain = [this.createGenesisBlock()];
//     }
//
//     createGenesisBlock() {
//         return new Block(0, '01/01/2023', 'Genesis block', '0');
//     }
//
//     getLatestBlock() {
//         return this.chain[this.chain.length - 1];
//     }
//
//     addBlock(newBlock) {
//         newBlock.previousHash = this.getLatestBlock().hash;
//         newBlock.hash = newBlock.calculateHash();
//         this.chain.push(newBlock);
//     }
//
//     isChainValid() {
//         for (let i = 1; i < this.chain.length; i++) {
//             const currentBlock = this.chain[i];
//             const previousBlock = this.chain[i - 1];
//
//             if (currentBlock.hash !== currentBlock.calculateHash()) {
//                 return false;
//             }
//
//             if (currentBlock.previousHash !== previousBlock.hash) {
//                 return false;
//             }
//         }
//
//         return true;
//     }
// }
// // Testing the implementation
// this.myBlockchain = new BlockchainSha256();
// myBlockchain.addBlock(new Block(1, '03/23/2023', { amount: 4 }));
// myBlockchain.addBlock(new Block(2, '03/24/2023', { amount: 10 }));
//
// console.log('Is blockchain valid? ' + myBlockchain.isChainValid());
//
// // Tampering with the chain
// myBlockchain.chain[1].data = { amount: 100 };
// myBlockchain.chain[1].hash = myBlockchain.chain[1].calculateHash();
//
// console.log('Is blockchain valid after tampering? ' + myBlockchain.isChainValid());
//
// // Printing the chain
// // console.log(JSON.stringify(myBlockchain, null, 4));
