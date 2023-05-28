import 'package:flutter/material.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  final Color selectedItemColor;
  final Color unselectedItemColor;

  const CustomBottomNavbar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CustomColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 4.0,
            color: Color.fromARGB((0.25 * 255).toInt(), 0, 0, 0),
          )
        ],
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navbarItems(
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
        ),
      ),
    );
  }

  List<Widget> navbarItems({
    required Color selectedItemColor,
    required Color unselectedItemColor,
  }) {
    final List<Widget> widgetItems = [];

    for (int i = 0; i < items.length; i++) {
      widgetItems.add(
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            onTap(i);
          },
          child: _CustomBottomNavbarItem(
            currentIndex == i,
            items[i],
            selectedItemColor: selectedItemColor,
            unselectedItemColor: unselectedItemColor,
          ),
        ),
      );
    }

    return widgetItems;
  }
}

class _CustomBottomNavbarItem extends StatelessWidget {
  final BottomNavigationBarItem item;
  final bool isActive;

  final Color selectedItemColor;
  final Color unselectedItemColor;

  const _CustomBottomNavbarItem(
    this.isActive,
    this.item, {
    required this.selectedItemColor,
    required this.unselectedItemColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isActive ? item.activeIcon : item.icon,
          Text(
            item.label ?? '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isActive ? selectedItemColor : unselectedItemColor,
            ),
          ),
        ],
      ),
    );
  }
}
