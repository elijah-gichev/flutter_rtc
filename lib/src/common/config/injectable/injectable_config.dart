import 'package:flutter_webrtc_example/src/common/config/injectable/injectable_config.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: false, // default
  asExtension: false, // default
)
Future<GetIt> configureDependencies(String environment) =>
    $initGetIt(GetIt.I, environment: environment);
