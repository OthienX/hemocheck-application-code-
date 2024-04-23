import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'homePage.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedSex = 'Male';

  late BuildContext _scaffoldContext; // Define a variable to store Scaffold context

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 61, 252, 252),
        appBar: AppBar(
          title: const Text('Sign Up', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 61, 252, 252),
          leading: Container(),
        ),
        body: Builder( // Use Builder widget to get a new context for Scaffold
            builder: (BuildContext scaffoldContext) {
              _scaffoldContext = scaffoldContext; // Store Scaffold context
              return Center(
                child: Card(
                  margin: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
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
                              // You can add more complex email validation here if needed
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              // You can add more complex password validation here if needed
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _ageController,
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your age';
                              }
                              // You can add more complex age validation here if needed
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _selectedSex,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedSex = value!;
                              });
                            },
                            items: <String>['Male', 'Female', 'Other']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Sex',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your sex';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _registerUser();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100,
                                  vertical: 15), // Adjust width as needed
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Adding space between button and text below
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Sign In',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Call sign-up class
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const SignInPage()),
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
              );
            }
        )
    );
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final username = _nameController.text;
      final password = _passwordController.text;
      final email = _emailController.text;
      final age = int.tryParse(_ageController.text) ?? 0; // Handle parsing error
      final sex = _selectedSex;

      final user = {
        'username': username,
        'password': password,
        'email': email,
        'age': age,
        'sex': sex,
      };

      final dbHelper = DatabaseHelper();
      try {
        await dbHelper.registerUser(user);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User registered successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to register user'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

}
