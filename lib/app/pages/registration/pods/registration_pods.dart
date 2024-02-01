import 'package:code_todo/app/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLoginProvider = StateProvider<UserModel>((ref) {
  return UserModel();
});
