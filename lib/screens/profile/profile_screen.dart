import 'package:flutter/material.dart';
import '../../data/data_dummy.dart'; // Mengambil data asli
import '../auth/login_page.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String role;

  const ProfileScreen({super.key, required this.name, required this.role});

  Color _getRoleColor() {
    // Pakai contains biar lebih sakti ngeceknya
    String r = role.toLowerCase();

    if (r.contains('admin')) {
      return const Color(0xFF0E458E); // FIX BIRU ADMIN
    } else if (r.contains('helpdesk')) {
      return const Color(0xFFC97E00); // FIX ORANYE HELPDESK
    } else {
      return const Color(0xFF00796D); // FIX IJO USER
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = _getRoleColor();

    // --- AMBIL DATA LANGSUNG DARI DATABASE DUMMY (BIAR GAK BERANTAKAN) ---
    // Menghitung total tiket yang ada di sistem
    int totalTiket = DataDummy.tickets.length;

    // Menghitung tiket yang statusnya "Done" secara real-time dari DB
    int tiketSelesai = DataDummy.tickets.where((t) => t['status'] == "Done").length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profil Pengguna", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Header Profil
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 60, color: primaryColor),
                ),
                const SizedBox(height: 15),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(role.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 2.0)),
              ],
            ),
          ),

          // Statistik (Sesuai Data di Database)
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Total Tiket", totalTiket.toString(), primaryColor),
                _buildStatItem("Selesai", tiketSelesai.toString(), primaryColor),
              ],
            ),
          ),

          const Divider(thickness: 1, indent: 20, endIndent: 20),

          // Menu List
          Expanded(
            child: ListView(
              children: [
                _profileMenu(Icons.history, "Riwayat Aktivitas", primaryColor),
                _profileMenu(Icons.lock_outline, "Ubah Password", primaryColor),
                _profileMenu(Icons.help_outline, "Pusat Bantuan", primaryColor),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                            (route) => false
                    ),
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

  Widget _profileMenu(IconData icon, String title, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}