import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:workout_dashboard/parsing_ops/workout_data.dart';

class LogEditor extends StatefulWidget {
  LogEditor({super.key});

  final TextEditingController logController = TextEditingController();

  @override
  State<LogEditor> createState() => _LogEditorState();

  ScrollController scrollController = ScrollController();
  QuillController? quillController;
}

class _LogEditorState extends State<LogEditor> {
  @override
  void initState() {
    super.initState();

    // Making the editor scroll to the end right after the build function is called
    // WidgetsBinding.instance.addPostFrameCallback((_) => widget.scrollController
    //     .jumpTo(widget.scrollController.position.maxScrollExtent));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(builder: (context, workoutData, widget1) {
      // For some reason there needs to be a linebreak at the end of text for it to
      // be put in the editor.
      if (workoutData.rawWorkoutLogString.split("").last != "\n") {
        workoutData.rawWorkoutLogString =
            "${workoutData.rawWorkoutLogString}\n";
      }

      // Loading the text into the quill controller
      widget.quillController = QuillController(
        document: Document.fromJson([
          {"insert": workoutData.rawWorkoutLogString},
        ]),
        selection: TextSelection.collapsed(
          offset: workoutData.rawWorkoutLogString.length - 1,
        ),
      );

      // Adding listener to the quill editor to note file changes
      widget.quillController?.document.changes.listen((event) {
        workoutData.registerFileChange();

        workoutData.setWorkoutLogFileRawString(
          widget.quillController?.document.toDelta().toJson().first["insert"],
        );
        print("File Changed: ${workoutData.fileChanged}");
      });

      Widget widgetToReturn = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                workoutData.writeToFile(
                  data: widget.quillController?.document
                      .toDelta()
                      .toJson()
                      .first["insert"],
                );
              },
              child: const AutoSizeText(
                "Log Editor",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 35,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.28,
              // ),
              child: QuillEditor.basic(
                controller: widget.quillController,
                scrollController: widget.scrollController,
              ),
            ),
          ],
        ),
      );

      return widgetToReturn;
    });
  }
}
