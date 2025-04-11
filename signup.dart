
import 'package:eventbookingapp/admin/admin_login.dart';
import 'package:eventbookingapp/services/auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Image.asset("images/onboarding.png"),
            SizedBox(height: 10.0,),
            Text(
              "Unlock the Future of",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
             Text(
              "Event Booking App",
              style: TextStyle(
                  color: Color(0xff6351ec),
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0,),
            Text(
              "Discover, book, and experience unforgettable moments effortlessly!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 20.0,
               ),
            ),
             SizedBox(height: 50.0,),
            GestureDetector(
              onTap: ()async{
                AuthMethods().signInWithGoogle(context);
              },
              child: Container(
                height: 70,
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
                decoration: BoxDecoration( color: Color(0xff6351ec),borderRadius: BorderRadius.circular(40)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Image.asset("images/google.png", height: 30, width: 30, fit: BoxFit.cover,),
                  SizedBox(width: 20.0,),
                   Text(
                  "Sign in with Google",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0,
                   ),
                ),
                ],),
              ),
            ),
            SizedBox(height: 20.0,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminLogin()));
              },
              child: Text(
                    "Admin Panel",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                     ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
