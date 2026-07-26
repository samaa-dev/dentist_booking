import 'dart:io' as io;

class PostHttpOverrides extends io.HttpOverrides {
  @override
  io.HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (io.X509Certificate cert, String host, int port) => true;
  }
}
