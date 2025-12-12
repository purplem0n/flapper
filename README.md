# flapper
A flutter project template with supporting utility scripts.

## Setup

### Initial Project Setup

Run `setup.sh` to configure your project with your package ID and app name:

```bash
./setup.sh [package_id] [app_name]
```

This script will:
- Replace the default package ID (`com.example.flapper`) with your custom package ID
- Replace the default app name (`flapper`) with your custom app name
- Update all relevant files (Dart, YAML, Kotlin, XML, plist, etc.)
- Rename Android package directories to match your package structure
- Generate launcher icons and native splash screens

If you don't provide arguments, the script will prompt you for the package ID and app name.

**Example:**
```bash
./setup.sh com.mycompany.myapp MyApp
```

## Feature Development

### Creating New Features

Use `feat.sh` to quickly scaffold new features from a template:

```bash
./feat.sh
```

This script will:
- Prompt you for a feature name (in snake_case, e.g., `user_profile`)
- Prompt you whether the feature should use a GlobalBloc (true/false)
- Copy the template feature directory and rename all files/directories
- Replace all template references with your feature name in appropriate naming conventions:
  - Class names: PascalCase (e.g., `UserProfileBloc`)
  - Variable names: camelCase (e.g., `userProfileBloc`)
  - File names: snake_case (e.g., `user_profile_bloc.dart`)
- Update `app.dart` to add the necessary imports and providers
- Configure the feature to use global or local bloc based on your choice

**Example:**
```bash
./feat.sh
# Enter feature name: user_profile
# GlobalBloc: true
```

After running the script, you'll need to:
1. Update `lib/app/router.dart` to add the new route
2. Review and update the generated files as needed
3. Remove sample files if not needed