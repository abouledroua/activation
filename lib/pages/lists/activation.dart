// ignore_for_file: avoid_print

import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:activation/classes/data.dart';
import 'package:activation/classes/global_keys.dart';
import 'package:activation/pages/navigation_bar/navigation_bar.dart';
import 'package:activation/pages/widgets/centered_view.dart';
import 'package:activation/pages/drawer/drawer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivationPage extends StatefulWidget {
  const ActivationPage({Key? key}) : super(key: key);

  @override
  State<ActivationPage> createState() => _ActivationPageState();
}

bool working = false, genererActivation = false;
List<String> ns = ['', '', '', ''];
late FocusNode n1 = FocusNode(),
    n2 = FocusNode(),
    n3 = FocusNode(),
    nVerifier = FocusNode(),
    n4 = FocusNode();
late double prix;
late String ns1,
    ns2,
    ns3,
    ns4,
    mac,
    pSeq,
    workingMessage = "",
    nAct2,
    nAct3,
    nAct4,
    nAct1;
late SharedPreferences prefs;
late int disque, idVersion, annee, active, idCD;
late Client? myClient;

class _ActivationPageState extends State<ActivationPage> {
  late TextEditingController txtNS1,
      txtNS2,
      txtNS3,
      txtNS4,
      txtnAct1,
      txtnAct2,
      txtnAct3,
      txtnAct4,
      txtMac,
      txtDisque,
      txtActitiveClient,
      txtAdressClient,
      txtPhoneClient,
      txtNameClient;
  String numCD = "";

  @override
  void initState() {
    print("init activation");
    getSharedPrefs();
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    // if (Data.production) {
    numCD = "";
    txtNS1 = TextEditingController(text: "15V02a");
    txtNS2 = TextEditingController(text: "E2DY8I");
    txtNS3 = TextEditingController(text: "Y9A6Y6");
    txtNS4 = TextEditingController(text: "PTX3D");
    txtDisque = TextEditingController(text: "");
    txtMac = TextEditingController(text: "");
    txtActitiveClient = TextEditingController(text: "");
    txtAdressClient = TextEditingController(text: "");
    txtNameClient = TextEditingController(text: "");
    txtPhoneClient = TextEditingController(text: "");
    txtnAct1 = TextEditingController(text: "");
    txtnAct2 = TextEditingController(text: "");
    txtnAct3 = TextEditingController(text: "");
    txtnAct4 = TextEditingController(text: "");
    ns[0] = txtNS1.text;
    ns[1] = txtNS2.text;
    ns[2] = txtNS3.text;
    ns[3] = txtNS4.text;
    //   }
    super.initState();
  }

