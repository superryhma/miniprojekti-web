'use strict';

var gulp = require('gulp');
var browserSync = require('browser-sync');

var $ = require('gulp-load-plugins')();

module.exports = function(options) {
  gulp.task('scripts', function () {
    return gulp.src([
      options.src + '/{app,components}/**/*.coffee',
      '!' + options.src + '/{app,components}/**/*.spec.coffee',
      '!' + options.src + '/{app,components}/**/*.mock.coffee'
    ])
      .pipe($.sourcemaps.init())
      .pipe($.coffeelint())
      .pipe($.coffeelint.reporter())
      .pipe($.coffee()).on('error', options.errorHandler('CoffeeScript'))
      .pipe($.sourcemaps.write())
      .pipe(gulp.dest(options.tmp + '/serve/'))
      .pipe(browserSync.reload({ stream: true }))
      .pipe($.size());
  });
};
