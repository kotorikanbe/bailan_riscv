/*this header is a memory allocator for I/O device,including mouse and VGA*/
#include <stdint.h>
#ifndef _GPIO_

#define _GPIO_

#define GPIO_ORIGIN (0x40000000)

#endif // !_GPIO_
#ifndef _MOUSE_

#define _MOUSE_

#define MOUSE_X ((GPIO_ORIGIN) + (0x4))
#define MOUSE_Y ((GPIO_ORIGIN) + (0x8))
#define MOUSE_CLICK ((GPIO_ORIGIN) + (0xC))

#endif // !_MOUSE_
#ifndef _VGA_

#define _VGA_

#define VGA_NUM ((GPIO_ORIGIN) + (0x10))
#define VGA_POINT ((GPIO_ORIGIN) + (0x18))

#endif // !_VGA_

#define GPIO_E32(addr) (*((volatile uint32_t *)(addr)))
#define GPIO_E64(addr) (*((volatile int64_t *)(addr)))
#define GPIO_E8(addr) (*((volatile int8_t *)(addr)))