QUnit.module \ES5

isFunction = -> typeof! it is \Function

eq = strictEqual
deq = deepEqual

test 'Object.getOwnPropertyDescriptor' !->
  {getOwnPropertyDescriptor} = Object
  ok isFunction(getOwnPropertyDescriptor), 'Is function'
  deepEqual getOwnPropertyDescriptor(q:42, \q), {+writable, +enumerable, +configurable, value: 42}
  ok getOwnPropertyDescriptor({}, \toString) is void
test 'Object.defineProperty' !->
  {defineProperty} = Object
  ok isFunction(defineProperty), 'Is function'
  ok (rez = defineProperty src = {}, \q, value: 42) is src
  ok rez.q is 42
test 'Object.defineProperties' !->
  {defineProperties} = Object
  ok isFunction(defineProperties), 'Is function'
  ok (rez = defineProperties src = {}, q: {value: 42}, w: value: 33) is src
  ok rez.q is 42 and rez.w is 33
test 'Object.getPrototypeOf' !->
  {create, getPrototypeOf} = Object
  ok isFunction(getPrototypeOf), 'Is function'
  ok getPrototypeOf({}) is Object::
  ok getPrototypeOf([]) is Array::
  ok getPrototypeOf(new class fn) is fn::
  ok getPrototypeOf(create obj = q:1) is obj
  ok getPrototypeOf(create null) is null
  ok getPrototypeOf(getPrototypeOf {}) is null
  
  foo = ->
  foo::foo = \foo
  bar = ->
  bar:: = create foo::
  bar::constructor = bar
  eq getPrototypeOf(bar::).foo, \foo

test 'Object.getOwnPropertyNames' !->
  {getOwnPropertyNames} = Object
  ok isFunction(getOwnPropertyNames), 'Is function'
  fn1 = (@w = 2)->
  fn2 = (@toString = 2)->
  fn1::q = fn2::q = 1
  deq getOwnPropertyNames([1 2 3]), <[0 1 2 length]>
  deq getOwnPropertyNames(new fn1 1), <[w]>
  deq getOwnPropertyNames(new fn2 1), <[toString]>
  ok \toString in getOwnPropertyNames Array::
  ok \toString in getOwnPropertyNames Object::
  ok \constructor in getOwnPropertyNames Object::
test 'Object.create' !->
  {create, getPrototypeOf, getOwnPropertyNames} = Object
  isObject = -> it is Object it
  isPrototype = (a, b)-> ({}).isPrototypeOf.call a, b
  getPropertyNames = (object)->
    result = getOwnPropertyNames object
    while object = getPrototypeOf(object)
      for getOwnPropertyNames(object)
        .. in result or result.push ..
    result
  ok isFunction(create), 'Is function'
  ok isPrototype obj = q:1, create(obj)
  ok create(obj)q is 1
  fn = -> @a = 1
  ok create(new fn) instanceof fn
  ok fn:: is getPrototypeOf getPrototypeOf create new fn
  ok create(new fn)a is 1
  ok create({}, {a:value:42})a is 42
  ok isObject obj = create null w: value:2
  ok \toString not of obj
  ok obj.w is 2
  deq getPropertyNames(create null), []
test 'Object.keys' !->
  {keys} = Object
  ok isFunction(keys), 'Is function'
  fn1 = (@w = 2)->
  fn2 = (@toString = 2)->
  fn1::q = fn2::q = 1
  deq keys([1,2,3]), <[0 1 2]>
  deq keys(new fn1 1), <[w]>
  deq keys(new fn2 1), <[toString]>
  ok \push not in keys Array::
test 'Object.seal' !->
  {seal} = Object
  ok isFunction(seal), 'Is function'
  eq seal(a = {}), a
test 'Object.freeze' !->
  {freeze} = Object
  ok isFunction(freeze), 'Is function'
  eq freeze(a = {}), a
test 'Object.preventExtensions' !->
  {preventExtensions} = Object
  ok isFunction(preventExtensions), 'Is function'
  eq preventExtensions(a = {}), a
test 'Object.isSealed' !->
  {isSealed} = Object
  ok isFunction(isSealed), 'Is function'
  eq isSealed({}), no
test 'Object.isFrozen' !->
  {isFrozen} = Object
  ok isFunction(isFrozen), 'Is function'
  eq isFrozen({}), no
test 'Object.isExtensible' !->
  {isExtensible} = Object
  ok isFunction(isExtensible), 'Is function'
  eq isExtensible({}), on

test 'Function#bind' !->
  ok isFunction(Function::bind), 'Is function'
  obj = a: 42
  ok 42 is (-> @a)bind(obj)!
  ok void is new ((->)bind obj)!a
  fn = (@a, @b)->
  inst = new (fn.bind null, 1) 2
  ok inst instanceof fn
  eq inst.a, 1
  eq inst.b, 2
  ok 42 is (-> it)bind(null 42)!
  fn = RegExp::test.bind /a/
  ok fn \a
  F = Date.bind null 2015
  date = new F 6
  ok date instanceof Date
  eq date.getFullYear!, 2015
  eq date.getMonth!, 6
test 'Array.isArray' !->
  {isArray} = Array
  ok isFunction(isArray), 'Is function'
  ok not isArray {}
  ok not isArray do -> &
  ok isArray []
test 'ES5 Array prototype methods are functions' !->
  for <[indexOf lastIndexOf every some forEach map filter reduce reduceRight]>
    ok isFunction(Array::[..]), "Array::#{..} is function"
