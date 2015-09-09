// Copyright (c) 2015, Alexander Johr. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library dart_qs_c3_kreisdiagramm;

import 'dart:html';
import 'dart:js';
import 'package:qlikview_qlik_sense_extensions/qlikview_qlik_sense_extensions.dart';

part 'dart_qs_c3_kreisdiagramm.dart';

void main() {
  defineModule(["./initialProperties", "./definition", "./c3"
                , "text!./c3.min.css", "text!./style.css"]
  , (JsObject initialPropertiesJs, JsObject definitionJs
      , JsObject c3Js, String c3Css, String styleCss) {
    return new JsObject.jsify({
      'initialProperties': initialPropertiesJs,
      'definition': definitionJs,
      'paint': new JsFunction.withThis((JsObject paintThis, JsObject $contentDiv
          , JsObject extensionData) {
        registerQlikSenseExtensionObject(extensionData
            , () => new DartQsC3Kreisdiagramm(paintThis, extensionData
                , c3Js, c3Css, styleCss));
      })
    });
  });
}
