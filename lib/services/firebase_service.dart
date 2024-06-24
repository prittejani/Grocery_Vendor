import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  CollectionReference boys = FirebaseFirestore.instance.collection("boys");
  CollectionReference vendorsDetail =
      FirebaseFirestore.instance.collection("vendors");
  CollectionReference orders = FirebaseFirestore.instance.collection("orders");
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;

  getStoreDetails() async {
    DocumentSnapshot doc = await vendorsDetail.doc(user!.uid).get();
    return doc;
  }

  Future<DocumentSnapshot> getUserDetails(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }

  Future<void> selectBoy({orderId, location, name, image, phone,email}) {
    var result = orders.doc(orderId).update({
      'deliveryBoy': {
        'email' : email,
        'location': location,
        'name': name,
        'image': image,
        'phone': phone,
      }
    });
    return result;
  }
}
