import 'package:web/web.dart' as web;

void injectGoogleMapsScript(String apiKey) {
  if (apiKey.isEmpty) return;
  final script = web.HTMLScriptElement()
    ..src = 'https://maps.googleapis.com/maps/api/js?key=$apiKey'
    ..type = 'text/javascript';
  web.document.head?.appendChild(script);
}
