import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taski_to_do/core/services/navigation_provider.dart';

class CoreUtils {
  const CoreUtils._();

  static void unNamedRouteNavigation({
    required Widget page,
    required BuildContext context,
    bool? customRoute = false,
  }) {
    Navigator.of(context).push(
      customRoute!
          ? PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) =>
                  SlideTransition(
                position: animation.drive(
                  Tween(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).chain(
                    CurveTween(
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
                child: child,
              ),
            )
          : MaterialPageRoute(
              builder: (context) => page,
            ),
    );
  }

  static void openModal({
    required BuildContext context,
    required Widget child,
    void Function()? action,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => child,
    ).whenComplete(() {
      if (!context.mounted) return;
      return action ?? backTodo(context);
    });
  }

  static backTodo(BuildContext context) {
    Provider.of<NavigationProvider>(context, listen: false).setCurrentIndex(0);
  }

  static showWidgetOnInit({
    required BuildContext context,
    required Widget child,
  }) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => CoreUtils.openModal(
        context: context,
        child: child,
      ),
    );
  }
}
