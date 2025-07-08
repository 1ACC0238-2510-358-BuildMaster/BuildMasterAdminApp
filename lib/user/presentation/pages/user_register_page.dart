import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../styles/user_styles.dart';
import '../../../root_page.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({Key? key}) : super(key: key);

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String username = '';
  String password = '';
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: UserStyles.cardBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40),
              decoration: const BoxDecoration(
                color: UserStyles.primaryYellow,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(UserStyles.borderRadiusLarge),
                  bottomRight: Radius.circular(UserStyles.borderRadiusLarge),
                ),
              ),
              child: Column(
                children: const [
                  Text(
                    'Registro',
                    style: TextStyle(
                      color: UserStyles.darkText,
                      fontSize: UserStyles.headerFontSizeLarge,
                      fontWeight: UserStyles.fontWeightBold,
                      fontFamily: UserStyles.primaryFontFamily,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Crea una nueva cuenta',
                    style: TextStyle(
                      color: UserStyles.darkText,
                      fontSize: UserStyles.bodyFontSize,
                      fontWeight: UserStyles.fontWeightRegular,
                      fontFamily: UserStyles.primaryFontFamily,
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                padding: const EdgeInsets.all(UserStyles.paddingLarge),
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: UserStyles.white,
                  borderRadius: BorderRadius.circular(UserStyles.borderRadiusMedium),
                  boxShadow: UserStyles.cardShadow,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Bienvenido',
                        style: TextStyle(
                          color: UserStyles.darkText,
                          fontSize: UserStyles.headerFontSizeMedium,
                          fontWeight: UserStyles.fontWeightSemiBold,
                          fontFamily: UserStyles.primaryFontFamily,
                        ),
                      ),
                      const SizedBox(height: UserStyles.marginMedium),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: TextStyle(
                            color: UserStyles.darkText,
                            fontSize: UserStyles.smallFontSize,
                            fontWeight: UserStyles.fontWeightRegular,
                            fontFamily: UserStyles.primaryFontFamily,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(UserStyles.borderRadiusSmall)),
                            borderSide: BorderSide(color: UserStyles.inputBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(UserStyles.borderRadiusSmall)),
                            borderSide: BorderSide(color: UserStyles.primaryYellow),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: UserStyles.paddingSmall),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => setState(() => email = value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su correo';
                          }
                          if (!value.contains('@')) {
                            return 'Correo inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: UserStyles.marginMedium),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nombre de usuario',
                          labelStyle: TextStyle(
                            color: UserStyles.darkText,
                            fontSize: UserStyles.smallFontSize,
                            fontWeight: UserStyles.fontWeightRegular,
                            fontFamily: UserStyles.primaryFontFamily,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(UserStyles.borderRadiusSmall)),
                            borderSide: BorderSide(color: UserStyles.inputBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(UserStyles.borderRadiusSmall)),
                            borderSide: BorderSide(color: UserStyles.primaryYellow),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: UserStyles.paddingSmall),
                        ),
                        onChanged: (value) => setState(() => username = value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su nombre de usuario';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: UserStyles.marginMedium),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(
                            color: UserStyles.darkText,
                            fontSize: UserStyles.smallFontSize,
                            fontWeight: UserStyles.fontWeightRegular,
                            fontFamily: UserStyles.primaryFontFamily,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(UserStyles.borderRadiusSmall)),
                            borderSide: BorderSide(color: UserStyles.inputBorder),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(UserStyles.borderRadiusSmall)),
                            borderSide: BorderSide(color: UserStyles.primaryYellow),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: UserStyles.paddingSmall),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword ? Icons.visibility : Icons.visibility_off,
                              color: UserStyles.placeholderText,
                            ),
                            onPressed: () => setState(() => showPassword = !showPassword),
                          ),
                        ),
                        obscureText: !showPassword,
                        onChanged: (value) => setState(() => password = value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su contraseña';
                          }
                          if (value.length < 6) {
                            return 'Mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: UserStyles.marginMedium),
                      if (userProvider.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: UserStyles.marginSmall),
                          child: Text(
                            userProvider.errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: UserStyles.smallFontSize),
                          ),
                        ),
                      SizedBox(
                        height: UserStyles.buttonHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UserStyles.primaryYellow,
                            foregroundColor: UserStyles.darkText,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(UserStyles.borderRadiusMedium),
                            ),
                            elevation: 4,
                            shadowColor: UserStyles.buttonShadow[0].color,
                            textStyle: const TextStyle(
                              fontSize: UserStyles.buttonFontSize,
                              fontWeight: UserStyles.fontWeightSemiBold,
                              fontFamily: UserStyles.primaryFontFamily,
                            ),
                          ),
                          onPressed: userProvider.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await userProvider.register(email, username, password);
                                    if (success && mounted) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => const RootPage()),
                                        (route) => false,
                                      );
                                    }
                                  }
                                },
                          child: userProvider.isLoading
                              ? const CircularProgressIndicator(color: UserStyles.darkText)
                              : const Text('Registrarse'),
                        ),
                      ),
                      const SizedBox(height: UserStyles.marginSmall),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          '¿Ya tienes cuenta? Inicia sesión',
                          style: TextStyle(
                            color: UserStyles.lightText,
                            fontSize: UserStyles.smallFontSize,
                            fontFamily: UserStyles.primaryFontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
