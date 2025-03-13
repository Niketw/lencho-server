import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lencho/models/UserDetails.dart';
import 'package:lencho/screens/chat/chat_page.dart';
import 'package:lencho/screens/chat/user_search_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.to(() => const UserSearchPage());
            },
          ),
        ],
      ),
      body: currentUser == null
          ? const Center(child: Text('Please log in to access chat'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('participants', arrayContains: currentUser.uid)
                  .orderBy('lastMessageTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No chats yet'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => const UserSearchPage());
                          },
                          child: const Text('Find someone to chat with'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final chatDoc = snapshot.data!.docs[index];
                    final chatData = chatDoc.data() as Map<String, dynamic>;
                    final participants =
                        List<String>.from(chatData['participants']);

                    // Get the other user's ID
                    final otherUserId = participants.firstWhere(
                      (id) => id != currentUser.uid,
                      orElse: () => 'Unknown',
                    );

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(otherUserId)
                          .get(),
                      builder: (context, userSnapshot) {
                        String userName = 'Loading...';

                        if (userSnapshot.hasData) {
                          final userData = userSnapshot.data!.data()
                              as Map<String, dynamic>?;
                          if (userData != null) {
                            userName = userData['email'] ?? 'Unknown';
                          }
                        }

                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(userName.isNotEmpty
                                ? userName[0].toUpperCase()
                                : '?'),
                          ),
                          title: Text(userName),
                          subtitle: Text(
                            chatData['lastMessage'] ?? 'Start a conversation',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: chatData['lastMessageTime'] != null
                              ? Text(
                                  _formatTimestamp(
                                      chatData['lastMessageTime'] as Timestamp),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                )
                              : null,
                          onTap: () {
                            Get.to(() => ChatPage(
                                  chatId: chatDoc.id,
                                  otherUserId: otherUserId,
                                ));
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();

    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      // Today - show time only
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (date.day == now.day - 1 &&
        date.month == now.month &&
        date.year == now.year) {
      // Yesterday
      return 'Yesterday';
    } else {
      // Other days - show date
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
