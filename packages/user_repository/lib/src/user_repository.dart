import 'package:core/core.dart';
import 'package:user_repository/user_repository.dart';


class UserRepository {
  User? _user;

  Future<User?> getUser(String? token) async {
    if (token == null || token.isEmpty) return null;
    if (_user != null) return _user;

    print('YummyHouse Hive box opened: ${yummyHouseHive.isOpen}');

    final User? user = yummyHouseHive.get('user');
    print('User from Hive: $user');
    if (user != null) {
      _user = user;
      return _user;
    }

    try {
      final users = await getRequest<User>(
        '/user',
        User.fromJson,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (users.isNotEmpty) {
        _user = users.first;
        yummyHouseHive.put('user', _user as User);
        return _user;
      }
    } catch (e, stackTrace) {
      print('Error in UserRepository is $e, Trace $stackTrace');
      return null;
    }

    return null;
  }
}
