


data =
  todos: [
      title: 'first title'
      completed: true
    ,
      title: 'second title'
      completed: true
  ]
  filters: [
      title: 'all'
      fn: (todo)-> true
    ,
      title: 'active'
      fn: (todo)-> not todo.completed
    ,
      title: 'completed'
      fn: (todo)-> todo.completed
  ]

views = 

  header:

    'keydown #new-todo': (e)->
      if e.which is 13
        data.todos.unshift
          title: e.target.value
          completed: false
        e.target.value = ''

    'change #toggle-all': ->
      all_checked = data.todos.filter( (item)-> item.completed ).length is data.todos.length
      for todo in data.todos
        todo.completed = not all_checked
  
  footer:

    'click #clear-completed': ->
      data.todos = data.todos.filter( (item)-> not item.completed )

    'n-completed': ->
      data.todos.filter( (item)-> item.completed ).length

    'n-left': ->
      data.todos.length - data.todos.filter( (item)-> item.completed ).length

    filters:

      'click #filters': (e)->
        @active_filter = e.target.className

      afterSync: ->
        @$.toggleClass 'selected', @selected

  todos:

    'change .toggle[type="checkbox"]': (e)->
      @item.completed = e.target.checked

    'dblclick .view label': ->
      @editing = true
      @then =>
        @$.find('[type="text"]:visible').focus()

    'focusout [type="text"]': (e)->
      @item.title = e.target.value
      @editing = false # No race condition because dblclick happens later than focusout.
    
    'keydown [type="text"]': (e)->
      if e.which is 13
        @item.title = e.target.value
        @editing = false
      else if e.which is 27
        @editing = false
      else
        false

    'click .destroy': (e)->
      data.todos = data.todos.filter (item)=>
        item isnt @item
    
    afterSync: (node, todo)-> # crap, but necessary for jQuery plugins

      @$.toggleClass 'editing', @editing
      @$.toggleClass 'completed', todo.completed

      if $('#filters .active').item()(todo)
        $(node).css 'display', 'block'
      else
        $(node).css 'display', 'none'

      views.footer.sync()

