import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    errorMethodCount: 5,
    lineLength: 80,
    printTime: true,
  ),
);
