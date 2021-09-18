import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginPresenter = Provider.of<LoginPresenter?>(context);
    return StreamBuilder<String?>(
      stream: loginPresenter?.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: "E-mail",
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: loginPresenter?.validateEmail,
        );
      },
    );
  }
}
