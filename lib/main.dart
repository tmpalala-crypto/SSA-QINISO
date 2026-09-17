import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() => runApp(const QINISOApp());

class QINISOApp extends StatefulWidget {
  const QINISOApp({super.key});
  @override
  State<QINISOApp> createState() => _QINISOAppState();
}

class _QINISOAppState extends State<QINISOApp> {
  int idx = 0;
  final pages = [const FactoryQR(), const BrandPage(), const DeptPage(), const MapPage(), const SapsPage()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: pages[idx],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: idx,
          selectedItemColor: const Color(0xFF0D3B66),
          onTap: (i)=> setState(()=> idx=i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR Factory'),
            BottomNavigationBarItem(icon: Icon(Icons.branding_watermark), label: '50 Brands'),
            BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Depts'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.local_police), label: 'SAPS'),
          ],
        ),
      ),
    );
  }
}

// QR FACTORY - WITH YOUR LOGO INSIDE QR!
class FactoryQR extends StatefulWidget { const FactoryQR({super.key}); @override State<FactoryQR> createState() => _FactoryQRState(); }
class _FactoryQRState extends State<FactoryQR> {
  final prod = TextEditingController(text: 'MANGO JUICE 500ml');
  final batch = TextEditingController(text: 'B001');
  final shop = TextEditingController(text: 'SPAR Bethelsdorp');
  final qty = TextEditingController(text: '4');
  List<String> codes = [];

  void gen() {
    int q = int.tryParse(qty.text)?? 4;
    setState((){ codes = List.generate(q, (i)=> 'QIN-${batch.text}-${DateTime.now().millisecondsSinceEpoch + i}'); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(children:[Image.asset('assets/logo.png', height:32, errorBuilder:(c,e,s)=> const Icon(Icons.shield, color: Colors.white)), const SizedBox(width:8), const Text('QINISO - QR FACTORY')]), backgroundColor: const Color(0xFF0D3B66)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children:[
        Image.asset('assets/logo.png', height:90, errorBuilder:(c,e,s)=> const Icon(Icons.shield, size:80, color: Color(0xFF0D3B66))),
        const Text('SECURE • VERIFIED • ANTI-COUNTERFEIT • OFFICIAL', style: TextStyle(fontSize:9, fontWeight:FontWeight.bold, color: Colors.brown)),
        const SizedBox(height:16),
        TextField(controller: prod, decoration: const InputDecoration(labelText:'Product', border: OutlineInputBorder())),
        const SizedBox(height:8),
        TextField(controller: batch, decoration: const InputDecoration(labelText:'Batch', border: OutlineInputBorder())),
        const SizedBox(height:8),
        TextField(controller: shop, decoration: const InputDecoration(labelText:'Shop', border: OutlineInputBorder())),
        const SizedBox(height:8),
        TextField(controller: qty, decoration: const InputDecoration(labelText:'Qty', border: OutlineInputBorder()), keyboardType: TextInputType.number),
        const SizedBox(height:12),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D3B66), minimumSize: const Size(double.infinity, 50)), onPressed: gen, child: const Text('GENERATE QR WITH LOGO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        const SizedBox(height:20),
        Wrap(spacing:12, runSpacing:12, children: codes.map((c){
          String data = '$c | ${prod.text} | ${shop.text} | VERIFIED';
          return Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF0D3B66)), borderRadius: BorderRadius.circular(10)), child: Column(children:[
            QrImageView(
              data: data,
              version: QrVersions.auto,
              size: 140,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(color: Color(0xFF0D3B66)),
              dataModuleStyle: const QrDataModuleStyle(color: Color(0xFF0D3B66)),
              embeddedImage: const AssetImage('assets/logo.png'),
              embeddedImageStyle: QrEmbeddedImageStyle(size: Size(30,30)),
            ),
            SizedBox(width:140, child: Text(c, style: const TextStyle(fontSize:7, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
            SizedBox(width:140, child: Text(prod.text, style: const TextStyle(fontSize:7), textAlign: TextAlign.center, maxLines:1)),
          ]));
        }).toList())
      ])),
    );
  }
}

class BrandPage extends StatelessWidget { const BrandPage({super.key}); @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: const Text('50 BRANDS BOARD'), backgroundColor: const Color(0xFF0D3B66)), body: const Center(child: Text('Private IDs per Brand\nKOO, COKE, SASKO etc\nAuto Alert to each brand!'))); }}
class DeptPage extends StatelessWidget { const DeptPage({super.key}); @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: const Text('DEPTS AUTO ALERT'), backgroundColor: Colors.blue[800]), body: const Center(child: Text('HEALTH, CIPC, SARS, VAT, SAPS, NCC\nAuto Alert when chain break!'))); }}
class MapPage extends StatelessWidget { const MapPage({super.key}); @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: const Text('MAP - GPS Suspect'), backgroundColor: Colors.orange[800]), body: const Center(child: Text('Map: Bethelsdorp\nGPS: -33.92, 25.57\nRed dot = Suspect location'))); }}
class SapsPage extends StatelessWidget { const SapsPage({super.key}); @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: const Text('SAPS CASE PROOF'), backgroundColor: Colors.black), body: const Center(child: Text('Chain Break = SAPS Case\nPapers + Stock scanned\nEvidence proof attached!'))); }}
