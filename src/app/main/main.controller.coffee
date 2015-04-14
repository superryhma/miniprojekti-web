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
    ###$scope.references = [
      {
        "id": 16,
        "name": "MSAM",
        "url": "/api/references/16",
        "created_at": "2015-03-31T17:09:27Z",
        "updated_at": "2015-03-31T17:22:47Z",
        "type": "book",
        "fields": {
          "author": "Matti",
          "title": "Sammakkokirja",
          "year": "2013",
          "publisher": "Otava",
          "pages": "512"
        },
        "tags": [
          "suomi", "lol"
        ]
      },
      {
        "id": 17,
        "name": "KEK",
        "url": "/api/references/17",
        "created_at": "2015-03-31T17:09:27Z",
        "updated_at": "2015-03-31T17:22:47Z",
        "type": "misc",
        "fields": {
          "author": "Kek Kos",
          "title": "Hehehehehe",
          "year": "2016",
        },
        "tags": [
          "lol"
        ]
      }
    ]###
  .filter 'unlist', ->
    (input) ->
      return input.join ", "
  .filter 'capitalize', ->
    (input) ->
      return false if input is undefined
      return input.charAt(0).toUpperCase() + input.substr(1).toLowerCase()
