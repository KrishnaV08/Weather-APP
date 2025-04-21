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
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: _searchBar(),

                  pinned: true,
                ),


    SliverAppBar(
  pinned: true,
  expandedHeight: MediaQuery.of(context).size.height/2,

  backgroundColor: Colors.transparent,
  flexibleSpace: LayoutBuilder(
    builder: (context, constraints) {
      final isCollapsed = constraints.maxHeight <= kToolbarHeight+20;

      return FlexibleSpaceBar(
        centerTitle: true,

        background: isCollapsed==true
            ? _weatherCardCompact()  // 👈 compact version on scroll
            : _weatherCard(),        // 👈 full version when expanded
        title: isCollapsed
            ? _weatherCardCompact() // optional, you can keep this empty since we use compact widget
            : null,
      );
    },
  ),
),

    
                SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return _infoCards();

            }, childCount: 2),
          ),
                
              ],
            )
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
        Image.network(list?.current.condition.icon ?? "", width: 30, height: 30),
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
      decoration: BoxDecoration(


      ),
      child: Column(
        
        mainAxisSize:
            MainAxisSize.min, // 🟢 Keeps container height dynamic
        crossAxisAlignment: CrossAxisAlignment.center,
      
        children: [
          SizedBox(height: 30,),
          Text(
            lat!=0?"MY LOCATION" : "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10
            ),
          ),
          Text(
            list?.location.name != null
                ? list!.location.name
                : "Loading...",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w100,
            ),
          ),
          Text(
            list?.current.tempC != null
                ? "${list!.current.tempC.toString().substring(0, 2)}°"
                : "Loading...",
            style: TextStyle(
              fontSize: list?.current.tempC != null?58: 26,
              color: Colors.white,
              fontWeight: FontWeight.w100

            ),
          ),
      
      
          list?.current.condition.icon != null
              ? Image.network(
                list?.current.condition.icon != null
                    ? list!.current.condition.icon
                    : "Jkdsl",
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
                    ? "H:${list!.forecast.forecastday[0].day.maxtempC.toString().substring(0, 2)}°C "
                    : "Loading...",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 8),
              Text(
                list?.forecast.forecastday[0].day.mintempC != null
                    ? "L:${list!.forecast.forecastday[0].day.mintempC.toString().substring(0, 2)}°C"
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
                        ? "${list!.current.feelslikeC.toString().substring(0, 2)}°"
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
                color: const Color.fromARGB(72, 50, 87, 117)
                
                
              
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

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 120,

              width: MediaQuery.of(context).size.width / 2.8,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(72, 50, 87, 117)
                
                
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
                        ? "${list!.current.feelslikeC.toString().substring(0, 2)}°"
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
                color: const Color.fromARGB(72, 50, 87, 117)
                
                
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 120,

              width: MediaQuery.of(context).size.width / 2.8,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(72, 50, 87, 117)
                
                
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
                        ? "${list!.current.feelslikeC.toString().substring(0, 2)}°"
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
                color: const Color.fromARGB(72, 50, 87, 117)
                
                
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 120,

              width: MediaQuery.of(context).size.width / 2.8,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(72, 50, 87, 117)
                
                
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
                        ? "${list!.current.feelslikeC.toString().substring(0, 2)}°"
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
                color: const Color.fromARGB(72, 50, 87, 117)
                
                
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
