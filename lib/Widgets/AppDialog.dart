// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:todo_app/Widgets/AppText.dart';
import 'package:todo_app/Widgets/AppTextField.dart';

enum DialogType {
  alert,
  comfirm,
  input,
}

enum DialogLogo {
  none,
  check,
  warning,
  cross,
  questionmark,
  contact,
}

class AppDialog extends StatefulWidget {
  DialogType dialogType;
  String comfirmBtnText;
  bool confirmBtn;
  String cancelBtnText;
  bool confirmDeleteBtn;
  bool cancelBtn;
  String dialogTitle;
  String dialogDescription;
  DialogLogo dialogLogo;
  bool onPopScope;
  Function? onConfirmBtnPress;
  Function? onCancelBtnPress;
  String inputValue;
  String inputPlaceHolder;
  Function(String value)? onInputChange;

  AppDialog({
    super.key,
    required this.dialogType,
    this.comfirmBtnText = "Ok",
    this.confirmBtn = true,
    this.cancelBtnText = "Cancel",
    this.cancelBtn = true,
    this.dialogTitle = "",
    this.dialogDescription = "",
    this.dialogLogo = DialogLogo.none,
    this.onPopScope = true,
    this.confirmDeleteBtn = false,
    this.onConfirmBtnPress,
    this.onCancelBtnPress,
    this.inputValue = "",
    this.inputPlaceHolder = "",
    this.onInputChange,
  });

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  final TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();

    if (widget.inputValue != "") {
      inputController.text = widget.inputValue;
    } else {
      inputController.text = "";
    }
  }

  void onConfirmPress() {
    if (widget.onConfirmBtnPress != null) {
      widget.onConfirmBtnPress!();
    } else {
      Navigator.pop(context);
    }
  }

  void onCancelPress() {
    if (widget.onCancelBtnPress != null) {
      widget.onCancelBtnPress!();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.onPopScope,
      child: Center(
        child: GestureDetector(
          onTap: () => widget.onPopScope == true ? Navigator.pop(context) : {},
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  // currentFocus.unfocus();
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: ScaleTransition(
                scale: scaleAnimation,
                child: AlertDialog(
                  contentPadding: const EdgeInsets.all(0),
                  backgroundColor: Colors.transparent,
                  content: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.dialogLogo != DialogLogo.none
                            ? Container(
                                decoration: ShapeDecoration(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  color: widget.dialogLogo == DialogLogo.check
                                      ? Colors.lightGreen.shade600
                                      : widget.dialogLogo == DialogLogo.warning
                                          ? Colors.yellow.shade600
                                          : widget.dialogLogo ==
                                                  DialogLogo.cross
                                              ? Colors.red
                                              : widget.dialogLogo ==
                                                      DialogLogo.questionmark
                                                  ? Colors.yellow
                                                  : widget.dialogLogo ==
                                                          DialogLogo.contact
                                                      ? Colors.lightGreen
                                                      : Theme.of(context)
                                                          .primaryColor,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: buildDialogIcon(),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: widget.dialogType == DialogType.alert
                              ? buildAlertDialogBody()
                              : widget.dialogType == DialogType.comfirm
                                  ? buildConfirmDialogBody()
                                  : buildInputDialogBody(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDialogIcon() {
    return Center(
      child: Icon(
        widget.dialogLogo == DialogLogo.check
            ? Icons.check_circle_outline
            : widget.dialogLogo == DialogLogo.warning
                ? Icons.warning
                : widget.dialogLogo == DialogLogo.cross
                    ? Icons.cancel_outlined
                    : widget.dialogLogo == DialogLogo.questionmark
                        ? Icons.help_outline
                        : widget.dialogLogo == DialogLogo.contact
                            ? Icons.account_circle_outlined
                            : Icons.menu,
        color: Colors.white,
        size: MediaQuery.of(context).size.height * 0.1,
      ),
    );
  }

  Widget buildAlertDialogBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.dialogTitle != ""
            ? Column(
                children: [
                  AppText(
                    text: widget.dialogTitle,
                    size: 18,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : Container(),
        widget.dialogDescription != ""
            ? Column(
                children: [
                  AppText(
                    text: widget.dialogDescription,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : Container(),
        const SizedBox(height: 10),
        buildConfirmButton(
            widget.comfirmBtnText, () => onConfirmPress(), false),
      ],
    );
  }

  Widget buildConfirmDialogBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.dialogTitle != ""
            ? Column(
                children: [
                  AppText(
                    text: widget.dialogTitle,
                    size: 18,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : Container(),
        widget.dialogDescription != ""
            ? Column(
                children: [
                  AppText(
                    text: widget.dialogDescription,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : Container(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildCancelButton(widget.cancelBtnText, () => onCancelPress()),
            buildConfirmButton(widget.comfirmBtnText, () => onConfirmPress(),
                widget.confirmDeleteBtn),
          ],
        ),
      ],
    );
  }

  Widget buildInputDialogBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.dialogTitle != ""
            ? Column(
                children: [
                  AppText(
                    text: widget.dialogTitle,
                    size: 18,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                ],
              )
            : Container(),
        widget.dialogDescription != ""
            ? Column(
                children: [
                  AppText(
                    text: widget.dialogDescription,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                ],
              )
            : Container(),
        const SizedBox(height: 10),
        AppTextField(
          text: inputController,
          onChanged: (value) {
            if (widget.dialogType == DialogType.input &&
                widget.onInputChange != null) {
              widget.onInputChange!(value);
            }
          },
          hintText: widget.inputPlaceHolder,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.cancelBtn != false
                ? buildCancelButton(widget.cancelBtnText, () => onCancelPress())
                : Container(),
            buildConfirmButton(widget.comfirmBtnText, () => onConfirmPress(),
                widget.confirmDeleteBtn),
          ],
        ),
      ],
    );
  }

  Widget buildConfirmButton(String? text, Function? onPress, bool? deleteMode) {
    return Material(
      color: deleteMode == false ? Theme.of(context).primaryColor : Colors.red,
      borderRadius: BorderRadius.circular(50),
      shadowColor: Colors.grey.withOpacity(0.5),
      elevation: 2.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () => onPress!(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.25),
          alignment: Alignment.center,
          child: AppText(
            text: text.toString(),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildCancelButton(String? text, Function? onPress) {
    return Material(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(50),
      shadowColor: Colors.grey.withOpacity(0.5),
      elevation: 2.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () => onPress!(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.25),
          alignment: Alignment.center,
          child: AppText(text: text.toString()),
        ),
      ),
    );
  }
}
