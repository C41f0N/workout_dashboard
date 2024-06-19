import 'package:flutter/material.dart';

class FileAvailabilityWrapper extends StatefulWidget {
  const FileAvailabilityWrapper(
      {super.key, required this.child, required this.fileAvailable});

  final Widget child;
  final bool fileAvailable;

  @override
  State<FileAvailabilityWrapper> createState() =>
      _FileAvailabilityWrapperState();
}

class _FileAvailabilityWrapperState extends State<FileAvailabilityWrapper> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        !widget.fileAvailable
            ? Container(
                color: Colors.black.withOpacity(0.85),
              )
            : const SizedBox(),
        !widget.fileAvailable
            ? Container(
                decoration: BoxDecoration(
                  // color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  "No data to crunch.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
