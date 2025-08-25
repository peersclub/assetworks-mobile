import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/ios18_theme.dart';
import '../../../data/models/widget_model.dart';

class IOSWidgetCard extends StatelessWidget {
  final WidgetModel widget;
  final VoidCallback? onTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onBookmarkTap;
  final bool showAuthor;
  final bool compact;
  
  const IOSWidgetCard({
    super.key,
    required this.widget,
    this.onTap,
    this.onShareTap,
    this.onBookmarkTap,
    this.showAuthor = true,
    this.compact = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        iOS18Theme.selectionClick();
        onTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: iOS18Theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: iOS18Theme.separator.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with asset class badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iOS18Theme.tertiaryFill.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getAssetClassColor(widget.assetClass),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.assetClass ?? 'Report',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (widget.createdAt != null)
                    Text(
                      _formatDate(widget.createdAt!),
                      style: TextStyle(
                        fontSize: 11,
                        color: iOS18Theme.tertiaryLabel,
                      ),
                    ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title ?? 'Untitled Report',
                      style: TextStyle(
                        fontSize: compact ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: iOS18Theme.primaryLabel,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.description != null && !compact) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.description!,
                        style: TextStyle(
                          fontSize: 13,
                          color: iOS18Theme.secondaryLabel,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const Spacer(),
                    
                    // Author info
                    if (showAuthor && widget.authorName != null) ...[
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: iOS18Theme.quaternaryFill,
                              image: widget.authorProfileImage != null
                                  ? DecorationImage(
                                      image: NetworkImage(widget.authorProfileImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: widget.authorProfileImage == null
                                ? Center(
                                    child: Text(
                                      widget.authorName![0].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: iOS18Theme.primaryLabel,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.authorName!,
                              style: TextStyle(
                                fontSize: 12,
                                color: iOS18Theme.secondaryLabel,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    
                    // Actions row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Share button
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 32,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: iOS18Theme.quaternaryFill,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              CupertinoIcons.share,
                              size: 16,
                              color: iOS18Theme.secondaryLabel,
                            ),
                          ),
                          onPressed: () {
                            iOS18Theme.lightImpact();
                            onShareTap?.call();
                          },
                        ),
                        const SizedBox(width: 8),
                        // Bookmark button
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 32,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: widget.isSaved == true
                                  ? iOS18Theme.accentBlue.withOpacity(0.15)
                                  : iOS18Theme.quaternaryFill,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              widget.isSaved == true
                                  ? CupertinoIcons.bookmark_fill
                                  : CupertinoIcons.bookmark,
                              size: 16,
                              color: widget.isSaved == true
                                  ? iOS18Theme.accentBlue
                                  : iOS18Theme.secondaryLabel,
                            ),
                          ),
                          onPressed: () {
                            iOS18Theme.lightImpact();
                            onBookmarkTap?.call();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getAssetClassColor(String? assetClass) {
    switch (assetClass?.toLowerCase()) {
      case 'stocks':
        return iOS18Theme.accentBlue;
      case 'crypto':
        return iOS18Theme.accentOrange;
      case 'forex':
        return iOS18Theme.accentGreen;
      case 'commodities':
        return iOS18Theme.accentYellow;
      case 'indices':
        return iOS18Theme.accentPurple;
      case 'bonds':
        return iOS18Theme.accentTeal;
      case 'real estate':
        return iOS18Theme.accentPink;
      default:
        return iOS18Theme.accentIndigo;
    }
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}