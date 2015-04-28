angular.module "web"
.factory "ACM", ($http) ->
  getIDFromUrl = (url) ->
    parser = document.createElement "a"
    parser.href = url
    params = parser.search.substring(1).split("&")
    params = params.map (el) -> el.split("=")
    for param in params
      if param[0] == "id"
        return param[1]
    return null

  downloadBiBTeX = (id, cb) ->
    id = id.split(".")
    url = "http://weekhub.com:9292/dl.acm.org/downformats.cfm?id=#{id[1]}&parent_id=#{id[0]}&expformat=bibtex"
    $http.get(url).success (data) ->
      cb(data)

  unEscapeBiBTeX = (text) ->
    text

  parseBiBTeX = (data, cb) ->
    data = data.substring(1) # drop @
    type = data.split("{", 1)[0]
    name = data.split("{", 2)[1].split(",")[0]
    fields = data.split(name)[1].substring(1, data.split(name)[1].length - 1).split("\n")
    .map (i) -> i.trim()
    .filter (i) -> i.length > 0
    .map (i) ->
      tmp = i.split("=").map (j) -> j.trim()
      tmp[1] = unEscapeBiBTeX(tmp[1].substring(1, tmp[1].length - 2))
      return tmp

    fieldso = {}
    for field in fields
      fieldso[field[0]] = field[1]

    cb({
      name: name,
      type: type,
      fields: fieldso
    })

  return {
  get: (url, cb) ->
    id = getIDFromUrl(url)
    myParse = (data) ->
      parseBiBTeX(data, cb)
    downloadBiBTeX(id, myParse)
  }
