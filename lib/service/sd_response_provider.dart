import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/sd/txt2img_request.dart';
import '../models/sd/txt2img_response.dart';
import 'sd_service_provider.dart';

part 'sd_response_provider.g.dart';

@Riverpod(keepAlive: true)
class Txt2ImgResponseController extends _$Txt2ImgResponseController {
  @override
  Txt2ImgResponse build() => const Txt2ImgResponse();

  Future<void> inference(Txt2ImgRequest request) async {
    state = await ref.read(sdServiceProvider).txt2Img(request);
  }
}
