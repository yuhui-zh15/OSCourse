# 操作系统Lec3 HW

###### 张钰晖 计算机系计55班 2015011372 yuhui-zh15@mails.tsinghua.edu.cn

## 第三讲 启动、中断、异常和系统调用

## 3.1 BIOS
-  BIOS从磁盘读入的第一个扇区是什么内容？为什么没有直接读入操作系统内核映像？


BIOS完成硬件初始化和自检后，会根据CMOS中设置的启动顺序启动相应的设备，这里假定按顺序系统要启动硬盘。但此时，文件系统并没有建立，BIOS也不知道硬盘里存放的是什么，所以BIOS是无法直接启动操作系统。另外一个硬盘可以有多个分区，每个分区都有可能包括一个不同的操作系统，BIOS也无从判断应该从哪个分区启动，所以对待硬盘，所有的BIOS都是读取硬盘的0磁头、0柱面、1扇区的内容，然后把控制权交给这里面的MBR(Main Boot Record）。

MBR由两个部分组成：即主引导记录MBR和硬盘分区表DPT。在总共512字节的主引导分区里其中MBR占446个字节（偏移0--偏移1BDH)，一般是一段引导程序，其主要是用来在系统硬件自检完后引导具有激活标志的分区上的操作系统。DPT占64个字节（偏移1BEH--偏移1FDH),一般可放4个16字节的分区信息表。最后两个字节“55，AA”（偏移1FEH，偏移1FFH)是分区的结束标志。

-  比较UEFI和BIOS的区别。


UEFI，全称Unified Extensible Firmware Interface，即“统一的可扩展固件接口”, 是适用于电脑的标准固件接口，旨在代替BIOS（基本输入/输出系统）。此标准由UEFI联盟中的140多个技术公司共同创建，其中包括微软公司。UEFI旨在提高软件互操作性和解决BIOS的局限性。

UEFI启动对比BIOS启动的优势有三点：

- 安全性更强：UEFI启动需要一个独立的分区，它将系统启动文件和操作系统本身隔离，可以更好的保护系统的启动。
- 启动配置更灵活：EFI启动和GRUB启动类似，在启动的时候可以调用EFIShell，在此可以加载指定硬件驱动，选择启动文件。比如默认启动失败，在EFIShell加载U盘上的启动文件继续启动系统。
- 支持容量更大:传统的BIOS启动由于MBR的限制，默认是无法引导超过2TB以上的硬盘的。随着硬盘价格的不断走低，2TB以上的硬盘会逐渐普及，因此UEFI启动也是今后主流的启动方式。

## 3.2 系统启动流程

- 分区引导扇区的结束标志是什么？

0X55AA

- 在UEFI中的可信启动有什么作用？

通过启动前的数字签名检查来保证启动介质的安全性

## 3.3 中断、异常和系统调用比较
- 什么是中断、异常和系统调用？

1. 中断：外部意外的响应；
2. 异常：指令执行意外的响应；
3. 系统调用：系统调用指令的响应；

- 中断、异常和系统调用的处理流程有什么异同？

1. 源头、响应方式、处理机制
2. 一个网的参考： [http://blog.csdn.net/rainlight/article/details/636089](http://blog.csdn.net/rainlight/article/details/636089%7B%ends%%7D)

- 以ucore lab8的answer为例，uCore的系统调用有哪些？大致的功能分类有哪些？

ucore lab8的answer中共有22个系统调用，大致分为如下几类

1. 进程管理：包括 fork/exit/wait/exec/yield/kill/getpid/sleep
2. 文件操作：包括 open/close/read/write/seek/fstat/fsync/getcwd/getdirentry/dup
3. 内存管理：pgdir命令
4. 外设输出：putc命令

## 3.4 linux系统调用分析
-  通过分析[lab1_ex0](https://github.com/chyyuu/ucore_lab/blob/master/related_info/lab1/lab1-ex0.md)了解Linux应用的系统调用编写和含义。(仅实践，不用回答)


-  通过调试[lab1_ex1](https://github.com/chyyuu/ucore_lab/blob/master/related_info/lab1/lab1-ex1.md)了解Linux应用的系统调用执行过程。(仅实践，不用回答)


## 3.5 ucore系统调用分析 （扩展练习，可选）
-  基于实验八的代码分析ucore的系统调用实现，说明指定系统调用的参数和返回值的传递方式和存放位置信息，以及内核中的系统调用功能实现函数。
-  以ucore lab8的answer为例，分析ucore 应用的系统调用编写和含义。
-  以ucore lab8的answer为例，尝试修改并运行ucore OS kernel代码，使其具有类似Linux应用工具`strace`的功能，即能够显示出应用程序发出的系统调用，从而可以分析ucore应用的系统调用执行过程。


## 3.6 请分析函数调用和系统调用的区别
- 系统调用与函数调用的区别是什么？


1. 指令不同
2. 特权级不同
3. 堆栈切换

- 通过分析`int`、`iret`、`call`和`ret`的指令准确功能和调用代码，比较函数调用与系统调用的堆栈操作有什么不同？


SS:SP压栈