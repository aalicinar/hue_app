import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/text_styles.dart';
import '../../core/mock/mock_seed.dart';
import '../../domain/models/models.dart';
import '../home/home_providers.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  final String contactId;
  const ConversationScreen({super.key, required this.contactId});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  late final Contact _contact;
  late List<Message> _messages;
  bool _composerOpen = false;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contact = MockSeed.contacts.firstWhere(
      (c) => c.id == widget.contactId,
      orElse: () => MockSeed.contacts.first,
    );
    _messages = widget.contactId == 'user1'
        ? List.from(MockSeed.messagesWithUser1)
        : [];
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTextMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(Message(
        id: 'new_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: 'conv_${widget.contactId}',
        senderId: MockSeed.currentUserId,
        kind: MessageKind.text,
        text: text.trim(),
        createdAt: DateTime.now(),
      ));
      _composerOpen = false;
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(userPrefsProvider);

    return Scaffold(
      backgroundColor: HueColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _ConversationHeader(contact: _contact),
            Expanded(
              child: _messages.isEmpty
                  ? _EmptyConversation(contact: _contact)
                  : ListView.builder(
                      padding: const EdgeInsets.all(HueSpacing.md),
                      itemCount: _messages.length,
                      itemBuilder: (context, i) {
                        final msg = _messages[i];
                        final isMe = msg.senderId == MockSeed.currentUserId;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: HueSpacing.sm),
                          child: msg.kind == MessageKind.hue
                              ? _HueBubble(message: msg, isMe: isMe)
                              : _TextBubble(message: msg, isMe: isMe),
                        ).animate(delay: (i * 50).ms).fadeIn(duration: 250.ms);
                      },
                    ),
            ),
            // Hızlı yanıt barı
            _QuickReplyBar(
              prefs: prefs,
              onSend: _addTextMessage,
              onManage: () => _showQuickReplyManager(context, prefs),
            ),
            // Composer
            _ComposerBar(
              composerOpen: _composerOpen,
              controller: _textController,
              onOpenComposer: () => setState(() => _composerOpen = true),
              onCloseComposer: () => setState(() => _composerOpen = false),
              onSendText: _addTextMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickReplyManager(BuildContext context, UserPreferences prefs) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _QuickReplyManagerSheet(
        prefs: prefs,
        onAdd: (text) =>
            ref.read(userPrefsProvider.notifier).addQuickReply(text),
        onRemove: (id) =>
            ref.read(userPrefsProvider.notifier).removeQuickReply(id),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// HEADER
// ──────────────────────────────────────────────────────

class _ConversationHeader extends StatelessWidget {
  final Contact contact;
  const _ConversationHeader({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HueSpacing.md,
        vertical: HueSpacing.sm,
      ),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(color: HueColors.borderSubtle, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            color: HueColors.textSecondary,
            onPressed: () => context.go('/home'),
          ),
          Expanded(
            child: Column(
              children: [
                Text(contact.name, style: HueTextStyles.subtitle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: contact.presenceStatus.auraColor,
                      ),
                    ),
                    const Gap(4),
                    Text(contact.presenceStatus.label,
                        style: HueTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.home_outlined, size: 20),
            color: HueColors.textSecondary,
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// QUICK REPLY BAR
// ──────────────────────────────────────────────────────

class _QuickReplyBar extends StatelessWidget {
  final UserPreferences prefs;
  final ValueChanged<String> onSend;
  final VoidCallback onManage;

  const _QuickReplyBar({
    required this.prefs,
    required this.onSend,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final replies = prefs.quickReplies;
    if (replies.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HueSpacing.md,
        vertical: HueSpacing.sm,
      ),
      decoration: const BoxDecoration(
        border:
            Border(top: BorderSide(color: HueColors.borderSubtle, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: replies
                    .map((r) => Padding(
                          padding: const EdgeInsets.only(right: HueSpacing.xs),
                          child: GestureDetector(
                            onTap: () => onSend(r.text),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: HueSpacing.md,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: HueColors.bgCard,
                                borderRadius:
                                    BorderRadius.circular(HueRadius.pill),
                                border:
                                    Border.all(color: HueColors.borderSubtle),
                              ),
                              child: Text(r.text, style: HueTextStyles.caption),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          const Gap(HueSpacing.xs),
          GestureDetector(
            onTap: onManage,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: HueColors.bgCard,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit_outlined,
                  size: 16, color: HueColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// QUICK REPLY MANAGER BOTTOM SHEET
// ──────────────────────────────────────────────────────

class _QuickReplyManagerSheet extends StatefulWidget {
  final UserPreferences prefs;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  const _QuickReplyManagerSheet({
    required this.prefs,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<_QuickReplyManagerSheet> createState() =>
      _QuickReplyManagerSheetState();
}

class _QuickReplyManagerSheetState extends State<_QuickReplyManagerSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final replies = widget.prefs.quickReplies;
    return Container(
      decoration: const BoxDecoration(
        color: HueColors.bgSecondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(HueRadius.xl)),
      ),
      padding: EdgeInsets.only(
        left: HueSpacing.lg,
        right: HueSpacing.lg,
        top: HueSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + HueSpacing.lg,
      ),
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
          Text('Hızlı Yanıtlar', style: HueTextStyles.subtitle),
          const Gap(HueSpacing.sm),
          Text(
            'Bir kez dokun → anında gönder',
            style: HueTextStyles.caption,
          ),
          const Gap(HueSpacing.md),
          // Mevcut yanıtlar
          Wrap(
            spacing: HueSpacing.xs,
            runSpacing: HueSpacing.xs,
            children: replies
                .map((r) => Chip(
                      label: Text(r.text, style: HueTextStyles.caption),
                      backgroundColor: HueColors.bgCard,
                      side: const BorderSide(color: HueColors.borderSubtle),
                      deleteIcon: const Icon(Icons.close,
                          size: 14, color: HueColors.textSecondary),
                      onDeleted: r.isDefault
                          ? null
                          : () {
                              widget.onRemove(r.id);
                            },
                    ))
                .toList(),
          ),
          const Gap(HueSpacing.md),
          // Yeni ekle
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLength: 40,
                  style: HueTextStyles.body,
                  decoration: InputDecoration(
                    hintText: 'Yeni hızlı yanıt ekle...',
                    hintStyle: HueTextStyles.meta,
                    counterText: '',
                    filled: true,
                    fillColor: HueColors.bgCard,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(HueRadius.md),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: HueSpacing.md,
                      vertical: HueSpacing.sm,
                    ),
                  ),
                  onSubmitted: (v) {
                    if (v.trim().isNotEmpty) {
                      widget.onAdd(v.trim());
                      _controller.clear();
                    }
                  },
                ),
              ),
              const Gap(HueSpacing.sm),
              IconButton.filled(
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C42),
                ),
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    widget.onAdd(text);
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// BUBBLES
// ──────────────────────────────────────────────────────

class _HueBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  const _HueBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final intent = message.hueIntent!;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: intent.preset.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: intent.preset.primaryColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
          ),
          const Gap(4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(intent.preset.label, style: HueTextStyles.caption),
              const Gap(4),
              Icon(
                message.acknowledgedAt != null ? Icons.done_all : Icons.done,
                size: 12,
                color: message.acknowledgedAt != null
                    ? intent.preset.primaryColor
                    : HueColors.textDisabled,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TextBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  const _TextBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        padding: const EdgeInsets.symmetric(
            horizontal: HueSpacing.md, vertical: HueSpacing.sm),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF1F2A36) : HueColors.bgCard,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(HueRadius.lg),
            topRight: const Radius.circular(HueRadius.lg),
            bottomLeft: Radius.circular(isMe ? HueRadius.lg : HueRadius.sm),
            bottomRight: Radius.circular(isMe ? HueRadius.sm : HueRadius.lg),
          ),
        ),
        child: Text(
          message.text ?? '',
          style: HueTextStyles.body.copyWith(
            color: isMe ? HueColors.textPrimary : HueColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// COMPOSER BAR
// ──────────────────────────────────────────────────────

class _ComposerBar extends StatelessWidget {
  final bool composerOpen;
  final TextEditingController controller;
  final VoidCallback onOpenComposer;
  final VoidCallback onCloseComposer;
  final ValueChanged<String> onSendText;

  const _ComposerBar({
    required this.composerOpen,
    required this.controller,
    required this.onOpenComposer,
    required this.onCloseComposer,
    required this.onSendText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        HueSpacing.md,
        HueSpacing.sm,
        HueSpacing.md,
        HueSpacing.md,
      ),
      child: composerOpen
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    maxLength: 280,
                    maxLines: null,
                    style: HueTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'Yaz...',
                      hintStyle: HueTextStyles.meta,
                      counterText: '',
                      filled: true,
                      fillColor: HueColors.bgCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(HueRadius.lg),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: HueSpacing.md,
                        vertical: HueSpacing.sm,
                      ),
                    ),
                    onSubmitted: onSendText,
                  ),
                ),
                const Gap(HueSpacing.sm),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  color: const Color(0xFFFF8C42),
                  onPressed: () => onSendText(controller.text),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: HueColors.textSecondary,
                  onPressed: onCloseComposer,
                ),
              ],
            ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.5, end: 0)
          : Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onOpenComposer,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: HueSpacing.md,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: HueColors.bgCard,
                        borderRadius: BorderRadius.circular(HueRadius.lg),
                      ),
                      child: Text('Yazı yaz', style: HueTextStyles.meta),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// ──────────────────────────────────────────────────────
// EMPTY STATE
// ──────────────────────────────────────────────────────

class _EmptyConversation extends StatelessWidget {
  final Contact contact;
  const _EmptyConversation({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [
                contact.presenceStatus.auraColor.withValues(alpha: 0.3),
                contact.presenceStatus.auraColorEnd.withValues(alpha: 0.1),
              ]),
              border: Border.all(
                color: contact.presenceStatus.auraColor.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                contact.name[0].toUpperCase(),
                style: HueTextStyles.title.copyWith(fontSize: 28),
              ),
            ),
          ),
          const Gap(HueSpacing.md),
          Text('${contact.name} ile sohbet', style: HueTextStyles.subtitle),
          const Gap(HueSpacing.xs),
          Text('Bir hue göndererek başla', style: HueTextStyles.meta),
        ],
      ),
    );
  }
}
