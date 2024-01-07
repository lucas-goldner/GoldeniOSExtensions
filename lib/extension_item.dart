import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:golden_ios_extensions/extensions.dart';

class ExtensionItem extends StatelessWidget {
  const ExtensionItem({required this.extension, this.data, super.key});

  final Extensions extension;
  final Object? data;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => Navigator.of(context).pushNamed(
          '/${extension.name.toLowerCase()}',
          arguments: (extension, data),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: CupertinoColors.systemGrey.withOpacity(0.5)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  extension.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => {},
                  icon: const Icon(CupertinoIcons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      );
}
