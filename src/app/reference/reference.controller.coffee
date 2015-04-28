angular.module "web"
  .controller "ReferenceCtrl", ($scope, $http, $routeParams, $location, types, references) ->
    $scope.types = types.data.types
    $scope.selectedType = $scope.types[0]
    $scope.editing = true

    errorElement = document.querySelector(".error")

    showError = (error) ->
      errorElement.innerHTML = error
      errorElement.style.display = "block"

    hideError = () ->
      errorElement.innerHTML = ""
      errorElement.style.display = "none"

    updateReference = () ->
      references.getId($routeParams.id).success (data) ->
        $scope.reference = data
        hideError()

    editReference = () ->
      req = references.parseForm()
      references.edit($routeParams.id, req)
        .success (data) ->
          updateReference()
          references.resetForm()
          $scope.editing = false
          $location.url "/"
        .error (data) ->
          showError (if typeof data is Object then data.description else data)

    removeReference = (target) ->
      references.delete(target)
        .success (data) ->
          updateReference()
        .error (data) ->
          showError data

    updateReference()

    $scope.removeReference = removeReference
    $scope.editReference = editReference
    $scope.startEditing = () ->
      $scope.editing = true
    $scope.stopEditing = () ->
      $scope.editing = false
      $location.url "/"
    $scope.getSuggestion = references.makeSuggestionHappen
