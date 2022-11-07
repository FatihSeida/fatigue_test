import 'package:dartz/dartz.dart';

import '../../data/model/user.dart';
import '../../utils/extension/failure.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> login(String email, String password) ;
}