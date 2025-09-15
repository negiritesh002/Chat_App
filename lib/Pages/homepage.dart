import 'package:chat_app/Auth/authservice.dart';
import 'package:chat_app/Chat/chat_services.dart';
import 'package:chat_app/Components/my_drawer.dart';
import 'package:chat_app/Components/usertile.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  void logout(){
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList(){
    return StreamBuilder(stream: _chatServices.getUserStream(), builder: (context, snapshot){
      if (snapshot.hasError){
        return const Text("Error");
      }

      if (snapshot.connectionState == ConnectionState.waiting){
        return const Text("Loading..");
      }
      return ListView(
        children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(
          userData,context
        )
        ).toList(),
      );
    });
  }
  Widget _buildUserListItem(
      Map<String,dynamic> userData, BuildContext context){
    if(userData["email"] != _authService.getCurrentUser()!.email){
      return Usertile(
        text: userData["email"],
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
            receiverEmail: userData["email"],
            receiverID: userData["uid"],
          ),));
        },
      );
    }
    else {
      return Container();
    }
  }
}

