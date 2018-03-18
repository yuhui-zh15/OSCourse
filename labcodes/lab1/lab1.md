# 操作系统 Lab1 实验报告

###### 张钰晖 计算机系计55班 2015011372 yuhui-zh15@mails.tsinghua.edu.cn

### 练习1：理解通过make生成执行文件的过程

##### [练习1.1] 操作系统镜像文件ucore.img是如何一步一步生成的？

通过`make "V="`命令观察make过程，对整体过程有个宏观的把握，部分注释写在了代码中。

```bash
# 编译生成kernel所需文件
# 其中关键参数含义如下：
# -ggdb  生成可供gdb使用的调试信息。这样才能用qemu+gdb来调试bootloader or ucore。
# -m32  生成适用于32位环境的代码。我们用的模拟硬件是32bit的80386，所以ucore也要是32位的软件。
# -gstabs  生成stabs格式的调试信息。这样要ucore的monitor可以显示出便于开发者阅读的函数调用栈信息
# -nostdinc  不使用标准库。标准库是给应用程序用的，我们是编译ucore内核，OS内核是提供服务的，所以所有的服务要自给自足。
# -fno-stack-protector  不生成用于检测缓冲区溢出的代码。这是for 应用程序的，我们是编译内核，ucore内核好像还用不到此功能。
# -Os  为减小代码大小而进行优化。根据硬件spec，主引导扇区只有512字节，我们写的简单bootloader的最终大小不能大于510字节。
# -I<dir>  添加搜索头文件的路径
+ cc kern/init/init.c
gcc -Ikern/init/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/init/init.c -o obj/kern/init/init.o
kern/init/init.c:95:1: warning: ‘lab1_switch_test’ defined but not used [-Wunused-function]
+ cc kern/libs/readline.c
gcc -Ikern/libs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/readline.c -o obj/kern/libs/readline.o
+ cc kern/libs/stdio.c
gcc -Ikern/libs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/stdio.c -o obj/kern/libs/stdio.o
+ cc kern/debug/kdebug.c
gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/debug/kdebug.c -o obj/kern/debug/kdebug.o
+ cc kern/debug/kmonitor.c
gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/debug/kmonitor.c -o obj/kern/debug/kmonitor.o
+ cc kern/debug/panic.c
gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/debug/panic.c -o obj/kern/debug/panic.o
+ cc kern/driver/clock.c
gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/clock.c -o obj/kern/driver/clock.o
+ cc kern/driver/console.c
gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/console.c -o obj/kern/driver/console.o
+ cc kern/driver/intr.c
gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/intr.c -o obj/kern/driver/intr.o
+ cc kern/driver/picirq.c
gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/picirq.c -o obj/kern/driver/picirq.o
+ cc kern/trap/trap.c
gcc -Ikern/trap/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/trap/trap.c -o obj/kern/trap/trap.o
kern/trap/trap.c:14:13: warning: ‘print_ticks’ defined but not used [-Wunused-function]
kern/trap/trap.c:30:26: warning: ‘idt_pd’ defined but not used [-Wunused-variable]
+ cc kern/trap/trapentry.S
gcc -Ikern/trap/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/trap/trapentry.S -o obj/kern/trap/trapentry.o
+ cc kern/trap/vectors.S
gcc -Ikern/trap/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/trap/vectors.S -o obj/kern/trap/vectors.o
+ cc kern/mm/pmm.c
gcc -Ikern/mm/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/mm/pmm.c -o obj/kern/mm/pmm.o
+ cc libs/printfmt.c
gcc -Ilibs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/  -c libs/printfmt.c -o obj/libs/printfmt.o
+ cc libs/string.c
gcc -Ilibs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/  -c libs/string.c -o obj/libs/string.o

# 链接文件生成kernel
# 其中关键的参数含义如下：
# -m <emulation>  模拟为i386上的连接器
# -nostdlib  不使用标准库
# -N  设置代码段和数据段均可读写
# -e <entry>  指定入口
# -Ttext  制定代码段开始位置
+ ld bin/kernel
ld -m    elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel  obj/kern/init/init.o obj/kern/libs/readline.o obj/kern/libs/stdio.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/debug/panic.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/intr.o obj/kern/driver/picirq.o obj/kern/trap/trap.o obj/kern/trap/trapentry.o obj/kern/trap/vectors.o obj/kern/mm/pmm.o  obj/libs/printfmt.o obj/libs/string.o

# 编译生成bootblock所需文件
# 参数含义同上
+ cc boot/bootasm.S
gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootasm.S -o obj/boot/bootasm.o
+ cc boot/bootmain.c
gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootmain.c -o obj/boot/bootmain.o
+ cc tools/sign.c
gcc -Itools/ -g -Wall -O2 -c tools/sign.c -o obj/sign/tools/sign.o
gcc -g -Wall -O2 obj/sign/tools/sign.o -o bin/sign

# 链接文件生成bootblock
# 参数含义同上
+ ld bin/bootblock
ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
'obj/bootblock.out' size: 492 bytes
build 512 bytes boot sector: 'bin/bootblock' success!

# 初始化磁盘镜像文件
# 其中主要参数含义如下：
# if=代表输入文件
# of=代表输出文件
# count=代表被复制的块数，每个块默认512字节
# seek=k跳过指定的区块数，即从第k+1个块开始写
# conv=notrunc，指定文件转换的方式，不将文件清空
dd if=/dev/zero of=bin/ucore.img count=10000
10000+0 records in
10000+0 records out
5120000 bytes (5.1 MB) copied, 0.0386708 s, 132 MB/s
# 将bootlock中的内容写入第一个块
dd if=bin/bootblock of=bin/ucore.img conv=notrunc
1+0 records in
1+0 records out
512 bytes (512 B) copied, 4.2015e-05 s, 12.2 MB/s
# 将kernel中的内容写入第二个块及其以后
dd if=bin/kernel of=bin/ucore.img seek=1 conv=notrunc
146+1 records in
146+1 records out
74862 bytes (75 kB) copied, 0.000636221 s, 118 MB/s

# 其中有两步信息没有输出：
# 拷贝二进制代码bootblock.o到bootblock.out
objcopy -S -O binary obj/bootblock.o obj/bootblock.out
# 使用sign工具处理bootblock.out，生成bootblock
bin/sign obj/bootblock.out bin/bootblock
```

