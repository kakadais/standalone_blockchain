SHA256 = require 'crypto-js/sha256'
{ faker } = require '@faker-js/faker'

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
    new Block 0, '01/01/2023', 'Genesis block', '0'

  getLatestBlock: ->
    @chain[@chain.length - 1]

  addBlock: (newBlock) ->
    newBlock.previousHash = @getLatestBlock().hash
    newBlock.hash = newBlock.calculateHash()
    @chain.push newBlock

  isChainValid: ->
    for i in [1...@chain.length]
      currentBlock = @chain[i]
      previousBlock = @chain[i - 1]

      return false if currentBlock.hash != currentBlock.calculateHash()
      return false if currentBlock.previousHash != previousBlock.hash

    return true

# Testing the implementation
myBlockchain = new BlockchainSha256()
for i in [0...100000]
  myBlockchain.addBlock new Block i, new Date(), faker.lorem.sentence()

console.log 'Is blockchain valid? ' + myBlockchain.isChainValid()

# Tampering with the chain
myBlockchain.chain[1].data = amount: 100
myBlockchain.chain[1].hash = myBlockchain.chain[1].calculateHash()

console.log 'Is blockchain valid after tampering? ' + myBlockchain.isChainValid()

# Printing the chain
# console.log JSON.stringify(myBlockchain, null, 4)
