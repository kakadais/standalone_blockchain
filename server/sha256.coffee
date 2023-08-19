SHA256 = require 'crypto-js/sha256'
{ faker } = require '@faker-js/faker'

db = new Mongo.Collection 'bcDB'
db.remove({})


class Block
  constructor: (index, timestamp, data, previousHash = '') ->
    @index = index
    @timestamp = timestamp
    @data = data
    @previousHash = previousHash
    @hash = @calculateHash()

  calculateHash: ->
    SHA256(@index + @previousHash + @timestamp + JSON.stringify(@data)).toString()

class BlockchainSha256
  constructor: ->
    @chain = [@createGenesisBlock()]

  createGenesisBlock: ->
    genesisBlock = new Block 0, new Date(), 'Genesis block', '0'
    db.insert genesisBlock # Save the genesis block to MongoDB
    return genesisBlock

  getLatestBlock: ->
    @chain[@chain.length - 1]

  addBlock: (newBlock) ->
    newBlock.previousHash = @getLatestBlock().hash
    newBlock.hash = newBlock.calculateHash()
    @chain.push newBlock
    db.insert newBlock # Save the block to MongoDB after setting previousHash

  isChainValid: ->
    for i in [1...@chain.length]
      currentBlock = @chain[i]
      previousBlock = @chain[i - 1]

      return false if currentBlock.hash != currentBlock.calculateHash()
      return false if currentBlock.previousHash != previousBlock.hash

    return true

# Testing the implementation
myBlockchain = new BlockchainSha256()
for i in [1..10]
  myBlockchain.addBlock new Block i, new Date(), faker.lorem.sentence()

console.log 'Is blockchain valid? ' + myBlockchain.isChainValid()

# Tampering with the chain
myBlockchain.chain[1].data = amount: 100
myBlockchain.chain[1].hash = myBlockchain.chain[1].calculateHash()

console.log 'Is blockchain valid after tampering? ' + myBlockchain.isChainValid()

# Printing the chain
console.log JSON.stringify(myBlockchain, null, 4)
