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
                              "$loc",
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
                    SizedBox(height: 90,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(
                          // data.forecast!.forecastday!.hour.length(),
                          data.forecast!.forecastday![0].hour!.length,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10,left: 15),
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
                    SizedBox(height: 10,),
                    Divider(
                      endIndent:15,
                      indent:15,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 325, left: 110),
                  child: Text(formattedDate),
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
