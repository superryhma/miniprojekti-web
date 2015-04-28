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

    parseForm = (formId="add-new") ->
      req = references.getTemplate()

      selector = document.querySelector("form\##{formId} select[name=type]")
      req.type = selector.options[selector.selectedIndex].text.toLowerCase()

      for input in document.querySelectorAll("form\##{formId} input[type=text]")
        switch input.name
          when "name" then req.name = input.value
          when "tags" then req.tags = input.value.split "," if input.value.length > 0
          else req.fields[input.name.split("field_")[1]] = input.value if input.getAttribute("type") is "text" and input.value.length > 0

      req

    resetForm = (formId="add-new") ->
      for input in document.querySelectorAll("form\##{formId} input[type=text]")
        input.value = ""

    editReference = () ->
      req = parseForm()
      references.edit($routeParams.id, req)
        .success (data) ->
          updateReference()
          resetForm()
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
