'use strict';

var gulp = require('gulp');
var browserSync = require('browser-sync');

var $ = require('gulp-load-plugins')();

module.exports = function(options) {
  gulp.task('styles', function () {

    var injectFiles = gulp.src([
      options.src + '/{app,components}/**/*.styl',
      '!' + options.src + '/app/index.styl',
      '!' + options.src + '/app/vendor.styl'
    ], { read: false });

    var injectOptions = {
      transform: function(filePath) {
        filePath = filePath.replace(options.src + '/app/', '');
        filePath = filePath.replace(options.src + '/components/', '../components/');
        return '@import \'' + filePath + '\';';
      },
      starttag: '// injector',
      endtag: '// endinjector',
      addRootSlash: false
    };

    var indexFilter = $.filter('index.styl');

    return gulp.src([
      options.src + '/app/index.styl',
      options.src + '/app/vendor.styl'
    ])
    .pipe(indexFilter)
    .pipe($.inject(injectFiles, injectOptions))
    .pipe(indexFilter.restore())
    .pipe($.sourcemaps.init())
    .pipe($.stylus()).on('error', options.errorHandler('Stylus'))
    .pipe($.autoprefixer()).on('error', options.errorHandler('Autoprefixer'))
    .pipe($.sourcemaps.write())
    .pipe(gulp.dest(options.tmp + '/serve/app/'))
    .pipe(browserSync.reload({ stream: true }));
  });
};
