import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/data_dummy.dart';

class TicketDetailPage extends StatefulWidget {
  final int index;
  final String role;
  const TicketDetailPage({super.key, required this.index, required this.role});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  final TextEditingController _replyController = TextEditingController();

  Color _getRoleColor() {
    switch (widget.role.toLowerCase()) {
      case 'admin': return const Color(0xFF0E458E);
      case 'helpdesk': return const Color(0xFFC97E00);
      case 'user': return const Color(0xFF00796D);
      default: return const Color(0xFF264C8D);
    }
  }

  void _updateStatus(String newStatus) {
    setState(() {
      var t = DataDummy.tickets[widget.index];
      t['status'] = newStatus;
      t['history'].add("${DateTime.now().day}/${DateTime.now().month} - Status jadi $newStatus oleh ${widget.role}");
    });
    _showSnackBar("Status diperbarui ke $newStatus");
  }

  void _showAssignSheet() {
    Color primaryColor = _getRoleColor();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pilih Petugas Helpdesk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 15),
            ...DataDummy.helpdeskList.map((name) => ListTile(
              leading: CircleAvatar(backgroundColor: primaryColor.withOpacity(0.1), child: Icon(Icons.person, color: primaryColor)),
              title: Text(name),
              onTap: () {
                setState(() {
                  var t = DataDummy.tickets[widget.index];
                  t['assignedTo'] = name;
                  t['status'] = "Process";
                  t['history'].add("Tiket di-assign ke $name");
                });
                Navigator.pop(context);
              },
            )).toList(),
          ],
        ),
      ),
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
    Color primaryColor = _getRoleColor();

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail ${tiket['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tiket['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _statusBadge(tiket['status']),
                  const SizedBox(height: 15),

                  // Perbaikan Overflow di Bagian Penugasan
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Icon(Icons.assignment_ind, color: primaryColor),
                        const SizedBox(width: 10),
                        const Text("Ditugaskan: ", style: TextStyle(fontWeight: FontWeight.w500)),
                        Expanded( // Solusi Overflow 1
                          child: Text(
                            "${tiket['assignedTo']}",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 40),
                  const Text("Deskripsi:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(tiket['desc'] ?? "-", style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4)),
                  const SizedBox(height: 25),

                  // Tombol Aksi
                  if (widget.role == 'admin' && tiket['assignedTo'] == "-")
                    _actionButton("ASSIGN TIKET", Colors.orange[700]!, Icons.person_add, _showAssignSheet),
                  if (widget.role == 'helpdesk' && tiket['status'] == "Open")
                    _actionButton("PROSES TIKET", primaryColor, Icons.play_arrow, () => _updateStatus("Process")),
                  if ((widget.role == 'helpdesk' || widget.role == 'admin') && tiket['status'] == "Process")
                    _actionButton("SELESAIKAN", Colors.green[700]!, Icons.check_circle, () => _updateStatus("Done")),

                  const Divider(height: 40),
                  const Text("Lampiran Foto:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildImageSection(tiket['image']),

                  const Divider(height: 40),
                  Text("History Tracking", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  const SizedBox(height: 10),

                  // Perbaikan Overflow di Bagian History
                  ...((tiket['history'] as List? ?? []).map((h) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.only(top: 6), child: Icon(Icons.circle, size: 6, color: primaryColor)),
                        const SizedBox(width: 12),
                        Expanded(child: Text(h, style: const TextStyle(fontSize: 13))), // Solusi Overflow 2
                      ],
                    ),
                  )).toList()),

                  const Divider(height: 40),
                  Text("Diskusi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  const SizedBox(height: 10),
                  ...((tiket['comments'] as List? ?? []).map((c) => Card(
                    child: ListTile(
                      title: Text(c['sender'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: primaryColor)),
                      subtitle: Text(c['message']),
                      trailing: Text(c['time'], style: const TextStyle(fontSize: 10)),
                    ),
                  )).toList()),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Input Reply (Anti-Overflow)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: "Balas...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(backgroundColor: primaryColor, child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 20), onPressed: _sendReply)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(String? path) {
    if (path == null || path == "") {
      return Container(height: 100, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.image_not_supported, color: Colors.grey));
    }
    return ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(path), height: 200, width: double.infinity, fit: BoxFit.cover));
  }

  Widget _actionButton(String label, Color color, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: onPressed, icon: Icon(icon), label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)))),
    );
  }

  Widget _statusBadge(String status) {
    Color color = status == "Done" ? Colors.green : (status == "Process" ? Colors.orange : Colors.blue);
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)), child: Text(status.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)));
  }
}