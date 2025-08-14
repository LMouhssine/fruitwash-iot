import 'package:flutter/material.dart';
import '../../../core/widgets/primary_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController();
    final email = TextEditingController();
    final pass = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: name,
                    decoration: const InputDecoration(labelText: 'Nom complet', prefixIcon: Icon(Icons.person_outline)),
                    validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: email,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    validator: (v) => (v == null || !v.contains('@')) ? 'Email invalide' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: pass,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Mot de passe', prefixIcon: Icon(Icons.lock_outline)),
                    validator: (v) => (v == null || v.length < 6) ? '6+ caractères' : null,
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Créer le compte',
                    icon: Icons.person_add_alt,
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.of(context).pushReplacementNamed('/dashboard');
                      }
                    },
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


