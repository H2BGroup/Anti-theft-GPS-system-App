import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atgs_app/app.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  
    @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  TextEditingController deviceNumberController = TextEditingController(text: '+');
  TextEditingController ownersNumberController = TextEditingController(text: '+');
  TextEditingController datePickerController = TextEditingController();
  static const String dateKey = "selectedDate";
  static const String deviceNumberKey = "deviceNumber";
  static const String ownersNumberKey = "ownersNumber";

  void saveDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(dateKey, date);
  }

  void saveDeviceNumber(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(deviceNumberKey, number);
  }

  void saveOwnersNumber(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(ownersNumberKey, number);
  }

  void loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDate = prefs.getString(dateKey);
    String? savedDeviceNumber = prefs.getString(deviceNumberKey);
    String? savedOwnersNumber = prefs.getString(ownersNumberKey);

    if (savedDate != null) { setState(() {datePickerController.text = savedDate; }); }
    if (savedDeviceNumber != null) { setState(() {deviceNumberController.text = savedDeviceNumber; }); }
    if (savedOwnersNumber != null) { setState(() {ownersNumberController.text = savedOwnersNumber; }); }
  }

  void handleNumberControllers() {
    deviceNumberController.addListener(() {
      final text = deviceNumberController.text;
        if (!text.startsWith('+')) {
          deviceNumberController.text = '+${text.replaceAll('+', '')}';
          deviceNumberController.selection = TextSelection.fromPosition(
            TextPosition(offset: deviceNumberController.text.length),
          );
        } 
        else if (text == '+') {
          deviceNumberController.selection = TextSelection.fromPosition(
            const TextPosition(offset: 1),
          );
        }
        saveDeviceNumber(deviceNumberController.text);
    });

    ownersNumberController.addListener(() {
      final text = ownersNumberController.text;
        if (!text.startsWith('+')) {
          ownersNumberController.text = '+${text.replaceAll('+', '')}';
          ownersNumberController.selection = TextSelection.fromPosition(
            TextPosition(offset: ownersNumberController.text.length),
          );
        } 
        else if (text == '+') {
          ownersNumberController.selection = TextSelection.fromPosition(
            const TextPosition(offset: 1),
          );
        }
        saveOwnersNumber(ownersNumberController.text);
    });
  }

  onTapDatePicker({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime(2030),
      firstDate: DateTime(2024),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    datePickerController.text = DateFormat('dd MMMM, yyyy').format(pickedDate);
    saveDate(DateFormat('dd MMMM, yyyy').format(pickedDate));
  }

@override
  void initState() {
    super.initState();
    loadSavedData(); 
    handleNumberControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 90),
        child: Center(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              constraints: const BoxConstraints(maxHeight: 570),
              width: 330,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(25), border: Border.all(color: darkestBlue, width: 5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Profile settings", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    width: 330,
                    decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 3)),
                    child: Column(
                      children: [
                        Text( "Device phone number", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 240,
                              height: 80,
                              child: 
                              TextField(
                                controller: deviceNumberController,
                                style: TextStyle(fontWeight: FontWeight.w700, foreground: Paint() ..color = Colors.white, fontSize: 20),
                                cursorColor: darkestBlue,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                ],
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: darkestBlue, width: 2.0)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: darkestBlue, width: 2.0)),
                                  counterText: ''
                                ),
                                maxLength: 14,
                              )
                            )
                          ]
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    width: 330,
                    decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 3)),
                    child: Column(
                      children: [
                        Text( "Owner's phone number", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 240,
                              height: 80,
                              child: 
                              TextField(
                                controller: ownersNumberController,
                                style: TextStyle(fontWeight: FontWeight.w700, foreground: Paint() ..color = Colors.white, fontSize: 20),
                                cursorColor: darkestBlue,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                ],
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: darkestBlue, width: 2.0)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: darkestBlue, width: 2.0)),
                                  counterText: ''
                                ),
                                maxLength: 14,
                              )
                            )
                          ]
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: 330,
                    decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 3)),
                    child: Column(
                      children: [
                        Text( "Subscription expires on", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 250,
                          height: 75,
                          child: 
                            TextField(
                                style: TextStyle(fontWeight: FontWeight.w700, foreground: Paint() ..color = Colors.white, fontSize: 20),
                                cursorColor: darkestBlue,
                                textAlign: TextAlign.center,
                                controller: datePickerController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: darkestBlue, width: 2.0)),
                                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: darkestBlue, width: 2.0)),                 
                                  hintText: "Click here to select date",
                                  hintStyle: TextStyle(fontWeight: FontWeight.w500, foreground: Paint() ..color = Colors.white, fontSize: 20, fontStyle: FontStyle.italic)
                                  ),
                                onTap: () => onTapDatePicker(context: context),
                              )
                        )
                      ]
                    )
                  )
                ]
              )
            )
          )
      )
      )
    );
  }
}