// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
library kernel.application_root;

import 'package:path/path.dart' as pathlib;

/// Resolves URIs with the `app` scheme.
///
/// These are used internally in kernel to represent file paths relative to
/// some application root. This is done to avoid storing irrelevant paths, such
/// as the path to the home directory of the user who compiled a given file.
class ApplicationRoot {
  static const String scheme = 'app';

  final String path;

  ApplicationRoot(this.path) {
    assert(pathlib.isAbsolute(path));
  }

  /// Resolves a given file path or URI to a relative URI.
  Uri resolve(String pathString) {
    var uri = Uri.parse(pathString);
    if (uri.hasScheme) return relativeUri(uri);
    return new Uri(
        scheme: ApplicationRoot.scheme,
        path: pathlib.relative(uri.path, from: this.path));
  }

  /// Converts `app` URIs to absolute `file` URIs.
  Uri absoluteUri(Uri uri) {
    if (uri.scheme == ApplicationRoot.scheme) {
      return new Uri(scheme: 'file', path: pathlib.join(this.path, uri.path));
    } else {
      return uri;
    }
  }

  /// Converts `file` URIs to `app` URIs.
  Uri relativeUri(Uri uri) {
    if (uri.scheme == 'file') {
      return new Uri(
          scheme: ApplicationRoot.scheme,
          path: pathlib.relative(uri.path, from: this.path));
    } else {
      return uri;
    }
  }
}
