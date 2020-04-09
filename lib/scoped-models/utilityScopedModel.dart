import 'package:scoped_model/scoped_model.dart';


mixin UtilityModel on Model {

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }
}