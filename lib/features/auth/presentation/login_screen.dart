import 'package:flutter/material.dart';
import '../../../core/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FlutterLogo(size: 72),
                  const SizedBox(height: 12),
                  const Text(
                    'FruitWash',
                    textAlign: TextAlign.center,
                    style: null,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Connectez-vous pour accéder au tableau de bord',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Identifiant',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Se connecter',
                    icon: Icons.login,
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.of(context).pushReplacementNamed('/dashboard');
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/register'),
                    child: const Text('Créer un compte'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


