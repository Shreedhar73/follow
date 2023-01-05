import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:follow/features/authentication/blocs/login_bloc.dart';
import 'package:follow/injection_container/injection.dart';
import 'package:follow/screens/home_page.dart';


typedef OAuthSignIn = void Function();



/// Helper class to show a snackbar using the passed context.
class ScaffoldSnackbar {
  // ignore: public_member_api_docs
  ScaffoldSnackbar(this._context);

  /// The scaffold of current context.
  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }

  final BuildContext _context;

  /// Helper method to show a SnackBar.
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

/// The mode of the current auth session, either [AuthMode.login] or [AuthMode.register].
enum AuthMode { login, register, phone }

extension on AuthMode {
  String get label => this == AuthMode.login
      ? 'Sign in'
      : this == AuthMode.phone
          ? 'Sign in'
          : 'Register';
}

/// Entrypoint example for various sign-in flows with Firebase.
class AuthGate extends StatefulWidget {
  // ignore: public_member_api_docs
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';
  String verificationId = '';

  AuthMode mode = AuthMode.login;
  late LoginBloc _bloc;


  late Map<Buttons, OAuthSignIn> authButtons;

  @override
  void initState() {
    _bloc = sl<LoginBloc>();
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: BlocListener<LoginBloc,LoginState>(
          bloc: _bloc,
          listener: (context,state){
            if(state is LoginSuccess){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomePage()));
            }else if(state is LoginLoading){
              showDialog(
                context: context, 
                barrierColor: Colors.transparent,
                builder: (context) => const Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(color: Colors.white,),
                  ),
                ) 
              );
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration:  const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white54,
                Colors.blueGrey]
              )
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SafeArea(
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: error.isNotEmpty,
                            child: MaterialBanner(
                              backgroundColor: Theme.of(context).errorColor,
                              content: Text(error),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      error = '';
                                    });
                                  },
                                  child: const Text(
                                    'dismiss',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                              contentTextStyle:
                                  const TextStyle(color: Colors.white),
                              padding: const EdgeInsets.all(10),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (mode != AuthMode.phone)
                            Column(
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    hintText: 'Email',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      value != null && value.isNotEmpty
                                          ? null
                                          : 'Required',
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Password',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      value != null && value.isNotEmpty
                                          ? null
                                          : 'Required',
                                ),
                              ],
                            ),
                          if (mode == AuthMode.phone)
                            TextFormField(
                              controller: phoneController,
                              decoration: const InputDecoration(
                                hintText: '+12345678910',
                                labelText: 'Phone number',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value != null && value.isNotEmpty
                                      ? null
                                      : 'Required',
                            ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: (){},
                                   
                              child:Text(mode.label),
                            ),
                          ),
                          TextButton(
                            onPressed: (){},
                            child: const Text('Forgot password?'),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: SignInButton(
                                Buttons.Google,
                                onPressed: (){
                                  _bloc.add(const LoginUserEvent());
                                },
                              ),
                            ),
                            ),
                         
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed:  () {
                                      if (mode != AuthMode.phone) {
                                        setState(() {
                                          mode = AuthMode.phone;
                                        });
                                      } else {
                                        setState(() {
                                          mode = AuthMode.login;
                                        });
                                      }
                                    },
                              child: Text(
                                      mode != AuthMode.phone
                                          ? 'Sign in with Phone Number'
                                          : 'Sign in with Email and Password',
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (mode != AuthMode.phone)
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyText1,
                                children: [
                                  TextSpan(
                                    text: mode == AuthMode.login
                                        ? "Don't have an account? "
                                        : 'You have an account? ',
                                  ),
                                  TextSpan(
                                    text: mode == AuthMode.login
                                        ? 'Register now'
                                        : 'Click to login',
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        setState(() {
                                          mode = mode == AuthMode.login
                                              ? AuthMode.register
                                              : AuthMode.login;
                                        });
                                      },
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyText1,
                              children: [
                                const TextSpan(text: 'Or '),
                                TextSpan(
                                  text: 'continue as guest',
                                  style: const TextStyle(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (){},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}

Future<String?> getSmsCodeFromUser(BuildContext context) async {
  String? smsCode;

  // Update the UI - wait for the user to enter the SMS code
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('SMS code:'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Sign in'),
          ),
          OutlinedButton(
            onPressed: () {
              smsCode = null;
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
        content: Container(
          padding: const EdgeInsets.all(20),
          child: TextField(
            onChanged: (value) {
              smsCode = value;
            },
            textAlign: TextAlign.center,
            autofocus: true,
          ),
        ),
      );
    },
  );

  return smsCode;
}