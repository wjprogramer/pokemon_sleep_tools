class AssetsPath {
  AssetsPath._();

  static const _prefix = 'assets/debug/images';

  static String pokemonPortrait(int boxNo) {
    return '$_prefix/pokemon/portrait/$boxNo.png';
  }

}