bcrypt = require 'bcrypt'
saltRounds = 10

do ->
#  cl await db.rawCollection().aggregate([$sample: size: 1]).toArray()
#  hash = await bcrypt.hash JSON.stringify({a: 1}), saltRounds
#  cl bcrypt.compareSync JSON.stringify({a: 1}), hash
  prev = null

  db.rawCollection().aggregate([$sample: size: db.find().count()]).forEach (data) ->
    unless prev then prev = data
    sbc.insert



