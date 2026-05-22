import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UrunEkleEkrani extends StatefulWidget {
  const UrunEkleEkrani({super.key});

  @override
  State<UrunEkleEkrani> createState() => _UrunEkleEkraniState();
}

class _UrunEkleEkraniState extends State<UrunEkleEkrani> {
  final _baslikController = TextEditingController();
  final _fiyatController = TextEditingController();
  final _aciklamaController = TextEditingController();
  bool _yukleniyor = false;
  final supabase = Supabase.instance.client;

  Future<void> _urunKaydet() async {
    if (_baslikController.text.isEmpty || _fiyatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Başlık ve fiyat zorunludur!')));
      return;
    }
    
    setState(() => _yukleniyor = true);
    
    try {
      await supabase.from('urunler').insert({
        'baslik': _baslikController.text.trim(),
        'fiyat': double.tryParse(_fiyatController.text.trim()) ?? 0,
        'aciklama': _aciklamaController.text.trim(),
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ürün başarıyla eklendi!')));
        Navigator.pop(context, true); 
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    } finally {
      setState(() => _yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni El Emeği Ürün Ekle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.add_circle_outline, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            TextField(
              controller: _baslikController, 
              decoration: const InputDecoration(labelText: 'Ürün Başlığı (Örn: Örgü Atkı)', border: OutlineInputBorder())
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _fiyatController, 
              keyboardType: TextInputType.number, 
              decoration: const InputDecoration(labelText: 'Fiyat (TL)', border: OutlineInputBorder())
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _aciklamaController, 
              maxLines: 4, 
              decoration: const InputDecoration(labelText: 'Ürün Açıklaması ve Detayları', border: OutlineInputBorder())
            ),
            const SizedBox(height: 24),
            _yukleniyor 
              ? const CircularProgressIndicator() 
              : ElevatedButton(
                  onPressed: _urunKaydet,
                  
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), padding: const EdgeInsets.all(16)),
                  child: const Text('ÜRÜNÜ YAYINLA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                )
          ],
        ),
      ),
    );
  }
}