glob = require('glob')
winston = require('winston')
path = require('path')

#class to gather files based on directory info
class Files
  constructor: (@config) ->

  get_files: (directory="") ->
    ret = {}
    options = {}
    options.cwd = @config.top_dir
    pattern = path.join(directory, "*.*")
    ret.files = glob.sync(pattern, options)
    ret


module.exports = Files

