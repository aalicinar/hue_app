import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/text_styles.dart';
import '../../domain/models/presence.dart';
import '../home/home_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  PresenceStatus _myPresence = PresenceStatus.available;
  bool _analyticsEnabled = true;

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (mounted) {
      ref.read(userPrefsProvider.notifier).setMyAvatar(bytes);
    }
  }

  void _editName(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: HueColors.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HueRadius.xl),
        ),
        title: Text('İsim Değiştir', style: HueTextStyles.subtitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 30,
          style: HueTextStyles.body,
          decoration: InputDecoration(
            hintText: 'Adın ne?',
            hintStyle: HueTextStyles.meta,
            counterStyle: HueTextStyles.caption,
            filled: true,
            fillColor: HueColors.bgCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HueRadius.md),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal', style: HueTextStyles.meta),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C42)),
            onPressed: () {
              ref.read(userPrefsProvider.notifier).setMyName(controller.text);
              Navigator.pop(context);
            },
            child: Text('Kaydet',
                style: HueTextStyles.caption.copyWith(color: Colors.white)),
          ),
        ],
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
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: HueSpacing.md,
                vertical: HueSpacing.sm,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    color: HueColors.textSecondary,
                    onPressed: () => context.go('/home'),
                  ),
                  Expanded(
                    child: Text(
                      'Ayarlar',
                      style: HueTextStyles.title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(HueSpacing.md),
                children: [
                  // ── Profil Kartı ────────────────────────────
                  _EditableProfileCard(
                    name: prefs.myName,
                    avatarBytes: prefs.myAvatarBytes,
                    presence: _myPresence,
                    onPhotoTap: _pickPhoto,
                    onNameTap: () => _editName(context, prefs.myName),
                  ).animate().fadeIn(duration: 300.ms),
                  const Gap(HueSpacing.lg),

                  // ── Presence ─────────────────────────────────
                  _SectionHeader('Presence Durumum'),
                  const Gap(HueSpacing.sm),
                  ...PresenceStatus.values.map((status) => _PresenceOption(
                        status: status,
                        isSelected: _myPresence == status,
                        onTap: () => setState(() => _myPresence = status),
                      )),
                  const Gap(HueSpacing.lg),

                  // ── Tercihler ────────────────────────────────
                  _SectionHeader('Tercihler'),
                  const Gap(HueSpacing.sm),
                  _ToggleRow(
                    label: 'Analytics',
                    subtitle: 'Kullanım verilerini paylaş',
                    value: _analyticsEnabled,
                    onChanged: (v) => setState(() => _analyticsEnabled = v),
                  ),
                  const Gap(HueSpacing.lg),

                  // ── Hakkında ─────────────────────────────────
                  _SectionHeader('Hakkında'),
                  const Gap(HueSpacing.sm),
                  _InfoRow(label: 'Versiyon', value: '0.1.0 (Mockup)'),
                  _InfoRow(label: 'Faz', value: 'FAZ 0 — Statik Mockup'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// EDITABLE PROFILE CARD
// ──────────────────────────────────────────────────────

class _EditableProfileCard extends StatelessWidget {
  final String name;
  final dynamic avatarBytes;
  final PresenceStatus presence;
  final VoidCallback onPhotoTap;
  final VoidCallback onNameTap;

  const _EditableProfileCard({
    required this.name,
    required this.avatarBytes,
    required this.presence,
    required this.onPhotoTap,
    required this.onNameTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HueSpacing.md),
      decoration: BoxDecoration(
        color: HueColors.bgCard,
        borderRadius: BorderRadius.circular(HueRadius.xl),
        border: Border.all(color: HueColors.borderSubtle),
      ),
      child: Column(
        children: [
          // Fotoğraf
          GestureDetector(
            onTap: onPhotoTap,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        presence.auraColor.withValues(alpha: 0.5),
                        presence.auraColorEnd.withValues(alpha: 0.2),
                      ],
                    ),
                    border: Border.all(
                      color: presence.auraColor.withValues(alpha: 0.6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: presence.auraColor.withValues(alpha: 0.3),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                    image: avatarBytes != null
                        ? DecorationImage(
                            image: MemoryImage(avatarBytes),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: avatarBytes == null
                      ? Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'B',
                            style: HueTextStyles.title.copyWith(
                              fontSize: 36,
                              color: presence.auraColor,
                            ),
                          ),
                        )
                      : null,
                ),
                // Kamera ikonu
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8C42),
                    shape: BoxShape.circle,
                    border: Border.all(color: HueColors.bgCard, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt,
                      size: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          const Gap(HueSpacing.md),
          // İsim + düzenle butonu
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: HueTextStyles.subtitle),
              const Gap(HueSpacing.xs),
              GestureDetector(
                onTap: onNameTap,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: HueColors.bgSecondary,
                    borderRadius: BorderRadius.circular(HueRadius.sm),
                  ),
                  child: const Icon(Icons.edit,
                      size: 14, color: HueColors.textSecondary),
                ),
              ),
            ],
          ),
          const Gap(HueSpacing.xs),
          // Presence
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: presence.auraColor,
                ),
              ),
              const Gap(4),
              Text(presence.label, style: HueTextStyles.caption),
            ],
          ),
          const Gap(HueSpacing.sm),
          // Fotoğraf yükle butonu
          OutlinedButton.icon(
            onPressed: onPhotoTap,
            icon: const Icon(Icons.photo_library_outlined, size: 16),
            label: Text(
              avatarBytes != null ? 'Fotoğrafı Değiştir' : 'Fotoğraf Ekle',
              style: HueTextStyles.caption,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: HueColors.textSecondary,
              side: const BorderSide(color: HueColors.borderSubtle),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(HueRadius.md),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) => Text(
        title.toUpperCase(),
        style: HueTextStyles.caption.copyWith(
          letterSpacing: 1.0,
          color: HueColors.textDisabled,
        ),
      );
}

class _PresenceOption extends StatelessWidget {
  final PresenceStatus status;
  final bool isSelected;
  final VoidCallback onTap;
  const _PresenceOption(
      {required this.status, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: HueSpacing.xs),
        padding: const EdgeInsets.symmetric(
            horizontal: HueSpacing.md, vertical: HueSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? status.auraColor.withValues(alpha: 0.12)
              : HueColors.bgCard,
          borderRadius: BorderRadius.circular(HueRadius.md),
          border: Border.all(
            color: isSelected
                ? status.auraColor.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: status.auraColor),
            ),
            const Gap(HueSpacing.sm),
            Expanded(child: Text(status.label, style: HueTextStyles.body)),
            if (isSelected)
              Icon(Icons.check, color: status.auraColor, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow(
      {required this.label,
      required this.subtitle,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: HueSpacing.md, vertical: HueSpacing.sm),
      decoration: BoxDecoration(
        color: HueColors.bgCard,
        borderRadius: BorderRadius.circular(HueRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: HueTextStyles.body),
                Text(subtitle, style: HueTextStyles.caption),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF8C42),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: HueSpacing.md, vertical: HueSpacing.sm),
        child: Row(
          children: [
            Text(label, style: HueTextStyles.body),
            const Spacer(),
            Text(value, style: HueTextStyles.meta),
          ],
        ),
      );
}
