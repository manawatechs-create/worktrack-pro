class Utilisateur {
  final String id;
  final String email;
  final String nom;
  final String prenom;
  final String role; // admin, manager, employe
  final String matricule;
  final String? telephone;
  final String? photoUrl;
  final DateTime? dateEmbauche;
  final String statut; // actif, inactif, suspendu

  Utilisateur({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.role,
    required this.matricule,
    this.telephone,
    this.photoUrl,
    this.dateEmbauche,
    required this.statut,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      email: json['email'],
      nom: json['nom'],
      prenom: json['prenom'],
      role: json['role'],
      matricule: json['matricule'],
      telephone: json['telephone'],
      photoUrl: json['photo_url'],
      dateEmbauche: json['date_embauche'] != null 
          ? DateTime.parse(json['date_embauche']) 
          : null,
      statut: json['statut'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'role': role,
      'matricule': matricule,
      'telephone': telephone,
      'photo_url': photoUrl,
      'date_embauche': dateEmbauche?.toIso8601String(),
      'statut': statut,
    };
  }

  String get nomComplet => '$prenom $nom';
}
