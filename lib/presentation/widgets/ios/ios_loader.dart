import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/ios18_theme.dart';

class IOSLoader extends StatelessWidget {
  final String? message;
  final bool showProgress;
  final double? progress;
  
  const IOSLoader({
    super.key,
    this.message,
    this.showProgress = false,
    this.progress,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showProgress && progress != null) ...[
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: iOS18Theme.quaternaryFill,
                      valueColor: AlwaysStoppedAnimation<Color>(iOS18Theme.accentBlue),
                    ),
                  ),
                  Text(
                    '${(progress! * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: iOS18Theme.primaryLabel,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const CupertinoActivityIndicator(
              radius: 16,
            ),
          ],
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontSize: 15,
                color: iOS18Theme.secondaryLabel,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}