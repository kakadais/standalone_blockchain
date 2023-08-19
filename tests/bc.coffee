#{ Mongo } = require 'meteor/mongo'
#{ SHA256 } = require 'crypto-js'
#{ faker } = require '@faker-js/faker'
#
## Declare Collections
#db = new Mongo.Collection('bcDB')
#blocks = new Mongo.Collection('bcBlocks')
#
## Uncomment to Remove Collection Data (Uncomment to reset data)
##db.remove({})
##blocks.remove({})
#
#
## Insert Dummy Data into 'bcDB' if no data exists
#if db.find().count() == 0
#  cl 'build dummy blocks'
#  pHash = 'genesis'
#  [0...100].forEach (i) ->
#    tmp_id = db.insert
#      pHash: pHash
#      data: faker.lorem.sentence()
#    tmpBlock = db.findOne(tmp_id)
#    pHash = SHA256(JSON.stringify(tmpBlock)).toString()
#
## check validate
#if db.find().count() > 0
#  #first block
#  block = db.findOne(pHash: 'genesis')
#  pHash = SHA256(JSON.stringify(block)).toString()
#
#
#
#
#
#
## Build blocks
##if db.find().count() > 0 and blocks.find().count() == 0
##  cl 'build blocks'
##  pHash = 'genesis' #previous hash
##  db.find().forEach (data) ->
##    _id = blocks.insert
##      pHash: pHash
##      hash: SHA256(JSON.stringify(data)).toString()
##    block = blocks.findOne(_id)
##    pHash = SHA256(JSON.stringify(block)).toString()
##
## Check validation
##if db.find().count() > 0 and blocks.find().count() > 0
##  cl 'check validation'
##  blocks.update {}, {
##      $unset:
##        'isMatched': 1
##    }, {multi: 1}
##  try
##    # link with original data
##    db.find().forEach (data) ->
##      hash = SHA256(JSON.stringify(data)).toString()
##      block = blocks.findOne(hash: hash)
##      unless block then throw new Meteor.Error 'block data not found'
##      blocks.update block._id, $set: p_id: data._id #set parent _id
##    blocks.find().forEach (block) ->
##      block.p_ids = []
##      db.find().forEach (data) ->
##        if block.hash == SHA256(JSON.stringify(data)).toString()
##          block.p_ids.push data._id
##
##      blocks.update block._id, block
##
##
##  catch err
##    console.error err
#
#
##  pHash = 'genesis'
##  for i in [0...100]
##    cl block = blocks.findOne(pHash: pHash)
##    try
##      db.find().forEach (block) ->
##        SHA256(JSON.stringify(block)).toString()
##    catch err
##      console.error "err: #{err}"
##    pHash = SHA256(JSON.stringify(block)).toString()
#
#
#
#
##  # Shuffle and Create Blockchain Data
##  previousHash = 'GenesisBlock'
##  bcTarget.find().forEach (target) ->
##    currentHash = SHA256(previousHash).toString() # Changed key name to currentHash
##    bc.insert
##      currentHash: currentHash # Changed key name to currentHash
##      previousHash: previousHash
##
##    previousHash = currentHash # Update previousHash with currentHash
##
##  console.log 'Blockchain successfully generated.'
##
##if bc.find().count() > 0
##  bc.find().forEach (block) ->
##
##
##  previousHash = bc.findOne(previousHash: 'GenesisBlock').previousHash
##  for i in [0 ... bc.find().count()]
##    startCheckTime = new Date().getTime()
##    bc.findOne(previousHash: previousHash)
##    foundBlock = bc.findOne(previousHash: previousHash)
##    if !foundBlock then return console.error "Error: Block not found. Previous hash:", previousHash
##
##
#
#
#
## Function to Validate the Blockchain and Calculate Processing Time
##validateBlockchain = ->
##  previousHash = 'GenesisBlock'
##  rslt = 'success'
##  try
##    bc.find().forEach (block) ->
##      startCheckTime = new Date().getTime()
##
##      # Check if the block is found
##      foundBlock = bc.findOne
##        currentHash: block.currentHash # Changed key name to currentHash
##        previousHash: previousHash
##
##      if !foundBlock
##        throw new Meteor.Error "Error: Block not found. Hash:", block.currentHash, "Previous hash:", previousHash # Changed key name to currentHash
##
##      checkTime = new Date().getTime() - startCheckTime
##      bc.update foundBlock._id, $set: checkTime: checkTime
##      previousHash = foundBlock.currentHash # Update previousHash with currentHash
##  catch err
##    rslt = 'error'
##    console.error err
##  console.log rslt
#
## Uncomment to run the validation
##validateBlockchain()
