import 'package:flutter/material.dart';

import '../ui/components/components.dart';
import '../ui/pages/pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ForDev',
      theme: makeAppTheme(),
      home: const LoginPage(null),
    );
  }
}
