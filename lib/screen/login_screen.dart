import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testemos/service/login_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController(text:"");
    _passwordController = TextEditingController(text:"");
    super.initState();
  }

  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<loginAuth>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Login'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  controller: _emailController,
                  validator: (value) => validateEmail(value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  controller: _passwordController,
                  obscureText: true,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: MaterialButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        if(!await _user.signIn(_emailController.text,_passwordController.text)){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed')));
                        }
                      }
                    },
                    child: Text('Login'),
                    ),
                )
            ],
          ),
        ),
      ),
    );
  }
}