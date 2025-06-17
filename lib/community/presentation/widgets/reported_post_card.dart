import 'package:flutter/material.dart';

class ReportedPostCard extends StatelessWidget {
  final String user;
  final String reason;
  final String content;
  final VoidCallback onApprove;
  final VoidCallback onRemove;

  const ReportedPostCard({
    super.key,
    required this.user,
    required this.reason,
    required this.content,
    required this.onApprove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.green),
                const SizedBox(width: 8),
                Text(user, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Chip(label: Text(reason)),
              ],
            ),
            const SizedBox(height: 8),
            Text(content),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Aprobar'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: onApprove,
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                  onPressed: onRemove,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

