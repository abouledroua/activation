import 'package:activation/pages/navigation_bar/nav_item.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatefulWidget {
  final String title;
  final IconData icon;
  const DrawerItem({Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  late String title;
  late IconData icon;
  bool isHover = false;

  @override
  void initState() {
    title = widget.title;
    icon = widget.icon;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 30, top: 60),
        child: InkWell(
            onTap: () {},
            onHover: (hover) {
              setState(() {
                isHover = hover;
              });
            },
            child: Row(children: [
              Icon(icon, color: isHover ? Colors.amber : Colors.white),
              const SizedBox(width: 20),
              NavItem(title: title)
            ])));
  }
}
