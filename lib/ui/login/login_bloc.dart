import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:tuple/tuple.dart';
import 'package:untitled/base/base_bloc.dart';
import 'package:untitled/data/source/remote.dart';
import 'package:untitled/data/source/repository.dart';
import 'package:untitled/utils/disposeBag/dispose_bag.dart';

class LoginBloc extends BaseBloc {
  Function(String) userNameChanged;
  Function(String) passwordChanged;

  Sink<void> login;
  Sink<void> register;

  Stream<bool> isValidate;
  Stream<bool> loading;
  Stream<bool> loginStream;

  LoginBloc._({
    required DisposeBag disposeBag,
    required this.userNameChanged,
    required this.passwordChanged,
    required this.login,
    required this.loginStream,
    required this.register,
    required this.isValidate,
    required this.loading,
  }) : super(disposeBag);

  factory LoginBloc(
      UserRepository userRepository, TokenRepository tokenRepository) {
    final userNameController = PublishSubject<String>();
    final passwordController = PublishSubject<String>();

    final loginController = PublishSubject<void>();
    final registerController = PublishSubject<void>();

    final loadingController = BehaviorSubject<bool>.seeded(false);

    final controllers = [
      userNameController,
      passwordController,
      loginController,
      registerController,
      loadingController,
    ];

    final isValidStream = Rx.combineLatest2(
      userNameController.stream.map((event) => event.isNotEmpty),
      passwordController.stream.map((event) => event.isNotEmpty),
      (bool isValidUserName, bool isValidPassword) {
        return isValidUserName && isValidPassword;
      },
    ).shareValueSeeded(false);

    final loginInfoStream = Rx.combineLatest2(
      userNameController.stream,
      passwordController.stream,
      (String userName, String password) => Tuple2(userName, password),
    );

    final loginStream = loginController.stream
        .withLatestFrom(isValidStream, (_, bool isValidate) => isValidate)
        .where((isValidate) => isValidate)
        .flatMap((_) => Rx.fromCallable(() => userRepository.createToken())
            .doOnListen(() => loadingController.add(true))
            .doOnError((e, s) => loadingController.add(false)))
        .map((token) => token.token)
        .withLatestFrom(
          loginInfoStream,
          (token, Tuple2<String, String> newToken) => Tuple2(token, newToken),
        )
        .flatMap((value) {
          final token = value.item1;
          final userName = value.item2.item1;
          final password = value.item2.item2;
          return Rx.fromCallable(
              () => userRepository.loginUser(userName, password, token));
        })
        .flatMap((token) =>
            Rx.fromCallable(() => userRepository.getInfoUser(token.token))
                .doOnDone(() => tokenRepository.saveToken(token)))
        .map((user) => user.name.isNotEmpty);

    loginStream.listen((data) {
      print("Login Success");
      loadingController.add(false);
    }, onDone: () {
      print("Login Done");
    }, onError: (error) {
      print("Login Error");
      if (error is AppError) {
        loadingController.add(false);
      }
    });

    final streams = [isValidStream];

    return LoginBloc._(
      disposeBag: DisposeBag([...controllers, ...streams]),
      userNameChanged: userNameController.add,
      passwordChanged: passwordController.add,
      login: loginController.sink,
      register: registerController.sink,
      isValidate: isValidStream,
      loading: loadingController,
      loginStream: loginStream,
    );
  }
}
