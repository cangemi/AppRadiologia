import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreConn {
  FirebaseFirestore db = FirebaseFirestore.instance;

  lista(Function function, String collection) {
    db.collection(collection).snapshots().listen((snapshot) {
      for (DocumentSnapshot s in snapshot.docs) {
        function(s);
      }
    });
  }
}
