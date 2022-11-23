# 小组cpu设计Verilog语言命名规范以及多人编程操作手册
## 1.目的
本文档的目的在于在小组多人编程时使用统一又规范的命名标准，使得代码交流更为高效，提高工作效率。
## 2.命名风格
本章主要强调命名风格的统一及规范
### 2.1 大小写的使用
由于vscode对Verilog语言支持度不高，故智能补全有一定缺陷，现建议对所有的变量，文件命名全部为小写英文字母， <font color="#dd0000"> 而模块的命名以大写字母开头作为区分。</font><br />
例如 
```verilog
module Counter();
/*代码实现*/
endmodule
/*调用时*/
Counter counter();
```
### 2.2 常用变量的命名
为了防止功能相同而命名不同造成的理解混乱，我们采用统一的命名规范。
<details>
  <summary>缩写表格(点击箭头展开)</summary>
  
名称 | 常用缩写
------------ | -------------
clock | clk
reset | rst
switch | sw
address |addr
input |i / in(待定)
output | o / out(待定)
enable | ena / en(待定)
synchronic | sync
asynchronic | async
read | rd
write | wr
answer | ans
average | avg
block | blk
buffer | buf
calculate | calc
capture | cap
channel | ch
character | char
chip select | cs
clear | clr
column | col
command | cmd
compare | cmp
control | ctrl
count | cnt
current | cur
data | dat
decode | dec
delay | dly
delete | del
device | dev
different | diff
directory | dir
display | disp
double | dbl
dynamic | dyna
empty | ept
encode | enc
execute | exec
feed back | fb
filter | flt
flag | flg
index | idx
length | len
low | l
number | num
object | obj
operator | opt
parameter | para
pointer | ptr
posedge | pos
record | rcd
register | r
source | src
status | stat
system | sys
value | val
variable | var
version | ver
wire | w

  <pre><code>title，value，callBack可以缺省</code></pre>
</details>

