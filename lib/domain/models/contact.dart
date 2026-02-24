import 'presence.dart';
import 'intent.dart';

class Contact {
  final String id;
  final String name;
  final String? avatarUrl;
  final PresenceStatus presenceStatus;
  final HueIntent? lastIntent;
  final DateTime? lastActiveAt;

  const Contact({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.presenceStatus,
    this.lastIntent,
    this.lastActiveAt,
  });
}
