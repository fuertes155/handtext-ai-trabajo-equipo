import 'package:flutter/material.dart';

import '../strings.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final last = _page == AppStrings.photoTips.length - 1;
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.tips)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                liveRegion: true,
                child: Text('${_page + 1} de ${AppStrings.photoTips.length}'),
              ),
              const SizedBox(height: 16),
              Text(AppStrings.photoTips[_page]),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  if (last) {
                    Navigator.pop(context, true);
                  } else {
                    setState(() => _page++);
                  }
                },
                child: Text(last ? AppStrings.start : AppStrings.next),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(AppStrings.skip),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
