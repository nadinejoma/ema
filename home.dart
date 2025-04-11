import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventbookingapp/pages/categories_event.dart';
import 'package:eventbookingapp/pages/detail_page.dart';
import 'package:eventbookingapp/services/database.dart';
import 'package:eventbookingapp/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? eventStream;
  int eventnumber = 0;
  String? _currentCity, name;

  getthesharedpref() async {
    name = await SharedpreferenceHelper().getUserName();
    setState(() {});
  }

  Future<void> _getCurrentCity() async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _currentCity = "Permission Denied";
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Convert coordinates to address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        setState(() {
          _currentCity = placemarks.first.locality;
        });
      } else {
        setState(() {
          _currentCity = "City not found";
        });
      }
    } catch (e) {
      setState(() {
        _currentCity = "Error: $e";
      });
    }
  }

  ontheload() async {
    await getthesharedpref();
    eventStream = await DatabaseMethods().getallEvents();
    _getCurrentCity();
    setState(() {});
  }

  bool search = false;

  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchcontroller = new TextEditingController();

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });

    var CapitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['UpdatedName'].startsWith(CapitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget allEvents() {
    return StreamBuilder(
        stream: eventStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];

                    if (_currentCity == ds["Location"]) {
                      eventnumber = eventnumber + 1;
                    }

                    String inputDate = ds["Date"];
                    DateTime parsedDate = DateTime.parse(inputDate);
                    String formattedDate =
                        DateFormat('MMM, dd').format(parsedDate);

                    DateTime currentDate = DateTime.now();
                    bool hasPassed = currentDate.isAfter(parsedDate);

                    return hasPassed
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                          date: ds["Date"],
                                          detail: ds["Detail"],
                                          image: ds["Image"],
                                          location: ds["Location"],
                                          name: ds["Name"],
                                          price: ds["Price"])));
                            },
                            child: Column(children: [
                              Container(
                                margin: EdgeInsets.only(right: 20.0),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        "images/event.jpg",
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10.0, top: 10.0),
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          formattedDate,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ds["Name"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text(
                                      "\$" + ds["Price"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff6351ec),
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Row(children: [
                                Icon(Icons.location_on),
                                Text(
                                  ds["Location"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ])
                            ]),
                          );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentCity == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.only(top: 50.0, left: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xffe3e6ff),
                Color(0xfff1f3ff),
                Colors.white
              ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        Text(
                          _currentCity!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Hello, " + name!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "There are 20 events\naround your location.",
                      style: TextStyle(
                          color: Color(0xff6351ec),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20.0),
                      padding: EdgeInsets.only(left: 20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        onChanged: (value) {
                          initiateSearch(value.toUpperCase());
                        },
                        controller: searchcontroller,
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.search_outlined,
                            ),
                            border: InputBorder.none,
                            hintText: "Search a Event"),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    search
                        ? ListView(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList())
                        : Column(
                            children: [
                              Container(
                                height: 100,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoriesEvent(
                                                        eventcategory:
                                                            "Music")));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 5.0),
                                        child: Material(
                                          elevation: 3.0,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            width: 130,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "images/musical.png",
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Music",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.0),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoriesEvent(
                                                        eventcategory:
                                                            "Clothing")));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 5.0),
                                        child: Material(
                                          elevation: 3.0,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            width: 130,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "images/tshirt.png",
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Clothing",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.0),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoriesEvent(
                                                        eventcategory:
                                                            "Festival")));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 5.0),
                                        child: Material(
                                          elevation: 3.0,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            width: 130,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "images/confetti.png",
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Festival",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.0),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoriesEvent(
                                                        eventcategory:
                                                            "Food")));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 5.0),
                                        child: Material(
                                          elevation: 3.0,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            width: 130,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "images/dish.png",
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                  "Food",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.0),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Upcoming Events",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text(
                                      "See all",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              allEvents(),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                      detail: data["Detail"],
                      image: data["Image"],
                      name: data["Name"],
                      price: data["Price"],
                      date: data["Date"],
                      location: data["Location"],
                    )));
      },
      child: Container(
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.only(left: 10.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 100,
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "images/event.jpg",
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["Name"],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontFamily: 'Poppins'),
                    ),
                    Text(
                      "\$" + data["Price"],
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 20.0),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Color(0xff0000ff),
                      borderRadius: BorderRadius.circular(60)),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
