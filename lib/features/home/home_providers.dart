import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/models.dart';

/// Global kullanıcı tercihleri state
final userPrefsProvider =
    StateNotifierProvider<UserPrefsNotifier, UserPreferences>(
  (ref) => UserPrefsNotifier(),
);

class UserPrefsNotifier extends StateNotifier<UserPreferences> {
  UserPrefsNotifier() : super(UserPreferences());

  // --- PROFİL ---
  void setMyName(String name) {
    if (name.trim().isEmpty) return;
    state = state.copyWithMyName(name.trim());
  }

  void setMyAvatar(Uint8List bytes) {
    state = state.copyWithMyAvatar(bytes);
  }

  // --- MUTE ---
  void mute(String contactId, Duration duration) {
    state = state.copyWithMute(
      contactId,
      MuteInfo(
        contactId: contactId,
        mutedUntil: DateTime.now().add(duration),
      ),
    );
  }

  void unmute(String contactId) {
    state = state.copyWithUnmute(contactId);
  }

  // --- PRESET LABELS ---
  void setLabel(String contactId, String presetKey, String label) {
    state = state.copyWithLabel(
      PresetLabel(contactId: contactId, presetKey: presetKey, label: label),
    );
  }

  void removeLabel(String contactId, String presetKey) {
    final newList = state.presetLabels
        .where((l) => !(l.contactId == contactId && l.presetKey == presetKey))
        .toList();
    state = UserPreferences(
      myName: state.myName,
      myAvatarBytes: state.myAvatarBytes,
      muteMap: state.muteMap,
      presetLabels: newList,
      quickReplies: state.quickReplies,
    );
  }

  // --- QUICK REPLIES ---
  void addQuickReply(String text) {
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    state = state.copyWithQuickReply(QuickReply(id: id, text: text));
  }

  void removeQuickReply(String id) {
    state = state.copyWithoutQuickReply(id);
  }
}
