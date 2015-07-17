(function() {
  var MdTestUI,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  MdTestUI = {};

  MdTestUI.App = new Marionette.Application();

  MdTestUI.App.on('start', function() {
    this.layout = new MdTestUI.View.Root();
    this.router = new MdTestUI.Router({
      controller: new MdTestUI.Controller()
    });
    return Backbone.history.start({
      pushState: true
    });
  });

  MdTestUI.Controller = (function(superClass) {
    extend(Controller, superClass);

    function Controller() {
      return Controller.__super__.constructor.apply(this, arguments);
    }

    Controller.prototype.index = function() {
      var view;
      console.log('index c');
      view = new MdTestUI.View.IndexRoot();
      MdTestUI.App.layout.getRegion('main').show(view);
      return view.render();
    };

    Controller.prototype.test = function(id) {
      var view;
      console.log('test c');
      view = new MdTestUI.View.TestRoot({
        test_id: id
      });
      return MdTestUI.App.layout.getRegion('main').show(view);
    };

    return Controller;

  })(Marionette.Object);

  MdTestUI.Router = (function(superClass) {
    extend(Router, superClass);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.appRoutes = {
      '': 'index',
      ':id': 'test'
    };

    return Router;

  })(Marionette.AppRouter);

  MdTestUI.View = {};

  MdTestUI.View.Root = (function(superClass) {
    extend(Root, superClass);

    function Root() {
      return Root.__super__.constructor.apply(this, arguments);
    }

    Root.prototype.el = 'body';

    Root.prototype.regions = {
      main: "main"
    };

    return Root;

  })(Marionette.LayoutView);

  MdTestUI.View.IndexRoot = (function(superClass) {
    extend(IndexRoot, superClass);

    function IndexRoot() {
      return IndexRoot.__super__.constructor.apply(this, arguments);
    }

    IndexRoot.prototype.template = "#index-root";

    IndexRoot.prototype.regions = {
      search: ".search"
    };

    IndexRoot.prototype.onShow = function() {};

    return IndexRoot;

  })(Marionette.LayoutView);

  MdTestUI.View.TestRoot = (function(superClass) {
    extend(TestRoot, superClass);

    function TestRoot() {
      return TestRoot.__super__.constructor.apply(this, arguments);
    }

    TestRoot.prototype.template = "#test-root";

    TestRoot.prototype.regions = {
      search: ".search"
    };

    TestRoot.prototype.initialize = function(arg) {
      var test_id;
      test_id = arg.test_id;
      return console.log(test_id);
    };

    return TestRoot;

  })(Marionette.LayoutView);

  $(function() {
    return MdTestUI.App.start();
  });

}).call(this);
