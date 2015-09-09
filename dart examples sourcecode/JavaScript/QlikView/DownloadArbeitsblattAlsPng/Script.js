var EXTENSION_NAME = "DownloadArbeitsblattAlsPng";
var F10_KEY = 121;

var remoteUrl = Qva.Remote + (Qva.Remote.indexOf('?') >= 0 ? '&' : '?') +
  'public=only&type=document&name=Extensions/' + EXTENSION_NAME;
var jsFiles = [remoteUrl + '/html2canvas.js', remoteUrl + '/rgbcolor.js',
  remoteUrl + '/StackBlur.js', remoteUrl + '/canvg.js'
];
Qv.LoadExtensionScripts(jsFiles, function() {
  Qva.AddDocumentExtension(EXTENSION_NAME, function() {
    $(document).keydown(function(event) {
      if (F10_KEY == event.keyCode) {
        var sheetSize = getSheetSize();
        canvg();
        downloadSheetAsPng(sheetSize);
      }
    });
  });
});

function getSheetSize() {
  var sheetSize = {};
  var elements = document.querySelectorAll('#MainContainer *');
  sheetSize.right = 0;
  sheetSize.bottom = 0;

  for (var i = 0; i < elements.length; i++) {
    var elementRight = elements[i].offsetLeft + elements[i].offsetWidth;
    var elementBottom = elements[i].offsetLeft + elements[i].offsetWidth;
    sheetSize.right = Math.max(sheetSize.right, elementRight);
    sheetSize.bottom = Math.max(sheetSize.bottom, elementBottom);
  }

  return sheetSize;
}

function downloadSheetAsPng(sheetSize) {
  html2canvas(document.body, {
    width: sheetSize.right,
    height: sheetSize.bottom,
    onrendered: function(canvas) {
      var link = document.createElement('a');
      link.href = canvas.toDataURL();
      link.download = 'print.png';
      link.click();
    }
  });
}
