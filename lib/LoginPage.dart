import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'SignupPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print('Login failed: $e');
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.only(top: 20, left: 16, right: 16),
              alignment: Alignment.center,
              child: Image.asset('assets/Cuisinie.png'),
            ),
            SizedBox(height: 8),
            Text(
              'Welcome back',
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
                          SizedBox(height: 16.0),
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
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: _login,
                            child: Text('Login', style: TextStyle(color: cursorColor)),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account yet?', style: TextStyle(color: Colors.white),),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SignupPage()));
                                },
                                child: Text(
                                  'Sign up Now',
                                  style: TextStyle(color: cursorColor),
                                ),
                              ),
                            ],
                          ),
                        ]
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
