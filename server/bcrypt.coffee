bcrypt = require 'bcrypt'
{ faker } = require '@faker-js/faker'

db = new Mongo.Collection 'sbcDB'
db._ensureIndex({index: 1})
#db.remove({})

saltRounds = 1

class Block
  constructor: (index, timestamp, data, previousHash = '') ->
    @index = index
    @timestamp = timestamp
    @data = data
    @previousHash = previousHash
    [hash, salt] = @calculateHash()
    @hash = hash
    @salt = salt

  calculateHash: ->
    salt = bcrypt.genSaltSync(saltRounds)
    hash = bcrypt.hashSync(@index + @previousHash + @timestamp + JSON.stringify(@data), salt)
    return [hash, salt]

class BlockchainBcrypt
  constructor: ->
    @createGenesisBlock()

  createGenesisBlock: ->
    if db.find().count() is 0
      genesisBlock = new Block 0, new Date(), 'Genesis block', '0'
      db.insert(genesisBlock)

  getLatestBlock: ->
    db.findOne({}, { sort: { index: -1 }})

  addBlock: (newBlock) ->
    latestBlock = @getLatestBlock()
    newBlock.previousHash = latestBlock.hash
    [hash, salt] = newBlock.calculateHash()
    newBlock.hash = hash
    newBlock.salt = salt
    db.insert(newBlock)

  isChainValid: (_count) ->
    count = _count or db.find().count()
    previousBlock = null

    for i in [0...count]
      if i % 1000 is 0 then cl "validating count: #{i}"
      currentBlock = db.findOne({ index: i })

      # Time Weight: Add the time weight for Indexing & DB Hashing compare & vHash Calc.
      db.find({}, {limit: count}).forEach (currentBlock, idx) ->
#        if idx % 1000 is 0 then cl 'weight: ', idx
#        currentBlock = db.findOne({ index: i })
        bcrypt.compare(currentBlock.index + currentBlock.previousHash + currentBlock.timestamp + JSON.stringify(currentBlock.data), currentBlock.hash)


      if i == 0
#        cl currentBlock.hash
  # Handle genesis block
        if currentBlock.hash != bcrypt.hashSync(currentBlock.index + currentBlock.previousHash + currentBlock.timestamp + JSON.stringify(currentBlock.data), currentBlock.salt)
          return false
      else
        isValid = bcrypt.compareSync(currentBlock.index + currentBlock.previousHash + currentBlock.timestamp + JSON.stringify(currentBlock.data), currentBlock.hash)
        return false unless isValid

        # Directly compare previous hashes, no bcrypt involved
        if currentBlock.previousHash != previousBlock.hash
          return false

      previousBlock = currentBlock

    return true

return

# Testing the implementation
db.remove({})
myBlockchain = new BlockchainBcrypt()
count = 1000
if db.find().count() <= count
  [db.find().count()...count].forEach (i) ->
    myBlockchain.addBlock new Block i, new Date(), faker.lorem.sentence()

#console.log 'Is blockchain valid? ', myBlockchain.isChainValid()

# Creating a new MongoDB collection for the results
sbcDBResult = new Mongo.Collection 'sbcDBResult_weight'
sbcDBResult.remove({})
# Total number of blocks to validate
totalBlocks = db.find().count()

# Variable to track cumulative time

# Loop to validate blocks in chunks of 1000
loop_count = 100
for count in [loop_count...totalBlocks + 1] by loop_count
  startTime = Date.now()
  isValid = myBlockchain.isChainValid(count)
  endTime = Date.now()

  timeTaken = endTime - startTime # Calculate time taken in milliseconds

  # Save the result to the bcDBResult collection
  result = { count: count, loopTime: timeTaken}
  sbcDBResult.insert result

  console.log "Is blockchain valid after tampering for count #{count}? " + isValid
  console.log "Loop time: #{timeTaken}ms"

