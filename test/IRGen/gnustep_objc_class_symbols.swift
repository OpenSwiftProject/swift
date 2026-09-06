// RUN: %target-swift-frontend -target x86_64-unknown-linux-gnu -parse-stdlib -module-name Swift -enable-objc-interop -objc-runtime-vendor=gnustep -disable-objc-attr-requires-foundation-module -I %S/Inputs/GNUstepClassSymbols -emit-ir %s -o - | %FileCheck %s --check-prefix=GNUSTEP --implicit-check-not=OBJC_METACLASS --implicit-check-not=objc_classrefs --implicit-check-not='._OBJC_REF_CLASS_RuntimeRenamed'
// RUN: %target-swift-frontend -target aarch64-unknown-linux-gnu -parse-stdlib -module-name Swift -enable-objc-interop -objc-runtime-vendor=gnustep -disable-objc-attr-requires-foundation-module -I %S/Inputs/GNUstepClassSymbols -emit-ir %s -o - | %FileCheck %s --check-prefix=GNUSTEP --implicit-check-not=OBJC_METACLASS --implicit-check-not=objc_classrefs
// RUN: %target-swift-frontend -target x86_64-unknown-linux-gnu -parse-stdlib -module-name Swift -enable-objc-interop -disable-objc-attr-requires-foundation-module -I %S/Inputs/GNUstepClassSymbols -emit-ir %s -o - | %FileCheck %s --check-prefix=APPLE --implicit-check-not=._OBJC_
// RUN: %target-swift-frontend -target x86_64-unknown-linux-gnu -parse-stdlib -module-name Swift -enable-objc-interop -objc-runtime-vendor=apple -disable-objc-attr-requires-foundation-module -I %S/Inputs/GNUstepClassSymbols -emit-ir %s -o - | %FileCheck %s --check-prefix=APPLE --implicit-check-not=._OBJC_
// RUN: %target-swift-frontend -target x86_64-apple-macosx10.15 -parse-stdlib -module-name Swift -enable-objc-interop -disable-objc-attr-requires-foundation-module -I %S/Inputs/GNUstepClassSymbols -emit-ir %s -o - | %FileCheck %s --check-prefix=APPLE --implicit-check-not=._OBJC_

import GNUstepClassSymbols

// Strong references load the ABI v2 slot exported by the Objective-C provider.
// GNUSTEP-DAG: @._OBJC_REF_CLASS_First = external global ptr, align 8
// GNUSTEP-DAG: @._OBJC_REF_CLASS_Second = external global ptr, align 8
// GNUSTEP-DAG: @._OBJC_REF_CLASS_Renamed = external global ptr, align 8
// Weak imports need a local slot initialized from the nullable class symbol.
// GNUSTEP-DAG: @._OBJC_REF_CLASS_WeakClass = private global ptr @._OBJC_CLASS_WeakClass, align 8
// GNUSTEP-DAG: @._OBJC_CLASS_WeakClass = extern_weak global
// GNUSTEP-DAG: @._OBJC_REF_CLASS_WeakRenamed = private global ptr @._OBJC_CLASS_WeakRenamed, align 8
// GNUSTEP-DAG: @._OBJC_CLASS_WeakRenamed = extern_weak global

// The Apple ABI and the historical default retain local Darwin classrefs.
// APPLE-DAG: @"OBJC_CLASS_REF_$_First" = private externally_initialized global ptr @"OBJC_CLASS_$_First"
// APPLE-DAG: @"OBJC_CLASS_REF_$_Second" = private externally_initialized global ptr @"OBJC_CLASS_$_Second"
// APPLE-DAG: @"OBJC_CLASS_REF_$_RuntimeRenamed" = private externally_initialized global ptr @"OBJC_CLASS_$_RuntimeRenamed"
// APPLE-DAG: @"OBJC_CLASS_$_WeakClass" = extern_weak global
// APPLE-DAG: @"OBJC_CLASS_$_WeakRuntimeRenamed" = extern_weak global

// GNUSTEP-LABEL: define {{.*}} @"$sSo5FirstCMa"
// GNUSTEP: [[FIRST:%.*]] = load ptr, ptr @._OBJC_REF_CLASS_First, align 8
// GNUSTEP: call ptr @objc_opt_self(ptr [[FIRST]])
func firstType() -> First.Type { First.self }
// GNUSTEP-LABEL: define {{.*}} @"$sSo6SecondCMa"
// GNUSTEP: load ptr, ptr @._OBJC_REF_CLASS_Second, align 8
func secondType() -> Second.Type { Second.self }
// GNUSTEP-LABEL: define {{.*}} @"$sSo7RenamedCMa"
// GNUSTEP: load ptr, ptr @._OBJC_REF_CLASS_Renamed, align 8
func renamedType() -> Renamed.Type { Renamed.self }
// GNUSTEP-LABEL: define {{.*}} @"$sSo9WeakClassCMa"
// GNUSTEP: load ptr, ptr @._OBJC_REF_CLASS_WeakClass, align 8
func weakType() -> WeakClass.Type { WeakClass.self }
// GNUSTEP-LABEL: define {{.*}} @"$sSo11WeakRenamedCMa"
// GNUSTEP: load ptr, ptr @._OBJC_REF_CLASS_WeakRenamed, align 8
func weakRenamedType() -> WeakRenamed.Type { WeakRenamed.self }
// GNUSTEP-LABEL: define {{.*}} @"$ss9aliasTypeSo5FirstCmyF"
// GNUSTEP: call swiftcc %swift.metadata_response @"$sSo5FirstCMa"
func aliasType() -> Alias.Type { Alias.self }

// These constructors also exercise the classref path used for class messages.
// Selector lowering is deliberately unchanged in this class-symbol fix.
func makeFirst() -> First { First() }
func makeSecond() -> Second { Second() }
