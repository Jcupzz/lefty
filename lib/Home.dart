import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lefty/Authentication/Authentication_Services.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("Lefty.",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.follow_the_signs_outlined), onPressed: ()async{
            dynamic isLoggedOut = await context
                .read<AuthenticationService>()
                .signOut();
            if (isLoggedOut.toString() == "Signed out") {
              Navigator.pushReplacementNamed(
                  context, "/Register");
            }
          }),
        ],
      ),
    );
  }
}
