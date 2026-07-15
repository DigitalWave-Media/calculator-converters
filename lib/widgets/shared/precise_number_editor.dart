import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable widget that provides a text field with a custom numeric keypad,
/// allowing for precise cursor placement and editing.
class PreciseNumberEditor extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const PreciseNumberEditor({
    super.key,
    this.hintText = '0',
    this.onChanged,
  });

  @override
  State<PreciseNumberEditor> createState() => _PreciseNumberEditorState();
}

class _PreciseNumberEditorState extends State<PreciseNumberEditor> {
  final TextEditingController _controller = TextEditingController();

  void _insertNumberText(String textToInsert) {
    final text = _controller.text;
    final selection = _controller.selection;

    // --- Validation Rules for Numbers ---
    if (textToInsert == '.' && text.contains('.')) return;
    if (textToInsert == '.' && text.isEmpty) textToInsert = '0.';
    if (textToInsert == '0' && text == '0') return;

    if (selection.baseOffset < 0) {
      _controller.text += textToInsert;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
      if (widget.onChanged != null) widget.onChanged!(_controller.text);
      return;
    }

    final start = selection.start;
    final end = selection.end;

    final newText = text.replaceRange(start, end, textToInsert);

    _controller.value = _controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: start + textToInsert.length,
      ),
    );
    
    if (widget.onChanged != null) widget.onChanged!(_controller.text);
  }

  void _deleteText() {
    final text = _controller.text;
    final selection = _controller.selection;

    if (selection.baseOffset < 0 || text.isEmpty) return;

    final start = selection.start;
    final end = selection.end;

    if (start != end) {
      final newText = text.replaceRange(start, end, '');
      _controller.value = _controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: start),
      );
      if (widget.onChanged != null) widget.onChanged!(_controller.text);
      return;
    }

    if (start == 0) return;

    final newText = text.replaceRange(start - 1, start, '');
    _controller.value = _controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: start - 1),
    );
    
    if (widget.onChanged != null) widget.onChanged!(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          autofocus: true,
          showCursor: true,
          keyboardType: TextInputType.none, // Prevent system keyboard from popping up
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildNumberBtn('7'), _buildNumberBtn('8'), _buildNumberBtn('9'),
            _buildNumberBtn('4'), _buildNumberBtn('5'), _buildNumberBtn('6'),
            _buildNumberBtn('1'), _buildNumberBtn('2'), _buildNumberBtn('3'),
            _buildNumberBtn('.'), _buildNumberBtn('0'),
            ElevatedButton(
              onPressed: _deleteText,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Icon(Icons.backspace, color: Colors.red),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildNumberBtn(String digit) {
    return ElevatedButton(
      onPressed: () => _insertNumberText(digit),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(digit, style: const TextStyle(fontSize: 28)),
    );
  }
}
