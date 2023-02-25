import 'package:flutter/material.dart';

import 'chat_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ChatApp(),
  );
}
