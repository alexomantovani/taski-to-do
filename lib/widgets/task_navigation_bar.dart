import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/services/assets.dart';
import '../core/services/navigation_provider.dart';
import '../core/services/styles.dart';

class TaskNavigationBar extends StatelessWidget {
  const TaskNavigationBar({super.key, required this.onTap});

  final Function(int value) onTap;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      child: BottomNavigationBar(
        backgroundColor: Styles.kStandardWhite,
        elevation: 20.0,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedItemColor: Styles.kPrimaryBlue,
        unselectedLabelStyle: Styles.bodySmall.copyWith(
          height: 3,
          fontWeight: FontWeight.bold,
        ),
        selectedLabelStyle: Styles.bodySmall.copyWith(
          height: 3,
          fontWeight: FontWeight.bold,
        ),
        currentIndex: Provider.of<NavigationProvider>(context).currentIndex,
        onTap: (value) => onTap(value),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.kIcTodo),
            label: 'Todo',
            activeIcon: SvgPicture.asset(Assets.kIcTodoBlue),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.kIcCreate),
            label: 'Create',
            activeIcon: SvgPicture.asset(
              Assets.kIcCreate,
              colorFilter:
                  ColorFilter.mode(Styles.kPrimaryBlue, BlendMode.srcIn),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.kIcSearch),
            label: 'Search',
            activeIcon: SvgPicture.asset(
              Assets.kIcSearch,
              colorFilter:
                  ColorFilter.mode(Styles.kPrimaryBlue, BlendMode.srcIn),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.kIcDone),
            label: 'Done',
            activeIcon: SvgPicture.asset(
              Assets.kIcDone,
              colorFilter:
                  ColorFilter.mode(Styles.kPrimaryBlue, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}
