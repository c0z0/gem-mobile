import 'package:Gem/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';

import 'package:Gem/styles.dart' show TextStyles, Space;
import 'package:Gem/components/button.dart' show PrimaryButton;
import 'package:Gem/components/input.dart' show Input;
import 'package:Gem/utlis.dart' show checkForUpdate;
import 'package:Gem/components/spinning_diamond.dart';

class LoginScreen extends StatefulWidget {
  createState() => _LoginScreenState();
}

const _googleLoginMutation = """
   mutation Login(\$token: String!) {
    googleLogin(token: \$token) {
      token
    }
  }
""";

const _sendEmailMutation = """
  mutation Login(\$email: String!) {
  login(email: \$email) {
    id
    verificationCode   
  }
}
""";

const _checkLoginQuery = """
query CheckLogin(\$id: ID!) {
  checkLogin(id: \$id) {
    token
    pending
  }
}
""";

class _LoginScreenState extends State<LoginScreen> {
  var _email = '';
  var _verificationCode;
  var _loginId;
  bool _hasEmailApp = false;
  TextEditingController _inputController = TextEditingController();

  @override
  initState() {
    _inputController.addListener(_onEmailChange);
    checkForUpdate(context);
    _checkEmailAppAvailability();

    super.initState();
  }

  @override
  dispose() {
    _inputController.dispose();
    super.dispose();
  }

  _onEmailChange() {
    setState(() {
      _email = _inputController.text;
    });
  }

  _onLoginIdChange(id, verificationCode) {
    setState(() {
      _loginId = id;
      _verificationCode = verificationCode;
    });
  }

  _undoLogin() {
    setState(() {
      _verificationCode = null;
      _loginId = null;
    });
  }

  _onVerified(BuildContext context, String token) async {
    SharedPreferences storage = await SharedPreferences.getInstance();

    storage.setString('session', token);

    Navigator.of(context).pushReplacementNamed('/gems');
  }

  Widget _buildForm() {
    return Mutation(
      options: MutationOptions(
        document: _googleLoginMutation,
      ),
      onCompleted: (dynamic res) {
        _onVerified(context, res['googleLogin']['token']);
      },
      builder: (
        RunMutation runGoogleLoginMutation,
        QueryResult googleLoginResult,
      ) {
        return Mutation(
          options: MutationOptions(
            document: _sendEmailMutation,
          ),
          onCompleted: (dynamic res) {
            _onLoginIdChange(
                res['login']['id'], res['login']['verificationCode']);
          },
          builder: (
            RunMutation runMutation,
            QueryResult result,
          ) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Welcome,',
                  style: TextStyles.title,
                ),
                Text(
                  'sign in to get started',
                  style: TextStyles.subtitle,
                ),
                Space.med,
                Input(
                  controller: _inputController,
                  hintText: 'you@domain.com',
                  keyboardType: TextInputType.emailAddress,
                  autoFocus: true,
                  onSubmitted: (s) {
                    if (_email.length > 0) runMutation({'email': _email});
                  },
                ),
                Space.sml,
                PrimaryButton(
                  onPressed: () {
                    runMutation({'email': _email});
                  },
                  text: result.loading || googleLoginResult.loading
                      ? 'Loading...'
                      : 'Continue',
                  disabled: _email.length == 0 ||
                      result.loading ||
                      googleLoginResult.loading,
                ),
                Space.sml,
                RichText(
                  softWrap: true,
                  text: TextSpan(
                    style: TextStyles.text,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign in with Google',
                        style: TextStyle(
                          color: GemColors.purple,
                        ),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () async {
                            GoogleSignIn _googleSignIn = GoogleSignIn(
                              scopes: [
                                'email',
                              ],
                            );
                            GoogleSignInAccount res =
                                await _googleSignIn.signIn();
                            GoogleSignInAuthentication auth =
                                await res.authentication;
                            runGoogleLoginMutation({'token': auth.idToken});
                          },
                      ),
                    ],
                  ),
                ),
                Space.sml,
                result.errors != null
                    ? Text('Something went wrong', style: TextStyles.error)
                    : null,
              ].where((t) => t != null).toList(),
            );
          },
        );
      },
    );
  }

  _launchEmailApp() async {
    await AppAvailability.launchApp(
        Platform.isIOS ? "message://" : "com.google.android.gm");
  }

  _checkEmailAppAvailability() async {
    try {
      await AppAvailability.checkAvailability(
          Platform.isIOS ? "message://" : "com.google.android.gm");
      setState(() {
        _hasEmailApp = true;
      });
    } on PlatformException catch (_) {
      setState(() {
        _hasEmailApp = false;
      });
    }
  }

  Widget _buildAwaitingVerification(BuildContext context) {
    return Query(
      options: QueryOptions(
          document: _checkLoginQuery,
          variables: {'id': _loginId},
          pollInterval: 1),
      builder: (QueryResult result, {VoidCallback refetch}) {
        if (!result.loading && result.errors == null) {
          var pending = result.data['checkLogin']['pending'];

          if (!pending) {
            _onVerified(context, result.data['checkLogin']['token']);
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Awaiting Verification',
              style: TextStyles.title,
              textDirection: TextDirection.ltr,
            ),
            Space.sml,
            RichText(
              softWrap: true,
              text: TextSpan(
                style: TextStyles.text,
                children: <TextSpan>[
                  TextSpan(text: 'We sent an email to '),
                  TextSpan(text: '$_email', style: TextStyles.bold),
                  TextSpan(text: ' ('),
                  TextSpan(
                    text: 'undo',
                    style: TextStyle(
                      color: GemColors.purple,
                    ),
                    recognizer: new TapGestureRecognizer()..onTap = _undoLogin,
                  ),
                  TextSpan(text: ').'),
                ],
              ),
            ),
            Space.sml,
            RichText(
              softWrap: true,
              text: TextSpan(
                style: TextStyles.text,
                children: <TextSpan>[
                  TextSpan(
                      text:
                          'Please log in to your inbox, verify that the provided security code matches the following text: '),
                  TextSpan(text: '$_verificationCode', style: TextStyles.bold),
                  TextSpan(text: '.'),
                ],
              ),
            ),
            Space.med,
            _hasEmailApp
                ? PrimaryButton(
                    text: 'Open email app',
                    onPressed: _launchEmailApp,
                  )
                : null,
          ].where((w) => w != null).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).size.height * .20;

    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 48, right: 48, top: topPadding),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SpinningDiamond(
                    constantSpeed: .5,
                  ),
                  Space.lrg,
                  _verificationCode != null
                      ? _buildAwaitingVerification(context)
                      : _buildForm(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
