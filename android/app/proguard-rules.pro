# Flutter-specific ProGuard rules
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Your app's main classes
-keep class com.example.QuickNotion.** { *; }

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Google Play Core library - allow missing classes (optional dependency)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
-keepclassmembers class com.google.android.play.core.** { *; }

# Suppress warnings about missing Google Play Core classes
-keep class io.flutter.embedding.engine.deferredcomponents.PlayStoreDeferredComponentManager {
    *** splitInstallManager;
}

