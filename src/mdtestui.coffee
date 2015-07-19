MdTestUI = {}

# app

MdTestUI.App = new Marionette.Application()

MdTestUI.App.on 'start', ->
  @layout = new MdTestUI.View.Root()
  @router = new MdTestUI.Router(controller: new MdTestUI.Controller())
  Backbone.history.start(pushState: true)

# controller

class MdTestUI.Controller extends Marionette.Object
  index: ->
    console.log "route index"
    search = new Search()
    tests = new Tests()
    tests.fetch()
    search.on 'change:title', (model, value) ->
      console.log value
      tests.fetch
        data:
          title: value
    view = new MdTestUI.View.IndexRoot(search_model: search, tests_collection: tests)
    MdTestUI.App.layout.main.show(view)
  new_test: ->
    console.log "route new_test"
    test = new Test()
    view = new MdTestUI.View.TestEditRoot(test_model: test)
    MdTestUI.App.layout.main.show(view)
  test: (id) ->
    console.log "route test"
    test = new Test(id: id)
    test.fetch()
    view = new MdTestUI.View.TestRoot(test_model: test)
    MdTestUI.App.layout.main.show(view)
  edit_test: (id) ->
    console.log "route edit_test"
    test = new Test(id: id)
    test.fetch()
    view = new MdTestUI.View.TestEditRoot(test_model: test)
    MdTestUI.App.layout.main.show(view)

# router

class MdTestUI.Router extends Marionette.AppRouter
  appRoutes:
    '': 'index'
    'test': 'new_test'
    'test/:id': 'test'
    'test/:id/edit': 'edit_test'

# view

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
  ui:
    new_test: '.new-test'
  events:
    'click @ui.new_test': ->
      MdTestUI.App.router.navigate('test', true)
  initialize: ({@search_model, @tests_collection}) ->
  onShow: ->
    @search.show new MdTestUI.View.IndexSearch(model: @search_model)
    @tests.show new MdTestUI.View.IndexTests(collection: @tests_collection)

class MdTestUI.View.TestRoot extends Marionette.LayoutView
  template: "#test-root"
  regions:
    view: ".view"
  ui:
    index: '.index'
  events:
    'click @ui.index': ->
      MdTestUI.App.router.navigate('', true)
  initialize: ({@test_model}) ->
  onShow: ->
    @view.show new MdTestUI.View.TestView(model: @test_model)

class MdTestUI.View.TestEditRoot extends Marionette.LayoutView
  template: "#test-edit-root"
  regions:
    edit: ".edit"
    view: ".view"
  ui:
    index: '.index'
  events:
    'click @ui.index': ->
      MdTestUI.App.router.navigate('', true)
  initialize: ({@test_model}) ->
  onShow: ->
    @edit.show new MdTestUI.View.TestEdit(model: @test_model)
    @view.show new MdTestUI.View.TestView(model: @test_model)

class MdTestUI.View.TestEdit extends Marionette.ItemView
  template: "#test-edit"
  bindings:
    '.errors':
      observe: 'errors'
      update: ($el, errors, model) ->
        console.log errors
        $el.html($("<li>#{error}</li>") for error in errors)
    '.title':
      observe: 'title'
    '.description':
      observe: 'description'
    '.test':
      observe: 'test'
  ui:
    submit: '.submit'
  events:
    'click @ui.submit': ->
      @model.save null,
        success: (model, response) ->
          MdTestUI.App.router.navigate("test/#{response.id}", true)
        error: (model, response) ->
          model.set 'errors', response.responseJSON.errors
  onShow: ->
    @stickit()

class MdTestUI.View.TestView extends Marionette.ItemView
  template: "#test-view"
  bindings:
    '.title':
      observe: 'title'
    '.description':
      observe: 'description'
    '.test':
      observe: 'test'
  ui:
    edit: '.edit'
  events:
    'click @ui.edit': ->
      MdTestUI.App.router.navigate("test/#{@model.id}/edit", true)
  onShow: ->
    @stickit()

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
  bindings:
    '.title':
      observe: 'title'
  events:
    'click': ->
      MdTestUI.App.router.navigate("test/#{@model.id}", true)
  onShow: ->
    @stickit()

class MdTestUI.View.IndexTests extends Marionette.CollectionView
  tagName: 'ul'
  childView: MdTestUI.View.IndexTest

# model

class Search extends Backbone.Model
  defaults:
    title: ''

class Test extends Backbone.Model
  urlRoot: '/tests'

class Tests extends Backbone.Collection
  model: Test
  url: '/tests'

$ ->
  MdTestUI.App.start()
  window.a = MdTestUI.App
