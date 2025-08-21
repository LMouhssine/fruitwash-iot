import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_providers.dart';
import 'error_widget.dart';

class LogoutButton extends ConsumerWidget {
  final String? tooltip;
  final IconData? icon;
  final String? label;
  final bool showConfirmDialog;
  final VoidCallback? onLogoutSuccess;

  const LogoutButton({
    super.key,
    this.tooltip,
    this.icon,
    this.label,
    this.showConfirmDialog = true,
    this.onLogoutSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    if (label != null) {
      return TextButton.icon(
        onPressed: authState.isLoading ? null : () => _handleLogout(context, ref),
        icon: authState.isLoading 
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon ?? Icons.logout),
        label: Text(label!),
      );
    }

    return IconButton(
      icon: authState.isLoading 
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(icon ?? Icons.logout),
      tooltip: tooltip ?? 'Se déconnecter',
      onPressed: authState.isLoading ? null : () => _handleLogout(context, ref),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    bool shouldLogout = true;

    if (showConfirmDialog) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Se déconnecter'),
            ),
          ],
        ),
      );
      shouldLogout = confirmed == true;
    }

    if (shouldLogout) {
      try {
        await ref.read(authNotifierProvider.notifier).signOut();
        if (context.mounted) {
          SuccessSnackBar.show(context, 'Déconnexion réussie');
          onLogoutSuccess?.call();
        }
      } catch (e) {
        if (context.mounted) {
          ErrorSnackBar.show(context, 'Erreur lors de la déconnexion: $e');
        }
      }
    }
  }
}

class LogoutTile extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final IconData? leading;
  final bool showConfirmDialog;
  final VoidCallback? onLogoutSuccess;

  const LogoutTile({
    super.key,
    this.title = 'Se déconnecter',
    this.subtitle,
    this.leading,
    this.showConfirmDialog = true,
    this.onLogoutSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return ListTile(
      leading: authState.isLoading 
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(leading ?? Icons.logout, color: Colors.red),
      title: Text(
        title,
        style: const TextStyle(color: Colors.red),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      enabled: !authState.isLoading,
      onTap: () => _handleLogout(context, ref),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    bool shouldLogout = true;

    if (showConfirmDialog) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Se déconnecter'),
            ),
          ],
        ),
      );
      shouldLogout = confirmed == true;
    }

    if (shouldLogout) {
      try {
        await ref.read(authNotifierProvider.notifier).signOut();
        if (context.mounted) {
          SuccessSnackBar.show(context, 'Déconnexion réussie');
          onLogoutSuccess?.call();
        }
      } catch (e) {
        if (context.mounted) {
          ErrorSnackBar.show(context, 'Erreur lors de la déconnexion: $e');
        }
      }
    }
  }
}

class LogoutDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelLabel;
  final String confirmLabel;

  const LogoutDialog({
    super.key,
    this.title = 'Déconnexion',
    this.content = 'Êtes-vous sûr de vouloir vous déconnecter ?',
    this.cancelLabel = 'Annuler',
    this.confirmLabel = 'Se déconnecter',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }

  static Future<bool?> show(BuildContext context, {
    String? title,
    String? content,
    String? cancelLabel,
    String? confirmLabel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => LogoutDialog(
        title: title ?? 'Déconnexion',
        content: content ?? 'Êtes-vous sûr de vouloir vous déconnecter ?',
        cancelLabel: cancelLabel ?? 'Annuler',
        confirmLabel: confirmLabel ?? 'Se déconnecter',
      ),
    );
  }
}