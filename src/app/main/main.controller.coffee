angular.module "web"
  .controller "MainCtrl", ($scope, $http, types, references) ->
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
