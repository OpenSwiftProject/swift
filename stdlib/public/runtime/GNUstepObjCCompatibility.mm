//===--- GNUstepObjCCompatibility.mm - GNUstep ObjC shims -----------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#include "swift/Runtime/Config.h"

#if SWIFT_OBJC_INTEROP
#include <objc/objc-arc.h>
#include <objc/runtime.h>

#if defined(__GNUSTEP_RUNTIME__) || defined(__OBJC_GNUSTEP_RUNTIME_ABI__)

typedef struct objc_image_info {
  uint32_t version;
  uint32_t flags;
} objc_image_info;

extern "C" {

void *_objc_empty_cache = nullptr;

const struct {
  char c;
} objc_absolute_packed_isa_class_mask = {0};

id _objc_rootAutorelease(id object) {
  return objc_autorelease(object);
}

Class objc_opt_self(Class cls) {
  return cls;
}

id objc_constructInstance(Class cls, void *bytes) {
  if (cls == Nil || bytes == nullptr)
    return nil;
  *reinterpret_cast<Class *>(bytes) = cls;
  return reinterpret_cast<id>(bytes);
}

void *objc_destructInstance(id object) {
  return object;
}

Class objc_readClassPair(Class cls, const objc_image_info *) {
  return cls;
}

} // extern "C"

#endif // defined(__GNUSTEP_RUNTIME__) || defined(__OBJC_GNUSTEP_RUNTIME_ABI__)
#endif // SWIFT_OBJC_INTEROP
