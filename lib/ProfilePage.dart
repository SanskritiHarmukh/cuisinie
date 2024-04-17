import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginPage.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String username = "User";
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFFE4AD0C),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: Icon(Icons.logout, color: Colors.black,), // Change the icon to logout
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
        ],
      ),
      backgroundColor: Color(0xFF25262A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoggedIn)
              Text(
                'Welcome',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )
            else
              Column(
                children: [
                  Text(
                    'Log in to access user exclusive functionalities',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(primary: Color(0xFFE4AD0C),),
                    child: Text('Login', style: TextStyle(color: Color(0xFF25262A), )),
                  ),
                ],
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
