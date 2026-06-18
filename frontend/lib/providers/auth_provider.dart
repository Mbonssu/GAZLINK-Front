import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import '../models/models.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user         => _user;
  UserModel? get currentUser  => _user;
  bool get isLoading          => _isLoading;
  String? get error           => _error;
  bool get isAuthenticated    => _user != null;

  // ── Écouter les changements de session Supabase ──────────
  AuthProvider() {
    supabase.auth.onAuthStateChange.listen((data) async {
      final event   = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        await _chargerProfil(session.user.id);
      } else if (event == AuthChangeEvent.signedOut) {
        _user = null;
        notifyListeners();
      } else if (event == AuthChangeEvent.tokenRefreshed && session != null) {
        // Session rafraîchie silencieusement — pas besoin de notifier
        logger.d('Session rafraîchie pour ${session.user.id}');
      }
    });

    // Si une session existe déjà au démarrage (utilisateur déjà connecté)
    _restaurerSession();
  }

  // ── Restaurer la session existante au démarrage ──────────
  Future<void> _restaurerSession() async {
    final session = supabase.auth.currentSession;
    if (session != null) {
      await _chargerProfil(session.user.id);
    }
  }

  // ── Charger le profil depuis la table `profils` ──────────
  Future<void> _chargerProfil(String userId) async {
    try {
      final data = await supabase
          .from('profils')
          .select()
          .eq('id', userId)
          .eq('est_actif', true)
          .single();

      _user = UserModel.fromJson(data);
      logger.i('Profil chargé : ${_user!.nom} (${_user!.role.label})');
    } catch (e) {
      logger.e('Erreur chargement profil : $e');
      // Profil introuvable ou désactivé → déconnecter
      await supabase.auth.signOut();
      _user = null;
    }
    notifyListeners();
  }

  // ── Inscription ──────────────────────────────────────────
  Future<bool> inscrire({
    required String email,
    required String password,
    required String nom,
    required String telephone,
    required UserRole role,
  }) async {
    _setLoading(true);

    try {
      // 1. Créer le compte Auth Supabase
      final response = await supabase.auth.signUp(
        email:    email,
        password: password,
        data: {
          'nom':       nom,
          'telephone': telephone,
          'role':      role.dbValue,
        },
      );

      if (response.user == null) {
        _setError('Inscription échouée. Vérifie ton email.');
        return false;
      }

      // 2. Créer le profil dans la table `profils`
      await supabase.from('profils').insert({
        'id':        response.user!.id,
        'email':     email,
        'nom':       nom,
        'telephone': telephone,
        'role':      role.dbValue,
      });

      logger.i('Inscription réussie : $email');
      _setLoading(false);
      return true;
    } on AuthException catch (e) {
      _setError(_traduireErreurAuth(e.message));
      return false;
    } catch (e) {
      logger.e('Erreur inscription : $e');
      _setError('Une erreur est survenue. Réessaie.');
      return false;
    }
  }

  // ── Connexion ────────────────────────────────────────────
  Future<bool> connecter({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final response = await supabase.auth.signInWithPassword(
        email:    email,
        password: password,
      );

      if (response.user == null) {
        _setError('Identifiants incorrects.');
        return false;
      }

      // Le profil sera chargé via onAuthStateChange
      _setLoading(false);
      return true;
    } on AuthException catch (e) {
      _setError(_traduireErreurAuth(e.message));
      return false;
    } catch (e) {
      logger.e('Erreur connexion : $e');
      _setError('Une erreur est survenue. Réessaie.');
      return false;
    }
  }

  // ── Déconnexion ──────────────────────────────────────────
  Future<void> deconnecter() async {
    try {
      await supabase.auth.signOut();
      _user = null;
      _error = null;
      notifyListeners();
      logger.i('Déconnexion réussie');
    } catch (e) {
      logger.e('Erreur déconnexion : $e');
    }
  }

  // ── Mot de passe oublié ──────────────────────────────────
  Future<bool> reinitialiserMotDePasse(String email) async {
    _setLoading(true);
    try {
      await supabase.auth.resetPasswordForEmail(email);
      _setLoading(false);
      return true;
    } on AuthException catch (e) {
      _setError(_traduireErreurAuth(e.message));
      return false;
    } catch (e) {
      _setError('Erreur lors de l\'envoi de l\'email.');
      return false;
    }
  }

  // ── Changer le mot de passe ──────────────────────────────
  Future<bool> changerMotDePasse(String nouveauMotDePasse) async {
    _setLoading(true);
    try {
      await supabase.auth.updateUser(
        UserAttributes(password: nouveauMotDePasse),
      );
      _setLoading(false);
      return true;
    } on AuthException catch (e) {
      _setError(_traduireErreurAuth(e.message));
      return false;
    } catch (e) {
      _setError('Erreur lors du changement de mot de passe.');
      return false;
    }
  }

  // ── Mettre à jour le profil ──────────────────────────────
  Future<bool> mettreAJourProfil({
    String? nom,
    String? telephone,
  }) async {
    if (_user == null) return false;
    _setLoading(true);

    try {
      final updates = <String, dynamic>{
        if (nom != null)       'nom': nom,
        if (telephone != null) 'telephone': telephone,
      };

      await supabase
          .from('profils')
          .update(updates)
          .eq('id', _user!.id);

      _user = _user!.copyWith(nom: nom, telephone: telephone);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      logger.e('Erreur mise à jour profil : $e');
      _setError('Erreur lors de la mise à jour du profil.');
      return false;
    }
  }

  // ── Désactiver le compte (soft delete) ───────────────────
  // Le compte n'est pas supprimé — on coupe juste les accès
  Future<bool> desactiverCompte() async {
    if (_user == null) return false;
    _setLoading(true);

    try {
      await supabase.from('profils').update({
        'est_actif':  false,
        'deleted_at': DateTime.now().toIso8601String(),
      }).eq('id', _user!.id);

      await deconnecter();
      return true;
    } catch (e) {
      logger.e('Erreur désactivation compte : $e');
      _setError('Erreur lors de la désactivation du compte.');
      return false;
    }
  }

  // ── Helpers internes ─────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _error = null;
    notifyListeners();
  }

  void _setError(String message) {
    _error    = message;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Traduit les messages d'erreur Supabase en français
  String _traduireErreurAuth(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Email ou mot de passe incorrect.';
    }
    if (message.contains('Email not confirmed')) {
      return 'Confirme ton email avant de te connecter.';
    }
    if (message.contains('User already registered')) {
      return 'Un compte existe déjà avec cet email.';
    }
    if (message.contains('Password should be at least')) {
      return 'Le mot de passe doit contenir au moins 6 caractères.';
    }
    if (message.contains('rate limit')) {
      return 'Trop de tentatives. Attends quelques minutes.';
    }
    return message;
  }
}