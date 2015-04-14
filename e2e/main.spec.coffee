describe 'The main view', () ->
  page = null

  beforeEach () ->
    browser.get 'http://localhost:3000/index.html'

  it 'should have a form of inputs', () ->
    expect(element.all(`by`.id("add-new")).count()).toEqual(1)
