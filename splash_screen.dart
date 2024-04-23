import 'package:flutter/material.dart';
import 'package:smart_hemo_check/sign_in_page.dart';
import 'welcome_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 61, 252, 252), // Set background color to blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon and name
            const Column(
              children: [
              Image(
                image: AssetImage('assets/logo.jpeg'), // Replace 'path_to_your_image' with the actual path to your image asset
                width: 100.0,
                height: 100.0,
              ),
                SizedBox(height: 16.0),
                Text(
                  'Smart Hemo Check ',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
               // color: Colors.blue,
              ),
              child: TweenAnimationBuilder(
                duration: const Duration(seconds: 3),
                tween: Tween(begin: 0.0, end: 1.0),
                onEnd: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const WelcomePage(), // Navigate to your dashboard page
                  ));
                },
                builder: (BuildContext context, double value, Widget? child) {
                  return Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8 * value,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}