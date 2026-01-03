/// Static mapping of skill categories to YouTube playlist URLs.
/// Keys include both category ids and common display names to make lookups flexible.
class SkillPlaylists {
  static const Map<String, String> _map = {
    // Category id keys
    'honeybee': 'https://www.youtube.com/playlist?list=PLp_t_S9L2Zz8N7F196EisXvEPrOQ_1r9T',
    'artisan': 'https://www.youtube.com/playlist?list=PL_Xv5C0v_v7Qx6XlY7QpG-N_9GqX_X6Xl',
    'bamboo': 'https://www.youtube.com/playlist?list=PLG218Xv-7_IeKId76T-p0N_r_0Z_U6ZlS',
    'jute': 'https://www.youtube.com/playlist?list=PLD_6W0v_X6XlY7QpG-N_9GqX_X6XlV_9G',
    'macrame': 'https://www.youtube.com/playlist?list=PLXoY8yW_9GqX_X6XlY7QpG-N_9GqX_X6Xl',

    // Friendly/display name keys (in case we look up by title)
    'Honeybee Farming': 'https://www.youtube.com/playlist?list=PLp_t_S9L2Zz8N7F196EisXvEPrOQ_1r9T',
    'Artisan Training': 'https://www.youtube.com/playlist?list=PL_Xv5C0v_v7Qx6XlY7QpG-N_9GqX_X6Xl',
    'Bamboo Training': 'https://www.youtube.com/playlist?list=PLG218Xv-7_IeKId76T-p0N_r_0Z_U6ZlS',
    'Jutework': 'https://www.youtube.com/playlist?list=PLD_6W0v_X6XlY7QpG-N_9GqX_X6XlV_9G',
    'Macrame Work': 'https://www.youtube.com/playlist?list=PLXoY8yW_9GqX_X6XlY7QpG-N_9GqX_X6Xl',
  };

  static String? getPlaylist(String key) {
    if (key.isEmpty) return null;
    final lk = key.toLowerCase();
    // exact id or name match
    if (_map.containsKey(key)) return _map[key];
    // try id key
    if (_map.containsKey(lk)) return _map[lk];
    // fallback: contains matching
    return _map.entries.firstWhere(
      (e) => lk.contains(e.key.toLowerCase()),
      orElse: () => const MapEntry('', ''),
    ).value.isEmpty
        ? null
        : _map.entries.firstWhere((e) => lk.contains(e.key.toLowerCase())).value;
  }
}
