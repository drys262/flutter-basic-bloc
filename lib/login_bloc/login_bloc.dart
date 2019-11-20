import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sample_bloc/login_bloc/authentication_bloc.dart';
import 'package:sample_bloc/login_bloc/login_events.dart';
import 'package:sample_bloc/login_bloc/login_state.dart';
import 'package:sample_bloc/login_bloc/user_repository.dart';

import 'authentication_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({@required this.userRepository, @required this.authenticationBloc})
      : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final token = await userRepository.authenticate(
            username: event.username, password: event.password);
        authenticationBloc.dispatch(LoggedIn(token: token));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
