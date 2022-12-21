/*this header is a memory allocator for I/O device,including mouse and VGA*/
#include <stdint.h>
#ifndef _GPIO_

#define _GPIO_

#define GPIO_ORIGIN (0x40000000)

#endif // !_GPIO_
#ifndef _MOUSE_

#define _MOUSE_

#define MOUSE_X ((GPIO_ORIGIN))
#define MOUSE_Y ((GPIO_ORIGIN) + (0x2))
#define MOUSE_CLICK ((GPIO_ORIGIN) + (0x4))

#endif // !_MOUSE_
#ifndef _VGA_

#define _VGA_

#define VGA_ORIGIN ((GPIO_ORIGIN) + (0x01000000))
#define VGA_NUM_0 (VGA_ORIGIN)
#define VGA_NUM_1 ((VGA_ORIGIN)+(0x1))
#define VGA_NUM_2 ((VGA_ORIGIN)+(0x2))
#define VGA_NUM_3 ((VGA_ORIGIN)+(0x3))
#define VGA_NUM_4 ((VGA_ORIGIN)+(0x4))
#define VGA_NUM_5 ((VGA_ORIGIN)+(0x5))
#define VGA_NUM_6 ((VGA_ORIGIN)+(0x6))
#define VGA_NUM_7 ((VGA_ORIGIN)+(0x7))
#define VGA_NUM_8 ((VGA_ORIGIN)+(0x8))
#define VGA_NUM_9 ((VGA_ORIGIN)+(0x9))
#define VGA_NUM_10 ((VGA_ORIGIN)+(0xA))
#define VGA_NUM_11 ((VGA_ORIGIN)+(0xB))
#define VGA_POINT ((VGA_ORIGIN) + (0xC))
#define VGA_SIGN ((VGA_ORIGIN) + (0xD))

#endif // !_VGA_

#define GPIO_E16(addr) (*((volatile uint16_t *)(addr)))
#define GPIO_E8(addr) (*((volatile uint8_t *)(addr)))