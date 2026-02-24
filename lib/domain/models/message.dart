import 'intent.dart';

enum MessageKind { hue, text }

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final MessageKind kind;
  final HueIntent? hueIntent;
  final String? text;
  final DateTime createdAt;
  final DateTime? acknowledgedAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.kind,
    this.hueIntent,
    this.text,
    required this.createdAt,
    this.acknowledgedAt,
  });
}
