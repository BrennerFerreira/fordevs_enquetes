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
      body: Builder(
        builder: (context) {
          loginPresenter?.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return SimpleDialog(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator.adaptive(),
                          SizedBox(height: 10),
                          Text(
                            "Aguarde...",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            } else {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            }
          });

          loginPresenter?.authErrorStream.listen((authError) {
            if (authError?.isNotEmpty == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).errorColor,
                  content: Text(
                    authError!,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          });

          return SingleChildScrollView(
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
                            stream: loginPresenter?.emailErrorStream,
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
                              stream: loginPresenter?.passwordErrorStream,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Senha",
                                    icon: Icon(
                                      Icons.lock,
                                      color:
                                          Theme.of(context).primaryColorLight,
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
                        StreamBuilder<bool>(
                            stream: loginPresenter?.isFormValidStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: snapshot.data == true
                                    ? loginPresenter?.auth
                                    : null,
                                child: Text("Entrar".toUpperCase()),
                              );
                            }),
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
          );
        },
      ),
    );
  }
}
