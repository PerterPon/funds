
# /**
#   Funds
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Mon Aug 18 2014 23:55:55 GMT+0800 (CST)
#

"use strict"

thunkify    = require 'thunkify-wrap'

fundsModule = require( '../module/funds' )()

class Funds

  getFunds : ->
    that = @
    ( next ) -->
      data  = yield fundsModule.getFunds()
      @body = data

  insertOrUpdateFunds : ->
    that = @
    ( next ) -->
      body  = @request
      yield fundsModule.insertOrUpdateFunds body
      @body = 'ok'

  forecast : ->
    that = @
    ( next ) -->
      { rate }      = @params
      rate         -= 0
      monthIncremental = 0
      monthReceipts = 0
      monthTotal    = 0
      yearReceipts  = 0
      yearTotal     = 0
      funds    = yield fundsModule.getFunds()
      for item in funds
        { base, name, month_get, month_cost, month_dead_line, month_rate, year_get, year_cost, year_dead_line, year_rate } = item
        fundReceipts     = ( base + month_get ) * ( 1 + rate / 12 ) - month_cost * ( 1 + month_rate ) - base
        monthIncremental += fundReceipts
        monthReceipts += ( base + month_get ) * ( rate / 12 ) - month_cost * month_rate
        monthTotal    += base + fundReceipts
      monthIncremental = that._beautifyMoney monthIncremental
      monthReceipts    = that._beautifyMoney monthReceipts
      monthTotal       = that._beautifyMoney monthTotal
      @body            = JSON.stringify { monthIncremental, monthReceipts, monthTotal }

  _beautifyMoney : ( number ) ->
    ( Math.round number * 100 ) / 100

module.exports = ( options ) ->
  new Funds options
   