经过仔细阅读，makefile文件通过大量的嵌套的函数实现了以上make功能，并不如直接输出信息更能清楚地看出ucore.img生成的全过程，故通过对输出进行注释的方法理解ucore.img的生成过程。

##### [练习1.2] 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？

bootblock经过了sign处理，tools/sign.c代码如下：

```c
int main(int argc, char *argv[]) {
    struct stat st;
    if (argc != 3) {
        fprintf(stderr, "Usage: <input filename> <output filename>\n");
        return -1;
    }
    if (stat(argv[1], &st) != 0) {
        fprintf(stderr, "Error opening file '%s': %s\n", argv[1], strerror(errno));
        return -1;
    }
    printf("'%s' size: %lld bytes\n", argv[1], (long long)st.st_size);
    // 检查扇区是否超过了510字节
    if (st.st_size > 510) {
        fprintf(stderr, "%lld >> 510!!\n", (long long)st.st_size);
        return -1;
    }
    char buf[512]; // 主引导扇区大小
    memset(buf, 0, sizeof(buf));
    FILE *ifp = fopen(argv[1], "rb");
    int size = fread(buf, 1, st.st_size, ifp);
    if (size != st.st_size) {
        fprintf(stderr, "read '%s' error, size is %d.\n", argv[1], size);
        return -1;
    }
    fclose(ifp);
    buf[510] = 0x55; // 主引导扇区倒数第二个字节
    buf[511] = 0xAA; // 主引导扇区倒数第一个字节
    FILE *ofp = fopen(argv[2], "wb+");
    size = fwrite(buf, 1, 512, ofp);
    if (size != 512) {
        fprintf(stderr, "write '%s' error, size is %d.\n", argv[2], size);
        return -1;
    }
    fclose(ofp);
    printf("build 512 bytes boot sector: '%s' success!\n", argv[2]);
    return 0;
}
```

可知，主引导扇区大小为512字节，且最后两个字节是0x55AA。

### 练习2：使用qemu执行并调试lab1中的软件

##### [练习2.1] 从CPU加电后执行的第一条指令开始，单步跟踪BIOS的执行。

将tools/gdbinit更改如下：

```
file bin/kernel
target remote :1234
set architecture i8086
```

