import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/technician.dart';
import 'package:service_app/screens/home.dart';
import 'package:service_app/screens/login_signup_page.dart';
import 'package:service_app/services/authentication.dart';

class RootPage extends StatefulWidget {
  final BaseAuth auth;

  RootPage({this.auth});

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user?.getUid();
        authStatus = _userId != null && _userId.length > 0
            ? AuthStatus.LOGGED_IN
            : AuthStatus.NOT_LOGGED_IN;
        if (user != null) {
          FirebaseRepository.init(Technician(_userId, "Techniker",
              user.getLogIn(), "+491629835793", "Lieferwagen"));
        }
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.getUid();
        authStatus = AuthStatus.LOGGED_IN;
      });
//      TODO add inputs for the hard coded strings
      FirebaseRepository.init(Technician(_userId, "Techniker", user.getLogIn(),
          "+491629835793", "Lieferwagen"));
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = null;
    });
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildLoadingScreen();
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignUpPage(widget.auth, _onLoggedIn);
      case AuthStatus.LOGGED_IN:
        if (_userId != null && _userId.length > 0) {
          return new HomePage(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
          );
        }
        return _buildLoadingScreen();
      default:
        return _buildLoadingScreen();
    }
  }
}
