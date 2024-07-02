import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage: dart generate_bloc_files.dart <ScreenName>');
    return;
  }

  final screenName = arguments[0];
  final screenNameLower = screenName.toLowerCase();
  final templates = {
    'bloc': 'tools/templates/template_bloc.txt',
    'state': 'tools/templates/template_state.txt',
    'event': 'tools/templates/template_event.txt',
    'router': 'tools/templates/template_router.txt',
    'page': 'tools/templates/template_page.txt',
    'index': 'tools/templates/index.txt',
  };

  final outputDir = 'lib/presentation/page/$screenNameLower';

  // Create the directory if it doesn't exist
  final directory = Directory(outputDir);
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  for (final entry in templates.entries) {
    final templateFile = File(entry.value);
    if (!templateFile.existsSync()) {
      print('Template file ${entry.value} does not exist');
      return;
    }

    final templateContent = templateFile.readAsStringSync();
    final newContent = templateContent
        .replaceAll('{ScreenName}', screenName)
        .replaceAll('{screen_name}', screenNameLower);
    final newFile = File('$outputDir/${screenNameLower}_${entry.key}.dart');

    if (entry.key == 'index') {
      final newIndexFile = File('$outputDir/index.dart');
      newIndexFile.writeAsStringSync(newContent);
      print('File $outputDir/index.dart created successfully.');
    } else {
      newFile.writeAsStringSync(newContent);
      print('File $outputDir/${screenNameLower}_${entry.key}.dart created successfully.');
    }

  }
}
