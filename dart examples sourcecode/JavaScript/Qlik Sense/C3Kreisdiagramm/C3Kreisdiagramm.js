define(["./initialProperties", "./definition", "./c3",
  "text!./c3.min.css", "text!./style.css"], 
  function(initialPropertiesJs, definitionJs, c3Js, c3Css, styleCss) {
  'use strict';

  $("<style>").html(c3Css).appendTo("head");
  $("<style>").html(styleCss).appendTo("head");

  return {
    initialProperties: initialPropertiesJs,
    definition: definitionJs,
    paint: function($contentDiv, extensionData) {
      var extensionObject = this;
      var objectId = extensionData.qInfo.qId;
      window["C3KreisdiagrammObject" + objectId] = extensionObject;
      window["C3KreisdiagrammData" + objectId] = extensionData;

      var c3Columns = new Array();
      var idNameMap = {};
      extensionObject.backendApi.eachDataRow(function(rownum, row) {
        var id = row[0].qElemNumber;
        var dimension = row[0].qText;
        var value = row[1].qText;
        var c3Column = [id, value];
        c3Columns.push(c3Column);
        idNameMap[id] = dimension;
      });

      $contentDiv.empty();
      var chartDivElement = $("<div>");
      chartDivElement.className = "kreisdiagramm";
      $contentDiv.append(chartDivElement);

      c3Js.generate({
        bindto: $contentDiv[0],
        data: {
          columns: c3Columns,
          type: 'pie',
          onclick: function(data) {
            extensionObject.backendApi.selectValues(0, [parseInt(
              data.id)], false);
          },
          names: idNameMap
        },
        legend: { show: extensionData.showLegend }
      });
    }
  };
});
