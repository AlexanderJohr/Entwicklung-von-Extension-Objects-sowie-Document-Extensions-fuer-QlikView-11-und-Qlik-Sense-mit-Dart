// Copyright (c) 2015, Alexander Johr. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
part of dart_qs_c3_kreisdiagramm;

class DartQsC3Kreisdiagramm extends QlikSenseExtensionObject {

  DartQsC3Kreisdiagramm(JsObject extensionObject, JsObject extensionData, this.c3Js
      , this.c3Css, this.styleCss)
      : super(extensionObject, extensionData);

  final JsObject c3Js;
  final String c3Css, styleCss;
  final DivElement chartDivElement = new DivElement()..classes.add("kreisdiagramm");

  @override
  void onCreate() {
    context["DartC3Kreisdiagramm${objectId}"] = this;

    document.head.append(new StyleElement()..text = c3Css);
    document.head.append(new StyleElement()..text = styleCss);

    contentDiv.append(chartDivElement);

    onPaint();
  }

  @override
  void onPaint() {
    c3Js.callMethod('generate', [new JsObject.jsify({
        'bindto': chartDivElement,
        'data': {
          'columns': dataAsList,
          'type': 'pie',
          'onclick': (data, svgElement) {
            selectValues(0, [int.parse(data['id'])]);
          },
          'names': idNameMap
        },
        'legend': {
          'show': extensionData['showLegend']
        }
      })]);
  }
}
