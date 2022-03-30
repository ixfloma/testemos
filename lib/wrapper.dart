import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:testemos/screen/login_screen.dart';
import 'package:testemos/service/login_auth.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => loginAuth.instance(),
      child: Consumer(builder: (context, loginAuth user, _) {
      switch(user.status){
        case Status.Uninitialized:
          return const Splash();
        case Status.Unauthenticated:
        case Status.Authenticating:
          return const LoginPage();
        case Status.Authenticated:
          return HomePage(user: user.user);
      }
    }));
  }
}

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({ Key? key, this.user }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String getCurrentTime(){
    var now = DateTime.now();
    String formattetime = DateFormat('hh:mm').format(now);
    return formattetime;
  }

  String getTime(){
    var now = DateTime.now();
    String formattetime = DateFormat('hh').format(now);
    int waktu = int.parse(formattetime);
    if(waktu>=6 && waktu<=11){
      return "Selamat Pagi";
    }
    else if(waktu>=12 && waktu<=15){
      return "Selamat Siang";
    }
    else if(waktu>=16 && waktu<=18){
      return "Selamat Sore";
    }
    else if(waktu>=19 && waktu<=23){
      return "Selamat Malam";
    }
    else{
      return "Selamat Pagi";
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = '';
    if(widget.user != null){
      var split = widget.user!.email!.split('@');
      name = split[0];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Masuk'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          (widget.user == null) ? Text('User: null') : (widget.user!.email == null) ? Text('Email: null') : Center(child: Text('Email: ${widget.user!.email}')),
          Center(child: Text(getTime()),),
          Center(
            child: Text('Selamat datang $name'),
          ),
          Center(
            child: Text('Waktu sekarang: ${getCurrentTime()}'),
          ),
          Center(
            child: MaterialButton(
              child: Text('Logout'),
              onPressed: () {
                Provider.of<loginAuth>(context, listen: false).signOut();
              },
            ),
          ),
        ],
      )
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const CircularProgressIndicator(),
    );
  }
}