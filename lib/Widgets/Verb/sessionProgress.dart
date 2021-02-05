import 'package:flutter/material.dart';

class SessionProgress extends StatelessWidget {
  final int total;
  final int completed;

  SessionProgress(this.total, this.completed);

  @override
  Widget build(BuildContext context) {
    // if total hasn't been set yet (because the verbs haven't loaded yet...)
    if (completed > total) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.all(20),
      child: LinearProgressIndicator(minHeight: 30, value: completed / total),
    );
  }
}
