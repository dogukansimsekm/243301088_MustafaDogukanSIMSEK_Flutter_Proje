import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';

class ProfilEkrani extends StatefulWidget {
  const ProfilEkrani({super.key});

  @override
  State<ProfilEkrani> createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  final user = Supabase.instance.client.auth.currentUser;
  String _rol = 'Yükleniyor...';

  @override
  void initState() {
    super.initState();
    _profilGetir();
  }

  Future<void> _profilGetir() async {
    if (user == null) return;
    try {
      final data = await Supabase.instance.client
          .from('profiller')
          .select('rol')
          .eq('id', user!.id)
          .single();
      setState(() {
        _rol = data['rol'] ?? 'Bilinmiyor';
      });
    } catch (e) {
      setState(() {
        _rol = 'Satıcı (Varsayılan)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profilim')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20, width: double.infinity),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text('E-posta: ${user?.email ?? "Bilinmiyor"}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Rolünüz: $_rol', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Çıkış Yap', style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const GirisEkrani()),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}