import 'package:activation/pages/navigation_bar/navigation_bar_desktop_tablet.dart';
import 'package:activation/pages/navigation_bar/navigation_bar_mobile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        child: ScreenTypeLayout(
          mobile: const NavigationBarMobile(),
          tablet: const NavigationBarTabletDesktop(),
        ));
  }
}
