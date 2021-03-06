; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s

; SHLD/SHRD manual shifts

define i64 @test1(i64 %hi, i64 %lo, i64 %bits) nounwind {
; CHECK-LABEL: test1:
; CHECK:       # BB#0:
; CHECK-NEXT:    andl $63, %edx
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    shldq %cl, %rsi, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %and = and i64 %bits, 63
  %and64 = sub i64 64, %and
  %sh_lo = lshr i64 %lo, %and64
  %sh_hi = shl i64 %hi, %and
  %sh = or i64 %sh_lo, %sh_hi
  ret i64 %sh
}

define i64 @test2(i64 %hi, i64 %lo, i64 %bits) nounwind {
; CHECK-LABEL: test2:
; CHECK:       # BB#0:
; CHECK-NEXT:    andl $63, %edx
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    shrdq %cl, %rdi, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %and = and i64 %bits, 63
  %and64 = sub i64 64, %and
  %sh_lo = shl i64 %hi, %and64
  %sh_hi = lshr i64 %lo, %and
  %sh = or i64 %sh_lo, %sh_hi
  ret i64 %sh
}

define i64 @test3(i64 %hi, i64 %lo, i64 %bits) nounwind {
; CHECK-LABEL: test3:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    shldq %cl, %rsi, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %bits64 = sub i64 64, %bits
  %sh_lo = lshr i64 %lo, %bits64
  %sh_hi = shl i64 %hi, %bits
  %sh = or i64 %sh_lo, %sh_hi
  ret i64 %sh
}

define i64 @test4(i64 %hi, i64 %lo, i64 %bits) nounwind {
; CHECK-LABEL: test4:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    shrdq %cl, %rdi, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %bits64 = sub i64 64, %bits
  %sh_lo = shl i64 %hi, %bits64
  %sh_hi = lshr i64 %lo, %bits
  %sh = or i64 %sh_lo, %sh_hi
  ret i64 %sh
}

define i64 @test5(i64 %hi, i64 %lo, i64 %bits) nounwind {
; CHECK-LABEL: test5:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    shldq %cl, %rsi, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %bits64 = xor i64 %bits, 63
  %lo2 = lshr i64 %lo, 1
  %sh_lo = lshr i64 %lo2, %bits64
  %sh_hi = shl i64 %hi, %bits
  %sh = or i64 %sh_lo, %sh_hi
  ret i64 %sh
}

define i64 @test6(i64 %hi, i64 %lo, i64 %bits) nounwind {
; CHECK-LABEL: test6:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    shrdq %cl, %rsi, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %bits64 = xor i64 %bits, 63
  %lo2 = shl i64 %lo, 1
  %sh_lo = shl i64 %lo2, %bits64
  %sh_hi = lshr i64 %hi, %bits
  %sh = or i64 %sh_lo, %sh_hi
  ret i64 %sh
}

define i64 @test7(i64 %hi, i64 %lo, i64 %bits) nounwind {
; CHECK-LABEL: test7:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    shrdq %cl, %rsi, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %bits64 = xor i64 %bits, 63
  %lo2 = add i64 %lo, %lo
  %sh_lo = shl i64 %lo2, %bits64
  %sh_hi = lshr i64 %hi, %bits
  %sh = or i64 %sh_lo, %sh_hi
  ret i64 %sh
}
