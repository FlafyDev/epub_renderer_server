import 'dart:io';

import 'package:epub_renderer_server/epub_renderer_server.dart';

void main(List<String> arguments) async {
  final server = EpubRendererServer(
    port: 8082,
    epubRendererHtml:
        File("/mnt/general/repos/flafydev/epub-renderer/dist/index.html"),
    // epubResourcesPath:
    //     "/home/flafydev/Documents/book_reader/mybook2/extracted/EPUB",
    epubResourcesPath:
        "/home/flafydev/Documents/book_reader/mybook/extracted/OEBPS/",
  );

  await server.start();
  print("Started server");
}
