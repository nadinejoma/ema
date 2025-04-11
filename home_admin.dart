import 'package:eventbookingapp/admin/ticket_event.dart';
import 'package:eventbookingapp/admin/upload_event.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Column(
          children: [
            Text(
              "Home Admin",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadEvent()));
                      },
                      child: Container(
                        height: 150,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.black45, width: 2.0)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10.0,
                            ),
                            Image.asset(
                              "images/up.png",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              "Upload\nEvents",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> TicketEvent()));
                      },
                      child: Container(
                        height: 150,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.black45, width: 2.0)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10.0,
                            ),
                            Image.asset(
                              "images/ticket.png",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              "Event\nTickets",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                       SizedBox(
                      height: 50.0,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> TicketEvent()));
                      },
                      child: Container(
                        height: 150,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.black45, width: 2.0)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10.0,
                            ),
                            Image.asset(
                              "images/profile.png",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              "Manage\nProfiles",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
