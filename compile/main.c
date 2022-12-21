#include "calculator.h"
Number operator1,operator2,show_operator;
Operator target=none;
Mouse mouse;
int main(){
    while(1){
        mouse_update(&mouse);
        execute_signal(&mouse);
        VGA_display(&show_operator);
        delay(500);//add delay for I/O devices work
    }
}