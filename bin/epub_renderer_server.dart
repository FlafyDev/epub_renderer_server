import 'package:epub_renderer_server/epub_renderer_server.dart';

void main(List<String> arguments) async {
  final server = EpubRendererServer(
    port: 8081,
    epubResourcesPath:
        "/home/flafydev/Documents/book_reader/mybook2/extracted/EPUB",
  );

  await server.start();
  print("Started server");
}
