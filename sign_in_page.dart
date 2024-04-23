import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'sign_up_page.dart';
import 'database_helper.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 61, 252, 252),
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 61, 252, 252),
        leading: Container(), // Removes the back button
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          color: Colors.white, // Set card background color to white
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Add email validation logic if needed
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      // Add password validation logic if needed
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _signIn();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 100,vertical: 15), // Adjust width as needed
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20), // Adding space between button and text below
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Do not have an account? ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign up',
                          style: const TextStyle(
                            color: Colors.green,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Call sign-up class
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpPage()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final dbHelper = DatabaseHelper();
      try {
        final user = await dbHelper.authenticateUser(email, password);
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign in successful'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid username or password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


}


