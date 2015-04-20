angular.module "web"
  .controller "MainCtrl", ($scope, $http, types, references) ->
    $scope.types = types.data.types
    $scope.selectedType = $scope.types[0]

    errorElement = document.querySelector(".error")

    showError = (error) ->
      errorElement.innerHTML = error
      errorElement.style.display = "block"

    hideError = () ->
      errorElement.innerHTML = ""
      errorElement.style.display = "none"

    updateReferences = () ->
      references.get().success (data) ->
        $scope.references = data.references
        hideError()

    parseForm = () ->
      req = references.getTemplate()

      selector = document.querySelector("select[name=type]")
      req.type = selector.options[selector.selectedIndex].text.toLowerCase()

      for input in document.querySelectorAll("form.add-new input[type=text]")
        switch input.name
          when "name" then req.name = input.value
          when "tags" then req.tags = input.value.split " " if input.value.length > 0
          else req.fields[input.name.split("field_")[1]] = input.value if input.getAttribute("type") is "text" and input.value.length > 0

      req

    resetForm = () ->
      for input in document.querySelectorAll("form.add-new input[type=text]")
        input.value = ""

    addReference = () ->
      req = parseForm()
      references.add(req)
        .success (data) ->
          updateReferences()
          resetForm()
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
