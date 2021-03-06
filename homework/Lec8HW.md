# 操作系统Lec8 HW

###### 张钰晖 计算机系计55班 2015011372 yuhui-zh15@mails.tsinghua.edu.cn

> 时间有限，抄一遍答案复习加深印象，也给期中期末留一些复习资料，麻烦您不用批改了，谢谢！

### 8.1 虚拟存储的需求背景

1. 寄存器、高速缓存、内存、外存的访问特征？

   存储器的位置、存储管理否需要软件参与访问、存储的访问频率

2. 如何理解计算机中的存储层次结构所的理想状态是“均衡繁忙”状态？

   均衡繁忙是指，各种存储介质都处理繁忙状态，但又不构成系统瓶颈

3. 在你写程序时遇到过内存不够的情况吗？尝试过什么解决方法？

   如：数组排序、动态链接库

### 8.2 覆盖和交换

1. 什么是覆盖技术？使用覆盖技术的程序开发者的主要工作是什么？

   覆盖：划分程序功能模块、不会同时执行的模块共享同一块内存

   程序员的任务：模块划分、确定模块的共享关系

2. 什么是交换技术？覆盖与交换有什么不同？

   交换：作为一个整体的进程地址空间的换入和换出

   覆盖：通过切块，解决进程空间大于物理内存的问题；交换：通过进程整体交换，解决高优先级进程运行需要的内存空间不够问题；

3. 覆盖和交换技术在现代计算机系统中还有需要吗？可能用在什么地方？

4. 如何分析内核模块间的依赖关系？

5. 如何获取内核模块间的函数调用列表？

   静态代码分析、动态函数调用跟踪

### 8.3 局部性原理

1. 什么是时间局部性、空间局部性和分支局部性？

2. 如何提高程序执行时的局部性特征？

   有意识地规范程序跳转和数据访问

3. 排序算法的局部性特征？

- 参考：[九大排序算法再总结](http://blog.csdn.net/xiazdong/article/details/8462393)

### 8.4 虚拟存储概念

1. 什么是虚拟存储？它与覆盖和交换的区别是什么？它有什么好处和挑战？

   虚拟存储：只把当前指令执行所需要的部分进程地址空间内容放在物理内存中；

   虚拟存储的特征：不连续性、大用户空间、部分交换

2. 虚拟存储需要什么样的支持技术？

   硬件：地址转换

   操作系统：置换算法（换入和换出的区域选择）

### 8.5 虚拟页式存储

1. 什么是虚拟页式存储？缺页中断处理的功能是什么？

2. 为了支持虚拟页式存储的实现，页表项有什么修改？

   驻留位：表示是否在内存

   修改位：表示是否被修改过

   访问位：表示是否被访问过

   保护位：表示允许页面访问方式

3. 页式存储和虚拟页式存储的区别是什么？

### 8.6 缺页异常

1. 缺页异常的处理流程？

   1.指令执行中的页表项引用；

   2.由于页面不在内存，导致缺页异常；

   3.在外存中查找需要访问的页面备份；

   4.页面换入；

   5.页表项修改；

   6.重新执行导致缺页异常的指令； 

2. 虚拟页式存储管理中有效存储访问时间是如何计算的？

   EAT = 访存时间 * (1-p) + 缺页异常处理时间 * 缺页率p