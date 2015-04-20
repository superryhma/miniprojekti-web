angular.module 'web', ['ngAnimate', 'ngCookies', 'ngTouch', 'ngSanitize', 'ngResource', 'ngRoute']
  .config ($routeProvider) ->
    $routeProvider
      .when "/",
        templateUrl: "app/main/main.html"
        controller: "MainCtrl"
        resolve: {
          types: "Types"
        }
      .when "/references/:id",
        templateUrl: "app/reference/reference.html"
        controller: "ReferenceCtrl"
        resolve: {
          types: "Types"
        }
      .when "/about",
        templateUrl: "app/about/about.html"
      .when "/BiBTeX",
        templateUrl: "app/bibtex/bibtex.html"
        controller: "BiBTeXCtrl"
      .otherwise
        redirectTo: "/"

  .filter 'unlist', ->
    (input) ->
      return input?.join ", "

  .filter 'capitalize', ->
    (input) ->
      return false if input is undefined
      return input.charAt(0).toUpperCase() + input.substr(1).toLowerCase()