在lab1根目录下执行`make debug`，待qemu、gdb加载完成，通过指令`si`即可单步跟踪BIOS，通过指令`x /2i $pc`可以查看当前执行的汇编代码。

##### [练习2.2] 在初始化位置0x7c00设置实地址断点，测试断点正常。

将tools/gdbinit更改如下：

```
file bin/kernel
target remote :1234
set architecture i8086
b *0x7c00
c          
x /2i $pc 
set architecture i386 
```

在lab1根目录下执行`make debug`，可看到输出：

```
Breakpoint 2, 0x00007c00 in ?? ()
=> 0x7c00:      cli    
   0x7c01:      cld    
```

断点正常。

##### [练习2.3] 从0x7c00开始跟踪代码运行，将单步跟踪反汇编得到的代码与bootasm.S和bootblock.asm进行比较。

在Makefile debug调用qemu时增加`-d in_asm -D output.log`参数，便可以将运行的汇编指令保存在output.log文件中。

output.log搜索0x7c00结果如下：

```
----------------
IN: 
0x00007c00:  cli    

----------------
IN: 
0x00007c01:  cld    
0x00007c02:  xor    %ax,%ax
0x00007c04:  mov    %ax,%ds
0x00007c06:  mov    %ax,%es
0x00007c08:  mov    %ax,%ss

----------------
IN: 
0x00007c0a:  in     $0x64,%al

----------------
IN: 
0x00007c0c:  test   $0x2,%al
0x00007c0e:  jne    0x7c0a

----------------
IN: 
0x00007c10:  mov    $0xd1,%al
0x00007c12:  out    %al,$0x64
0x00007c14:  in     $0x64,%al
0x00007c16:  test   $0x2,%al
0x00007c18:  jne    0x7c14

----------------
IN: 
0x00007c1a:  mov    $0xdf,%al
0x00007c1c:  out    %al,$0x60
0x00007c1e:  lgdtw  0x7c6c
0x00007c23:  mov    %cr0,%eax
0x00007c26:  or     $0x1,%eax
0x00007c2a:  mov    %eax,%cr0

----------------
IN: 
0x00007c2d:  ljmp   $0x8,$0x7c32

----------------
IN: 
0x00007c32:  mov    $0x10,%ax
0x00007c36:  mov    %eax,%ds

----------------
IN: 
0x00007c38:  mov    %eax,%es

----------------
IN: 
0x00007c3a:  mov    %eax,%fs
0x00007c3c:  mov    %eax,%gs
0x00007c3e:  mov    %eax,%ss

----------------
IN: 
0x00007c40:  mov    $0x0,%ebp

----------------
IN: 
0x00007c45:  mov    $0x7c00,%esp
0x00007c4a:  call   0x7d0d
```
bootasm.s文件主要代码如下：

```assembly
.globl start
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    cld                                             # String operations increment

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment

    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    movl $start, %esp
    call bootmain
```

两者一致。

##### [练习2.4] 自己找一个bootloader或内核中的代码位置，设置断点并进行测试。

将tools/gdbinit更改如下：

```
file bin/kernel
target remote :1234
set architecture i8086
b *0x7c01
c          
x /3i $pc 
set architecture i386 
```
在lab1根目录下执行`make debug`，可看到输出：

```
Breakpoint 1, 0x00007c01 in ?? ()
=> 0x7c01:      cld    
   0x7c02:      xor    %ax,%ax
   0x7c04:      mov    %ax,%ds 
```

断点正常。

#### 练习3：分析bootloader进入保护模式的过程

1 启动预备：关闭中断；将标志寄存器flag的方向标志位DF清零， 在字串操作中使变址寄存器SI或DI的地址指针自动增加，字串处理由前往后。

```asm
    cli                                             # Disable interrupts
    cld                                             # String operations increment
```

2 清理环境：将数据段寄存器（DS、ES、SS）清零。

```asm
    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment
```

3 开启A20：早期Intel CPU地址总线为20位，为了向后兼容，第20位地址总线被固定到0，实模式下无法访问超过1MB的地址空间，保护模式下只能连续访问奇数M地址空间，故需要开始A20。开启A20具体分为四步：等待8042 input buffer为空；向8042控制端口0x64发送0xd1写P2端口命令；等待8042 input buffer为空；向8042数据端口0x60写入0xdf来打开A20。

```asm
    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.

    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1
```

