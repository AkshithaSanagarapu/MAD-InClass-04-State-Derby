import 'package:flutter/material.dart';

void main() {
  runApp(const ViralStudioApp());
}

// ============================================================
// ROOT APP - Manages global Light/Dark theme state
// ============================================================

class ViralStudioApp extends StatefulWidget {
  const ViralStudioApp({super.key});

  @override
  State<ViralStudioApp> createState() => _ViralStudioAppState();
}

class _ViralStudioAppState extends State<ViralStudioApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viral Content Studio',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: ViralContentScreen(
        isDark: isDarkMode,
        onToggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

// ============================================================
// MAIN SCREEN - Owns the engagement state
// ============================================================

class ViralContentScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ViralContentScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ViralContentScreen> createState() => _ViralContentScreenState();
}

class _ViralContentScreenState extends State<ViralContentScreen> {
  int likes = 0;
  int comments = 0;
  int saves = 0;
  int shares = 0;
  int streak = 0;

  bool isTrending = false;

  String lastAction = "NONE";

  int get engagementScore {
    return likes + (comments * 2) + (saves * 2) + (shares * 3);
  }

  void _performAction(String action) {
    setState(() {
      if (action == "LIKE") {
        likes++;
      } else if (action == "COMMENT") {
        comments++;
      } else if (action == "SAVE") {
        saves++;
      } else if (action == "SHARE") {
        shares++;
      }

      streak++;
      lastAction = action;

      // Viral Content Studio rule:
      // Trending unlocks at 20 engagement points.
      isTrending = engagementScore >= 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isTrending
        ? (widget.isDark
              ? const Color(0xFF351525)
              : const Color(0xFFFFE5EE))
        : (widget.isDark
              ? const Color(0xFF1E1F29)
              : const Color(0xFFE0E5EC));

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: const Text(
          "VIRAL CONTENT STUDIO",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              widget.isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: "Toggle Theme",
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Column(
          children: [
            // ==================================================
            // STATELESS WIDGET #1
            // ==================================================

            EngagementMetrics(
              engagementScore: engagementScore,
              streak: streak,
              isDark: widget.isDark,
            ),

            const SizedBox(height: 16),

            // ==================================================
            // STATELESS WIDGET #2
            // ==================================================

            StudioStatus(
              lastAction: lastAction,
              isTrending: isTrending,
              isDark: widget.isDark,
            ),

            const SizedBox(height: 28),

            // ==================================================
            // INTERACTIVE BUTTONS
            // ==================================================

            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                TactileButton(
                  icon: Icons.favorite,
                  label: "LIKE +1",
                  accentColor: Colors.pinkAccent,
                  isDark: widget.isDark,
                  onPressed: () => _performAction("LIKE"),
                ),

                TactileButton(
                  icon: Icons.comment,
                  label: "COMMENT +2",
                  accentColor: Colors.blueAccent,
                  isDark: widget.isDark,
                  onPressed: () => _performAction("COMMENT"),
                ),

                TactileButton(
                  icon: Icons.bookmark,
                  label: "SAVE +2",
                  accentColor: Colors.amberAccent,
                  isDark: widget.isDark,
                  onPressed: () => _performAction("SAVE"),
                ),

                TactileButton(
                  icon: Icons.share,
                  label: "SHARE +3",
                  accentColor: Colors.greenAccent,
                  isDark: widget.isDark,
                  onPressed: () => _performAction("SHARE"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Individual counters
            EngagementBreakdown(
              likes: likes,
              comments: comments,
              saves: saves,
              shares: shares,
            ),

            const SizedBox(height: 24),

            // Dynamic meter
            Text(
              "Trending Progress: $engagementScore / 20",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: (engagementScore / 20).clamp(0.0, 1.0),
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 10),

            Text(
              isTrending
                  ? "Target reached!"
                  : "${20 - engagementScore} points until trending",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isTrending
                    ? Colors.pinkAccent
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// STATELESS WIDGET #1 - ENGAGEMENT METRICS
// ============================================================
//
// This widget only displays data given by the parent.
// It does not own or change state.
//

class EngagementMetrics extends StatelessWidget {
  final int engagementScore;
  final int streak;
  final bool isDark;

  const EngagementMetrics({
    super.key,
    required this.engagementScore,
    required this.streak,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark
        ? const Color(0xFF282A36)
        : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              isDark ? 0.3 : 0.08,
            ),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text(
                "ENGAGEMENT",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$engagementScore",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Container(
            width: 1,
            height: 40,
            color: Colors.grey.withOpacity(0.3),
          ),

          Column(
            children: [
              const Text(
                "STREAK",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$streak",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STATELESS WIDGET #2 - STATUS DISPLAY
// ============================================================

class StudioStatus extends StatelessWidget {
  final String lastAction;
  final bool isTrending;
  final bool isDark;

  const StudioStatus({
    super.key,
    required this.lastAction,
    required this.isTrending,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "LAST ACTION: $lastAction",
          style: TextStyle(
            fontFamily: "monospace",
            fontWeight: FontWeight.w600,
            color: isDark
                ? Colors.cyanAccent
                : Colors.blue.shade700,
          ),
        ),

        if (isTrending) ...[
          const SizedBox(height: 10),
          const Text(
            "TRENDING 🔥",
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}

// ============================================================
// ADDITIONAL STATELESS WIDGET - ENGAGEMENT BREAKDOWN
// ============================================================

class EngagementBreakdown extends StatelessWidget {
  final int likes;
  final int comments;
  final int saves;
  final int shares;

  const EngagementBreakdown({
    super.key,
    required this.likes,
    required this.comments,
    required this.saves,
    required this.shares,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        Text("❤️ Likes: $likes"),
        Text("💬 Comments: $comments"),
        Text("🔖 Saves: $saves"),
        Text("🚀 Shares: $shares"),
      ],
    );
  }
}

// ============================================================
// CUSTOM STATEFUL WIDGET - TACTILE BUTTON
// ============================================================
//
// Stateful because every individual button must remember
// whether it is currently being pressed.
//

class TactileButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final bool isDark;
  final VoidCallback onPressed;

  const TactileButton({
    super.key,
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.isDark,
    required this.onPressed,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDark
        ? const Color(0xFF222430)
        : const Color(0xFFE0E5EC);

    final darkShadow = widget.isDark
        ? Colors.black87
        : const Color(0xFFA3B1C6);

    final lightShadow = widget.isDark
        ? const Color(0xFF2F3244)
        : Colors.white;

    return GestureDetector(
      // User begins pressing -> visual depression
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },

      // User releases -> restore button and perform action
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });

        widget.onPressed();
      },

      // Gesture cancelled -> restore button
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: darkShadow.withOpacity(0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: lightShadow.withOpacity(0.5),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: darkShadow.withOpacity(0.7),
                    offset: const Offset(8, 8),
                    blurRadius: 16,
                  ),
                  BoxShadow(
                    color: lightShadow.withOpacity(0.9),
                    offset: const Offset(-8, -8),
                    blurRadius: 16,
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: isPressed ? 40 : 46,
              color: isPressed
                  ? widget.accentColor
                  : (widget.isDark
                        ? Colors.white70
                        : Colors.black87),
            ),

            const SizedBox(height: 8),

            Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.8,
                color: isPressed
                    ? widget.accentColor
                    : (widget.isDark
                          ? Colors.white70
                          : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}