import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'chat_message.dart';
import 'text_composer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final googleSignIn = GoogleSignIn();
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreCollection = FirebaseFirestore.instance.collection('messages');

  User? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      firebaseAuth.authStateChanges().listen((user) {
        if (user != null) {
          setState(() => _currentUser = user);
        } else {
          setState(() => _currentUser = null);
        }
      });
    }
  }

  Future<User?> _getUser() async {
    if (_currentUser != null) return _currentUser;

    try {
      final googleSignInAccount = await googleSignIn.signIn();
      final googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      if (googleSignInAccount == null) return null;
      if (googleSignInAuthentication == null) return null;

      final credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final authResult = await firebaseAuth.signInWithCredential(credential);
      final user = authResult.user;
      return user;
    } catch (e, s) {
      debugPrint('Erro ao realizar login: $e');
      debugPrint('Stack trace: $s');
      return null;
    }
  }

  Future<void> _sendMessage({
    File? imgFile,
    String? text,
  }) async {
    final user = await _getUser();
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Não foi  possível realizar seu login. Tente novamente...',
            ),
          ),
        );
      }
    }

    if (user != null) {
      var data = <String, dynamic>{
        'uid': user.uid,
        'senderName': user.displayName,
        'senderPhotoUrl': user.photoURL,
        'time': Timestamp.now(),
      };

      final task = FirebaseStorage.instance.ref().child(
            user.uid + DateTime.now().millisecondsSinceEpoch.toString(),
          );

      if (imgFile != null) {
        setState(() => _isLoading = true);
        final taskWithImage = task.putFile(imgFile);
        var taskSnapshot = await taskWithImage.whenComplete(() {});
        String url = await taskSnapshot.ref.getDownloadURL();
        data['imgUrl'] = url;
      } else {
        data['text'] = text;
      }
      setState(() => _isLoading = false);
      firestoreCollection.add(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          _currentUser != null
              ? 'Olá, ${_currentUser?.displayName ?? 'Nome não informado.'}'
              : 'Chat App',
        ),
        actions: <Widget>[
          _currentUser != null
              ? IconButton(
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    firebaseAuth.signOut();
                    googleSignIn.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Você saiu com sucesso.'),
                      ),
                    );
                  },
                )
              : const SizedBox(),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreCollection.orderBy('time').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    var documents = snapshot.data?.docs.reversed.toList() ??
                        <QueryDocumentSnapshot>[];
                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final document = documents[index];
                        return ChatMessage(
                          data: document.data() as Map<String, dynamic>,
                          isMine: document['uid'] == _currentUser?.uid,
                        );
                      },
                    );
                }
              },
            ),
          ),
          _isLoading ? const LinearProgressIndicator() : const SizedBox(),
          TextComposer(
            sendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
