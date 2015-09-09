// Copyright (c) 2015, Alexander Johr. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library DartDownloadArbeitsblattAlsPng;

import 'dart:async';
import 'dart:html';
import 'dart:js';
import 'dart:math';
import 'package:qlikview_qlik_sense_extensions/qlikview_qlik_sense_extensions.dart';

part 'dart_download_arbeitsblatt_als_png.dart';

void main() {  
  registerQlikViewDocumentExtension(
      () => new DartDownloadArbeitsblattAlsPng("DartDownloadArbeitsblattAlsPng"));
}
