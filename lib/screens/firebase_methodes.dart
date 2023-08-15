import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_crud/utils/article_model.dart';
import 'package:uuid/uuid.dart';

class FirebaseMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;



  // register methode
  Future<String> register(String email, String password)async{
  String res = "une erreur s'est produite .";

  try {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if(credential.user != null){
      res = "success";
    }
  } on FirebaseAuthException catch (error) {
    res = error.code;
  }

  return res;

  }


  // Login methode

  Future<String> login(String email , String password )async{

    String res = "Une erreur s'est produite";

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(credential.user != null){
        res = "success";
      }
      return res;
    } on FirebaseAuthException catch (error) {


      res = error.code;

      return res;
    }
}

  // logout method

  Future<String> logout()async{
    String res = "Une erreur s'est produite";
    await _auth.signOut().then((value) {
      res = "success";
    }).onError((error, stackTrace){
      res = error.toString();
    });
    return res;
  }

  // For FireStore using

  Future<String> addArticleToFirestore(String title,String description,Uint8List imageData)async{
    String res = "Une erreur s'est produite";
    // Storing image to FirebaseStorage
    try {
      String url = await uploadImageToStorage(imageData);

      // Store Article to FireStore
      String articleId = const Uuid().v1();
      Article article = Article(id: articleId, title: title, description: description, image: url, createdAt: DateTime.now(), updateAt: DateTime.now(), userId: _auth.currentUser!.uid);
      await _firestore.collection('Articles').doc(articleId).set(article.toMap(article))
      .then((value){
        res = 'success';
      }).onError((error, stackTrace) {
        res = error.toString();
        print(error);
      });
    }  catch (e) {
      res = e.toString();
      print(res);
    }

    return res;
  }

  Future<String> uploadImageToStorage(Uint8List data)async{
    String path = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = _storage.ref().child('ArtiCleImages').child(path);
      UploadTask uploadTask = ref.putData(data);
      
      TaskSnapshot taskSnapshot = await uploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();
      
      return url;
      
  }

  // Delete Article fromFirestore

  Future<String> deleteArticle(Article article)async{

    String res = "Une errreur s'est produite";
    var ref = _storage.refFromURL(article.image!);
    await ref.delete();
    await _firestore.collection("Articles").doc(article.id!).delete().then((value) {
      res = "success";
    }).onError((error, stackTrace) {
      res = error.toString();
    });
    return res;
  }


  // update Article
  Future<String> updateArticle(Article article,Uint8List? image_data)async{
    String res = "Une erreur s'est produite";

    try {
      if(image_data!=null){
        var ref = _storage.refFromURL(article.image!);
       await  ref.putData(image_data);
      }
      Article newArticle = Article(id: article.id!,
          title: article.title!,
          description: article.description!,
          image: article.image!,
          createdAt: article.createdAt,
          updateAt: DateTime.now(),
          userId: article.userId
      );
      await _firestore.collection("Articles").doc(article.id!).set(
        newArticle.toMap(newArticle)
      );
      res = "success";

    } on Exception catch (error) {
      res = error.toString();

    }
    return res;
  }

}