4 初始化GDT表：一个包含三个描述符（空描述符、代码段描述符以及数据段描述符）的简单的GDT表和其描述符已经静态储存在引导区中，载入即可。

```asm
    # using a bootstrap GDT
    lgdt gdtdesc
```

5 进入保护模式：通过将CR0寄存器PE位使能便进入了保护模式。
```asm
	# Switch from real to protected mode
	movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0
```

6 设置CS寄存器：使用ljmp，设置CS寄存器。

```asm
    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg
```

7 设置段寄存器：初始化保护模式下的数据段寄存器DS、ES、FS、GS、SS。

```asm
	# Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment
```

8 设置堆栈：初始化堆栈寄存器EBP、ESP。

```asm
    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    movl $start, %esp

```

9 进入BOOT主过程：

```asm
	call bootmain
```

#### 练习4：分析bootloader加载ELF格式的OS的过程

- waitdisk函数：等待磁盘控制器就绪。

```c
/* waitdisk - wait for disk ready */
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
        /* do nothing */;
}
```

- readsect函数：将第secno的扇区数据读入到dst内。

  > 读取过程如下：
  >
  > 等待磁盘控制器就绪；
  >
  > 设置要读取的扇区个数；
  >
  > 设置读取的LBA参数；
  >
  > 向控制端口写入读取扇区命令；
  >
  > 等待磁盘控制器就绪；
  >
  > 读取一个扇区，读取的实际是双字，故需要除以4。

```c
/* readsect - read a single sector at @secno into @dst */
static void
readsect(void *dst, uint32_t secno) {
    // wait for disk to be ready
    waitdisk();
	
	// 设置要读取的扇区个数
    outb(0x1F2, 1);                         // count = 1
    // 设置读取的LBA参数
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    // 向控制端口写入读取扇区命令
    outb(0x1F7, 0x20);                      // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // read a sector
    // 读取的实际是双字，故需要除以4
    insl(0x1F0, dst, SECTSIZE / 4);
}
```

- readseg函数：从offset地址读取count字节到va。该函数主要使用了上述readsect函数，需要注意的是，由于offset并不一定是扇区大小（512）的倍数，为了对齐实际上可能读取了不止count个字节。

```c
/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;

    // round down to sector boundary
    va -= offset % SECTSIZE;

    // translate from bytes to sectors; kernel starts at sector 1
    // 加1因为0扇区被引导占用，ELF文件从1扇区开始
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
    }
}
```

- bootmain函数：bootloader的主过程，将ELF格式镜像引导至内存。

  > 整体流程如下：
  >
  > 读取ELF头部；
  >
  > 根据ELF头部判断是否是正确的ELF格式；
  >
  > 根据ELF头部确定program header表的地址和program header的个数；
  >
  > 根据program header获得每个program segment应该被加载到内存中的位置、长度以及偏移量，将整个ELF文件中的数据加载入内存；
  >
  > 根据ELF头部跳转到内核入口地址。

```c
/* bootmain - the entry of bootloader */
void
bootmain(void) {
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);

    /* do nothing */
    while (1);
}
```

#### 练习5：实现函数调用堆栈跟踪函数

编写print\_stackframe函数如下，ebp指向的堆栈位置储存着caller的ebp，以此为线索可以得到所有使用堆栈的函数ebp，ebp+4指向caller调用时的eip，ebp+8等是可能的参数。英文注释已经写得非常清楚，按照其实现即可：

```c
void
print_stackframe(void) {
     /* LAB1 2015011372 : STEP 1 */
     /* (1) call read_ebp() to get the value of ebp. the type is (uint32_t);
      * (2) call read_eip() to get the value of eip. the type is (uint32_t);
      * (3) from 0 .. STACKFRAME_DEPTH
      *    (3.1) printf value of ebp, eip
      *    (3.2) (uint32_t)calling arguments [0..4] = the contents in address (unit32_t)ebp +2 [0..4]
      *    (3.3) cprintf("\n");
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
    uint32_t eip = read_eip();
    int i;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++) {
        cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
		uint32_t* args = (uint32_t*)ebp + 2;
		int j;
		cprintf("args:");
		for (j = 0; j < 4; j++) cprintf("0x%08x ", args[j]);
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t*)ebp + 1);
		ebp = *((uint32_t*)ebp);
    }
}
```

