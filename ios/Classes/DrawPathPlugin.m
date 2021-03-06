#import "DrawPathPlugin.h"
#if __has_include(<draw_path/draw_path-Swift.h>)
#import <draw_path/draw_path-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "draw_path-Swift.h"
#endif

@implementation DrawPathPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDrawPathPlugin registerWithRegistrar:registrar];
}
@end
