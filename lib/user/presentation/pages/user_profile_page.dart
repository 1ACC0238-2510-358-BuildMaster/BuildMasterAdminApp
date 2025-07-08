import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../styles/user_styles.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // For demo, just show email and token if available
    return Scaffold(
      backgroundColor: UserStyles.cardBackground,
      appBar: AppBar(
        title: const Text('Perfil de Usuario', style: TextStyle(color: UserStyles.darkText)),
        backgroundColor: UserStyles.primaryYellow,
        iconTheme: const IconThemeData(color: UserStyles.darkText),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(UserStyles.paddingLarge),
          margin: const EdgeInsets.all(UserStyles.marginLarge),
          decoration: BoxDecoration(
            color: UserStyles.white,
            borderRadius: BorderRadius.circular(UserStyles.borderRadiusMedium),
            boxShadow: UserStyles.cardShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, size: 64, color: UserStyles.primaryYellow),
              const SizedBox(height: UserStyles.marginMedium),
              Text(
                userProvider.token != null ? 'Sesión activa' : 'No has iniciado sesión',
                style: const TextStyle(
                  color: UserStyles.darkText,
                  fontSize: UserStyles.headerFontSizeMedium,
                  fontWeight: UserStyles.fontWeightSemiBold,
                  fontFamily: UserStyles.primaryFontFamily,
                ),
              ),
              const SizedBox(height: UserStyles.marginMedium),
              if (userProvider.token != null)
                Column(
                  children: [
                    Text(
                      'Token:',
                      style: const TextStyle(
                        color: UserStyles.lightText,
                        fontSize: UserStyles.smallFontSize,
                        fontFamily: UserStyles.primaryFontFamily,
                      ),
                    ),
                    Text(
                      userProvider.token!,
                      style: const TextStyle(
                        color: UserStyles.darkText,
                        fontSize: UserStyles.smallFontSize,
                        fontFamily: UserStyles.primaryFontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: UserStyles.marginMedium),
                    if (userProvider.username != null && userProvider.username!.isNotEmpty)
                      Text(
                        'Usuario: ${userProvider.username}',
                        style: const TextStyle(
                          color: UserStyles.darkText,
                          fontSize: UserStyles.bodyFontSize,
                          fontFamily: UserStyles.primaryFontFamily,
                        ),
                      ),
                    if (userProvider.email != null && userProvider.email!.isNotEmpty)
                      Text(
                        'Email: ${userProvider.email}',
                        style: const TextStyle(
                          color: UserStyles.darkText,
                          fontSize: UserStyles.bodyFontSize,
                          fontFamily: UserStyles.primaryFontFamily,
                        ),
                      ),
                    const SizedBox(height: UserStyles.marginMedium),
                    ElevatedButton(
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
                      onPressed: () {
                        userProvider.logout();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: const Text('Cerrar sesión'),
                    ),
                  ],
                )
              else
                ElevatedButton(
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
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: const Text('Iniciar sesión'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