在lab1根目录执行`make qemu`后，输出如下：

```
...
ebp:0x00007b28 eip:0x0010098e args:0x00010094 0x00010094 0x00007b58 0x00100094 
    kern/debug/kdebug.c:306: print_stackframe+22
ebp:0x00007b38 eip:0x00100c81 args:0x00000000 0x00000000 0x00000000 0x00007ba8 
    kern/debug/kmonitor.c:125: mon_backtrace+10
ebp:0x00007b58 eip:0x00100094 args:0x00000000 0x00007b80 0xffff0000 0x00007b84 
    kern/init/init.c:48: grade_backtrace2+33
ebp:0x00007b78 eip:0x001000bd args:0x00000000 0xffff0000 0x00007ba4 0x00000029 
    kern/init/init.c:53: grade_backtrace1+38
ebp:0x00007b98 eip:0x001000db args:0x00000000 0x00100000 0xffff0000 0x0000001d 
    kern/init/init.c:58: grade_backtrace0+23
ebp:0x00007bb8 eip:0x00100100 args:0x0010341c 0x00103400 0x00001308 0x00000000 
    kern/init/init.c:63: grade_backtrace+34
ebp:0x00007be8 eip:0x00100057 args:0x00000000 0x00000000 0x00000000 0x00007c4f 
    kern/init/init.c:28: kern_init+86
ebp:0x00007bf8 eip:0x00007d6f args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8 
    <unknow>: -- 0x00007d6e --
...
```

可见，输出与实验指导书基本一致。

最后一行输出对应的是第一个压栈的函数，通过查看bootasm.s，可知第一个压栈的函数是bootmain.c中的bootmain。

- ebp=0x00007bf8 : 调用bootmain前，esp被设置为0x7c00，使用"call bootmain"转入bootmain函数，call指令压入bootmain返回地址与旧ebp，所以bootmain中ebp为0x7bf8。
- eip=0x00007d6f : 为bootmain的返回地址，对应bootblock.asm中的outw(0x8A00, 0x8A00)，查看其地址发现一致。
- args=0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8 : bootmain函数无参数，故输出为调用bootmain之前，栈顶的四个数值，故输出的四个数值位于0x7c00~0x7c0f，与obj/bootblock.asm代码一致。

#### 练习6：完善中断初始化和处理

##### [练习6.1] 中断描述符表（也可简称为保护模式下的中断向量表）中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

中断向量表中一个表项占用8个字节。

- 0-1字节为位移的0-15位
- 6-7字节为位移的16-31位
- 2-3字节为段选择子

段选择子与位移联合便是中断处理程序的入口地址。

##### [练习6.2]请编程完善kern/trap/trap.c中对中断向量表进行初始化的函数idt_init。

编写idt\_init函数如下：

```c
void
idt_init(void) {
     /* LAB1 2015011372 : STEP 2 */
     /* (1) Where are the entry addrs of each Interrupt Service Routine (ISR)?
      *     All ISR's entry addrs are stored in __vectors. where is uintptr_t __vectors[] ?
      *     __vectors[] is in kern/trap/vector.S which is produced by tools/vector.c
      *     (try "make" command in lab1, then you will find vector.S in kern/trap DIR)
      *     You can use  "extern uintptr_t __vectors[];" to define this extern variable which will be used later.
      * (2) Now you should setup the entries of ISR in Interrupt Description Table (IDT).
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i++) {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
    lidt(&idt_pd);
}
```

注释比较详细，根据注释使用宏`SETGATE`设置表项的类型、选择子、位移和DPL等属性。`T_SWITCH_TOK`为用户态调用的软中断，故其DPL设为用户态特权级，之后调用`lidt`即可。

实现后，按下的键会在屏幕显示，证明中断设置成功。

##### [练习6.3] 请编程完善trap.c中的中断处理函数trap。

修改trap\_dispatch函数如下：

```c
static void
trap_dispatch(struct trapframe *tf) {
    ...
    switch (tf->tf_trapno) {
    case IRQ_OFFSET + IRQ_TIMER:
        /* LAB1 2015011372 : STEP 3 */
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
        if (ticks % TICK_NUM == 0) print_ticks();
        break;
    ...
    }
}
```

注释非常详细，本次任务也非常简单。实现后，系统大约每1秒会输出一次“100 ticks”。

