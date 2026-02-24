import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/text_styles.dart';
import '../../domain/models/intent.dart';

class OnboardingBScreen extends StatefulWidget {
  const OnboardingBScreen({super.key});

  @override
  State<OnboardingBScreen> createState() => _OnboardingBScreenState();
}

class _OnboardingBScreenState extends State<OnboardingBScreen>
    with SingleTickerProviderStateMixin {
  late final HuePreset _selectedPreset;

  @override
  void initState() {
    super.initState();
    final presets =
        HuePreset.values.where((p) => p != HuePreset.custom).toList();
    _selectedPreset = presets[Random().nextInt(presets.length)];
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _selectedPreset.gradient;

    return Scaffold(
      backgroundColor: HueColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: HueSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Breathing Orb
              _BreathingOrb(gradient: gradient),
              const Gap(HueSpacing.xl),
              Text(
                'Bir renk seç.',
                style: HueTextStyles.title.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const Gap(HueSpacing.sm),
              Text(
                'Yeter.',
                style: HueTextStyles.title.copyWith(
                  fontSize: 28,
                  color: HueColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(HueSpacing.md),
              Text(
                'Hue, söze gerek kalmadan\nne hissettiğini iletir.',
                style: HueTextStyles.meta,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/onboarding-c'),
                  style: FilledButton.styleFrom(
                    backgroundColor: gradient.first,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(HueRadius.lg),
                    ),
                  ),
                  child: Text(
                    'Devam',
                    style: HueTextStyles.label.copyWith(color: Colors.white),
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

class _BreathingOrb extends StatefulWidget {
  final List<Color> gradient;
  const _BreathingOrb({required this.gradient});

  @override
  State<_BreathingOrb> createState() => _BreathingOrbState();
}

class _BreathingOrbState extends State<_BreathingOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    _glow = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: widget.gradient,
                radius: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.gradient.first.withOpacity(_glow.value),
                  blurRadius: 60,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
