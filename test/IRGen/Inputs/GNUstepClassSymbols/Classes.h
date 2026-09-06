__attribute__((objc_root_class))
@interface First
- (instancetype _Nonnull)init;
@end

@interface Second : First
@end

__attribute__((objc_root_class, weak_import))
@interface WeakClass
- (instancetype _Nonnull)init;
@end

__attribute__((objc_root_class, objc_runtime_name("RuntimeRenamed")))
@interface Renamed
- (instancetype _Nonnull)init;
@end

__attribute__((objc_root_class, weak_import,
               objc_runtime_name("WeakRuntimeRenamed")))
@interface WeakRenamed
- (instancetype _Nonnull)init;
@end

@compatibility_alias Alias First;
