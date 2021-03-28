import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'Speechtotext.dart';

class DemoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  bool isAuthenticated = false;

  get strongpasscode => '123456';

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Passcode Application')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You are ${isAuthenticated ? '' : 'not'}'
              ' authenticated',
              style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 10,
            ),
            _lockScreenButton(context),
          ],
        ),
      ),
    );
  }

  _lockScreenButton(BuildContext context) => MaterialButton(
        padding: EdgeInsets.only(left: 50, right: 50),
        color: Theme.of(context).primaryColor,
        child: Text(
          'Unlock Application',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
        ),
        onPressed: () {
          _showLockScreen(
            context,
            opaque: false,
            cancelButton: Text(
              'Cancel',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              semanticsLabel: 'Cancel',
            ),
          );
        },
      );

  _showLockScreen(BuildContext context,
      {bool opaque,
      CircleUIConfig circleUIConfig,
      KeyboardUIConfig keyboardUIConfig,
      Widget cancelButton,
      List<String> digits}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: opaque,
        pageBuilder: (context, animation, secondaryAnimation) => PasscodeScreen(
          title: Text(
            'Enter Passcode',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          circleUIConfig: circleUIConfig,
          keyboardUIConfig: keyboardUIConfig,
          passwordEnteredCallback: _passcodeEntered,
          cancelButton: cancelButton,
          deleteButton: Text(
            'Delete',
            style: const TextStyle(fontSize: 16, color: Colors.white),
            semanticsLabel: 'Delete',
          ),
          shouldTriggerVerification: _verificationNotifier.stream,
          backgroundColor: Colors.black.withOpacity(0.8),
          cancelCallback: _passcodeCancelled,
          digits: digits,
          passwordDigits: 6,
        ),
      ),
    );
  }

  _passcodeEntered(String enteredPasscode) {
    bool isValid = strongpasscode == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(
        () {
          this.isAuthenticated = isValid;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Speechtotext();
              },
            ),
          );
        },
      );
    }
  }

  _passcodeCancelled() {
    Navigator.maybePop(context);
  }
}
