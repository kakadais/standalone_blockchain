@_schema = (_objName, _addData) ->
  rslt = {}
  # add 될 데이터가 있다면 return 시에 extend 해서 반환
  addData = _addData or {}

  switch _objName
    when 'sbc'
      rslt =
        eb: ''
        db: []

    else
      throw new Error '### Data Schema Not found'
  return _.extend rslt, addData