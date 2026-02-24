import 'dart:typed_data';

/// Bir kişiyi susturma bilgisi
class MuteInfo {
  final String contactId;
  final DateTime mutedUntil;

  const MuteInfo({required this.contactId, required this.mutedUntil});

  bool get isActive => DateTime.now().isBefore(mutedUntil);

  Duration get remaining => mutedUntil.difference(DateTime.now());

  String get remainingLabel {
    final r = remaining;
    if (r.inHours >= 1) return '${r.inHours}sa';
    if (r.inMinutes >= 1) return '${r.inMinutes}dk';
    return '${r.inSeconds}s';
  }
}

/// Kullanıcının bir preset'e atadığı özel anlam
class PresetLabel {
  final String contactId;
  final String presetKey;
  final String label;

  const PresetLabel({
    required this.contactId,
    required this.presetKey,
    required this.label,
  });
}

/// Hızlı yanıt seçeneği
class QuickReply {
  final String id;
  final String text;
  final bool isDefault;

  const QuickReply({
    required this.id,
    required this.text,
    this.isDefault = false,
  });
}

/// Uygulama genelinde kullanıcı tercihleri (mock state)
class UserPreferences {
  final String myName;
  final Uint8List? myAvatarBytes; // Web'de seçilen fotoğraf byte'ları
  final Map<String, MuteInfo> muteMap;
  final List<PresetLabel> presetLabels;
  final List<QuickReply> quickReplies;

  UserPreferences({
    this.myName = 'Ben',
    this.myAvatarBytes,
    Map<String, MuteInfo>? muteMap,
    List<PresetLabel>? presetLabels,
    List<QuickReply>? quickReplies,
  })  : muteMap = muteMap ?? {},
        presetLabels = presetLabels ?? _defaultLabels,
        quickReplies = quickReplies ?? _defaultQuickReplies;

  static final List<PresetLabel> _defaultLabels = const [];

  static final List<QuickReply> _defaultQuickReplies = [
    QuickReply(id: 'ok', text: 'Tamam', isDefault: true),
    QuickReply(id: 'yes', text: 'Evet', isDefault: true),
    QuickReply(id: 'no', text: 'Hayır', isDefault: true),
    QuickReply(id: 'later', text: 'Sonra', isDefault: true),
  ];

  bool isMuted(String contactId) {
    final info = muteMap[contactId];
    return info != null && info.isActive;
  }

  MuteInfo? getMuteInfo(String contactId) => muteMap[contactId];

  String? getLabelFor(String contactId, String presetKey) {
    final personal = presetLabels
        .where(
          (l) => l.contactId == contactId && l.presetKey == presetKey,
        )
        .toList();
    if (personal.isNotEmpty) return personal.first.label;

    final global = presetLabels
        .where(
          (l) => l.contactId == 'global' && l.presetKey == presetKey,
        )
        .toList();
    if (global.isNotEmpty) return global.first.label;

    return null;
  }

  // ─── Copy helpers ────────────────────────────────────────

  UserPreferences copyWithMyName(String name) => UserPreferences(
        myName: name,
        myAvatarBytes: myAvatarBytes,
        muteMap: muteMap,
        presetLabels: presetLabels,
        quickReplies: quickReplies,
      );

  UserPreferences copyWithMyAvatar(Uint8List bytes) => UserPreferences(
        myName: myName,
        myAvatarBytes: bytes,
        muteMap: muteMap,
        presetLabels: presetLabels,
        quickReplies: quickReplies,
      );

  UserPreferences copyWithMute(String contactId, MuteInfo info) {
    final newMap = Map<String, MuteInfo>.from(muteMap);
    newMap[contactId] = info;
    return UserPreferences(
      myName: myName,
      myAvatarBytes: myAvatarBytes,
      muteMap: newMap,
      presetLabels: presetLabels,
      quickReplies: quickReplies,
    );
  }

  UserPreferences copyWithUnmute(String contactId) {
    final newMap = Map<String, MuteInfo>.from(muteMap);
    newMap.remove(contactId);
    return UserPreferences(
      myName: myName,
      myAvatarBytes: myAvatarBytes,
      muteMap: newMap,
      presetLabels: presetLabels,
      quickReplies: quickReplies,
    );
  }

  UserPreferences copyWithLabel(PresetLabel label) {
    final newList = presetLabels
        .where((l) =>
            !(l.contactId == label.contactId && l.presetKey == label.presetKey))
        .toList()
      ..add(label);
    return UserPreferences(
      myName: myName,
      myAvatarBytes: myAvatarBytes,
      muteMap: muteMap,
      presetLabels: newList,
      quickReplies: quickReplies,
    );
  }

  UserPreferences copyWithQuickReply(QuickReply reply) {
    final newList = [...quickReplies, reply];
    return UserPreferences(
      myName: myName,
      myAvatarBytes: myAvatarBytes,
      muteMap: muteMap,
      presetLabels: presetLabels,
      quickReplies: newList,
    );
  }

  UserPreferences copyWithoutQuickReply(String id) {
    final newList = quickReplies.where((r) => r.id != id).toList();
    return UserPreferences(
      myName: myName,
      myAvatarBytes: myAvatarBytes,
      muteMap: muteMap,
      presetLabels: presetLabels,
      quickReplies: newList,
    );
  }
}
