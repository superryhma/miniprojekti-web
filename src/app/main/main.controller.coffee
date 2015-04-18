angular.module "web"
  .controller "MainCtrl", ($scope, $http, types) ->
    $scope.types = types.data.types
    $scope.selectedType = $scope.types[0]

    updateReferences = () ->
      $http.get("/api/references").success (data) ->
        $scope.references = data.references
        document.querySelector(".error").style.display = "none"

    addReference = () ->
      req = {
        name: "",
        type: "",
        tags: [],
        fields: {}
      }

      selector = document.querySelector("select[name=type]")
      req.type = selector.options[selector.selectedIndex].text.toLowerCase()

      for input in document.querySelectorAll("form.add-new input[type=text]")
        switch input.name
          when "name" then req.name = input.value
          when "tags" then req.tags = input.value.split " " if input.value.length > 0
          else req.fields[input.name.split("field_")[1]] = input.value if input.getAttribute("type") is "text" and input.value.length > 0

      $http.post "/api/references/", req
        .success (data) ->
          updateReferences()
          for input in document.querySelectorAll("form.add-new input[type=text]")
            input.value = ""
        .error (data) ->
          document.querySelector(".error").innerHTML = data.description
          document.querySelector(".error").style.display = "block"

    removeReference = (target) ->
      $http.delete "/api/references/#{target}"
        .success (data) ->
          updateReferences()
        .error (data) ->
          console.log data

    updateReferences()

    $scope.updateReferences = updateReferences
    $scope.addReference = addReference
    $scope.removeReference = removeReference
