// ignore_for_file: implicit_dynamic_map_literal
import 'dart:async';
import "dart:convert";
import "dart:io";

import "package:meta/meta.dart";
import "package:shared_models/model_config.dart";

const _minConfig = "[]";

class ModelsConfigController
{
  static const JsonCodec _jsonCodec = JsonCodec();
  Map<String, ModelConfig> configs = Map<String, ModelConfig>();
  File configFile;

  ModelsConfigController({
    @required Directory folderPath,
  })
  {
    configFile = File("${folderPath.path}/models_config.json");
    if(!configFile.existsSync())
    {
      configFile.createSync();
      configFile.writeAsStringSync(_minConfig);
    }
    _readConfig();
  }

  void _readConfig()
  {
    final dynamic json = _jsonCodec.decode(configFile.readAsStringSync());
    for(final confgJson in json)
    {
      final ModelConfig config = ModelConfig.fromJson(confgJson as Map<String, dynamic>);
      configs[config.name] = config;
    }
  }

  void _writeConfig()
  {
    List<Map<String, dynamic>> json;
    for(var config in configs.values)
    {
      json.add(config.toJson());
    }
    configFile.writeAsStringSync(_jsonCodec.encode(json));
  }

  Future save() async
  {
    _writeConfig();
  }
  
  ModelConfig operator [](String key) => configs[key];
  void operator []=(String key, ModelConfig value) => configs[key] = value;

  void add(ModelConfig config)
  {
    configs[config.name] = config;
  }

  List<ModelConfig> getConfigList()
  {
    return configs.values?.toList();
  }
}