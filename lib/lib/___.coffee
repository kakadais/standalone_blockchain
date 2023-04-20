@moment = require('moment-timezone')
@_ = require('lodash')

@cl = console.log

#Object::hasOwnNestedProperty = (propertyPath) ->
#  if !propertyPath
#    return false
#  properties = propertyPath.split('.')
#  obj = this
#  i = 0
#  while i < properties.length
#    prop = properties[i]
#    if !obj or !obj.hasOwnProperty(prop)
#      return false
#    else
#      obj = obj[prop]
#    i++
#  return true


#date manipulate
# Date prototyping
Date::addSeconds ?= (s) ->
  @setSeconds @getSeconds() + s
  return @
Date::addMinutes ?= (m) ->
  @setMinutes @getMinutes() + m
  return @
Date::addHours ?= (h) ->
  @setHours @getHours() + h
  return @
Date::addDates ?= (d) ->
  @setDate @getDate() + d
  return @
Date::addMonths ?= (month) ->
  @setMonth(@getMonth()+month)
  return @
Date::addYears ?= (year) ->
  @setYear(@getFullYear()+year)
  return @
Date::clone ?= -> return new Date @getTime()

Date::toStringYM ?= ->
  return moment(this).format('YYYY-MM')
Date::toStringYM ?= ->
  return moment(this).format('YYYY-MM')
Date::toStringYMD ?= ->
  return moment(this).format('YYYY-MM-DD')
Date::toStringYMDdot ?= ->
  return moment(this).format('YYYY.MM.DD')
Date::toStringMDHM ?= ->
  return moment(this).format('MM-DD HH:mm')
Date::toStringMD ?= ->
  return moment(this).format('MM-DD')
Date::toStringHMS ?= ->
  return moment(this).format('HH:mm:ss')
Date::toStringH ?= ->
  return moment(this).format('HH')
Date::toStringM ?= ->
  return moment(this).format('mm')
Date::toStringHM ?= ->
  return moment(this).format('HH:mm')
Date::toStringYMDHMS ?= ->
  return moment(this).format('YYYY-MM-DD HH:mm:ss')
Date::toStringYMD_HMS ?= ->
  return moment(this).format('YYYY-MM-DD_HH:mm:ss')
Date::toDateFromString ?= (_str) ->
  return moment(_str, 'YYYY-MM-DD HH:mm:ss').toDate()

#array manipulate
Array::random ?= (N, M) ->
  if typeof N is 'number' # random pick N
    if typeof M is 'number' # random pick in array by N <= count < M
      if @length > 1 then for i in [@length-1..1]
        j = Math.floor Math.random() * (i + 1)
        [@[i], @[j]] = [@[j], @[i]]
      return this.slice(0, [N ... M].random())
    else
      if @length > 1 then for i in [@length-1..1]
        j = Math.floor Math.random() * (i + 1)
        [@[i], @[j]] = [@[j], @[i]]
      return this.slice(0, N)
  else
    return this[Math.floor((Math.random()*this.length))]

Array::shuffle ?= ->
  if @length > 1 then for i in [@length-1..1]
    j = Math.floor Math.random() * (i + 1)
    [@[i], @[j]] = [@[j], @[i]]
  this

Array::randomN ?= (N) ->
  if @length > 1 then for i in [@length-1..1]
    j = Math.floor Math.random() * (i + 1)
    [@[i], @[j]] = [@[j], @[i]]
  return this.slice(0, N)

Array::randomNM ?= (N, M) ->
  # random pick in array by N <= count < M
  if @length > 1 then for i in [@length-1..1]
    j = Math.floor Math.random() * (i + 1)
    [@[i], @[j]] = [@[j], @[i]]
  return this.slice(0, [N ... M].random())

if (!String.prototype.splice)
  String.prototype.splice = (start, delCount, newSubStr) ->
#insert newSubStr to start and remove delCount
    return this.slice(0, start) + newSubStr + this.slice(start + Math.abs(delCount));

