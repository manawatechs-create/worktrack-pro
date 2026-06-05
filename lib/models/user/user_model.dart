class UserModel {
  final String id;
  final String matricule;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? photoUrl;
  final String role; // super_admin, admin_rh, manager, employee, auditor
  final String department;
  final String position;
  final DateTime hireDate;
  final String contractType; // cdi, cdd, stage, freelance
  final String status; // active, inactive, suspended
  final Map<String, dynamic>? metadata;

  UserModel({
    required this.id,
    required this.matricule,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.photoUrl,
    required this.role,
    required this.department,
    required this.position,
    required this.hireDate,
    required this.contractType,
    required this.status,
    this.metadata,
  });

  String get fullName => '$firstName $lastName';
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      matricule: json['matricule'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photo_url'],
      role: json['role'],
      department: json['department'],
      position: json['position'],
      hireDate: DateTime.parse(json['hire_date']),
      contractType: json['contract_type'],
      status: json['status'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matricule': matricule,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'photo_url': photoUrl,
      'role': role,
      'department': department,
      'position': position,
      'hire_date': hireDate.toIso8601String(),
      'contract_type': contractType,
      'status': status,
      'metadata': metadata,
    };
  }
}
