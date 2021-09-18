import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import 'components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? loginPresenter;
  const LoginPage(this.loginPresenter, {Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    widget.loginPresenter?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.loginPresenter?.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.loginPresenter?.authErrorStream.listen((authError) {
            if (authError?.isNotEmpty == true) {
              showErrorMessage(context, text: authError!);
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
                  child: Provider<LoginPresenter?>(
                    create: (context) => widget.loginPresenter,
                    child: Form(
                      child: Column(
                        children: [
                          const EmailInput(),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 32),
                            child: PasswordInput(),
                          ),
                          StreamBuilder<bool>(
                              stream: widget.loginPresenter?.isFormValidStream,
                              builder: (context, snapshot) {
                                return ElevatedButton(
                                  onPressed: snapshot.data == true
                                      ? widget.loginPresenter?.auth
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
