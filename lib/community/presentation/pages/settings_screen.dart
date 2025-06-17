import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool commentsEnabled = true;
  bool moderationRequired = false;
  String welcomeMessage = '¡Bienvenido a la comunidad!';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          SwitchListTile(
            title: const Text('Habilitar comentarios'),
            value: commentsEnabled,
            onChanged: (v) => setState(() => commentsEnabled = v),
            activeColor: Colors.green,
          ),
          SwitchListTile(
            title: const Text('Requiere moderación de posts'),
            value: moderationRequired,
            onChanged: (v) => setState(() => moderationRequired = v),
            activeColor: Colors.green,
          ),
          const SizedBox(height: 16),
          const Text('Mensaje de bienvenida', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: welcomeMessage,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Mensaje para nuevos usuarios',
            ),
            onChanged: (v) => setState(() => welcomeMessage = v),
          ),
        ],
      ),
    );
  }
}

