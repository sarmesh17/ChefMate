import 'package:airecipe/provider/chat_gpt_provider/chat_gpt_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AiRecipeScreen extends ConsumerStatefulWidget {
  const AiRecipeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreen();
}

class _ChatScreen extends ConsumerState<AiRecipeScreen>
    with TickerProviderStateMixin {
  final userInputController = TextEditingController();
  final scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<ChatMessage> messages = [];
  bool isLoading = false;
  AnimationController? _typingAnimationController;
  AnimationController? _welcomeAnimationController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _welcomeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _welcomeAnimationController!,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _welcomeAnimationController!,
            curve: Curves.elasticOut,
          ),
        );

    _welcomeAnimationController?.forward();
  }

  @override
  void dispose() {
    userInputController.dispose();
    scrollController.dispose();
    _focusNode.dispose();
    _typingAnimationController?.dispose();
    _welcomeAnimationController?.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final input = userInputController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(message: input, isUser: true));
      isLoading = true;
      userInputController.clear();
    });

    // Scroll to bottom immediately when user sends message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    try {
      final response = await ref.read(chatRepoProvider).fetchResponse(input);
      final reply = response.choices.first.message.content;

      setState(() {
        messages.add(ChatMessage(message: reply, isUser: false));
        isLoading = false;
      });

      // Auto scroll to bottom after AI response
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      setState(() {
        messages.add(ChatMessage(message: "Error: $e", isUser: false));
        isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[100]!, Colors.grey[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
                const SizedBox(width: 8),
                Text(
                  "ChefMate is cooking up a response...",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation:
          _typingAnimationController ??
          AnimationController(duration: Duration.zero, vsync: this),
      builder: (context, child) {
        if (_typingAnimationController == null) {
          return Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          );
        }

        double delay = index * 0.2;
        double animValue = (_typingAnimationController!.value - delay).clamp(
          0.0,
          1.0,
        );
        double scale = (1.0 + 0.5 * (1.0 - (animValue - 0.5).abs() * 2)).clamp(
          0.5,
          1.5,
        );

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    final isUser = message.isUser;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        final safeOpacity = value.clamp(0.0, 1.0);

        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: safeOpacity,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                mainAxisAlignment: isUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.lightGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        gradient: isUser
                            ? const LinearGradient(
                                colors: [Colors.green, Colors.lightGreen],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [Colors.grey[50]!, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(isUser ? 20 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isUser
                                ? Colors.green.withOpacity(0.3)
                                : Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.message,
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.grey[800],
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTime(message.timestamp),
                            style: TextStyle(
                              color: isUser
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isUser) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[400]!, Colors.blue[600]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'ChefMate',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                messages.clear();
              });
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Welcome Section
                  if (messages.isEmpty) ...[
                    _welcomeAnimationController != null
                        ? AnimatedBuilder(
                            animation: _welcomeAnimationController!,
                            builder: (context, child) {
                              return FadeTransition(
                                opacity: _fadeAnimation!,
                                child: SlideTransition(
                                  position: _slideAnimation!,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.green,
                                              Colors.lightGreen,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.green.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          'assets/images/ai_robo_sticker.png',
                                          width: 120,
                                          height: 120,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 20,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (bounds) =>
                                                  const LinearGradient(
                                                    colors: [
                                                      Colors.green,
                                                      Colors.lightGreen,
                                                    ],
                                                  ).createShader(bounds),
                                              child: const Text(
                                                '👋 Hello, Boss!',
                                                style: TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'I\'m Ready to Help You',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              "Ask me anything that's on your mind.\nI'm here to assist you with amazing recipes! 🍳",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.green, Colors.lightGreen],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/ai_robo_sticker.png',
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (bounds) =>
                                          const LinearGradient(
                                            colors: [
                                              Colors.green,
                                              Colors.lightGreen,
                                            ],
                                          ).createShader(bounds),
                                      child: const Text(
                                        '👋 Hello, Boss!',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'I\'m Ready to Help You',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Ask me anything that's on your mind.\nI'm here to assist you with amazing recipes! 🍳",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 32),
                  ],

                  // Chat Messages
                  ...messages.asMap().entries.map(
                    (entry) => _buildMessageBubble(entry.value, entry.key),
                  ),

                  // Typing Indicator
                  if (isLoading) _buildTypingIndicator(),

                  const SizedBox(height: 80), // Extra space for input field
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7F5),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: TextField(
                  controller: userInputController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => sendMessage(),
                  decoration: const InputDecoration(
                    hintText: "What recipe would you like to explore? 🤔",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: isLoading ? null : sendMessage,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Icon(
                      isLoading ? Icons.hourglass_bottom : Icons.send_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