此表不全，摘自 [CSDN](https://blog.csdn.net/heartdreamplus/article/details/86171272)。

### 2.3 命名方法
#### 2.3.1 文件命名

除了顶层模块外，确保每一个文件只含一个module，文件名命名与模块一致。
特别的，有
- 约束文件一个工程中只有一个，统一命名即可。
- 仿真文件在源文件基础上加_tb

例如
> counter.v
> counter_tb.v

#### 2.3.2 模块命名

模块命名以描述功能为主，单词之间用**下划线"_"** 分隔，<font color="#dd0000"> 以大写字母开头。</font><br /> 为了防止混乱，新建模块(即创建新文件后)后请及时上传远程仓库并在群内通知。

- 一般来说命名为"描述"+"核心功能名称"
- 请务必使用标准命名表中的命名。
- 一般来说命名以约定为准。
- IP也算一个模块，但Vivado IP核命名已经非常标准，故一般情况只需改大写即可。
#### 2.3.3 变量命名

变量命名，总的原则与模块命名一致，但有以下注意点。

- 输入输出变量请加后缀i/o/io。
- 非输入输出的线变量请加后缀w。
- 非输入输出寄存器变量请加后缀r。
- 如果输出变量为寄存器变量，建议加o。

#### 2.3.4 常量命名

常量请在模块开头定义，并使用以下方式表示。
```verilog
module  ram
    #(  parameter       AW = 2 ,
        parameter       DW = 3 )
    (
        input                   CLK ,
        input [AW-1:0]          A ,
        input [DW-1:0]          D ,
        input                   EN ,
        input                   WR ,    //1 for write and 0 for read
        output reg [DW-1:0]     Q
     );
     /*在这种定义下，可在仿真中改变常量，提供便利*/
ram #(.AW(4), .DW(4))
    u_ram
    (
        .CLK    (clk),
        .A      (a[AW-1:0]),
        .D      (d),
        .EN     (en),
        .WR     (wr),    //1 for write and 0 for read
        .Q      (q)
     );
```

参见[菜鸟教程](https://www.runoob.com/w3cnote/verilog-defparam.html)

## 3.代码风格
本节主要统一代码风格，便于协调。
### 3.1 编辑器
我们采用Vscode作为编辑器和git管理器，当需要使用vivado时，可自行将文件复制 [^1] 到vivado。

- 请注意，为了防止vivado代码与vscode不一致，请不要在vivado中更改**任何代码。**

下讲述vscode配置，请检查自己是否配置完好。
- Verilog系列插件。除了最高下载量插件外也有很多好用的插件，请看情况选择。
- 请确保你已经下载好git(可在命令行中输入git检查)，并安装好gitlen插件，[git基础攻略](https://www.runoob.com/git/git-tutorial.html)
- 使用一个好的主题可以让写代码更加舒适，请自行搜索。
[^1]:复制不代表在vivado中add source ，因为add source容易存在乱码问题，初步判断为utf_8和vivado使用的编码之间转换问题，而直接ctrl+c ctrl+v没有这个问题。

### 3.2 Verilog模块命名
示例如下
```verilog
module  Ram
    #(  
        parameter       AW = 2 ,
        parameter       DW = 3 
     )
    (
        input                   CLK ,
        input [AW-1:0]          A ,
        input [DW-1:0]          D ,
        input                   EN ,
        input                   WR ,    //1 for write and 0 for read
        output reg [DW-1:0]     Q
     );
Ram #(
        .AW(4),
        .DW(4)
     )
        u_ram/*实例化的名称使用小写，采用功能化描述*/
    (
        .CLK    (clk),
        .A      (a[AW-1:0]),
        .D      (d),
        .EN     (en),
        .WR     (wr),    //1 for write and 0 for read
        .Q      (q)
     );
```
可见有如下要点

- 模块关键字module与常量及变量的括号相差为一个制表符(即tab)
- module与变量名之间有两个空格，这是为了与下方对齐所用，实际上保持对齐即可。
- 请注意，module的名称(Ram)与parameter、input、output对齐，变量名称的第一个字符也要对齐，实例化时也采用此对齐策略。
- 为了对齐，一般是在最长的字符前加tab(vscode默认tab为4个空格)给足4个空格作为基准进行对齐，其余变量如无法tab对齐可手动对齐。
- 模块定义时input、output以及是否为reg均一并给出，与模块的中间变量分离。
### 3.3 中间变量、连续赋值语句、always结构块
具体事例如下。
```verilog
module  Ram
    #(  
        parameter       AW = 2 ,
        parameter       DW = 3 
     )
    (
        input                   CLK ,
        input [AW-1:0]          A ,
        input [DW-1:0]          D ,
        input                   EN ,
        input                   WR ,    //1 for write and 0 for read
        output reg [DW-1:0]     Q
     );
     /*仅为事例*/
        wire            clk_core;
        wire [7:0]      min_o_counter;
        wire [7:0]      sec_o_counter;
        wire [7:0]      ms_10_o_counter;
        wire            left_button_p;
        wire            rigit_button_p;
        wire            up_button_p;
        wire            down_button_p;
        wire            center_button_p;
        wire [7:0]      min_o_rcounter;
        wire [7:0]      sec_o_rcounter;
        wire [7:0]      ms_10_o_rcounter;
        wire            time_out_o_rcounter;
        wire [1:0]      target_o_rcounter;
        reg [7:0]       min_o_sel;
        reg [7:0]       sec_o_sel;
        reg [7:0]       ms_10_o_sel;
        reg [1:0]       target_o_sel;
        reg             time_out_o_sel;
        /*仅为事例*/
        assign          end2 = (v_count == vline_end);
        assign          h_sync = (h_count > hsync_end);
        assign          v_sync = (v_count > vsync_end);
        assign          data_en = (v_count > v_ram_begin) && (v_count <= v_ram_end) && (h_count >= hdat_begin) && (h_count < hdat_end);
        always @(*) begin
        if(!mode_switch) begin
            min_o_sel = min_o_counter;
            sec_o_sel = sec_o_counter;
            ms_10_o_sel = ms_10_o_counter;
            target_o_sel = 2'b11;
            time_out_o_sel = 1'b0;
        end
        else begin
            min_o_sel = min_o_rcounter;
            sec_o_sel = sec_o_rcounter;
            ms_10_o_sel = ms_10_o_rcounter;
            target_o_sel = target_o_rcounter;
            time_out_o_sel = time_out_o_rcounter;
        end
    end
```
- 中间变量一定要在input、output之后
- 中间不要加任何assign以及always语句，且wire和reg型分开。
- 具体顺序可按照产生顺序，命名顺序等，符合逻辑。
- assign紧随中间变量声明之后。
- assign也加入空格并对齐显得美观。
- 在每个双目运算符前后各加一个空格便于查看。
- 对于always块，可以使用插件提供的模板自动补全。
- 对于begin end块 begin加在当前一行(不换行)，且增加一个空格。end独占一行，与产生begin的地方对应(即always和if、else等)
- 对于代码整体结构，以声明，中间变量，连续赋值，always为顺序
- 注释没有太多要求，但对于一个模块，你至少应该在模块声明前写明作者，功能，接口等信息。

## 4. git、github远程仓库使用规范
基本操作连接，[git基础攻略](https://www.runoob.com/git/git-tutorial.html)，我们一般不会使用命令行操作git，但我们有如下原则。
- 每次编辑代码前请先git pull或者git fetch(区别见教程)拉取远程仓库最新的代码，防止你本地仓库与远程仓库不同而造成冲突。
- 我们不提倡在本地对master分支(主分支)的修改，即所以的修改请先在分支进行，并且不要使用merge命令对分支合并然后再push的操作，这样对主分支可能会造出较大影响。
- 正确的做法是当你完成一个分支后提交pull request 这样会提交一个合并主分支的请求到GitHub，由大家判断后再执行合并，gitlen插件提供了一键提交pull request的按钮，请自行寻找。





