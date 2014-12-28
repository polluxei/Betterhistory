(function() {
  var Template = {
    fetch: function(name) {
      if(BH.Templates && BH.Templates[name]) {
        return BH.Templates[name];
      } else {
        var req = new XMLHttpRequest();
        req.open ('POST', '/templates/' + name, false);
        req.send();
        return req.response;
      }
    }
  };

  BH.Lib.Template = Template;
})();
