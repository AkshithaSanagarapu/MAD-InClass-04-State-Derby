# In-Class Activity 04: Flutter Widget Wars & State Destruction Derby

## Team Members

- Akshitha Sainath Sanagarapu — Student ID: 003027780
- Mouni Sri Nallapaneni — Student ID: 003013851

**Team Name:** Akshitha_Mouni

**Shared Google Doc:**  
https://docs.google.com/document/d/1HYI7YpdYLr_xj3a0sIt8Lb2BKVXGwuKYsTCmA0-OEYk/edit?tab=t.0

**GitHub Repository:**  
https://github.com/AkshithaSanagarapu/MAD-InClass-04-State-Derby

---

## How to Run

1. Clone or download the Flutter project.
2. Open the project in VS Code.
3. Make sure Flutter is installed and configured.
4. Open a terminal inside the project folder.
5. Run:

```bash
flutter pub get
```

6. Start the application in Chrome:

```bash
flutter run -d chrome
```

7. Use the Like, Comment, Save, and Share buttons to increase engagement.
8. Use the theme icon in the top-right corner to switch between Light and Dark mode.

---

## Round 1 Findings

### Widget Identification Blitz

**STATE IDENTIFICATION BLITZ — TEAM FINDINGS REPORT**

**Team Name:** Akshitha_Mouni

SCENARIO 1 / 6 — PriceTag: We answered "STATELESS" — CORRECT (actual: STATELESS)

SCENARIO 2 / 6 — LikeToggle: We answered "STATEFUL" — CORRECT (actual: STATEFUL)

SCENARIO 3 / 6 — MenuActionTile: We answered "STATELESS" — CORRECT (actual: STATELESS)

SCENARIO 4 / 6 — SearchField: We answered "STATEFUL" — CORRECT (actual: STATEFUL)

SCENARIO 5 / 6 — StatBadge: We answered "STATELESS" — CORRECT (actual: STATELESS)

SCENARIO 6 / 6 — PulsingDot: We answered "STATEFUL" — CORRECT (actual: STATEFUL)

### Final Score

**6 / 6**

### Round 1 Evidence

The Round 1 final-score screenshot and findings report are included in the shared team evidence document.

---

## Round 2 Bug Fixes

During Round 2, we diagnosed and corrected four state-management and interaction bugs in the provided Flutter starter application.

### Bug #1 — Scope Failure

**Corrected Code:**

```dart
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
  // 🐛 BUG #1 — FIXED:
  // Every button instance now has its own pressed state.
  bool isPressed = false;
}
```

**Explanation:**  
`TactileButton` is now a `StatefulWidget`, so every individual button owns its own `isPressed` state instead of sharing one screen-level value. This allows one button to visually react without affecting all of the other buttons.

---

### Bug #2 — Silent Mutator

**Corrected Code:**

```dart
Slider(
  value: powerLevel,
  min: 0,
  max: 100,

  // 🐛 BUG #2 — FIXED:
  // setState tells Flutter to rebuild after powerLevel changes.
  onChanged: (newVal) {
    setState(() {
      powerLevel = newVal;
    });
  },
),
```

**Explanation:**  
Changing `powerLevel` by itself does not tell Flutter that the interface needs to redraw. Wrapping the update inside `setState()` causes the displayed percentage, slider, and related UI to update immediately.

---

### Bug #3 — Geometry Inversion

**Corrected Code:**

```dart
// 🐛 BUG #3 — FIXED:
// Pressed = small shadows.
// Released = large shadows.

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
```

**Explanation:**  
The shadow geometry for the pressed and released states was reversed. The corrected version uses smaller shadows while pressed and larger shadows while released, giving the button the correct tactile/neomorphic effect.

---

### Bug #4 — Event Race

**Corrected Code:**

```dart
return GestureDetector(
  // 🐛 BUG #4 — FIXED:
  // Touch down only changes the visual pressed state.
  onTapDown: (_) {
    setState(() {
      isPressed = true;
    });
  },

  // 🐛 BUG #4 — FIXED:
  // The actual action runs only after the user releases the button.
  onTapUp: (_) {
    setState(() {
      isPressed = false;
    });

    widget.onPressed();
  },

  onTapCancel: () {
    setState(() {
      isPressed = false;
    });
  },
);
```

**Explanation:**  
`onTapDown` now only controls the visual pressed state. The actual action executes through `onTapUp` after the user releases the button, while `onTapCancel` resets the button if the gesture is cancelled.

### Round 2 Evidence

Screenshots showing the corrected code, original `// 🐛 BUG #` comments, and fixed application behavior are included in the shared team Google Doc.

---

