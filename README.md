# swing_page_transition

A 3D "swing" page transition for Flutter. The new page swings in from the
side, rotating around the vertical axis and zooming down to size like a book
page being turned, while the page underneath slides back, shrinks and dims.

<p align="center">
  <img src="https://raw.githubusercontent.com/RB105/swing_page_transition/main/doc/demo.gif" width="300" alt="The swing page transition: a venue page swings in over a list and back out">
</p>

The defaults reproduce the page transition of the Wolt app, following
[Shadi F's React Navigation re-creation](https://iamshadi.medium.com/re-creating-the-wolts-smooth-page-transition-with-expo-router-in-react-native-0b34541452db).
This package is not affiliated with Wolt.

## Features

- **One line in your theme.** Every `MaterialPageRoute` swings in, including
  `Navigator.pushNamed` and routers that build on it.
- **`SwingPageRoute`** swings in a single page, whatever the theme.
- **iOS edge swipe back** is kept (it is Flutter's own Cupertino gesture) and
  respects `PopScope`.
- **The page underneath recedes** even when it is not a `MaterialPageRoute`,
  such as a `PageRouteBuilder` root.
- Right-to-left aware, fully configurable, no dependencies.

## Usage

```yaml
dependencies:
  swing_page_transition: ^0.1.0
```

### Every route

```dart
MaterialApp(
  theme: ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: SwingPageTransitionsBuilder(),
        TargetPlatform.iOS: SwingPageTransitionsBuilder(),
      },
    ),
  ),
  home: const HomePage(),
);
```

### A single route

```dart
Navigator.of(context).push(
  SwingPageRoute(builder: (_) => const DetailsPage()),
);
```

### Tuning

```dart
const SwingPageTransitionsBuilder(
  duration: Duration(milliseconds: 450),
  enterAngle: math.pi / 6, // 30° instead of 60°
  enterScale: 1.3,
  coveredOverlayColor: Color(0x66000000),
)
```

| Parameter | Default | Effect |
| --- | --- | --- |
| `duration` | 550 ms | Push duration. |
| `reverseDuration` | `duration` | Pop duration. |
| `curve` | `Curves.easeOut` | Easing. A pop plays it backwards. |
| `enterOffset` | `1.6` | Where the new page starts, in screen widths. |
| `enterAngle` | `pi / 3` (60°) | Its starting rotation around the vertical axis. |
| `enterScale` | `1.6` | Its starting scale. |
| `enterOpacity` | `0.8` | Its starting opacity. |
| `perspective` | `1000` | Viewer distance in logical pixels, like CSS `perspective()`. |
| `coveredOffset` | `-0.3` | How far the page underneath slides, in screen widths. |
| `coveredScale` | `0.9` | How far the page underneath shrinks. |
| `coveredOverlayColor` | 50% black | How much the page underneath dims. |
| `backdropColor` | black | Shown around the shrunk page; `null` for none. |
| `swipeBackEnabled` | `true` | Whether an edge swipe pops the route. |

## Coming from React Navigation

| `@react-navigation/stack` | swing_page_transition |
| --- | --- |
| `current.progress` | the route's `animation` |
| `next.progress` | the route's `secondaryAnimation` |
| `transitionSpec`: 550 ms, `Easing.out(Easing.ease)` / `Easing.in(Easing.ease)` | `duration`, `curve: Curves.easeOut` (played backwards on pop, which equals `Easing.in`) |
| `translateX` 1.6 × width, `rotateY` 60°, `scale` 1.6, `perspective` 1000 | `enterOffset`, `enterAngle`, `enterScale`, `perspective` |
| card opacity 0.8 → 1 | `enterOpacity` |
| `next`: `translateX` −0.3 × width, `scale` 0.9 | `coveredOffset`, `coveredScale` |
| `cardOverlayEnabled`, overlay opacity 0 → 0.5 | `coveredOverlayColor` |
| `gestureEnabled` | `swipeBackEnabled` |

## Notes

- Requires Flutter 3.27 or newer. On Flutter 3.27 and 3.28, `MaterialPageRoute`
  ignores `duration` and runs for 300 ms; `SwingPageRoute` always honors it.
- During a back swipe both pages follow the finger linearly with the same
  geometry, so the page moves faster than the finger, as in the original.
