
import 'package:flutter/material.dart';
import 'package:flutter_technical_task/constants/constants.dart';
import 'package:flutter_technical_task/helpers/helper.dart';
import 'package:flutter_technical_task/providers/auth_provider.dart';
import 'package:flutter_technical_task/widgets/rounded_textfield.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  void initState(){
    super.initState();
    txtPhone.text='+971501977439';
    txtPass.text='1132456';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 75,
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Login to your Account',style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),),
                    Utilities.verticalSpace(height: 17),
                    RoundedTextField(
                      controller: txtPhone,
                      hintText: 'Username or phone number',

                    ),
                    Utilities.verticalSpace(height: 17),
                    RoundedTextField(
                      controller: txtPass,
                      hintText: 'Password',
                    ),
                    Utilities.verticalSpace(),
                    Consumer<AuthProvider>(
                      builder: (context,provider,child){
                        if(provider.status==AuthStatus.LOADING){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ButtonTheme(
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimens.BUTTON_BORDER)
                          ),
                          padding: EdgeInsets.all(15),
                          buttonColor: Colors.green,
                          textTheme: ButtonTextTheme.primary,
                          child: RaisedButton(
                            onPressed: (){
                              provider.loginUser(txtPhone.text, txtPass.text,context);
                            },
                            child: Text('Login'),
                          ),
                        );
                      },
                    ),
                    Utilities.verticalSpace(height: 18),
                    Center(
                      child: Text('Forgot your password?',style: Theme.of(context).textTheme.bodyText1.copyWith(color:
                      Theme.of(context).primaryColor),),
                    )
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            flex: 25,
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t have an account?',
                  style: Theme.of(context).textTheme.bodyText2,
                  children: [
                    TextSpan(
                      text: ' Register',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(color:
                        Theme.of(context).primaryColor)
                    )
                  ]
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
