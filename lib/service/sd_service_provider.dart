import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/sd/controlnet_detect_request.dart';
import '../models/sd/controlnet_detect_response.dart';
import '../models/sd/controlnet_model_response.dart';
import '../models/sd/controlnet_module_response.dart';
import '../models/sd/sd_model.dart';
import '../models/sd/sd_sampler.dart';
import '../models/sd/txt2img_request.dart';
import '../models/sd/txt2img_response.dart';
import '../utils/app_logger.dart';
import 'preference_provider.dart';

part 'sd_service_provider.g.dart';

@Riverpod(keepAlive: true)
SdService sdService(SdServiceRef ref) {
  final host =
      ref.watch(appPreferenceControllerProvider.select((p) => p.sdHost));
  return SdService(host: host);
}

@riverpod
FutureOr<List<SdModel>> models(ModelsRef ref) {
  return ref.watch(sdServiceProvider).getModels();
}

@riverpod
FutureOr<List<String>> controlnetModels(ControlnetModelsRef ref) {
  return ref.watch(sdServiceProvider).getControlnetModels();
}

@Riverpod(keepAlive: true)
FutureOr<int> controlnetUnitCount(ControlnetUnitCountRef ref) {
  return ref.watch(sdServiceProvider).getControlnetUnitCount();
}

@Riverpod(keepAlive: true)
FutureOr<ControlnetModule> controlnetModule(ControlnetModuleRef ref) {
  return ref.watch(sdServiceProvider).getControlnetModule();
}

@riverpod
FutureOr<List<SdSampler>> samplers(SamplersRef ref) {
  return ref.watch(sdServiceProvider).getSamplers();
}

class SdService {
  SdService({required this.host});

  final String host;

  final _headers = {'Content-Type': 'application/json'};

  Future<List<SdModel>> getModels() async {
    final uri = Uri.parse('$host/sdapi/v1/sd-models');
    logger.i('getModels: $uri');

    final resp = await http.get(uri);
    logger.i('getModels: ${resp.statusCode}');

    if (resp.statusCode == 200) {
      final list = jsonDecode(resp.body) as List<dynamic>;

      final models =
          list.map((e) => SdModel.fromJson(e as Map<String, dynamic>)).toList();

      return models;
    } else {
      throw Exception('Failed to load models');
    }
  }

  Future<Txt2ImgResponse> txt2Img(Txt2ImgRequest request) async {
    final uri = Uri.parse('$host/sdapi/v1/txt2img');
    logger.i('txt2Img: $uri');

    final resp = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );
    logger.i('txt2Img: ${resp.statusCode}');

    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final response = Txt2ImgResponse.fromJson(json);
      return response;
    } else {
      throw Exception('Failed to load models');
    }
  }

  Future<void> setModel(SdModel? model) async {
    logger.i('setModel: $model');

    final uri = Uri.parse('$host/sdapi/v1/options');
    final settings = OverrideSettings(sdModelCheckpoint: model?.modelName);

    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(settings.toJson()),
    );
    logger.i('setModel: ${response.statusCode}');

    if (response.statusCode != 200) {
      logger.e('setModel: ${response.body}');
      throw Exception('Failed to set model');
    } else {
      logger.i('setModel: ${response.body}');
    }
  }

  Future<List<String>> getControlnetModels() async {
    final uri = Uri.parse('$host/controlnet/model_list');
    logger.i('getControlnetModels: $uri');

    final resp = await http.get(uri);
    logger.i('getControlnetModels: ${resp.statusCode}');

    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;

      return ControlnetModelResponse.fromJson(json).models;
    } else {
      throw Exception('Failed to load models');
    }
  }

  Future<int> getControlnetUnitCount() {
    final uri = Uri.parse('$host/controlnet/settings');
    logger.i('getControlnetUnitCount: $uri');

    return http.get(uri).then((resp) {
      logger.i('getControlnetUnitCount: ${resp.statusCode}');

      if (resp.statusCode == 200) {
        final json = jsonDecode(resp.body) as Map<String, dynamic>;
        return json['control_net_unit_count'] as int;
      } else {
        throw Exception('Failed to load models');
      }
    });
  }

  Future<ControlnetModule> getControlnetModule() {
    final uri = Uri.parse('$host/controlnet/module_list');
    logger.i('getControlnetModule: $uri');

    return http.get(uri).then((resp) {
      logger.i('getControlnetModule: ${resp.statusCode}');

      if (resp.statusCode == 200) {
        final json = jsonDecode(resp.body) as Map<String, dynamic>;
        return ControlnetModule.fromJson(json);
      } else {
        logger.e('getControlnetModule: ${resp.body}');
        throw Exception('Failed to load models');
      }
    });
  }

  Future<ControlnetDetectResponse> preprocess(ControlnetDetectRequest request) {
    final uri = Uri.parse('$host/controlnet/detect');
    logger.i('preprocess: $uri');

    return http
        .post(
      uri,
      headers: _headers,
      body: jsonEncode(request.toJson()),
    )
        .then((resp) {
      logger.i('preprocess: ${resp.statusCode}');

      if (resp.statusCode != 200) {
        logger.e('preprocess: ${resp.body}');
        throw Exception('Failed to preprocess');
      } else {
        logger.i('preprocess: ${resp.body}');
        final json = jsonDecode(resp.body) as Map<String, dynamic>;
        return ControlnetDetectResponse.fromJson(json);
      }
    });
  }

  Future<List<SdSampler>> getSamplers() {
    final uri = Uri.parse('$host/sdapi/v1/samplers');
    logger.i('getSamplers: $uri');

    return http.get(uri).then((resp) {
      logger.i('getSamplers: ${resp.statusCode}');

      if (resp.statusCode == 200) {
        final list = jsonDecode(resp.body) as List<dynamic>;

        final samplers = list
            .map((e) => SdSampler.fromJson(e as Map<String, dynamic>))
            .toList();

        return samplers;
      } else {
        throw Exception('Failed to load models');
      }
    });
  }
}
