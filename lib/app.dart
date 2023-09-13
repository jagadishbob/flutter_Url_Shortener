

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_shortener/link.dart';
import 'package:url_shortener/pages/historyPage.dart';
import 'package:url_shortener/pages/homePage.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int pageIndex = 0;
  List<Links> links = [];
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Homepage(
        links: links,
      ),
      HistoryPage(
        links: links,
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Shortener'),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (val) {
          setState(() {
            pageIndex = val;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Ionicons.home),
            label: 'Home',
            activeIcon: Icon(Ionicons.home),
          ),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.document_attach_outline),
              label: 'History',
              activeIcon: Icon(Ionicons.document_attach)),
        ],
      ),
    );
  }
}
