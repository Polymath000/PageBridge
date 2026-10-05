# Project Context: PageBridge

## Overview
**PageBridge** is a Flutter mobile and tablet application designed to integrate seamlessly with the Notion API. It empowers users to authenticate with their Notion workspace, view recent pages and databases, search relations, and create or edit Notion pages directly.

## Architecture
- **Pattern:** Clean Architecture (Feature-First) + Cubit State Management.
- **Layers:**
  - `presentation`: Views, Cubits, States, Widgets.
  - `domain`: Entities, Abstract Repositories, Use Cases.
  - `data`: Models, Data Sources, Repository Implementations.
- **Shared Code:**
  - `lib/core/`: Network clients (Dio), storage, errors/failures, constants, themes, shared widgets/helpers.
  - `lib/config/`: App routing (`on_generate_routes.dart`), theme configs, extensions.

## Tooling & Debugging Setup
- **Dart Development Service (DDS):** Required for full Flutter DevTools capabilities (especially the **Performance** tab, Perfetto trace streaming, and CPU sampling).
- **Configurations (`.vscode/launch.json`):** Launch profiles (Debug, Profile, Release) configured without `--no-dds` so DDS runs and proxies VM Service event streams correctly.

## Key Features
1. **Authentication:** Notion OAuth and token management with secure caching (`flutter_secure_storage`).
2. **Databases & Pages:** Browsing connected databases, viewing schema properties, and displaying recent pages feed with pull-to-refresh.
3. **New Page Creation:** Dynamic field rendering based on Notion property types (text, number, select, multi-select, relation, date, etc.).
4. **Theming & Responsiveness:** Dark/light mode switching and adaptive layouts for phone and tablet screens.

## Recent UI & Performance Optimizations
- **Rasterization & GPU Optimization:** Replaced expensive `BackdropFilter` blur shaders with lightweight gradient-based glassmorphism (`BoxDecoration` with linear opacity gradient and subtle border) on `CustomSearchTextField`, `DatabaseCard`, and `CustomAppBar` / `RelationSearchAppBar`.
- **Profile Mode Benchmarking:** Configured `.vscode/launch.json` DDS support to enable smooth DevTools Performance timeline recording and CPU profiling without shader compilation overhead.
