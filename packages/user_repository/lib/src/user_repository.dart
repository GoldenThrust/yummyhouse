import 'package:core/core.dart';
import 'package:user_repository/user_repository.dart';

class UserRepository {
  User? _user;

  Future<User?> getUser(String? token) async {
    if (token == null || token.isEmpty) return null;

    if (_user != null) return _user;
    try {
      final users = await getRequest<User>('/user', User.fromJson, headers: {
        'Authorization': 'Bearer $token',
      });


      if (users.isNotEmpty) {
        _user = users.first;
        return _user;
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
