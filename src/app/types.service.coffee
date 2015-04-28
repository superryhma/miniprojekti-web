angular.module "web"
.factory "Types", ($http) ->
  return $http.get("/api/types")
