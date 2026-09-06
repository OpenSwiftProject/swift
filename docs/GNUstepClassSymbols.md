# GNUstep imported Objective-C class symbols

The experimental frontend option `-objc-runtime-vendor=gnustep` selects the
GNUstep ABI v2 spelling and indirection for imported Objective-C class symbols
on ELF targets. It requires `-enable-objc-interop`. With the Swift driver, pass
both frontend options explicitly:

```sh
swiftc -Xfrontend -enable-objc-interop \
  -Xfrontend -objc-runtime-vendor=gnustep ...
```

The option also selects `-fobjc-runtime=gnustep-2.0` for the Clang importer.
Objective-C provider targets must be compiled with that same Clang runtime ABI.
Objective-C interop and runtime-vendor settings participate in the importer
cache key. Omitting the vendor option, or selecting `apple`, preserves Swift's
existing Apple ABI behavior; GNUstep is rejected on non-ELF targets.

## Class references

For a strongly imported class `Example`, Swift loads the external pointer slot
`._OBJC_REF_CLASS_Example` exported by the Objective-C translation unit defining
the class. It does not synthesize a Darwin `objc_classrefs` entry or require a
linker alias for `OBJC_CLASS_$_Example`.

A weakly imported class may have no provider, so there may be no exported slot
to load. Swift instead emits a private slot initialized with the `extern_weak`
raw class symbol `._OBJC_CLASS_Example`. An absent class can therefore resolve
to null without dereferencing a nonexistent external slot.

Linker names use the Clang interface name, including when an
`objc_runtime_name` attribute specifies a different name. Compatibility aliases
resolve to the underlying interface. These rules match Clang's GNUstep ABI v2
class emission in `clang/lib/CodeGen/CGObjCGNU.cpp`.

## Scope

This is imported-class symbol support, not complete GNUstep Objective-C interop.
It does not change selector references, Swift runtime metadata support,
Swift-defined `@objc` metadata, category registration, or subclass support.
In particular, Clang's GNUstep metaclass objects are internal implementation
details, not exported symbols that Swift can use by renaming Apple metaclass
references. Demo-side runtime and selector shims are still needed.

The compiler regressions cover x86_64 and AArch64 ELF references, weak imports,
runtime names, compatibility aliases, unchanged Apple lowering, and the
Swift-owned metadata naming boundary:

- `test/Frontend/objc_runtime_vendor.swift`
- `test/IRGen/gnustep_objc_class_symbols.swift`
- `test/IRGen/gnustep_native_class_symbols.swift`
