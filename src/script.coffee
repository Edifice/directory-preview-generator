'use strict'

electron = require('electron')
fs = require('fs')
path = require('path')
_ = require('lodash')
jimp = require('jimp')

config = {}
config.dbPath = __dirname + path.sep + '..' + path.sep + '.db'
config.dbDataPath = config.dbPath + path.sep + 'generator.json'
config.rootPath = __dirname.substr(0, __dirname.lastIndexOf(path.sep)) + path.sep + 'testStructure'
config.categories =
    'background': 'Background'
    'brush': 'Brush'
    'effect': 'Effect'
    'element': 'Element'
    'icon': 'Icon pack'
    'mockup': 'Mockup / Scene'
    'ready': 'Ready design template'
    'texture': 'Texture'
    'theme-pack': 'Theme based pack'
    'tool': 'Tool'
    'ui': 'UI'

collectData = ->
    try
        # check access to db json file
        fs.accessSync config.dbDataPath, fs.F_OK
    catch error
        # create db json file if it doesn't exist
        fs.writeFileSync config.dbDataPath, JSON.stringify {}

    JSON.parse(fs.readFileSync(config.dbDataPath)).files || []

countTags = (files)->
    tags = {}
    files.forEach (file)->
        file.tags.forEach (tag)->
            if typeof tags[tag] isnt 'number'
                tags[tag] = 0
            tags[tag] += 1
            @
        @

    $('.mdl-layout__drawer nav a').remove()
    for tag, count of tags
        $('.mdl-layout__drawer nav').append("<a class='mdl-navigation__link' href=''>#{tag} <small>(#{count})</small></a>")
    tags

appendData = (newFile)->
    currentFiles = collectData()
    currentFiles.push(newFile)
    writeData(currentFiles)

writeData = (data)->
    fs.writeFileSync(config.dbDataPath, JSON.stringify({files: data}))

updateList = ->
    data = collectData()
    tags = countTags(data)
    container = $('.page-content').html('')
    for file in data
        templateData =
            background: ('..' + path.sep + file.sample).replace(/\\/g, '/')
            tags: ''

        file.tags.forEach (tag)->
            templateData.tags += '<span class="mdl-badge" data-badge="' + tags[tag] + '">' + tag + '</span>'

        template = """
            <div class="mdl-card mdl-shadow--2dp">
                <div class="mdl-card__media" style="background-image: url('#{templateData.background}')"></div>
                <div class="mdl-card__supporting-text">
                    #{templateData.tags}
                </div>
                <div class="mdl-card__menu">
                    <button class="mdl-button mdl-button--icon mdl-js-button mdl-js-ripple-effect">
                        <i class="material-icons">content_copy</i>
                    </button>
                </div>
            </div>
        """

        container.append(template)

initSelectize = ->
    $('select.selectize').selectize
        plugins: ['restore_on_backspace', 'remove_button']
        delimiter: ','
        persist: false
        create: (input) ->
            value: input
            text: input

$(document).ready ->
    # set categories
    $('#add-dialog-category option').remove()
    $('.mdl-layout__header nav a').remove()
    for cat, text of config.categories
        $('#add-dialog-category').append("<option value='#{cat}'>#{text}</option>")
        $('.mdl-layout__header nav').append("<a class='mdl-navigation__link' href=''>#{text}</a>")

    $('.add-button').on 'click', (event)->
        event.preventDefault()
        select = $('#add-dialog-tags')
        $('option', select).remove()
        for tag, count of countTags(collectData())
            select.append('<option value="' + tag + '">' + tag + '</option>')
        initSelectize()
        document.querySelector('#add-dialog').showModal()
        @

    $('#add-dialog button.add-confirm-button').on 'click', ->
        serialized = $('#add-dialog form').serializeArray()
        filePath = _.find(serialized, ['name', 'add-dialog-file-input-hidden']).value
        fileStats = fs.statSync(filePath)
        newFile =
            recordDate: +new Date()
            file:
                path: path.relative __dirname, filePath
                ino: fileStats.ino
                size: fileStats.size
            category: _.find(serialized, ['name', 'add-dialog-category']).value
            tags: serialized.filter (elem)->
                elem.name is 'add-dialog-tags'
            .map (elem)->
                elem.value
        newFile.sample = path.relative __dirname + path.sep + '..', config.dbPath + path.sep + newFile.file.ino + '.png'

        samplePath = _.find(serialized, ['name', 'add-dialog-sample-input-hidden']).value
        jimp.read samplePath, (err, img)->
            throw err if err
            img.contain(300, 300)
                .quality(80)
                .write(newFile.sample)
            console.log newFile.sample + ' converted from "' + samplePath + '" and saved'

        $('#add-dialog form')[0].reset()
        $('#add-dialog')[0].close()
        appendData newFile
        setTimeout 1000, updateList
    @

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

    updateList()

    @
