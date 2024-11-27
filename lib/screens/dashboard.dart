import 'package:flutter/material.dart';
import 'package:lubinpla/components/dashboard/project_screen.dart';
import 'package:lubinpla/helpers/pref_data.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Screen',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 0,
          showUnselectedLabels: true,
          backgroundColor: Colors.white, // Background color
          selectedItemColor: Colors.black, // Selected item color
          unselectedItemColor: Colors.black26, // Unselected item color
        ),
      ),
      home: HomeScreen(
        currentIndex: 0,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  int currentIndex = 0;
  HomeScreen({super.key, required this.currentIndex});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DocumentScreen(),
    const ProjectScreen(),
    const ChatScreen(),
    const MoreScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text(
      //     ['도큐먼트', '프로젝트', '채팅', '더보기'][_currentIndex],
      //   ),
      //   centerTitle: true,
      // ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // Remove ripple effect
          highlightColor: Colors.transparent, // Remove tab press overlay
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // No shifting effect
          elevation: 0,
          selectedFontSize: 12, // Font size for selected label
          unselectedFontSize: 10, // Font size for unselected label
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black26,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: '도큐먼트',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: '프로젝트',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: '채팅',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: '더보기',
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  late String name = ''; // Initialize with an empty string

  @override
  void initState() {
    super.initState();
    _initializeControllers(); // Make sure to call _initializeControllers
  }

  // Initialize the controllers and fetch data from SharedPreferences
  Future<void> _initializeControllers() async {
    final givenName = await getSavedData('givenName');

    print(givenName);
    // If givenName is fetched successfully, set it to the name variable
    if (givenName != null) {
      setState(() {
        name = givenName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Document Screen \n Hi $name', // Display the name
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Chat Screen',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'More Screen',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
