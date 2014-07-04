SystemStatus = require('../src/system_status')
config = require('../configut.json')
winston = require('winston')
require('../src/initlog')(config.debug.level)

describe "System Status Test", ->

  it "should display the correct status", ->
    system_status = new SystemStatus()
    system_status._get_db_status()
    waitsFor(()->
      status = system_status.get_status()
      if status.db?
        return true
      else
        return false
    ,"Timeout waiting", 7500)
    runs( ->
        status = system_status.get_status()
        winston.debug "status #{JSON.stringify status, null, 2}"
        expect(status.db.status).toEqual("ok")
      )

  it "should display the correct status using monitor", ->
    system_status = new SystemStatus()
    system_status.start_monitor()
    waitsFor(()->
      status = system_status.get_status()
      if status.db?
        return true
      else
        return false
    ,"Timeout waiting", 75000)
    runs( ->
        system_status.stop_monitor()
        status = system_status.get_status()
        expect(status.db).not.toBe(null);
        if status.db?
          expect(status.db.status).toEqual("ok")
      )