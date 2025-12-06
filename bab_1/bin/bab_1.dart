import 'dart:async';

// Enum Role dengan nilai admin dan customer (lowerCamelCase)
enum Role { admin, customer }

// Class Product 
class Product {
  final String productName;
  final double price;
  final bool inStock;

  Product({
    required this.productName,
    required this.price,
    required this.inStock,
  });

  @override
  String toString() {
    return 'Product(name: $productName, price: Rp$price, inStock: $inStock)';
  }
}

// Base class User 
class User {
  String name;
  int age;
  Role? role; // Nullable type untuk role
  late List<Product> products; // Late initialization untuk products

  User({
    required this.name,
    required this.age,
    this.role,
  }) {
    // Inisialisasi products setelah objek dibuat
    products = [];
  }

  void viewProducts() {
    if (products.isEmpty) {
      print("$name tidak memiliki produk.");
    } else {
      print("\nDaftar produk milik $name:");
      for (var product in products) {
        print("  - ${product.productName}, Harga: Rp${product.price}, "
            "Stok: ${product.inStock ? 'Tersedia' : 'Habis'}");
      }
    }
  }
}

// AdminUser - subclass dari User dengan kemampuan menambah/menghapus produk
class AdminUser extends User {
  AdminUser({
    required super.name,
    required super.age,
  }) : super(role: Role.admin);

  // Method untuk menambah produk dengan exception handling
  void addProduct(Product product, Set<String> productSet) {
    try {
      // Cek apakah produk tersedia dalam stok
      if (!product.inStock) {
        throw Exception(
            "Produk '${product.productName}' tidak tersedia dalam stok!");
      }

      // Gunakan Set untuk memastikan produk unik
      if (productSet.add(product.productName)) {
        products.add(product);
        print("✓ Admin $name berhasil menambahkan produk: ${product.productName}");
      } else {
        print("⚠ Produk '${product.productName}' sudah ada dalam daftar.");
      }
    } on Exception catch (e) {
      print("✗ Error: $e");
    } catch (e) {
      print("✗ Terjadi kesalahan tidak terduga: $e");
    }
  }

  // Method untuk menghapus produk
  void removeProduct(String productName) {
    try {
      var product = products.firstWhere(
        (p) => p.productName == productName,
      );
      products.remove(product);
      print("✓ Admin $name berhasil menghapus produk: $productName");
    } catch (e) {
      print("✗ Produk '$productName' tidak ditemukan dalam daftar.");
    }
  }
}

// CustomerUser - subclass dari User yang hanya bisa melihat produk
class CustomerUser extends User {
  CustomerUser({
    required super.name,
    required super.age,
  }) : super(role: Role.customer);

  // CustomerUser hanya bisa melihat, tidak bisa menambah/hapus
  @override
  void viewProducts() {
    print("\n[Customer View]");
    super.viewProducts();
  }
}

// Fungsi asinkron untuk mengambil detail produk dengan penundaan
Future<void> fetchProductDetails(Product product) async {
  print("\n⏳ Mengambil detail produk '${product.productName}' dari server...");
  
  // Simulasi pengambilan data dengan penundaan 2 detik
  await Future.delayed(Duration(seconds: 2));
  
  print("✓ Detail produk berhasil diambil:");
  print("  Nama Produk: ${product.productName}");
  print("  Harga: Rp${product.price}");
  print("  Status Stok: ${product.inStock ? 'Tersedia' : 'Habis'}");
}

void main() async {
  print("=== SISTEM E-COMMERCE ===\n");

  // Map untuk menyimpan katalog produk (key: nama produk, value: object Product)
  Map<String, Product> productCatalog = {};
  
  // Set untuk memastikan produk unik (tidak ada duplikat)
  Set<String> productSet = {};

  // Membuat AdminUser dan CustomerUser
  var admin = AdminUser(name: "Alice", age: 30);
  var customer = CustomerUser(name: "Bob", age: 25);

  print("User yang dibuat:");
  print("  - ${admin.name} (${admin.role})");
  print("  - ${customer.name} (${customer.role})\n");

  // Membuat beberapa produk
  var product1 = Product(
    productName: "Laptop",
    price: 15000000,
    inStock: true,
  );
  
  var product2 = Product(
    productName: "Smartphone",
    price: 8000000,
    inStock: false, // Produk tidak tersedia (untuk testing exception)
  );
  
  var product3 = Product(
    productName: "Headphone",
    price: 2000000,
    inStock: true,
  );
  
  var product4 = Product(
    productName: "Laptop", // Duplikat untuk testing Set
    price: 15000000,
    inStock: true,
  );

  // Menyimpan produk ke dalam Map catalog
  productCatalog[product1.productName] = product1;
  productCatalog[product2.productName] = product2;
  productCatalog[product3.productName] = product3;

  print("--- ADMIN MENAMBAHKAN PRODUK ---");
  // Admin menambahkan produk (dengan exception handling)
  admin.addProduct(product1, productSet); // Berhasil
  admin.addProduct(product2, productSet); // Error: tidak ada stok
  admin.addProduct(product3, productSet); // Berhasil
  admin.addProduct(product4, productSet); // Duplikat

  print("\n--- ADMIN MENGHAPUS PRODUK ---");
  // Admin menghapus produk
  admin.removeProduct("Smartphone"); // Berhasil (walaupun tidak ditambahkan)
  admin.removeProduct("Mouse"); // Error: tidak ditemukan

  print("\n--- MENAMPILKAN PRODUK ---");
  // Admin melihat produk miliknya
  admin.viewProducts();

  // Customer melihat produk (products masih kosong karena tidak ada yang ditambahkan)
  customer.viewProducts();

  // Simulasi customer mendapat produk (misalnya dari pembelian)
  customer.products.add(product1);
  customer.products.add(product3);
  customer.viewProducts();

  print("\n--- ASYNCHRONOUS: MENGAMBIL DETAIL PRODUK ---");
  // Menggunakan asynchronous programming untuk fetch product details
  await fetchProductDetails(product1);
  await fetchProductDetails(product3);

  print("\n--- DEMONSTRASI NULL SAFETY ---");
  
  // Fungsi yang mengembalikan User nullable
  User? getUserOrNull(bool shouldReturnUser) {
    if (shouldReturnUser) {
      return User(name: "Charlie", age: 28);
    }
    return null;
  }
  
  // Demonstrasi operator ? dan ?. ketika benar-benar null
  User? nullableUser = getUserOrNull(false);
  print("Nullable user (null): ${nullableUser?.name ?? 'User belum diinisialisasi'}");
  print("Role (null): ${nullableUser?.role ?? 'Role belum ditentukan'}");
  
  // Demonstrasi ketika user ada
  nullableUser = getUserOrNull(true);
  print("\nNullable user (ada): ${nullableUser?.name ?? 'User belum diinisialisasi'}");
  print("Role (ada): ${nullableUser?.role ?? 'Role belum ditentukan'}");
  
  // Demonstrasi operator ! (non-null assertion) - kita paksa meskipun nullable
  User? anotherUser = getUserOrNull(true);
  print("Menggunakan ! operator: ${anotherUser!.name}"); // Kita yakin tidak null
  print("Jumlah produk: ${anotherUser.products.length}");

  print("\n=== PROGRAM SELESAI ===");
}