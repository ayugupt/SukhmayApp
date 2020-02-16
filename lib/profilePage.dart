import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  String name, address, mobileNo, email, gender;
  ProfilePage(this.name, this.address, this.mobileNo, this.email, this.gender);
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.grey, Colors.grey[200]])),
          )
        ],
      ),
    );
  }
}
