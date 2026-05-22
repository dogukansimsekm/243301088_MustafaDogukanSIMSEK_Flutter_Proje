import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart'; 

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  

  await Supabase.initialize(
    url: 'URL-KISMI',
    anonKey: 'KEY_KISMI',
  );

  runApp(const ElEmegiUygulamasi());
}

class ElEmegiUygulamasi extends StatelessWidget {
  const ElEmegiUygulamasi({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'El Emeği Sistemi',
       theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue, 
      home: const GirisEkrani(),
    );
  }

}