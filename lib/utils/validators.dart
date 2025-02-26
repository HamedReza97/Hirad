extension PersianNumberConversion on String {
  String toPersianNumbers() {
    const persianDigits = ['۰','۱','۲','۳','۴','۵','۶','۷','۸','۹'];
    return split('').map((char) {
      if (char.contains(RegExp(r'[0-9]'))) {
        return persianDigits[int.parse(char)];
      } else {
        return char;
      }
    }).join('');
  }
}
