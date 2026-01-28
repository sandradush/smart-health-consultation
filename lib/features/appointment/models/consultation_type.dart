import 'package:flutter/material.dart';

enum ConsultationType {
  videoCall('Video Call', Icons.videocam, Colors.blue),
  voiceCall('Voice Call', Icons.call, Colors.green),
  chat('Chat', Icons.chat, Colors.orange),
  inPerson('In-Person', Icons.person, Colors.purple);

  final String displayName;
  final IconData icon;
  final Color color;

  const ConsultationType(this.displayName, this.icon, this.color);
}