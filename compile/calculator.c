#include "calculator.h"
// typedef struct fixed_number
// {
//     int64_t operated_number;
//     uint8_t point_addr;
// } Number;

// typedef struct MOUSE
// {
//     uint32_t X;
//     uint32_t Y;
//     uint32_t click;
// } Mouse;

// typedef enum OPERATOR
// {
//     zero = 0,
//     one,
//     two,
//     three,
//     four,
//     five,
//     six,
//     seven,
//     eight,
//     nine,
//     plus,
//     minus,
//     multiply,
//     div
// } Operator;

extern Number operator1, operator2, show_operator;
extern Operator target;
Number Number_plus(Number *op1, Number *op2);
Operator identify(Mouse *mouse);
Number Number_minus(Number *op1, Number *op2);
Number Number_multiply(Number *op1, Number *op2);
Number Number_divide(Number *op1, Number *op2);
uint8_t get_width(int64_t opr);
int64_t power10(uint8_t exp);
void reduct_zero(Number *op);
void execute_signal(Mouse *mouse)
{
    static uint8_t execute_flag = 0;
    static State curr_state = clear;
    static uint8_t point_flag = 0;
    static uint8_t spec_flag = 0;
    if ((mouse->click == 1) && (!execute_flag))
    {
        execute_flag = 1;
        Operator this_op = identify(mouse);
        switch (curr_state)
        {
        case clear:
        {
            switch (this_op)
            {
            case zero:
            {
                ; // do nothing
                break;
            }
            case one:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = 1;
                operator1.point_addr = 0;
                break;
            }
            case two:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = 2;
                operator1.point_addr = 0;
                break;
            }
            case three:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = 3;
                operator1.point_addr = 0;
                break;
            }
            case four:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = 4;
                operator1.point_addr = 0;
                break;
            }
            case five:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = 5;
                operator1.point_addr = 0;
                break;
            }
            case six:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = 6;
                operator1.point_addr = 0;
                break;
            }
            case seven:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = 7;
                operator1.point_addr = 0;
                break;
            }
            case eight:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = 8;
                operator1.point_addr = 0;
                break;
            }
            case nine:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = 9;
                operator1.point_addr = 0;
                break;
            }
            case point:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = 0;
                operator1.point_addr = 0;
                point_flag = 1;
                break;
            }
            case sign:
            {
                // curr_state = to_be_added_op1;
                // sign_flag = 1;
                // operator1.operated_number = 0;
                // operator1.point_addr = 0;
                // do nothing
                break;
            }
            default:
            {
                break;
            }
            }
            break;
        }
        case to_be_added_op1:
        {
            switch (this_op)
            {
            case zero:
            {
                operator1.operated_number = operator1.operated_number * 10 + 0;
                if (point_flag)
                {
                    operator1.point_addr += 1;
                }
                break;
            }
            case one:
            {
                operator1.operated_number = operator1.operated_number * 10 + 1;
                if (point_flag)
                {
                    operator1.point_addr += 1;
                }
                break;
            }
            case two:
            {
                operator1.operated_number = operator1.operated_number * 10 + 2;
                if (point_flag)
                {
                    operator1.point_addr += 1;
                }
                break;
            }
            case three:
            {
                operator1.operated_number = operator1.operated_number * 10 + 3;
                if (point_flag)
                {
                    operator1.point_addr += 1;
                }
                break;
            }
            case four:
            {
                operator1.operated_number = operator1.operated_number * 10 + 4;
                if (point_flag)
                {
                    operator1.point_addr += 1;
                }
                break;
            }
            case five:
            {
                operator1.operated_number = operator1.operated_number * 10 + 5;
                if (point_flag)
                {
                    operator1.point_addr += 1;
                }
                break;
            }
            case six:
            {
                operator1.operated_number = operator1.operated_number * 10 + 6;
                if (point_flag)
                {
                    operator1.point_addr += 1;
                }
                break;
            }
            case seven:
            {
                operator1.operated_number = operator1.operated_number * 10 + 7;
                if (point_flag)
                {
                    operator1.point_addr += 1;
                }
                break;
            }
            case eight:
            {
                operator1.operated_number = operator1.operated_number * 10 + 8;
                if (point_flag)
                {
                    operator1.point_addr += 1;
                }
                break;
            }
            case nine:
            {
                operator1.operated_number = operator1.operated_number * 10 + 9;
                if (point_flag)
                {
                    operator1.point_addr += 1;
                }
                break;
            }
            case point:
            {
                if (!point_flag)
                {
                    point_flag = 1;
                }
                break;
            }
            case sign:
            {
                operator1.operated_number = -operator1.operated_number;
            }
            case plus:
            {
                curr_state = to_be_added_op2;
                target = plus;
                point_flag = 0;
                operator2.operated_number = 0;
                operator2.point_addr = 0;
                spec_flag = 0;
                break;
            }
            case minus:
            {
                curr_state = to_be_added_op2;
                target = minus;
                point_flag = 0;
                operator2.operated_number = 0;
                operator2.point_addr = 0;
                spec_flag = 0;
                break;
            }
            case multiply:
            {
                curr_state = to_be_added_op2;
                target = multiply;
                point_flag = 0;
                operator2.operated_number = 0;
                operator2.point_addr = 0;
                spec_flag = 0;
                break;
            }
            case division:
            {
                curr_state = to_be_added_op2;
                target = division;
                point_flag = 0;
                operator2.operated_number = 0;
                operator2.point_addr = 0;
                spec_flag = 0;
                break;
            }
            case C:
            {
                curr_state = clear;
                target = none;
                operator1.operated_number = 0;
                operator1.point_addr = 0;
                point_flag = 0;
                break;
            }
            default:
            {
                break;
            }
            }
            break;
        }
        case to_be_added_op2:
        {
            switch (this_op)
            {
            case zero:
            {
                if (operator2.operated_number == 0)
                {
                    ;
                }
                else
                {
                    operator2.operated_number = operator2.operated_number * 10 + 0;
                    if (point_flag == 1)
                    {
                        operator2.point_addr += 1;
                    }
                }
                spec_flag = 1;
                break;
            }
            case one:
            {
                operator2.operated_number = operator2.operated_number * 10 + 1;
                if (point_flag == 1)
                {
                    operator2.point_addr += 1;
                }
                spec_flag = 1;
                break;
            }
            case two:
            {
                operator2.operated_number = operator2.operated_number * 10 + 2;
                if (point_flag == 1)
                {
                    operator2.point_addr += 1;
                }
                spec_flag = 0;
                break;
            }
            case three:
            {
                operator2.operated_number = operator2.operated_number * 10 + 3;
                if (point_flag == 1)
                {
                    operator2.point_addr += 1;
                }
                spec_flag = 1;
                break;
            }
            case four:
            {
                operator2.operated_number = operator2.operated_number * 10 + 4;
                if (point_flag == 1)
                {
                    operator2.point_addr += 1;
                }
                spec_flag = 1;
                break;
            }
            case five:
            {
                operator2.operated_number = operator2.operated_number * 10 + 5;
                if (point_flag == 1)
                {
                    operator2.point_addr += 1;
                }
                spec_flag = 1;
                break;
            }
            case six:
            {
                operator2.operated_number = operator2.operated_number * 10 + 6;
                if (point_flag == 1)
                {
                    operator2.point_addr += 1;
                }
                spec_flag = 1;
                break;
            }
            case seven:
            {
                operator2.operated_number = operator2.operated_number * 10 + 7;
                if (point_flag == 1)
                {
                    operator2.point_addr += 1;
                }
                spec_flag = 1;
                break;
            }
            case eight:
            {
                operator2.operated_number = operator2.operated_number * 10 + 8;
                if (point_flag == 1)
                {
                    operator2.point_addr += 1;
                }
                spec_flag = 1;
                break;
            }
            case nine:
            {
                operator2.operated_number = operator2.operated_number * 10 + 9;
                if (point_flag == 1)
                {
                    operator2.point_addr += 1;
                }
                spec_flag = 1;
                break;
            }
            case sign:
            {
                if (operator2.operated_number == 0)
                {
                    ;
                }
                else
                {
                    operator2.operated_number = -operator2.operated_number;
                }
                break;
            }
            case point:
            {
                if (!point_flag)
                {
                    point_flag = 1;
                }
                spec_flag = 1;
                break;
            }
            case plus:
            {
                if (spec_flag != 0)
                {
                    switch (target)
                    {
                    case plus:
                    {
                        operator1 = Number_plus(&operator1, &operator2);
                        break;
                    }
                    case minus:
                    {
                        operator1 = Number_minus(&operator1, &operator2);
                        break;
                    }
                    case multiply:
                    {
                        operator1 = Number_multiply(&operator1, &operator2);
                        break;
                    }
                    case division:
                    {
                        operator1 = Number_divide(&operator1, &operator2);
                        break;
                    }
                    default:
                        break;
                    }
                    point_flag = 0;
                    operator2.operated_number = 0;
                    operator2.point_addr = 0;
                    spec_flag = 0;
                    target = plus;
                }
                else
                {
                    target = plus;
                }
                break;
            }
            case minus:
            {
                if (spec_flag != 0)
                {
                    switch (target)
                    {
                    case plus:
                    {
                        operator1 = Number_plus(&operator1, &operator2);
                        break;
                    }
                    case minus:
                    {
                        operator1 = Number_minus(&operator1, &operator2);
                        break;
                    }
                    case multiply:
                    {
                        operator1 = Number_multiply(&operator1, &operator2);
                        break;
                    }
                    case division:
                    {
                        operator1 = Number_divide(&operator1, &operator2);
                        break;
                    }
                    default:
                        break;
                    }
                    point_flag = 0;
                    operator2.operated_number = 0;
                    operator2.point_addr = 0;
                    spec_flag = 0;
                    target = minus;
                }
                else
                {
                    target = minus;
                }
                break;
            }
            case multiply:
            {
                if (spec_flag != 0)
                {
                    switch (target)
                    {
                    case plus:
                    {
                        operator1 = Number_plus(&operator1, &operator2);
                        break;
                    }
                    case minus:
                    {
                        operator1 = Number_minus(&operator1, &operator2);
                        break;
                    }
                    case multiply:
                    {
                        operator1 = Number_multiply(&operator1, &operator2);
                        break;
                    }
                    case division:
                    {
                        operator1 = Number_divide(&operator1, &operator2);
                        break;
                    }
                    default:
                        break;
                    }
                    point_flag = 0;
                    operator2.operated_number = 0;
                    operator2.point_addr = 0;
                    spec_flag = 0;
                    target = multiply;
                }
                else
                {
                    target = multiply;
                }
                break;
            }
            case division:
            {
                if (spec_flag != 0)
                {
                    switch (target)
                    {
                    case plus:
                    {
                        operator1 = Number_plus(&operator1, &operator2);
                        break;
                    }
                    case minus:
                    {
                        operator1 = Number_minus(&operator1, &operator2);
                        break;
                    }
                    case multiply:
                    {
                        operator1 = Number_multiply(&operator1, &operator2);
                        break;
                    }
                    case division:
                    {
                        operator1 = Number_divide(&operator1, &operator2);
                        break;
                    }
                    default:
                        break;
                    }
                    point_flag = 0;
                    operator2.operated_number = 0;
                    operator2.point_addr = 0;
                    spec_flag = 0;
                    target = division;
                }
                else
                {
                    target = division;
                }
                break;
            }
            case C:
            {
                curr_state = clear;
                target = none;
                operator1.operated_number = 0;
                operator1.point_addr = 0;
                operator2.operated_number = 0;
                operator2.point_addr = 0;
                point_flag = 0;
                break;
            }
            case equal:
            {
                curr_state = show;
                // switch (target)
                // {
                // case plus:
                // {
                //     show_operator=Number_plus(&operator1,&operator2);
                // }
                // default:
                // {
                //     break;
                // }
                // }
                break;
            }
            default:
            {
                break;
            }
            }
            break;
        }
        case show:
        {
            switch (this_op)
            {
            case zero:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = show_operator.operated_number * 10 + 0;
                if (show_operator.point_addr != 0)
                {
                    operator1.point_addr = show_operator.point_addr + 1;
                    point_flag = 1;
                }
                else
                {
                    operator1.point_addr = 0;
                    point_flag = 0;
                }
                break;
            }
            case one:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = show_operator.operated_number * 10 + 1;
                if (show_operator.point_addr != 0)
                {
                    operator1.point_addr = show_operator.point_addr + 1;
                    point_flag = 1;
                }
                else
                {
                    operator1.point_addr = 0;
                    point_flag = 0;
                }
                break;
            }
            case two:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = show_operator.operated_number * 10 + 2;
                if (show_operator.point_addr != 0)
                {
                    operator1.point_addr = show_operator.point_addr + 1;
                    point_flag = 1;
                }
                else
                {
                    operator1.point_addr = 0;
                    point_flag = 0;
                }
                break;
            }
            case three:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = show_operator.operated_number * 10 + 3;
                if (show_operator.point_addr != 0)
                {
                    operator1.point_addr = show_operator.point_addr + 1;
                    point_flag = 1;
                }
                else
                {
                    operator1.point_addr = 0;
                    point_flag = 0;
                }
                break;
            }
            case four:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = show_operator.operated_number * 10 + 4;
                if (show_operator.point_addr != 0)
                {
                    operator1.point_addr = show_operator.point_addr + 1;
                    point_flag = 1;
                }
                else
                {
                    operator1.point_addr = 0;
                    point_flag = 0;
                }
                break;
            }
            case five:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = show_operator.operated_number * 10 + 5;
                if (show_operator.point_addr != 0)
                {
                    operator1.point_addr = show_operator.point_addr + 1;
                    point_flag = 1;
                }
                else
                {
                    operator1.point_addr = 0;
                    point_flag = 0;
                }
                break;
            }
            case six:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = show_operator.operated_number * 10 + 6;
                if (show_operator.point_addr != 0)
                {
                    operator1.point_addr = show_operator.point_addr + 1;
                    point_flag = 1;
                }
                else
                {
                    operator1.point_addr = 0;
                    point_flag = 0;
                }
                break;
            }
            case seven:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = show_operator.operated_number * 10 + 7;
                if (show_operator.point_addr != 0)
                {
                    operator1.point_addr = show_operator.point_addr + 1;
                    point_flag = 1;
                }
                else
                {
                    operator1.point_addr = 0;
                    point_flag = 0;
                }
                break;
            }
            case eight:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = show_operator.operated_number * 10 + 8;
                if (show_operator.point_addr != 0)
                {
                    operator1.point_addr = show_operator.point_addr + 1;
                    point_flag = 1;
                }
                else
                {
                    operator1.point_addr = 0;
                    point_flag = 0;
                }
                break;
            }
            case nine:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = show_operator.operated_number * 10 + 9;
                if (show_operator.point_addr != 0)
                {
                    operator1.point_addr = show_operator.point_addr + 1;
                    point_flag = 1;
                }
                else
                {
                    operator1.point_addr = 0;
                    point_flag = 0;
                }
                break;
            }
            case point:
            {
                if (show_operator.point_addr == 0)
                {
                    curr_state = to_be_added_op1;
                    operator1.operated_number = show_operator.operated_number;
                    operator1.point_addr = 0;
                    point_flag = 1;
                }
                break;
            }
            case sign:
            {
                curr_state = to_be_added_op1;
                operator1.operated_number = -show_operator.operated_number;
                if (show_operator.point_addr != 0)
                {
                    operator1.point_addr = show_operator.point_addr;
                    point_flag = 1;
                }
                else
                {
                    operator1.point_addr = 0;
                    point_flag = 0;
                }
                break;
            }
            case plus:
            {

                curr_state = to_be_added_op2;
                operator1 = show_operator;
                target = plus;
                spec_flag = 0;
                point_flag = 0;
                operator2.point_addr = 0;
                operator2.operated_number = 0;
                break;
            }
            case minus:
            {

                curr_state = to_be_added_op2;
                operator1 = show_operator;
                target = minus;
                spec_flag = 0;
                point_flag = 0;
                operator2.point_addr = 0;
                operator2.operated_number = 0;
                break;
            }
            case multiply:
            {

                curr_state = to_be_added_op2;
                operator1 = show_operator;
                target = multiply;
                spec_flag = 0;
                point_flag = 0;
                operator2.point_addr = 0;
                operator2.operated_number = 0;
                break;
            }
            case division:
            {

                curr_state = to_be_added_op2;
                operator1 = show_operator;
                target = division;
                spec_flag = 0;
                point_flag = 0;
                operator2.point_addr = 0;
                operator2.operated_number = 0;
                break;
            }
            case C:
            {
                curr_state = clear;
                point_flag = 0;
                operator2.point_addr = 0;
                operator2.operated_number = 0;
                target = none;
                operator1.operated_number = 0;
                operator1.point_addr = 0;
                break;
            }
            default:
            {
                break;
            }
            }
            break;
        }
        default:
        {
            break;
        }
        }
    }
    else if ((mouse->click == 1) && (execute_flag))
        ;
    else if (mouse->click == 0)
    {
        execute_flag = 0;
    }
    switch (curr_state)
    {
    case clear:
    {
        show_operator.operated_number = 0;
        show_operator.point_addr = 0;
        break;
    }
    case to_be_added_op1:
    {
        show_operator = operator1;
        break;
    }
    case to_be_added_op2:
    {
        if (spec_flag)
        {
            show_operator = operator2;
        }
        else
        {
            show_operator = operator1;
        }
        break;
    }
    case show:
    {
        switch (target)
        {
        case plus:
        {
            show_operator = Number_plus(&operator1, &operator2);
            break;
        }
        case minus:
        {
            show_operator = Number_minus(&operator1, &operator2);
            break;
        }
        case multiply:
        {
            show_operator = Number_multiply(&operator1, &operator2);
            break;
        }
        case division:
        {
            show_operator = Number_divide(&operator1, &operator2);
            break;
        }
        default:
            break;
        }
        break;
    }
    default:
    {
        break;
    }
    }
}

