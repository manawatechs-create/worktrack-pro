class Presence {
  final String id;
  final String utilisateurId;
  final DateTime datePresence;
  final DateTime? heureArrivee;
  final DateTime? heureDepart;
  final String typePresence; // present, absent, retard, conge, mission
  final String methodePointage; // qr_code, geolocalisation, manuelle, biometrique
  final double? latitude;
  final double? longitude;
  final String? photoPointage;
  final String? commentaire;
  final DateTime createdAt;

  Presence({
    required this.id,
    required this.utilisateurId,
    required this.datePresence,
    this.heureArrivee,
    this.heureDepart,
    required this.typePresence,
    required this.methodePointage,
    this.latitude,
    this.longitude,
    this.photoPointage,
    this.commentaire,
    required this.createdAt,
  });

  factory Presence.fromJson(Map<String, dynamic> json) {
    return Presence(
      id: json['id'],
      utilisateurId: json['utilisateur_id'],
      datePresence: DateTime.parse(json['date_presence']),
      heureArrivee: json['heure_arrivee'] != null 
          ? DateTime.parse(json['heure_arrivee']) 
          : null,
      heureDepart: json['heure_depart'] != null 
          ? DateTime.parse(json['heure_depart']) 
          : null,
      typePresence: json['type_presence'],
      methodePointage: json['methode_pointage'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      photoPointage: json['photo_pointage'],
      commentaire: json['commentaire'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  bool get estPresent => typePresence == 'present';
  bool get estEnRetard => typePresence == 'retard';
  bool get estAbsent => typePresence == 'absent';
  
  Duration? get dureeTravail {
    if (heureArrivee != null && heureDepart != null) {
      return heureDepart!.difference(heureArrivee!);
    }
    return null;
  }
}
