// Copyright (c) 2015, Alexander Johr. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
part of qlikview_qlik_sense_extensions;

abstract class QlikViewExtensionObject extends ExtensionObject with QlikViewExtension {
  QlikViewExtensionObject(JsObject qvaWrapper)
      : super(qvaWrapper['Layout']['ObjectId'], qvaWrapper['Element']),
        this.qvaWrapper = qvaWrapper;

  final JsObject qvaWrapper;
  String get name => qvaWrapper['ObjectMgr']['Extension'];
  String get remoteAddress {
    String remoteRoot = context['qva']['Remote'] as String;
    return "${remoteRoot}${remoteRoot.
      contains('?') ? '&' : '?'}public=only&name=Extensions/${name}";
  }
  @override
  List get dataAsList {
    var data = new List<List>();
    for (int i = 0; i < qvaWrapper['Data']['Rows']['length']; i++) {
      var row = qvaWrapper['Data']['Rows'][i];
      var id = row[0]['value'];
      var value = row[1]['data'];
      data.add([id, value]);
    }
    return data;
  }
  @override
  Map<int, String> get idNameMap {
    var idNameMap = new Map<int, String>();
    for (int i = 0; i < qvaWrapper['Data']['Rows']['length']; i++) {
      var row = qvaWrapper['Data']['Rows'][i];
      var id = row[0]['value'];
      var dimension = row[0]['text'];
      idNameMap[id] = dimension;
    }
    return idNameMap;
  }
  @override
  void selectValues(int dimensionId, List rowIds, {SelectionMode selectionMode}) {
    bool toggle = selectionMode == SelectionMode.keepPrevious ? true : false;
    qvaWrapper['Data'].callMethod('SelectValuesInColumn', [dimensionId, rowIds.join(" "), toggle]);
  }
}

void registerQlikViewExtensionObject(String name, QlikViewExtensionObject factoryFunc(JsObject qvaWrapper)) {
  var addExtension = new JsFunction.withThis((JsObject qvaWrapper) {
    String objectId = qvaWrapper['Layout']['ObjectId'];
    registerExtensionObject(objectId, () => factoryFunc(qvaWrapper));
  });
  context['Qva'].callMethod('AddExtension', [name, addExtension]);
}
