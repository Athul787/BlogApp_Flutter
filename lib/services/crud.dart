import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CrudMethods{
  Future<void> addData(blogData,String? uniqueId) async{
    FirebaseFirestore.instance.collection("blogs").doc(uniqueId).set(blogData).catchError((e){
      print(e);
    });
  }
  Future getData() async{


    return await FirebaseFirestore.instance.collection("blogs").orderBy('createdTime',descending: true).snapshots();

  }

 Future getmyData() async{
   final firebaseUser=FirebaseAuth.instance.currentUser;

  return await FirebaseFirestore.instance.collection("blogs").where('Identity',isEqualTo: firebaseUser!.uid).orderBy('createdTime',descending: true).snapshots();
}



  // Future getUserData() async{
  //
  //   var User = await FirebaseAuth.instance.currentUser;
  //   return await FirebaseFirestore.instance.collection("users").doc(User!.uid).get();
  // }

}