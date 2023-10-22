import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/pokemon_icon_image.dart';

class PokemonIconBorderedImage extends StatelessWidget {
  const PokemonIconBorderedImage({
    super.key,
    required this.basicProfile,
    this.width,
    this.height,
    this.fit,
    this.disableTooltip = false,
    this.toolTipMessage,
  });

  final PokemonBasicProfile basicProfile;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool disableTooltip;
  final String? toolTipMessage;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    Widget result = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerColor,
        ),
        color: basicProfile.pokemonType.color.withOpacity(.1),
      ),
      child: PokemonIconImage(
        basicProfile: basicProfile,
        width: width,
        disableTooltip: disableTooltip,
      ),
    );

    if (!disableTooltip) {
      result = Tooltip(
        message: toolTipMessage ?? basicProfile.nameI18nKey.xTr,
        child: result,
      );
    }

    return result;
  }
}
