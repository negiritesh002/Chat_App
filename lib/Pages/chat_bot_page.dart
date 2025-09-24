import 'dart:async';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: "assets/images/chat_bot_2.jpg",
  );

  String _title = ""; // current animated text
  final String _fullTitle = "CHAT_BOT....";
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_index < _fullTitle.length) {
        // Keep typing next letter
        setState(() {
          _title += _fullTitle[_index];
          _index++;
        });
      } else {
        // Restart after short delay
        Future.delayed(const Duration(microseconds: 200), () {
          setState(() {
            _title = "";
            _index = 0;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // clean up timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      final String question = chatMessage.text;
      String buffer = "";

      final placeholder = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "",
      );
      setState(() {
        messages = [placeholder, ...messages];
      });

      gemini.streamGenerateContent(question).listen((event) {
        final chunk = event.content?.parts
            ?.whereType<TextPart>()
            .map((p) => p.text ?? "")
            .join("") ??
            "";

        if (chunk.isNotEmpty) {
          buffer += chunk; // accumulate

          // find index of the placeholder (or any existing gemini message)
          final idx = messages.indexWhere((m) => m.user == geminiUser);

          final updated = ChatMessage(
            // preserve the original placeholder createdAt if available
            user: geminiUser,
            createdAt: idx != -1 ? messages[idx].createdAt : DateTime.now(),
            text: buffer,
          );

          // replace in a new list to trigger rebuild reliably
          final newMessages = List<ChatMessage>.from(messages);
          if (idx != -1) {
            newMessages[idx] = updated;
          } else {
            // fallback: insert at top
            newMessages.insert(0, updated);
          }

          setState(() {
            messages = newMessages;
          });
        }
      }, onError: (err) {
        print("Stream error: $err");
      }, onDone: () {
        print("Streaming completed. Final text: $buffer");
      });
    } catch (e) {
      print("Error: $e");
    }
  }



}
