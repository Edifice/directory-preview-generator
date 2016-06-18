'use strict'

electron = require('electron')
fs = require('fs')
path = require('path')
_ = require('lodash')

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

    JSON.parse(fs.readFileSync(config.dbDataPath)).files || []

appendData = (newFile)->
    data.push(newFile)
    writeData()

writeData = ->
    fs.writeFileSync(config.dbDataPath, JSON.stringify({files: data}))

data = collectData()
events = {}


$(document).ready ->
    $('.add-button').on 'click', (event)->
        event.preventDefault()
        document.querySelector('#add-dialog').showModal()
        @

    $('#add-dialog button.add-confirm-button').on 'click', ->
        serialized = $('#add-dialog form').serializeArray()
        filePath = _.find(serialized, ['name', 'add-dialog-file-input-hidden']).value
        fileStats = fs.statSync(filePath)
        newFile =
            file:
                path: path.relative __dirname, filePath
                ino: fileStats.ino
                size: fileStats.size
            sample: path.relative __dirname, _.find(serialized, ['name', 'add-dialog-sample-input-hidden']).value
            category: _.find(serialized, ['name', 'add-dialog-category']).value
            tags:serialized.filter (elem)->
                elem.name is 'add-dialog-tags'
            .map (elem)->
                elem.value

        $('#add-dialog form')[0].reset()
        $('#add-dialog')[0].close()
        appendData newFile

    $('#add-dialog button.add-close-button').on 'click', ->
        $('#add-dialog form')[0].reset()
        $('#add-dialog')[0].close()
        @

    $('.file-picker button').bind 'click', (event)->
        event.preventDefault()
        filePath = electron.remote.dialog.showOpenDialog()
        filePath = filePath[0] if $.isArray filePath
        $('input[type=hidden]', $(this).parent()).val(filePath)
        $('input[type=text]', $(this).parent()).val(filePath.substr(filePath.lastIndexOf(path.sep) + 1)).parent().addClass('is-dirty')
        false

    $('select.selectize').selectize
        plugins: ['restore_on_backspace', 'remove_button']
        delimiter: ','
        persist: false
        create: (input) ->
            value: input
            text: input

    @
