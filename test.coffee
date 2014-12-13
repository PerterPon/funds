
request = require 'request'

fs      = require 'fs'

wrap = ( fn, ctx ) ->
  ( args... ) ->
    cb   = null
    done = ( args... ) ->
      res = cb args
      { value, done } = res
      return if done is true
      value cb
    args.push done
    fn.apply ctx, args
    ( next ) ->
      cb = next

a = () -->
  request = wrap request
  fs.readFile = wrap fs.readFile
  g = yield request 'http://www.baidu.com'
  l = yield fs.readFile './README.md', 'utf-8'
  console.log g.length
  console.log l

A = a()
c = A.next()
c.value A.next.bind A