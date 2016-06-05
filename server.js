(function() {
    "use strict";

    var walk = require('walk'),
        fs = require('fs'),
        path = require('path'),
        postfix = '_sample',
        dbPath = __dirname + path.sep + 'generator.json',
        dbData = JSON.parse(fs.readFileSync(dbPath)),
        rootPath = __dirname.substr(0, __dirname.lastIndexOf(path.sep)) + path.sep + 'test';

    //var handleFileReading = function(){

        console.log('Start digging into ' + rootPath);
        var files = [];
        var walker = walk.walk(rootPath, {
            filters: ['.git', 'bower_components', 'node_modules', 'out', '__generator']
        });

        walker.on("file", function(root, fileStats, next) {
            // fs.readFile(fileStats.name, function () {
            //     // doStuff
            // });
            if (fileStats.name.indexOf(postfix) !== -1){
                var file = {
                    ino: fileStats.ino,
                    tags: dbData[fileStats.ino + ''],
                    image: (root + path.sep + fileStats.name).replace(__dirname + path.sep, '')
                };
                file.path = file.image.replace(postfix, '');
                files.push(file);
                //     console.log(fs.statSync(fileStats.name))
            }
            // console.log(fileStats.name);
            next();
        });

        walker.on("errors", function(root, nodeStatsArray, next) {
            next();
        });

        walker.on("end", function() {
            console.log(files);
            console.log("all done");
        });
    };

}());
var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Hello World!');
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});
