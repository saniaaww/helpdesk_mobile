import 'package:flutter/material.dart';
import '../../data/data_dummy.dart';
import '../tickets/ticket_detail_page.dart';
import '../auth/login_page.dart';
import '../profile/profile_screen.dart';

class HelpdeskDashboard extends StatefulWidget {
  const HelpdeskDashboard({super.key});

  @override
  State<HelpdeskDashboard> createState() => _HelpdeskDashboardState();
}

class _HelpdeskDashboardState extends State<HelpdeskDashboard> {
  bool _isLocalDarkMode = false;

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Tugas & Update"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _notiItem(context, "Tiket Baru", "Admin menugaskan Anda pada TK-003", 0),
              _notiItem(context, "Komentar Baru", "User membalas pesan di tiket TK-001", 1),
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
        backgroundColor: Color(0xFFF57C00), 
        child: Icon(Icons.notifications, color: Colors.white, size: 18)
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
      onTap: () async {
        Navigator.pop(context);
        await Navigator.push(context, MaterialPageRoute(builder: (_) => TicketDetailPage(index: index, role: 'helpdesk')));
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = _isLocalDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = _isLocalDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = _isLocalDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = _isLocalDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // HEADER AREA
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 5, bottom: 25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isLocalDarkMode 
                  ? [const Color(0xFF2C2C2C), const Color(0xFF1F1F1F)] 
                  : [const Color(0xFFF57C00), const Color(0xFFFFB300)],
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 1. JUDUL (Menggunakan Flexible agar tidak memakan semua ruang)
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Helpdesk", 
                            overflow: TextOverflow.ellipsis, // Jika layar sangat kecil, teks akan jadi ...
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("Ready to work", 
                            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                        ],
                      ),
                    ),
                    
                    // 2. ICON ACTIONS (Dijejerkan ke samping)
                    Row(
                      mainAxisSize: MainAxisSize.min, // Penting: Row hanya mengambil ruang seperlunya
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(maxWidth: 40),
                          icon: Icon(_isLocalDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white, size: 22),
                          onPressed: () => setState(() => _isLocalDarkMode = !_isLocalDarkMode),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(maxWidth: 40),
                          icon: const Icon(Icons.notifications_none, color: Colors.white, size: 22),
                          onPressed: () => _showNotificationDialog(context),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(maxWidth: 40),
                          icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 22),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen(name: "Budi IT", role: "Helpdesk"))),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(maxWidth: 40),
                          icon: const Icon(Icons.logout, color: Colors.white, size: 22),
                          onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (r) => false),
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
                    _statItem("Total", DataDummy.tickets.length.toString()),
                    _statItem("Belum", DataDummy.tickets.where((t) => t['status'] == "Open").length.toString()),
                    _statItem("Proses", DataDummy.tickets.where((t) => t['status'] == "Process").length.toString()),
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
                Color currentCardColor = t['status'] == 'Process' 
                  ? (_isLocalDarkMode ? const Color(0xFF2E2218) : Colors.orange.shade50)
                  : cardColor;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: currentCardColor,
                  child: ListTile(
                    leading: Icon(Icons.build_circle, color: t['status'] == 'Process' ? Colors.orange : Colors.grey),
                    title: Text(t['title'], style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                    subtitle: Text("Status: ${t['status']}", style: TextStyle(color: subTextColor)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.orange),
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => TicketDetailPage(index: index, role: 'helpdesk')));
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

  Widget _statItem(String label, String val) {
    return Column(children: [
      Text(val, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11))
    ]);
  }
}