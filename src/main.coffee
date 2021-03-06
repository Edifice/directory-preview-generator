electron = require('electron')
app = electron.app
BrowserWindow = electron.BrowserWindow
mainWindow = undefined

# Quit when all windows are closed.
app.on 'window-all-closed', ->
    if process.platform != 'darwin'
        app.quit()
    return

# This method will be called when Electron has done everything
# initialization and ready for creating browser windows.
app.on 'ready', ->
    # Create the browser window.
    mainWindow = new BrowserWindow
        width: 1024
        height: 768
    # and load the index.html of the app.
    mainWindow.loadURL 'file://' + __dirname + '/index.html'
    # Emitted when the window is closed.
    mainWindow.on 'closed', ->
        # Dereference the window object, usually you would store windows
        # in an array if your app supports multi windows, this is the time
        # when you should delete the corresponding element.
        mainWindow = null
        return
    return
