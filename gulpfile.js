(function(){
    'use strict';

    var gulp = require('gulp'),
        stylus = require('gulp-stylus'),
        sourcemaps = require('gulp-sourcemaps'),
        coffee = require('gulp-coffee'),
        gutil = require('gulp-util'),
        del = require('del');

    gulp.task('clean', function (cb) {
        del(['out/**'], cb);
    });

    gulp.task('stylus', function () {
        return gulp.src('./src/style.styl')
            .pipe(sourcemaps.init())
            .pipe(stylus())
            .pipe(sourcemaps.write())
            .pipe(gulp.dest('./out'));
    });

    gulp.task('coffee', function(){
        return gulp.src('./src/**/*.coffee')
            .pipe(sourcemaps.init())
            .pipe(coffee({
                bare: true
            }).on('error', gutil.log))
            .pipe(sourcemaps.write())
            .pipe(gulp.dest('./out'));
    });

    gulp.task('index', [], function(){
        return gulp.src('./src/index.html')
            .pipe(gulp.dest('./out'));
    });

    gulp.task('compile', ['stylus', 'index', 'coffee'], function(){
        return ;
    });

    gulp.task('watch', ['compile'], function(){
        gulp.watch('./src/**/*.styl', ['stylus']);
        gulp.watch('./src/**/*.coffee', ['coffee']);
        gulp.watch('./src/index.html', ['index']);
    });
})();
