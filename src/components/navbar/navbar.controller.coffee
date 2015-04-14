angular.module "web"
  .controller "NavbarCtrl", ($scope, $location) ->
    $scope.isActive = (viewLocation) ->
      viewLocation is $location.path()
