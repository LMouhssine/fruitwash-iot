import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestFirebaseScreen extends StatefulWidget {
  const TestFirebaseScreen({super.key});

  @override
  State<TestFirebaseScreen> createState() => _TestFirebaseScreenState();
}

class _TestFirebaseScreenState extends State<TestFirebaseScreen> {
  bool _isWriting = false;
  String? _lastKey;
  String? _error;

  Future<void> _createTestEntry() async {
    setState(() {
      _isWriting = true;
      _error = null;
      _lastKey = null;
    });
    try {
      final bool isMobileOrWeb = kIsWeb ||
          defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS;

      if (isMobileOrWeb) {
        final DatabaseReference testsRef = FirebaseDatabase.instance.ref('tests');
        final DatabaseReference newChild = testsRef.push();
        await newChild.set({
          'createdAt': DateTime.now().toIso8601String(),
          'message': 'Écriture de test depuis FruitWash',
          'platform': kIsWeb ? 'web' : 'mobile',
        });
        setState(() {
          _lastKey = newChild.key;
        });
      } else {
        // Fallback REST pour desktop (Windows/macOS/Linux)
        const String databaseUrl =
            'https://esp32-moha-default-rtdb.europe-west1.firebasedatabase.app';
        final Uri url = Uri.parse('$databaseUrl/tests.json');
        final Map<String, dynamic> payload = {
          'createdAt': DateTime.now().toIso8601String(),
          'message': 'Écriture de test depuis FruitWash (REST desktop)',
          'platform': 'desktop',
        };
        final http.Response resp = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );
        if (resp.statusCode >= 200 && resp.statusCode < 300) {
          final Map<String, dynamic> body = jsonDecode(resp.body);
          setState(() {
            _lastKey = body['name'] as String?;
          });
        } else {
          throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isWriting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Appuie sur le bouton pour créer une entrée dans Realtime Database sous \'tests/\'.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isWriting ? null : _createTestEntry,
              child: _isWriting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Créer une entrée de test'),
            ),
            const SizedBox(height: 24),
            if (_lastKey != null) ...[
              const Text('Dernière écriture réussie :', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('tests/$_lastKey'),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              const Text('Erreur :', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              Text(_error!),
            ],
          ],
        ),
      ),
    );
  }
}


