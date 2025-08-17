############################################
## Flutter – Keep all Flutter plugins
############################################
#
#-keep class io.flutter.** { *; }
#-keep class io.flutter.plugins.** { *; }
#
############################################
## GetX – Reflection-safe (optional)
############################################
#
#-keep class **.Controller { *; }
#
############################################
## Paystack SDK
############################################
#
#-keep class co.paystack.android.** { *; }
#-dontwarn co.paystack.android.**
#
############################################
## Flutter DotEnv
############################################
#
#-keep class io.github.cdimascio.dotenv.** { *; }
#-dontwarn io.github.cdimascio.dotenv.**
#
## Keep constructors for Kotlin data classes
#-keepclassmembers class ** {
#    public <init>(...);
#}
#
## Keep all annotations (safe)
#-keepattributes *Annotation*
#
## Keep R classes (for Android resources)
#-keepclassmembers class **.R$* {
#    public static <fields>;
#}
