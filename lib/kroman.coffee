KromanLib = require './kroman_lib'
{CompositeDisposable, TextEditor} = require 'atom'

module.exports = Kroman =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'kroman:romanize-region': => @romanizeRegion()
    @subscriptions.add atom.commands.add 'atom-workspace', 'kroman:romanize-buffer': => @romanizeBuffer()
    @subscriptions.add atom.commands.add 'atom-workspace', 'kroman:romanize-and-compare': => @romanizeAndCompare()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  romanizeBuffer: ->
    if editor = atom.workspace.getActiveTextEditor()
      text = editor.getText()
      parsed = KromanLib.parse(text)
      editor.setText(parsed)
    return

  romanizeRegion: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.mutateSelectedText (selection, index) =>
        text = selection.getText()
        parsed = KromanLib.parse(text)
        selection.deleteSelectedText()
        selection.insertText(parsed)
    return

  romanizeAndCompare: ->
    if editor = atom.workspace.getActiveTextEditor()
      text = editor.getText()
      parsed = KromanLib.parse(text)
      pane = atom.workspace.getActivePane()
      item = pane.getActiveItem()
      newEditor = new TextEditor()
      newEditor.setText(parsed)
      pane.splitRight(items: [newEditor])
