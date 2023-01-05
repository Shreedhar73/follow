import 'package:follow/features/authentication/blocs/login_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // register bloc
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(),
  );
} 
