import 'package:meta/meta.dart';


class Setting {
  const Setting({
    @required this.title,
    @required this.value,
  });

  final String title;
  final dynamic value;
}
