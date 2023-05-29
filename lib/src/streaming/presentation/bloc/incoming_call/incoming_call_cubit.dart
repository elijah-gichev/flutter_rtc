import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc_example/src/auth/data/models/user.dart';
import 'package:flutter_webrtc_example/src/common/services/id_service.dart';
import 'package:flutter_webrtc_example/src/streaming/data/repository/fb_realtime_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'incoming_call_state.dart';

@injectable
class IncomingCallCubit extends Cubit<IncomingCallState> {
  final FbRealtimeRepository _fbRealtimeRepository;
  final IdService _idService;

  IncomingCallCubit(
    this._fbRealtimeRepository,
    this._idService,
  ) : super(IncomingCallInitial()) {
    makeSubscriptionYourself();
  }

  void makeSubscriptionYourself() {
    _fbRealtimeRepository.addOnChildAddedSubscription(
      _idService.id,
      (event) async {
        if (state is! IncomingCallAdmission) {
          final data = event.snapshot.value as Map<Object?, Object?>;
          final senderId = data['sender'] as String;
          if (senderId != _idService.id) {
            final callerUser =
                await _fbRealtimeRepository.getUserById(senderId);
            emit(IncomingCallAdmission(callerUser));
          }
        }
      },
    );
  }

  Future<void> rejectIncomingCall() async {
    await _fbRealtimeRepository.clearAll();
  }

  void acceptIncomingCall() {
    emit(IncomingCallInitial());
  }
}
