//===------ JITSymbolFlags.h - Flags for symbols in the JIT -----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Symbol flags for symbols in the JIT (e.g. weak, exported).
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_EXECUTIONENGINE_JITSYMBOLFLAGS_H
#define LLVM_EXECUTIONENGINE_JITSYMBOLFLAGS_H

#include "llvm/IR/GlobalValue.h"
#include "llvm/Object/SymbolicFile.h"

namespace llvm {

/// @brief Flags for symbols in the JIT.
enum class JITSymbolFlags : char {
  None = 0,
  Weak = 1U << 0,
  Common = 1U << 1,
  Exported = 1U << 2
};

inline JITSymbolFlags operator|(JITSymbolFlags LHS, JITSymbolFlags RHS) {
  typedef std::underlying_type<JITSymbolFlags>::type UT;
  return static_cast<JITSymbolFlags>(
           static_cast<UT>(LHS) | static_cast<UT>(RHS));
}

inline JITSymbolFlags& operator |=(JITSymbolFlags &LHS, JITSymbolFlags RHS) {
  LHS = LHS | RHS;
  return LHS;
}

inline JITSymbolFlags operator&(JITSymbolFlags LHS, JITSymbolFlags RHS) {
  typedef std::underlying_type<JITSymbolFlags>::type UT;
  return static_cast<JITSymbolFlags>(
           static_cast<UT>(LHS) & static_cast<UT>(RHS));
}

inline JITSymbolFlags& operator &=(JITSymbolFlags &LHS, JITSymbolFlags RHS) {
  LHS = LHS & RHS;
  return LHS;
}

/// @brief Base class for symbols in the JIT.
class JITSymbolBase {
public:
  JITSymbolBase(JITSymbolFlags Flags) : Flags(Flags) {}

  JITSymbolFlags getFlags() const { return Flags; }

  bool isWeak() const {
    return (Flags & JITSymbolFlags::Weak) == JITSymbolFlags::Weak;
  }

  bool isCommon() const {
    return (Flags & JITSymbolFlags::Common) == JITSymbolFlags::Common;
  }

  bool isExported() const {
    return (Flags & JITSymbolFlags::Exported) == JITSymbolFlags::Exported;
  }

  static JITSymbolFlags flagsFromGlobalValue(const GlobalValue &GV) {
    JITSymbolFlags Flags = JITSymbolFlags::None;
    if (GV.hasWeakLinkage())
      Flags |= JITSymbolFlags::Weak;
    if (GV.hasCommonLinkage())
      Flags |= JITSymbolFlags::Common;
    if (!GV.hasLocalLinkage() && !GV.hasHiddenVisibility())
      Flags |= JITSymbolFlags::Exported;
    return Flags;
  }

  static JITSymbolFlags
  flagsFromObjectSymbol(const object::BasicSymbolRef &Symbol) {
    JITSymbolFlags Flags = JITSymbolFlags::None;
    if (Symbol.getFlags() & object::BasicSymbolRef::SF_Weak)
      Flags |= JITSymbolFlags::Weak;
    if (Symbol.getFlags() & object::BasicSymbolRef::SF_Common)
      Flags |= JITSymbolFlags::Common;
    if (Symbol.getFlags() & object::BasicSymbolRef::SF_Exported)
      Flags |= JITSymbolFlags::Exported;
    return Flags;
  }

private:
  JITSymbolFlags Flags;
};

} // end namespace llvm

#endif
