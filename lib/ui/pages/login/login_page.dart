import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? loginPresenter;
  const LoginPage(this.loginPresenter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(),
            const Headline1(title: "Login"),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                child: Column(
                  children: [
                    StreamBuilder<String?>(
                        stream: loginPresenter?.emailErrorStream
                            as Stream<String?>?,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: "E-mail",
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              errorText: snapshot.data?.isEmpty == true
                                  ? null
                                  : snapshot.data,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: loginPresenter?.validateEmail,
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                      child: StreamBuilder<String?>(
                          stream: loginPresenter?.passwordErrorStream
                              as Stream<String?>?,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: "Senha",
                                icon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                errorText: snapshot.data?.isEmpty == true
                                    ? null
                                    : snapshot.data,
                              ),
                              obscureText: true,
                              onChanged: loginPresenter?.validatePassword,
                            );
                          }),
                    ),
                    ElevatedButton(
                      onPressed: null,
                      child: Text("Entrar".toUpperCase()),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      label: const Text("Criar conta"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
