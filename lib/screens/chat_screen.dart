import 'package:flutter/material.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/global.dart';
import 'package:scholar_chat/helper/get_chat_id.dart';
import 'package:scholar_chat/models/contact.dart';
import 'package:scholar_chat/models/message.dart';
import 'package:scholar_chat/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'ChatScreen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? content;

  TextEditingController controller = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final ScrollController _controller = ScrollController();

  // scroll listView to the end
  void _scrollDown() {
    if (_controller.hasClients) {
      _controller.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Scroll to bottom after first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final contact = ModalRoute.of(context)!.settings.arguments as Contact;

    final chatId = getChatId(Global.email!, contact.email);
    final chatsRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return StreamBuilder<QuerySnapshot>(
      stream: chatsRef
          .collection(kMessagesCollection)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (var doc in snapshot.data!.docs) {
            messagesList.add(Message.fromJson(doc));
          }
          _scrollDown();
          return Scaffold(
            appBar: AppBar(
              // centerTitle: true,
              foregroundColor: Colors.white,
              title: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: kPictureColor,
                  child: Text(
                    contact.name.trimLeft()[0].toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                title: Text(
                  contact.name,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              backgroundColor: kPrimaryColor,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return (messagesList[index].sender == Global.email)
                          ? ChatBubble(message: messagesList[index])
                          : ChatBubbleForFriend(message: messagesList[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controller,
                    onChanged: (data) {
                      content = data;
                    },
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      suffixIconColor: kPrimaryColor,
                      suffixIcon: IconButton(
                        onPressed: () async {
                          if (content == null || content!.trim().isEmpty) {
                            return;
                          }

                          // Make sure the chat exists (create it if missing)
                          await chatsRef.set({
                            'users': [Global.email, contact.email],
                            'createdAt': FieldValue.serverTimestamp(),
                          }, SetOptions(merge: true));

                          // Then add your message under messages/
                          await chatsRef.collection('messages').add({
                            kContent: content,
                            kCreatedAt: FieldValue.serverTimestamp(),
                            kSender: Global.email,
                          });

                          controller.clear();
                          // Hide the keyboard
                          _scrollDown();
                        },
                        icon: Icon(Icons.send),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
