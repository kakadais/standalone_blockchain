#bcrypt = require('bcrypt')
#saltRounds = 10;
#myPlaintextPassword = 's0/\/\P4$$w0rD';
#someOtherPlaintextPassword = 'not_bacon';
#
#do ->
#  hash = await bcrypt.hash(myPlaintextPassword, saltRounds)
#  cl await bcrypt.compare myPlaintextPassword, hash
#
#@SBC = class SBC
#  sbc: new Mongo.Collection '___sbc'
#  constructor: (_targetDB) ->
#    if !@sbc.findOne(_id: '') then @db.insert(_id: 'GENESYS')
#    @targetDB = _targetDB
#  getDB: -> @db