import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controller/api_helper.dart';
import '../controller/theme_provider.dart';
import '../model/wether_api_model.dart';

class Home_screen extends StatefulWidget {
  const Home_screen({super.key});

  @override
  State<Home_screen> createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    String loc = "Rajkot";
    return Scaffold(
      body: FutureBuilder(
        future: ApiHelper().getApiData(loc),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 60,
                      ),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Consumer<ThemeProvider>(
                                builder: (context, themeProvider, child) =>
                                    Switch(
                                      value: themeProvider.currentTheme,
                                      onChanged: (bool value) {
                                        themeProvider.changeTheme(value);
                                      },
                                    )),
                            Text(
                              "${data.location!.name}",
                              style: TextStyle(fontSize: 23),
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
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            hintText: "Search The City",
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 80, left: 110),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        textBaseline: TextBaseline.alphabetic,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Text(
                            "${data.current!.tempC}°",
                            style: TextStyle(
                              fontSize: _height * 0.06,
                              fontWeight: FontWeight.w500,
                              // color: Colors.white,
                            ),
                          ),
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
                    ),
                    SizedBox(
                      height: 90,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(
                          // data.forecast!.forecastday!.hour.length(),
                          data.forecast!.forecastday![0].hour!.length,
                          (index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 15),
                              child: Column(
                                children: [
                                  (data.forecast!.forecastday![0]
                                              .hour![DateTime.now().hour].time!
                                              .split(
                                                  "${DateTime.now().day}")[1] ==
                                          data.forecast!.forecastday![0]
                                              .hour![index].time!
                                              .split(
                                                  "${DateTime.now().day}")[1])
                                      ? Text(
                                          "Now",
                                          style: TextStyle(
                                            // color: Colors.white,
                                            fontSize: _height * 0.022,
                                          ),
                                        )
                                      : Text(
                                          data.forecast!.forecastday![0]
                                              .hour![index].time!
                                              .split(
                                                  "${DateTime.now().day}")[1],
                                          style: TextStyle(
                                            // color: Colors.white,
                                            fontSize: _height * 0.022,
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
                                      fontSize: _height * 0.022,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      endIndent: 15,
                      indent: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Details",
                        style: TextStyle(
                          fontSize: _height * 0.0209,
                          fontWeight: FontWeight.w500,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.sunny_snowing,
                              color: Colors.yellow,
                            ),
                            Text(
                                "${data.forecast!.forecastday![0].astro!.sunrise}")
                          ],
                        ),
                        Container(
                          width: 230,
                          child: Slider(
                            activeColor:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.yellow
                                    : Colors.grey[400],
                            min: 0.0,
                            max: 100.0,
                            value: hour,
                            divisions: 24,
                            label: '${hour.round()}',
                            onChanged: (value) {
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .refresh();
                              hour = value;
                            },
                          ),
                        ),
                        Column(
                          children: [
                            Icon(Icons.sunny),
                            Text(
                                "${data.forecast!.forecastday![0].astro!.sunset}")
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color: Colors.grey),
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
                          Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "${data.current!.humidity}°c",
                              ),
                              Text("Humidity")
                            ],
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
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 325, left: 110),
                  child: Text(formattedDate),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 270, left: 230),
                  child: Text(
                    "c",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
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
    );
  }
}
