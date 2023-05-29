import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc_example/src/auth/data/models/user.dart';
import 'package:flutter_webrtc_example/src/common/services/id_service.dart';
import 'package:flutter_webrtc_example/src/streaming/data/repository/fb_realtime_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'users_state.dart';

@injectable
class UsersCubit extends Cubit<UsersState> {
  final FbRealtimeRepository _fbRealtimeRepository;
  final IdService _idService;
  UsersCubit(this._fbRealtimeRepository, this._idService)
      : super(
          UsersInProgress(),
        );

  Future<void> load() async {
    try {
      final myId = _idService.id;

      final users = await _fbRealtimeRepository.getAllUsers();

      users.removeWhere((user) => user.id == myId || !user.isOnline);

      emit(UsersCompleted(users));
    } catch (e) {
      print(e);
      emit(UsersFailure());
    }
  }
}
