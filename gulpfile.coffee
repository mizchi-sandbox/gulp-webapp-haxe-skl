gulp       = require 'gulp'
rename     = require 'gulp-rename'
plumber    = require 'gulp-plumber'
concat     = require 'gulp-concat'
sass       = require 'gulp-sass'
bowerFiles = require "gulp-bower-files"
source     = require 'vinyl-source-stream'
browserify = require 'browserify'
shell      = require 'gulp-shell'

gulp.task 'coffee', ->
  browserify
    entries: ['./app/pre.coffee']
    extensions: ['.coffee','.jade', '.js', '.ts']
  .transform 'coffeeify'
  .transform 'jadeify'
  .bundle()
  .pipe plumber()
  .pipe source 'pre.js'
  .pipe gulp.dest 'public'

gulp.task 'vendor', ->
  bowerFiles()
    .pipe plumber()
    .pipe concat('vendor.js')
    .pipe gulp.dest('./public')

gulp.task 'haxe', shell.task [
  'haxe build.hxml'
]

gulp.task 'css', ->
  gulp
    .src './app/styles/*.scss'
    .pipe plumber()
    .pipe sass()
    .pipe gulp.dest './public'

gulp.task 'watch', ['build'], ->
  gulp.watch 'app/**/*.coffee', ['coffee']
  gulp.watch 'app/**/*.jade', ['coffee']
  gulp.watch 'app/haxe/**/*.hx', ['haxe']
  gulp.watch 'app/styles/**/*.scss', ['css']
  gulp.watch 'bower_components/**/*.js', ['vendor']

gulp.task 'build', ['vendor', 'haxe', 'css', 'coffee']
gulp.task 'default', ['build']
