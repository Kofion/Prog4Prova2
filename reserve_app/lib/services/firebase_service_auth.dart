import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServiceAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('Erro ao criar usuário: ${e.message}');
      throw Exception('Erro ao criar usuário: ${e.message}');
    } catch (e) {
      print('Erro desconhecido ao criar usuário: $e');
      throw Exception('Erro desconhecido ao criar usuário');
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('Erro ao fazer login: ${e.message}');
      throw Exception('Erro ao fazer login: ${e.message}');
    } catch (e) {
      print('Erro desconhecido ao fazer login: $e');
      throw Exception('Erro desconhecido ao fazer login');
    }
  }
}
