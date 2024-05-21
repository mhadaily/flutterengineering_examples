import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Enhanced function to show update
// dialog with critical update consideration
void showUpdateDialog(
  BuildContext context, {
  bool isCritical = false,
}) {
  showDialog(
    context: context,
    // Control dismissibility based on update criticality
    barrierDismissible: !isCritical,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Update Available'),
        content: Text(
          isCritical
              ? '''A critical update is available. 
                Update now to continue using the app.'''
              : '''A new version of the app is available. 
                Please update now for the 
                latest features and improvements.''',
        ),
        actions: <Widget>[
          if (!isCritical)
            TextButton(
              child: const Text('Later'),
              // Allow dismissal for non-critical updates
              onPressed: () => Navigator.of(context).pop(),
            ),
          TextButton(
            child: const Text('Update'),
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
              // Open the URL to update
              _launchURL();
            },
          ),
        ],
      );
    },
  );
}

// platform check and error handling
void _launchURL() async {
  final url = kIsWeb
      ? Uri.parse('https://yourwebsite.com/update')
      : Platform.isAndroid
          ? Uri.parse(
              'https://play.google.com/store/apps/details?id=your.app.id')
          : Platform.isIOS
              ? Uri.parse(
                  'https://apps.apple.com/app/idyourAppId')
              // Fallback URL for other platforms
              : Uri.parse(
                  'https://yourfallbackwebsite.com/update');

  if (!await launchUrl(url)) {
    // Log error or inform the user of
    //an issue if the URL can't be launched
    debugPrint('Could not launch $url');
    // Consider showing a toast or
    //another dialog here to inform the user
  }
}

void checkForUpdate(BuildContext context) {
  // Replace with actual update check logic
  const isUpdateAvailable = true;
  // Replace based on the update's criticality
  const isCritical = false;

  if (isUpdateAvailable) {
    showUpdateDialog(context, isCritical: isCritical);
  }
}
