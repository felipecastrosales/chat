import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  const TextComposer({
    super.key,
    required this.sendMessage,
  });

  final Function({String? text, File? imgFile}) sendMessage;

  @override
  State<StatefulWidget> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final _controller = TextEditingController();
  bool _isComposing = false;

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo_camera),
            onPressed: () async {
              final imgFile = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              final selectedImage = File(imgFile?.path ?? '');
              if (imgFile == null) return;
              widget.sendMessage(imgFile: selectedImage);
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration.collapsed(
                hintText: 'Enviar mensagem...',
              ),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessage(text: text);
                _reset();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.green),
            onPressed: _isComposing
                ? () {
                    widget.sendMessage(text: _controller.text);
                    _reset();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
