QUnit.module \core-js
test 'Object.isObject' !->
  {isObject} = Object
  ok typeof! isObject is \Function, 'Is function'
  ok not isObject(void), 'isObject undefined return false'
  ok not isObject(null), 'isObject null return false'
  ok not isObject(1), 'isObject number return false'
  ok not isObject(true), 'isObject bool return false'
  ok not isObject('string'), 'isObject string return false'
  ok isObject(new Number 1), 'isObject new Number return true'
  ok isObject(new Boolean no), 'isObject new Boolean return true'
  ok isObject(new String 1), 'isObject new String return true'
  ok isObject({}), 'isObject object return true'
  ok isObject([]), 'isObject array return true'
  ok isObject(/./), 'isObject regexp return true'
  ok isObject(->), 'isObject function return true'
  ok isObject(new ->), 'isObject constructor instance return true'