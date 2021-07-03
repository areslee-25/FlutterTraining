import 'package:rxdart/rxdart.dart';
import 'package:untitled/base/base_bloc.dart';
import 'package:untitled/data/model/base_model.dart';
import 'package:untitled/data/source/repository.dart';

class ProfileBloc extends BaseBloc {
  late Stream<User?> user$;

  ProfileBloc(UserRepository userRepository, TokenRepository tokenRepository) {
    final getUserController = BehaviorSubject<void>.seeded(0);

    user$ = getUserController.stream.flatMap(
        (value) => Rx.fromCallable(() => userRepository.getUserLocal()));

    user$.listen((event) {
      print("get User");
      print(event);
    });
  }
}
