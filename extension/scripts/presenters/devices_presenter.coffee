class BH.Presenters.DevicesPresenter
  deviceList: (devices) ->
    out = {}

    if devices.length > 0
      out.availableDevices = devices: devices

    out
