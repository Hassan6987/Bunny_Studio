import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify/domain/repository/auth/auth.dart';

import '../../../service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {

  @override
  Future<Either> getUser() async {
    return await sl<AuthFirebaseService>().getUser();
  }
  }
