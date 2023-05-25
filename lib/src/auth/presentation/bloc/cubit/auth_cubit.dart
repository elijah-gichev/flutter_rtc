import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc_example/src/auth/data/auth_repository.dart';
import 'package:flutter_webrtc_example/src/common/services/id_service.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final IdService _idService;
  AuthCubit(
    this._authRepository,
    this._idService,
  ) : super(AuthInProgress());

  Future<void> logIn() async {
    try {
      final id = _idService.id;

      final isRegistered = await _authRepository.isRegistered(id);
      if (!isRegistered) {
        await _authRepository.register(id);
      }

      emit(AuthCompleted());
    } catch (e) {
      print(e);
      emit(AuthFailure());
    }
  }
}
