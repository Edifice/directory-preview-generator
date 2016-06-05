window.$ = window.jQuery = require('./bower_components/jquery/dist/jquery.min.js')
electron = require('electron')

data = [{
    path: '../../design resources/mockups/devices/Facebook Devices/Nexus 5X/Device with Shadow/Nexus 5X.png',
    image: '../../design resources/mockups/devices/Facebook Devices/Nexus 5X/Device with Shadow/Nexus 5X.png',
    tags: ['mockup', 'device', 'phone', 'nexus']
}]

$ ->
    console.log __dirname
