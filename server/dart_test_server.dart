// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Client program is note_client.dart.
// Use note_taker.html to run the client.

import 'dart:io';

void main() {
  var port = int.parse(Platform.environment['PORT']);
//  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4042)
  HttpServer.bind('127.0.0.1', port)
      .then(listenForRequests)
      .catchError((e) => print('hello: ${e.toString()}'));
}

listenForRequests(_server) {
  print('Listening on port: ${_server.port}');
  _server.listen((HttpRequest request) {
    switch (request.method) {
      case 'GET':
        handleGet(request);
        break;
      case 'OPTION':
        handleOptions(request);
        break;
      default:
        defaultHandler(request);
        break;
    }
  },
  onDone: () => print('No more requests.'),
  onError: (e ) => print(e.toString()));
}

void handleGet(HttpRequest req) {
  addCorsHeaders(req.response);
  print(req.requestedUri.path);
  if (req.requestedUri.path == '/getresponse') {
    req.response.statusCode = HttpStatus.OK;
    req.response.writeln('Response from server');
  }
  req.response.close();
}

void defaultHandler(HttpRequest req) {
  HttpResponse res = req.response;
  addCorsHeaders(res);
  res.statusCode = HttpStatus.NOT_FOUND;
  res.write('Not found: ${req.method}, ${req.uri.path}');
  res.close();
}

void handleOptions(HttpRequest req) {
  HttpResponse res = req.response;
  addCorsHeaders(res);
  print('${req.method}: ${req.uri.path}');
  res.statusCode = HttpStatus.NO_CONTENT;
  res.close();
}

void addCorsHeaders(HttpResponse res) {
  res.headers.add('Access-Control-Allow-Origin', '*');
  res.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.headers.add('Access-Control-Allow-Headers',
      'Origin, X-Requested-With, Content-Type, Accept');
}