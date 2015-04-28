angular.module "web"
.controller "MainCtrl", ($scope, $http, types, references, ACM) ->
  $scope.types = types.data.types
  $scope.selectedType = $scope.types[0]

  errorElement = document.querySelector(".error")

  showError = (error) ->
    errorElement.innerHTML = error.description
    errorElement.style.display = "block"

  hideError = () ->
    errorElement.innerHTML = ""
    errorElement.style.display = "none"

  updateReferences = () ->
    references.get().success (data) ->
      $scope.references = data.references
      hideError()

  addReference = () ->
    req = references.parseForm()
    references.add(req)
    .success (data) ->
      updateReferences()
      references.resetForm()
    .error (data) ->
      showError (if typeof data is Object then data.description else data)

  removeReference = (target) ->
    references.delete(target)
    .success (data) ->
      updateReferences()
    .error (data) ->
      showError data

  updateReferences()

  $scope.addReference = addReference
  $scope.removeReference = removeReference
  $scope.getSuggestion = references.makeSuggestionHappen
  $scope.importACM = () ->
    url = prompt("Enter ACM URL")
    if url.length == 0
      return
    # http://dl.acm.org/citation.cfm?id=2380552.2380613&coll=DL&dl=GUIDE
    ACM.get url, (data) ->
      console.log data
      name = data.name
      name = name.charAt(0).toUpperCase() + name.substr(1).toLowerCase()
      document.querySelector("input[name=name]").value = data.name

      #selector = document.querySelector("select[name=type]")
      #for i of selector.options
      #  if selector.options[i].text.toLowerCase() == data.type
      #    selector.selectedIndex = i
      #    break
      for i in $scope.types
        if i.name == data.type
          $scope.selectedType = i
          break

      setTimeout () ->
        for field_key of data.fields
          ele = document.querySelector("input[name='field_#{field_key}'")
          if ele
            ele.value = data.fields[field_key]
       , 50
