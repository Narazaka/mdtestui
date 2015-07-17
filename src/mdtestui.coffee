MdTestUI = {}

MdTestUI.App = new Marionette.Application()

MdTestUI.App.on 'start', ->
  @layout = new MdTestUI.View.Root()
  @router = new MdTestUI.Router(controller: new MdTestUI.Controller())
  Backbone.history.start(pushState: true)

class MdTestUI.Controller extends Marionette.Object
  index: ->
    search = new Search()
    tests = new Tests()
    tests.add new Test(title: "aa")
    search.on 'change:title', (model, value) ->
    view = new MdTestUI.View.IndexRoot(search_model: search, tests_collection: tests)
    MdTestUI.App.layout.main.show(view)
  test: (id) ->
    view = new MdTestUI.View.TestRoot(id: id)
    MdTestUI.App.layout.main.show(view)

class MdTestUI.Router extends Marionette.AppRouter
  appRoutes:
    '': 'index'
    ':id': 'test'

MdTestUI.View = {}

class MdTestUI.View.Root extends Marionette.LayoutView
  el: 'body'
  regions:
    main: "main"

class MdTestUI.View.IndexRoot extends Marionette.LayoutView
  template: "#index-root"
  regions:
    search: ".search"
    tests: ".tests"
  initialize: ({@search_model, @tests_collection}) ->
  onShow: ->
    @search.show new MdTestUI.View.IndexSearch(model: @search_model)
    @tests.show new MdTestUI.View.IndexTests(collection: @tests_collection)

class MdTestUI.View.TestRoot extends Marionette.LayoutView
  template: "#test-root"
  regions:
    search: ".search"
  initialize: ({id}) ->
    console.log id

class MdTestUI.View.IndexSearch extends Marionette.ItemView
  template: "#index-search"
  bindings:
    '.title':
      observe: 'title'
  onShow: ->
    @stickit()

class MdTestUI.View.IndexTest extends Marionette.ItemView
  tagName: 'li'
  template: "#index-test"

class MdTestUI.View.IndexTests extends Marionette.CollectionView
  tagName: 'ul'
  childView: MdTestUI.View.IndexTest

class Search extends Backbone.Model
  defaults:
    title: ''

class Tests extends Backbone.Collection
  model: -> Test

class Test extends Backbone.Model

$ ->
  MdTestUI.App.start()
