import 'dart:io';

import 'package:chat_sockets/SocketDemo/SocketUtil.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketDemo extends StatefulWidget {
  SocketDemo() : super();

  final String title = "Socket Demo";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return SocketDemoState();
  }
}

class SocketDemoState extends State<SocketDemo> {
  TextEditingController _textEditingController;
  WebSocketChannel _channel;
  String _status;
  SocketUtil _socketUtil;
  List<String> _messages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
   // _connectSocketChannel();
    _status = '';
    _socketUtil = SocketUtil();
    _messages = List<String>();
  }

  _connectSocketChannel() {
    _channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
  }

  void sendMessage() {
    _channel.sink.add(_textEditingController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close();
  }

  Widget _messageTextField() {
    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(6.0)),
          ),
          filled: true,
          fillColor: Colors.white60,
          contentPadding: EdgeInsets.all(15.0),
          hintText: 'Message'),
    );
  }

  Widget _sendBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: OutlineButton(
          child: Text('Send Message'),
          onPressed: () {
            if (_textEditingController.text.isEmpty) {
              return;
            }
          //  sendMessage();
            _socketUtil.sendMessage(_textEditingController.text, connectionListener);
          }),
    );
  }

  Widget _streamBuilder() {
    return StreamBuilder(
      stream: _channel.stream,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            _messageTextField(),
            _sendBtn(),
            Text(_status),
          ],
        ),
      ),
    );
  }

  void connectionListener(bool connected) {
    setState(() {
      _status = 'Status : ' + (connected ? "Connected" : "Failed to connect");
    });
  }


}
