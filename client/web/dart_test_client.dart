// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Client to note_server.dart.
// Use note_taker.html to run this script.

import 'dart:html';

ParagraphElement displayResponse;
HttpRequest request;
//String url = 'http://localhost:4042';
String url = 'http://'+ window.location.hostname;

main() {
  displayResponse = querySelector('#display_response');

  querySelector('#get_response').onClick.listen(requestResponse);
}

void requestResponse(Event e) {
  request = new HttpRequest();
  request.onReadyStateChange.listen((_) {
    if (request.readyState == HttpRequest.DONE && request.status == 200) {
      print('Got response!');
      displayResponse.text = request.responseText;
      }
  });
  print('$url/getresponse');
  request.open('GET', '$url/getresponse');
  request.send();
}
