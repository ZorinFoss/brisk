import 'package:brisk/util/download_addition_ui_util.dart';
import 'package:brisk/widget/base/rounded_outlined_button.dart';
import 'package:brisk/widget/loader/file_info_loader.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AddUrlDialog extends StatefulWidget {
  final bool updateDialog;
  final int? downloadId;

  const AddUrlDialog({super.key, this.updateDialog = false, this.downloadId});

  @override
  State<AddUrlDialog> createState() => _AddUrlDialogState();
}

class _AddUrlDialogState extends State<AddUrlDialog> {
  TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (progress) => FileInfoLoader(
        onCancelPressed: () => DownloadAdditionUiUtil.cancelRequest(context),
      ),
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
        title: Text(
            widget.updateDialog ? "Update Download URL" : "Add a Download URL",
            style: const TextStyle(color: Colors.white)),
        content: SizedBox(
          width: 400,
          height: 100,
          child: Row(
            children: [
              SizedBox(
                  width: 340,
                  child: TextField(
                    maxLines: 1,
                    cursorColor: Colors.indigo,
                    controller: txtController,
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    style: const TextStyle(color: Colors.white),
                  )),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.paste_rounded, color: Colors.white),
                onPressed: () async {
                  String url = await FlutterClipboard.paste();
                  setState(() => txtController.text = url);
                },
              )
            ],
          ),
        ),
        actions: <Widget>[
          RoundedOutlinedButton(
            text: "Cancel",
            borderColor: Colors.red,
            textColor: Colors.red,
            onPressed: () => _onCancelPressed(context),
          ),
          RoundedOutlinedButton(
            text: widget.updateDialog ? "Update" : "Add",
            borderColor: Colors.green,
            textColor: Colors.green,
            onPressed: () => _onAddPressed(context),
          ),
        ],
      ),
    );
  }

  void _onCancelPressed(BuildContext context) {
    txtController.text = '';
    Navigator.of(context).pop();
  }

  void _onAddPressed(BuildContext context) {
    final url = txtController.text;
    DownloadAdditionUiUtil.handleDownloadAddition(context, url,
        updateDialog: widget.updateDialog,
        downloadId: widget.downloadId,
        additionalPop: true);
  }
}
