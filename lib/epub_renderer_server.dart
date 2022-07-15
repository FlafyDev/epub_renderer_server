import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:mime/mime.dart';

class EpubRendererServer {
  final int port;
  final String epubResourcesPath;
  HttpServer? server;

  EpubRendererServer({
    required this.port,
    required this.epubResourcesPath,
  });

  Future<void> start() async {
    final server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      port,
    );
    server.listen(onServerRequest);
  }

  Future<void> stop() async {
    await server?.close();
  }

  Future<void> onServerRequest(HttpRequest request) async {
    final path = request.requestedUri.path;
    final pathSplit =
        path.split("/").where((element) => element.isNotEmpty).toList();

    request.response.headers.add('Access-Control-Allow-Origin', '*');

    switch (pathSplit[0]) {
      case "epub":
        {
          final filePath = pathSplit.skip(1).join("/");

          File file = File(p.join(epubResourcesPath, filePath));

          if (!await file.exists()) {
            request.response
              ..statusCode = HttpStatus.notFound
              ..close();
            return;
          }

          final List<int> content;
          final mimeType = lookupMimeType(file.path);

          if (mimeType == null) {
            request.response
              ..statusCode = HttpStatus.badRequest
              ..close();
            return;
          }

          request.response
            ..headers.contentType = ContentType.parse(mimeType)
            ..add(file.readAsBytesSync())
            ..close();

          return;
        }
      default:
        {
          request.response
            ..statusCode = HttpStatus.notFound
            ..close();
          return;
        }
    }
  }
}
