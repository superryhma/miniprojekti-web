describe 'controllers', () ->
  scope = null

  beforeEach module 'web'

  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should 1=1', () ->
    expect(1).toBe(1)

