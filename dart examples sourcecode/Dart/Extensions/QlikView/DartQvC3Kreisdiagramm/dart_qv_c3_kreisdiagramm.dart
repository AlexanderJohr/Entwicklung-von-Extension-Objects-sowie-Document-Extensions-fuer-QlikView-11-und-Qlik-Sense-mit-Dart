// Copyright (c) 2015, Alexander Johr. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
part of dart_qv_c3_kreisdiagramm;

class DartQvC3Kreisdiagramm extends QlikViewExtensionObject {
  DartQvC3Kreisdiagramm(JsObject qvaWrapper) : super(qvaWrapper);

  final DivElement pieChartDiv 
    = new DivElement()..classes.add("kreisdiagramm");
  bool get showLegend
    => qvaWrapper['Layout']['Text0']['text'] == 1 ? true : false;
  
  @override
  void onCreate() {
  final completer0 = new Completer();
  scheduleMicrotask(() {
    try {
      context['${name}${objectId.replaceFirst(r"\", "")}'] = this;
      contentDiv.append(pieChartDiv);
      loadStyleSheets([
          "style.css",
          "c3.min.css"
      ]);
      new Future.value(loadScripts([
          "d3.min.js",
          "c3.min.js"
      ])).then((x0) {
        try {
          x0;
          onPaint();
          completer0.complete();
        } catch (e0, s0) {
          completer0.completeError(e0, s0);
        }
      }, onError: completer0.completeError);
    } catch (e, s) {
      completer0.completeError(e, s);
    }
  });
  return completer0.future;
}

  @override
  void onPaint() {
    Map c3PieChartParams = {
      'bindto': pieChartDiv,
      'data': {
        'columns': dataAsList,
        'type': 'pie',
        'onclick': (data, svgShape) {
          selectValues(0, [int.parse(data['id'])]
          , selectionMode: SelectionMode.replacePrevious);
        },
        'names': idNameMap
      },
      'legend': {
        'show': showLegend
      }
    };
    context['c3'].callMethod('generate'
        , [new JsObject.jsify(c3PieChartParams)]);
  }  
}
