class DataDummy {
  static List<Map<String, String>> users = [
    {"email": "admin@mail.com", "pass": "admin123", "role": "admin"},
    {"email": "helpdesk@mail.com", "pass": "help123", "role": "helpdesk"},
    {"email": "user@mail.com", "pass": "user123", "role": "user"},
  ];

  static List<String> helpdeskList = [
    "Budi (IT Support)", 
    "Santi (Network Tech)", 
    "Rian (Hardware)"
  ];

  static List<Map<String, dynamic>> tickets = [
    {
      "id": "TK-001",
      "title": "Masalah Jaringan Lantai 3",
      "desc": "WiFi tidak terdeteksi sejak pukul 08.00 WIB.",
      "status": "Open",
      "user": "Mhs Teknik",
      "assignedTo": "-",
      "date": "2026-04-08",
      "history": ["Tiket dibuat oleh Mhs Teknik"],
      "image": null,
      "comments": [],
    },
    {
      "id": "TK-002",
      "title": "Aplikasi E-Learning Error",
      "desc": "Tidak bisa submit tugas, muncul pesan error 500.",
      "status": "Process",
      "user": "Mhs Airlangga",
      "assignedTo": "Budi (IT Support)",
      "date": "2026-04-07",
      "history": ["Tiket dibuat", "Diterima oleh Admin", "Assign ke Budi (IT Support)"],
      "image": null,
      "comments": [],
    },
  ];
}