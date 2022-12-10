#include "GPIO.h"
#include <stdint.h>
typedef struct MOUSE
{
    uint32_t X;
    uint32_t Y;
    uint32_t click;
} Mouse;

void delay(uint32_t delay_time)
{
    int delay_count;
    for (delay_count = 0; delay_count < delay_time; ++delay_count)
        ;
    return;
}

void mouse_update(Mouse mouse)
{
    mouse.X = GPIO_E(MOUSE_X);
    mouse.Y = GPIO_E(MOUSE_Y);
    mouse.click = GPIO_E(MOUSE_CLICK);
}


