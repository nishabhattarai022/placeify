import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:yaml/yaml.dart';

/// Repairs migration drift after `git restore` / branch switches.
///
/// 1. Removes migration folders on disk that are not in [migration_registry.txt].
/// 2. Resets `serverpod_migrations.version` when a module references a migration
///    that no longer exists in that module's registry.
/// 3. Drops columns on the `product` table that were added by a reverted migration
///    but are no longer in [product.spy.yaml].
///
/// Run from [placeify_server]:
///   dart bin/fix_migration_drift.dart
Future<void> main() async {
  final serverRoot = _serverRoot();
  final placeifyRegistry = _readRegistry(
    '${serverRoot.path}/migrations/migration_registry.txt',
  );
  if (placeifyRegistry.isEmpty) {
    stderr.writeln('No migrations found in migration_registry.txt.');
    exit(1);
  }

  final moduleRegistries = <String, List<String>>{
    'placeify': placeifyRegistry,
    'serverpod': _readRegistry(_packageRegistryPath('serverpod', '3.4.8')),
    'serverpod_auth_core': _readRegistry(
      _packageRegistryPath('serverpod_auth_core_server', '3.4.8'),
    ),
    'serverpod_auth_idp': _readRegistry(
      _packageRegistryPath('serverpod_auth_idp_server', '3.4.8'),
    ),
  };

  final orphans = _orphanMigrationFolders(serverRoot, placeifyRegistry);
  for (final folder in orphans) {
    stderr.writeln('Removing orphan migration folder: $folder');
    Directory('${serverRoot.path}/migrations/$folder').deleteSync(recursive: true);
  }

  final db = _loadDatabaseConfig(serverRoot);
  final connection = await Connection.open(
    Endpoint(
      host: db.host,
      port: db.port,
      database: db.name,
      username: db.user,
      password: db.password,
    ),
    settings: const ConnectionSettings(sslMode: SslMode.disable),
  );

  try {
    final rows = await connection.execute(
      Sql('SELECT module, version FROM serverpod_migrations ORDER BY module'),
    );

    if (rows.isEmpty) {
      stderr.writeln(
        'serverpod_migrations is empty. Run: dart bin/main.dart --apply-migrations',
      );
      return;
    }

    var fixedVersions = false;
    for (final row in rows) {
      final module = row[0] as String;
      final version = row[1] as String;
      final registry = moduleRegistries[module];

      if (registry == null) {
        stdout.writeln('SKIP $module -> $version (unknown module)');
        continue;
      }

      if (registry.contains(version)) {
        stdout.writeln('OK  $module -> $version');
        continue;
      }

      final latest = registry.last;
      stderr.writeln(
        'FIX $module: DB has $version (missing from project) -> $latest',
      );
      await connection.execute(
        Sql.named(
          'UPDATE serverpod_migrations '
          'SET version = @version, timestamp = now() '
          'WHERE module = @module',
        ),
        parameters: {'version': latest, 'module': module},
      );
      fixedVersions = true;
    }

    const revertedProductColumns = <String>[
      'discountPrice',
      'discountPercentage',
      'isOffer',
      'hasActiveOffer',
      'featured',
      'isDeleted',
      'isActive',
    ];

    var droppedColumns = false;
    for (final column in revertedProductColumns) {
      final exists = await connection.execute(
        Sql.named(
          'SELECT 1 FROM information_schema.columns '
          "WHERE table_schema = 'public' AND table_name = 'product' "
          'AND column_name = @column',
        ),
        parameters: {'column': column},
      );
      if (exists.isEmpty) continue;

      stderr.writeln('DROP product."$column" (from reverted migration)');
      await connection.execute(
        Sql('ALTER TABLE "product" DROP COLUMN IF EXISTS "$column"'),
      );
      droppedColumns = true;
    }

    if (fixedVersions || droppedColumns || orphans.isNotEmpty) {
      stdout.writeln('\nDatabase drift repaired.');
      stdout.writeln('Next: dart bin/main.dart --apply-migrations');
    } else {
      stdout.writeln('\nNo drift detected.');
    }
  } finally {
    await connection.close();
  }
}

Directory _serverRoot() {
  final cwd = Directory.current;
  if (File('${cwd.path}/migrations/migration_registry.txt').existsSync()) {
    return cwd;
  }
  final nested = Directory('${cwd.path}/placeify_server');
  if (File('${nested.path}/migrations/migration_registry.txt').existsSync()) {
    return nested;
  }
  stderr.writeln('Run this script from placeify_server (or repo root).');
  exit(1);
}

List<String> _readRegistry(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('Migration registry not found: $path');
    exit(1);
  }
  return [
    for (final line in file.readAsLinesSync())
      if (RegExp(r'^\d+$').hasMatch(line.trim())) line.trim(),
  ];
}

String _packageRegistryPath(String package, String version) {
  final home = Platform.environment['HOME'];
  if (home == null) {
    stderr.writeln('HOME is not set; cannot locate Serverpod package migrations.');
    exit(1);
  }
  return '$home/.pub-cache/hosted/pub.dev/$package-$version/'
      'migrations/migration_registry.txt';
}

List<String> _orphanMigrationFolders(
  Directory serverRoot,
  List<String> registry,
) {
  final registrySet = registry.toSet();
  final migrationsDir = Directory('${serverRoot.path}/migrations');
  return [
    for (final entity in migrationsDir.listSync())
      if (entity is Directory)
        if (RegExp(r'^\d+$').hasMatch(entity.uri.pathSegments.last))
          if (!registrySet.contains(entity.uri.pathSegments.last))
            entity.uri.pathSegments.last,
  ]..sort();
}

({String host, int port, String name, String user, String password})
    _loadDatabaseConfig(Directory serverRoot) {
  final devYaml = loadYaml(
    File('${serverRoot.path}/config/development.yaml').readAsStringSync(),
  ) as YamlMap;
  final passwordsYaml = loadYaml(
    File('${serverRoot.path}/config/passwords.yaml').readAsStringSync(),
  ) as YamlMap;

  final database = devYaml['database'] as YamlMap;
  final developmentPasswords = passwordsYaml['development'] as YamlMap?;

  final password = developmentPasswords?['database'] as String?;
  if (password == null || password.isEmpty) {
    stderr.writeln('Missing development.database password in passwords.yaml');
    exit(1);
  }

  return (
    host: database['host'] as String,
    port: database['port'] as int,
    name: database['name'] as String,
    user: database['user'] as String,
    password: password,
  );
}
