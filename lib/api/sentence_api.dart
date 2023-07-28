import 'dart:convert';

import 'package:http/http.dart' as http;

String url =
    "https://od-api.oxforddictionaries.com/api/v2/sentences/en/ace?strictMatch=false";

Future<Map<String, dynamic>> fetchSentences() async {
  final Map<String, String> headers = {
    // Add your headers here (if required by the API)
    "Accept": "application/json",
    "app_id": "c2e7b1fe",
    "app_key": "b41be5b3b08f91ebe3d849570f15c52a",
  };

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      // Successful response, you can process the data here
      // print(response.body);
    } else {
      // Error handling
      print('Request failed with status: ${response.statusCode}.');
    }
    return json.decode(response.body);
  } catch (e) {
    print(e);
    return {};
  }
}
