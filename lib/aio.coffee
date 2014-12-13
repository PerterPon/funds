
# /*
#   AIO
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Tue Aug 12 2014 23:56:06 GMT+0800 (CST)
#

"use strict"

koa    = require 'koa'

Router = require 'koa-router'

mount  = require 'koa-mount'

Funds  = require './controller/funds'

Flows  = require './controller/flows'

koaBodyParse = require 'koa-body-parser'

staticServer = require 'koa-static'

db    = require( './core/db' )()

class Aio

  constructor : ( @options = {} ) ->
    @init options
    @app = koa()
    @useMiddleware()

  init : ( options ) ->
    db.init options.mysql, console

  useMiddleware : ->
    { app, options } = @
    funds = Funds options
    flows = Flows options
    app.use koaBodyParse()
    app.use staticServer "#{__dirname}/../res/"
    
    # funds router
    fundsRouter = new Router
    fundsRouter.get  '/', funds.getFunds()
    fundsRouter.post '/', funds.insertOrUpdateFunds()
    fundsRouter.put  '/', funds.insertOrUpdateFunds()

    # forecast router
    forecastRouter = new Router
    forecastRouter.get '/:rate', funds.forecast()

    # flows router
    flowsRouter = new Router
    flowsRouter.get '/in',          flows.inflows()
    flowsRouter.get '/out',         flows.outflows()
    flowsRouter.get '/healthCheck', flows.healthCheck()

    # mount middlewares
    app.use mount '/funds',    fundsRouter.middleware()
    app.use mount '/forecast', forecastRouter.middleware()
    app.use mount '/flows',    flowsRouter.middleware()

    app.on 'error', ( error ) ->
      console.log """
      ~~~~~~~~~~ server error ~~~~~~~~~~~
      #{error.message}
      #{error.stack}
      """

  listen : ( port, cb ) ->
    @app.listen port, cb

module.exports = Aio
