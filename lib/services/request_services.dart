import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

class RequestServices {

  


  Future<Weather?> getReq(double lat,double long,String selectedCity) async {
    var client = http.Client();
    Uri url;
    if (selectedCity.isNotEmpty) {
       url = Uri.parse(
        "https://api.weatherapi.com/v1/forecast.json?key=0e85ff7496b64fe08df84436251804&q=$selectedCity&days=7&aqi=no&alerts=no"
      );
    } else {
       url = Uri.parse(
        "https://api.weatherapi.com/v1/forecast.json?key=0e85ff7496b64fe08df84436251804&q=$lat, $long&days=7&aqi=no&alerts=no",
      );
    }
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var json = response.body;
      return weatherFromJson(json);
    }
    return null;
  }
}




           