// Copyright (c) 2015, Alexander Johr. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
part of qlikview_qlik_sense_extensions;

abstract class QlikViewDocumentExtension extends Extension 
  with QlikViewExtension {
  QlikViewDocumentExtension(this.name);  
  final String name;

  String get remoteAddress {
    String remoteAddress = context['qva']['Remote'] as String;
    return "${remoteAddress}${remoteAddress.contains('?') ? '&' : '?'}"
           "public=only&type=document&name=Extensions/${name}";
  }
}

void registerQlikViewDocumentExtension
  (QlikViewDocumentExtension factoryFunc()) {
  
  QlikViewDocumentExtension createdExtension = factoryFunc();
  var extensionFunction = () => createdExtension.onCreate();

  List addExtensionParams = [createdExtension.name, extensionFunction];
  context['Qva'].callMethod('AddDocumentExtension', addExtensionParams);
}
