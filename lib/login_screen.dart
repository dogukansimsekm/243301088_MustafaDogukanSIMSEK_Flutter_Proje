import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final _emailController = TextEditingController();
  final _sifreController = TextEditingController();
  String _secilenRol = 'Alici'; 
  bool _yukleniyor = false;

  final supabase = Supabase.instance.client;

  Future<void> _girisYap() async {
    setState(() => _yukleniyor = true);
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _sifreController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Giriş Başarılı!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AnaSayfa()),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Giriş Başarısız: Şifre veya E-posta hatalı')));
    } finally {
      setState(() => _yukleniyor = false);
    }
  }

  Future<void> _kayitOl() async {
    setState(() => _yukleniyor = true);
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _sifreController.text.trim(),
      );
      
      if (res.user != null) {
        await supabase.from('profiller').insert({
          'id': res.user!.id,
          'rol': _secilenRol,
          'eposta': _emailController.text.trim(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kayıt Başarılı! Şimdi giriş yapabilirsiniz.')));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kayıt Hatası: $e')));
    } finally {
      setState(() => _yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El Emeği - Kayıt & Giriş'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.handshake, size: 80, color: Colors.blue),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta Adresi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _sifreController,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _secilenRol,
                items: ['Alici', 'Satici'].map((rol) => DropdownMenuItem(value: rol, child: Text(rol == 'Alici' ? 'Alıcı' : 'Satıcı'))).toList(),
                onChanged: (val) => setState(() => _secilenRol = val!),
                decoration: const InputDecoration(
                  labelText: 'Kayıt Olacaklar İçin Rol Seçimi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 24),
              _yukleniyor 
                ? const Center(child: CircularProgressIndicator()) 
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        // ElevatedButton için style kısmı
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Köşeleri yuvarladık
                          elevation: 5,
                        ),
                        onPressed: _girisYap, 
                        child: const Text('GİRİŞ YAP', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        onPressed: _kayitOl, 
                        child: const Text('YENİ HESAP OLUŞTUR', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}