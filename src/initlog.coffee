winston = require('winston')

module.exports = (level='info') ->
  winston.setLevels({debug:0,info:1,silly:2,warn: 3,error:4});
  winston.remove(winston.transports.Console)
  winston.add(winston.transports.Console, {'level': level, 'timestamp': true})