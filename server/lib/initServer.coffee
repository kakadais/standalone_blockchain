{ faker } = require '@faker-js/faker'
#db.remove({})
#unless db.findOne()
#  for i in [0...100]
#    db.insert
#      createdAt: (new Date()).addDates([-1000...0].random())
#      content: faker.lorem.sentence()