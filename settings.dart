import 'package:flutter/material.dart';
import 'package:smart_hemo_check/welcome_page.dart';

import 'database_helper.dart';

class Settings extends StatelessWidget {

  final dbHelper = DatabaseHelper();

  Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        leading: Container(),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          SettingCard(
            title: 'Notifications',
            icon: Icons.notifications,
            onPressed: () {
              showSnackBar(context, 'Notifications');
            },
          ),
          SettingCard(
            title: 'Profile',
            icon: Icons.account_circle,
            onPressed: () {
              showSnackBar(context, 'Profile');
            },
          ),
          SettingCard(
            title: 'Privacy',
            icon: Icons.privacy_tip,
            onPressed: () {
              showSnackBar(context, 'Privacy');
            },
          ),
          SettingCard(
            title: 'Security',
            icon: Icons.security,
            onPressed: () {
              showSnackBar(context, 'Security');
            },
          ),
          SettingCard(
            title: 'Delete Account',
            icon: Icons.account_box_rounded,
            onPressed: () {
              _showDeleteAccountDialog(context);
            },
          ),
          SettingCard(
            title: 'Log Out',
            icon: Icons.logout,
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
          // Add more SettingCard widgets here as needed
        ],
      ),
    );
  }
  void showSnackBar(BuildContext context, String option) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The $option option is not implemented yet.'),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Set border color here
                    width: 1.0, // Set border width here
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Set border radius here
                ),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your name',
                    border: OutlineInputBorder(), // Hide default border
                    contentPadding: EdgeInsets.all(8.0), // Adjust content padding
                  ),
                ),
              ),
              const SizedBox(height: 16.0), // Add some spacing between inputs
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Set border color here
                    width: 1.0, // Set border width here
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Set border radius here
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Enter your Password',
                    border: OutlineInputBorder(), // Hide default border
                    contentPadding: EdgeInsets.all(8.0), // Adjust content padding
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () async {
                String username = usernameController.text;
                String password = passwordController.text;
                // Call the deleteUser function with provided credentials
                await dbHelper.deleteUser(context, username, password);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade800,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.white),
            ),
            ),
          ],
        );
      },
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade800,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: const Text('Log Out',style: TextStyle(color: Colors.white),),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const WelcomePage()));
              },
            ),
          ],
        );
      },
    );
  }

}

class SettingCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const SettingCard({super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 150.0,
          height: 150.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 48.0,
                  color: Colors.black,
                ),
                const SizedBox(height: 12.0),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
