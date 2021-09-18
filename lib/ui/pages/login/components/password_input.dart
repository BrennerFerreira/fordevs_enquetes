import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginPresenter = Provider.of<LoginPresenter?>(context);
    return StreamBuilder<String?>(
      stream: loginPresenter?.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: "Senha",
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
          ),
          obscureText: true,
          onChanged: loginPresenter?.validatePassword,
        );
      },
    );
  }
}
