import 'package:flutter/material.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Upper Expanded Section
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 400,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 61, 252, 252),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon and App Name
                    Image(
                      image: AssetImage('assets/logo.jpeg'), // Replace 'path_to_your_image' with the actual path to your image asset
                      width: 100.0,
                      height: 100.0,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Smart Hemo Check',
                      style: TextStyle(color: Colors.black, fontSize: 24.0),
                    ),
                    SizedBox(height: 10.0),
                    // Welcoming Text
                    Text(
                      'Welcome',
                      style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    // Additional welcoming text below
                    Text(
                      'We are glad to have you here!',
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Lower Expanded Section
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[350],
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Sign in Button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Sign In Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Sign up Text
                    InkWell(
                      onTap: () {
                        // Navigate to Sign Up Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        'Do not have an account? Sign up',
                        style: TextStyle(color: Colors.green, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
