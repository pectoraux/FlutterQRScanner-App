import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'auth.dart';
import 'color_override.dart';
import 'constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/animation.dart';
import 'animated_logo.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}


class _LoginPageState extends State<LoginPage>   with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();
  }

  static final formKey = new GlobalKey<FormState>();
  var _login = GlobalKey(debugLabel: 'Login');
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool active = true;
  String _authHint = 'Type in your details and press the Login button';




  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = await widget.auth.signIn(_usernameController.text, _passwordController.text);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
        });
        widget.onSignIn();

      }
      catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  Widget hintText() {
    return new Container(
      //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(
            _authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center)
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TodoColors.baseColors[0],
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
//                SizedBox(height: 100.0),
//                Image.asset('assets/diamond.png',),
//                new Container(
//                  width: _iconAnimation.value,
//                    height: _iconAnimation.value,
//                    decoration: new BoxDecoration(
//      color: Colors.purple,
//      gradient: new RadialGradient(
//        colors: [Colors.red, Colors.cyan, Colors.purple, TodoColors.baseColors[0]],
//        center: Alignment(-0.7, -0.6),
//        radius: 0.2,
//        tileMode: TileMode.clamp,
//        stops: [0.3, 0.5, 0.6, 0.7]
//      ),
//    ),
//                    child:new FlutterLogo(), //Image.asset('assets/diamond.png',),
//                    new FlutterLogo(
//                      size: _iconAnimation.value*140.0,
//
//                      textColor: Colors.red,
//                    )
//                ),
                SizedBox(height: 20.0),
          AnimatedLogo(animation: animation, message: 'LATERITE', factor: 2.9,),

              ],
            ),
            Form(
              key: formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:<Widget>[
                  SizedBox(height: 12.0),
                  PrimaryColorOverride(
                    color: kShrineBrown900,
                    child: TextFormField(
                      key: new Key('Username'),
                      autocorrect: false,
                      controller: _usernameController,
                      validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
                      onSaved: (val) => _usernameController.text = val,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: CutCornersBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  new PrimaryColorOverride(
                    color: kShrineBrown900,
                    child: TextFormField(
                      key: new Key('password'),
                      obscureText: true,
                      autocorrect: false,
                      controller: _passwordController,
                      validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
                      onSaved: (val) => _passwordController.text = val,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: CutCornersBorder(),
                      ),
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text('CANCEL',),
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        onPressed: () {
                          _usernameController.clear();
                          _passwordController.clear();
                        },
                      ),
                      active? RaisedButton(
                          child: Text('LOG IN', style: TextStyle(color: TodoColors.baseColors[0]),),
                          elevation: 8.0,
                          key: _login,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          ),
                          onPressed: (){
                            validateAndSubmit();
                          }
                      ):Content,
                    ],
                  ),],),
            ),
            hintText()

          ],
        ),
      ),
    );
  }

  Widget Content;

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}