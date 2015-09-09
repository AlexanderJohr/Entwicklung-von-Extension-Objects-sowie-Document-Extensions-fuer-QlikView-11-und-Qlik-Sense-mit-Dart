// Copyright (c) 2015, Alexander Johr. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dart_qv_c3_kreisdiagramm;

import 'dart:html';
import 'dart:js';
import 'dart:async';
import 'package:qlikview_qlik_sense_extensions/qlikview_qlik_sense_extensions.dart';

part 'dart_qv_c3_kreisdiagramm.dart';

void main() {  
  registerQlikViewExtensionObject("DartQvC3Kreisdiagramm", 
      (JsObject qvaWrapper) => new DartQvC3Kreisdiagramm(qvaWrapper));
}


