angular.module "web"
  .controller "MainCtrl", ($scope, $http, types) ->
    $scope.types = types.data.types
    $scope.selectedType = $scope.types[0]
    $http.get("/api/references").success (data) ->
      $scope.references = data.references

    $scope.addReference = () ->
      req = {
        name: "",
        type: "",
        tags: [],
        fields: {

        }
      }
      selector = document.querySelector("select[name=type]")
      req.type = selector.options[selector.selectedIndex].text.toLowerCase()
      for input in document.querySelectorAll("form.add-new input")
        switch input.name
          when "name" then req.name = input.value
          when "tags" then req.tags = input.value.split " " if input.value.length > 0
          else req.fields[input.name.split("field_")[1]] = input.value if input.getAttribute("type") is "text" and input.value.length > 0

      $http.post "/api/references/", req
        .success (data) ->
          $http.get("/api/references").success (data) ->
            document.querySelector(".error").style.display = "none"
            $scope.references = data.references
        .error (data) ->
          document.querySelector(".error").innerHTML = data.description
          document.querySelector(".error").style.display = "block"

  .filter 'unlist', ->
    (input) ->
      return input.join ", "

  .filter 'capitalize', ->
    (input) ->
      return false if input is undefined
      return input.charAt(0).toUpperCase() + input.substr(1).toLowerCase()
