import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final List<String> bannerImages = [
    'assets/banner/b1.jpg', // Path to your first banner image
    'assets/banner/b2.jpeg', // Path to your second banner image
    'assets/banner/b3.jpeg', // Path to your third banner image
    // Add more banner images as needed
  ];

  // Sample images for the place screen
  final List<String> placeImages = [
    'assets/Logo/welcome.jpg', // Path to your first place image
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildSectionTitle('Welcome Screen Settings'),
              // Multiple Place Images
              Container(
                height: 200, // Set a height for the place images area
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: placeImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 300, // Width of each place image
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.asset(
                        placeImages[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle get started action
                  print('Get Started clicked');
                },
                child: Text('Get Started'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                ),
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Admin Settings'),
              Center(
                // Center the logo
                child: GestureDetector(
                  onTap: () {
                    // Show admin details in a dialog
                    _showAdminDetails(context);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/Logo/welcome.jpg'), // Path to your application logo
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildSectionTitle('Banner Settings'),
              // Multiple Banners
              Container(
                height: 200, // Set a height for the banner area
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bannerImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 300, // Width of each banner
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.asset(
                        bannerImages[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              // Banner Actions
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle add banner action
                      print('Addit Banner');
                    },
                    child: Text('Addit Banner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Button color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle remove banner action
                      print('Remove Banner');
                    },
                    child: Text('Remove Banner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Button color
                    ),
                  ),
                ],
              ),

              // Placeholder for additional settings
              SizedBox(height: 20),
              _buildSectionTitle('Additional Settings'),
              ListTile(
                title: Text('Notification Settings'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  // Handle navigation to notification settings
                },
              ),
              ListTile(
                title: Text('Privacy Policy'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  // Handle navigation to privacy policy
                },
              ),
              ListTile(
                title: Text('Help & Support'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  // Handle navigation to help and support
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.green.withOpacity(0.3), // Highlight color
          height: 30, // Height of the highlighted line
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 8), // Space between title and content
      ],
    );
  }

  void _showAdminDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Admin Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Name: Admin User'),
                Text('Email: admin@example.com'),
                Text('Phone: +123 456 7890'),
                SizedBox(height: 10),
                Text('Update Details:'),
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle update action
                print('Admin details updated');
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SettingsPage(),
  ));
}
