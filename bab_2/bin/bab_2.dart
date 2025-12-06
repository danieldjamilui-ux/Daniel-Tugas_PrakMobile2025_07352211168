// Enum untuk Kategori Produk
enum KategoriProduk { dataManagement, networkAutomation }

// Enum untuk Peran Karyawan
enum PeranKaryawan { developer, networkEngineer, manager }

// Enum untuk Fase Proyek
enum FaseProyek { perencanaan, pengembangan, evaluasi }

// Mixin Kinerja untuk mengelola produktivitas karyawan
mixin Kinerja {
  int _produktivitas = 0;
  DateTime _terakhirDiperbarui = DateTime.now();

  int get produktivitas => _produktivitas;

  void perbaruiProduktivitas(int nilaiBaru, PeranKaryawan? peran) {
    final sekarang = DateTime.now();
    final hariSejakTerakhirDiperbarui =
        sekarang.difference(_terakhirDiperbarui).inDays;

    if (hariSejakTerakhirDiperbarui < 30) {
      print("Produktivitas hanya bisa diperbarui setiap 30 hari.");
      return;
    }

    if (nilaiBaru < 0 || nilaiBaru > 100) {
      print("Nilai produktivitas harus di antara 0 dan 100.");
      return;
    }

    // Validasi khusus untuk Manager
    if (peran == PeranKaryawan.manager && nilaiBaru < 85) {
      print("Manajer harus memiliki produktivitas minimal 85. Update dibatalkan.");
      return;
    }

    _produktivitas = nilaiBaru;
    _terakhirDiperbarui = sekarang;
    print("Produktivitas berhasil diperbarui menjadi $_produktivitas");
  }
}

// Kelas ProdukDigital untuk mengelola produk perusahaan
class ProdukDigital {
  final String namaProduk;
  final KategoriProduk kategori;
  double harga;
  int jumlahTerjual = 0;

  ProdukDigital({
    required this.namaProduk,
    required this.kategori,
    required this.harga,
  }) {
    // Validasi harga berdasarkan kategori
    if (kategori == KategoriProduk.networkAutomation && harga < 200000) {
      throw Exception(
          "Produk NetworkAutomation harus memiliki harga minimal 200.000");
    }
    if (kategori == KategoriProduk.dataManagement && harga >= 200000) {
      throw Exception(
          "Produk DataManagement harus memiliki harga di bawah 200.000");
    }
  }

  // Metode untuk menerapkan diskon pada produk NetworkAutomation
  void terapkanDiskon() {
    if (kategori == KategoriProduk.networkAutomation && jumlahTerjual > 50) {
      double hargaSetelahDiskon = harga * 0.85;
      
      // Pastikan harga setelah diskon tidak di bawah 200.000
      if (hargaSetelahDiskon >= 200000) {
        harga = hargaSetelahDiskon;
        print("Diskon 15% diterapkan pada $namaProduk. Harga baru: Rp${harga.toStringAsFixed(0)}");
      } else {
        print("Diskon tidak dapat diterapkan karena harga akan di bawah 200.000");
      }
    }
  }

  void tambahPenjualan(int jumlah) {
    jumlahTerjual += jumlah;
    print("$namaProduk terjual $jumlah unit. Total terjual: $jumlahTerjual unit");
    terapkanDiskon();
  }
}

// Kelas Abstrak Karyawan
abstract class Karyawan with Kinerja {
  final String nama;
  final int umur;
  final PeranKaryawan peran;
  final int pengalaman; // dalam tahun

  // Positional argument untuk nama, named arguments untuk umur dan peran
  Karyawan(
    this.nama, {
    required this.umur,
    required this.peran,
    this.pengalaman = 0,
  }) {
    _validasiKaryawan();
  }

  // Validasi kriteria umur dan pengalaman berdasarkan peran
  void _validasiKaryawan() {
    switch (peran) {
      case PeranKaryawan.developer:
        if (umur < 21) {
          throw Exception("Developer harus berumur minimal 21 tahun");
        }
        if (pengalaman < 1) {
          throw Exception("Developer harus memiliki pengalaman minimal 1 tahun");
        }
        break;
      case PeranKaryawan.networkEngineer:
        if (umur < 23) {
          throw Exception("NetworkEngineer harus berumur minimal 23 tahun");
        }
        if (pengalaman < 2) {
          throw Exception("NetworkEngineer harus memiliki pengalaman minimal 2 tahun");
        }
        break;
      case PeranKaryawan.manager:
        if (umur < 28) {
          throw Exception("Manager harus berumur minimal 28 tahun");
        }
        if (pengalaman < 5) {
          throw Exception("Manager harus memiliki pengalaman minimal 5 tahun");
        }
        // Set produktivitas awal minimal 85 untuk Manager
        if (_produktivitas < 85) {
          _produktivitas = 85;
        }
        break;
    }
  }

  // Metode abstrak yang harus diimplementasikan oleh subclass
  void bekerja();

  // Override metode perbaruiProduktivitas untuk memanggil dengan peran
  void updateProduktivitas(int nilaiBaru) {
    perbaruiProduktivitas(nilaiBaru, peran);
  }
}

