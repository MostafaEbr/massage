import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/modules/profile/cubit/states.dart';

class ProfileBloc extends Cubit<ProfileState> {

  ProfileBloc() : super(InitialProfileState());
  static ProfileBloc get(context) => BlocProvider.of(context);




}
