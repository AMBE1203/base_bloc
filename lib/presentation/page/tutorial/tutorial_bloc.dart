import 'package:base_bloc/presentation/base/index.dart';
import 'index.dart';

class TutorialBloc extends BaseBloc<BaseEvent, TutorialState> {
  TutorialBloc() : super(initState: TutorialState()) {}

  @override
  void dispose() {}
}
