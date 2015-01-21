gulp = require 'gulp'
coffee = require 'gulp-coffee'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
mocha = require 'gulp-mocha'
require 'espower-coffee/guess'

paths =
  coffee: ["./develop/**/*.coffee"]
  static: ["./develop/**/*", "!./develop/**/*.coffee"]
  test: ["./test/**/*.coffee"]

gulp.task "coffee", ->
  gulp.src(paths.coffee)
  .pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
  .pipe coffee({bare: true})
  .pipe gulp.dest('./lib')
  return

gulp.task "copy", ->
  gulp.src(paths.static)
  .pipe gulp.dest("./lib")
  return

gulp.task "test", ->
  gulp.src("./test/**/*.coffee")
  .pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
    .pipe mocha()
  return

gulp.task "watch", ->
  gulp.watch paths.coffee, ["coffee", "test"]
  gulp.watch paths.static, ["copy"]
  gulp.watch paths.test, ["test"]
  return

gulp.task "default", [
  "watch"
]

