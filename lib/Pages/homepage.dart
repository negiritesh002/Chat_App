import 'package:chat_app/Auth/authservice.dart';
import 'package:chat_app/Chat/chat_services.dart';
import 'package:chat_app/Components/my_drawer.dart';
import 'package:chat_app/Components/usertile.dart';
import 'package:chat_app/Pages/chat_bot_page.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  bool _isSwiped = false;

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  void _onChatBotTap(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
        const ChatBotPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide from right to left
          const begin = Offset(1.0, 0.0); // page starts from right
          const end = Offset.zero;        // ends at normal position
          const curve = Curves.easeInOut;

          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          _buildUserList(),

          // 👉 Animated chatbot button (swipe left effect)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            bottom: 20,
            right: _isSwiped ? MediaQuery.of(context).size.width - 100 : 20,
            child: GestureDetector(
              onTap: () => _onChatBotTap(context),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/chat_bot_2.jpg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatServices.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData,
      BuildContext context,
      ) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return Usertile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
