import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification"), centerTitle: true),

      body: Center(

        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No Notification", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
