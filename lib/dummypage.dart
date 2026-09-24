import 'package:flutter/material.dart';

import 'data/services/ai/ai_service.dart';
import 'utils/popups/snackbar_helpers.dart';

class Dummypage extends StatelessWidget {
  const Dummypage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("dummy")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                try {
                  final reply = await AIService.instance
                      .ask('Say hello to EduTrack in one short sentence.');
                  SSnackBarHelpers.successSnackBar(
                    title: 'AI replied',
                    message: reply,
                    duration: 6,
                  );
                } catch (e) {
                  SSnackBarHelpers.errorSnackBar(
                    title: 'AI failed',
                    message: e.toString(),
                  );
                }
              },
              child: const Text('Test AI'),
            ),
          ],
        ),
      ),
    );
  }
}