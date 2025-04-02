import 'package:url_launcher/url_launcher.dart';

/// Utility function to launch URLs
Future<void> launchUrlExternal(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
