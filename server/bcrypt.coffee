bcrypt = require 'bcrypt'
{ faker } = require '@faker-js/faker'
saltRounds = 10

@db = new Mongo.Collection 'sbcDB'
db._ensureIndex({index: 1})
db.remove({})

class Block
  constructor: (index, timestamp, data, previousHash = '') ->
    @index = index
    @timestamp = timestamp
    @data = data
    @previousHash = previousHash
    @hash = @calculateHash()


  calculateHash: () ->
    plainText = @index + @previousHash + @timestamp + JSON.stringify(@data)
    @hash = bcrypt.hashSync plainText, saltRounds

class BlockchainBcrypt
  constructor: () ->
    @createGenesisBlock()

  createGenesisBlock: () ->
    if db.find().count() is 0
      genesisBlock = new Block 0, new Date(), 'Genesis block', '0'
      db.insert genesisBlock # Save the genesis block to MongoDB

  getLatestBlock: () ->
    db.findOne({}, { sort: { index: -1 }})

  addBlock: (newBlock) ->
    newBlock.previousHash = @getLatestBlock().hash
    newBlock.hash = newBlock.calculateHash()
    db.insert newBlock # Save the block to MongoDB after setting previousHash

  isChainValid: (_count) ->
    count = _count or db.find().count()
    previousBlock = null

    for i in [0...count]
      if i % 1000 is 0 then cl "validating count: #{i}"
      currentBlock = db.findOne({ index: i })

      # Check genesis block hash
      if i == 0
        genesisHash = SHA256(currentBlock.index + currentBlock.previousHash + currentBlock.timestamp + JSON.stringify(currentBlock.data)).toString()
        return false if currentBlock.hash != genesisHash
#        return false if bcrypt.compareSync currentBlock.previousHash,
      else
        currentHash = SHA256(currentBlock.index + currentBlock.previousHash + currentBlock.timestamp + JSON.stringify(currentBlock.data)).toString()
        return false if currentBlock.hash != currentHash
        return false if currentBlock.previousHash != previousBlock.hash

      previousBlock = currentBlock

    return true

## Testing the implementation
myBlockchain = new BlockchainBcrypt()
count = 5
if db.find().count() <= count
  [db.find().count()...count].forEach (i) ->
    if i % 1000 is 0 then cl i
    myBlockchain.addBlock new Block i, new Date(), faker.lorem.sentence()
#
#console.log 'Is blockchain valid? ' + myBlockchain.isChainValid()
#
## Tampering with the chain
#myBlockchain.chain[1].data = { amount: 100 }
#myBlockchain.chain[1].hash = myBlockchain.chain[1].calculateHash()
#
#console.log 'Is blockchain valid after tampering? ' + myBlockchain.isChainValid()
#
## Printing the chain
#console.log JSON.stringify myBlockchain, null, 4