// Subclass KaryawanTetap - menggunakan super parameters
class KaryawanTetap extends Karyawan {
  KaryawanTetap(
    super.nama, {
    required super.umur,
    required super.peran,
    super.pengalaman = 0,
  });

  @override
  void bekerja() {
    print("$nama (Karyawan Tetap) bekerja pada hari kerja reguler (Senin-Jumat, 08:00-17:00)");
  }
}

// Subclass KaryawanKontrak - menggunakan super parameters
class KaryawanKontrak extends Karyawan {
  final int durasiProyek; // dalam hari
  final DateTime tanggalMulaiKontrak;
  
  KaryawanKontrak(
    super.nama, {
    required super.umur,
    required super.peran,
    required this.durasiProyek,
    super.pengalaman = 0,
  }) : tanggalMulaiKontrak = DateTime.now();

  @override
  void bekerja() {
    final hariTersisa = durasiProyek - 
        DateTime.now().difference(tanggalMulaiKontrak).inDays;
    print("$nama (Karyawan Kontrak) bekerja pada proyek dengan durasi $durasiProyek hari (Sisa: $hariTersisa hari)");
  }

  DateTime get tanggalSelesaiKontrak =>
      tanggalMulaiKontrak.add(Duration(days: durasiProyek));
}

// Kelas Proyek untuk mengelola fase dan tim proyek
class Proyek {
  String namaProyek;
  FaseProyek fase = FaseProyek.perencanaan;
  List<Karyawan> timProyek = [];
  DateTime? tanggalMulaiPengembangan;

  Proyek(this.namaProyek);

  void tambahKaryawan(Karyawan karyawan) {
    if (timProyek.length < 20) {
      timProyek.add(karyawan);
      print("${karyawan.nama} ditambahkan ke tim proyek '$namaProyek'");
    } else {
      print("Batas maksimum 20 karyawan dalam tim proyek telah tercapai");
    }
  }

  // Transisi dari Perencanaan ke Pengembangan
  bool pindahKePengembangan() {
    if (fase == FaseProyek.perencanaan) {
      if (timProyek.length >= 5) {
        fase = FaseProyek.pengembangan;
        tanggalMulaiPengembangan = DateTime.now();
        print("✓ Proyek '$namaProyek' beralih ke fase Pengembangan");
        return true;
      } else {
        print("✗ Gagal beralih ke Pengembangan: Minimal 5 karyawan diperlukan (Saat ini: ${timProyek.length})");
        return false;
      }
    } else {
      print("✗ Proyek tidak dalam fase Perencanaan");
      return false;
    }
  }

  // Transisi dari Pengembangan ke Evaluasi
  bool pindahKeEvaluasi() {
    if (fase == FaseProyek.pengembangan) {
      if (tanggalMulaiPengembangan != null) {
        final hariDalamPengembangan =
            DateTime.now().difference(tanggalMulaiPengembangan!).inDays;
        
        if (hariDalamPengembangan > 45) {
          fase = FaseProyek.evaluasi;
          print("✓ Proyek '$namaProyek' beralih ke fase Evaluasi");
          return true;
        } else {
          print("✗ Gagal beralih ke Evaluasi: Proyek harus berjalan lebih dari 45 hari (Saat ini: $hariDalamPengembangan hari)");
          return false;
        }
      }
    } else {
      print("✗ Proyek tidak dalam fase Pengembangan");
    }
    return false;
  }

  void tampilkanStatus() {
    print("\n=== Status Proyek: $namaProyek ===");
    print("Fase: ${fase.name}");
    print("Jumlah Tim: ${timProyek.length} orang");
    if (tanggalMulaiPengembangan != null) {
      print("Hari dalam Pengembangan: ${DateTime.now().difference(tanggalMulaiPengembangan!).inDays} hari");
    }
  }
}

// Kelas Perusahaan untuk mengelola karyawan
class Perusahaan {
  final String namaPerusahaan;
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];

  Perusahaan(this.namaPerusahaan);

  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length < 20) {
      karyawanAktif.add(karyawan);
      print("✓ ${karyawan.nama} berhasil ditambahkan sebagai karyawan aktif");
      print("  Total karyawan aktif: ${karyawanAktif.length}/20");
    } else {
      print("✗ Gagal menambahkan ${karyawan.nama}: Batas maksimum 20 karyawan aktif telah tercapai");
    }
  }

  void resignKaryawan(Karyawan karyawan) {
    if (karyawanAktif.remove(karyawan)) {
      karyawanNonAktif.add(karyawan);
      print("✓ ${karyawan.nama} telah resign dan dipindahkan ke status non-aktif");
      print("  Total karyawan aktif: ${karyawanAktif.length}/20");
    } else {
      print("✗ ${karyawan.nama} tidak ditemukan dalam daftar karyawan aktif");
    }
  }

  void tampilkanStatistik() {
    print("\n=== Statistik $namaPerusahaan ===");
    print("Karyawan Aktif: ${karyawanAktif.length}/20");
    print("Karyawan Non-Aktif: ${karyawanNonAktif.length}");
    
    if (karyawanAktif.isNotEmpty) {
      print("\nDaftar Karyawan Aktif:");
      for (var k in karyawanAktif) {
        print("  - ${k.nama} (${k.peran.name}, ${k.umur} tahun, Produktivitas: ${k.produktivitas})");
      }
    }
  }
}