## Build Challenge

### Theme: Viral Content Studio

For our Creative Build Challenge, we created a **Viral Content Studio**, a social-media engagement simulator.

Users can interact with a simulated social-media post by liking, commenting, saving, and sharing it. Each interaction contributes a different number of engagement points.

The application tracks the individual actions, total engagement, streak, last action, and whether the post has reached trending status.

---

### State Variables

The `ViralContentScreen` manages the main engagement state:

```dart
int likes = 0;
int comments = 0;
int saves = 0;
int shares = 0;
int streak = 0;
String lastAction = 'NONE';
bool isTrending = false;
```

These values change while the application is running and are therefore managed as state.

The root `ViralStudioApp` also manages the global theme state:

```dart
bool isDarkMode = true;
```

---

### Engagement Rules

The application uses the following engagement system:

- Like = +1
- Comment = +2
- Save = +2
- Share = +3

The total engagement score is calculated using:

```dart
int get engagementScore {
  return likes + (comments * 2) + (saves * 2) + (shares * 3);
}
```

Each interaction updates its corresponding counter, increments the streak, and contributes to the overall engagement score.

---

### Trending Condition

The goal is to reach **20 engagement points**.

The application checks the trending condition using:

```dart
isTrending = engagementScore >= 20;
```

Once the engagement score reaches 20:

- `TRENDING 🔥` appears.
- The background changes.
- The progress meter reaches its target.
- `Target reached!` is displayed.

This gives the user immediate visual feedback that the special condition has been unlocked.

---

### Interactive Buttons

The application provides four functional actions:

- LIKE +1
- COMMENT +2
- SAVE +2
- SHARE +3

Each button calls `_performAction()` with its corresponding action.

For example:

```dart
onPressed: () => _performAction("LIKE")
```

and:

```dart
onPressed: () => _performAction("SHARE")
```

Each action changes application state and causes the interface to update.

---

### Dynamic Counter / Meter

The application dynamically displays:

- Engagement Score
- Streak
- Likes
- Comments
- Saves
- Shares
- Last Action
- Trending Progress

The progress meter uses:

```dart
LinearProgressIndicator(
  value: (engagementScore / 20).clamp(0.0, 1.0),
)
```

All of these values update in real time using `setState()`.

Before reaching the target, the application displays the remaining progress.

Once the target is reached, the application displays:

**Target reached!**

---

### Theme Color Switcher

The application includes a theme switcher in the upper-right corner.

The user can switch between:

- Light Mode
- Dark Mode

The global theme state is stored as:

```dart
bool isDarkMode = true;
```

The application switches between:

```dart
ThemeData.dark(useMaterial3: true)
```

and:

```dart
ThemeData.light(useMaterial3: true)
```

When the user presses the theme button, the state changes using:

```dart
setState(() {
  isDarkMode = !isDarkMode;
});
```

The application then updates the background, cards, text, shadows, and other interface elements based on the selected theme.

---

### StatelessWidgets

The Viral Content Studio contains three custom `StatelessWidget`s.

#### 1. EngagementMetrics

`EngagementMetrics` displays:

- Engagement Score
- Streak

It receives these values from its parent and does not modify them.

#### 2. StudioStatus

`StudioStatus` displays:

- Last Action
- `TRENDING 🔥` when the trending condition is reached

It receives its values from the parent and only displays them.

#### 3. EngagementBreakdown

`EngagementBreakdown` displays:

- Likes
- Comments
- Saves
- Shares

It does not maintain or modify these counters itself.

These widgets are stateless because they only receive and display values provided by their parent.

---

### StatefulWidgets

The application uses `StatefulWidget`s where changing information must be stored.

#### 1. ViralStudioApp

`ViralStudioApp` manages the global:

```dart
isDarkMode
```

state.

#### 2. ViralContentScreen

`ViralContentScreen` manages:

- Likes
- Comments
- Saves
- Shares
- Streak
- Trending status
- Last action

#### 3. TactileButton

`TactileButton` maintains its own:

```dart
bool isPressed = false;
```

Each button therefore manages its pressed state independently.

---

### GestureDetector Interaction

The custom `TactileButton` uses `GestureDetector` to create tactile feedback.

The following gesture lifecycle methods are used:

```dart
onTapDown
onTapUp
onTapCancel
```

#### onTapDown

When the user begins pressing the button:

```dart
onTapDown: (_) {
  setState(() {
    isPressed = true;
  });
},
```

This changes the visual appearance of the button.

#### onTapUp

When the user releases the button:

```dart
onTapUp: (_) {
  setState(() {
    isPressed = false;
  });

  widget.onPressed();
},
```

