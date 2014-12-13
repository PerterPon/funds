
# /*
#  Note
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Sat Aug 30 2014 16:02:50 GMT+0800 (CST)
#

"use strict"

db       = require( '../core/db' )()

thunkify = require 'thunkify-wrap'

GET_FUNDS =
  """
  SELECT *
  FROM funds
  WHERE is_delete = 'n';
  """

INSERT_OR_UPDATE_FUNDS =
  """
  INSERT INTO funds (
    name,
    month_get,
    month_cost,
    month_deal_line,
    month_rate,
    year_get,
    year_cost,
    year_dead_line,
    year_rate
  )
  VALUES(
    :name,
    :month_get,
    :month_cost,
    :month_deal_line,
    :month_rate,
    :year_get,
    :year_cost,
    :year_dead_line,
    :year_rate
  )
  ON DUPLICATE KEY UPDATE
    name            = VALUES( name ),
    month_get       = VALUES( month_get ),
    month_cost      = VALUES( month_cost ),
    month_deal_line = VALUES( month_deal_line ),
    month_rate      = VALUES( month_rate ),
    year_get        = VALUES( year_get ),
    year_cost       = VALUES( year_cost ),
    year_dead_line  = VALUES( year_dead_line ),
    year_rate       = VALUES( year_rate );
  """

class Note

  getFunds : thunkify ( cb ) ->
    db.query GET_FUNDS, {}, cb

  insertOrUpdateFunds : thunkify ( item, cb ) ->
    db.query INSERT_OR_UPDATE_FUNDS, item, cb

module.exports = ->
  new Note