import 'package:flutter/material.dart';
import '../../data/data_dummy.dart';
import '../tickets/ticket_detail_page.dart';
import '../auth/login_page.dart';
import '../profile/profile_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // 1. Variabel Lokal Dark Mode
  bool _isLocalDarkMode = false;

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Pemberitahuan Admin"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _notiItem(context, "Tiket Baru", "Ada tiket baru masuk dari Mhs Teknik", 0),
              _notiItem(context, "Update Status", "Helpdesk Budi menyelesaikan tiket TK-002", 1),
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
        backgroundColor: Color(0xFF0D47A1), 
        child: Icon(Icons.notifications, color: Colors.white, size: 18)
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
      onTap: () async {
        Navigator.pop(context);
        await Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => TicketDetailPage(index: index, role: 'admin'))
        );
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 2. Definisi Warna Berdasarkan Mode
    Color bgColor = _isLocalDarkMode ? const Color(0xFF121212) : Colors.grey[100]!;
    Color cardColor = _isLocalDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = _isLocalDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = _isLocalDarkMode ? Colors.white70 : Colors.black54;

    int total = DataDummy.tickets.length;
    int process = DataDummy.tickets.where((t) => t['status'] == "Process").length;
    int done = DataDummy.tickets.where((t) => t['status'] == "Done").length;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // HEADER AREA
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 10, bottom: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isLocalDarkMode 
                  ? [const Color(0xFF1A1A1A), const Color(0xFF2C2C2C)] 
                  : [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // JUDUL (Flexible agar tidak overflow)
                    const Flexible(
                      child: Text(
                        "Admin", 
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    ),
                    // ICON ACTIONS
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _topIconButton(
                          icon: _isLocalDarkMode ? Icons.light_mode : Icons.dark_mode, 
                          onPressed: () => setState(() => _isLocalDarkMode = !_isLocalDarkMode)
                        ),
                        _topIconButton(
                          icon: Icons.notifications_none, 
                          onPressed: () => _showNotificationDialog(context)
                        ),
                        _topIconButton(
                          icon: Icons.account_circle_outlined, 
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen(name: "Admin Utama", role: "Administrator IT")))
                        ),
                        _topIconButton(
                          icon: Icons.logout, 
                          onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (r) => false)
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // STATISTIK TIKET
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem("Total", total.toString()),
                    _statItem("Proses", process.toString()),
                    _statItem("Selesai", done.toString()),
                  ],
                )
              ],
            ),
          ),
          // LIST TIKET
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: DataDummy.tickets.length,
              itemBuilder: (context, index) {
                var t = DataDummy.tickets[index];
                return Card(
                  color: cardColor,
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    title: Text(t['title'], style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                    subtitle: Text("${t['id']} • ${t['status']}", style: TextStyle(color: subTextColor)),
                    trailing: Icon(Icons.arrow_right, color: _isLocalDarkMode ? Colors.blueAccent : Colors.blue),
                    onTap: () async {
                      // 3. Refresh Otomatis saat kembali dari detail
                      await Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (_) => TicketDetailPage(index: index, role: 'admin'))
                      );
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // Widget Helper untuk Icon agar rapi dan tidak overflow
  Widget _topIconButton({required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(maxWidth: 40),
      icon: Icon(icon, color: Colors.white, size: 22),
      onPressed: onPressed,
    );
  }

  // Widget pendukung Statistik (Tanpa Const karena ada Opacity)
  Widget _statItem(String label, String val) {
    return Column(children: [
      Text(val, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12))
    ]);
  }
}