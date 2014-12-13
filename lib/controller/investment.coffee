
# /*
#   Investment
# */
# Author: yuhan.wyh<yuhan.wyh>
# Create: Fri Dec 12 2014 21:50:01 GMT+0800 (CST)
#

investmentModule = require( '../module/investment' )()

class Investment

  constructor : ( @options ) ->

  add : ->
    ( next ) -->
      { body } = @
      yield investmentModule.add body
      @body = 'ok'

module.exports = ( options ) ->
  new Investment options
