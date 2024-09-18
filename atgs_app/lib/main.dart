import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter/material.dart';
import 'package:atgs_app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'message_service.dart';
import 'package:introduction_screen/introduction_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterIsolate.spawn(startMessageService, null);
  runApp(const MyApp());
}

void startMessageService(_) {
  receiveMessage();
  sendMessage("location");
  sendMessage("status");
  sendMessage(deviceArmed);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    checkifInitialized();
  }

  Future<void> checkifInitialized() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedisInitialized = prefs.getBool("isInitialized");

    if(savedisInitialized != null) {
      setState(() {
        isInitialized = savedisInitialized;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        scaffoldBackgroundColor: backgroundColor,
        textSelectionTheme: const TextSelectionThemeData(selectionHandleColor: darkestBlue)
      ),
      home: (isInitialized) ? const AppView() : const IntroductionView()
    );
  }
}

class IntroductionView extends StatefulWidget {
  const IntroductionView({super.key});

  @override
  IntroductionViewState createState() => IntroductionViewState();
}

class IntroductionViewState extends State<IntroductionView> {
  TextEditingController deviceNumberController = TextEditingController(text: '+');
  TextEditingController ownersNumberController = TextEditingController(text: '+');

  final introKey = GlobalKey<IntroductionScreenState>();
  int currentPageIndex = 0;
  bool nextButtonAllowed = false;

  void saveInitializedStatus(bool isInitialized) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isInitialized", isInitialized);
  }

  void saveDeviceNumber(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("deviceNumber", number);
  }

  void saveOwnersNumber(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("ownersNumber", number);
  }

  void loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savedDeviceNumber = prefs.getString("deviceNumber");
    String? savedOwnersNumber = prefs.getString("ownersNumber");

    if (savedDeviceNumber != null) { setState(() {deviceNumberController.text = savedDeviceNumber; }); }
    if (savedOwnersNumber != null) { setState(() {ownersNumberController.text = savedOwnersNumber; }); }
  }

  void allowNextButton() {
    if(currentPageIndex == 1 && deviceNumberController.text == "+") {
      setState(() { nextButtonAllowed = false; });
    }
    else if(currentPageIndex == 1 && deviceNumberController.text != "+") {
      setState(() { nextButtonAllowed = true; });
    }

    if(currentPageIndex == 2 && ownersNumberController.text == "+") {
      setState(() { nextButtonAllowed = false; });
    }
    else if(currentPageIndex == 2 && ownersNumberController.text != "+") {
      setState(() { nextButtonAllowed = true; });
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
        allowNextButton();
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
        allowNextButton();
    });
  }

  List<PageViewModel> introductionPages(){
    return [
      PageViewModel(
        image: Image.asset('assets/introduction_background.png', fit: BoxFit.cover, width: double.infinity),
        titleWidget: Text("Welcome!",
            style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w900, letterSpacing: 2.5,
              shadows: [Shadow(offset: const Offset(5.0, 5.0), blurRadius: 20.0, color: Colors.black.withOpacity(0.8))]
            )
        ),
        bodyWidget: Column(
          children: [
            Text("We are here to help you track and locate your bike",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900,
                shadows: [Shadow(offset: const Offset(4.0, 4.0), blurRadius: 20.0, color: Colors.black.withOpacity(0.8))]
              )
            ),
            const SizedBox(height: 40),
            ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    side: const BorderSide(color: introductionLight, width: 5),
                    backgroundColor: darkBlue
                  ),
                  onPressed: () { introKey.currentState?.next(); },
                  child: Text("Let's pair your device",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900,
                      shadows: [Shadow(offset: const Offset(4.0, 4.0), blurRadius: 20.0, color: Colors.black.withOpacity(0.8))]
                    )
                  )
            )
          ]
        )
      ),
      PageViewModel(
        image: Image.asset('assets/introduction_background.png', fit: BoxFit.cover, width: double.infinity),
        titleWidget: Text("Enter your device's phone number", textAlign: TextAlign.center, style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 28, fontWeight: FontWeight.w900,
          shadows: [Shadow(offset: const Offset(4.0, 4.0), blurRadius: 20.0, color: Colors.black.withOpacity(0.8))])
        ),
        bodyWidget: Container(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
          width: 330,
          decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(25),border: Border.all(color: introductionLight, width: 4)),
          child: Column(
            children: [
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
                      cursorColor: introductionDark,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        prefixIcon: Icon(Icons.phone, color: introductionDark, size: 38),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: introductionDark, width: 4.0)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: introductionDark, width: 4.0)),
                        counterText: ''
                      ),
                      maxLength: 14,
                    )
                  )
                ]
              )
            ]
          )
        )
      ),
      PageViewModel(
        image: Image.asset('assets/introduction_background.png', fit: BoxFit.cover, width: double.infinity),      
        titleWidget: Text("Enter your phone number", textAlign: TextAlign.center, style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 28, fontWeight: FontWeight.w900,
          shadows: [Shadow(offset: const Offset(4.0, 4.0), blurRadius: 20.0, color: Colors.black.withOpacity(0.8))])
        ),
        bodyWidget: Container(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
          width: 330,
          decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(25),border: Border.all(color: introductionLight, width: 4)),
          child: Column(
            children: [
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
                      cursorColor: introductionDark,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        prefixIcon: Icon(Icons.phone_android, color: introductionDark, size: 36),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: introductionDark, width: 4.0)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: introductionDark, width: 4.0)),
                        counterText: ''
                      ),
                      maxLength: 14,
                    )
                  )
                ]
              )
            ]
          )
        )    
      )
    ];
  }

  @override
  void initState() {
    super.initState(); 
    handleNumberControllers();
    loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        key: introKey,
        pages: introductionPages(),
        back: Container(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 2)),
          child: Image.asset('assets/arrow-narrow-left.png', color: Colors.white, fit: BoxFit.cover, width: 50),
        ),
        next: (currentPageIndex == 0) ? Container() : Container(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 2)),
          child: Image.asset('assets/arrow-narrow-right.png', color: Colors.white, fit: BoxFit.cover, width: 50),
        ),
        done: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 2)),
          child: Text("Start!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700,
            shadows: [Shadow( offset: const Offset(4.0, 4.0), blurRadius: 20.0, color: Colors.black.withOpacity(0.8))])
          )
        ),
        onDone: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AppView()));
          saveInitializedStatus(true);
        },
        onChange: (index) {
          setState(() { currentPageIndex = index; });
          allowNextButton();
        },
        globalBackgroundColor: introductionDark,
        showSkipButton: false,
        showNextButton: (nextButtonAllowed) ? true : false,
        showDoneButton: (nextButtonAllowed) ? true : false,
        showBackButton: true,
        dotsDecorator: DotsDecorator(
          activeColor: backgroundColor,
          color: introductionLight,
          size: const Size(20.0, 10.0),
          activeSize: const Size(40.0, 10.0),
          activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))
        )
      )
    );
  }
}