Operator identify(Mouse *mouse)
{ // 待提供图像具体信息供判断
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
    mouse->X = GPIO_E16(MOUSE_X);
    mouse->Y = GPIO_E16(MOUSE_Y);
    mouse->click = GPIO_E8(MOUSE_CLICK);
    return;
}

void VGA_display(Number *number)
{
    uint8_t flag = 0;
    int64_t tmp;
    if (number->operated_number < 0)
    {
        GPIO_E8(VGA_SIGN) = 1;
        tmp = -number->operated_number;
    }
    else
    {
        GPIO_E8(VGA_SIGN) = 0;
        tmp = number->operated_number;
    }
    GPIO_E8(VGA_POINT) = number->point_addr;
    volatile uint8_t *num_ptr = (uint8_t *)VGA_NUM_0;
    while (tmp != 0)
    {
        GPIO_E8(num_ptr) = tmp % 10;
        tmp = tmp / 10;
        if (num_ptr == (uint8_t *)VGA_NUM_11)
        {
            flag = 1;
            break;
        }
        else
        {
            num_ptr = num_ptr + 1;
        }
    }
    while (num_ptr <= (uint8_t *)VGA_NUM_11)
    {
        if (flag)
        {
            break;
        }
        else
        {
            if ((num_ptr - (uint8_t *)VGA_NUM_0) <= number->point_addr)
            {
                GPIO_E8(num_ptr) = 0;
            }
            else
            {
                GPIO_E8(num_ptr) = 0xff;
            }
            if (num_ptr == (uint8_t *)VGA_NUM_11)
            {
                break;
            }
            else
            {
                num_ptr = num_ptr + 1;
            }
        }
    }
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
        tmp.operated_number = op1->operated_number + op2->operated_number * power10(offset);
        tmp.point_addr = op1->point_addr;
    }
    else
    {
        uint8_t offset = op2->point_addr - op1->point_addr;
        tmp.operated_number = op2->operated_number + op1->operated_number * power10(offset);
        tmp.point_addr = op2->point_addr;
    }
    reduct_zero(&tmp);
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
        tmp.operated_number = op1->operated_number - op2->operated_number * power10(offset);
        tmp.point_addr = op1->point_addr;
    }
    else
    {
        uint8_t offset = op2->point_addr - op1->point_addr;
        tmp.operated_number = op1->operated_number * power10(offset) - op2->operated_number;
        tmp.point_addr = op2->point_addr;
    }
    reduct_zero(&tmp);
    return tmp;
}

