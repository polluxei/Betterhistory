(function() {
  var Template = {
    fetch: function(name) {
      if(BH.Templates && BH.Templates[name]) {
        return BH.Templates[name];
      } else {
        result = $.ajax({url: '/templates/' + name, async: false});
        return result.responseText;
      }
    }
  };

  BH.Lib.Template = Template;
})();
