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

  Color subscriptionDateTextColor = Colors.white;
  Icon subscriptionDateWarningIcon = const Icon(Icons.check_circle_rounded, color: Color.fromARGB(255, 1, 109, 5));


  void saveDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedDate", date);
  }

  void saveDeviceNumber(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("deviceNumber", number);

    if(number == "+") { await prefs.setBool("isInitialized", false); }
    else { await prefs.setBool("isInitialized", true);  }
  }

  void saveOwnersNumber(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("ownersNumber", number);

    if(number == "+") { await prefs.setBool("isInitialized", false); }
    else { await prefs.setBool("isInitialized", true); }
  }

  void savesubscriptionDateTextColorAndIcon(Color color, Icon icon) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int colorValue = color.value;
    await prefs.setInt("subscriptionDateTextColorKey", colorValue);

    String iconString = icon.icon!.codePoint.toString();
    await prefs.setString('subscriptionDateWarningIconName', iconString);

    int iconColor = icon.color!.value;
    await prefs.setInt("subscriptionDateWarningIconColor", iconColor);
  }

  void loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDate = prefs.getString("selectedDate");
    String? savedDeviceNumber = prefs.getString("deviceNumber");
    String? savedOwnersNumber = prefs.getString("ownersNumber");

    int? colorValue = prefs.getInt("subscriptionDateTextColorKey");
    String? iconName = prefs.getString('subscriptionDateWarningIconName');
    int? iconColor = prefs.getInt('subscriptionDateWarningIconColor');

    if (savedDate != null) { setState(() {datePickerController.text = savedDate; }); }
    if (savedDeviceNumber != null) { setState(() {deviceNumberController.text = savedDeviceNumber; }); }
    if (savedOwnersNumber != null) { setState(() {ownersNumberController.text = savedOwnersNumber; }); }
    if (colorValue != null) { setState(() {subscriptionDateTextColor = Color(colorValue); }); }
    if (iconName != null && iconColor != null) { setState(() {subscriptionDateWarningIcon = Icon(IconData(int.parse(iconName), fontFamily: 'MaterialIcons'), color: Color(iconColor),); }); }
  
  
    if (datePickerController.text.isNotEmpty) {
    if( DateFormat("dd MMMM, yyyy").parse(datePickerController.text, true).isBefore(DateTime.now())){
      setState(() {
        subscriptionDateTextColor = Colors.red; 
        subscriptionDateWarningIcon = const Icon(Icons.warning, color: Colors.red);
        });
    }
    else {
      setState(() {
        subscriptionDateTextColor = Colors.white; 
        subscriptionDateWarningIcon = const Icon(Icons.check_circle_rounded, color: Color.fromARGB(255, 1, 109, 5));
        });
    }
    savesubscriptionDateTextColorAndIcon(subscriptionDateTextColor, subscriptionDateWarningIcon);
  }
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDate = prefs.getString("selectedDate");
    DateTime? subscriptionDate;
    if(savedDate != null) {subscriptionDate = DateFormat("dd MMMM, yyyy").parse(savedDate, true);}
    DateTime? pickedDate = await showDatePicker(
      // ignore: use_build_context_synchronously
      context: context,
      lastDate: DateTime(2030),
      firstDate: DateTime(2024),
      initialDate: (subscriptionDate != null) ? subscriptionDate : DateTime.now(),
    );
    if (pickedDate == null) return;
    datePickerController.text = DateFormat('dd MMMM, yyyy').format(pickedDate);
    subscriptionDate = DateFormat("dd MMMM, yyyy").parse(datePickerController.text, true);

    if(subscriptionDate.isBefore(DateTime.now())){
      setState(() {
        subscriptionDateTextColor = Colors.red; 
        subscriptionDateWarningIcon = const Icon(Icons.warning, color: Colors.red);
        });
    }
    else {
      setState(() {
        subscriptionDateTextColor = Colors.white; 
        subscriptionDateWarningIcon = const Icon(Icons.check_circle_rounded, color: Color.fromARGB(255, 1, 109, 5));
        });
    }
    saveDate(DateFormat('dd MMMM, yyyy').format(pickedDate));
    savesubscriptionDateTextColorAndIcon(subscriptionDateTextColor, subscriptionDateWarningIcon);
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
                  const SizedBox(height: 30),

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
                              height: 70,
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
                                  contentPadding: EdgeInsets.all(8.0),
                                  prefixIcon: Icon(Icons.phone, color: darkestBlue, size: 38),
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
                  const SizedBox(height: 35),

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
                              height: 70,
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
                                  contentPadding: EdgeInsets.all(8.0),
                                  prefixIcon: Icon(Icons.phone_android, color: darkestBlue, size: 36),
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
                  const SizedBox(height: 35),

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
                          height: 65,
                          child: 
                            TextField(
                                style: TextStyle(fontWeight: FontWeight.w700, foreground: Paint() ..color = subscriptionDateTextColor, fontSize: 20),
                                cursorColor: darkestBlue,
                                textAlign: TextAlign.center,
                                controller: datePickerController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8.0),
                                  suffixIcon: (datePickerController.text != "") ? subscriptionDateWarningIcon : null,
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