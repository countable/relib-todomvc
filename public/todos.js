// Generated by CoffeeScript 1.6.3
(function() {
  var filters;

  window.data = {
    todos: [
      {
        title: 'first title',
        completed: true
      }, {
        title: 'second title',
        completed: true
      }
    ]
  };

  filters = {
    'filter-all': function(todo) {
      return true;
    },
    'filter-active': function(todo) {
      return !todo.completed;
    },
    'filter-completed': function(todo) {
      return todo.completed;
    }
  };

  $(function() {
    var TodoItem;
    window.TodoApp = review.view('.todoapp', {
      active_filter: 'filter-all',
      events: {
        'keydown #new-todo': function(e) {
          if (e.which === 13) {
            data.todos.unshift({
              title: e.target.value,
              completed: false
            });
            return e.target.value = '';
          } else {
            return false;
          }
        },
        'click #filters': function(e) {
          console.log('set filter', e.target.className);
          return this.active_filter = e.target.className;
        },
        'change #toggle-all': function() {
          var all_checked, todo, _i, _len, _ref;
          all_checked = data.todos.filter(function(item) {
            return item.completed;
          }).length === data.todos.length;
          _ref = data.todos;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            todo = _ref[_i];
            todo.completed = !all_checked;
          }
          return true;
        },
        'click #clear-completed': function() {
          data.todos = data.todos.filter(function(item) {
            return !item.completed;
          });
          return true;
        }
      },
      scope: {
        '.n-completed': function() {
          return data.todos.filter(function(item) {
            return item.completed;
          }).length;
        },
        '.n-left': function() {
          return data.todos.length - data.todos.filter(function(item) {
            return item.completed;
          }).length;
        }
      },
      afterSync: function(data) {
        $('#filters *').removeClass('selected');
        return $('.' + this.active_filter).addClass('selected');
      }
    });
    TodoItem = review.view('.todo', {
      events: {
        'change .toggle[type="checkbox"]': function(e) {
          this.item.completed = e.target.checked;
          return true;
        },
        'dblclick .view label': function() {
          var _this = this;
          this.parent().editing_todo = this.item;
          return setTimeout(function() {
            return $('[type="text"]:visible').focus();
          }, 200);
        },
        'focusout [type="text"]': function(e) {
          this.item.title = e.target.value;
          return this.parent().editing_todo = null;
        },
        'keydown [type="text"]': function(e) {
          if (e.which === 13) {
            this.item.title = e.target.value;
            return this.$.removeClass('editing');
          } else if (e.which === 27) {
            return this.$.removeClass('editing');
          } else {
            return false;
          }
        },
        'click .destroy': function(e) {
          var _this = this;
          return data.todos = data.todos.filter(function(item) {
            return item !== _this.item;
          });
        }
      },
      afterSync: function(node, todo) {
        var app;
        this.$.toggleClass('editing', this.parent().editing_todo === todo);
        this.$.toggleClass('completed', todo.completed);
        app = this.parent();
        console.log(app.active_filter);
        console.log(filters[app.active_filter](todo));
        if (filters[app.active_filter](todo)) {
          $(node).css('display', 'block');
        } else {
          $(node).css('display', 'none');
        }
        return true;
      },
      syncData: function(data) {
        return this.parent().syncRoot();
      }
    });
    return review.init($('#todoapp').get(0), data);
  });

}).call(this);
