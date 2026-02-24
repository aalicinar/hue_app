import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${contact.name} susturuldu — ${info.remainingLabel} kaldı',
            style: HueTextStyles.meta.copyWith(color: Colors.white),
          ),
          backgroundColor: HueColors.bgCard,
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

    return Scaffold(
      backgroundColor: HueColors.bgPrimary,
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

  const _TopBar({
    required this.searchOpen,
    required this.onSearchToggle,
    required this.onSearchChanged,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: HueSpacing.md, vertical: HueSpacing.sm),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                color: HueColors.textSecondary,
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
              IconButton(
                icon: Icon(searchOpen ? Icons.close : Icons.search),
                color: HueColors.textSecondary,
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
                style: HueTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Kişi ara',
                  hintStyle: HueTextStyles.meta,
                  prefixIcon: const Icon(Icons.search,
                      color: HueColors.textSecondary, size: 20),
                  filled: true,
                  fillColor: HueColors.bgCard,
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 78,
        margin: const EdgeInsets.symmetric(
          horizontal: HueSpacing.md,
          vertical: HueSpacing.xs,
        ),
        padding: const EdgeInsets.symmetric(horizontal: HueSpacing.md),
        decoration: BoxDecoration(
          color: isMuted ? HueColors.bgSecondary : HueColors.bgCard,
          borderRadius: BorderRadius.circular(HueRadius.lg),
          border: isMuted
              ? Border.all(color: HueColors.borderSubtle, width: 1)
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
                          color: isMuted
                              ? HueColors.textSecondary
                              : HueColors.textPrimary,
                        ),
                      ),
                      if (isMuted && muteInfo != null) ...[
                        const Gap(HueSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: HueColors.borderSubtle,
                            borderRadius: BorderRadius.circular(HueRadius.pill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.volume_off,
                                  size: 10, color: HueColors.textSecondary),
                              const Gap(2),
                              Text(
                                muteInfo!.remainingLabel,
                                style: HueTextStyles.caption
                                    .copyWith(fontSize: 10),
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
                              ? HueColors.textDisabled
                              : contact.presenceStatus.auraColor,
                        ),
                      ),
                      const Gap(HueSpacing.xs),
                      Text(
                        contact.presenceStatus.label,
                        style: HueTextStyles.caption,
                      ),
                    ],
                  ),
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
                    style: HueTextStyles.caption,
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
    final auraColor =
        muted ? HueColors.textDisabled : contact.presenceStatus.auraColor;
    final auraEnd =
        muted ? HueColors.borderSubtle : contact.presenceStatus.auraColorEnd;
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌫️', style: TextStyle(fontSize: 48)),
          const Gap(HueSpacing.md),
          Text('Kimse bulunamadı', style: HueTextStyles.subtitle),
          Text('Aramayı değiştir', style: HueTextStyles.meta),
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
    return Container(
      decoration: const BoxDecoration(
        color: HueColors.bgSecondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(HueRadius.xl)),
      ),
      padding: const EdgeInsets.all(HueSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: HueColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(HueSpacing.md),
          // Kişi adı
          Text(
            contact.name,
            style: HueTextStyles.subtitle,
          ),
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
                color: HueColors.textDisabled,
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
          const Divider(color: HueColors.borderSubtle, height: HueSpacing.lg),
          _MenuAction(
            icon: Icons.person_outline,
            label: 'Profili Gör',
            onTap: onViewProfile,
          ),
          const Gap(HueSpacing.md),
        ],
      ),
    );
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
            Icon(
              icon,
              color: color ?? HueColors.textSecondary,
              size: 20,
            ),
            const Gap(HueSpacing.md),
            Text(
              label,
              style: HueTextStyles.body.copyWith(
                color: color ?? HueColors.textPrimary,
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
    return Dialog(
      backgroundColor: HueColors.bgSecondary,
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
                  color:
                      contact.presenceStatus.auraColor.withValues(alpha: 0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        contact.presenceStatus.auraColor.withValues(alpha: 0.3),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  contact.name[0].toUpperCase(),
                  style: HueTextStyles.title.copyWith(fontSize: 32),
                ),
              ),
            ),
            const Gap(HueSpacing.md),
            Text(contact.name, style: HueTextStyles.title),
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
                Text(contact.presenceStatus.label, style: HueTextStyles.meta),
              ],
            ),
            const Gap(HueSpacing.lg),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Kapat', style: HueTextStyles.meta),
            ),
          ],
        ),
      ),
    );
  }
}
