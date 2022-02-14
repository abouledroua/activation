import 'dart:math';

import 'package:activation/classes/data.dart';
import 'package:activation/pages/drawer/drawer_item.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: min(250, Data.widthScreen),
        decoration: const BoxDecoration(
          color: Colors.indigo,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)],
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.start, children: const [
          DrawerItem(icon: Icons.lock_open_outlined, title: 'Activation'),
          DrawerItem(icon: Icons.production_quantity_limits, title: 'Produits'),
          DrawerItem(icon: Icons.person, title: 'Clients')
        ]));
  }
}
