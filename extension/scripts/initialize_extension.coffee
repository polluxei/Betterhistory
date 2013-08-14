window.track = new BH.Lib.Track(_gaq)

window.onerror = (msg, url, lineNumber) ->
  track.error(msg, url, lineNumber)

new BH.Lib.DateI18n().configure()
window.router = new BH.Router()
Backbone.history.start()

unless localStorage.mailingListPromptSeen?
  mailingListPromptTimer = parseInt(localStorage.mailingListPromptTimer, 10) || 3
  if mailingListPromptTimer == 1
    new BH.Views.MailingListView().open()
    delete localStorage.mailingListPromptTimer
    localStorage.mailingListPromptSeen = true
  else
    localStorage.mailingListPromptTimer = mailingListPromptTimer - 1
