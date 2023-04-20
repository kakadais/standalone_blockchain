#bcrypt = require 'bcrypt'
#saltRounds = 10
#
#class Block
#  constructor: (index, timestamp, data, previousHash = '') ->
#    @index = index
#    @timestamp = timestamp
#    @data = data
#    @previousHash = previousHash
#    @hash = ''
#    @calculateHash()
#
#  calculateHash: () ->
#    plainText = @index + @previousHash + @timestamp + JSON.stringify(@data)
#    @hash = await bcrypt.hash plainText, saltRounds
#
#class Blockchain
#  constructor: () ->
#    @chain = [@createGenesisBlock()]
#
#  createGenesisBlock: () ->
#    genesisBlock = new Block 0, '01/01/2023', 'Genesis block', '0'
#    await genesisBlock.calculateHash()
#    return genesisBlock
#
#  getLatestBlock: () ->
#    @chain[@chain.length - 1]
#
#  addBlock: (newBlock) ->
#    newBlock.previousHash = @getLatestBlock().hash
#    newBlock.hash = newBlock.calculateHash()
#    @chain.push newBlock
#
#  isChainValid: () ->
#    for i in [1...@chain.length]
#      currentBlock = @chain[i]
#      previousBlock = @chain[i - 1]
#
#      return false if currentBlock.hash != currentBlock.calculateHash()
#      return false if currentBlock.previousHash != previousBlock.hash
#
#    return true
#
## Testing the implementation
#myBlockchain = new Blockchain()
#myBlockchain.addBlock new Block 1, '03/23/2023', { amount: 4 }
#myBlockchain.addBlock new Block 2, '03/24/2023', { amount: 10 }
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