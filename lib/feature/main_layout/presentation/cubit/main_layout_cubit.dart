import 'package:flutter_bloc/flutter_bloc.dart';

import "package:pagebridge/core/services/shared_preferences_singleton.dart";

class MainLayoutCubit extends Cubit<int> {
  String? get workspaceName =>
      SharedPreferencesSingleton.getString("workspaceName");
  String? get ownerAvatarUrl =>
      SharedPreferencesSingleton.getString("ownerAvatarUrl");
  MainLayoutCubit() : super(0);

  void changeTab(int index) => emit(index);
}
