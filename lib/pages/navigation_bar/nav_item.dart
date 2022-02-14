// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavItem extends StatefulWidget {
  final String title;

  const NavItem({Key? key, required this.title}) : super(key: key);

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  late String title;

  @override
  void initState() {
    title = widget.title;
    super.initState();
  }

  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        onHover: (hover) {
          setState(() {
            isHover = hover;
          });
        },
        child: Text(title,
            style: GoogleFonts.abel(
                decoration:
                    isHover ? TextDecoration.underline : TextDecoration.none,
                fontSize: 30,
                color: isHover ? Colors.amber : Colors.white,
                fontWeight: FontWeight.bold)));
  }
}
