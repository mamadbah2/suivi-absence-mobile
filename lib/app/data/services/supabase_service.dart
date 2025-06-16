import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class SupabaseService {
  static final SupabaseClient _supabaseClient = Supabase.instance.client;
  static const String _bucketName = 'justificatifs'; // Le nom de votre bucket Supabase

  // Initialisation de Supabase - à appeler au démarrage de l'application
  static Future<void> initialize({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    print('🔧 Initialisation de Supabase avec URL: $supabaseUrl');
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    print('✅ Supabase initialisé avec succès');
  }

  // Upload d'une image et retourne l'URL
  static Future<String?> uploadImage(dynamic image) async {
    try {
      final uuid = const Uuid().v4();
      String fileName;
      Uint8List? fileBytes;

      print('🔄 Début du processus d\'upload vers Supabase...');
      
      // Traitement différent selon le type d'image
      if (kIsWeb) {
        if (image is XFile) {
          fileBytes = await image.readAsBytes();
          fileName = '$uuid-${path.basename(image.name)}';
          print('📄 Image web préparée: $fileName (${fileBytes.length} octets)');
        } else {
          throw Exception('Format d\'image non supporté sur le web');
        }
      } else {
        if (image is File) {
          fileBytes = await image.readAsBytes();
          fileName = '$uuid-${path.basename(image.path)}';
          print('📄 Image mobile (File) préparée: $fileName (${fileBytes.length} octets)');
        } else if (image is XFile) {
          fileBytes = await image.readAsBytes();
          fileName = '$uuid-${path.basename(image.name)}';
          print('📄 Image mobile (XFile) préparée: $fileName (${fileBytes.length} octets)');
        } else {
          throw Exception('Format d\'image non supporté');
        }
      }

      print('📤 Tentative d\'upload du fichier "$fileName" dans le bucket "$_bucketName"...');
      
      // Uploader le fichier
      await _supabaseClient.storage.from(_bucketName).uploadBinary(
        fileName,
        fileBytes!,
        fileOptions: const FileOptions(
          cacheControl: '3600',
          contentType: 'image/jpeg',
        ),
      );

      // Récupérer l'URL publique du fichier
      final imageUrl = _supabaseClient.storage.from(_bucketName).getPublicUrl(fileName);
      
      print('✅ Image uploadée avec succès: $fileName');
      print('🔗 URL générée: $imageUrl');
      
      return imageUrl;
    } catch (e) {
      print('❌ Erreur lors de l\'upload de l\'image: $e');
      // Obtenir plus d'informations sur l'erreur
      if (e is StorageException) {
        print('  - Code: ${e.statusCode}');
        print('  - Message: ${e.message}');
        print('  - Erreur: ${e.error}');
      }
      return null;
    }
  }

  // Upload de plusieurs images et retourne les URLs
  static Future<List<String>> uploadImages(List<dynamic> images) async {
    List<String> urls = [];
    print('🔄 Début de l\'upload de ${images.length} image(s)...');
    
    for (int i = 0; i < images.length; i++) {
      print('📷 Upload de l\'image ${i+1}/${images.length}');
      final url = await uploadImage(images[i]);
      if (url != null) {
        urls.add(url);
        print('✓ Image ${i+1} uploadée: $url');
      } else {
        print('✗ Échec de l\'upload de l\'image ${i+1}');
      }
    }
    
    print('✅ Upload terminé: ${urls.length}/${images.length} images avec succès');
    return urls;
  }
}