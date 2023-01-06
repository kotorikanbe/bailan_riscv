#include "calculator.h"
// Number operator1, operator2, show_operator;
// Operator target = none;
// Mouse mouse;
int main()
{
    Number operator1, operator2, show_operator;
    Operator target = none;
    Mouse mouse;
    operator1.operated_number = 0;
    operator1.point_addr = 0;
    operator2.operated_number = 0;
    operator2.point_addr = 0;
    show_operator.point_addr = 0;
    show_operator.operated_number = 0;
    mouse.click = 0;
    mouse.X = 0;
    mouse.Y = 0;
    while (1)
    {
        mouse_update(&mouse);
        execute_signal(&mouse, &operator1, &operator2, &show_operator,&target);
        VGA_display(&show_operator);
        delay(500); // add delay for I/O devices work
    }
}