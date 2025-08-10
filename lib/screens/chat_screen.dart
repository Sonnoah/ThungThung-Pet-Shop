import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // Change to store sender type
  bool _firstMessageSent = false;

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({'message': _controller.text, 'sender': 'user'}); // Add user message
        if (!_firstMessageSent) {
          _messages.add({'message': "สวัสดีค่ะ ThungThung Petshop ยินดีให้บริการ\nนี่คือข้อความอัตโนมัติ\nต้องการติดต่อสอบถาม กรุณารอสักครู่ค่ะ", 'sender': 'bot'}); // Add bot message
          _firstMessageSent = true;
        }
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: Color.fromRGBO(148, 98, 88, 1)),
          onPressed: () => GoRouter.of(context).go('/user'),
        ),
        title: Text('แชท', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: const [SizedBox(width: 50)],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final sender = message['sender'];
                final msg = message['message'];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: sender == 'user' ? Alignment.centerRight : Alignment.centerLeft, // Adjust alignment based on sender
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: sender == 'user' 
                            ? Color.fromRGBO(225, 213, 198, 1)  // User message color
                            : Color.fromRGBO(205, 162, 105, 1), // Bot message color (light blue)
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        msg!,
                        style: TextStyle(
                          color: sender == 'user' ? Colors.black : Colors.white, // Set text color accordingly
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onSubmitted: (_) {
                      _sendMessage(); // Trigger send message on Enter
                    },
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: Color.fromRGBO(233, 188, 133, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
