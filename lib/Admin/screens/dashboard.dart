import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:grocery_vegitable_market/Admin/screens/Add_category.dart';
import 'package:grocery_vegitable_market/Admin/screens/Add_item.dart';
import 'package:grocery_vegitable_market/Admin/screens/All_Product.dart';
import 'package:grocery_vegitable_market/Admin/screens/Delivery_boy_details.dart';
import 'package:grocery_vegitable_market/Admin/screens/Service_Page.dart';
import 'package:grocery_vegitable_market/Admin/screens/Setting.dart';
import 'package:grocery_vegitable_market/Admin/screens/User_details.dart';
import 'package:grocery_vegitable_market/Admin/screens/manage_order.dart';

void main() {
  runApp(DashboardApp());
}

class DashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedDrawerIndex = 0; // Track the selected item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 20),
            _buildProductStatusGrid(),
            SizedBox(height: 20),
            _buildSectionWithChart(
              title: 'Weekly Activity',
              chartWidget: _buildWeeklyActivityChart(),
            ),
            SizedBox(height: 20),
            _buildSectionWithChart(
              title: 'High Product Selling',
              chartWidget: _buildHighProductSellingChart(),
            ),
            SizedBox(height: 20),
            _buildSectionWithChart(
              title: 'City Sales Distribution',
              chartWidget: _buildCityPieChart(),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 2,
      backgroundColor: Colors.green,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Text('Dashboard', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/Logo/welcome.jpg'),
            radius: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.green, Colors.lightGreen]),
            ),
            child: Row(
              children: [
                Image.asset('assets/Logo/carrot.png', width: 40, height: 40),
                SizedBox(width: 10),
                Text('Vegetable Market',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          ),
          _buildDrawerItem(
              Icons.home, 'Dashboard', context, 0, DashboardPage()),
          _buildDrawerItem(
              Icons.add_circle_outline, 'Add Item', context, 1, AddItemPage()),
          _buildDrawerItem(
              Icons.category, 'Add Category', context, 2, AddCategoryPage()),
          _buildDrawerItem(Icons.person, 'Users', context, 3, UsersPage()),
          _buildDrawerItem(
              Icons.inventory, 'Manage Order', context, 4, ManageOrderPage()),
          _buildDrawerItem(
              Icons.grid_on, 'All Product', context, 5, AllProductPage()),
          _buildDrawerItem(Icons.build, 'Services', context, 6, ServicesPage()),
          _buildDrawerItem(Icons.delivery_dining, 'Delivery Boy Details',
              context, 7, DeliveryBoyDetailsPage()),
          _buildDrawerItem(
              Icons.settings, 'Settings', context, 8, SettingsPage()),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context,
      int index, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: TextStyle(color: Colors.grey)),
      tileColor: _selectedDrawerIndex == index
          ? Colors.green.withOpacity(0.2)
          : null, // Highlight selected item
      onTap: () {
        setState(() {
          _selectedDrawerIndex = index; // Update selected index
        });
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          hintText: 'Search for something...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildProductStatusGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemCount: _statusCards.length,
      itemBuilder: (context, index) => _statusCards[index],
    );
  }

  final List<Widget> _statusCards = [
    _buildStatusCard('All Products', Icons.shopping_bag, Colors.blue),
    _buildStatusCard('Packaging', Icons.inventory, Colors.amber),
    _buildStatusCard('Delivered', Icons.local_shipping, Colors.green),
    _buildStatusCard('Completed', Icons.check_circle, Colors.deepPurple),
  ];

  static Widget _buildStatusCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            Spacer(),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionWithChart(
      {required String title, required Widget chartWidget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        chartWidget,
      ],
    );
  }

  Widget _buildWeeklyActivityChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [BarChartRodData(toY: 8, color: Colors.blue, width: 20)],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(toY: 10, color: Colors.green, width: 20)
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(toY: 14, color: Colors.blue, width: 20)
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(toY: 15, color: Colors.green, width: 20)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighProductSellingChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 3),
                FlSpot(1, 5),
                FlSpot(2, 7),
                FlSpot(3, 4),
                FlSpot(4, 6),
              ],
              isCurved: true,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
              ),
              barWidth: 3,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityPieChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 40,
              title: 'City A',
              color: Colors.red,
            ),
            PieChartSectionData(
              value: 30,
              title: 'City B',
              color: Colors.blue,
            ),
            PieChartSectionData(
              value: 30,
              title: 'City C',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
