import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../app/app.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/text_styles.dart';
import '../../core/mock/mock_seed.dart';
import '../../domain/models/models.dart';
import '../../core/utils/time_formatter.dart';
import '../intent/intent_panel.dart';
import 'home_providers.dart';

class PresenceBoardScreen extends ConsumerStatefulWidget {
  const PresenceBoardScreen({super.key});

  @override
  ConsumerState<PresenceBoardScreen> createState() =>
      _PresenceBoardScreenState();
}

class _PresenceBoardScreenState extends ConsumerState<PresenceBoardScreen> {
  bool _searchOpen = false;
  String _searchQuery = '';
  late List<Contact> _contacts;

  @override
  void initState() {
    super.initState();
    _contacts = MockSeed.contacts;
  }

  List<Contact> get _filtered {
    if (_searchQuery.isEmpty) return _contacts;
    return _contacts
        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _openIntentPanel(BuildContext context, Contact contact) {
    final prefs = ref.read(userPrefsProvider);
    if (prefs.isMuted(contact.id)) {
      final info = prefs.getMuteInfo(contact.id)!;
      final c = context.hue;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${contact.name} susturuldu — ${info.remainingLabel} kaldı',
            style: HueTextStyles.meta.copyWith(color: Colors.white),
          ),
          backgroundColor: c.bgCard,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HueRadius.lg),
          ),
          margin: const EdgeInsets.all(HueSpacing.md),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IntentPanel(contact: contact),
    );
  }

  void _showLongPressMenu(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _LongPressMenu(
        contact: contact,
        onMute: (duration) {
          ref.read(userPrefsProvider.notifier).mute(contact.id, duration);
        },
        onUnmute: () {
          ref.read(userPrefsProvider.notifier).unmute(contact.id);
        },
        isMuted: ref.read(userPrefsProvider).isMuted(contact.id),
        onViewProfile: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (_) => _ContactProfileDialog(contact: contact),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(userPrefsProvider);
    final c = context.hue;

    return Scaffold(
      backgroundColor: c.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              searchOpen: _searchOpen,
              onSearchToggle: () => setState(() {
                _searchOpen = !_searchOpen;
                if (!_searchOpen) _searchQuery = '';
              }),
              onSearchChanged: (q) => setState(() => _searchQuery = q),
              onSettingsPressed: () => context.go('/settings'),
              onThemeToggle: () {
                final current = ref.read(themeModeProvider);
                ref.read(themeModeProvider.notifier).state =
                    current == ThemeMode.dark
                        ? ThemeMode.light
                        : ThemeMode.dark;
              },
              isDark: c.isDark,
            ),
            Expanded(
              child: _filtered.isEmpty
                  ? _EmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                          top: HueSpacing.sm, bottom: HueSpacing.lg),
                      itemCount: _filtered.length,
                      itemBuilder: (context, i) {
                        final contact = _filtered[i];
                        final muted = prefs.isMuted(contact.id);
                        final muteInfo = prefs.getMuteInfo(contact.id);
                        return GestureDetector(
                          onLongPress: () =>
                              _showLongPressMenu(context, contact),
                          child: ContactRow(
                            contact: contact,
                            isMuted: muted,
                            muteInfo: muteInfo,
                            onTap: () => _openIntentPanel(context, contact),
                            onAvatarTap: () => showDialog(
                              context: context,
                              builder: (_) =>
                                  _ContactProfileDialog(contact: contact),
                            ),
                          ),
                        )
                            .animate(delay: (i * 60).ms)
                            .fadeIn(duration: 300.ms)
                            .slideX(begin: 0.04, end: 0, duration: 300.ms);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// TOP BAR
// ──────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final bool searchOpen;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSettingsPressed;
  final VoidCallback onThemeToggle;
  final bool isDark;

  const _TopBar({
    required this.searchOpen,
    required this.onSearchToggle,
    required this.onSearchChanged,
    required this.onSettingsPressed,
    required this.onThemeToggle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: HueSpacing.md, vertical: HueSpacing.sm),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                color: c.textSecondary,
                onPressed: onSettingsPressed,
              ),
              const Spacer(),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFF8C42), Color(0xFF6C3483)],
                ).createShader(bounds),
                child: const Text(
                  'hue',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              // Theme toggle
              IconButton(
                icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                color: c.textSecondary,
                onPressed: onThemeToggle,
                tooltip: isDark ? 'Açık mod' : 'Koyu mod',
              ),
              IconButton(
                icon: Icon(searchOpen ? Icons.close : Icons.search),
                color: c.textSecondary,
                onPressed: onSearchToggle,
              ),
            ],
          ),
          if (searchOpen)
            Padding(
              padding: const EdgeInsets.only(
                left: HueSpacing.sm,
                right: HueSpacing.sm,
                bottom: HueSpacing.sm,
              ),
              child: TextField(
                autofocus: true,
                onChanged: onSearchChanged,
                style: HueTextStyles.body.copyWith(color: c.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Kişi ara',
                  hintStyle: HueTextStyles.meta.copyWith(color: c.textSecondary),
                  prefixIcon: Icon(Icons.search,
                      color: c.textSecondary, size: 20),
                  filled: true,
                  fillColor: c.bgCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(HueRadius.lg),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1, end: 0),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// CONTACT ROW
// ──────────────────────────────────────────────────────

class ContactRow extends StatelessWidget {
  final Contact contact;
  final bool isMuted;
  final MuteInfo? muteInfo;
  final VoidCallback onTap;
  final VoidCallback onAvatarTap;

  const ContactRow({
    super.key,
    required this.contact,
    required this.onTap,
    required this.onAvatarTap,
    this.isMuted = false,
    this.muteInfo,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: contact.lastMessage != null ? 88 : 78,
        margin: const EdgeInsets.symmetric(
          horizontal: HueSpacing.md,
          vertical: HueSpacing.xs,
        ),
        padding: const EdgeInsets.symmetric(horizontal: HueSpacing.md),
        decoration: BoxDecoration(
          color: isMuted ? c.bgSecondary : c.bgCard,
          borderRadius: BorderRadius.circular(HueRadius.lg),
          border: isMuted
              ? Border.all(color: c.borderSubtle, width: 1)
              : null,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onAvatarTap,
              child: _PresenceAvatar(contact: contact, muted: isMuted),
            ),
            const Gap(HueSpacing.sm),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        contact.name,
                        style: HueTextStyles.label.copyWith(
                          color: isMuted ? c.textSecondary : c.textPrimary,
                        ),
                      ),
                      if (isMuted && muteInfo != null) ...[
                        const Gap(HueSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: c.borderSubtle,
                            borderRadius: BorderRadius.circular(HueRadius.pill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.volume_off,
                                  size: 10, color: c.textSecondary),
                              const Gap(2),
                              Text(
                                muteInfo!.remainingLabel,
                                style: HueTextStyles.caption
                                    .copyWith(fontSize: 10, color: c.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Gap(2),
                  Row(
                    children: [
                      Container(
                        width: HueSizes.presenceDot,
                        height: HueSizes.presenceDot,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isMuted
                              ? c.textDisabled
                              : contact.presenceStatus.auraColor,
                        ),
                      ),
                      const Gap(HueSpacing.xs),
                      Text(
                        contact.presenceStatus.label,
                        style: HueTextStyles.caption.copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                  if (contact.lastMessage != null) ...[
                    const Gap(3),
                    _LastMessagePreview(
                      message: contact.lastMessage!,
                      isMuted: isMuted,
                    ),
                  ],
                ],
              ),
            ),
            if (contact.lastIntent != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _IntentSwatch(intent: contact.lastIntent!, muted: isMuted),
                  const Gap(HueSpacing.xs),
                  Text(
                    formatRelativeTime(contact.lastIntent!.createdAt),
                    style: HueTextStyles.caption.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _PresenceAvatar extends StatelessWidget {
  final Contact contact;
  final bool muted;
  const _PresenceAvatar({required this.contact, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    final auraColor =
        muted ? c.textDisabled : contact.presenceStatus.auraColor;
    final auraEnd =
        muted ? c.borderSubtle : contact.presenceStatus.auraColorEnd;
    return Container(
      width: HueSizes.avatarMd,
      height: HueSizes.avatarMd,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            auraColor.withValues(alpha: 0.3),
            auraEnd.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: auraColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          contact.name[0].toUpperCase(),
          style: HueTextStyles.subtitle.copyWith(color: auraColor),
        ),
      ),
    );
  }
}

class _IntentSwatch extends StatelessWidget {
  final HueIntent intent;
  final bool muted;
  const _IntentSwatch({required this.intent, this.muted = false});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: muted ? 0.3 : 1.0,
      child: Container(
        width: HueSizes.swatchW,
        height: HueSizes.swatchH,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            colors: intent.preset.gradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }
}


class _LastMessagePreview extends StatelessWidget {
  final Message message;
  final bool isMuted;
  const _LastMessagePreview({required this.message, this.isMuted = false});

  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    final isMe = message.senderId == MockSeed.currentUserId;

    if (message.kind == MessageKind.hue && message.hueIntent != null) {
      final preset = message.hueIntent!.preset;
      // Mini pill for hue messages
      return Row(
        children: [
          Text(
            isMe ? 'Sen: ' : '',
            style: HueTextStyles.caption.copyWith(
              color: c.textDisabled,
              fontSize: 10,
            ),
          ),
          Container(
            height: 16,
            padding: const EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: preset.gradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(HueRadius.pill),
            ),
            child: Center(
              child: Text(
                preset.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Text preview
      final prefix = isMe ? 'Sen: ' : '';
      final preview = '$prefix${message.text ?? ''}';
      return Text(
        preview,
        style: HueTextStyles.caption.copyWith(
          color: isMuted ? c.textDisabled : c.textSecondary,
          fontSize: 11,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌫️', style: TextStyle(fontSize: 48)),
          const Gap(HueSpacing.md),
          Text('Kimse bulunamadı', style: HueTextStyles.subtitle.copyWith(color: c.textPrimary)),
          Text('Aramayı değiştir', style: HueTextStyles.meta.copyWith(color: c.textSecondary)),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// LONG PRESS MENU (susturma)
// ──────────────────────────────────────────────────────

class _LongPressMenu extends StatelessWidget {
  final Contact contact;
  final bool isMuted;
  final void Function(Duration) onMute;
  final VoidCallback onUnmute;
  final VoidCallback onViewProfile;

  const _LongPressMenu({
    required this.contact,
    required this.isMuted,
    required this.onMute,
    required this.onUnmute,
    required this.onViewProfile,
  });

  static const _muteDurations = [
    (label: '15 dakika', duration: Duration(minutes: 15)),
    (label: '1 saat', duration: Duration(hours: 1)),
    (label: '3 saat', duration: Duration(hours: 3)),
    (label: '8 saat', duration: Duration(hours: 8)),
    (label: '24 saat', duration: Duration(hours: 24)),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    final maxH = MediaQuery.of(context).size.height * 0.55;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxH),
      child: Container(
      decoration: BoxDecoration(
        color: c.bgSecondary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(HueRadius.xl)),
      ),
      padding: const EdgeInsets.all(HueSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: c.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(HueSpacing.md),
          Text(contact.name, style: HueTextStyles.subtitle.copyWith(color: c.textPrimary)),
          const Gap(HueSpacing.lg),

          if (isMuted) ...[
            _MenuAction(
              icon: Icons.volume_up_outlined,
              label: 'Susturmayı Kaldır',
              color: const Color(0xFF1E8449),
              onTap: () {
                onUnmute();
                Navigator.pop(context);
              },
            ),
          ] else ...[
            Text(
              'SUS',
              style: HueTextStyles.caption.copyWith(
                letterSpacing: 1.0,
                color: c.textDisabled,
              ),
            ),
            const Gap(HueSpacing.sm),
            ..._muteDurations.map((item) => _MenuAction(
                  icon: Icons.volume_off_outlined,
                  label: item.label,
                  onTap: () {
                    onMute(item.duration);
                    Navigator.pop(context);
                  },
                )),
          ],
          Divider(color: c.borderSubtle, height: HueSpacing.lg),
          _MenuAction(
            icon: Icons.person_outline,
            label: 'Profili Gör',
            onTap: onViewProfile,
          ),
          const Gap(HueSpacing.md),
        ],
       ), // Column
      ),   // SingleChildScrollView
     ),    // Container
    );     // ConstrainedBox
  }
}

class _MenuAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(HueRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: HueSpacing.sm,
          horizontal: HueSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? c.textSecondary, size: 20),
            const Gap(HueSpacing.md),
            Text(
              label,
              style: HueTextStyles.body.copyWith(
                color: color ?? c.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// CONTACT PROFILE DIALOG
// ──────────────────────────────────────────────────────

class _ContactProfileDialog extends StatelessWidget {
  final Contact contact;
  const _ContactProfileDialog({required this.contact});

  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    return Dialog(
      backgroundColor: c.bgSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HueRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(HueSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: HueSizes.avatarLg,
              height: HueSizes.avatarLg,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    contact.presenceStatus.auraColor.withValues(alpha: 0.4),
                    contact.presenceStatus.auraColorEnd.withValues(alpha: 0.2),
                  ],
                ),
                border: Border.all(
                  color: contact.presenceStatus.auraColor.withValues(alpha: 0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: contact.presenceStatus.auraColor.withValues(alpha: 0.3),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  contact.name[0].toUpperCase(),
                  style: HueTextStyles.title.copyWith(fontSize: 32, color: c.textPrimary),
                ),
              ),
            ),
            const Gap(HueSpacing.md),
            Text(contact.name, style: HueTextStyles.title.copyWith(color: c.textPrimary)),
            const Gap(HueSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: contact.presenceStatus.auraColor,
                  ),
                ),
                const Gap(HueSpacing.xs),
                Text(contact.presenceStatus.label,
                    style: HueTextStyles.meta.copyWith(color: c.textSecondary)),
              ],
            ),
            const Gap(HueSpacing.lg),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Kapat', style: HueTextStyles.meta.copyWith(color: c.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
