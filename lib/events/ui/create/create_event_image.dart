import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticketing/events/ui/create/bloc/crate_event_state.dart';
import 'package:ticketing/events/ui/create/bloc/create_event_cubit.dart';
import 'package:ticketing/events/ui/create/create_event_app_bar.dart';
import 'package:ticketing/events/ui/create/create_event_next_button.dart';

class CreateEventImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createEventAppBar(context),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload an image for your event',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _UploadArea(),
              ],
            ),
          ),
          createEventPositionedNextButton(
              context, (_) => context.read<CreateEventCubit>().publishEvent(),
              text: 'Publish'),
        ],
      ),
    );
  }
}

class _UploadArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            _getImage().then(
                (file) => context.read<CreateEventCubit>().onFilePicked(file));
          },
          child: state.image != null
              ? Image.file(state.image)
              : DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 2,
                  dashPattern: [4, 3, 4, 3],
                  child: Container(
                      color: Colors.grey.withOpacity(0.1),
                      padding: EdgeInsets.all(30),
                      child: Center(
                          child: Column(
                        children: [
                          Icon(Icons.cloud_download,
                              size: 48, color: Colors.grey),
                          Text('Upload Picture Here',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor))
                        ],
                      ))),
                ),
        );
      },
    );
  }

  Future<File> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    return File(pickedFile.path);
  }
}
