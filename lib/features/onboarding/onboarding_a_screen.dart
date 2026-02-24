import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/text_styles.dart';

class OnboardingAScreen extends StatefulWidget {
  const OnboardingAScreen({super.key});

  @override
  State<OnboardingAScreen> createState() => _OnboardingAScreenState();
}

class _OnboardingAScreenState extends State<OnboardingAScreen> {
  final List<String> _messages = ['Tamam', 'Peki', 'Görüyorum'];
  int _currentMessageIndex = 0;
  String _displayedText = '';
  bool _isTyping = true;

  @override
  void initState() {
    super.initState();
    _startTypingLoop();
  }

  void _startTypingLoop() async {
    while (mounted) {
      final target = _messages[_currentMessageIndex];
      // Type
      for (int i = 0; i <= target.length; i++) {
        if (!mounted) return;
        setState(() {
          _displayedText = target.substring(0, i);
          _isTyping = true;
        });
        await Future.delayed(const Duration(milliseconds: 80));
      }
      await Future.delayed(const Duration(milliseconds: 600));
      // Delete
      for (int i = target.length; i >= 0; i--) {
        if (!mounted) return;
        setState(() {
          _displayedText = target.substring(0, i);
          _isTyping = false;
        });
        await Future.delayed(const Duration(milliseconds: 50));
      }
      await Future.delayed(const Duration(milliseconds: 300));
      _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: HueColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: HueSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.25),
              // Typing animation area
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(HueSpacing.md),
                decoration: BoxDecoration(
                  color: HueColors.bgCard,
                  borderRadius: BorderRadius.circular(HueRadius.lg),
                  border: Border.all(color: HueColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFF2C3A50),
                      child: Text(
                        '👤',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const Gap(HueSpacing.sm),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            _displayedText,
                            style: HueTextStyles.body,
                          ),
                          if (_isTyping && _displayedText.isNotEmpty)
                            Container(
                              width: 2,
                              height: 18,
                              color: HueColors.textPrimary,
                            )
                                .animate(onPlay: (c) => c.repeat())
                                .fadeIn(duration: 500.ms)
                                .then()
                                .fadeOut(duration: 500.ms),
                          if (_displayedText.isEmpty)
                            Container(
                              width: 2,
                              height: 18,
                              color: HueColors.textSecondary,
                            )
                                .animate(onPlay: (c) => c.repeat())
                                .fadeIn(duration: 500.ms)
                                .then()
                                .fadeOut(duration: 500.ms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(HueSpacing.xl),
              Text(
                'Bazen yazmak\nfazla gelir.',
                style: HueTextStyles.title.copyWith(
                  fontSize: 26,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Hue, bunu değiştiriyor.',
                style: HueTextStyles.meta,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/onboarding-b'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C42),
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
