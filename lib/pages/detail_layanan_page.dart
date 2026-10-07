import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pengajuan_model.dart';

class DetailLayananPage extends StatefulWidget {
  final Map<String, String> layanan;

  const DetailLayananPage({
    super.key,
    required this.layanan,
  });

  @override
  State<DetailLayananPage> createState() => _DetailLayananPageState();
}

class _DetailLayananPageState extends State<DetailLayananPage> {
  bool _sedangMengajukan = false;

  Future<void> _ajukanPermohonan() async {
    final namaLayanan = widget.layanan['nama'] ?? 'Layanan';

    // setState digunakan untuk mengubah status sementara tombol
    setState(() {
      _sedangMengajukan = true;
    });

    // Simulasi proses pengajuan
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Simpan pengajuan ke PengajuanModel
    context.read<PengajuanModel>().tambahPengajuan(namaLayanan);

    // Kembalikan status pengajuan ke halaman sebelumnya
    Navigator.pop(
      context,
      'Permohonan $namaLayanan telah diajukan',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Layanan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon layanan
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.miscellaneous_services,
                  size: 45,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Nama layanan
            Text(
              widget.layanan['nama'] ?? 'Nama Layanan',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // Dinas
            _infoLayanan(
              icon: Icons.account_balance,
              judul: 'Instansi Penanggung Jawab',
              isi: widget.layanan['dinas'] ?? '-',
            ),

            const SizedBox(height: 18),

            // Jam pelayanan
            _infoLayanan(
              icon: Icons.access_time,
              judul: 'Jam Pelayanan',
              isi: widget.layanan['jam'] ?? '-',
            ),

            const SizedBox(height: 18),

            // Deskripsi
            _infoLayanan(
              icon: Icons.info_outline,
              judul: 'Deskripsi',
              isi: widget.layanan['keterangan'] ?? '-',
            ),

            const SizedBox(height: 35),

            // Tombol pengajuan
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _sedangMengajukan
                    ? null
                    : _ajukanPermohonan,
                icon: _sedangMengajukan
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _sedangMengajukan
                      ? 'Mengajukan...'
                      : 'Ajukan Permohonan',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.blue.shade300,
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoLayanan({
    required IconData icon,
    required String judul,
    required String isi,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 25,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isi,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}