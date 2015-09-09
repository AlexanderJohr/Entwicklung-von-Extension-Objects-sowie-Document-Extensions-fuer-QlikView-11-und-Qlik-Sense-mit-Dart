var EXTENSION_NAME = "C3Kreisdiagramm";

var remoteUrl = Qva.Remote + (Qva.Remote.indexOf('?') >= 0 ? '&' : '?') +
  'public=only&name=Extensions/' + EXTENSION_NAME;
var cssFiles = [remoteUrl + '/c3.min.css', remoteUrl + '/style.css'];
for (var i = 0; i < cssFiles.length; i++) {
  Qva.LoadCSS(cssFiles[i]);
}
var jsFiles = [remoteUrl + '/d3.min.js', remoteUrl + '/c3.min.js'];
Qv.LoadExtensionScripts(jsFiles, function() {
  Qva.AddExtension(EXTENSION_NAME, function() {
    var qvaWrapper = this;
    var objectId = qvaWrapper.Layout.ObjectId.replace("\\", "");
    window[EXTENSION_NAME + objectId] = this;

    var c3Columns = new Array();
    var idNameMap = {};
    for (var i = 0; i < qvaWrapper.Data.Rows.length; i++) {

      var row = qvaWrapper.Data.Rows[i];
      var id = row[0].value;
      var dimension = row[0].text;
      var value = row[1].data;

      var c3Column = [id, value];
      c3Columns.push(c3Column);
      idNameMap[id] = dimension;
    }
    var showLegend = Boolean(qvaWrapper.Layout.Text0.text);

    $(qvaWrapper.Element).empty();
    var chartDivElement = document.createElement("div");
    chartDivElement.className = "kreisdiagramm";
    qvaWrapper.Element.appendChild(chartDivElement);

    c3.generate({
      bindto: chartDivElement,
      data: {
        columns: c3Columns,
        type: 'pie',
        onclick: function(data) {
          qvaWrapper.Data.SelectValuesInColumn(0, data.id, false);
        },
        names: idNameMap
      },
      legend: {
        show: showLegend
      }
    });
  });
});
