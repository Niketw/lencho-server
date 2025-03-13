import 'package:flutter/material.dart';
import 'package:lencho/widgets/home/header_widgets.dart';
import 'package:lencho/widgets/home/content_widgets.dart';
import 'package:get/get.dart';
import 'package:lencho/screens/chat/chat_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          HomeHeader(),
          HomeContent(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
        onTap: (index) {
          if (index == 3) {
            // Navigate to chat list page when chat icon is tapped
            Get.to(() => const ChatListPage());
          }
        },
        type: BottomNavigationBarType.fixed, // Required for 4+ items
      ),
    );
  }
}
