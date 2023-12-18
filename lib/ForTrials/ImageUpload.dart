import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/vegetable': (context) => VegetableScreen(),
        '/fruits': (context) => FruitsScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Selection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                navigateToCategory('Vegetable');
              },
              child: Text('Vegetable'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                navigateToCategory('Fruits');
              },
              child: Text('Fruits'),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedCategory,
              items: ['Vegetable', 'Fruits']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
                navigateToCategory(value!);
              },
            ),
          ],
        ),
      ),
    );
  }

  void navigateToCategory(String category) {
    switch (category) {
      case 'Vegetable':
        Navigator.pushNamed(context, '/vegetable');
        break;
      case 'Fruits':
        Navigator.pushNamed(context, '/fruits');
        break;
    }
  }
}

class VegetableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vegetable Screen'),
      ),
      body: Center(
        child: Text('This is the Vegetable Screen'),
      ),
    );
  }
}

class FruitsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruits Screen'),
      ),
      body: Center(
        child: Text('This is the Fruits Screen'),
      ),
    );
  }
}
