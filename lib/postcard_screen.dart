import 'package:flutter/material.dart';

class PostcardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weatherly - Share Postcard')),
      body: Center(child: Text('Create and Share Weather Postcards')),
    );
  }
}
