import 'package:bloc/bloc.dart';
import 'package:pagebridge/feature/auth/domain/repo/auth_repository.dart';

import '../../../domain/entities/auth_token_entity.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRep;

  AuthCubit({required this.authRep}) : super(const AuthInitial());

  Future<void> signIn() async {
    emit(const AuthLoading());
    final result = await authRep.signInWithNotion();
    result.fold(
      (failure) {
        if (!isClosed) emit(AuthFailure(message: failure.message));
      },
      (token) {
        if (!isClosed) emit(AuthSuccess(token: token));
      },
    );
  }
}
