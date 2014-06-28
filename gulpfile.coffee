gulp       = require 'gulp'
rename     = require 'gulp-rename'
plumber    = require 'gulp-plumber'
concat     = require 'gulp-concat'
sass       = require 'gulp-sass'
bowerFiles = require "gulp-bower-files"
typescript = require "gulp-tsc"
source     = require 'vinyl-source-stream'
browserify = require 'browserify'
tsd        = require 'gulp-tsd'
typescript = require 'gulp-tsc'

gulp.task 'js', ->
  gulp
    .src ['app/app.ts']
    .pipe plumber()
    .pipe typescript
      sourcemap: true
      outDir: './public'
      target: 'ES5'
      module: 'commonjs'
    # .pipe rename 'app.js'
    .pipe gulp.dest 'public'

gulp.task 'tsd', ->
  gulp
    .src './gulp-tsd.json'
    .pipe tsd()

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

gulp.task 'css', ->
  gulp
    .src './app/styles/*.scss'
    .pipe plumber()
    .pipe sass()
    .pipe gulp.dest './public'

gulp.task 'watch', ['build'], ->
  gulp.watch 'app/**/*.coffee', ['coffee']
  gulp.watch 'app/**/*.jade', ['coffee']
  gulp.watch 'app/**/*.ts', ['js']
  gulp.watch 'app/styles/**/*.scss', ['css']
  gulp.watch 'bower_components/**/*.js', ['vendor']

gulp.task 'build', ['tsd','vendor', 'js', 'css', 'coffee']
gulp.task 'default', ['build']
