import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/models/auth/user.dart';
import 'package:spotify/domain/entities/auth/user.dart';

abstract class AuthFirebaseService {


  Future<Either> getUser();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {

  
  @override
  Future < Either > getUser() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var userDoc = await firebaseFirestore.collection('Users').doc(
          firebaseAuth.currentUser?.uid
      ).get();
      if (userDoc.exists) {
        UserModel userModel = UserModel.fromJson(userDoc.data()!);
        UserEntity userEntity = userModel.toEntity();
        return Right(userEntity);
      } else {
        return const Left('User data not found');
      }

    } catch (e) {
      return Left('An error occurred: $e');
    }
  }

  
}