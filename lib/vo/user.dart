import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  const User(
      {@required this.email,
      @required this.id,
      @required this.name,
      @required this.photo,
      @required this.emailVerified})
      : assert(id != null);

  final String email;
  final String id;
  final String name;
  final String photo;
  final bool emailVerified;

  static const empty = User(email: '', id: '', name: null, photo: null, emailVerified: false);

  @override
  List<Object> get props => [email, id, name, photo, emailVerified];
}
