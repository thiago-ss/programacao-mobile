class User {
  final int? id;
  final String name;
  final String email;
  final String? password;
  final String? imageUrl;
  final String? bio;
  final String? phone;
  final String? address;
  final bool isAdmin;
  final DateTime createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.imageUrl,
    this.bio,
    this.phone,
    this.address,
    this.isAdmin = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      imageUrl: map['imageUrl'],
      bio: map['bio'],
      phone: map['phone'],
      address: map['address'],
      isAdmin: map['isAdmin'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? imageUrl,
    String? bio,
    String? phone,
    String? address,
    bool? isAdmin,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'bio': bio,
      'phone': phone,
      'address': address,
      'isAdmin': isAdmin ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
