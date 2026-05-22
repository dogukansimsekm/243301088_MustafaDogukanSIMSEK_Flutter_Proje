import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'urun_ekle.dart';
import 'urun_detay.dart';
import 'profil_ekrani.dart'; 

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final supabase = Supabase.instance.client;
  List<dynamic> _urunler = [];
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _urunleriGetir();
  }

  Future<void> _urunleriGetir() async {
    try {
      final data = await supabase.from('urunler').select();
      setState(() {
        _urunler = data;
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() {
        _urunler = [];
        _yukleniyor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El Emeği Ürünler'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, size: 30),
            onPressed: () {
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilEkrani()),
              );
            },
          )
        ],
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : _urunler.isEmpty
              ? const Center(child: Text('Henüz ürün eklenmemiş.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _urunler.length,
                  itemBuilder: (context, index) {
                    final mevcutUrun = _urunler[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.shopping_bag, color: Colors.blue, size: 40),
                        title: Text(mevcutUrun['baslik'] ?? 'İsimsiz Ürün', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${mevcutUrun['fiyat']} TL', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UrunDetayEkrani(urun: mevcutUrun)),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final sonuc = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UrunEkleEkrani()),
          );
          if (sonuc == true) {
            setState(() => _yukleniyor = true);
            _urunleriGetir();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 