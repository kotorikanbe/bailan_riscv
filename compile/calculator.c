#include "GPIO.h"
#include <stdint.h>
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
    plus,
    minus,
    multiply,
    div
} Operator;

static Mouse mouse;
static Number operator1, operator2, show_operator;
void execute_signal(Mouse *mouse)
{
    static uint8_t execute_flag = 0;
}
void delay(uint32_t delay_time)
{
    int delay_count;
    for (delay_count = 0; delay_count < delay_time; ++delay_count)
        ;
    return;
}

void mouse_update(Mouse *mouse)
{
    mouse->X = GPIO_E32(MOUSE_X);
    mouse->Y = GPIO_E32(MOUSE_Y);
    mouse->click = GPIO_E32(MOUSE_CLICK);
    return;
}

void VGA_display(Number *number)
{
    GPIO_E32(VGA_POINT) = number->point_addr;
    GPIO_E64(VGA_NUM) = number->operated_number;
    return;
}

Number Number_plus(Number *op1, Number *op2)
{
    Number tmp;
    if (op1->point_addr == op2->point_addr)
    {
        tmp.operated_number = op1->operated_number + op2->operated_number;
        tmp.point_addr = op1->point_addr;
    }
    else if (op1->point_addr > op2->point_addr)
    {
        uint8_t offset = op1->point_addr - op2->point_addr;
        tmp.operated_number = op1->operated_number + op2->operated_number * pow10(offset);
        tmp.point_addr = op1->point_addr;
    }
    else
    {
        uint8_t offset = op2->point_addr - op1->point_addr;
        tmp.operated_number = op2->operated_number + op1->operated_number * pow10(offset);
        tmp.point_addr = op2->point_addr;
    }
    return tmp;
}

Number Number_minus(Number *op1, Number *op2)
{
    Number tmp;
    if (op1->point_addr == op2->point_addr)
    {
        tmp.operated_number = op1->operated_number - op2->operated_number;
        tmp.point_addr = op1->point_addr;
    }
    else if (op1->point_addr > op2->point_addr)
    {
        uint8_t offset = op1->point_addr - op2->point_addr;
        tmp.operated_number = op1->operated_number - op2->operated_number * pow10(offset);
        tmp.point_addr = op1->point_addr;
    }
    else
    {
        uint8_t offset = op2->point_addr - op1->point_addr;
        tmp.operated_number = op1->operated_number * pow10(offset) - op2->operated_number;
        tmp.point_addr = op2->point_addr;
    }
    return tmp;
}

Number Number_multiply(Number *op1, Number *op2)
{
    Number tmp;
    tmp.operated_number = op1->operated_number * op2->operated_number;
    tmp.point_addr = op1->point_addr + op2->point_addr;
    return tmp;
}

Number Number_divide(Number *op1, Number *op2)
{
    double dividend = op1->operated_number;
    double divisor = op2->operated_number;
    double quotient = dividend / divisor;
    Number tmp;
    if (op1->point_addr == op2->point_addr)
    {
        uint8_t width = get_width((int64_t)quotient);
        if (width <= 12)
        {
            tmp.operated_number = (int64_t)(quotient * pow10(12 - width));
            tmp.point_addr = 12 - width;
            reduct_zero(&tmp);
        }
        else
        {
            tmp.operated_number = (int64_t)(quotient / pow10(width - 12));
            tmp.point_addr = 0;
        }
    }
    else if (op1->point_addr > op2->point_addr)
    {
        uint8_t offset = op1->point_addr - op2->point_addr;
        uint8_t width = get_width((int64_t)quotient);
        if (width <= 12)
        {
            tmp.operated_number = (int64_t)(quotient * pow10(12 - width));
            tmp.point_addr = 12 - width+offset;
            reduct_zero(&tmp);
        }
        else
        {
            tmp.operated_number = (int64_t)(quotient / pow10(width - 12));
            tmp.point_addr = 0;
        }
    }
    else{
        uint8_t offset = op2->point_addr - op1->point_addr;
        uint8_t width = get_width((int64_t)quotient);
        if (width <= 12)
        {
            tmp.operated_number = (int64_t)(quotient * pow10(12 - width));
            tmp.point_addr = 12 - width-offset;
            reduct_zero(&tmp);
        }
        else
        {
            tmp.operated_number = (int64_t)(quotient / pow10(width - 12));
            tmp.point_addr = 0;
        }
    }
    return tmp;
}

uint8_t get_width(int64_t *opr)
{
    int64_t tmp = *opr;
    uint8_t i = 0;
    while (tmp != 0)
    {
        tmp = tmp / 10;
        i++;
    }
    return i;
}

int64_t pow10(uint8_t exp)
{

    uint8_t i;
    int64_t ans = 1;
    for (i = 0; i < exp; ++i)
    {
        ans = ans * 10;
    }
    return ans;
}

void reduct_zero(Number *op)
{
    while ((op->operated_number % 10 == 0) && (op->point_addr != 0))
    {
        op->operated_number = op->operated_number / 10;
        op->point_addr = op->point_addr - 1;
    }
    return;
}