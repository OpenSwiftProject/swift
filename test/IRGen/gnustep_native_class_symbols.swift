// RUN: %target-swift-frontend -target x86_64-unknown-linux-gnu -parse-stdlib -module-name Swift -enable-objc-interop -objc-runtime-vendor=gnustep -disable-objc-attr-requires-foundation-module -emit-ir %s -o - | %FileCheck %s --implicit-check-not=._OBJC_
// RUN: %target-swift-frontend -target x86_64-unknown-linux-gnu -parse-stdlib -module-name Swift -enable-objc-interop -disable-objc-attr-requires-foundation-module -emit-ir %s -o - | %FileCheck %s --implicit-check-not=._OBJC_

// Imported GNUstep class references must not rename Swift-owned metadata.
// This is an IR naming boundary test, not a claim that Swift-defined @objc
// classes can be registered with GNUstep's runtime yet.
// CHECK-DAG: @"OBJC_METACLASS_$_NativeClass" = hidden global %objc_class
// CHECK-DAG: @"OBJC_CLASS_$__TtCs12_SwiftObject" = external global %objc_class
// CHECK-DAG: @"OBJC_CLASS_$_NativeClass" = hidden alias %swift.type, ptr @"$ss11NativeClassCN"
@objc(NativeClass)
class NativeClass {}

func nativeType() -> NativeClass.Type { NativeClass.self }
