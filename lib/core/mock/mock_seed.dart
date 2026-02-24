import '../../domain/models/models.dart';

class MockSeed {
  static const String currentUserId = 'me';

  static final List<Contact> contacts = [
    Contact(
      id: 'user1',
      name: 'Ayşe',
      presenceStatus: PresenceStatus.available,
      lastIntent: HueIntent(
        id: 'i1',
        senderId: 'user1',
        recipientId: currentUserId,
        preset: HuePreset.warm,
        intensity: 0.8,
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      lastActiveAt: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    Contact(
      id: 'user2',
      name: 'Can',
      presenceStatus: PresenceStatus.busy,
      lastIntent: HueIntent(
        id: 'i2',
        senderId: currentUserId,
        recipientId: 'user2',
        preset: HuePreset.onTheWay,
        intensity: 1.0,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        acknowledgedAt: DateTime.now().subtract(const Duration(minutes: 55)),
      ),
      lastActiveAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Contact(
      id: 'user3',
      name: 'Mert',
      presenceStatus: PresenceStatus.deepTalk,
      lastIntent: null,
      lastActiveAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Contact(
      id: 'user4',
      name: 'Selin',
      presenceStatus: PresenceStatus.onTheWay,
      lastIntent: HueIntent(
        id: 'i3',
        senderId: 'user4',
        recipientId: currentUserId,
        preset: HuePreset.deep,
        intensity: 0.6,
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      lastActiveAt: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    Contact(
      id: 'user5',
      name: 'Burak',
      presenceStatus: PresenceStatus.sleeping,
      lastIntent: null,
      lastActiveAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    Contact(
      id: 'user6',
      name: 'Zeynep',
      presenceStatus: PresenceStatus.listening,
      lastIntent: HueIntent(
        id: 'i4',
        senderId: 'user6',
        recipientId: currentUserId,
        preset: HuePreset.listening,
        intensity: 0.5,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        acknowledgedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      lastActiveAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  static final List<Message> messagesWithUser1 = [
    Message(
      id: 'm1',
      conversationId: 'conv_user1',
      senderId: 'user1',
      kind: MessageKind.hue,
      hueIntent: HueIntent(
        id: 'ci1',
        senderId: 'user1',
        recipientId: currentUserId,
        preset: HuePreset.warm,
        intensity: 0.9,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        acknowledgedAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      acknowledgedAt: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    Message(
      id: 'm2',
      conversationId: 'conv_user1',
      senderId: currentUserId,
      kind: MessageKind.text,
      text: 'Merhaba! Nasılsın?',
      createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    Message(
      id: 'm3',
      conversationId: 'conv_user1',
      senderId: 'user1',
      kind: MessageKind.hue,
      hueIntent: HueIntent(
        id: 'ci2',
        senderId: 'user1',
        recipientId: currentUserId,
        preset: HuePreset.deep,
        intensity: 0.7,
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    Message(
      id: 'm4',
      conversationId: 'conv_user1',
      senderId: currentUserId,
      kind: MessageKind.hue,
      hueIntent: HueIntent(
        id: 'ci3',
        senderId: currentUserId,
        recipientId: 'user1',
        preset: HuePreset.onTheWay,
        intensity: 1.0,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  static final Contact currentUser = Contact(
    id: currentUserId,
    name: 'Ben',
    presenceStatus: PresenceStatus.available,
  );
}
