
OUTPUT_FORMAT("binary")
OUTPUT_ARCH(i386)
ENTRY(_start)
SECTIONS
{
  . = 0x7c00;
  .text : {
    _start = .;
    *(.text)
  }
  .rodata : { *(.rodata) }
  .data : { *(.data) }
  .bss : {
    _bss_start = .;
    *(.bss)
    _bss_end = .;
  }
  /DISCARD/ : { *(.note.GNU-stack) }
}



