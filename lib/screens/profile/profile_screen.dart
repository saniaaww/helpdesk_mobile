import 'package:flutter/material.dart';
import '../../data/data_dummy.dart';
import '../auth/login_page.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String role;
  
  const ProfileScreen({super.key, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    // Statistik sederhana dari Data Dummy
    int total = DataDummy.tickets.length;
    int selesai = DataDummy.tickets.where((t) => t['status'] == "Done").length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profil Pengguna", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header Profil (Teal Background)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 60, color: Colors.teal),
                ),
                const SizedBox(height: 15),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(role, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),

          // Statistik Singkat
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Total Tiket", total.toString()),
                _buildStatItem("Selesai", selesai.toString()),
              ],
            ),
          ),

          const Divider(thickness: 1, indent: 20, endIndent: 20),

          // Menu List (Bisa di-klik)
          Expanded(
            child: ListView(
              children: [
                _profileMenu(Icons.history, "Riwayat Aktivitas", () {
                  // Tambahkan aksi klik di sini
                  _showInfo(context, "Membuka Riwayat...");
                }),
                _profileMenu(Icons.lock_outline, "Ubah Password", () {
                  _showInfo(context, "Membuka Menu Keamanan...");
                }),
                _profileMenu(Icons.help_outline, "Pusat Bantuan", () {
                  _showInfo(context, "Menghubungi Support...");
                }),
                const SizedBox(height: 20),
                
                // Tombol Logout
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (_) => const LoginPage()), 
                        (route) => false
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text("Keluar Aplikasi", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk List Menu
  Widget _profileMenu(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Widget untuk Statistik
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Fungsi snackbar buat tanda kalau menu diklik
  void _showInfo(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }
}