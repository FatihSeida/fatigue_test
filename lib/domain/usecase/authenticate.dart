import 'package:dartz/dartz.dart';
import 'package:fatigue_tester/domain/repository/user_repository.dart';

import '../../data/model/user.dart';
import '../../utils/extension/failure.dart';

class Authenticate {
  final UserRepository repository;

  Authenticate(this.repository);

  Future<Either<Failure, User>> execute(String username, String password) {
    return repository.login(username, password);
  }
}
