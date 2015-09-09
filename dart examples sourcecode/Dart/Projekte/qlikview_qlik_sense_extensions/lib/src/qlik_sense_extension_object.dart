// Copyright (c) 2015, Alexander Johr. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
part of qlikview_qlik_sense_extensions;

abstract class QlikSenseExtensionObject extends ExtensionObject {

  QlikSenseExtensionObject(JsObject extensionObject, JsObject extensionData)
      : super(extensionData['qInfo']['qId'], extensionObject[r'$element'][0])
      , this.extensionObject = extensionObject
      , this.extensionData = extensionData;
      
  final JsObject extensionObject, extensionData;
  JsObject get backendApi => extensionObject['backendApi'];
  
  @override
  List get dataAsList {
    var data = new List<List>();
    backendApi.callMethod('eachDataRow', [(JsObject rownum, JsObject row) {
        var id = row[0]['qElemNumber'];
        var value = row[1]['qText'];
        data.add([id, value]);
      }]);
    return data;
  }

  @override
  Map<int, String> get idNameMap {
    var idNameMap = new Map<int, String>();
    backendApi.callMethod('eachDataRow', [(JsObject rownum, JsObject row) {
        var id = row[0]['qElemNumber'];
        var dimension = row[0]['qText'];
        idNameMap[id] = dimension;
      }]);
    return idNameMap;
  }

  @override
  void selectValues(int dimensionId, List rowIds
    , {SelectionMode selectionMode}) {
    bool toggle = selectionMode == SelectionMode.keepPrevious ? true : false;
    backendApi.callMethod('selectValues'
        , [dimensionId, new JsObject.jsify(rowIds), toggle]);
  }
}

void defineModule(List<String> dependencies, Function moduleFunc) {
  context.callMethod('define'
      , [new JsObject.jsify(dependencies), moduleFunc]);
}

void registerQlikSenseExtensionObject(JsObject extensionData
  , QlikSenseExtensionObject factoryFunc()) {
  String objectId = extensionData['qInfo']['qId'];
  registerExtensionObject(objectId, factoryFunc);
}
