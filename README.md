# Suivi Absence Mobile

Application mobile de suivi des absences développée avec Flutter et GetX.

## 🚀 Fonctionnalités

- Authentification des utilisateurs
- Gestion des pointages
- Interface moderne et responsive

## 📱 Screenshots

Pas encore disponible

## 🛠 Technologies Utilisées

- Flutter
- GetX pour la gestion d'état
- Architecture MVC+S

## 🏗 Architecture du Projet

```
lib/
  ├── app/
  │   ├── data/
  │   │   ├── controllers     # Données Globales
  |   |   ├── models/         # Modèles de données
  │   │   ├── providers/      # Communication API
  │   │   └── repositories/   # Logique métier
  │   ├── modules/
  │   │   ├── login/         # Module de connexion
  │   │   └── pointage/      # Module de pointage
  │   └── routes/            # Configuration des routes
  └── main.dart
```

## 🚦 Pour Commencer

1. Clonez le repository
```bash
git clone https://github.com/votre-username/suivi-absence-mobile
```

2. Installez les dépendances
```bash
flutter pub get
```

3. Lancez l'application
```bash
flutter run
```

## 📝 Configuration

Pour la configuration de l'API, modifiez le fichier `lib/app/data/providers/auth_provider.dart`

## 👥 Contributeurs

- Fatima KEITA
- Anna NDIAYE
- Mamadou Bobo BAH
- Adja Mariem KEITA
- Fatoumata Binetou aidel KABIR
- Ameth Touré
- Ousmane BA