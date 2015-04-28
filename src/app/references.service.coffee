angular.module "web"
.factory "references", ($http) ->
  getTemplate = () ->
    return {
    name: "",
    type: "",
    tags: [],
    fields: {}
    }
  getSuggestion = (author, year) ->
    $http.get "/api/references/namesuggestion", {
      params: {
        author: author,
        year: year
      }
    }
  return {
  get: () ->
    $http.get "/api/references"
  getId: (id) ->
    $http.get "/api/references/#{id}"
  delete: (id) ->
    $http.delete "/api/references/#{id}"
  add: (data) ->
    $http.post "/api/references", data
  edit: (id, data) ->
    $http.put "/api/references/#{id}", data
  parseForm: (formId = "add-new") ->
    req = getTemplate()

    selector = document.querySelector("form\##{formId} select[name=type]")
    req.type = selector.options[selector.selectedIndex].text.toLowerCase()

    for input in document.querySelectorAll("form\##{formId} input[type=text]")
      switch input.name
        when "name" then req.name = input.value
        when "tags" then req.tags = input.value.split "," if input.value.length > 0
        else
          req.fields[input.name.split("field_")[1]] = input.value if input.getAttribute("type") is "text" and input.value.length > 0

    placeholder = document.querySelector("input[name='name']").getAttribute("placeholder")
    if req.name.length == 0 and placeholder.length > 0
      req.name = placeholder

    req
  resetForm: (formId = "add-new") ->
    input.value = "" for input in document.querySelectorAll("form\##{formId} input[type=text]")
    document.querySelector("input[name='name']").setAttribute("placeholder", "")
  getTemplate: getTemplate
  getBiBTeX: () ->
    req =
      method: 'GET'
      url: '/api/references'
      headers: {
        'Accept': 'text/x-bibtex'
      }

    $http req
  getSuggestion: getSuggestion
  makeSuggestionHappen: () ->
    author = document.querySelector 'input[name="field_author"]'
    year = document.querySelector 'input[name="field_year"]'
    name = document.querySelector 'input[name="name"]'
    if author and year
      if author.value.length == 0 or year.value.length == 0 or name.value.length != 0
        return
      getSuggestion(author.value, year.value).success (data) ->
        name.setAttribute("placeholder", data.name)
  }
