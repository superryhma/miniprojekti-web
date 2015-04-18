angular.module "web"
  .controller "BiBTeXCtrl", ($scope, $http) ->
    req =
      method: 'GET'
      url: '/api/references'
      headers: {
        'Accept': 'text/x-bibtex'
      }

    $http req
      .success (data) ->
        document.querySelector("#BiBTeX").innerHTML = data
      .error (data) ->
        console.log data
