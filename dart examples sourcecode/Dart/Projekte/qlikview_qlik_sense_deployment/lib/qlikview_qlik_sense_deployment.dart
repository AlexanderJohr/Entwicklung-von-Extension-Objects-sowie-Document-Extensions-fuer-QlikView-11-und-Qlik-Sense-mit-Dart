// Copyright (c) 2015, Alexander Johr. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library qlikview_qlik_sense_deployment;

import 'package:barback/barback.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';

class QlikViewQlikSenseDeployment extends Transformer {
  String destScriptFilePath, destFolder;

  QlikViewQlikSenseDeployment.asPlugin(BarbackSettings settings) {
    var options = settings.configuration;
    destFolder = options['deploymentFolder'];
    var destScriptFile = options['destinationScriptFile'];
    destScriptFilePath = join(destFolder, destScriptFile);
  }

  Future apply(Transform transform) {
    return transform.primaryInput.readAsString().then((content) {
      var id = transform.primaryInput.id;
      bool isScript = id.path.endsWith('.dart.js');
      bool isScriptMap = id.path.endsWith('.dart.js.map');
      var fileName = basename(id.path);
      var destFilePath = join(destFolder, fileName);
      if (isScript) {
        new File(destScriptFilePath).writeAsStringSync(content
            , flush: true);
      } else if (isScriptMap) {
        Map scriptMapJson = JSON.decode(content);
        var sources = scriptMapJson['sources'] as List;
        for (int i = 0; i < sources.length; i++) 
          sources[i] = sources[i].replaceFirst("\.\./", "");
        String jsonData = JSON.encode(scriptMapJson);
        new File(destFilePath).writeAsStringSync(jsonData, flush: true);
      } else {
        new File(destFilePath).writeAsStringSync(content, flush: true);
      }
    });
  }
}
