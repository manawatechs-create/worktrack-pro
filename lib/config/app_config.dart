class AppConfig {
  static const String appName = 'Gestion de Présence';
  static const String apiBaseUrl = 'http://localhost:3000/api';
  static const String appVersion = '1.0.0';
  
  // Configuration de présence
  static const double rayonGeolocalisation = 100.0; // mètres
  static const String heureDebutTravail = '08:00';
  static const String heureFinTravail = '17:00';
  static const int toleranceRetardMinutes = 15;
}
