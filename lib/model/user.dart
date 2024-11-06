class UserModel {
  final String iduser;
  final String nama;
  final String profesi;
  final String email;
  final String password;
  final String roleId;
  final String isActive;
  final String tanggalInput;
  final String modified;

  UserModel({
    required this.iduser,
    required this.nama,
    required this.profesi,
    required this.email,
    required this.password,
    required this.roleId,
    required this.isActive,
    required this.tanggalInput,
    required this.modified,
  });

  // Fungsi untuk mengonversi JSON menjadi UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      iduser: json['iduser'],
      nama: json['nama'],
      profesi: json['profesi'],
      email: json['email'],
      password: json['password'],
      roleId: json['role_id'],
      isActive: json['is_active'],
      tanggalInput: json['tanggal_input'],
      modified: json['modified'],
    );
  }

  // Fungsi untuk mengonversi UserModel ke dalam bentuk JSON
  Map<String, dynamic> toJson() {
    return {
      'iduser': iduser,
      'nama': nama,
      'profesi': profesi,
      'email': email,
      'password': password,
      'role_id': roleId,
      'is_active': isActive,
      'tanggal_input': tanggalInput,
      'modified': modified,
    };
  }

  // Fungsi copyWith untuk membuat salinan baru dari UserModel dengan data yang dapat diubah
  UserModel copyWith({
    String? iduser,
    String? nama,
    String? profesi,
    String? email,
    String? password,
    String? roleId,
    String? isActive,
    String? tanggalInput,
    String? modified,
  }) {
    return UserModel(
      iduser: iduser ?? this.iduser,
      nama: nama ?? this.nama,
      profesi: profesi ?? this.profesi,
      email: email ?? this.email,
      password: password ?? this.password,
      roleId: roleId ?? this.roleId,
      isActive: isActive ?? this.isActive,
      tanggalInput: tanggalInput ?? this.tanggalInput,
      modified: modified ?? this.modified,
    );
  }
}
