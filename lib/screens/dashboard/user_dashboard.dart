import 'package:flutter/material.dart';
import '../../data/data_dummy.dart';
import '../tickets/ticket_detail_page.dart';
import '../auth/login_page.dart';
import '../tickets/create_ticket_page.dart';
import '../profile/profile_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  // Variabel lokal untuk mengontrol tema di halaman ini saja
  bool _isLocalDarkMode = false;

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Notifikasi Terkini"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _notiItem(context, "Status Diperbarui", "Tiket TK-001 sedang diproses", 0),
              _notiItem(context, "Pesan Baru", "Admin membalas pesan Anda", 1),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup"))
        ],
      ),
    );
  }

  Widget _notiItem(BuildContext context, String title, String sub, int index) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.teal, 
        child: Icon(Icons.notifications, color: Colors.white, size: 18)
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
      onTap: () async {
        Navigator.pop(context);
        await Navigator.push(context, MaterialPageRoute(builder: (_) => TicketDetailPage(index: index, role: 'user')));
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definisi warna berdasarkan state _isLocalDarkMode
    Color bgColor = _isLocalDarkMode ? const Color(0xFF121212) : Colors.white;
    Color headerColor = _isLocalDarkMode ? const Color(0xFF1F1F1F) : Colors.teal;
    Color cardColor = _isLocalDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = _isLocalDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = _isLocalDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: headerColor,
        title: const Text("Tiket Saya", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          // TOMBOL TOGGLE DARK MODE LOKAL
          IconButton(
            icon: Icon(_isLocalDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
            onPressed: () {
              setState(() {
                _isLocalDarkMode = !_isLocalDarkMode;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () => _showNotificationDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen(name: "User Mhs", role: "Mahasiswa"))),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (r) => false),
          )
        ],
      ),
      body: Column(
        children: [
          // Statistik Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _userStat("Total", DataDummy.tickets.length.toString()),
                _userStat("Selesai", DataDummy.tickets.where((t) => t['status'] == "Done").length.toString()),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: DataDummy.tickets.length,
              itemBuilder: (context, index) {
                var t = DataDummy.tickets[index];
                return Card(
                  color: cardColor,
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    title: Text(t['title'], style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                    subtitle: Text("Status: ${t['status']}", style: TextStyle(color: subTextColor)),
                    trailing: const Icon(Icons.track_changes, color: Colors.teal),
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => TicketDetailPage(index: index, role: 'user')));
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateTicketPage()));
          setState(() {}); 
        },
        label: const Text("Buat Tiket", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _userStat(String label, String val) {
    return Column(children: [
      Text(val, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(color: Colors.white70)),
    ]);
  }
}