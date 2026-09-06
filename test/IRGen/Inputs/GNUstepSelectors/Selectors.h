__attribute__((objc_root_class))
@interface SelectorProbe
+ (void)pingClass;
- (void)ping;
- (void)take:(SelectorProbe * _Nonnull)first
       other:(SelectorProbe * _Nonnull)second;
@property(nonatomic, strong, nonnull) SelectorProbe *child;
@end
