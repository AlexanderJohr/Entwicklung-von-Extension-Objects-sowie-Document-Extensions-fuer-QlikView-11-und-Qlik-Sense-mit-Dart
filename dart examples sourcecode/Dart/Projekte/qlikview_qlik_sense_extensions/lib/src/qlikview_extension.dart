// Copyright (c) 2015, Alexander Johr. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
part of qlikview_qlik_sense_extensions.base;

abstract class QlikViewExtension {

  String get remoteAddress;
  final HeadElement documentHead = querySelector("head") as HeadElement;

  Future loadScripts(List<String> paths) => _loadDependencies(paths, loadScript);
  Future loadStyleSheets(List<String> paths) => _loadDependencies(paths, loadStyleSheet);
  
  Future loadScript(String path) {
    ScriptElement scriptElement = new ScriptElement()
        ..src = path
        ..charset = "UTF-8"
        ..type = "text/javascript";
    return _appendNodeToHeadAndLoad(scriptElement);
  }
  Future loadStyleSheet(String path) {
    LinkElement cssElement = new LinkElement()
        ..rel = "stylesheet"
        ..type = "text/css"
        ..href = path;
    return _appendNodeToHeadAndLoad(cssElement);
  }  

  Future _loadDependencies(List<String> paths, Future loadFunction(String path)) {
    var completer = new Completer();
    var loadTasks = new List<Future>();
    for (String relativePath in paths) {
      var absolutePath = getAbsolutePath(relativePath);
      loadTasks.add(loadFunction(absolutePath));
    }
    Future.wait(loadTasks).then((List results) => completer.complete());
    return completer.future;
  }

  String getAbsolutePath(String resource) => "${remoteAddress}/${resource}";
  
  Future _appendNodeToHeadAndLoad(HtmlElement node) {
    Completer completer = new Completer();
    node.onLoad.listen((event) => completer.complete());
    documentHead.append(node);
    return completer.future;
  }
}
