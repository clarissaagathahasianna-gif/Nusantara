import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pengajuan_model.dart';
import '../pages/beranda_page.dart';
import '../pages/layanan_page.dart';
import '../pages/warga_page.dart';
import 'app_routes.dart';

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int _index = 0;

  final List<Widget> _halaman = const [
    BerandaPage(),
    LayananPage(),
    WargaPage(),
  ];

  void _ubahHalaman(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double lebarLayar = MediaQuery.of(context).size.width;

    // Breakpoint tugas: 600 logical pixels
    final bool layarLebar = lebarLayar >= 600;

    // Hanya mengambil jumlah pengajuan.
    // Bagian navigasi lainnya tidak perlu bergantung pada seluruh model.
    final int totalPengajuan = context.select<PengajuanModel, int>(
      (model) => model.totalPengajuan,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nusantara Cerdas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      // =========================
      // NAVIGATION DRAWER
      // =========================
      drawer: NavigationDrawer(
        onDestinationSelected: (index) {
          // Tutup drawer terlebih dahulu
          Navigator.pop(context);

          if (index == 0) {
            // Beranda
            _ubahHalaman(0);
          } else if (index == 1) {
            // Layanan
            _ubahHalaman(1);
          } else if (index == 2) {
            // Warga
            _ubahHalaman(2);
          } else if (index == 3) {
            // Pengaturan Kota
            Navigator.pushNamed(
              context,
              AppRoutes.pengaturanKota,
            );
          } else if (index == 4) {
            // Tentang Aplikasi
            Navigator.pushNamed(
              context,
              AppRoutes.tentangAplikasi,
            );
          } else if (index == 5) {
            // Keluar
            _tampilkanDialogKeluar(context);
          }
        },
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 20, 16, 12),
            child: Text(
              'Nusantara Cerdas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const NavigationDrawerDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: Text('Beranda'),
          ),

          const NavigationDrawerDestination(
            icon: Icon(Icons.miscellaneous_services_outlined),
            selectedIcon: Icon(Icons.miscellaneous_services),
            label: Text('Layanan'),
          ),

          NavigationDrawerDestination(
            icon: _ikonWarga(Icons.person_outline, totalPengajuan),
            selectedIcon: _ikonWarga(Icons.person, totalPengajuan),
            label: const Text('Warga'),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Divider(),
          ),

          const NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: Text('Pengaturan Kota'),
          ),

          const NavigationDrawerDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: Text('Tentang Aplikasi'),
          ),

          const NavigationDrawerDestination(
            icon: Icon(Icons.logout),
            selectedIcon: Icon(Icons.logout),
            label: Text('Keluar'),
          ),
        ],
      ),

      // =========================
      // RESPONSIVE CONTENT
      // =========================
      body: Row(
        children: [
          // Layar >= 600px
          if (layarLebar)
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: _ubahHalaman,
              labelType: NavigationRailLabelType.all,
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Beranda'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.miscellaneous_services_outlined),
                  selectedIcon: Icon(Icons.miscellaneous_services),
                  label: Text('Layanan'),
                ),
                NavigationRailDestination(
                  icon: _ikonWarga(Icons.person_outline, totalPengajuan),
                  selectedIcon: _ikonWarga(Icons.person, totalPengajuan),
                  label: const Text('Warga'),
                ),
              ],
            ),

          // Konten halaman
          Expanded(
            child: _halaman[_index],
          ),
        ],
      ),

      // =========================
      // NAVIGATION BAR
      // =========================
      bottomNavigationBar: layarLebar
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: _ubahHalaman,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Beranda',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.miscellaneous_services_outlined),
                  selectedIcon: Icon(Icons.miscellaneous_services),
                  label: 'Layanan',
                ),
                NavigationDestination(
                  icon: _ikonWarga(Icons.person_outline, totalPengajuan),
                  selectedIcon: _ikonWarga(Icons.person, totalPengajuan),
                  label: 'Warga',
                ),
              ],
            ),
    );
  }

  // =========================
  // IKON WARGA + BADGE
  // =========================
  Widget _ikonWarga(
    IconData icon,
    int totalPengajuan,
  ) {
    return Badge(
      isLabelVisible: totalPengajuan > 0,
      label: Text('$totalPengajuan'),
      child: Icon(icon),
    );
  }

  // =========================
  // DIALOG KELUAR
  // =========================
  void _tampilkanDialogKeluar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keluar'),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari aplikasi?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}