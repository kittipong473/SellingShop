import 'package:flutter/material.dart';

class AdminAddUser extends StatefulWidget {
  const AdminAddUser({Key? key}) : super(key: key);

  @override
  _AdminAddUserState createState() => _AdminAddUserState();
}

class _AdminAddUserState extends State<AdminAddUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add user'),
      ),
    );
  }
}
