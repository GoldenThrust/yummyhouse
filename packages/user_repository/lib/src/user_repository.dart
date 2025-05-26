import 'package:core/core.dart';
import 'package:user_repository/user_repository.dart';

class UserRepository {
  User? _user;

  Future<User?> getUser() async {
    if (_user != null) return _user;

    final users = await getRequest<User>('/users', User.fromJson);

    if (users.isNotEmpty) {
      _user = users.first;
      return _user;
    }

    return null;
  }
}
