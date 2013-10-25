BH.Lib.ImageData =
  base64: (url, callback) ->
    img = new Image()
    img.src = url
    img.onload = =>
      canvas = document.createElement("canvas")
      ctx = canvas.getContext("2d")
      ctx.drawImage(img, 16, 16)
      dataURL = canvas.toDataURL("image/png")
      callback(dataURL)
