angular.module "web"
.controller "BiBTeXCtrl", ($scope, $http, references) ->
  references.getBiBTeX()
  .success (data) ->
    document.querySelector("#BiBTeX").innerHTML = data
  .error (data) ->
    console.log data
