class BH.Collections.Devices extends Backbone.Collection
  fetch: ->
    chrome.sessions.getDevices maxResults: 3, (devices) =>
      console.log devices
