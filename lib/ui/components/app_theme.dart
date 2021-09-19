import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  const primaryColor = Color.fromRGBO(136, 14, 79, 1);
  const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
  final theme = ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    errorColor: Colors.red[900],
    backgroundColor: Colors.white,
    disabledColor: Colors.grey,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: primaryColorDark,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionHandleColor: primaryColor,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColorLight),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      alignLabelWithHint: true,
      labelStyle: TextStyle(color: primaryColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            }

            return primaryColor;
          },
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            return states.contains(MaterialState.pressed)
                ? primaryColorLight
                : null;
          },
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          const StadiumBorder(),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.pressed)
                ? primaryColorLight.withOpacity(0.25)
                : null;
          },
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
      ),
    ),
  );

  return theme.copyWith(
    colorScheme: theme.colorScheme.copyWith(
      secondary: primaryColor,
      secondaryVariant: primaryColorLight,
    ),
  );
}
