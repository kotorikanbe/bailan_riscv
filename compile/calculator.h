#include "GPIO.h"
#include <stdlib.h>
typedef struct fixed_number
{
    int64_t operated_number;
    uint8_t point_addr;
} Number;

typedef struct MOUSE
{
    uint16_t X;
    uint16_t Y;
    uint8_t click;
} Mouse;

typedef enum OPERATOR
{
    zero = 0,
    one,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
    point,
    sign,
    plus,
    minus,
    multiply,
    division,
    C,
    equal,
    none
} Operator;

typedef enum CURR_STATE
{
    clear=0,
    to_be_added_op1,
    to_be_added_op2,
    show
}State;
void execute_signal(Mouse *mouse);

void delay(uint32_t delay_time);

void mouse_update(Mouse *mouse);

void VGA_display(Number *number);
