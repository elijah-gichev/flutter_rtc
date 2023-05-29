import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc_example/src/auth/data/auth_repository.dart';
import 'package:flutter_webrtc_example/src/auth/data/models/user.dart';
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
  ) : super(AuthInitial());

  Future<void> logIn() async {
    try {
      emit(AuthInProgress());

      final id = _idService.id;
      final name = 'Anonymous';
      final isOnline = true;

      final isRegistered = await _authRepository.isRegistered(id);
      if (!isRegistered) {
        await _authRepository.register(
          accountID: id,
          name: name,
          isOnline: isOnline,
        );
      }

      emit(
        AuthCompleted(
          User(
            id: id,
            name: name,
            isOnline: isOnline,
          ),
        ),
      );
    } catch (e) {
      print(e);
      emit(AuthFailure());
    }
  }

  Future<void> logOut() async {
    emit(AuthInitial());
  }
}
