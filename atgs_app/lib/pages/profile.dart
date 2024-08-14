import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atgs_app/app.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  
    @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  TextEditingController datePickerController = TextEditingController();
  static const String dateKey = "selectedDate";

  void saveDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(dateKey, date);
  }

  void loadSavedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDate = prefs.getString(dateKey);
    if (savedDate != null) {
      setState(() {
        datePickerController.text = savedDate;
      });
    }
  }

  onTapFunction({required BuildContext context}) async {
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
    loadSavedDate(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(top: 50),
            constraints: const BoxConstraints(maxHeight: 570),
            width: 330,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(25), border: Border.all(color: darkestBlue, width: 5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Profile settings", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(height: 60),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 330,
                  decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 3)),
                  child: Column(
                    children: [
                      Text( "Device phone number", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 50),
                          const Badge(isLabelVisible: false, child: Icon(Icons.phone_in_talk, color: darkestBlue, size: 35)),
                          const SizedBox(width: 10),
                          Text( deviceNumber, style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)), 
                        ]
                      )
                    ]
                  )
                ),
                const SizedBox(height: 90),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 330,
                  decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 3)),
                  child: Column(
                    children: [
                      Text( "Subscription expires on", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
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
                              onTap: () => onTapFunction(context: context),
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
    );
  }
}