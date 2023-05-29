import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_example/src/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';

bool _newIsOnline = false;

void showChangeStatusDialog(BuildContext context, bool currentIsOnline) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Change status'),
        content: _ChangeIsOnlineContent(currentIsOnline),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().changeIsOnline(_newIsOnline);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

class _ChangeIsOnlineContent extends StatefulWidget {
  final bool currentIsOnline;
  const _ChangeIsOnlineContent(this.currentIsOnline, {super.key});

  @override
  State<_ChangeIsOnlineContent> createState() => _ChangeIsOnlineContentState();
}

class _ChangeIsOnlineContentState extends State<_ChangeIsOnlineContent> {
  @override
  void initState() {
    _newIsOnline = widget.currentIsOnline;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthCompleted) {
          return Row(
            children: [
              Text('Status: '),
              CupertinoSwitch(
                value: _newIsOnline,
                onChanged: (bool value) {
                  setState(() {
                    _newIsOnline = value;
                  });
                },
              ),
            ],
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