// Program utama
void main() {
  print("==============================================");
  print("SISTEM MANAJEMEN PERUSAHAAN TONGIT");
  print("==============================================\n");

  // ========== 1. MANAJEMEN PRODUK DIGITAL ==========
  print(">>> TESTING PRODUK DIGITAL <<<\n");
  
  try {
    var produk1 = ProdukDigital(
      namaProduk: "Sistem Manajemen Data",
      kategori: KategoriProduk.dataManagement,
      harga: 150000,
    );
    print("✓ Produk '${produk1.namaProduk}' berhasil dibuat (Harga: Rp${produk1.harga})");

    var produk2 = ProdukDigital(
      namaProduk: "Sistem Otomasi Jaringan",
      kategori: KategoriProduk.networkAutomation,
      harga: 250000,
    );
    print("✓ Produk '${produk2.namaProduk}' berhasil dibuat (Harga: Rp${produk2.harga})");

    // Testing diskon
    print("\n--- Testing Diskon Premium ---");
    produk2.tambahPenjualan(51);
    
  } catch (e) {
    print("✗ Error: $e");
  }

  // ========== 2. MANAJEMEN KARYAWAN ==========
  print("\n\n>>> TESTING KARYAWAN <<<\n");
  
  try {
    // Contoh penggunaan positional dan named arguments
    var manager = KaryawanTetap(
      "Alice Johnson",  // positional argument
      umur: 30,         // named argument
      peran: PeranKaryawan.manager,  // named argument
      pengalaman: 7,
    );
    print("✓ Manager berhasil ditambahkan");

    var developer = KaryawanKontrak(
      "Bob Smith",
      umur: 25,
      peran: PeranKaryawan.developer,
      durasiProyek: 90,
      pengalaman: 3,
    );
    print("✓ Developer kontrak berhasil ditambahkan");

    var engineer = KaryawanTetap(
      "Charlie Brown",
      umur: 27,
      peran: PeranKaryawan.networkEngineer,
      pengalaman: 4,
    );
    print("✓ Network Engineer berhasil ditambahkan");

    // Testing metode bekerja()
    print("\n--- Testing Metode Bekerja ---");
    manager.bekerja();
    developer.bekerja();
    engineer.bekerja();

    // Testing produktivitas
    print("\n--- Testing Produktivitas ---");
    manager.updateProduktivitas(90);
    developer.updateProduktivitas(75);
    
    // Testing validasi produktivitas Manager < 85 (harus gagal)
    print("\nMencoba update produktivitas Manager menjadi 80 (di bawah 85):");
    manager.updateProduktivitas(80);

  } catch (e) {
    print("✗ Error: $e");
  }

  // ========== 3. MANAJEMEN PERUSAHAAN ==========
  print("\n\n>>> TESTING MANAJEMEN PERUSAHAAN <<<\n");
  
  var tongIT = Perusahaan("TongIT");
  
  try {
    // Tambah beberapa karyawan
    var k1 = KaryawanTetap("David Lee", umur: 29, peran: PeranKaryawan.manager, pengalaman: 6);
    var k2 = KaryawanTetap("Eva Chen", umur: 26, peran: PeranKaryawan.developer, pengalaman: 3);
    var k3 = KaryawanKontrak("Frank Wilson", umur: 24, peran: PeranKaryawan.networkEngineer, durasiProyek: 120, pengalaman: 2);
    
    tongIT.tambahKaryawan(k1);
    tongIT.tambahKaryawan(k2);
    tongIT.tambahKaryawan(k3);
    
    // Testing resign
    print("\n--- Testing Resign Karyawan ---");
    tongIT.resignKaryawan(k3);
    
    tongIT.tampilkanStatistik();
    
  } catch (e) {
    print("✗ Error: $e");
  }

  // ========== 4. MANAJEMEN PROYEK ==========
  print("\n\n>>> TESTING MANAJEMEN PROYEK <<<\n");
  
  var proyek1 = Proyek("Modernisasi Sistem Internal");
  
  // Tambah karyawan ke proyek
  for (int i = 0; i < 6; i++) {
    try {
      var karyawan = KaryawanTetap(
        "Karyawan${i+1}",
        umur: 25,
        peran: PeranKaryawan.developer,
        pengalaman: 2,
      );
      proyek1.tambahKaryawan(karyawan);
    } catch (e) {
      print("Error: $e");
    }
  }
  
  // Testing transisi fase
  print("\n--- Testing Transisi Fase Proyek ---");
  proyek1.pindahKePengembangan();
  proyek1.pindahKeEvaluasi(); // Akan gagal karena belum 45 hari
  
  proyek1.tampilkanStatus();

  print("\n==============================================");
  print("TESTING SELESAI");
  print("==============================================");
}