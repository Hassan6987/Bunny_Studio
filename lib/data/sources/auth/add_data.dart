import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify/presentation/home/pages/home.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
class StoreData{

  Future<String> uploadImageToStorage(String childName, Uint8List file, String? id) async{
    Reference ref = _storage.ref().child(childName).child(id!);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<Object> saveData({required String name, required String email, required String password, required Uint8List file, required BuildContext context})async{
    String resp = "Some Error Occurred";
    try {
      if(name.isNotEmpty ||email.isNotEmpty || password.isNotEmpty || file.isNotEmpty){
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      String imageUrl = await uploadImageToStorage('profileImage', file, data.user?.uid);

      _firestore.collection('Users').doc(data.user?.uid)
          .set(
          {
            'name': name,
            'email': data.user?.email,
            'imageLink': imageUrl,
          }
      );
      resp = 'Success';
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
              (route) => false
      );
    }
    }on FirebaseAuthException catch(e) {
      String message = '';

      if(e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }


      return Left(message);
    }
    catch(err){
      resp= err.toString();
    }
    return resp;
  }
}