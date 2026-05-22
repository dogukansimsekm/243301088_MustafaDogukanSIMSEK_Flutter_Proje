import 'package:flutter/material.dart';

class UrunDetayEkrani extends StatelessWidget {
  final Map<String, dynamic> urun;
  

  const UrunDetayEkrani({super.key, required this.urun});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(urun['baslik'] ?? 'Ürün Detayı')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Icon(Icons.shopping_bag, size: 120, color: Colors.blue)),
            const SizedBox(height: 30),
            Text(urun['baslik'] ?? 'İsimsiz Ürün', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('${urun['fiyat']} TL', style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold)),
            const Divider(height: 40, thickness: 2),
            const Text('Açıklama:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(urun['aciklama'] ?? 'Bu ürün için henüz bir açıklama girilmemiş.', style: const TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}