unless @___ then @___ =
  sanitize: (str = '', max = 28, replacement = '-') ->
    return str.replace(/([^a-z0-9\-\_]+)/gi, replacement).substring(0, max)

  isObject: (obj) ->
    if (this.isArray(obj) || this.isFunction(obj))
      return false
    return obj == Object(obj)

  isArray: (obj) ->
    return Array.isArray(obj)

  isBoolean: (obj) ->
    return obj == true || obj == false || Object.prototype.toString.call(obj) == '[object Boolean]'

  isString: (obj) ->
    return typeof obj is "string"

  isFunction: (obj) ->
    return typeof obj == 'function' || false

  isDate: (date) ->
    return !Number.isNaN(new Date(date).getDate())

  isEmpty: (obj) ->
    # number & boolean can't be checked. (all false returned)
    if (this.isDate(obj))
      return false
    if (this.isObject(obj))
      return !Object.keys(obj).length
    if (this.isArray(obj) || this.isString(obj))
      return !obj.length
    return false

  clone: (obj) ->
    # object & array will be cloned. (because the others will copy value if assigned.)
    if (!this.isObject(obj) && !this.isArray(obj)) then return obj
    return if this.isArray(obj) then obj.slice() else Object.assign({}, obj)

  has: (_obj, path) ->
    # path is array with keys
    obj = _obj
    if (!this.isObject(obj))
      return false
    if (!this.isArray(path))
      return this.isObject(obj) && Object.prototype.hasOwnProperty.call(obj, path)

    length = path.length
    for item, i in path
      if (!Object.prototype.hasOwnProperty.call(obj, path[i]))
        return false
      obj = obj[path[i]]
    return !!length

  omit: (obj, ...keys) ->
    clear = Object.assign({}, obj)
    for key, i in keys by -1
      delete clear[keys[i]]
    return clear
  checkEmail: (mail) ->
    #이메일 형식 check / return true, false
    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(mail)) then return true
    else return false
  getPadNumber: (n, length, char) ->
    # 0 padding / n: nunber, length: target length, char: pad character
    char = char or '0'
    n = n + ''
    if n.length >= length then n else new Array(length - (n.length) + 1).join(char) + n
  getRandomPaddedNumber: (n) ->
    # n: length (first padding with 0. ex> 001)
    # return typeof number
    add = 1
    max = 12 - add
    # 12 is the min safe number Math.random() can generate without it starting to pad the end with zeros.
    if n > max
      return generate(max) + generate(n - max)
    max = 10 ** (n + add)
    min = max / 10
    # Math.pow(10, n) basically
    number = Math.floor(Math.random() * (max - min + 1)) + min
    ('' + number).substring add
  getRandomNumber: (min, max) ->
    # min to max(exclude) / return typeof number
    min = Math.ceil(min)
    max = Math.floor(max)
    return Math.floor(Math.random() * (max - min)) + min
  exist: (_obj) ->
    #obj, arr, string 등 값의 존재 유무 확인
    if typeof _obj is 'number' then return true
    else if typeof _obj is 'boolean' then return true
    else return _obj? and !!_obj and !!Object.keys(_obj).length
  exists: (_arr, operator) ->
    ### operator
  or: 하나라도 있으면 true
  and(=undefined): 모두 있어야 true
###
    if !@isArray then throw new Meteor.Error 'Not array'
    if _arr.length <= 0 then return false #필요 한 매개변수가 없는 것으로 간주
    if operator not in [undefined, 'or'] then throw new Meteor.Error 'Not operator'

    if operator is 'or'
      for data in _arr
        if @exist data then return true
      return false
    else
      for data in _arr
        if !@exist data then return false
      return true

#    if operator is 'or'
#      for data in _arr
#        if exist(data) then return true
#      return false
#    else
#
#      for data in _arr
#        if !exist(data) then return false
#      return false

#    arr = []
#    for _obj in _arr
#      if typeof _obj is 'number' then arr.push true
#      else if typeof _obj is 'boolean' then arr.push true
#      else arr.push _obj? and !!_obj and !!Object.keys(_obj).length
#    if operator is 'or' then return arr.includes(true) #or
#    else !arr.includes(false) #and
  getStartEndOfDate: (_date) ->
    strYMD = _date.toStringYMD()
    return {
      startAt: (new Date).toDateFromString(strYMD + ' 00:00:00')
      endAt: (new Date).toDateFromString(strYMD + ' 00:00:00').addDates(1)
    }
  getObjectCounts: (_object) ->
    Object.keys(_object).length
  hasOnlyDigits: (_val) ->
    if /^-?\d+\.?\d*$/.test _val then return true
    else return false
  getClassName: (obj) ->
    if typeof obj is "undefined" then return "undefined"
    if obj is null then return "null"
    return Object.prototype.toString.call(obj).match(/^\[object\s(.*)\]$/)[1]