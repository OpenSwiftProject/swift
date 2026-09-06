// RUN: %target-swift-frontend -target x86_64-unknown-linux-gnu -parse-stdlib -module-name Swift -typecheck %s -enable-objc-interop -objc-runtime-vendor=apple
// RUN: %target-swift-frontend -target x86_64-unknown-linux-gnu -parse-stdlib -module-name Swift -typecheck %s -enable-objc-interop -objc-runtime-vendor=gnustep
// RUN: not %target-swift-frontend -target x86_64-unknown-linux-gnu -parse-stdlib -module-name Swift -typecheck %s -enable-objc-interop -objc-runtime-vendor=unknown 2>&1 | %FileCheck %s --check-prefix=INVALID
// RUN: not %target-swift-frontend -target x86_64-unknown-linux-gnu -parse-stdlib -module-name Swift -typecheck %s -disable-objc-interop -objc-runtime-vendor=gnustep 2>&1 | %FileCheck %s --check-prefix=REQUIRES-INTEROP
// RUN: not %target-swift-frontend -target x86_64-apple-macosx10.15 -parse-stdlib -module-name Swift -typecheck %s -enable-objc-interop -objc-runtime-vendor=gnustep 2>&1 | %FileCheck %s --check-prefix=MACHO
// RUN: not %target-swift-frontend -target x86_64-unknown-windows-msvc -parse-stdlib -module-name Swift -typecheck %s -enable-objc-interop -objc-runtime-vendor=gnustep 2>&1 | %FileCheck %s --check-prefix=COFF

// INVALID: error: invalid value 'unknown' in '-objc-runtime-vendor=unknown'
// REQUIRES-INTEROP: error: option '-objc-runtime-vendor' requires '-enable-objc-interop'
// MACHO: error: unsupported option '-objc-runtime-vendor=gnustep' for target 'x86_64-apple-macosx10.15'
// COFF: error: unsupported option '-objc-runtime-vendor=gnustep' for target 'x86_64-unknown-windows-msvc'
