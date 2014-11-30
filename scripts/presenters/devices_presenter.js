(function() {
  var DevicesPresenter = function() {};

  DevicesPresenter.prototype.deviceList = function(devices) {
    var out = {};

    if(devices.length > 0) {
      out.availableDevices = {devices: devices};
    }

    return out;
  };

  BH.Presenters.DevicesPresenter = DevicesPresenter;
})();
