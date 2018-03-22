# 操作系统Lec7 HW

###### 张钰晖 计算机系计55班 2015011372 yuhui-zh15@mails.tsinghua.edu.cn

> 时间有限，抄一遍答案复习加深印象，也给期中期末留一些复习资料，麻烦您不用批改了，谢谢！

### 7.1 了解x86保护模式中的特权级

1. X86有几个特权级？

CPU支持4个特权级，通常操作系统只使用了2个。

2. 不同特权级有什么区别？

- 特权指令只能在ring 0使用

- 一条指令在不同特权下能访问的数据范围是不一样的

- 一条指令在不同特权级下的行为是不一样的；

3. 请说明CPL、DPL和RPL在中断响应、函数调用和指令执行时的作用。

访问门时：从低优先级代码访问高优先级服务

访问段时：从高优先级代码访问低优先级数据


4. 写一个示例程序，完成4个特权级间的函数调用和数据访问时特权级控制的作用。

### 7.2 了解特权级切换过程

1. 一条指令在执行时会有哪些可能的特权级判断？
2. 在什么情况下会出现特权级切换？
3. int指令在ring0和ring3的执行行为有什么不同？

- 压栈内容是不同的，多了一个SS:ESP的压栈

- 进行了栈切换

4. 如何利用int和iret指令完成不同特权级的切换？

人工构造需要的栈结构，然后通过int和iret指令进行切换

5. TSS和Task Register的作用是什么？

> [Task state segment](https://en.wikipedia.org/wiki/Task_state_segment)

> Reference: [Intel® 64 and IA-32 Architectures Software Developer Manuals](http://os.cs.tsinghua.edu.cn/oscourse/OS2017spring/lecture04?action=AttachFile&do=view&target=325462-sdm-vol-1-2abcd-3abcd.pdf) Page 2897/4684: 7.2.1 Task-State Segment (TSS)

### 7.3 了解段/页表

1. 一条指令执行时最多会出现多少次地址转换？
2. 描述X86-32的MMU地址转换过程；

### 7.4 了解UCORE建立段/页表

1. 分析MMU的使能过程，尽可能详细地分析在执行进入保护械的代码“movl %eax, %cr0 ; ljmp $CODE_SEL, $0x0”时，CPU的状态和寄存器内容的变化。
2. 分析页表的建立过程；