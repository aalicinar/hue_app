import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/text_styles.dart';
import '../../domain/models/models.dart';
import '../home/home_providers.dart';

/// Quick replies shown in intent panel (Tamam, Evet, Hayır, Sonra)
const _kQuickReplies = ['Tamam ✓', 'Evet', 'Hayır', 'Sonra'];

class IntentPanel extends ConsumerStatefulWidget {
  final Contact contact;
  const IntentPanel({super.key, required this.contact});

  @override
  ConsumerState<IntentPanel> createState() => _IntentPanelState();
}

class _IntentPanelState extends ConsumerState<IntentPanel> {
  HuePreset? _selectedPreset;
  double _intensity = 0.8;
  bool _sending = false;

  void _send() async {
    if (_selectedPreset == null || _sending) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      final preset = _selectedPreset!;
      Navigator.pop(context);
      _showSentSnackBar(preset.primaryColor, '${widget.contact.name}\'e hue gönderildi');
    }
  }

  void _sendQuickReply(String text) {
    Navigator.pop(context);
    _showSentSnackBar(const Color(0xFFFF8C42), '${widget.contact.name}\'e "$text" gönderildi');
  }

  void _showSentSnackBar(Color accentColor, String message) {
    final c = context.hue;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(
              message,
              style: HueTextStyles.meta.copyWith(color: Colors.white),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              child: Text(
                'Geri al',
                style: HueTextStyles.meta.copyWith(color: accentColor),
              ),
            ),
          ],
        ),
        backgroundColor: c.bgCard,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HueRadius.lg),
        ),
        margin: const EdgeInsets.all(HueSpacing.md),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(userPrefsProvider);
    final c = context.hue;
    final screenHeight = MediaQuery.of(context).size.height;
    final customLabel = _selectedPreset != null
        ? prefs.getLabelFor(widget.contact.id, _selectedPreset!.name)
        : null;

    return Container(
      height: screenHeight * 0.72,
      decoration: BoxDecoration(
        color: c.bgSecondary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(HueRadius.xl)),
      ),
      child: Column(
        children: [
          // ── Scrollable body ─────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                HueSpacing.lg,
                HueSpacing.md,
                HueSpacing.lg,
                0,
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: c.borderSubtle,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Gap(HueSpacing.md),
                  // Header row
                  Row(
                    children: [
                      _AvatarSmall(contact: widget.contact),
                      const Gap(HueSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.contact.name,
                                style: HueTextStyles.label.copyWith(color: c.textPrimary)),
                            Text(widget.contact.presenceStatus.label,
                                style: HueTextStyles.caption.copyWith(color: c.textSecondary)),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.go('/conversation/${widget.contact.id}');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: c.textSecondary,
                          side: BorderSide(color: c.borderSubtle),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(HueRadius.md),
                          ),
                        ),
                        child: Text('Sohbet aç', style: HueTextStyles.caption.copyWith(color: c.textSecondary)),
                      ),
                    ],
                  ),
                  const Gap(HueSpacing.md),

                  // ── Hızlı yanıt butonları ────────────────────────────
                  _QuickReplyRow(replies: _kQuickReplies, onSend: _sendQuickReply),
                  const Gap(HueSpacing.md),

                  // Preview Orb
                  _PreviewOrb(selectedPreset: _selectedPreset),
                  if (customLabel != null) ...[
                    const Gap(HueSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: HueSpacing.md, vertical: 6),
                      decoration: BoxDecoration(
                        color: _selectedPreset!.primaryColor
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(HueRadius.pill),
                        border: Border.all(
                          color: _selectedPreset!.primaryColor
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        '"$customLabel"',
                        style: HueTextStyles.caption.copyWith(
                          color: _selectedPreset!.primaryColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                  const Gap(HueSpacing.md),
                  // Presets row
                  _PresetsRow(
                    contactId: widget.contact.id,
                    selectedPreset: _selectedPreset,
                    prefs: prefs,
                    onSelect: (p) => setState(() => _selectedPreset = p),
                    onLongPress: (p) => _showLabelEditor(context, p, prefs),
                  ),
                  const Gap(HueSpacing.sm),
                  // Intensity slider
                  if (_selectedPreset != null) ...[
                    Row(
                      children: [
                        Text('Yoğunluk', style: HueTextStyles.caption.copyWith(color: c.textSecondary)),
                        const Spacer(),
                        Text('${(_intensity * 100).round()}%',
                            style: HueTextStyles.caption.copyWith(color: c.textSecondary)),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        activeTrackColor: _selectedPreset!.primaryColor,
                        inactiveTrackColor: c.borderSubtle,
                        thumbColor: _selectedPreset!.primaryColor,
                        overlayColor: _selectedPreset!.primaryColor
                            .withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: _intensity,
                        onChanged: (v) => setState(() => _intensity = v),
                      ),
                    ),
                  ] else
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: HueSpacing.sm),
                      child: Text(
                        'Uzun bas → anlam ata',
                        style: HueTextStyles.caption.copyWith(
                          color: c.textDisabled,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const Gap(HueSpacing.md),
                ],
              ),
            ),
          ),
          // ── Sabit alt bar ─────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(
              HueSpacing.md,
              HueSpacing.sm,
              HueSpacing.md,
              HueSpacing.lg,
            ),
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: c.borderSubtle, width: 0.5)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_outlined),
                  color: c.textSecondary,
                  onPressed: () {},
                ),
                const Spacer(),
                _SendButton(
                  selectedPreset: _selectedPreset,
                  sending: _sending,
                  onSend: _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLabelEditor(
      BuildContext ctx, HuePreset preset, UserPreferences prefs) {
    final c = ctx.hue;
    final existing = prefs.getLabelFor(widget.contact.id, preset.name) ?? '';
    final controller = TextEditingController(text: existing);
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: c.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HueRadius.xl),
        ),
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: preset.gradient),
              ),
            ),
            const Gap(HueSpacing.sm),
            Text(
              '${preset.label} anlamı',
              style: HueTextStyles.label.copyWith(color: c.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.contact.name} kişisine özel anlam gir:',
              style: HueTextStyles.caption.copyWith(color: c.textSecondary),
            ),
            const Gap(HueSpacing.sm),
            TextField(
              controller: controller,
              autofocus: true,
              maxLength: 60,
              style: HueTextStyles.body.copyWith(color: c.textPrimary),
              decoration: InputDecoration(
                hintText: 'örn. "Merak etme, iyiyim"',
                hintStyle: HueTextStyles.meta.copyWith(color: c.textSecondary),
                filled: true,
                fillColor: c.bgCard,
                counterStyle: HueTextStyles.caption.copyWith(color: c.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(HueRadius.md),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          if (existing.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(userPrefsProvider.notifier).removeLabel(
                      widget.contact.id,
                      preset.name,
                    );
                Navigator.pop(ctx);
              },
              child: Text('Kaldır',
                  style: HueTextStyles.meta.copyWith(color: c.error)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('İptal', style: HueTextStyles.meta.copyWith(color: c.textSecondary)),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                ref.read(userPrefsProvider.notifier).setLabel(
                      widget.contact.id,
                      preset.name,
                      text,
                    );
              }
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: preset.primaryColor,
            ),
            child: Text('Kaydet',
                style: HueTextStyles.caption.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// QUICK REPLY ROW
// ──────────────────────────────────────────────────────────

class _QuickReplyRow extends StatelessWidget {
  final List<String> replies;
  final ValueChanged<String> onSend;
  const _QuickReplyRow({required this.replies, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: replies.length,
        separatorBuilder: (_, __) => const Gap(HueSpacing.xs),
        itemBuilder: (context, i) {
          final text = replies[i];
          return GestureDetector(
            onTap: () => onSend(text),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: HueSpacing.md,
                vertical: 0,
              ),
              decoration: BoxDecoration(
                color: c.bgCard,
                borderRadius: BorderRadius.circular(HueRadius.pill),
                border: Border.all(color: c.borderSubtle),
              ),
              alignment: Alignment.center,
              child: Text(
                text,
                style: HueTextStyles.caption.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// AVATAR SMALL
// ──────────────────────────────────────────────────────────

class _AvatarSmall extends StatelessWidget {
  final Contact contact;
  const _AvatarSmall({required this.contact});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: HueSizes.avatarSm,
      height: HueSizes.avatarSm,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [
          contact.presenceStatus.auraColor.withValues(alpha: 0.4),
          contact.presenceStatus.auraColorEnd.withValues(alpha: 0.2),
        ]),
        border: Border.all(
          color: contact.presenceStatus.auraColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          contact.name[0].toUpperCase(),
          style: HueTextStyles.caption.copyWith(
            color: contact.presenceStatus.auraColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// PREVIEW ORB
// ──────────────────────────────────────────────────────────

class _PreviewOrb extends StatelessWidget {
  final HuePreset? selectedPreset;
  const _PreviewOrb({this.selectedPreset});
  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    final colors =
        selectedPreset?.gradient ?? [c.bgCard, c.borderSubtle];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: HueSizes.orbPreview,
      height: HueSizes.orbPreview,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors, radius: 0.8),
        boxShadow: selectedPreset != null
            ? [
                BoxShadow(
                    color: selectedPreset!.primaryColor.withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 6)
              ]
            : null,
      ),
      child: selectedPreset == null
          ? Center(
              child: Text('?',
                  style: HueTextStyles.title
                      .copyWith(color: c.textDisabled)))
          : null,
    );
  }
}

// ──────────────────────────────────────────────────────────
// PRESETS ROW
// ──────────────────────────────────────────────────────────

class _PresetsRow extends StatelessWidget {
  final String contactId;
  final HuePreset? selectedPreset;
  final UserPreferences prefs;
  final void Function(HuePreset) onSelect;
  final void Function(HuePreset) onLongPress;

  const _PresetsRow({
    required this.contactId,
    this.selectedPreset,
    required this.prefs,
    required this.onSelect,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    const presets = [
      HuePreset.warm,
      HuePreset.busy,
      HuePreset.listening,
      HuePreset.onTheWay,
      HuePreset.deep,
    ];
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: presets.length,
        separatorBuilder: (_, __) => const Gap(HueSpacing.md),
        itemBuilder: (context, i) {
          final preset = presets[i];
          final isSelected = selectedPreset == preset;
          final hasLabel = prefs.getLabelFor(contactId, preset.name) != null;
          return GestureDetector(
            onTap: () => onSelect(preset),
            onLongPress: () => onLongPress(preset),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: HueSizes.huePreset,
                  height: HueSizes.huePreset,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: preset.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                                color:
                                    preset.primaryColor.withValues(alpha: 0.6),
                                blurRadius: 16,
                                spreadRadius: 2)
                          ]
                        : null,
                    border: Border.all(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: hasLabel
                      ? Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                const Gap(4),
                Text(
                  preset.label,
                  style: HueTextStyles.caption.copyWith(
                    color: isSelected
                        ? preset.primaryColor
                        : c.textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// SEND BUTTON
// ──────────────────────────────────────────────────────────

class _SendButton extends StatelessWidget {
  final HuePreset? selectedPreset;
  final bool sending;
  final VoidCallback onSend;
  const _SendButton(
      {required this.selectedPreset,
      required this.sending,
      required this.onSend});

  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    final isEnabled = selectedPreset != null && !sending;
    final colors =
        selectedPreset?.gradient ?? [c.bgCard, c.bgCard];
    return GestureDetector(
      onTap: isEnabled ? onSend : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: HueSizes.huePrimary,
        height: HueSizes.huePrimary,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                      color: colors.first.withValues(alpha: 0.5),
                      blurRadius: 24,
                      spreadRadius: 4)
                ]
              : null,
        ),
        child: sending
            ? const Center(
                child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white)))
            : Icon(
                Icons.send_rounded,
                color: isEnabled ? Colors.white : c.textDisabled,
                size: 28,
              ),
      ),
    );
  }
}
