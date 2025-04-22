import 'package:flutter/material.dart';
import './services/request_services.dart';
import './models/weather.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCity = "New Delhi";
  Weather? list;
  bool isLoaded = false;
  double lat = 0;
  double long = 0;
  String hinted = "Search for the location";

  Future _getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      hinted = "Search for the location";
    });
    getData();
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    list = await RequestServices().getReq(lat, long, selectedCity);
    if (list != null) {
      setState(() {
        isLoaded = true;
      });
    } else {
      setState(() {
        selectedCity = "London";
        getData();
      });
    }
  }

  

  double get currTemp {
    return list?.current.tempC ?? 0;
  }

  double get feelss {
    return list?.current.feelslikeC ?? 0;
  }

  String get feeling {
    if (feelss - currTemp > 0) {
      return "Feels warmer ";
    } else if (currTemp - feelss > 0) {
      return "Feels cooler ";
    }
    return "Feels similar ";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(102, 1, 81, 143),
            ),
            child:  CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(title: _searchBar(), pinned: true),

                SliverAppBar(
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height / 2,

                  backgroundColor: Colors.transparent,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      final isCollapsed =
                          constraints.maxHeight <= kToolbarHeight + 20;

                      return FlexibleSpaceBar(
                        centerTitle: true,

                        background:
                            isCollapsed == true
                                ? _weatherCardCompact() // 👈 compact version on scroll
                                : _weatherCard(), // 👈 full version when expanded
                        title:
                            isCollapsed
                                ? _weatherCardCompact() // optional, you can keep this empty since we use compact widget
                                : null,
                      );
                    },
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    return _infoCards();
                  }, childCount: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _weatherCardCompact() {
    return Container(
      height: 90,
      color: const Color.fromARGB(144, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            list?.current.condition.icon ?? "",
            width: 30,
            height: 30,
          ),
          SizedBox(width: 8),
          Text(
            "${list?.location.name ?? ''} | ${list?.current.tempC?.toStringAsFixed(0) ?? '--'}°C",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _weatherCard() {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🟢 Keeps container height dynamic
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          SizedBox(height: 30),
          Text(
            lat != 0 ? "MY LOCATION" : "",
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          Text(
            list?.location.name != null ? list!.location.name : "Loading...",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w100,
            ),
          ),
          Text(
            list?.current.tempC != null
                ? "${list!.current.tempC.toString().split(".")[0]}°"
                : "Loading...",
            style: TextStyle(
              fontSize: list?.current.tempC != null ? 58 : 26,
              color: Colors.white,
              fontWeight: FontWeight.w100,
            ),
          ),

          list?.current.condition.icon != null
              ? Image.network(
                list?.current.condition.icon != null
                    ? list!.current.condition.icon
                    : "Loading...",
                width: 80, // optional size
                height: 80,
              )
              : Text("Loading..."),

          Text(
            list?.current.condition.text != null
                ? list!.current.condition.text.toString()
                : "Loading...",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                list?.forecast.forecastday[0].day.maxtempC != null
                    ? "H:${list!.forecast.forecastday[0].day.maxtempC.toString().split(".")[0]}°"
                    : "Loading...",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 8),
              Text(
                list?.forecast.forecastday[0].day.mintempC != null
                    ? "L:${list!.forecast.forecastday[0].day.mintempC.toString().split(".")[0]}°"
                    : "Loading...",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 75),

          // _infoCards(),
        ],
      ),
    );
  }

  String _getDay(int num) {
    switch(num){
      
      case 1: return "Mon";
      case 2: return "Tue";
      case 3: return "Wed";
      case 4: return "Thu";
      case 5: return "Fri";
      case 6: return "Sat";
      case 7: return "Sun";
      default: return "";

    }
  }

  Widget _infoCards() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            Container(
              height: 120,

              width: MediaQuery.of(context).size.width / 2.8,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(72, 50, 87, 117),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Feels Like",
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 93, 93, 93),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    list?.current.feelslikeC != null
                        ? "${list!.current.feelslikeC.toString().split(".")[0]}°"
                        : "Loading...",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(feeling, style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            Container(
              height: 120,

              width: MediaQuery.of(context).size.width / 2.8,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(72, 50, 87, 117),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Sunset",
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 93, 93, 93),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    list?.forecast.forecastday[0].astro.sunset != null
                        ? list!.forecast.forecastday[0].astro.sunset
                            .toString()
                            .substring(1)
                        : "Loading...",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    list?.forecast.forecastday[0].astro.sunrise != null
                        ? "Sunrise: ${list!.forecast.forecastday[0].astro.sunrise.toString().substring(1)}"
                        : "Loading...",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Container(
          height: 150,

          width: MediaQuery.of(context).size.width - 56,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color.fromARGB(72, 50, 87, 117),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hourly Forecast",
                style: TextStyle(
                  
                  fontSize: 12,
                  color: const Color.fromARGB(255, 93, 93, 93),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
  scrollDirection: Axis.horizontal,

  
  child: Row(
  children: list?.forecast.forecastday[0].hour.map((x) {
    final json = x.toJson();
    final time = json['time'];
    final tempC = json['temp_c'];
    final icon = x.condition.icon;

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: const Color.fromARGB(255, 101, 101, 101),
            width: 2,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time != null && time.toString().length >= 13
                ? time.toString().substring(11, 16) // to get HH:mm
                : "Loading...",
            style: TextStyle(color: Colors.white),
          ),
          icon != null
              ? Image.network(
                  'https:$icon',
                  width: 30,
                  height: 30,
                )
              : SizedBox(height: 30), // placeholder for missing image
          Text(
            tempC != null
                ? '${tempC.toString().split(".")[0]}°'
                : "Loading...",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }).toList() ?? [],
)

),


              SizedBox(height: 14),
            ],
          ),
        ),
        SizedBox(height: 24),

        Container(
          height: 300,

          width: MediaQuery.of(context).size.width - 56,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color.fromARGB(72, 50, 87, 117),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Forecast",
                style: TextStyle(
                  fontSize: 12,
                  color: const Color.fromARGB(255, 93, 93, 93),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      // for (int i = 1; i <7; i++)
                      //   (Text(
                      //     list?.forecast.forecastday[i].date.weekday != null
                      //         ? _getDay(list!.forecast.forecastday[i].date.weekday)                       : "Loading",
                      //     style: TextStyle(fontSize: 22,
                      //     color: Colors.white),
                      //     textAlign: TextAlign.left,
                          
                      //   )),
                       
                    ],
                  ),
                  
                  Column(
                    children: [
                    Text(
                      list != null
                          ? "${list!.forecast.forecastday[0].day.avgtempC
                              .toString()
                              .substring(0, 2)}°"
                          : "Loading",
                      style: TextStyle(fontSize: 22,color: Colors.white),
                    )
                    ]
                  ),
                ],
              ),

              SizedBox(height: 14),
            ],
          ),
        ),
       
        SizedBox(height: 24),
      ],
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          color: const Color.fromARGB(64, 0, 52, 76), // same as fillColor
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 4), // Shadow position
            ),
          ],
        ),
        child: TextField(
          onSubmitted: (e) {
            setState(() {
              selectedCity = e;
              lat = 0;
              long = 0;
            });
            getData();
          },

          decoration: InputDecoration(
            hintText: hinted,
            hintStyle: TextStyle(color: Colors.white54),
            prefixIcon: InkWell(
              child: Icon(Icons.pin_drop, size: 30),

              onTap: _getLocation,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none, // removes inner border
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.transparent, // handled by container
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}
