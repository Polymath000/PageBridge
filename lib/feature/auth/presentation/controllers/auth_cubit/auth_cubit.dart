import 'package:bloc/bloc.dart';

import '../../../domain/entities/auth_token_entity.dart';
import '../../../domain/usecases/sign_in_with_notion_usecase.dart';

part 'auth_state.dart';

/// Controls Notion OAuth sign-in flow.
class AuthCubit extends Cubit<AuthState> {
  final SignInWithNotionUseCase signInWithNotion;

  AuthCubit({required this.signInWithNotion}) : super(const AuthInitial());

  Future<void> signIn() async {
    emit(const AuthLoading());
    final result = await signInWithNotion();
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (token) => emit(AuthSuccess(token: token)),
    );
  }
}
