import 'package:flutter/material.dart';
import 'package:sellingshop/models/user_model.dart';

class AdminEditUser extends StatefulWidget {
  final UserModel userModel;
  const AdminEditUser({ Key? key, required this.userModel }) : super(key: key);

  @override
  _AdminEditUserState createState() => _AdminEditUserState();
}

class _AdminEditUserState extends State<AdminEditUser> {
  bool load = true;
  UserModel? userModel;

   @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    load = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('edit user'),
      ),
    );
  }
}