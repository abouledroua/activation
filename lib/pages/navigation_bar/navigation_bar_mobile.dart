import 'package:activation/classes/global_keys.dart';
import 'package:activation/pages/navigation_bar/nav_item.dart';
import 'package:flutter/material.dart';

class NavigationBarMobile extends StatefulWidget {
  const NavigationBarMobile({Key? key}) : super(key: key);

  @override
  State<NavigationBarMobile> createState() => _NavigationBarMobileState();
}

class _NavigationBarMobileState extends State<NavigationBarMobile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        child: Row(children: [
          IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu, color: Colors.white)),
          const Spacer(),
          const NavItem(title: 'Connect')
        ]));
  }
}
