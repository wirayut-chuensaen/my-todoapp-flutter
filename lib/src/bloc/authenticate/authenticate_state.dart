part of 'authenticate_cubit.dart';

class AuthenticateState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  const AuthenticateState({
    this.name = "",
    this.email = "",
    this.password = "",
    this.confirmPassword = "",
  });

  AuthenticateState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return AuthenticateState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  List<Object> get props => [
        name,
        email,
        password,
        confirmPassword,
      ];
}
