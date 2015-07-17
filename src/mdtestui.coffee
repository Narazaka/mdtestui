MdTestUI = {}

MdTestUI.App = new Marionette.Application()

MdTestUI.App.on 'start', ->
  @layout = new MdTestUI.View.Root()
  @router = new MdTestUI.Router(controller: new MdTestUI.Controller())
  Backbone.history.start(pushState: true)

class MdTestUI.Controller extends Marionette.Object
  index: ->
    console.log 'index c'
    view = new MdTestUI.View.IndexRoot()
    MdTestUI.App.layout.getRegion('main').show(view)
    view.render()
  test: (id) ->
    console.log 'test c'
    view = new MdTestUI.View.TestRoot(id: id)
    MdTestUI.App.layout.getRegion('main').show(view)

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
  onShow: ->

class MdTestUI.View.TestRoot extends Marionette.LayoutView
  template: "#test-root"
  regions:
    search: ".search"
  initialize: ({id}) ->
    console.log id

$ ->
  MdTestUI.App.start()
