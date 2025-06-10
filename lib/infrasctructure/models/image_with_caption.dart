import 'package:image_picker/image_picker.dart';

class ImageWithCaption {
  final XFile file;
  String caption;

  ImageWithCaption({
    required this.file,
    this.caption = '',
  });
}
