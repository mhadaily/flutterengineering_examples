class ValidatorUseCases {
  static String text(String text) {
    return text.trim();
  }

  static String email(String email) {
    return email.trim().toLowerCase();
  }

  static String password(String password) {
    return password.trim();
  }

  static String slugify(String input) {
    // Lowercase and replace non-alphanumeric characters with hyphens
    final nonAlphanumeric = RegExp(r'[^a-z0-9\s-]');
    final normalized = input.toLowerCase().replaceAll(nonAlphanumeric, '-');

    // Trim whitespace and hyphens, then replace multiple consecutive hyphens
    final trimmed = normalized.trim().replaceAll(RegExp(r'-{2,}'), '-');

    // Optionally convert remaining spaces to hyphens (depending on your needs)
    final hyphenatedSpaces = trimmed.replaceAll(' ', '-');

    return hyphenatedSpaces;
  }
}
