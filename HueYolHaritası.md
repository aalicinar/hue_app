# HUE — Flutter Mockup Geliştirme Yol Haritası
**Versiyon:** 2.0 — Mockup Önce  
**Strateji:** Önce statik yüksek sadakatli mockup → tasarım sabitlenir → component'lere hayat verilir → backend  
**Hedef:** Presence → Intent → Conversation felsefesini Flutter'da doğru şekilde yaşatan, TestFlight'a yüklenebilir bir mockup.

> Bu belge orijinal Hue spec'iyle tam uyumludur. Önceki yol haritasındaki ürün felsefesi hataları düzeltilmiştir.

---

## İçindekiler

1. [Mockup Stratejisi](#1-mockup-stratejisi)
2. [Düzeltilen Kavramlar](#2-düzeltilen-kavramlar)
3. [Teknik Kurulum](#3-teknik-kurulum)
4. [Proje Yapısı](#4-proje-yapısı)
5. [Veri Modeli](#5-veri-modeli)
6. [Mock Seed Verisi](#6-mock-seed-verisi)
7. [Tema & Tasarım Tokenleri](#7-tema--tasarım-tokenleri)
8. [Ekranlar — Detaylı Spesifikasyon](#8-ekranlar--detaylı-spesifikasyon)
9. [Navigasyon](#9-navigasyon)
10. [Animasyon Sistemi](#10-animasyon-sistemi)
11. [Adım Adım Geliştirme Planı](#11-adım-adım-geliştirme-planı)
12. [Kabul Testi Checklist](#12-kabul-testi-checklist)
13. [Sonraki Faz (Backend)](#13-sonraki-faz-backend)

---

## 1. Mockup Stratejisi

### 1.1 Faz Tanımı

```
FAZ 0: Statik Mockup (Bu belge)
  → Tüm ekranlar Flutter'da render ediliyor
  → Tüm geçişler ve animasyonlar çalışıyor
  → Veri: sabit mock seed (Hive yok, sadece in-memory)
  → Hiçbir iş mantığı yok (sort, filter, rate limit yok)
  → Hedef: "Bu hissediyor mu?" sorusunu yanıtlamak

FAZ 1: Canlı Mockup (Sonraki belge)
  → Hive ile local persistence
  → İş mantığı (sıralama, ack, undo)
  → TestFlight build

FAZ 2: Backend (Ayrı belge)
  → Firebase / Supabase entegrasyonu
  → Gerçek kullanıcılar
```

### 1.2 Mockup'un Tek Amacı

> "Presence → Intent → Conversation akışının doğru hissettirip hissettirmediğini 5 dakikada test etmek."

Mockup tamamlanmış sayılır:
- Kullanıcı klavyeye basmadan ilk hue'yu gönderebiliyorsa ✓
- Presence Board chat listesi gibi görünmüyorsa ✓
- Conversation açmak kasıtlı bir eylem gerektiriyorsa ✓

---

## 2. Düzeltilen Kavramlar

Önceki yol haritasından **silinen veya değiştirilen** kavramlar:

### 2.1 Yanlış → Doğru

| Önceki (YANLIŞ) | Yeni (DOĞRU) | Neden |
|---|---|---|
| "Hue Box" (gelen kutusu) | **Presence Board** (kişi paneli) | Inbox mesaj odaklıdır, spec insan odaklı ister |
| 4 sabit renk (Kırmızı=Acil) | **Duygusal preset'ler** (Sıcak, Meşgul, Derin...) | Hue önceliklendirme değil, durum bildirme aracıdır |
| `lastMessagePreview` alanı | **`lastIntentPreview`** (renk swatchi, metin yok) | Spec metin preview'u açıkça yasaklar |
| `unreadCount` (kırmızı badge) | **Yok** | Spec kırmızı badge'i açıkça yasaklar |
| Her zaman görünür composer | **Gizli composer** (modal ile açılır) | Spec: keyboard default görünmez |
| 3 sekme (Hue Box / Chats / Settings) | **Tek ana ekran** (Presence Board) | Conversation sekme değil, kasıtlı eskalasyondur |
| Çince karakter `核心` | **"Temel"** | Hata düzeltildi |
| `C:\Users\Mevlüt Cıhat\Desktop\HueLogo1.png` | **`assets/images/logo.png`** | Proje-relative path |
| Light mode ağırlıklı renk şeması | **Dark-first** (#0F1724 base) | Spec dark background tanımlar |
| Onboarding yok | **3 aşamalı interaktif onboarding** | Spec'in kritik parçası |

### 2.2 Eklenen Kavramlar

- **Presence katmanı** (aura rengi, durum, ambient awareness)
- **Onboarding C** (interaktif demo — "Başla" kilitli)
- **Undo (3s toast)** — intent/hue gönderimi için
- **Acknowledge felsefesi** — "Anladım" vs "Okudum" ayrımı
- **Photo + Hue zorunlu birlikteliği**
- **Contact Profile Modal**

---

## 3. Teknik Kurulum

### 3.1 Teknoloji Yığını

```yaml
Flutter:          3.x (Dart)
State Management: Riverpod 2.x (flutter_riverpod)
Navigation:       go_router
UI Approach:      Custom dark theme (iOS-adaptive widgets seçici kullanım)
Storage (Faz 0):  Sadece in-memory (MockRepository)
Storage (Faz 1):  Hive
Backend (Faz 2):  Firebase / Supabase
```

### 3.2 pubspec.yaml

```yaml
name: hue
description: Presence-based communication layer.

environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0
  go_router: ^12.0.0
  google_fonts: ^6.1.0         # Tipografi için
  flutter_animate: ^4.3.0      # Animasyonlar için
  gap: ^3.0.1                  # Spacing kolaylığı

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  flutter_launcher_icons: ^0.13.1

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/

flutter_launcher_icons:
  ios: true
  android: false
  image_path: "assets/images/logo.png"
  remove_alpha_ios: true
```

### 3.3 Klasör Yapısı

```
lib/
├── main.dart
├── app/
│   ├── app.dart                    # MaterialApp + GoRouter setup
│   ├── router.dart                 # Tüm route tanımları
│   └── theme/
│       ├── app_theme.dart          # ThemeData
│       ├── tokens.dart             # Renkler, spacing, radius
│       └── text_styles.dart        # Tipografi
├── core/
│   ├── mock/
│   │   ├── mock_seed.dart          # Statik test verisi
│   │   └── mock_repository.dart    # In-memory repo
│   └── utils/
│       └── time_formatter.dart
├── domain/
│   └── models/
│       ├── user.dart
│       ├── contact.dart
│       ├── intent.dart
│       ├── presence.dart
│       ├── conversation.dart
│       └── message.dart
├── features/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── onboarding/
│   │   ├── onboarding_screen.dart
│   │   ├── onboarding_a_screen.dart   # Problem
│   │   ├── onboarding_b_screen.dart   # Keşif
│   │   └── onboarding_c_screen.dart   # İnteraktif demo
│   ├── home/
│   │   ├── presence_board_screen.dart
│   │   ├── widgets/
│   │   │   ├── contact_row.dart
│   │   │   ├── presence_indicator.dart
│   │   │   └── intent_swatch.dart
│   │   └── home_providers.dart
│   ├── intent/
│   │   ├── intent_panel.dart          # Bottom sheet
│   │   ├── widgets/
│   │   │   ├── hue_orb.dart
│   │   │   ├── hue_preset_button.dart
│   │   │   └── photo_hue_preview.dart
│   │   └── intent_providers.dart
│   ├── conversation/
│   │   ├── conversation_screen.dart
│   │   ├── widgets/
│   │   │   ├── hue_bubble.dart
│   │   │   ├── text_bubble.dart
│   │   │   └── composer_modal.dart
│   │   └── conversation_providers.dart
│   ├── contact_profile/
│   │   └── contact_profile_modal.dart
│   └── settings/
│       └── settings_screen.dart
└── shared/
    └── widgets/
        ├── undo_toast.dart
        ├── hue_bottom_sheet.dart
        └── permission_modal.dart

assets/
├── images/
│   └── logo.png
└── icons/
    └── (SVG ikonlar)
```

---

## 4. Proje Yapısı

### 4.1 Mimari Katmanlar

```
┌──────────────────────────────────────┐
│          UI Layer (Features)         │
│   Splash / Onboarding / Home /       │
│   Intent / Conversation / Settings  │
└──────────────────────────────────────┘
              ↕ Riverpod Providers
┌──────────────────────────────────────┐
│        State / Controllers           │
│   PresenceBoardNotifier              │
│   IntentPanelNotifier                │
│   ConversationNotifier               │
└──────────────────────────────────────┘
              ↕ Repository Interface
┌──────────────────────────────────────┐
│          Data Layer                  │
│   Faz 0: MockRepository (in-memory) │
│   Faz 1: HiveRepository             │
│   Faz 2: FirebaseRepository         │
└──────────────────────────────────────┘
```

### 4.2 Repository Interface

```dart
// lib/core/repository_interface.dart
abstract class HueRepository {
  // Contacts & Presence
  List<Contact> getContacts();
  void updatePresence(String userId, PresenceStatus status);

  // Intents
  void sendIntent(Intent intent);
  List<Intent> getIntentsForContact(String contactId);
  void acknowledgeIntent(String intentId);
  void undoIntent(String intentId);

  // Conversation
  List<Message> getMessages(String conversationId);
  void sendMessage(Message message);
}
```

---

## 5. Veri Modeli

### 5.1 PresenceStatus

```dart
// lib/domain/models/presence.dart
enum PresenceStatus {
  available,   // Müsait
  busy,        // Meşgul
  listening,   // Dinleme modu
  deepTalk,    // Derin sohbet
  away,        // Uzakta
  sleeping,    // Uyuyor
  onTheWay,    // Yolda
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

  // Aura rengi — gradient başlangıç rengi
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
}
```

### 5.2 HuePreset

```dart
// lib/domain/models/intent.dart

/// HuePreset: Sabit renk kategorisi değil, duygusal/durumsal sinyal.
/// Kırmızı=Acil gibi öncelik sistemi YOK.
enum HuePreset {
  warm,       // Sıcak — genel müsaitlik
  busy,       // Meşgul — şu an uygun değil
  listening,  // Dinle — sakin mod
  onTheWay,   // Geliyor — yolda
  deep,       // Derin — ciddi konu
  custom,     // Özel — slider ile
}

extension HuePresetExt on HuePreset {
  String get label {
    switch (this) {
      case HuePreset.warm:      return 'Sıcak';
      case HuePreset.busy:      return 'Meşgul';
      case HuePreset.listening: return 'Dinle';
      case HuePreset.onTheWay:  return 'Geliyor';
      case HuePreset.deep:      return 'Derin';
      case HuePreset.custom:    return 'Özel';
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
}
```

### 5.3 Contact

```dart
// lib/domain/models/contact.dart
class Contact {
  final String id;
  final String name;
  final String? avatarUrl;
  final PresenceStatus presenceStatus;
  final Intent? lastIntent;     // Son gönderilen/alınan intent
  final DateTime? lastActiveAt; // Relative zaman için ("2sa önce")

  const Contact({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.presenceStatus,
    this.lastIntent,
    this.lastActiveAt,
  });
}
```

> ⚠️ `lastMessagePreview` (String) **YOK**.  
> Son intent yalnızca renk swatchi olarak gösterilir, metin preview hiçbir zaman gösterilmez.

### 5.4 Intent

```dart
// lib/domain/models/intent.dart
class Intent {
  final String id;
  final String senderId;
  final String recipientId;
  final HuePreset preset;
  final double intensity;       // 0.0 – 1.0
  final String? photoUrl;       // Foto varsa — her zaman preset ile birlikte
  final DateTime createdAt;
  final DateTime? acknowledgedAt; // null = henüz onaylanmadı
  final DateTime? undoneAt;       // null = geri alınmadı

  const Intent({
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
```

### 5.5 Message (Conversation için — ikincil)

```dart
// lib/domain/models/message.dart
enum MessageKind { hue, text }

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final MessageKind kind;

  // Hue mesaj için — her zaman Intent'e referans
  final Intent? hueIntent;

  // Text mesaj için — görsel olarak ikincil
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
```

---

## 6. Mock Seed Verisi

```dart
// lib/core/mock/mock_seed.dart

import 'package:flutter/material.dart';
import '../../domain/models/models.dart';

class MockSeed {
  static const String currentUserId = 'me';

  static final List<Contact> contacts = [
    Contact(
      id: 'user1',
      name: 'Ayşe',
      presenceStatus: PresenceStatus.available,
      lastIntent: Intent(
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
      lastIntent: Intent(
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
      lastIntent: Intent(
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
  ];

  // Conversation için örnek mesajlar (user1 = Ayşe)
  static final List<Message> messagesWithUser1 = [
    Message(
      id: 'm1',
      conversationId: 'conv_user1',
      senderId: 'user1',
      kind: MessageKind.hue,
      hueIntent: Intent(
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
      hueIntent: Intent(
        id: 'ci2',
        senderId: 'user1',
        recipientId: currentUserId,
        preset: HuePreset.deep,
        intensity: 0.7,
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
  ];

  static final Contact currentUser = Contact(
    id: currentUserId,
    name: 'Ben',
    presenceStatus: PresenceStatus.available,
  );
}
```

---

## 7. Tema & Tasarım Tokenleri

### 7.1 Renk Tokenleri

```dart
// lib/app/theme/tokens.dart

class HueColors {
  // Arkaplanlar
  static const bgPrimary   = Color(0xFF0F1724);
  static const bgSecondary = Color(0xFF141D2B);
  static const bgCard      = Color(0xFF1A2234);

  // Metin
  static const textPrimary   = Color(0xFFE8ECF4);
  static const textSecondary = Color(0xFF7A8399);
  static const textDisabled  = Color(0xFF3D4A60);

  // Border
  static const borderSubtle = Color(0xFF1F2D42);

  // Durum — Hue preset renkleriyle ayrı tutulur
  static const success = Color(0xFF1E8449);
  static const error   = Color(0xFFC0392B);
  static const info    = Color(0xFF2471A3);
}

class HueSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
}

class HueRadius {
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 20.0;
  static const double xl   = 28.0;
  static const double pill = 999.0;
}

class HueSizes {
  static const double avatarLg    = 80.0;
  static const double avatarMd    = 56.0;
  static const double avatarSm    = 32.0;
  static const double huePrimary  = 72.0;   // Ana send butonu
  static const double huePreset   = 48.0;   // Preset butonları
  static const double touchMin    = 44.0;
  static const double presenceDot = 8.0;
  static const double swatchW     = 30.0;
  static const double swatchH     = 12.0;
}
```

### 7.2 Tipografi

```dart
// lib/app/theme/text_styles.dart
import 'package:google_fonts/google_fonts.dart';

class HueTextStyles {
  static TextStyle get title => GoogleFonts.dmSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: HueColors.textPrimary,
    height: 1.2,
  );

  static TextStyle get subtitle => GoogleFonts.dmSans(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: HueColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get label => GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: HueColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get body => GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: HueColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get meta => GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: HueColors.textSecondary,
    height: 1.4,
  );

  static TextStyle get caption => GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: HueColors.textSecondary,
    height: 1.3,
  );
}
```

### 7.3 ThemeData

```dart
// lib/app/theme/app_theme.dart
ThemeData buildHueTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: HueColors.bgPrimary,
    colorScheme: const ColorScheme.dark(
      background: HueColors.bgPrimary,
      surface: HueColors.bgCard,
      onBackground: HueColors.textPrimary,
      onSurface: HueColors.textPrimary,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    dividerColor: HueColors.borderSubtle,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
```

---

## 8. Ekranlar — Detaylı Spesifikasyon

### 8.1 Splash Screen

```dart
// lib/features/splash/splash_screen.dart

class SplashScreen extends StatefulWidget { ... }

// Davranış:
// - Logo + tagline render
// - 1600ms sonra Navigator: ilk açılış → Onboarding, dönüş → PresenceBoard

// Widget yapısı:
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Logo: assets/images/logo.png
    Image.asset('assets/images/logo.png', width: 80, height: 80),
    Gap(HueSpacing.md),
    // Tagline
    Text('Mesaj değil, niyet gönder.', style: HueTextStyles.meta),
  ],
)

// Animasyon:
// logo: .animate().fadeIn(duration: 600.ms).scaleXY(begin: 0.92, end: 1.0)
// tagline: .animate(delay: 400.ms).fadeIn(duration: 400.ms)
```

**Kabul Kriterleri:**
- [ ] Hiçbir buton yok
- [ ] Auto geçiş 1200–1800ms
- [ ] Network çağrısı yok

---

### 8.2 Onboarding A — Problem Ekranı

```dart
// lib/features/onboarding/onboarding_a_screen.dart

// Layout (Column):
//   SizedBox(height: screenHeight * 0.35)
//   TypingLoopAnimation() ← özel widget
//   Gap(HueSpacing.xl)
//   Text("Bazen yazmak fazla gelir.")
//   Gap(HueSpacing.lg)
//   HuePrimaryButton(label: "Devam", onTap: goToB)

// TypingLoopAnimation:
// Animasyon: 3 mesaj → yazar → siler → tekrar yazar
// Mesajlar: ["Tamam", "Peki", "Görüyorum"]
// Her döngü: 800ms easeInOut
// flutter_animate ile: .shimmer() + custom typewriter effect
```

---

### 8.3 Onboarding B — Keşif Ekranı

```dart
// lib/features/onboarding/onboarding_b_screen.dart

// Layout:
//   Scaffold center:
//     BreathingOrb() ← canlı gradient orb
//     Gap(HueSpacing.xl)
//     Text("Bir renk seç. Yeter.")
//     Gap(HueSpacing.lg)
//     HuePrimaryButton(label: "Devam", onTap: goToC)

// BreathingOrb:
// - 96px diameter
// - Gradient: HuePreset.warm.gradient (random preset her açılışta)
// - scale 0.96 → 1.04 → 0.96, 1200ms, easeInOutSine, infinite
// - glow: BoxShadow opacity 0.4 → 0.8 → 0.4, sync
```

---

### 8.4 Onboarding C — İnteraktif Demo (Kritik)

```dart
// lib/features/onboarding/onboarding_c_screen.dart
//
// STATE:
// - demoCompleted: bool (başlangıç: false)
// - selectedPreset: HuePreset?
// - intentSent: bool
// - ackReceived: bool
//
// LAYOUT:
// Column(
//   MockPersonRow(name: "Ayşe", presence: available), // sahte kişi
//   Gap(HueSpacing.xl),
//   if (!intentSent) MockPresetRow(onSelect: setPreset),
//   if (selectedPreset != null && !intentSent) SendHueButton(onTap: sendMockIntent),
//   if (intentSent && !ackReceived) SentAnimation(),
//   if (ackReceived) MockAckIndicator(),  // "Ayşe gördü" soft animasyon
//   Gap(HueSpacing.xxl),
//   HuePrimaryButton(
//     label: "Başla",
//     enabled: demoCompleted,  // ← KILITLI
//     onTap: demoCompleted ? goToHome : null,
//   ),
// )
//
// AKIŞ:
// 1. Kullanıcı preset seçer → selectedPreset set
// 2. "Gönder" tap → intentSent = true → send animasyonu
// 3. 800ms sonra → ackReceived = true → mock ack gösterilir
// 4. 400ms sonra → demoCompleted = true → "Başla" aktif
//
// "Başla" disabled iken:
//   opacity: 0.4
//   tooltip/subtitle: "Önce bir hue gönder"
```

---

### 8.5 Presence Board (Ana Ekran)

```dart
// lib/features/home/presence_board_screen.dart
//
// Bu ekran CHAT LİSTESİ DEĞİLDİR.
// Mental model: "People Panel"
//
// SCAFFOLD:
// appBar: _buildTopBar()
// body: Column(
//   _buildSearchBar(),   // collapsed by default
//   Expanded(child: _buildContactList()),
// )
//
// TOP BAR:
// Row(
//   IconButton(menu/settings),
//   Spacer(),
//   HueLogo (small, center),
//   Spacer(),
//   IconButton(search),
// )
//
// CONTACT LIST:
// ListView.builder(
//   itemCount: contacts.length,
//   itemBuilder: (_, i) => ContactRow(contact: contacts[i]),
// )
//
// ContactRow TAP → IntentPanel bottom sheet açılır
// Avatar TAP → ContactProfileModal açılır
// Row LONG PRESS → QuickActionsSheet açılır
```

#### 8.5.1 ContactRow Widget

```dart
// lib/features/home/widgets/contact_row.dart
//
// HEIGHT: 78pt
//
// Row(
//   [Avatar 56px + PresenceAura]  ← sol
//   [Column:                      ← orta, expanded
//     [İsim label]
//     [Presence label + dot]
//   ]
//   [Column:                      ← sağ
//     [Son intent swatch 30x12px]
//     [Zaman meta "3sa"]
//   ]
// )
//
// ⚠️ YOKTUR:
//   - lastMessagePreview (String)
//   - unreadCount / badge
//   - "Son görülme" metni
//
// Son intent: yalnızca renk swatchi gösterilir
// Swatch: Container(
//   width: HueSizes.swatchW,
//   height: HueSizes.swatchH,
//   decoration: BoxDecoration(
//     gradient: LinearGradient(colors: contact.lastIntent!.preset.gradient),
//     borderRadius: BorderRadius.circular(4),
//   ),
// )
```

#### 8.5.2 PresenceIndicator Widget

```dart
// lib/features/home/widgets/presence_indicator.dart
//
// Stack(
//   CircleAvatar(radius: 28, ...)  ← avatar
//   Positioned(
//     bottom: 2, right: 2,
//     child: Container(
//       width: 8, height: 8,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: contact.presenceStatus.auraColor,
//         border: Border.all(color: HueColors.bgCard, width: 1.5),
//       ),
//     ),
//   ),
// )
//
// Aura (soft glow, arka katman):
// Container(
//   width: 64, height: 64,
//   decoration: BoxDecoration(
//     shape: BoxShape.circle,
//     boxShadow: [BoxShadow(
//       color: contact.presenceStatus.auraColor.withOpacity(0.35),
//       blurRadius: 16,
//       spreadRadius: 2,
//     )],
//   ),
// )
```

---

### 8.6 Intent Panel (Bottom Sheet)

```dart
// lib/features/intent/intent_panel.dart
//
// showModalBottomSheet(
//   context: context,
//   isScrollControlled: true,
//   backgroundColor: Colors.transparent,
//   builder: (_) => IntentPanel(contact: contact),
// )
//
// SHEET YÜKSEKLİĞİ: screenHeight * 0.52 (adaptive)
// BG: HueColors.bgSecondary, borderRadius üst 28pt
//
// LAYOUT:
// Column(
//   _buildHandle(),         // drag handle (4x32 kapsül)
//   _buildHeader(),         // avatar + isim + "Sohbet aç" butonu
//   _buildOrbPreview(),     // canlı renk orb (96px)
//   _buildPresetsRow(),     // 5 preset butonu
//   _buildBottomBar(),      // foto ikonu + send butonu
// )
//
// STATE:
// - selectedPreset: HuePreset?
// - intensity: double (0.0-1.0, default 0.8)
// - selectedPhoto: File?
//
// SEND BUTONU:
// enabled = selectedPreset != null
//   (foto varsa: selectedPhoto != null && selectedPreset != null)
//
// HEADER "Sohbet aç":
// TextButton → Navigator.push(ConversationScreen)
// Görsel: secondary (outline, düşük prominence)
```

#### 8.6.1 HueOrb Widget

```dart
// lib/features/intent/widgets/hue_orb.dart
//
// AnimatedContainer(
//   duration: 100ms,
//   width: 96, height: 96,
//   decoration: BoxDecoration(
//     shape: BoxShape.circle,
//     gradient: RadialGradient(
//       colors: selectedPreset?.gradient ?? [greyStart, greyEnd],
//     ),
//     boxShadow: [BoxShadow(
//       color: selectedPreset?.gradient.first.withOpacity(0.5) ?? transparent,
//       blurRadius: 24,
//       spreadRadius: 4,
//     )],
//   ),
// )
// Preset değişince: gradient 100ms'de crossfade eder.
```

#### 8.6.2 HuePresetButton Widget

```dart
// lib/features/intent/widgets/hue_preset_button.dart
//
// Column(
//   Container(
//     width: 48, height: 48,
//     decoration: BoxDecoration(
//       shape: BoxShape.circle,
//       gradient: LinearGradient(colors: preset.gradient),
//       border: isSelected
//         ? Border.all(color: Colors.white, width: 2)
//         : null,
//     ),
//   ),
//   Gap(4),
//   Text(preset.label, style: HueTextStyles.caption),
// )
//
// onTap: setState → selectedPreset = preset
// Semantics label: "${preset.label} tonu seç"
```

#### 8.6.3 Send Animasyonu (Mockup için basit)

```dart
// Tap Send:
// 1. Orb: scale 1.0 → 0.0 + opacity 1 → 0 (200ms)
// 2. Sheet dismiss (150ms)
// 3. UndoToast.show(context, "Gönderildi — geri al")
//
// flutter_animate ile:
// _orbKey.currentState?.animate()
//   .scale(end: 0.0, duration: 200.ms)
//   .fadeOut(duration: 200.ms)
//   .then(delay: 50.ms)
//   .callback(value: 1.0, callback: (_) => Navigator.pop(context));
```

---

### 8.7 Conversation Screen

```dart
// lib/features/conversation/conversation_screen.dart
//
// GİRİŞ: Yalnızca IntentPanel'deki "Sohbet aç" butonu ile açılır.
// Otomatik açılma YOKTUR.
//
// SCAFFOLD:
// appBar: _buildConversationAppBar()
//   sol: ← geri (PresenceBoard'a döner)
//   orta: isim + intent label
//   sağ: "Varlık'a dön" TextButton
//
// body: Column(
//   Expanded(child: _buildMessageList()),
//   _buildConversationBottomBar(),   // sadece "Yazı yaz" ve hue shortcut
// )
//
// BOTTOM BAR (default state):
// Row(
//   HueShortcutButton(onTap: openIntentPanel),  ← sol, küçük orb
//   Expanded(
//     GestureDetector(
//       onTap: () => _showComposerModal(context),
//       child: Container(
//         // "Yazı yaz..." placeholder, tıklanınca modal açar
//         // KLAVYEYİ DOĞRUDAN AÇMAZ
//       ),
//     ),
//   ),
// )
//
// COMPOSER MODAL (showModalBottomSheet):
// Column(
//   CupertinoTextField(
//     maxLength: 280,
//     autofocus: true,  // modal açılınca klavye çıkar
//   ),
//   SendButton,
// )
// Modal kapanınca klavye de kapanır.
```

#### 8.7.1 HueBubble Widget

```dart
// lib/features/conversation/widgets/hue_bubble.dart
//
// Hue mesajları görsel olarak PRIMARY
//
// Align(
//   alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
//   child: Container(
//     width: 80, height: 80,
//     decoration: BoxDecoration(
//       shape: BoxShape.circle,
//       gradient: RadialGradient(
//         colors: message.hueIntent!.preset.gradient,
//       ),
//       boxShadow: [BoxShadow(
//         color: firstColor.withOpacity(0.4),
//         blurRadius: 16,
//       )],
//     ),
//     child: isMine ? null : _buildAckButton(),
//   ),
// )
//
// Ack butonu (yalnızca alıcıda, onaylanmamışsa):
// Center(child: Text("Gördüm", style: white small))
//
// Onaylandıysa: soft checkmark overlay, düşük opaklık
```

#### 8.7.2 TextBubble Widget

```dart
// lib/features/conversation/widgets/text_bubble.dart
//
// Metin mesajları görsel olarak SECONDARY
//
// Align(
//   alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
//   child: Container(
//     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//     decoration: BoxDecoration(
//       // HueBubble'a göre çok daha düşük kontrast
//       color: Color(0xFF1F2A36),  // dark, nötr
//       borderRadius: BorderRadius.circular(HueRadius.md),
//     ),
//     child: Text(
//       message.text!,
//       style: HueTextStyles.body.copyWith(
//         // Hue mesajlarından daha düşük görsel ağırlık
//         color: HueColors.textSecondary,
//       ),
//     ),
//   ),
// )
//
// ⚠️ HueBubble'dan DAHA KÜÇÜK ve DAHA SOLU olmalıdır.
// Max width: screenWidth * 0.65 (HueBubble'ın max width'inden az)
```

---

### 8.8 Contact Profile Modal

```dart
// lib/features/contact_profile/contact_profile_modal.dart
//
// showModalBottomSheet ile açılır (Avatar tap'te)
//
// Column(
//   [Avatar 80px + büyük presence aura],
//   [İsim title],
//   [Presence label],
//   [Relative zaman: "2 saat önce hue attı"],
//   Gap(HueSpacing.lg),
//   [Son intentler — horizontal scroll, son 5 swatch],
//   Gap(HueSpacing.xl),
//   [Intent Gönder — primary button],
//   [Sohbet Aç — secondary button],
//   [Sessize Al — tertiary text button],
// )
//
// ⚠️ "Şu an yazıyor" → YOKTUR
// ⚠️ Real-time tracking → YOKTUR
// Relative zaman: "X saat önce aktifti" (lastActiveAt'tan hesaplanır)
```

---

### 8.9 Settings Screen

```dart
// lib/features/settings/settings_screen.dart
//
// Cupertino-style grouped list
//
// Bölümler:
// 1. Hesap: Display name, Avatar, Hesabı sil, Çıkış yap
// 2. Bildirimler: Push on/off, Preview stili
// 3. Fotoğraflar: Cihaza kaydet, EXIF konum (default off)
// 4. Davranış: Conversation'da composer varsayılan (default off)
// 5. Hakkında: Gizlilik, İletişim, Sürüm
// 6. Analytics: Anonim veri paylaş (default on)
//
// Header'dan açılır (hamburger veya top-left icon)
// AYRI SEKME DEĞİLDİR.
```

---

### 8.10 UndoToast Widget

```dart
// lib/shared/widgets/undo_toast.dart
//
// static void show(BuildContext context, {
//   required String message,
//   required VoidCallback onUndo,
// })
//
// OverlayEntry ile render — ekran altında floating
// 3 saniye görünür, tap'te onUndo() çağrılır
//
// Container(
//   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//   decoration: BoxDecoration(
//     color: HueColors.bgCard,
//     borderRadius: BorderRadius.circular(HueRadius.pill),
//     boxShadow: [...],
//   ),
//   child: Row(
//     [Text("Gönderildi")],
//     [TextButton("geri al", onTap: onUndo)],
//   ),
// )
//
// Animasyon: .animate().slideY(begin: 1.0, end: 0.0, duration: 200.ms)
// Auto hide: Future.delayed(3s) → .animate().fadeOut(200.ms) → remove overlay
```

---

## 9. Navigasyon

### 9.1 GoRouter Yapısı

```dart
// lib/app/router.dart

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash',       builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding',   builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/home',         builder: (_, __) => const PresenceBoardScreen()),
    GoRoute(
      path: '/conversation/:contactId',
      builder: (context, state) => ConversationScreen(
        contactId: state.pathParameters['contactId']!,
      ),
    ),
    GoRoute(path: '/settings',     builder: (_, __) => const SettingsScreen()),
  ],
);
```

### 9.2 Geçiş Kuralları

| Nereden | Nereye | Nasıl |
|---|---|---|
| Splash | Onboarding | fade push |
| Splash | Home | fade push |
| Onboarding A | Onboarding B | slide push |
| Onboarding B | Onboarding C | slide push |
| Onboarding C | Home | fade (onboarding sona erer) |
| Home | Intent Panel | bottom sheet modal |
| Home | Contact Profile | bottom sheet modal |
| Intent Panel | Conversation | stack push |
| Home | Settings | stack push |
| Conversation | Home | stack pop |

---

## 10. Animasyon Sistemi

### 10.1 Süreler (Referans Tablosu)

```dart
class HueDurations {
  static const splash          = Duration(milliseconds: 1600);
  static const screenTransition= Duration(milliseconds: 300);
  static const sheetOpen       = Duration(milliseconds: 180);
  static const sheetDismiss    = Duration(milliseconds: 160);
  static const modalOpen       = Duration(milliseconds: 200);
  static const orbUpdate       = Duration(milliseconds: 100);  // preset seçimi
  static const sendOrb         = Duration(milliseconds: 200);
  static const presencePulse   = Duration(milliseconds: 2400);
  static const onboardingTyping= Duration(milliseconds: 800);
  static const ackDelay        = Duration(milliseconds: 800);   // mock ack
  static const undoToast       = Duration(seconds: 3);
  static const toastFade       = Duration(milliseconds: 200);
}
```

### 10.2 Easing Kuralları

```
Ekran geçişleri:  Curves.easeInOutCubic
Sheet/Modal:      Curves.easeInOutCubic
Orb nefesi:       Curves.easeInOutSine
Fade:             Curves.easeOut
Spring (bubble):  SpringDescription(stiffness: 280, damping: 22)

YASAK: Curves.bounceIn, elasticOut, overshoot eğrileri
```

### 10.3 Presence Aura Animasyonu

```dart
// PresenceIndicator içinde:
// flutter_animate ile:
.animate(onPlay: (c) => c.repeat(reverse: true))
  .scaleXY(begin: 1.0, end: 1.08, duration: HueDurations.presencePulse)
  .custom(
    duration: HueDurations.presencePulse,
    builder: (ctx, value, child) => DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          color: auraColor.withOpacity(0.3 + value * 0.3),
          blurRadius: 16,
        )],
      ),
      child: child,
    ),
  )
```

---

## 11. Adım Adım Geliştirme Planı

### Gün 1 — Temel Altyapı

```
[ ] Flutter projesi oluştur (flutter create hue)
[ ] pubspec.yaml bağımlılıkları ekle (flutter pub get)
[ ] Klasör yapısını oluştur
[ ] tokens.dart, text_styles.dart, app_theme.dart yaz
[ ] mock_seed.dart yaz (tüm model sınıfları dahil)
[ ] router.dart yaz
[ ] main.dart → ProviderScope + MaterialApp.router
[ ] SplashScreen render et (logo + tagline, animasyonsuz)
✓ Kontrol: Uygulama açılıyor, splash görünüyor
```

### Gün 2 — Onboarding

```
[ ] OnboardingAScreen (typing animasyonu, Devam butonu)
[ ] OnboardingBScreen (BreathingOrb, Devam butonu)
[ ] OnboardingCScreen (mock preset seçimi, send akışı, "Başla" kilidi)
[ ] Splash → Onboarding → Home geçişleri çalışıyor
✓ Kontrol: Kullanıcı klavyeye basmadan demo tamamlıyor
```

### Gün 3 — Presence Board

```
[ ] PresenceBoardScreen scaffold
[ ] TopBar (logo, hamburger, arama ikonu)
[ ] ContactRow widget (avatar, isim, presence dot, swatch)
[ ] PresenceIndicator widget (aura glow)
[ ] IntentSwatch widget (30x12 gradient)
[ ] Mock contacts listeleniyor
✓ Kontrol: Chat listesi gibi görünmüyor, metin preview yok
```

### Gün 4 — Intent Panel

```
[ ] IntentPanel bottom sheet (yükseklik %52)
[ ] Header (avatar + isim + "Sohbet aç")
[ ] HueOrb widget (canlı gradient, glow)
[ ] HuePresetButton widget (5 preset)
[ ] Send butonu (disabled logic)
[ ] Send animasyonu (orb fly out)
[ ] UndoToast widget
[ ] Foto ikonu (placeholder, gerçek kamera yok - Faz 1)
✓ Kontrol: 3 tap ile intent gönderilebiliyor, klavye yok
```

### Gün 5 — Conversation Screen

```
[ ] ConversationScreen scaffold
[ ] AppBar (isim, intent label, "Varlık'a dön")
[ ] HueBubble widget (gradient orb, glow, ack butonu)
[ ] TextBubble widget (düşük kontrast, ikincil görünüm)
[ ] Mesaj listesi (mock data)
[ ] ConversationBottomBar ("Yazı yaz" placeholder + hue shortcut)
[ ] ComposerModal (bottom sheet, 280 char, autofocus)
✓ Kontrol: Conversation açmak kasıtlı eylem gerektiriyor
✓ Kontrol: Hue bubble'lar metin bubble'lardan belirgin şekilde baskın
```

### Gün 6 — Modal'lar & Settings

```
[ ] ContactProfileModal (avatar, presence, son intents, aksiyonlar)
[ ] QuickActionsSheet (long press, sessiz/engelle/profil)
[ ] SettingsScreen (CupertinoListSection grupları)
[ ] Tüm navigasyon bağlantıları (router test)
✓ Kontrol: Her ekran geçişi düzgün çalışıyor
```

### Gün 7 — Polish & TestFlight

```
[ ] Animasyon kalibrasyonu (tüm süreler doğru)
[ ] Glow efektleri son ayar
[ ] Boş durum ekranları
[ ] Dark mode kontrol (zaten dark-first)
[ ] iOS cihazda fiziksel test
[ ] Xcode signing, bundle ID: com.yourname.hue
[ ] Archive → TestFlight upload
[ ] 3-5 kişiye dağıtım
✓ Kontrol: Tüm kabul kriterleri geçiyor
```

---

## 12. Kabul Testi Checklist

### Felsefe Kontrolleri (En Kritik)

- [ ] Presence Board açıldığında chat listesi gibi görünmüyor
- [ ] Hiçbir kartta metin preview yok (yalnızca renk swatchi)
- [ ] Kırmızı badge / unread counter yok
- [ ] "Son görülme" metni yok
- [ ] İlk açılışta klavye görünmüyor
- [ ] Conversation açmak her zaman kasıtlı eylem gerektiriyor
- [ ] Metin mesajları hue mesajlarından görsel olarak ikincil

### Akış Kontrolleri

- [ ] Splash → Onboarding (ilk açılış)
- [ ] Splash → Home (dönüş)
- [ ] Onboarding demo tamamlanmadan "Başla" aktif olmuyor
- [ ] Home: kart tap → Intent Panel 200ms içinde açılıyor
- [ ] Intent Panel: preset seçilmeden send disabled
- [ ] Send → orb animasyonu → sheet kapanıyor → toast görünüyor
- [ ] Toast 3s sonra kayboluyor
- [ ] "Sohbet aç" → Conversation screen açılıyor
- [ ] Conversation → geri → Presence Board

### Görsel Kontroller

- [ ] Tüm ekranlar dark background (#0F1724)
- [ ] Hue orb'lar glow efektiyle render ediliyor
- [ ] Presence aura'ları hareketli (pulse)
- [ ] Tüm animasyonlar 60fps smooth
- [ ] Küçük metinler okunaklı (WCAG AA kontrast)

### Edge Case'ler

- [ ] Son intent olmayan contact → swatch alanı boş, crash yok
- [ ] Uzun isim → overflow yok (ellipsis)
- [ ] Boş kişi listesi → placeholder gösteriliyor
- [ ] Modal dışarı tap ile kapanıyor

---

## 13. Sonraki Faz (Backend)

Mockup onaylandıktan sonra:

### Faz 1: Canlı Mockup (Hive)

```
- Hive ile local persistence
- Intent gönderme gerçekten kaydediliyor
- Presence durumu değiştirilebiliyor
- Ack/undo iş mantığı
- Rate limit kontrolü (göndericinin kendi limit yönetimi)
- TestFlight ile 3-5 kişi arasında tek cihazda test
```

### Faz 2: Backend (Firebase)

```
- FirebaseRepository (MockRepository ile aynı interface)
- Auth: Phone auth
- Realtime presence sync
- Push notifications (FCM)
- Server-side intent delivery
- 10-20 kişi arasında gerçek kullanım
```

### Repository Swap (Faz 0 → Faz 2)

```dart
// Yalnızca bu satır değişir:

// Faz 0:
final repoProvider = Provider((_) => MockRepository());

// Faz 1:
final repoProvider = Provider((_) => HiveRepository());

// Faz 2:
final repoProvider = Provider((_) => FirebaseRepository());

// Tüm UI ve iş mantığı aynı kalır.
```

---

## Kaynaklar

**Flutter:**
- https://flutter.dev/docs
- https://riverpod.dev
- https://pub.dev/packages/flutter_animate
- https://pub.dev/packages/go_router

**Tasarım:**
- iOS HIG: https://developer.apple.com/design/human-interface-guidelines/
- DM Sans font: https://fonts.google.com/specimen/DM+Sans
- App Icon: https://appicon.co veya `flutter_launcher_icons`

**Test:**
- TestFlight: https://testflight.apple.com

---

**Versiyon:** 2.0  
**Odak:** Mockup Faz — Presence → Intent → Conversation felsefesini doğru yaşat  
**Sonraki:** Mockup onaylandıktan sonra Faz 1 belgesi yazılır
