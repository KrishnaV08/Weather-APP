import 'dart:convert';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));
String weatherToJson(Weather data) => json.encode(data.toJson());

class Weather {
  Location location;
  Current current;
  Forecast forecast;

  Weather({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        location: Location.fromJson(json["location"] ?? {}),
        current: Current.fromJson(json["current"] ?? {}),
        forecast: Forecast.fromJson(json["forecast"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "current": current.toJson(),
        "forecast": forecast.toJson(),
      };
}

class Location {
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String tzId;
  double localtimeEpoch;
  String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json["name"] ?? '',
        region: json["region"] ?? '',
        country: json["country"] ?? '',
        lat: json["lat"]?.toDouble() ?? 0.0,
        lon: json["lon"]?.toDouble() ?? 0.0,
        tzId: json["tz_id"] ?? '',
        localtimeEpoch: (json["localtime_epoch"] ?? 0).toDouble(),
        localtime: json["localtime"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "region": region,
        "country": country,
        "lat": lat,
        "lon": lon,
        "tz_id": tzId,
        "localtime_epoch": localtimeEpoch,
        "localtime": localtime,
      };
}

class Current {
  double? lastUpdatedEpoch;
  String? lastUpdated;
  double tempC;
  double tempF;
  double isDay;
  Condition condition;
  double windMph;
  double windDegree;
  String windDir;
  double pressureMb;
  double pressureIn;
  double precipMm;
  double precipIn;
  double humidity;
  double cloud;
  double feelslikeC;
  double feelslikeF;
  double windchillC;
  double windchillF;
  double heatindexC;
  double heatindexF;
  double dewpointC;
  double dewpointF;
  double visMiles;
  double uv;
  double gustMph;
  double gustKph;
  double? timeEpoch;
  String? time;
  double? snowCm;
  double? willItRain;
  double? chanceOfRain;
  double? willItSnow;
  double? chanceOfSnow;

  Current({
    this.lastUpdatedEpoch,
    this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.windchillC,
    required this.windchillF,
    required this.heatindexC,
    required this.heatindexF,
    required this.dewpointC,
    required this.dewpointF,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
    this.timeEpoch,
    this.time,
    this.snowCm,
    this.willItRain,
    this.chanceOfRain,
    this.willItSnow,
    this.chanceOfSnow,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        lastUpdatedEpoch: (json["last_updated_epoch"] ?? 0).toDouble(),
        lastUpdated: json["last_updated"],
        tempC: json["temp_c"]?.toDouble() ?? 0.0,
        tempF: json["temp_f"]?.toDouble() ?? 0.0,
        isDay: (json["is_day"] ?? 0).toDouble(),
        condition: Condition.fromJson(json["condition"] ?? {}),
        windMph: json["wind_mph"]?.toDouble() ?? 0.0,
        windDegree: (json["wind_degree"] ?? 0).toDouble(),
        windDir: json["wind_dir"] ?? '',
        pressureMb: (json["pressure_mb"] ?? 0).toDouble(),
        pressureIn: json["pressure_in"]?.toDouble() ?? 0.0,
        precipMm: (json["precip_mm"] ?? 0).toDouble(),
        precipIn: (json["precip_in"] ?? 0).toDouble(),
        humidity: (json["humidity"] ?? 0).toDouble(),
        cloud: (json["cloud"] ?? 0).toDouble(),
        feelslikeC: json["feelslike_c"]?.toDouble() ?? 0.0,
        feelslikeF: json["feelslike_f"]?.toDouble() ?? 0.0,
        windchillC: json["windchill_c"]?.toDouble() ?? 0.0,
        windchillF: json["windchill_f"]?.toDouble() ?? 0.0,
        heatindexC: json["heatindex_c"]?.toDouble() ?? 0.0,
        heatindexF: json["heatindex_f"]?.toDouble() ?? 0.0,
        dewpointC: json["dewpoint_c"]?.toDouble() ?? 0.0,
        dewpointF: json["dewpoint_f"]?.toDouble() ?? 0.0,
        visMiles: (json["vis_miles"] ?? 0).toDouble(),
        uv: json["uv"]?.toDouble() ?? 0.0,
        gustMph: json["gust_mph"]?.toDouble() ?? 0.0,
        gustKph: json["gust_kph"]?.toDouble() ?? 0.0,
        timeEpoch: (json["time_epoch"] ?? 0).toDouble(),
        time: json["time"],
        snowCm: (json["snow_cm"] ?? 0).toDouble(),
        willItRain: (json["will_it_rain"] ?? 0).toDouble(),
        chanceOfRain: (json["chance_of_rain"] ?? 0).toDouble(),
        willItSnow: (json["will_it_snow"] ?? 0).toDouble(),
        chanceOfSnow: (json["chance_of_snow"] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "last_updated_epoch": lastUpdatedEpoch,
        "last_updated": lastUpdated,
        "temp_c": tempC,
        "temp_f": tempF,
        "is_day": isDay,
        "condition": condition.toJson(),
        "wind_mph": windMph,
        "wind_degree": windDegree,
        "wind_dir": windDir,
        "pressure_mb": pressureMb,
        "pressure_in": pressureIn,
        "precip_mm": precipMm,
        "precip_in": precipIn,
        "humidity": humidity,
        "cloud": cloud,
        "feelslike_c": feelslikeC,
        "feelslike_f": feelslikeF,
        "windchill_c": windchillC,
        "windchill_f": windchillF,
        "heatindex_c": heatindexC,
        "heatindex_f": heatindexF,
        "dewpoint_c": dewpointC,
        "dewpoint_f": dewpointF,
        "vis_miles": visMiles,
        "uv": uv,
        "gust_mph": gustMph,
        "gust_kph": gustKph,
        "time_epoch": timeEpoch,
        "time": time,
        "snow_cm": snowCm,
        "will_it_rain": willItRain,
        "chance_of_rain": chanceOfRain,
        "will_it_snow": willItSnow,
        "chance_of_snow": chanceOfSnow,
      };
}

class Condition {
  String text;
  String icon;
  double code;

  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
        text: json["text"] ?? '',
        icon: json["icon"] ?? '',
        code: (json["code"] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "icon": icon,
        "code": code,
      };
}

class Forecast {
  List<Forecastday> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
        forecastday: List<Forecastday>.from(
            (json["forecastday"] ?? []).map((x) => Forecastday.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "forecastday": List<dynamic>.from(forecastday.map((x) => x.toJson())),
      };
}

class Forecastday {
  DateTime date;
  double dateEpoch;
  Day day;
  Astro astro;
  List<Current> hour;

  Forecastday({
    required this.date,
    required this.dateEpoch,
    required this.day,
    required this.astro,
    required this.hour,
  });

  factory Forecastday.fromJson(Map<String, dynamic> json) => Forecastday(
        date: DateTime.parse(json["date"] ?? DateTime.now().toString()),
        dateEpoch: (json["date_epoch"] ?? 0).toDouble(),
        day: Day.fromJson(json["day"] ?? {}),
        astro: Astro.fromJson(json["astro"] ?? {}),
        hour: List<Current>.from(
            json["hour"]?.map((x) => Current.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "date_epoch": dateEpoch,
        "day": day.toJson(),
        "astro": astro.toJson(),
        "hour": List<dynamic>.from(hour.map((x) => x.toJson())),
      };
}

class Astro {
  String sunrise;
  String sunset;
  String moonrise;
  String moonset;
  String moonPhase;
  double moonIllumination;
  double isMoonUp;
  double isSunUp;

  Astro({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.moonIllumination,
    required this.isMoonUp,
    required this.isSunUp,
  });

  factory Astro.fromJson(Map<String, dynamic> json) => Astro(
        sunrise: json["sunrise"] ?? '',
        sunset: json["sunset"] ?? '',
        moonrise: json["moonrise"] ?? '',
        moonset: json["moonset"] ?? '',
        moonPhase: json["moon_phase"] ?? '',
        moonIllumination: (json["moon_illumination"] ?? 0).toDouble(),
        isMoonUp: (json["is_moon_up"] ?? 0).toDouble(),
        isSunUp: (json["is_sun_up"] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "sunrise": sunrise,
        "sunset": sunset,
        "moonrise": moonrise,
        "moonset": moonset,
        "moon_phase": moonPhase,
        "moon_illumination": moonIllumination,
        "is_moon_up": isMoonUp,
        "is_sun_up": isSunUp,
      };
}

class Day {
  double maxtempC;
  double maxtempF;
  double mintempC;
  double mintempF;
  double avgtempC;
  double avgtempF;
  double maxwindMph;
  double maxwindKph;
  double totalprecipMm;
  double totalprecipIn;
  double totalsnowCm;
  double avgvisKm;
  double avgvisMiles;
  double avghumidity;
  double dailyWillItRain;
  double dailyChanceOfRain;
  double dailyWillItSnow;
  double dailyChanceOfSnow;
  Condition condition;
  double uv;

  Day({
    required this.maxtempC,
    required this.maxtempF,
    required this.mintempC,
    required this.mintempF,
    required this.avgtempC,
    required this.avgtempF,
    required this.maxwindMph,
    required this.maxwindKph,
    required this.totalprecipMm,
    required this.totalprecipIn,
    required this.totalsnowCm,
    required this.avgvisKm,
    required this.avgvisMiles,
    required this.avghumidity,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.dailyWillItSnow,
    required this.dailyChanceOfSnow,
    required this.condition,
    required this.uv,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        maxtempC: json["maxtemp_c"]?.toDouble() ?? 0.0,
        maxtempF: json["maxtemp_f"]?.toDouble() ?? 0.0,
        mintempC: json["mintemp_c"]?.toDouble() ?? 0.0,
        mintempF: json["mintemp_f"]?.toDouble() ?? 0.0,
        avgtempC: json["avgtemp_c"]?.toDouble() ?? 0.0,
        avgtempF: json["avgtemp_f"]?.toDouble() ?? 0.0,
        maxwindMph: json["maxwind_mph"]?.toDouble() ?? 0.0,
        maxwindKph: json["maxwind_kph"]?.toDouble() ?? 0.0,
        totalprecipMm: (json["totalprecip_mm"] ?? 0).toDouble(),
        totalprecipIn: (json["totalprecip_in"] ?? 0).toDouble(),
        totalsnowCm: (json["totalsnow_cm"] ?? 0).toDouble(),
        avgvisKm: (json["avgvis_km"] ?? 0).toDouble(),
        avgvisMiles: (json["avgvis_miles"] ?? 0).toDouble(),
        avghumidity: (json["avghumidity"] ?? 0).toDouble(),
        dailyWillItRain: (json["daily_will_it_rain"] ?? 0).toDouble(),
        dailyChanceOfRain: (json["daily_chance_of_rain"] ?? 0).toDouble(),
        dailyWillItSnow: (json["daily_will_it_snow"] ?? 0).toDouble(),
        dailyChanceOfSnow: (json["daily_chance_of_snow"] ?? 0).toDouble(),
        condition: Condition.fromJson(json["condition"] ?? {}),
        uv: json["uv"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "maxtemp_c": maxtempC,
        "maxtemp_f": maxtempF,
        "mintemp_c": mintempC,
        "mintemp_f": mintempF,
        "avgtemp_c": avgtempC,
        "avgtemp_f": avgtempF,
        "maxwind_mph": maxwindMph,
        "maxwind_kph": maxwindKph,
        "totalprecip_mm": totalprecipMm,
        "totalprecip_in": totalprecipIn,
        "totalsnow_cm": totalsnowCm,
        "avgvis_km": avgvisKm,
        "avgvis_miles": avgvisMiles,
        "avghumidity": avghumidity,
        "daily_will_it_rain": dailyWillItRain,
        "daily_chance_of_rain": dailyChanceOfRain,
        "daily_will_it_snow": dailyWillItSnow,
        "daily_chance_of_snow": dailyChanceOfSnow,
        "condition": condition.toJson(),
        "uv": uv,
      };
}
