import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controller/api_helper.dart';
import '../controller/connectivity_provider.dart';
import '../controller/search_provider.dart';
import '../controller/theme_provider.dart';
import '../main.dart';
import '../model/wether_api_model.dart';

bool isConnected = false;

class Home_screen extends StatefulWidget {
  const Home_screen({super.key});

  @override
  State<Home_screen> createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {
  @override
  void initState() {
    super.initState();
    var sp = Provider.of<SearchProvider>(context, listen: false);
    sp.fetchDataFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    // String loc = "Rajkot";
    var sp = Provider.of<SearchProvider>(context);
    return Scaffold(
      body: FutureBuilder(
        future: ApiHelper().getApiData(sp.loc!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            Weather? data = snapshot.data;
            String inputString = data!.location!.localtime!;
            // Parse the input string to DateTime with a specific format
            DateFormat inputFormat = DateFormat("yyyy-MM-dd H:mm");
            DateTime dateTime = inputFormat.parse(inputString);

            // Format the date in the desired output format with month name
            DateFormat outputFormat = DateFormat("MMMM dd, yyyy", 'en_US');
            String formattedDate = outputFormat.format(dateTime);

            DateTime now = DateTime.now();
            double hour = now.hour.toDouble();

            return Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (Provider.of<ThemeProvider>(context).currentTheme)
                          ? AssetImage("assets/wdark1.png")
                          : AssetImage("assets/wlight.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 200, left: 100),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Text(
                                  "${data.current!.tempC}°C",
                                  style: TextStyle(
                                    fontSize: _height * 0.06,
                                    fontWeight: FontWeight.w500,
                                    // color: Colors.white,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Image.network(
                                        "http:${data.current!.condition!.icon}"),
                                    Text(
                                      "${data.current!.condition!.text}",
                                      style: TextStyle(
                                        fontSize: _height * 0.025,
                                        fontWeight: FontWeight.w500,
                                        // color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                          "  ${data.location!.name} , ${data.location!.region} , ${data.location!.country}"),
                      Divider(
                        endIndent: 10,
                        indent: 10,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black54
                            : Colors.white,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          height: _height * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Color(0xFF3384C2)
                                    : Color(0xFF48799D),
                          ),
                          child: Row(
                            children: List.generate(
                              // data.forecast!.forecastday!.hour.length(),
                              data.forecast!.forecastday![0].hour!.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 15, top: 10),
                                  child: Column(
                                    children: [
                                      (data
                                                      .forecast!
                                                      .forecastday![0]
                                                      .hour![DateTime.now().hour]
                                                      .time!
                                                      .split(
                                                          "${DateTime.now().day}")[
                                                  1] ==
                                              data.forecast!.forecastday![0]
                                                  .hour![index].time!
                                                  .split(
                                                      "${DateTime.now().day}")[1])
                                          ? Text(
                                              "Now",
                                              style: TextStyle(
                                                  // color: Colors.white,
                                                  fontSize: _height * 0.020),
                                            )
                                          : Text(
                                              data.forecast!.forecastday![0]
                                                  .hour![index].time!
                                                  .split(
                                                      "${DateTime.now().day}")[1],
                                              style: TextStyle(
                                                // color: Colors.white,
                                                fontSize: _height * 0.020,
                                              ),
                                            ),
                                      Image.network(
                                        "http:${data.forecast!.forecastday![0].hour![index].condition!.icon}",
                                        height: _height * 0.05,
                                        width: _height * 0.05,
                                      ),
                                      Text(
                                        "${data.forecast!.forecastday![0].hour![index].tempC}°",
                                        style: TextStyle(
                                          // color: Colors.white,
                                          fontSize: _height * 0.020,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        endIndent: 10,
                        indent: 10,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black54
                            : Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: _height * 0.05,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Color(0xFF3384C2)
                                  : Color(0xFF48799D),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            children: [
                              Text(
                                "Details :",
                                style: TextStyle(
                                  fontSize: _height * 0.0209,
                                  fontWeight: FontWeight.w500,
                                  // color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 150,
                              ),
                              Text(formattedDate),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Color(0xFF3384C2)
                                  : Color(0xFF48799D),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Icon(
                                  Icons.sunny_snowing,
                                  color: Colors.yellow,
                                ),
                                Text(
                                    "${data.forecast!.forecastday![0].astro!.sunrise}")
                              ],
                            ),
                            Container(
                              width: 200,
                              child: Slider(
                                activeColor: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.yellow
                                    : Colors.grey[400],
                                min: 0.0,
                                max: 24,
                                value: hour,
                                divisions: 24,
                                label: '${hour.round()}',
                                onChanged: (value) {
                                  Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .refresh();
                                  hour = value;
                                },
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Icon(Icons.sunny),
                                Text(
                                    "${data.forecast!.forecastday![0].astro!.sunset}")
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Color(0xFF3384C2)
                                  : Color(0xFF48799D),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${data.current!.feelslikeC}°c",
                                ),
                                Text("Feels Like")
                              ],
                            ),
                            VerticalDivider(
                              indent: 10,
                              endIndent: 10,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${data.current!.humidity}%",
                                ),
                                Text("Humidity")
                              ],
                            ),
                            VerticalDivider(
                              indent: 10,
                              endIndent: 10,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${data.current!.cloud}",
                                ),
                                Text("WNW,force")
                              ],
                            ),
                            VerticalDivider(
                              indent: 10,
                              endIndent: 10,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${data.current!.pressureMb}",
                                ),
                                Text("Pressure")
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Color(0xFF3384C2)
                                  : Color(0xFF48799D),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${data.location!.lat}",
                                ),
                                Text("Lat")
                              ],
                            ),
                            VerticalDivider(
                              indent: 10,
                              endIndent: 10,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${data.current!.windMph} Mph",
                                ),
                                Text("Wind")
                              ],
                            ),
                            VerticalDivider(
                              indent: 10,
                              endIndent: 10,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${data.current!.windDir}",
                                ),
                                Text("Wind Dir")
                              ],
                            ),
                            VerticalDivider(
                              indent: 10,
                              endIndent: 10,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${data.location!.lon}",
                                ),
                                Text("Lon")
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Color(0xFF3384C2)
                                  : Color(0xFF48799D),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${data.forecast!.forecastday![0].astro!.moonIllumination}",
                                ),
                                Icon(Icons.shield_moon_sharp)
                                // Text("Lat")
                              ],
                            ),
                            VerticalDivider(
                              indent: 10,
                              endIndent: 10,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${data.forecast!.forecastday![0].day!.maxwindKph} Kph",
                                ),
                                Text("Max Wind")
                              ],
                            ),
                            VerticalDivider(
                              indent: 10,
                              endIndent: 10,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${data.forecast!.forecastday![0].day!.uv}",
                                ),
                                Text("UV")
                              ],
                            ),
                            VerticalDivider(
                              indent: 10,
                              endIndent: 10,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${data.forecast!.forecastday![0].day!.avghumidity}",
                                ),
                                Text("Avg Humidity")
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      height: 145,
                      color: Colors.transparent,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: (Provider.of<ThemeProvider>(context).currentTheme)
                              ? AssetImage("assets/d1.png")
                              : AssetImage("assets/w1.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Consumer<ThemeProvider>(
                                      builder: (context, tp, child) {
                                    return IconButton(
                                      onPressed: () {
                                        tp.setTheme();
                                      },
                                      icon: tp.currentTheme == false
                                          ? Icon(Icons.dark_mode)
                                          : Icon(Icons.light_mode_outlined),
                                    );
                                  }),
                                  Text(
                                    "${data.location!.name}",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.menu_outlined,
                                        size: 25,
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                              child: TextFormField(
                                onChanged: (value) async {
                                  String baseUrl =
                                      "https://api.weatherapi.com/v1/forecast.json?key=e09f03988e1048d2966132426232205&q=";
                                  String endUrl = "$value&aqi=no";
                                  String api = baseUrl + endUrl;
                                  http.Response res =
                                      await http.get(Uri.parse(api));
                                  if (res.statusCode == 200) {
                                    sp.loc = value;
                                    prefs.setString("City", value);
                                  } else {
                                    print("NO DATA FOUND");
                                  }
                                },
                                onSaved: (value) async {},
                                decoration: InputDecoration(
                                  labelText: 'Enter City',
                                  border: OutlineInputBorder(),
                                  icon: Icon(Icons.location_city),
                                ),
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar:
          Consumer<ConnectivityProvider>(builder: (context, netProvider, val) {
        netProvider.addNetListener();
        if (!netProvider.isNet) {
          return Container(
            color: Colors.red,
            width: double.infinity,
            height: 40,
            padding: EdgeInsets.all(8),
            child: Center(
              child: Text(
                "No Connection..",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          // Hide the message when internet connection is available
          return SizedBox.shrink();
        }
      }),
    );
  }
}
