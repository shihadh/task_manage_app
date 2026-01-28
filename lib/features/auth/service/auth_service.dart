import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/dio_client.dart';
import '../model/user_model.dart';

class AuthService {
  final DioClient _dioClient;

  AuthService(this._dioClient);

  Future<({UserModel? user, String? token, String? error})> login(
    String username,
    String password,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final userMap = response.data['user'];
        final user = UserModel.fromJson(userMap);
        return (user: user, token: token as String?, error: null);
      }
      return (
        user: null,
        token: null,
        error: '${response.statusCode} - Login failed',
      );
    } on DioException catch (e) {
      return (
        user: null,
        token: null,
        error: (e.response?.data['error'] ?? 'Login failed. Please try again.')
            .toString(),
      );
    } catch (e) {
      return (
        user: null,
        token: null,
        error: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
}
