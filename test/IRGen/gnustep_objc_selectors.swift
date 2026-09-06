// RUN: %target-swift-frontend -target x86_64-unknown-linux-gnu -parse-stdlib -module-name Swift -enable-objc-interop -objc-runtime-vendor=gnustep -disable-objc-attr-requires-foundation-module -I %S/Inputs/GNUstepSelectors -emit-ir %s | %FileCheck %s --check-prefix=GNUSTEP --implicit-check-not=objc_selrefs --implicit-check-not=sel_registerName
// RUN: %target-swift-frontend -target aarch64-unknown-linux-gnu -parse-stdlib -module-name Swift -enable-objc-interop -objc-runtime-vendor=gnustep -disable-objc-attr-requires-foundation-module -I %S/Inputs/GNUstepSelectors -emit-ir %s | %FileCheck %s --check-prefix=GNUSTEP --implicit-check-not=objc_selrefs --implicit-check-not=sel_registerName
// RUN: %target-swift-frontend -target x86_64-unknown-linux-gnu -parse-stdlib -module-name Swift -enable-objc-interop -disable-objc-attr-requires-foundation-module -I %S/Inputs/GNUstepSelectors -emit-ir %s | %FileCheck %s --check-prefix=APPLE --implicit-check-not=__objc_selectors

import GNUstepSelectors

public typealias Void = ()
precedencegroup AssignmentPrecedence {
  associativity: right
  assignment: true
}

// GNUSTEP-DAG: @.objc_selector_ping_ = linkonce_odr hidden global { ptr, ptr } { ptr @.objc_sel_name_ping, ptr null }, section "__objc_selectors", comdat, align 8
// GNUSTEP-DAG: @".objc_selector_take:other:_" = linkonce_odr hidden global { ptr, ptr }
// GNUSTEP-DAG: @.objc_selector_child_ = linkonce_odr hidden global { ptr, ptr }
// GNUSTEP-DAG: @".objc_selector_setChild:_" = linkonce_odr hidden global { ptr, ptr }
// GNUSTEP-DAG: @.objc_selector_pingClass_ = linkonce_odr hidden global { ptr, ptr }
// APPLE-DAG: @"\01L_selector(ping)" = private externally_initialized global ptr
// APPLE-DAG: @"\01L_selector(take:other:)" = private externally_initialized global ptr

// GNUSTEP-LABEL: define {{.*}}@"$ss5calls
// GNUSTEP: [[PING:%.*]] = load ptr, ptr @"\01L_selector(ping)", align 8
// GNUSTEP: call void @objc_msgSend(ptr {{.*}}, ptr [[PING]])
public func calls(_ value: SelectorProbe) {
  value.ping()
  value.take(value, other: value)
  value.child = value.child
  SelectorProbe.pingClass()
}
