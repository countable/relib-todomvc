


window.data =
  todos: [
      title: 'first title'
      completed: false
    ,
      title: 'second title'
      completed: true
  ]


filters = 
  'filter-all': (todo)-> true
  'filter-active': (todo)-> not todo.completed
  'filter-completed': (todo)-> todo.completed

$ ->

  window.TodoApp = review.view '.todoapp',
    
    active_filter: 'filter-all'

    events:
      'keydown #new-todo': (e)->
        if e.which is 13
          data.todos.unshift
            title: e.target.value
            completed: false
          e.target.value = ''
        else
          false

      'click #filters': (e)->
        console.log 'set filter', e.target.className
        @active_filter = e.target.className

      'change #toggle-all': ->
        all_checked = data.todos.filter( (item)-> item.completed ).length is data.todos.length
        for todo in data.todos
          todo.completed = not all_checked
        true

      'click #clear-completed': ->
        data.todos = data.todos.filter( (item)-> not item.completed )
        true

    scope:
      '.n-completed': ->
        data.todos.filter( (item)-> item.completed ).length
      '.n-left': ->
        data.todos.length - data.todos.filter( (item)-> item.completed ).length
    
    afterSync: (data)->
      $('#filters *').removeClass 'selected'
      $('.'+@active_filter).addClass 'selected'

    resync: ->
      console.log 'resync'
      @syncRoot data

  TodoItem = review.view '.todo',
    
    events:
      'change .toggle[type="checkbox"]': (e)->
        @item.completed = e.target.checked
        true # crap

      'dblclick .view label': ->
        @parent().editing_todo = @item
        setTimeout => # crap
            $('[type="text"]:visible').focus()
          , 200

      'focusout [type="text"]': (e)->
        @item.title = e.target.value
        @parent().editing_todo = null # No race condition because dblclick happens later than focusout.
      
      'keydown [type="text"]': (e)->
        if e.which is 13
          @item.title = e.target.value
          @$.removeClass 'editing'
        else if e.which is 27
          @$.removeClass 'editing'
        else
          false

      'click .destroy': (e)->
        data.todos = data.todos.filter (item)=>
          item isnt @item
    
    afterSync: (todo)-> # crap, but necessary for jQuery plugins

      console.log 'AFTER-SYNC'
      @$.toggleClass 'editing', @parent().editing_todo is todo
      @$.toggleClass 'completed', todo.completed
      console.log todo.completed
      
      app = @parent()
      console.log app.active_filter
      console.log filters[app.active_filter] todo
      if filters[app.active_filter] todo
        @$.css 'display', 'block'
      else
        @$.css 'display', 'none'

      true

    resync: ->
      @parent().syncRoot data

  review.init $("#todoapp").get(0), data  # crap

