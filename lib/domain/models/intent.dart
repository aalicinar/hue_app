import 'package:flutter/material.dart';

enum HuePreset {
  warm, // Sıcak — genel müsaitlik
  busy, // Meşgul — şu an uygun değil
  listening, // Dinle — sakin mod
  onTheWay, // Geliyor — yolda
  deep, // Derin — ciddi konu
  custom, // Özel — slider ile
}

extension HuePresetExt on HuePreset {
  String get label {
    switch (this) {
      case HuePreset.warm:
        return 'Sıcak';
      case HuePreset.busy:
        return 'Meşgul';
      case HuePreset.listening:
        return 'Dinle';
      case HuePreset.onTheWay:
        return 'Geliyor';
      case HuePreset.deep:
        return 'Derin';
      case HuePreset.custom:
        return 'Özel';
    }
  }

  String get emoji {
    switch (this) {
      case HuePreset.warm:
        return '☀️';
      case HuePreset.busy:
        return '🔴';
      case HuePreset.listening:
        return '🎧';
      case HuePreset.onTheWay:
        return '🚶';
      case HuePreset.deep:
        return '🌊';
      case HuePreset.custom:
        return '✨';
    }
  }

  List<Color> get gradient {
    switch (this) {
      case HuePreset.warm:
        return [const Color(0xFFFF8C42), const Color(0xFFFFB347)];
      case HuePreset.busy:
        return [const Color(0xFFC0392B), const Color(0xFF922B21)];
      case HuePreset.listening:
        return [const Color(0xFF2471A3), const Color(0xFF1A5276)];
      case HuePreset.onTheWay:
        return [const Color(0xFF1E8449), const Color(0xFF145A32)];
      case HuePreset.deep:
        return [const Color(0xFF6C3483), const Color(0xFF4A235A)];
      case HuePreset.custom:
        return [const Color(0xFF7A8399), const Color(0xFF3D4A60)];
    }
  }

  Color get primaryColor => gradient.first;
}

class HueIntent {
  final String id;
  final String senderId;
  final String recipientId;
  final HuePreset preset;
  final double intensity; // 0.0 – 1.0
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? acknowledgedAt;
  final DateTime? undoneAt;

  const HueIntent({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.preset,
    required this.intensity,
    this.photoUrl,
    required this.createdAt,
    this.acknowledgedAt,
    this.undoneAt,
  });

  bool get isAcknowledged => acknowledgedAt != null;
  bool get isUndone => undoneAt != null;
  bool get hasPhoto => photoUrl != null;
}
