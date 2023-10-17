import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchListTile extends StatelessWidget {
  const SearchListTile({
    super.key,
    required this.titleText,
    required this.url,
    this.subTitleText,
  });

  final String titleText;
  final String url;
  final String? subTitleText;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        launchUrl(Uri.parse(url));
      },
      title: Text(titleText),
      subtitle: subTitleText == null ? null
          : Text(subTitleText ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,),
      trailing: const Icon(
        Icons.open_in_new,
      ),
    );
  }
}
