'use strict'

window.$ = window.jQuery = require('./bower_components/jquery/dist/jquery.min.js')
electron = require('electron')
fs = require('fs')
path = require('path')

config = {}
config.dbPath = __dirname + path.sep + '..' + path.sep + '.db'
config.dbDataPath = config.dbPath + path.sep + 'generator.json'
config.rootPath = __dirname.substr(0, __dirname.lastIndexOf(path.sep)) + path.sep + 'testStructure'



collectData = ->
    try
        # check access to db json file
        fs.accessSync config.dbDataPath, fs.F_OK
    catch error
        # create db json file if it doesn't exist
        fs.writeFileSync config.dbDataPath, JSON.stringify {}

    # JSON.parse(fs.readFileSync(dbDataPath))

    # file =
    #     ino: fileStats.ino
    #     tags: dbData[fileStats.ino + '']
    #     image: (root + path.sep + fileStats.name).replace(__dirname + path.sep, '')
    #
    # file.path = file.image.replace(postfix, '')

    [
        imo: "281474976816702"
        path: '../../design resources/mockups/devices/Facebook Devices/Nexus 5X/Device with Shadow/Nexus 5X.png'
        image: '../../design resources/mockups/devices/Facebook Devices/Nexus 5X/Device with Shadow/Nexus 5X.png'
        tags: ['mockup', 'device', 'phone', 'nexus']
    ]

console.log data = collectData()

$ ->
    console.log __dirname
