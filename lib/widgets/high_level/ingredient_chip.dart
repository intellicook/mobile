import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';

class IngredientChip extends StatefulWidget {
  const IngredientChip({
    super.key,
    required this.ingredient,
    this.onEdit,
    this.onRemove,
  });

  final String ingredient;
  final ValueChanged<String>? onEdit;
  final VoidCallback? onRemove;

  @override
  State<IngredientChip> createState() => _IngredientChipState();
}

class _IngredientChipState extends State<IngredientChip> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<bool> _isEditing = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controller.text = widget.ingredient;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    void onConfirmClicked() {
      widget.onEdit?.call(_controller.text);
      _focusNode.unfocus();
      setState(() {
        _isEditing.value = false;
      });
    }

    void onEditClicked() {
      _focusNode.requestFocus();
      setState(() {
        _isEditing.value = true;
      });
    }

    void onRemoveClicked() {
      widget.onRemove?.call();
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _isEditing,
      builder: (context, isEditing, _) {
        return InputField(
          controller: _controller,
          focusNode: _focusNode,
          style: textTheme.bodyMedium,
          readOnly: !isEditing,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          constraints: const BoxConstraints.tightFor(
            height: SpacingConsts.l,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: SpacingConsts.m,
          ),
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Clickable(
                onClicked: isEditing ? onConfirmClicked : onEditClicked,
                child: Icon(
                  isEditing ? Icons.check_rounded : Icons.edit_rounded,
                  size: SpacingConsts.m,
                ),
              ),
              const SizedBox(width: SpacingConsts.s),
              Clickable(
                onClicked: onRemoveClicked,
                child: const Icon(
                  Icons.delete_rounded,
                  size: SpacingConsts.m,
                ),
              ),
            ],
          ),
          onSubmitted: (value) {
            if (isEditing) {
              onConfirmClicked();
            }
          },
        );
      },
    );
  }
}
