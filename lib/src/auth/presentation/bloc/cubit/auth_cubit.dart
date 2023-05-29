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

  User? lastUser;
  AuthCubit(
    this._authRepository,
    this._idService,
  ) : super(AuthInitial()) {
    final id = _idService.id;
    _authRepository.subscribeToUserChanges(id, (event) {
      final key = event.snapshot.key;
      final value = event.snapshot.value;

      if (key == 'name') {
        emit(
          AuthCompleted(
            lastUser!.copyWith(name: value as String),
          ),
        );
      }

      if (key == 'is_online') {
        emit(
          AuthCompleted(
            lastUser!.copyWith(isOnline: value as bool),
          ),
        );
      }
    });
  }

  Future<void> logIn() async {
    try {
      emit(AuthInProgress());

      final id = _idService.id;

      String name;
      bool isOnline;

      final registeredUser = await _authRepository.isRegistered(id);
      if (registeredUser == null) {
        name = 'Anonymous';
        isOnline = true;

        await _authRepository.register(
          accountID: id,
          name: name,
          isOnline: isOnline,
        );
      } else {
        name = registeredUser.name;
        isOnline = registeredUser.isOnline;
      }

      lastUser = User(
        id: id,
        name: name,
        isOnline: isOnline,
      );

      emit(
        AuthCompleted(lastUser!),
      );
    } catch (e) {
      print(e);
      emit(AuthFailure());
    }
  }

  Future<void> logOut() async {
    emit(AuthInitial());
  }

  Future<void> changeIsOnline(bool isOnline) async {
    try {
      emit(AuthInProgress());

      final id = _idService.id;

      await _authRepository.changeIsOnline(id, isOnline);
    } catch (e) {
      emit(AuthFailure());
    }
  }

  Future<void> changeName(String name) async {
    try {
      emit(AuthInProgress());

      final id = _idService.id;

      await _authRepository.changeName(id, name);
    } catch (e) {
      emit(AuthFailure());
    }
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    print(change.toString());
    print(change.currentState.toString());
    print(change.nextState.toString());
  }
}
