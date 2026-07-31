import 'package:web/web.dart' as web;

void injectGoogleMapsScript(String apiKey) {
  if (apiKey.isEmpty) return;

  const scriptId = 'google-maps-js-api';
  if (web.document.getElementById(scriptId) != null) return;

  final script = web.HTMLScriptElement()
    ..id = scriptId
    ..src =
        'https://maps.googleapis.com/maps/api/js?key=$apiKey&loading=async'
    ..type = 'text/javascript'
    ..async = true
    ..defer = true;
  web.document.head?.appendChild(script);
}
