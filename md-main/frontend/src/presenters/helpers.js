export function truncate(string, length, suffix = '...') {
  if (string && string.length > length) {
    return string.substring(0, length) + suffix;
  } else {
    return string;
  }
}
