import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/text_styles.dart';
import '../../domain/models/intent.dart';

class OnboardingCScreen extends StatefulWidget {
  const OnboardingCScreen({super.key});

  @override
  State<OnboardingCScreen> createState() => _OnboardingCScreenState();
}

class _OnboardingCScreenState extends State<OnboardingCScreen> {
  HuePreset? _selectedPreset;
  bool _sentHue = false;
  bool _acknowledged = false;
  bool _startEnabled = false;
  bool _showAcknowledge = false;

  void _selectPreset(HuePreset preset) {
    setState(() => _selectedPreset = preset);
  }

  void _sendHue() async {
    if (_selectedPreset == null || _sentHue) return;
    setState(() => _sentHue = true);

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _showAcknowledge = true);
    }
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _acknowledged = true;
        _startEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HueColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: HueSpacing.lg),
          child: Column(
            children: [
              const Gap(HueSpacing.xl),
              // Mock contact
              _MockContactPreview(
                showAcknowledge: _showAcknowledge,
                acknowledged: _acknowledged,
              ),
              const Gap(HueSpacing.xl),
              // Instruction text
              Text(
                _sentHue
                    ? (_acknowledged ? 'Ayşe anladı 👋' : 'Gönderildi...')
                    : 'Bir hue seç ve gönder',
                style: HueTextStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              const Gap(HueSpacing.md),
              // Preset row
              _PresetRow(
                selectedPreset: _selectedPreset,
                onSelect: _sentHue ? null : _selectPreset,
              ),
              const Gap(HueSpacing.xl),
              // Send button
              _HueSendButton(
                selectedPreset: _selectedPreset,
                sentHue: _sentHue,
                onSend: _sendHue,
              ),
              const Spacer(),
              // Start button
              AnimatedOpacity(
                opacity: _startEnabled ? 1.0 : 0.35,
                duration: const Duration(milliseconds: 400),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _startEnabled ? () => context.go('/home') : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C42),
                      disabledBackgroundColor: HueColors.bgCard,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(HueRadius.lg),
                      ),
                    ),
                    child: Text(
                      'Başla',
                      style: HueTextStyles.label.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Gap(HueSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _MockContactPreview extends StatelessWidget {
  final bool showAcknowledge;
  final bool acknowledged;

  const _MockContactPreview({
    required this.showAcknowledge,
    required this.acknowledged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HueSpacing.md),
      decoration: BoxDecoration(
        color: HueColors.bgCard,
        borderRadius: BorderRadius.circular(HueRadius.lg),
        border: Border.all(color: HueColors.borderSubtle),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF2C3A50),
                child: Text('A',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8C42),
                    shape: BoxShape.circle,
                    border: Border.all(color: HueColors.bgCard, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const Gap(HueSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ayşe', style: HueTextStyles.label),
                Text('Müsait', style: HueTextStyles.caption),
              ],
            ),
          ),
          if (showAcknowledge)
            Icon(
              acknowledged ? Icons.done_all : Icons.done,
              color: acknowledged
                  ? const Color(0xFFFF8C42)
                  : HueColors.textSecondary,
              size: 20,
            ).animate().fadeIn(duration: 300.ms).scaleXY(begin: 0.5, end: 1.0),
        ],
      ),
    );
  }
}

class _PresetRow extends StatelessWidget {
  final HuePreset? selectedPreset;
  final void Function(HuePreset)? onSelect;

  const _PresetRow({this.selectedPreset, this.onSelect});

  @override
  Widget build(BuildContext context) {
    const presets = [
      HuePreset.warm,
      HuePreset.listening,
      HuePreset.deep,
      HuePreset.onTheWay,
      HuePreset.busy,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: presets.map((preset) {
        final isSelected = selectedPreset == preset;
        return GestureDetector(
          onTap: () => onSelect?.call(preset),
          child: AnimatedContainer(
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
                        color: preset.primaryColor.withOpacity(0.6),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
              border: Border.all(
                color: isSelected
                    ? Colors.white.withOpacity(0.6)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(preset.label[0],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _HueSendButton extends StatelessWidget {
  final HuePreset? selectedPreset;
  final bool sentHue;
  final VoidCallback onSend;

  const _HueSendButton({
    required this.selectedPreset,
    required this.sentHue,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = selectedPreset != null && !sentHue;
    final colors =
        selectedPreset?.gradient ?? [HueColors.bgCard, HueColors.bgCard];

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
            end: Alignment.bottomRight,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: colors.first.withOpacity(0.5),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Icon(
          sentHue ? Icons.check : Icons.send_rounded,
          color: isEnabled || sentHue ? Colors.white : HueColors.textDisabled,
          size: 28,
        ),
      ),
    );
  }
}
