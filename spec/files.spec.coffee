Files = require('../src/files')
config = require('../configut.json')
winston = require('winston')
require('../src/initlog')(config.debug.level)

files = new Files(config.files)

describe "Files test", ->
  it "should return the correct files", ->
    ret = files.get_files()
    winston.debug "#{JSON.stringify ret, null, 2}"
    expect(ret.files.length).toBe(3)

  it "should return the correct files in subdir", ->
    ret = files.get_files("subdir1")
    winston.debug "#{JSON.stringify ret, null, 2}"
    expect(ret.files.length).toBe(2)