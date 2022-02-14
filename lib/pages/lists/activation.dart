// ignore_for_file: avoid_print

import 'dart:math';

import 'package:activation/classes/data.dart';
import 'package:activation/classes/global_keys.dart';
import 'package:activation/pages/navigation_bar/navigation_bar.dart';
import 'package:activation/pages/widgets/centered_view.dart';
import 'package:activation/pages/drawer/drawer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ActivationPage extends StatefulWidget {
  const ActivationPage({Key? key}) : super(key: key);

  @override
  State<ActivationPage> createState() => _ActivationPageState();
}

bool working = false;
List<String> ns = ['', '', '', ''];
FocusNode n1 = FocusNode(),
    n2 = FocusNode(),
    n3 = FocusNode(),
    nVerifier = FocusNode(),
    n4 = FocusNode();

class _ActivationPageState extends State<ActivationPage> {
  TextEditingController txtNS1 = TextEditingController(text: "");
  TextEditingController txtNS2 = TextEditingController(text: "");
  TextEditingController txtNS3 = TextEditingController(text: "");
  TextEditingController txtNS4 = TextEditingController(text: "");
  String numCD = "";

  @override
  void initState() {
    print("init activation");
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    if (Data.production) {
      numCD = "";
      txtNS1.text = "";
      txtNS2.text = "";
      txtNS3.text = "";
      txtNS4.text = "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Data.myContext = context;
    Data.setSizeScreen(context);
    return ResponsiveBuilder(
        builder: (context, sizingInformation) => SafeArea(
            child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/wall.jpg'),
                        fit: BoxFit.cover)),
                child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    drawer: sizingInformation.deviceScreenType ==
                            DeviceScreenType.mobile
                        ? const MyDrawer()
                        : null,
                    key: scaffoldKey,
                    body: CenteredView(
                        child: ListView(shrinkWrap: true, children: [
                      const NavigationBarWidget(),
                      FittedBox(
                          child: Text("Votre Numéro de Série",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.abel(
                                  fontSize: 40, color: Colors.amber))),
                      const SizedBox(height: 30),
                      Wrap(alignment: WrapAlignment.center, children: [
                        MyTextField(index: 0, txtNS: txtNS1),
                        const SizedBox(width: 10),
                        MyTextField(index: 1, txtNS: txtNS2),
                        const SizedBox(width: 10),
                        MyTextField(index: 2, txtNS: txtNS3),
                        const SizedBox(width: 10),
                        MyTextField(index: 3, txtNS: txtNS4)
                      ]),
                      const SizedBox(height: 30),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: Data.widthScreen / 20),
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: ElevatedButton(
                                  focusNode: nVerifier,
                                  style: ButtonStyle(backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return const Color.fromARGB(
                                          255, 179, 76, 161);
                                    } else if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.grey;
                                    }
                                    return const Color.fromARGB(
                                        255, 165, 15, 107);
                                  }), minimumSize:
                                      MaterialStateProperty.resolveWith<Size>(
                                          (Set<MaterialState> states) {
                                    return const Size.fromHeight(72);
                                  }), textStyle:
                                      MaterialStateProperty.resolveWith<TextStyle>(
                                          (Set<MaterialState> states) {
                                    return const TextStyle(
                                        fontSize: 24, color: Colors.white);
                                  })),
                                  onPressed: verifierNS,
                                  child: Text("Vérifier",
                                      style: GoogleFonts.abel(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 3,
                                          fontSize: 24))))),
                      const SizedBox(height: 30)
                    ]))))));
  }

  verifierNS() {
    if (ns[0].length == 6 && ns[1].length == 6 ||
        ns[2].length == 6 ||
        ns[3].length == 5) {
      verifier_cd();
    } else {
      AwesomeDialog(
              width: min(Data.widthScreen, 400),
              context: context,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: 'Erreur',
              desc: 'Numéro de série incomplet !!!')
          .show();
    }
  }

  verifier_cd() {
    String nAct = "", nAct2 = "", nAct3 = "", nAct4 = "";
    String ns1 = ns[0], ns2 = ns[1], ns3 = ns[2], ns4 = ns[3];

    String seq = ns3.substring(4, 5) +
        ns3.substring(3, 4) +
        ns1.substring(4, 5) +
        ns1.substring(1, 2) +
        ns2.substring(4, 5) +
        ns4.substring(4, 5) +
        ns2.substring(2, 3);

    print("seq=$seq");
  }
}

class MyTextField extends StatefulWidget {
  final TextEditingController txtNS;
  final int index;
  const MyTextField({Key? key, required this.txtNS, required this.index})
      : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late TextEditingController txtNS;
  late int index;

  @override
  void initState() {
    txtNS = widget.txtNS;
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int maxLength = index == 3 ? 5 : 6;
    return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 180),
        child: TextField(
            focusNode: index == 0
                ? n1
                : index == 1
                    ? n2
                    : index == 2
                        ? n3
                        : n4,
            cursorColor: Colors.black,
            onChanged: (value) {
              ns[index] = value;
              if (ns[index].length == maxLength) {
                switch (index) {
                  case 0:
                    n2.requestFocus();
                    break;
                  case 1:
                    n3.requestFocus();
                    break;
                  case 2:
                    n4.requestFocus();
                    break;
                  case 3:
                    nVerifier.requestFocus();
                    break;
                  default:
                }
              }
            },
            enabled: !working,
            controller: txtNS,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2),
            maxLength: maxLength,
            maxLines: 1,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                focusColor: Colors.amber,
                border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 5, color: Colors.black)),
                contentPadding: const EdgeInsets.only(bottom: 3),
                fillColor: Colors.grey.shade300,
                filled: true)));
  }
}
