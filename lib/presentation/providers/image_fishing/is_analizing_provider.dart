import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_analizing_provider.g.dart';

@riverpod
class IsAnalizingProvider extends _$IsAnalizingProvider {
  @override
  bool build() => false;

  void setIsAnalizing() {
    state = true;
  }

  void setIsNotAnalizing() {
    state = false;
  }
}