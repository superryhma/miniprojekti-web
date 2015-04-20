angular.module "web"
  .factory "references", ($http) ->
    return {
      get: () ->
        $http.get "/api/references"
      delete: (id) ->
        $http.delete "/api/references/#{id}"
      add: (data) ->
        $http.post "/api/references", data
      getTemplate: () ->
        return {
          name: "",
          type: "",
          tags: [],
          fields: {}
        }
    }