angular.module "web"
  .factory "references", ($http) ->
    return {
      get: () ->
        $http.get "/api/references"
      getId: (id) ->
        $http.get "/api/references/#{id}"
      delete: (id) ->
        $http.delete "/api/references/#{id}"
      add: (data) ->
        $http.post "/api/references", data
      edit: (id, data) ->
        $http.put "/api/references/#{id}", data
      getTemplate: () ->
        return {
          name: "",
          type: "",
          tags: [],
          fields: {}
        }
      getBiBTeX: () ->
        req =
        method: 'GET'
        url: '/api/references'
        headers: {
          'Accept': 'text/x-bibtex'
        }

        $http req
    }