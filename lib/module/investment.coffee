
# /*
#   Inverstment
# */
# Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
# Create: Fri Dec 12 2014 21:52:53 GMT+0800 (CST)
#

"use strict"

db  = require( '../core/db' )()

thunkify = require 'thunkify-wrap'

ADD =
  """
  INSERT INTO investment (
    name,
    begin,
    time_limit,
    year_rate,
    count,
    type
  )
  VALUES (
    :name,
    :begin,
    :time_limit,
    :year_rate,
    :count,
    :type
  );
  """

GET =
  """
  SELECT *
  FROM investment
  WHERE completed = 'n'
  """

class Investment

  add : thunkify ( where, cb ) ->
    db.query ADD, where, cb

  get : thunkify ( cb ) ->
    db.query GET, {}, cb

module.exports = ->
  new Investment

