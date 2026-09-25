import 'package:flutter/material.dart';

import 'swing_page_transitions_builder.dart';

/// A [PageRoute] that always uses a [SwingPageTransitionsBuilder], whatever
/// the app's [PageTransitionsTheme] is. Handy for swinging in a single page:
///
/// ```dart
/// Navigator.of(context).push(
///   SwingPageRoute(builder: (_) => const DetailsPage()),
/// );
/// ```
class SwingPageRoute<T> extends PageRoute<T> {
  /// Creates a route that swings its page in with [transitions].
  SwingPageRoute({
    required this.builder,
    this.transitions = const SwingPageTransitionsBuilder(),
    this.maintainState = true,
    super.settings,
    super.requestFocus,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
  });

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  /// The transition used to push and pop this route.
  final SwingPageTransitionsBuilder transitions;

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => transitions.transitionDuration;

  @override
  Duration get reverseTransitionDuration =>
      transitions.reverseTransitionDuration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  DelegatedTransitionBuilder? get delegatedTransition =>
      transitions.delegatedTransition;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: builder(context),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return transitions.buildTransitions<T>(
        this, context, animation, secondaryAnimation, child);
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}
