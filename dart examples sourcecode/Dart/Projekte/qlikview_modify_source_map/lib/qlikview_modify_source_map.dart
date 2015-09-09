// Copyright (c) 2015, Alexander Johr. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library qlikview_modify_source_map;

import 'package:barback/barback.dart';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';

class QlikViewModifySourceMap extends Transformer {
  String scriptMapUrlRoot;

  QlikViewModifySourceMap.asPlugin(BarbackSettings settings) {
    var options = settings.configuration;
    var extName = options['extensionName'];
    var extType = options['extensionType'];
    var urlRoot = "QvsViewClient.aspx?";
    var params = "public=only&type=${extType}&name=Extensions/${extName}";
    scriptMapUrlRoot = "${urlRoot}${params}/";
  }

  @override
  Future apply(Transform transform) {
    return transform.primaryInput.readAsString().then((content) {
      var id = transform.primaryInput.id;      
      bool isScript = id.path.endsWith('.dart.js');
      bool isScriptMap = id.path.endsWith('.dart.js.map');
      if (isScript) {
        var regExp = new RegExp(r"sourceMappingURL=(.*).dart.js.map");
        var fileName = basename(id.path);
        var replacedLine = "sourceMappingURL=${scriptMapUrlRoot}${fileName}.map";
        var newContent = content.replaceFirst(regExp, replacedLine);
        transform.addOutput(new Asset.fromString(transform.primaryInput.id, newContent));
      } else if (isScriptMap) {
        Map scriptMapJson = JSON.decode(content);
        var sources = scriptMapJson['sources'] as List;
        for (int i = 0; i < sources.length; i++) 
          sources[i] = "${scriptMapUrlRoot}${sources[i]}";
        String jsonData = JSON.encode(scriptMapJson);
        transform.addOutput(new Asset.fromString(transform.primaryInput.id, jsonData));
      }
    });
  }
}
