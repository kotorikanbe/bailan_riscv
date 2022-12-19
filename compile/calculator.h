#include "GPIO.h"
#include <stdlib.h>
typedef struct fixed_number
{
    int64_t operated_number;
    uint8_t point_addr;
} Number;

typedef struct MOUSE
{
    uint32_t X;
    uint32_t Y;
    uint32_t click;
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
    div,
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

