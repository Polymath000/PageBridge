# PageBridge

PageBridge is a Flutter app for capturing ideas quickly and syncing them to your Notion workspace. Sign in with Notion, pick a database, and create pages through a fast, property-aware form.

**Features**
- Notion OAuth sign-in with secure token storage.
- Onboarding experience and animated sign-in.
- Search and browse Notion databases with pagination.
- Create new pages from database properties (text, select, dates, relations, and more).
- Relation picker with page search and multi-select.
- Light/dark theme switching.

**Supported Properties**
- Title, text, rich text.
- Number, url, email, phone.
- Select, multi-select, status.
- Date.
- Checkbox.
- Relation.

**Architecture**
- Clean Architecture with strict `presentation -> domain -> data` boundaries.
- Feature-first structure: `feature/auth`, `feature/databases`, `feature/onStartedViews`.
- Shared utilities, services, and design tokens in `core`.
- App routing and theming in `config`.
- State management with Cubit/Bloc and dependency injection via GetIt.

**Configuration**
1. Create a Notion integration and generate a client ID and client secret.
2. Update OAuth settings in `lib/core/services/notion_oauth_config.dart`.
3. Ensure your redirect flow matches the app callback scheme.
4. Verify the Android callback scheme in `android/app/src/main/AndroidManifest.xml`.
5. Verify the iOS callback scheme in `ios/Runner/Info.plist`.

**Getting Started**
- Install Flutter with a Dart SDK compatible with `pubspec.yaml` (Dart `^3.10.0`).
- Run `flutter pub get`.
- Start the app with `flutter run`.

**Development**
- Format: `dart format .`
- Analyze: `flutter analyze`
- Test: `flutter test`

**Notes**
- OAuth tokens are stored using `flutter_secure_storage`.
- Replace the example Notion OAuth credentials before shipping; never commit real secrets.
