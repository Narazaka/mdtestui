(function() {
  var MdTestUI, Search, Test, Tests,
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
      var search, tests, view;
      search = new Search();
      tests = new Tests();
      tests.add(new Test({
        title: "aa"
      }));
      search.on('change:title', function(model, value) {});
      view = new MdTestUI.View.IndexRoot({
        search_model: search,
        tests_collection: tests
      });
      return MdTestUI.App.layout.main.show(view);
    };

    Controller.prototype.test = function(id) {
      var view;
      view = new MdTestUI.View.TestRoot({
        id: id
      });
      return MdTestUI.App.layout.main.show(view);
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
      search: ".search",
      tests: ".tests"
    };

    IndexRoot.prototype.initialize = function(arg) {
      this.search_model = arg.search_model, this.tests_collection = arg.tests_collection;
    };

    IndexRoot.prototype.onShow = function() {
      this.search.show(new MdTestUI.View.IndexSearch({
        model: this.search_model
      }));
      return this.tests.show(new MdTestUI.View.IndexTests({
        collection: this.tests_collection
      }));
    };

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
      var id;
      id = arg.id;
      return console.log(id);
    };

    return TestRoot;

  })(Marionette.LayoutView);

  MdTestUI.View.IndexSearch = (function(superClass) {
    extend(IndexSearch, superClass);

    function IndexSearch() {
      return IndexSearch.__super__.constructor.apply(this, arguments);
    }

    IndexSearch.prototype.template = "#index-search";

    IndexSearch.prototype.bindings = {
      '.title': {
        observe: 'title'
      }
    };

    IndexSearch.prototype.onShow = function() {
      return this.stickit();
    };

    return IndexSearch;

  })(Marionette.ItemView);

  MdTestUI.View.IndexTest = (function(superClass) {
    extend(IndexTest, superClass);

    function IndexTest() {
      return IndexTest.__super__.constructor.apply(this, arguments);
    }

    IndexTest.prototype.tagName = 'li';

    IndexTest.prototype.template = "#index-test";

    return IndexTest;

  })(Marionette.ItemView);

  MdTestUI.View.IndexTests = (function(superClass) {
    extend(IndexTests, superClass);

    function IndexTests() {
      return IndexTests.__super__.constructor.apply(this, arguments);
    }

    IndexTests.prototype.tagName = 'ul';

    IndexTests.prototype.childView = MdTestUI.View.IndexTest;

    return IndexTests;

  })(Marionette.CollectionView);

  Search = (function(superClass) {
    extend(Search, superClass);

    function Search() {
      return Search.__super__.constructor.apply(this, arguments);
    }

    Search.prototype.defaults = {
      title: ''
    };

    return Search;

  })(Backbone.Model);

  Tests = (function(superClass) {
    extend(Tests, superClass);

    function Tests() {
      return Tests.__super__.constructor.apply(this, arguments);
    }

    Tests.prototype.model = function() {
      return Test;
    };

    return Tests;

  })(Backbone.Collection);

  Test = (function(superClass) {
    extend(Test, superClass);

    function Test() {
      return Test.__super__.constructor.apply(this, arguments);
    }

    return Test;

  })(Backbone.Model);

  $(function() {
    return MdTestUI.App.start();
  });

}).call(this);