  @override
  void dispose() {
    n1.dispose();
    n2.dispose();
    n3.dispose();
    n4.dispose();
    nVerifier.dispose();
    txtNS1.dispose();
    txtNS2.dispose();
    txtNS3.dispose();
    txtNS4.dispose();
    txtDisque.dispose();
    txtMac.dispose();
    txtNameClient.dispose();
    txtActitiveClient.dispose();
    txtAdressClient.dispose();
    txtPhoneClient.dispose();
    txtnAct1.dispose();
    txtnAct2.dispose();
    txtnAct3.dispose();
    txtnAct4.dispose();
    super.dispose();
  }

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    String? serverIP = prefs.getString('ServerIp');
    var local = prefs.getString('LocalIP');
    var intenet = prefs.getString('InternetIP');
    var mode = prefs.getInt('NetworkMode');
    mode ??= 2;
    Data.setNetworkMode(mode);
    local ??= "192.168.1.152";
    intenet ??= "atlasschool.dz";
    serverIP ??= mode == 1 ? local : intenet;
    if (serverIP != "") Data.setServerIP(serverIP);
    if (local != "") Data.setLocalIP(local);
    if (intenet != "") Data.setInternetIP(intenet);
    print("serverIP=$serverIP");
    if (serverIP == "" && !Data.production) {
      Navigator.of(context).pushNamed("setting");
    }
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
                    body: myBodyWidget()))));
  }

  CenteredView myBodyWidget() => CenteredView(
          child: ListView(shrinkWrap: true, children: [
        const NavigationBarWidget(),
        FittedBox(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Votre N° de Série",
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.abel(fontSize: 40, color: Colors.amber)))),
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
        Visibility(
            visible: !genererActivation, child: const SizedBox(height: 30)),
        working
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(workingMessage,
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 15),
                const Center(child: CircularProgressIndicator.adaptive())
              ])
            : genererActivation
                ? widgetResultat()
                : btnVerifier(),
        const SizedBox(height: 10)
      ]));

  ListView widgetResultat() => ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const Divider(color: Colors.white, height: 3),
            titleResult("Votre N° d'Activation"),
            const SizedBox(height: 30),
            Wrap(alignment: WrapAlignment.center, children: [
              resultField(txtnAct1),
              const SizedBox(width: 10),
              resultField(txtnAct2),
              const SizedBox(width: 10),
              resultField(txtnAct3),
              const SizedBox(width: 10),
              resultField(txtnAct4)
            ]),
            const Divider(color: Colors.white, height: 3),
            titleResult("Info Matériel"),
            infoResult("Adresse Mac : " + mac),
            infoResult("N° Logique du Disque : " + disque.toString()),
            const SizedBox(height: 10),
            const Divider(color: Colors.white, height: 3),
            titleResult("Info Client"),
            infoResult("Nom : " + myClient!.name),
            infoResult("Adresse : " + myClient!.adress),
            infoResult("Activité : " + myClient!.activite),
            infoResult("Téléphone : " + myClient!.phone)
          ]);

  FittedBox infoResult(String msg) => FittedBox(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(msg,
              textAlign: TextAlign.center,
              style: GoogleFonts.abel(fontSize: 20, color: Colors.white))));

  FittedBox titleResult(String msg) => FittedBox(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(msg,
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.abel(fontSize: 40, color: Colors.tealAccent))));

  Container btnVerifier() => Container(
      margin: EdgeInsets.symmetric(horizontal: Data.widthScreen / 20),
      alignment: Alignment.center,
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: ElevatedButton(
              focusNode: nVerifier,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return const Color.fromARGB(255, 179, 76, 161);
                } else if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return const Color.fromARGB(255, 165, 15, 107);
              }), minimumSize: MaterialStateProperty.resolveWith<Size>(
                  (Set<MaterialState> states) {
                return const Size.fromHeight(72);
              }), textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                  (Set<MaterialState> states) {
                return const TextStyle(fontSize: 24, color: Colors.white);
              })),
              onPressed: verifierNS,
              child: Text("Vérifier",
                  style: GoogleFonts.abel(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      fontSize: 24)))));

  ConstrainedBox resultField(TextEditingController txtNS) => ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 170),
      child: TextField(
          cursorColor: Colors.black,
          controller: txtNS,
          enabled: false,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 2),
          maxLength: 6,
          maxLines: 1,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              focusColor: Colors.amber,
              border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 5, color: Colors.black)),
              contentPadding: const EdgeInsets.only(bottom: 3),
              fillColor: Colors.grey.shade300,
              filled: true)));

  verifierNS() {
    setState(() {
      genererActivation = false;
    });

    if (ns[0].length == 6 && ns[1].length == 6 ||
        ns[2].length == 6 ||
        ns[3].length == 5) {
      verifierCD();
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

  verifierCD() {
    ns1 = ns[0];
    ns2 = ns[1];
    ns3 = ns[2];
    ns4 = ns[3];
    pSeq = ns3.substring(4, 5) +
        ns3.substring(3, 4) +
        ns1.substring(4, 5) +
        ns1.substring(1, 2) +
        ns2.substring(4, 5) +
        ns4.substring(4, 5) +
        ns2.substring(2, 3);

    print("pSeq=$pSeq");
    existSequence();
  }

  existSequence() async {
    setState(() {
      workingMessage = "Vérification en cours ... ";
      working = true;
    });
    String serverIP = Data.getServerIP();
    print("serverIP=$serverIP");
    if (serverIP != "") {
      String serverDir = Data.getServerDirectory();
      final String url = "$serverDir/EXIST_SEQUENCE.php";
      print(url);
      Uri myUri = Uri.parse(url);
      http.post(myUri, body: {"SEQUENCE": pSeq}).then((response) async {
        if (response.statusCode == 200) {
          var responsebody = jsonDecode(response.body);
          idCD = 0;
          for (var m in responsebody) {
            idCD = int.parse(m['ID_CD']);
          }
          if (idCD == 0) {
            setState(() {
              working = false;
            });
            AwesomeDialog(
                    width: min(Data.widthScreen, 400),
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Sequence invalide !!!')
                .show();
          } else {
            print("Its Ok ----- Connected ----------------");
            print("ID_CD = $idCD");
            String vlch = ns3.substring(0, 1) +
                ns2.substring(5, 6) +
                ns1.substring(0, 1) +
                ns2.substring(0, 1);
            if (ns1.substring(3, 4) != "a") {
              vlch += ns1.substring(3, 4);
            }
            if (ns4.substring(2, 3) != "a") {
              vlch += ns4.substring(2, 3);
            }
            if (ns3.substring(1, 2) != "a") {
              vlch += ns3.substring(1, 2);
            }
            if (ns2.substring(3, 4) != "a") {
              vlch += ns2.substring(3, 4);
            }
            if (ns4.substring(1, 2) != "a") {
              vlch += ns4.substring(1, 2);
            }
            int pMac = decrypterSystem36(vlch);
            mac = decrypterMAC(pMac);
            print("mac = $mac");
            txtMac.text = mac;

            vlch =
                ns2.substring(1, 2) + ns1.substring(2, 3) + ns4.substring(3, 4);
            if (ns4.substring(0, 1) != "a") {
              vlch += ns4.substring(0, 1);
            }
            if (ns3.substring(5, 6) != "a") {
              vlch += ns3.substring(5, 6);
            }
            if (ns3.substring(2, 3) != "a") {
              vlch += ns3.substring(2, 3);
            }
            if (ns1.substring(5, 6) != "a") {
              vlch += ns1.substring(5, 6);
            }
            disque = decrypterSystem36(vlch);
            print("Disque = $disque");
            txtDisque.text = disque.toString();

            String numProduit = pSeq.substring(0, 2);
            print("numProduit = $numProduit");

            vlch = pSeq.substring(2, 3);
            idVersion = getNumber(vlch);
            print("idVersion = $idVersion");

            vlch = pSeq.substring(3, 4);
            annee = getNumber(vlch) + 2017;
            print("annee = $annee");

            pSeq = pSeq.substring(pSeq.length - 3, pSeq.length);
            print("pSeq = $pSeq");

            existActivation();
          }
        } else {
          setState(() {
            working = false;
          });
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme lors de la connexion avec le serveur !!!')
              .show();
        }
      }).catchError((error) {
        print("erreur : $error");
        setState(() {
          working = false;
        });
        print("error : ${e.toString()}");
        AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                showCloseIcon: true,
                title: 'Erreur',
                desc: 'Probleme de Connexion avec le serveur !!!')
            .show();
      });
    } else {
      setState(() {
        working = false;
      });
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: 'Erreur',
              desc:
                  'Adresse de serveur introuvable \n Configuer les paramêtres !!!')
          .show();
    }
  }

  existActivation() async {
    String serverIP = Data.getServerIP();
    if (serverIP != "") {
      String serverDir = Data.getServerDirectory();
      final String url = "$serverDir/EXIST_ACTIVATION.php";
      print(url);
      Uri myUri = Uri.parse(url);
      http.post(myUri, body: {"ID_CD": idCD.toString()}).then((response) async {
        if (response.statusCode == 200) {
          var responsebody = jsonDecode(response.body);
          active = 0;
          for (var m in responsebody) {
            active = int.parse(m['ACTIVE']);
            prix = double.parse(m['PRIX']);
          }
          if (active == 0) {
            myClient = await openClientDialog();
            if (myClient != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sequence valide !!!")));
              genererNumActivation();
              setState(() {
                working = false;
                genererActivation = true;
              });
            } else {
              setState(() {
                working = false;
              });
            }
          } else {
            setState(() {
              working = false;
            });
            AwesomeDialog(
                    width: min(Data.widthScreen, 400),
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Numéro de CD déjà activé !!!')
                .show();
          }
        } else {
          setState(() {
            working = false;
          });
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme lors de la connexion avec le serveur !!!')
              .show();
        }
      }).catchError((error) {
        print("erreur : $error");
        setState(() {
          working = false;
        });
        print("error : ${e.toString()}");
        AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                showCloseIcon: true,
                title: 'Erreur',
                desc: 'Probleme de Connexion avec le serveur !!!')
            .show();
      });
    } else {
      setState(() {
        working = false;
      });
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: 'Erreur',
              desc:
                  'Adresse de serveur introuvable \n Configuer les paramêtres !!!')
          .show();
    }
  }

  Future<Client?> openClientDialog() => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
              title: const Text("Info Client",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      decoration: TextDecoration.underline)),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.name,
                    onSubmitted: (_) => btnOk,
                    controller: txtNameClient,
                    autofocus: true,
                    decoration:
                        const InputDecoration(hintText: 'Nom du client')),
                TextField(
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    onSubmitted: (_) => btnOk,
                    controller: txtAdressClient,
                    autofocus: true,
                    decoration:
                        const InputDecoration(hintText: 'Adresse du client')),
                TextField(
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    onSubmitted: (_) => btnOk,
                    controller: txtActitiveClient,
                    autofocus: true,
                    decoration:
                        const InputDecoration(hintText: 'Acitivité du client')),
                TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.phone,
                    onSubmitted: (_) => btnOk,
                    controller: txtPhoneClient,
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintText: 'N° de Télephone du client')),
              ]),
              actions: [
                TextButton(onPressed: btnOk, child: const Text("Ok")),
                TextButton(
                    onPressed: btnCancel,
                    child: const Text("Annuler",
                        style: TextStyle(color: Colors.red)))
              ]));

  btnOk() {
    if (txtNameClient.text.isNotEmpty) {
      Client c = Client(
          name: txtNameClient.text,
          adress: txtAdressClient.text,
          activite: txtActitiveClient.text,
          phone: txtPhoneClient.text);
      Navigator.of(context).pop(c);

      txtAdressClient.clear();
      txtNameClient.clear();
      txtPhoneClient.clear();
    }
  }

  btnCancel() {
    Navigator.of(context).pop(null);
  }

  String system36New(int pnum) {
    int num = pnum;
    String reste = "";
    if (num == 0) {
      reste = getAlphabetNew(num);
    }
    late int r;
    late String rr;
    while (num != 0) {
      r = num % 36;
      rr = getAlphabetNew(r);
      reste = rr + reste;
      num = num ~/ 36;
    }
    return reste;
  }

  String getActivaton(String pch) => system36New(getNumber(pch));

  genererNumActivation() {
    setState(() {
      workingMessage = "Géneration du numéro d'activation en cours ... ";
    });

    nAct1 = "";
    nAct1 += getActivaton(ns2.substring(0, 1));
    nAct1 += getActivaton(ns2.substring(3, 4));
    nAct1 += getActivaton(ns2.substring(5, 6));
    nAct1 += getActivaton(ns2.substring(1, 2));
    nAct1 += getActivaton(ns2.substring(2, 3));
    nAct1 += getActivaton(ns2.substring(4, 5));
    print("nAct1=$nAct1");
    txtnAct1.text = nAct1;
    // ------------------------------------------------------
    nAct2 = "";
    nAct2 += getActivaton(ns3.substring(2, 3));
    nAct2 += getActivaton(ns3.substring(0, 1));
    nAct2 += getActivaton(ns3.substring(4, 5));
    nAct2 += getActivaton(ns3.substring(5, 6));
    nAct2 += getActivaton(ns3.substring(1, 2));
    nAct2 += getActivaton(ns3.substring(3, 4));
    print("nAct2=$nAct2");
    txtnAct2.text = nAct2;
    // ------------------------------------------------------
    nAct3 = "";
    nAct3 += getActivaton(ns1.substring(5, 6));
    nAct3 += getActivaton(ns1.substring(1, 2));
    nAct3 += getActivaton(ns1.substring(2, 3));
    nAct3 += getActivaton(ns1.substring(3, 4));
    nAct3 += getActivaton(ns1.substring(4, 5));
    nAct3 += getActivaton(ns1.substring(0, 1));
    print("nAct3=$nAct3");
    txtnAct3.text = nAct3;
    // ------------------------------------------------------
    nAct4 = "";
    nAct4 += getActivaton(ns4.substring(1, 2));
    nAct4 += getActivaton(ns4.substring(4, 5));
    nAct4 += getActivaton(ns4.substring(0, 1));
    nAct4 += getActivaton(ns4.substring(2, 3));
    nAct4 += getActivaton(ns4.substring(3, 4));
    print("nAct4=$nAct4");
    txtnAct4.text = nAct4;
  }

  String decrypterMAC(int imac) {
    String pmacN = imac.toRadixString(16).toUpperCase();
    int j = 0;
    String ch = "";
    int vltaille = pmacN.length;
    for (var i = 1; i <= vltaille; i++) {
      ch = pmacN.substring(i - 1, i);
      if (ch == "0") {
        j++;
      } else {
        break;
      }
    }
    String pmacNew = "";
    if (j == 0) {
      pmacNew = pmacN;
    } else {
      pmacNew = pmacN.substring(j, vltaille);
    }
    while (pmacNew.length < 12) {
      pmacNew = "0" + pmacNew;
    }
    pmacNew = pmacNew.substring(0, 2) +
        ":" +
        pmacNew.substring(2, 4) +
        ":" +
        pmacNew.substring(4, 6) +
        ":" +
        pmacNew.substring(6, 8) +
        ":" +
        pmacNew.substring(8, 10) +
        ":" +
        pmacNew.substring(10, 12);
    return pmacN;
  }

  int decrypterSystem36(String vlmac) {
    int pMac = 0;
    late int r, vlpuiss;
    int vltaille = vlmac.length;
    String ch = "";
    for (var i = vltaille; i >= 1; i--) {
      ch = vlmac.substring(i - 1, i);
      r = unGetAlphabet(ch);
      vlpuiss = vltaille - i;
      pMac += r * pow(36, vlpuiss).toInt();
    }
    return pMac;
  }

  int getNumber(String num) {
    switch (num) {
      case "0":
        return 0;
      case "1":
        return 1;
      case "2":
        return 2;
      case "3":
        return 3;
      case "4":
        return 4;
      case "5":
        return 5;
      case "6":
        return 6;
      case "7":
        return 7;
      case "8":
        return 8;
      case "9":
        return 9;
      case "A":
        return 10;
      case "B":
        return 11;
      case "C":
        return 12;
      case "D":
        return 13;
      case "E":
        return 14;
      case "F":
        return 15;
      case "G":
        return 16;
      case "H":
        return 17;
      case "I":
        return 18;
      case "J":
        return 19;
      case "K":
        return 20;
      case "L":
        return 21;
      case "M":
        return 22;
      case "N":
        return 23;
      case "O":
        return 24;
      case "P":
        return 25;
      case "Q":
        return 26;
      case "R":
        return 27;
      case "S":
        return 28;
      case "T":
        return 29;
      case "U":
        return 30;
      case "V":
        return 31;
      case "W":
        return 32;
      case "X":
        return 33;
      case "Y":
        return 34;
      case "Z":
        return 35;
      default:
        return 0;
    }
  }

  String getAlphabetNew(int num) {
    switch (num) {
      case 0:
        return "T";
      case 1:
        return "P";
      case 2:
        return "L";
      case 3:
        return "W";
      case 4:
        return "S";
      case 5:
        return "7";
      case 6:
        return "R";
      case 7:
        return "Z";
      case 8:
        return "6";
      case 9:
        return "2";
      case 10:
        return "J";
      case 11:
        return "9";
      case 12:
        return "O";
      case 13:
        return "Y";
      case 14:
        return "U";
      case 15:
        return "3";
      case 16:
        return "G";
      case 17:
        return "X";
      case 18:
        return "1";
      case 19:
        return "A";
      case 20:
        return "F";
      case 21:
        return "V";
      case 22:
        return "E";
      case 23:
        return "0";
      case 24:
        return "5";
      case 25:
        return "M";
      case 26:
        return "B";
      case 27:
        return "H";
      case 28:
        return "4";
      case 29:
        return "N";
      case 30:
        return "D";
      case 31:
        return "8";
      case 32:
        return "K";
      case 33:
        return "C";
      case 34:
        return "I";
      case 35:
        return "Q";
      default:
        return "";
    }
  }

  int unGetAlphabet(String num) {
    switch (num) {
      case "0":
        return 29;
      case "1":
        return 21;
      case "2":
        return 17;
      case "3":
        return 35;
      case "4":
        return 25;
      case "5":
        return 7;
      case "6":
        return 19;
      case "7":
        return 14;
      case "8":
        return 2;
      case "9":
        return 32;
      case "A":
        return 9;
      case "B":
        return 0;
      case "C":
        return 3;
      case "D":
        return 6;
      case "E":
        return 12;
      case "F":
        return 16;
      case "G":
        return 22;
      case "H":
        return 28;
      case "I":
        return 23;
      case "J":
        return 31;
      case "K":
        return 26;
      case "L":
        return 30;
      case "M":
        return 13;
      case "N":
        return 10;
      case "O":
        return 8;
      case "P":
        return 20;
      case "Q":
        return 11;
      case "R":
        return 24;
      case "S":
        return 5;
      case "T":
        return 34;
      case "U":
        return 33;
      case "V":
        return 27;
      case "W":
        return 15;
      case "X":
        return 18;
      case "Y":
        return 1;
      case "Z":
        return 4;
      default:
        return 0;
    }
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
            enabled: !working && !genererActivation,
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

class Client {
  String name, adress, activite, phone;
  Client(
      {required this.name,
      required this.activite,
      required this.adress,
      required this.phone});
}