The button returns to its normal appearance and performs the selected action.

#### onTapCancel

If the gesture is cancelled:

```dart
onTapCancel: () {
  setState(() {
    isPressed = false;
  });
},
```

This prevents the button from remaining visually pressed.

The `AnimatedContainer` also changes the button shadows and icon appearance based on the value of `isPressed`.

---

## Mandatory Architectural Checkpoints

### 1. Minimum 2 StatelessWidgets

Completed.

The application contains three custom StatelessWidgets:

- `EngagementMetrics`
- `StudioStatus`
- `EngagementBreakdown`

### 2. Minimum 1 Custom StatefulWidget

Completed.

`TactileButton` is a custom StatefulWidget that maintains its own pressed state.

### 3. Interactive Buttons

Completed.

The application contains four functional buttons:

- Like
- Comment
- Save
- Share

### 4. Dynamic Counter / Meter

Completed.

The engagement score, streak, individual action counters, and trending progress update dynamically.

### 5. Theme Color Switcher

Completed.

The user can switch between Light and Dark themes.

### 6. GestureDetector Interaction

Completed.

The custom tactile buttons use `GestureDetector` with:

- `onTapDown`
- `onTapUp`
- `onTapCancel`

to provide visual touch feedback.

---

## State Defense

Our Viral Content Studio separates widgets based on whether they need to manage changing information. `ViralStudioApp` is stateful because it manages the global `isDarkMode` value. `ViralContentScreen` is stateful because it manages likes, comments, saves, shares, streak, trending status, and the last action. `EngagementMetrics`, `StudioStatus`, and `EngagementBreakdown` are StatelessWidgets because they receive values from their parent and only display them.

We use `setState()` whenever data that affects the interface changes. `_performAction()` updates the appropriate engagement counter, increments the streak, updates the last action, and checks whether `engagementScore >= 20`. Once the score reaches 20, Flutter rebuilds the screen and displays `TRENDING 🔥`, changes the background, fills the progress indicator, and displays `Target reached!`. The root application also uses `setState()` when the Light/Dark theme is toggled.

`TactileButton` is a custom StatefulWidget because every button needs its own temporary `isPressed` state. Its `GestureDetector` sets `isPressed` to true during `onTapDown`, resets it during `onTapUp`, performs the action after release, and resets the state during `onTapCancel` if necessary. Keeping this state inside each `TactileButton` allows every button to respond independently.

---

## Build Challenge Evidence

The completed Viral Content Studio demonstrates both the normal and trending states.

At **20 engagement points**, the application displays:

**TRENDING 🔥**

The progress section displays:

**Trending Progress: 20 / 20**

and:

**Target reached!**

The application also demonstrates the Light/Dark theme switch and tactile button interactions.

Screenshots and the demo recording are included in the shared team evidence document and final iCollege submission.

---

## Demo

The **15–30 second screen recording** demonstrates:

- Like button interaction
- Comment button interaction
- Save button interaction
- Share button interaction
- Engagement score updating
- Individual counters updating
- Streak updating
- Last Action updating
- Trending progress increasing
- `TRENDING 🔥` unlocking
- Tactile button feedback
- Light/Dark theme switching

---

## Submission Checklist

- [x] GitHub repository contains the complete Flutter project.
- [x] `lib/main.dart` contains the completed Viral Content Studio.
- [x] `pubspec.yaml` is included.
- [x] README contains Team Members.
- [x] README contains How to Run instructions.
- [x] README contains Round 1 Findings.
- [x] Round 1 score is documented as **6 / 6**.
- [x] README contains all four Round 2 Bug Fix explanations.
- [x] README contains the Build Challenge section.
- [x] README contains the 3-paragraph State Defense Summary.
- [x] Minimum two StatelessWidgets implemented.
- [x] Custom StatefulWidget implemented.
- [x] Four interactive engagement buttons implemented.
- [x] Dynamic engagement counter and progress meter implemented.
- [x] Trending condition implemented.
- [x] Light/Dark theme switching implemented.
- [x] GestureDetector tactile interaction implemented.
- [x] Round 1 evidence is included in the shared document.
- [x] Round 2 Bug Hunt proof is included in the shared document.
- [x] Demo recording/GIF is included in the final submission.

---

## Final Project

**Activity:** In-Class Activity 04 — Flutter Widget Wars & State Destruction Derby

**Build Challenge:** Viral Content Studio

**Team:** Akshitha_Mouni

**Team Members:**

- Akshitha Sainath Sanagarapu
- Mouni Sri Nallapaneni

**GitHub Repository:**  
https://github.com/AkshithaSanagarapu/MAD-InClass-04-State-Derby