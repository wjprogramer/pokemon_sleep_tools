import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class LicenseSourceCard extends StatelessWidget {
  const LicenseSourceCard({
    super.key,
    required this.text,
  });

  final String text;

  static Widget t1() => const LicenseSourceCard(text: _t1,);
  // static Widget t2() => const LicenseSourceCard(text: _t2,);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final style = textTheme.bodySmall ?? TextStyle();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          style: style.copyWith(
            color: greyColor3,
          ),
        ),
      ),
    );
  }

  static const _t1 = '內容修改自非營利社群「食神攻略組」多人共同討論製作，使用創用CC授權，轉載引用請告知 (連結在頁尾、本 App 使用已告知)\n\n'
      '原資料編修：SteveH、Nicole、熬夜撿樹果的寶可夢、謎擬Q、史蒂芬、夏青、繆小狼、養樂多男孩、睡著了、Veil、璃璃、Pail\n\n'
      '本頁面沿用該作之創用CC條款';

  // static const _t2 = '本分析採用「寶可夢Sleep潛力計算機v4.0」，作者為繆小狼，原文「歡迎轉傳至各論壇使用，請附上來源，本文及計算機禁止內容農場網站及Youtube等...任何營利目的使用。」本頁面沿用該作之條款';
}
