String formatRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inSeconds < 60) {
    return '${diff.inSeconds}s önce';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes}dk önce';
  } else if (diff.inHours < 24) {
    return '${diff.inHours}sa önce';
  } else {
    return '${diff.inDays}g önce';
  }
}
