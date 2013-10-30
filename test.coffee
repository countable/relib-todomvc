
_extends = (child, parent)->
    for own key,val of parent
        child[key] = parent[key]

    ctor = ->
        this.constructor = child;
    ctor.prototype = parent.prototype
    child.prototype = new ctor()
    child.__super__ = parent.prototype
    child


class A
  constructor: ->
    @x=1
  @a: 1
  @b: 2
  c: 3
  d: 4
  e: ->

class B extends A
  constructor: ->
    @y=1
    super
  @a:5
  c: 6
  e: ->
    super


C = ->
    _ref = C.__super__.constructor.apply(this, arguments)
    return _ref
_extends(C, A)
C.a = 5
C::c = 6
C::e = ->
    C.__super__.e.apply(this, arguments)

console.log B.a
console.log C.a

