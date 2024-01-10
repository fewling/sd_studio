import 'package:freezed_annotation/freezed_annotation.dart';

part 'sampler.freezed.dart';
part 'sampler.g.dart';

@freezed
class Sampler with _$Sampler {
  const factory Sampler({
    required String name,
    required List<String> aliases,
  }) = _Sampler;

  factory Sampler.fromJson(Map<String, dynamic> json) =>
      _$SamplerFromJson(json);
}

/// Example of samplers.
const _samplers = [
  {
    'name': 'DPM++ 2M Karras',
    'aliases': ['k_dpmpp_2m_ka'],
    'options': {'scheduler': 'karras'}
  },
  {
    'name': 'DPM++ SDE Karras',
    'aliases': ['k_dpmpp_sde_ka'],
    'options': {
      'scheduler': 'karras',
      'second_order': 'True',
      'brownian_noise': 'True'
    }
  },
  {
    'name': 'DPM++ 2M SDE Exponential',
    'aliases': ['k_dpmpp_2m_sde_exp'],
    'options': {'scheduler': 'exponential', 'brownian_noise': 'True'}
  },
  {
    'name': 'DPM++ 2M SDE Karras',
    'aliases': ['k_dpmpp_2m_sde_ka'],
    'options': {'scheduler': 'karras', 'brownian_noise': 'True'}
  },
  {
    'name': 'Euler a',
    'aliases': ['k_euler_a', 'k_euler_ancestral'],
    'options': {'uses_ensd': 'True'}
  },
  {
    'name': 'Euler',
    'aliases': ['k_euler'],
    'options': {}
  },
  {
    'name': 'LMS',
    'aliases': ['k_lms'],
    'options': {}
  },
  {
    'name': 'Heun',
    'aliases': ['k_heun'],
    'options': {'second_order': 'True'}
  },
  {
    'name': 'DPM2',
    'aliases': ['k_dpm_2'],
    'options': {'discard_next_to_last_sigma': 'True', 'second_order': 'True'}
  },
  {
    'name': 'DPM2 a',
    'aliases': ['k_dpm_2_a'],
    'options': {
      'discard_next_to_last_sigma': 'True',
      'uses_ensd': 'True',
      'second_order': 'True'
    }
  },
  {
    'name': 'DPM++ 2S a',
    'aliases': ['k_dpmpp_2s_a'],
    'options': {'uses_ensd': 'True', 'second_order': 'True'}
  },
  {
    'name': 'DPM++ 2M',
    'aliases': ['k_dpmpp_2m'],
    'options': {}
  },
  {
    'name': 'DPM++ SDE',
    'aliases': ['k_dpmpp_sde'],
    'options': {'second_order': 'True', 'brownian_noise': 'True'}
  },
  {
    'name': 'DPM++ 2M SDE',
    'aliases': ['k_dpmpp_2m_sde_ka'],
    'options': {'brownian_noise': 'True'}
  },
  {
    'name': 'DPM++ 2M SDE Heun',
    'aliases': ['k_dpmpp_2m_sde_heun'],
    'options': {'brownian_noise': 'True', 'solver_type': 'heun'}
  },
  {
    'name': 'DPM++ 2M SDE Heun Karras',
    'aliases': ['k_dpmpp_2m_sde_heun_ka'],
    'options': {
      'scheduler': 'karras',
      'brownian_noise': 'True',
      'solver_type': 'heun'
    }
  },
  {
    'name': 'DPM++ 2M SDE Heun Exponential',
    'aliases': ['k_dpmpp_2m_sde_heun_exp'],
    'options': {
      'scheduler': 'exponential',
      'brownian_noise': 'True',
      'solver_type': 'heun'
    }
  },
  {
    'name': 'DPM++ 3M SDE',
    'aliases': ['k_dpmpp_3m_sde'],
    'options': {'discard_next_to_last_sigma': 'True', 'brownian_noise': 'True'}
  },
  {
    'name': 'DPM++ 3M SDE Karras',
    'aliases': ['k_dpmpp_3m_sde_ka'],
    'options': {
      'scheduler': 'karras',
      'discard_next_to_last_sigma': 'True',
      'brownian_noise': 'True'
    }
  },
  {
    'name': 'DPM++ 3M SDE Exponential',
    'aliases': ['k_dpmpp_3m_sde_exp'],
    'options': {
      'scheduler': 'exponential',
      'discard_next_to_last_sigma': 'True',
      'brownian_noise': 'True'
    }
  },
  {
    'name': 'DPM fast',
    'aliases': ['k_dpm_fast'],
    'options': {'uses_ensd': 'True'}
  },
  {
    'name': 'DPM adaptive',
    'aliases': ['k_dpm_ad'],
    'options': {'uses_ensd': 'True'}
  },
  {
    'name': 'LMS Karras',
    'aliases': ['k_lms_ka'],
    'options': {'scheduler': 'karras'}
  },
  {
    'name': 'DPM2 Karras',
    'aliases': ['k_dpm_2_ka'],
    'options': {
      'scheduler': 'karras',
      'discard_next_to_last_sigma': 'True',
      'uses_ensd': 'True',
      'second_order': 'True'
    }
  },
  {
    'name': 'DPM2 a Karras',
    'aliases': ['k_dpm_2_a_ka'],
    'options': {
      'scheduler': 'karras',
      'discard_next_to_last_sigma': 'True',
      'uses_ensd': 'True',
      'second_order': 'True'
    }
  },
  {
    'name': 'DPM++ 2S a Karras',
    'aliases': ['k_dpmpp_2s_a_ka'],
    'options': {
      'scheduler': 'karras',
      'uses_ensd': 'True',
      'second_order': 'True'
    }
  },
  {
    'name': 'Restart',
    'aliases': ['restart'],
    'options': {'scheduler': 'karras', 'second_order': 'True'}
  },
  {
    'name': 'DDIM',
    'aliases': ['ddim'],
    'options': {}
  },
  {
    'name': 'PLMS',
    'aliases': ['plms'],
    'options': {}
  },
  {
    'name': 'UniPC',
    'aliases': ['unipc'],
    'options': {}
  }
];
