## Function to calculate the exponential fit parameters a and b for y = a * e^(bx)
#calculateExpFit = (x, y) ->
#  sumX = 0
#  sumY = 0
#  sumXY = 0
#  sumXX = 0
#  n = x.length
#
#  for i in [0...n]
#    xi = x[i]
#    yi = Math.log(y[i])  # Taking natural log of y
#    sumX += xi
#    sumY += yi
#    sumXY += xi * yi
#    sumXX += xi * xi
#
#  # Calculate b
#  b = (n * sumXY - sumX * sumY) / (n * sumXX - sumX ** 2)
#
#  # Calculate a
#  a = Math.exp((sumY - b * sumX) / n)
#
#  return {a, b}
#
## Function to predict the next value
#predict = (a, b, x) ->
#  a * Math.exp(b * x)
#
## Given data
#data = [
#  {count: 100, loopTime: 743},
#  {count: 200, loopTime: 2361},
#  {count: 300, loopTime: 4174},
#  {count: 400, loopTime: 6598},
#  {count: 500, loopTime: 9273},
#  {count: 600, loopTime: 13585},
#  {count: 700, loopTime: 17212},
#  {count: 800, loopTime: 23019},
#  {count: 900, loopTime: 29088},
#  {count: 1000, loopTime: 38021},
#  {count: 1100, loopTime: 76174}
#]
#
#x = (d.count for d in data)
#y = (d.loopTime for d in data)
#
## Calculate exponential fit parameters
#{a, b} = calculateExpFit(x, y)
#
## Predict next 10 values using a for loop by range
#predictions = []
#for count in [1200..10000] by 100
#  predictedLoopTime = predict(a, b, count)
#  predictions.push({count, loopTime: Math.round(predictedLoopTime)})
#
## Combine original data and predictions
#finalData = data.concat(predictions)
#
#console.log(finalData)