import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'LoginPage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _signUp() async {
    if (_passwordController.text.trim() == _confirmPasswordController.text.trim()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        String? uid = userCredential.user?.uid;
        if (uid != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } catch (e) {
        print('Error during registration: $e');
        // Handle registration errors
        String errorMessage = 'Error during registration. Please try again later.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.5),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            content: Text(errorMessage),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      String errorMessage = 'Passwords do not match.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.5),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          content: Text(errorMessage),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cursorColor = Color(0xFFE4AD0C);
    final textColor = Colors.white;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFFE4AD0C),
            ),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFF25262A),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.only(top: 20, left: 16, right: 16),
              alignment: Alignment.center,
              child: Image.asset('assets/Cuisinie.png'),
            ),
            SizedBox(height: 8),
            Text(
              'Create an account to explore recipes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        cursorColor: cursorColor,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: textColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: cursorColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: cursorColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: cursorColor,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: textColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: cursorColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: cursorColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        cursorColor: cursorColor,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: textColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: cursorColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: cursorColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        cursorColor: cursorColor,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: textColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: cursorColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: cursorColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _signUp,
                        child: Text('Sign Up', style: TextStyle(color: cursorColor),),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?', style: TextStyle(color: Colors.white),),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                            },
                            child: Text(
                              'Log In Now',
                              style: TextStyle(color: cursorColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