test 'Array#slice' !->
  {slice} = Array::
  arr = <[1 2 3 4 5]>
  deq arr.slice!, arr
  deq arr.slice(1 3), <[2 3]>
  deq arr.slice(1 void), <[2 3 4 5]>
  deq arr.slice(1 -1), <[2 3 4]>
  deq arr.slice(-2 -1), <[4]>
  deq arr.slice(-2 -3), []
  str = \12345
  deq slice.call(str), arr
  deq slice.call(str, 1 3), <[2 3]>
  deq slice.call(str, 1 void), <[2 3 4 5]>
  deq slice.call(str, 1 -1), <[2 3 4]>
  deq slice.call(str, -2 -1), <[4]>
  deq slice.call(str, -2 -3), []
  if list = document?body?childNodes
    try eq typeof! slice.call(list), \Array
    catch => ok no
test 'Array#join' !->
  eq Array::join.call(\123), '1,2,3'
  eq Array::join.call(\123 \|), '1|2|3'
test 'Array#indexOf' !->
  ok 0  is [1 1 1]indexOf 1
  ok -1 is [1 2 3]indexOf 1 1
  ok 1  is [1 2 3]indexOf 2 1
  ok -1 is [NaN]indexOf NaN
  ok 3  is Array(2)concat([1 2 3])indexOf 2
  ok -1 is Array(1)indexOf void
test 'Array#lastIndexOf' !->
  eq 2,  [1 1 1]lastIndexOf 1
  eq -1, [1 2 3]lastIndexOf 3 1
  eq 1,  [1 2 3]lastIndexOf 2 1
  eq -1, [NaN]lastIndexOf NaN
  eq 1,  [1 2 3]concat(Array 2)lastIndexOf 2
test 'Array#every' !->
  (a = [1])every (val, key, that)->
    ok val  is 1
    ok key  is 0
    ok that is a
    ok @    is ctx
  , ctx = {}
  ok [1 2 3]every -> typeof! it is \Number
  ok [1 2 3]every (<4)
  ok not [1 2 3]every (<3)
  ok not [1 2 3]every -> typeof! it is \String
  ok [1 2 3]every (-> +@ is 1 ), 1
  rez = ''
  [1 2 3]every -> rez += &1
  ok rez is \012
  ok (arr = [1 2 3])every -> &2 is arr
test 'Array#some' !->
  (a = [1])some (val, key, that)->
    ok val  is 1
    ok key  is 0
    ok that is a
    ok @    is ctx
  , ctx = {}
  ok [1 \2 3]some -> typeof! it is \Number
  ok [1 2 3]some (<3)
  ok not [1 2 3]some (<0)
  ok not [1 2 3]some -> typeof! it is \String
  ok not [1 2 3]some (-> +@ isnt 1), 1
  rez = ''
  [1 2 3]some -> rez += &1; no
  ok rez is \012
  ok not (arr = [1 2 3])some -> &2 isnt arr
test 'Array#forEach' !->
  (a = [1])forEach (val, key, that)!->
    ok val  is 1
    ok key  is 0
    ok that is a
    ok @    is ctx
  , ctx = {}
  rez = ''
  [1 2 3]forEach !-> rez += it
  ok rez is \123
  rez = ''
  [1 2 3]forEach !-> rez += &1
  ok rez is \012
  rez = ''
  [1 2 3]forEach !-> rez += &2
  ok rez is '1,2,31,2,31,2,3'
  rez=''
  [1 2 3]forEach (!->rez+=@), 1
  ok rez is \111
  rez = ''
  arr = []
  arr.5 = ''
  arr.forEach (, k)!-> rez += k
  ok rez is \5
test 'Array#map' !->
  (a = [1])map (val, key, that)->
    ok val  is 1
    ok key  is 0
    ok that is a
    ok @    is ctx
  , ctx = {}
  deq [2 3 4] [1 2 3]map (+ 1)
  deq [1 3 5] [1 2 3]map ( + )
  deq [2 2 2] [1 2 3]map (-> +@), 2 
test 'Array#filter' !->
  (a = [1])filter (val, key, that)->
    ok val is 1
    ok key is 0
    ok that is a
    ok @ is ctx
  , ctx = {}
  deq [1 2 3 4 5] [1 2 3 \q {} 4 on 5]filter -> typeof! it is \Number
test 'Array#reduce' !->
  ok -5 is [5 4 3 2 1]reduce (-)
  (a = [1])reduce (memo, val, key, that)->
    ok memo is 42
    ok val  is 1
    ok key  is 0
    ok that is a
  , 42
  [42 43]reduce ->
    ok it is 42
test 'Array#reduceRight' !->
  ok -5 is [1 2 3 4 5]reduceRight (-)
  (a = [1])reduceRight (memo, val, key, that)->
    ok memo is 42
    ok val  is 1
    ok key  is 0
    ok that is a
  , 42
  [42 43]reduceRight ->
    ok it is 43
test 'Date.now' !->
  {now} = Date
  ok isFunction(now), 'Is function'
  ok +new Date - now! < 10, 'Date.now() ~ +new Date'
test 'Date#toISOString' !->
  ok isFunction(Date::toISOString), 'Is function'
  eq new Date(0).toISOString(), '1970-01-01T00:00:00.000Z'
  eq new Date(1e12+1).toISOString(), '2001-09-09T01:46:40.001Z'
  eq new Date(-5e13-1).toISOString(), '0385-07-25T07:06:39.999Z'
  ft =  new Date(1e15+1).toISOString()
  ok(ft is '+033658-09-27T01:46:40.001Z' or ft is '33658-09-27T01:46:40.001Z')
  bc =  new Date(-1e15+1).toISOString()
  ok(bc is '-029719-04-05T22:13:20.001Z' or bc is '-29719-04-05T22:13:20.001Z')
  throws (-> new Date(NaN).toISOString!), RangeError