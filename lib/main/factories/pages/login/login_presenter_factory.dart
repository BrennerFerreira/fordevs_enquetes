import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/usecases.dart';
import 'login_validation_factory.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
    validation: makeLoginValidation(),
    authentication: makeRemoteAuthentication(),
  );
}
