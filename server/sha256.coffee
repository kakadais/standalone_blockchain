SHA256 = require 'crypto-js/sha256'
{ faker } = require '@faker-js/faker'

@db = new Mongo.Collection 'bcDB'

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
    @createGenesisBlock()

  createGenesisBlock: ->
    if db.find().count() is 0
      genesisBlock = new Block 0, new Date(), 'Genesis block', '0'
      db.insert genesisBlock # Save the genesis block to MongoDB

  getLatestBlock: ->
    db.find({}, { sort: { index: -1 }, limit: 1 }).fetch()[0]

  addBlock: (newBlock) ->
    newBlock.previousHash = @getLatestBlock().hash
    newBlock.hash = newBlock.calculateHash()
    db.insert newBlock # Save the block to MongoDB after setting previousHash

  isChainValid: ->
    chain = db.find({}, { sort: { index: 1 } }).fetch()
    genesisBlock = chain[0]
    genesisHash = SHA256(genesisBlock.index + genesisBlock.previousHash + genesisBlock.timestamp + JSON.stringify(genesisBlock.data)).toString()
    return false if genesisBlock.hash != genesisHash

    for i in [1...(chain.length - 1)]
      currentBlock = chain[i]
      previousBlock = chain[i - 1]
      currentHash = SHA256(currentBlock.index + currentBlock.previousHash + currentBlock.timestamp + JSON.stringify(currentBlock.data)).toString()

      return false if currentBlock.hash != currentHash
      return false if currentBlock.previousHash != previousBlock.hash

    return true

# Testing the implementation
#db.remove({}) # to reset DB
myBlockchain = new BlockchainSha256()
count = 100000
if db.find().count() <= count
  [db.find().count()...count].forEach (i) ->
    if i % 1000 is 0 then cl i
    myBlockchain.addBlock new Block i, new Date(), faker.lorem.sentence()

#console.log 'Is blockchain valid? ' + myBlockchain.isChainValid()

# Tampering with the chain
#block = db.findOne({}, {skip:0})
#db.update block._id, $set: data: 'tampered'
#console.log 'Is blockchain valid after tampering? ' + myBlockchain.isChainValid()

# Printing the chain
#console.log JSON.stringify(myBlockchain, null, 4)
