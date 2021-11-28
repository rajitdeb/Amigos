import 'package:flutter/material.dart';

class FollowRequests extends StatelessWidget {
  const FollowRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Text("Follow Requests", style: TextStyle(color: Colors.white, fontSize: 48.0)),
      ),
    );
  }
}
