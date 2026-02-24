import 'package:flutter/material.dart';

enum PresenceStatus {
  available,  // Müsait
  busy,       // Meşgul
  listening,  // Dinleme modu
  deepTalk,   // Derin sohbet
  away,       // Uzakta
  sleeping,   // Uyuyor
  onTheWay,   // Yolda
}

extension PresenceStatusExt on PresenceStatus {
  String get label {
    switch (this) {
      case PresenceStatus.available:  return 'Müsait';
      case PresenceStatus.busy:       return 'Meşgul';
      case PresenceStatus.listening:  return 'Dinliyor';
      case PresenceStatus.deepTalk:   return 'Derin sohbet';
      case PresenceStatus.away:       return 'Uzakta';
      case PresenceStatus.sleeping:   return 'Uyuyor';
      case PresenceStatus.onTheWay:   return 'Yolda';
    }
  }

  Color get auraColor {
    switch (this) {
      case PresenceStatus.available:  return const Color(0xFFFF8C42);
      case PresenceStatus.busy:       return const Color(0xFFC0392B);
      case PresenceStatus.listening:  return const Color(0xFF2471A3);
      case PresenceStatus.deepTalk:   return const Color(0xFF6C3483);
      case PresenceStatus.away:       return const Color(0xFF7A8399);
      case PresenceStatus.sleeping:   return const Color(0xFF1C2833);
      case PresenceStatus.onTheWay:   return const Color(0xFF1E8449);
    }
  }

  Color get auraColorEnd {
    switch (this) {
      case PresenceStatus.available:  return const Color(0xFFFFB347);
      case PresenceStatus.busy:       return const Color(0xFF922B21);
      case PresenceStatus.listening:  return const Color(0xFF1A5276);
      case PresenceStatus.deepTalk:   return const Color(0xFF4A235A);
      case PresenceStatus.away:       return const Color(0xFF3D4A60);
      case PresenceStatus.sleeping:   return const Color(0xFF2C3E50);
      case PresenceStatus.onTheWay:   return const Color(0xFF52BE80);
    }
  }
}
