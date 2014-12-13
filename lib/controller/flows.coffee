
# /*
#   Flows
# */
# Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
# Create: Fri Dec 12 2014 21:44:41 GMT+0800 (CST)
#

"use strict"

fundModule = require( '../module/funds' )()

investmentModule = require( '../module/investment' )()

moment     = require 'moment'

class Flows

  constructor : ( @options ) ->

  inflows : ->
    ( next ) -->

  outflows : ->
    ( next ) -->

  # funds flows health check
  healthCheck : ->
    that = @
    ( next ) -->
      funds    = yield fundModule.getFunds()
      invs     = yield investmentModule.get()
      invsTimeline  = that._getInvsTimeline  invs
      fundsTimeline = that._getfundsTimeline funds
      left     = 0
      # do check every funds health
      for item in fundsTimeline
        { cost, time:fundsTime } = item
        totalEarnings = 0
        for { time:invsTime, earnings } in invsTimeline
          break if invsTime > fundsTime
          totalEarnings += earnings
        console.log left, totalEarnings, cost
        left += totalEarnings - cost
        if 0 <= left
          item.health = true
      @body = fundsTimeline

  # get inverstment time line
  _getInvsTimeline : ( invs ) ->
    ( for item in invs
        { name, begin, time_limit, year_rate, count } = item
        time     = moment( begin ).add( time_limit, 'day' )._d
        earnings = count * ( year_rate / 365 ) * time_limit + count
        { time, earnings, name, count }
    ).sort ( { time:a } , { time:b } ) -> a - b

  # get funds time line
  _getfundsTimeline : ( funds ) ->
    ( for item in funds
        { month_cost, name, month_rate, month_dead_line } = item
        cost = month_cost * ( 1 + month_rate )
        time = moment( ( new Date ).setDate month_dead_line ).add( 30, 'day' )._d
        { time, cost, name }
    ).sort ( { time:a }, { time:b } ) -> a - b

module.exports = ( options ) ->
  new Flows options
