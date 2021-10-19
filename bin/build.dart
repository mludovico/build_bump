import 'dart:io';

main(List<String> args) async {
  print('Initializing...');
  final file = await File('pubspec.yaml');
  if (!file.existsSync()) {
    print('File not found');
    exit(1);
  }
  String content = file.readAsStringSync();
  String? message;
  final regex = RegExp(r'(?:version:.?\d*\.\d*\.\d*\+)(\d*)(?=.*\n)');
  content = content.replaceFirstMapped(
    regex,
    (Match match) {
      final version = match.group(0)?.split('+');
      final versionNumber = version?.first;
      final buildNumber = int.tryParse(version?.last ?? '');
      if (buildNumber == null) {
        print('Invalid build number ${match.groups([1])}');
        exit(1);
      }
      final bumped = '$versionNumber+${buildNumber + 1}';
      message = bumped;
      return bumped;
    },
  );
  await _commit(message);
  await file.writeAsString(content, mode: FileMode.write, flush: true);
  await _build();
}

Future<void> _commit(String? message) async {
  if (message == null) {
    print('Could not commit with message $message');
    exit(1);
  }
  final commitMessage = ('Bumped build number $message');
  print(commitMessage);
  print('Commiting build number change');
  await Process.run('git', ['add', 'pubspec.yaml'])
      .asStream()
      .listen((event) => print(event.stdout));
  await Process.run('git', ['commit', '-m', commitMessage])
      .asStream()
      .listen((event) => print(event.stdout));
}

Future<void> _build() async {
  print('Pub get-ting...');
  await Process.run('flutter', ['pub', 'get'])
      .asStream()
      .listen((event) => print(event.stdout));
  await _buildAndroid();
  await _buildIOS();
}

Future<void> _buildAndroid() async {
  print('Building Android...');
  await Process.run('flutter', ['build', 'apk'])
      .asStream()
      .listen((event) => print(event.stdout));
}

Future<void> _buildIOS() async {
  print('Building iOS...');
  await Process.run('flutter', ['build', 'ios'])
      .asStream()
      .listen((event) => print(event.stdout));
}
