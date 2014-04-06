BH.Lib.QueryParams =
  read: (string = '') ->
    return {} if string.length == 0
    out = {}
    for keyValue in string.split('&')
      [key, value] = keyValue.split('=')
      out[key] = value
    out

  write: (obj = {}) ->
    out = []
    out = ("#{key}=#{value}" for key, value of obj)
    return "" if out.length == 0
    "?#{out.join('&')}"
