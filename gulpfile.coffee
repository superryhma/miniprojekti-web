gulp = require 'gulp'
gutil = require 'gulp-util'
_ = require 'lodash'
wrench = require 'wrench'

options =
  src: 'src'
  dist: 'build'
  tmp: '.tmp'
  e2e: 'e2e'
  errorHandler: (title) ->
    (err) ->
      gutil.log gutil.colors.red('[' + title + ']'), err.toString()
      @emit 'end'

wrench.readdirSyncRecursive './gulp'
  .filter (file) ->
    /\.(js|coffee)$/i.test file
  .map (file) ->
    require('./gulp/' + file) options

gulp.task 'default', ['clean'], ->
  gulp.start 'build'