Number Number_multiply(Number *op1, Number *op2)
{
    Number tmp;
    tmp.operated_number = op1->operated_number * op2->operated_number;
    tmp.point_addr = op1->point_addr + op2->point_addr;
    reduct_zero(&tmp);
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
            tmp.operated_number = (int64_t)(quotient * power10(12 - width));
            tmp.point_addr = 12 - width;
            reduct_zero(&tmp);
        }
        else
        {
            tmp.operated_number = (int64_t)(quotient / power10(width - 12));
            tmp.point_addr = 0;
        }
    }
    else if (op1->point_addr > op2->point_addr)
    {
        uint8_t offset = op1->point_addr - op2->point_addr;
        uint8_t width = get_width((int64_t)quotient);
        if (width <= 12)
        {
            tmp.operated_number = (int64_t)(quotient * power10(12 - width));
            tmp.point_addr = 12 - width + offset;
            reduct_zero(&tmp);
        }
        else
        {
            tmp.operated_number = (int64_t)(quotient / power10(width - 12));
            tmp.point_addr = 0;
        }
    }
    else
    {
        uint8_t offset = op2->point_addr - op1->point_addr;
        uint8_t width = get_width((int64_t)quotient);
        if (width <= 12)
        {
            tmp.operated_number = (int64_t)(quotient * power10(12 - width));
            tmp.point_addr = 12 - width - offset;
            reduct_zero(&tmp);
        }
        else
        {
            tmp.operated_number = (int64_t)(quotient / power10(width - 12));
            tmp.point_addr = 0;
        }
    }
    return tmp;
}

uint8_t get_width(int64_t opr)
{
    int64_t tmp = opr;
    uint8_t i = 0;
    while (tmp != 0)
    {
        tmp = tmp / 10;
        i++;
    }
    return i;
}

int64_t power10(uint8_t exp)
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
    if (op->point_addr >= 0)
    {
        while ((op->operated_number % 10 == 0) && (op->point_addr != 0))
        {
            op->operated_number = op->operated_number / 10;
            op->point_addr = op->point_addr - 1;
        }
    }
    else
    {
        while (op->point_addr < 0)
        {
            op->operated_number = op->operated_number * 10;
            op->point_addr = op->point_addr + 1;
        }
    }
    return;
}