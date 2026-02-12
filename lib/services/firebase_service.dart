import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alpha_fitness/models/member_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collection = 'members';

  // --- Ajouter un nouvel abonné ---
  Future<void> addMember(MemberModel member) async {
    await _db.collection(collection).add(member.toMap());
  }

  // --- Obtenir tous les abonnés actifs ---
  Stream<List<MemberModel>> getActiveMembers() {
    return _db
        .collection(collection)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MemberModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // --- Obtenir un abonné spécifique par son ID ---
  Future<MemberModel?> getMemberById(String id) async {
    final doc = await _db.collection(collection).doc(id).get();
    if (doc.exists) {
      return MemberModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // --- Mettre à jour un abonné (pour le renouvellement) ---
  Future<void> updateMember(String id, MemberModel member) async {
    await _db.collection(collection).doc(id).update(member.toMap());
  }

  // --- Marquer un abonné comme "parti" ---
  Future<void> markMemberAsLeft(String id) async {
    await _db.collection(collection).doc(id).update({'status': 'left'});
  }

  // --- Obtenir les abonnements expirés ---
  Stream<List<MemberModel>> getExpiredMembers() {
    DateTime now = DateTime.now();
    return _db
        .collection(collection)
        .where('status', isEqualTo: 'active')
        .where('endDate', isLessThan: now.toIso8601String())
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MemberModel.fromMap(doc.data(), doc.id))
            .toList());
  }
  
  // --- Obtenir les statistiques pour le tableau de bord ---
  Stream<Map<String, dynamic>> getDashboardStats() {
    return _db.collection('members').snapshots().map((snapshot) {
      int activeCount = 0;
      int expiringThisMonthCount = 0;
      double monthlyRevenue = 0.0;
      DateTime now = DateTime.now();
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);

      for (var doc in snapshot.docs) {
        var data = doc.data();
        if (data['status'] == 'active') {
          activeCount++;
          monthlyRevenue += (data['price'] ?? 0.0);
          
          DateTime endDate = DateTime.parse(data['endDate']);
          if (endDate.isAfter(now.subtract(const Duration(days: 1))) && endDate.isBefore(endOfMonth)) {
            expiringThisMonthCount++;
          }
        }
      }
      return {
        'activeCount': activeCount,
        'expiringThisMonthCount': expiringThisMonthCount,
        'monthlyRevenue': monthlyRevenue,
      };
    });
  }
}