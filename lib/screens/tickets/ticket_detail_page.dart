import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/data_dummy.dart';

class TicketDetailPage extends StatefulWidget {
  final int index;
  final String role; // 'admin', 'helpdesk', atau 'user'
  const TicketDetailPage({super.key, required this.index, required this.role});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  final TextEditingController _replyController = TextEditingController();

  // --- FUNGSI UPDATE STATUS (FR-006) ---
  void _updateStatus(String newStatus) {
    setState(() {
      var t = DataDummy.tickets[widget.index];
      t['status'] = newStatus;
      t['history'].add("Status tiket diubah menjadi $newStatus oleh ${widget.role}");
    });
    _showSnackBar("Status berhasil diperbarui ke $newStatus");
  }

  // --- FUNGSI ASSIGN (KHUSUS ADMIN) ---
  void _showAssignSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Pilih Petugas Helpdesk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              ...DataDummy.helpdeskList.map((name) => ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(name),
                onTap: () {
                  setState(() {
                    var t = DataDummy.tickets[widget.index];
                    t['assignedTo'] = name;
                    t['status'] = "Process"; // Otomatis ke Process saat di-assign
                    t['history'].add("Tiket ditugaskan ke $name");
                  });
                  Navigator.pop(context);
                  _showSnackBar("Tiket berhasil ditugaskan ke $name");
                },
              )).toList(),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _sendReply() {
    if (_replyController.text.trim().isEmpty) return;
    setState(() {
      var t = DataDummy.tickets[widget.index];
      t['comments'] ??= []; 
      t['comments'].add({
        "sender": widget.role.toUpperCase(),
        "message": _replyController.text.trim(),
        "time": "${DateTime.now().hour}:${DateTime.now().minute}"
      });
      _replyController.clear();
    });
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    var tiket = DataDummy.tickets[widget.index];
    List history = tiket['history'] ?? [];
    List comments = tiket['comments'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail ${tiket['id']}"), 
        backgroundColor: _getRoleColor(),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  Text(tiket['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _statusBadge(tiket['status']),
                  const SizedBox(height: 10),
                  Text("Ditugaskan kepada: ${tiket['assignedTo']}", style: const TextStyle(color: Colors.grey)),
                  
                  const Divider(height: 40),

                  // --- BAGIAN DESKRIPSI (YANG DITAMBAHKAN) ---
                  const Text("Deskripsi Tiket:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    tiket['desc'] ?? "Tidak ada deskripsi detail.",
                    style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  // -------------------------------------------

                  // --- TOMBOL AKSI BERDASARKAN ROLE ---
                  if (widget.role == 'admin' && tiket['assignedTo'] == "-")
                    _actionButton("ASSIGN KE HELPDESK", Colors.orange, Icons.person_add, _showAssignSheet),

                  if (widget.role == 'helpdesk' && tiket['status'] == "Open")
                    _actionButton("MULAI PROSES", Colors.blue, Icons.play_arrow, () => _updateStatus("Process")),

                  if ((widget.role == 'helpdesk' || widget.role == 'admin') && tiket['status'] == "Process")
                    _actionButton("TANDAI SELESAI", Colors.green, Icons.check_circle, () => _updateStatus("Done")),

                  const Divider(height: 40),

                  // Lampiran Foto
                  const Text("Lampiran Foto:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  tiket['image'] != null && tiket['image'] != ""
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(File(tiket['image']), height: 200, width: double.infinity, fit: BoxFit.cover),
                        )
                      : Container(
                          height: 100, 
                          width: double.infinity, 
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        ),

                  const Divider(height: 40),

                  // Tracking History
                  const Text("Tracking History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...history.map((h) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(child: Text(h, style: const TextStyle(fontSize: 14))),
                      ],
                    ),
                  )).toList(),

                  const Divider(height: 40),

                  // Diskusi
                  const Text("Diskusi / Reply", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...comments.map((c) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(c['sender'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    subtitle: Text(c['message']),
                    trailing: Text(c['time'], style: const TextStyle(fontSize: 10)),
                  )).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Input Reply
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))]
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController, 
                    decoration: const InputDecoration(
                      hintText: "Tulis balasan...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send, color: Colors.blue), onPressed: _sendReply),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget tombol aksi yang reusable
  Widget _actionButton(String label, Color color, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: color, 
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Color _getRoleColor() {
    if (widget.role == 'admin') return Colors.red[800]!;
    if (widget.role == 'helpdesk') return Colors.orange[800]!;
    return Colors.teal;
  }

  Widget _statusBadge(String status) {
    Color color = Colors.blue;
    if (status == "Process") color = Colors.orange;
    if (status == "Done") color = Colors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}