import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_example/src/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';

String _newName = '';

void showChangeNameDialog(BuildContext context, String currentName) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Name'),
          content: _ChangeNameContent(currentName),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await context.read<AuthCubit>().changeName(_newName);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      });
}

class _ChangeNameContent extends StatefulWidget {
  final String currentName;
  const _ChangeNameContent(this.currentName, {super.key});

  @override
  State<_ChangeNameContent> createState() => _ChangeNameContentState();
}

class _ChangeNameContentState extends State<_ChangeNameContent> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    _newName = widget.currentName;
    _textEditingController.text = _newName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthCompleted) {
          return TextField(
            controller: _textEditingController,
            onChanged: (value) {
              _newName = value;
            },
            decoration: InputDecoration(hintText: 'Enter new name'),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: CustomColors.primary,
          ),
        );
      },
    );
  }
}
