// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_core/firebase_core.dart' as _i3;
import 'package:firebase_database/firebase_database.dart' as _i4;
import 'package:flutter_webrtc_example/src/auth/data/auth_repository.dart'
    as _i7;
import 'package:flutter_webrtc_example/src/auth/presentation/bloc/cubit/auth_cubit.dart'
    as _i9;
import 'package:flutter_webrtc_example/src/common/config/injectable/app_module.dart'
    as _i13;
import 'package:flutter_webrtc_example/src/common/services/id_service.dart'
    as _i8;
import 'package:flutter_webrtc_example/src/streaming/data/repository/fb_realtime_repository.dart'
    as _i10;
import 'package:flutter_webrtc_example/src/streaming/data/repository/webrtc_repository.dart'
    as _i6;
import 'package:flutter_webrtc_example/src/streaming/presentation/bloc/peer_connection/peer_connection_bloc.dart'
    as _i11;
import 'package:flutter_webrtc_example/src/streaming/presentation/bloc/users/users_cubit.dart'
    as _i12;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final appModule = _$AppModule();
  await gh.lazySingletonAsync<_i3.FirebaseApp>(
    () => appModule.firebaseApp,
    preResolve: true,
  );
  gh.singleton<_i4.FirebaseDatabase>(appModule.firebaseDatabase);
  await gh.lazySingletonAsync<_i5.SharedPreferences>(
    () => appModule.preference,
    preResolve: true,
  );
  gh.lazySingleton<_i6.WebRTCRepository>(() => _i6.WebRTCRepository());
  gh.lazySingleton<_i7.AuthRepository>(
      () => _i7.AuthRepository(get<_i4.FirebaseDatabase>()));
  gh.lazySingleton<_i8.IdService>(
      () => _i8.IdService(get<_i5.SharedPreferences>()));
  gh.factory<_i9.AuthCubit>(() => _i9.AuthCubit(
        get<_i7.AuthRepository>(),
        get<_i8.IdService>(),
      ));
  gh.lazySingleton<_i10.FbRealtimeRepository>(() => _i10.FbRealtimeRepository(
        get<_i4.FirebaseDatabase>(),
        get<_i8.IdService>(),
      ));
  gh.factory<_i11.PeerConnectionBloc>(() => _i11.PeerConnectionBloc(
        get<_i10.FbRealtimeRepository>(),
        get<_i6.WebRTCRepository>(),
        get<_i8.IdService>(),
      ));
  gh.factory<_i12.UsersCubit>(() => _i12.UsersCubit(
        get<_i10.FbRealtimeRepository>(),
        get<_i8.IdService>(),
      ));
  return get;
}

class _$AppModule extends _i13.AppModule {}
