import 'package:flutter/material.dart';

class SessionProgress extends StatelessWidget {
  final int total;
  final int completed;

  SessionProgress(this.total, this.completed);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(completed.toString(), textAlign: TextAlign.right)),
      Text("of"),
      Expanded(child: Text(total.toString()))
    ]);
  }
}
