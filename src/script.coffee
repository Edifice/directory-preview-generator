'use strict'

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

data = collectData()
events = {}


$(document).ready ->
    $('.add-button').on 'click', (event)->
        event.preventDefault()
        document.querySelector('#add-dialog').showModal()
        @

    $('#add-dialog button.add-confirm-button').on 'click', ->
        @

    $('#add-dialog button.add-close-button').on 'click', ->
        $('#add-dialog form')[0].reset()
        $('#add-dialog')[0].close()
        @

    $('.file-picker button').bind 'click', (event)->
        filePath = electron.remote.dialog.showOpenDialog()
        filePath = filePath[0] if $.isArray filePath
        $('input[type=hidden]', $(this).parent()).val(filePath)
        $('input[type=text]', $(this).parent()).val(filePath.substr(filePath.lastIndexOf(path.sep) + 1)).parent().addClass('is-dirty')
        @

    $('select.selectize').selectize
        plugins: ['restore_on_backspace', 'remove_button']
        delimiter: ','
        persist: false
        create: (input) ->
            value: input
            text: input

    @
