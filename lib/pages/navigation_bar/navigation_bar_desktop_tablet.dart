import 'package:activation/pages/navigation_bar/nav_item.dart';
import 'package:flutter/material.dart';

class NavigationBarTabletDesktop extends StatefulWidget {
  const NavigationBarTabletDesktop({Key? key}) : super(key: key);

  @override
  State<NavigationBarTabletDesktop> createState() =>
      _NavigationBarTabletDesktopState();
}

class _NavigationBarTabletDesktopState
    extends State<NavigationBarTabletDesktop> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              NavItem(title: 'Activation'),
              SizedBox(width: 20),
              NavItem(title: 'Produits'),
              SizedBox(width: 20),
              NavItem(title: 'Clients'),
              SizedBox(width: 20),
              Spacer(),
              NavItem(title: 'Connect'),
            ]));
  }
}
