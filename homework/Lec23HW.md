# 操作系统Lec23 HW

###### 张钰晖 计算机系计55班 2015011372 yuhui-zh15@mails.tsinghua.edu.cn

### 23.1 IO特点

1. 字符设备的特点是什么？

> 以字节为单位顺序访问

2. 块设备的特点是什么？

> 以均匀的数据块为单位随机访问

3. 网络设备的特点是什么？

> 以格式化报文为单位的复杂交互访问

4. 阻塞I/O、非阻塞I/O和异步I/O这三种I/O方式有什么区别？

> 阻塞I/O：数据读写操作后，进程将进入等待状态，直到完成操作时返回；

> 非阻塞I/O：数据读写操作后，进程将立即返回；

> 异步I/O：数据读写操作后，进程将立即返回；内核在完成操作时通知进程；

> 区别：进程发出操作命令后，进程是否等待；操作结果反馈方式；

### 23.2 I/O结构

1. 请描述I/O请求到完成的整个执行过程。

> CPU通过总线与设备相连；CPU通过主动的I/O端口和映射内存读写操作与设备进行信息交互；设备通过中断请求来响应CPU的操作；在CPU的控制下，DMA可直接在设备接口与内存间的数据传输。

> 进程通过系统调用发送对设备的抽象操作命令；内核把抽象的设备操作命令转换成具体的设备I/O端口和映射内存读写序列，并在设备驱动中实施读写操作；当这个读写序列较长时，CPU会控制DMA进行内存与设备接口的直接数据传送；设备在收到控制序列后，执行操作动作，并在完成时向CPU发出中断请求；CPU通过中断服务例程响应设备的中断请求，并进行后续处理，直到系统调用返回，从而完成整个I/O操作过程。

### 23.3 IO数据传输

1. IO数据传输有哪几种？

> 程序控制I/O：CPU通过显式的IO指令，如x86的in, out；或者memory读写方式，即把device的寄存器，内存等映射到物理内存中；

> 直接内存访问DMA：在CPU的控制下，DMA控制器直接在内存与设备接口间传输数据；

2. 轮询方式的特点是什么？

> CPU定期检测设备状态

> 实现简单

> 持续占用CPU

3. 中断方式的特点是什么？

> 设备执行操作命令时，CPU可执行其他任务；

> 处理不可预测事件效果好

> 频繁的中断响应开销比较大

4. DMA方式的特点是什么？

> 直接在内存与设备接口间进行数据传输

> 合适高速和简单的数据传输

> CPU的开销小

### 23.4 磁盘调度

1. 请简要阐述磁盘的工作过程。

> 磁头移动、盘片旋转

2. 请描述磁盘I/O操作时间组成。

> 等待设备可用时间

> 等待通道可用时间

> 寻道时间

> 旋转延时

> 数据传送时间

3. 请说明磁盘调度算法的评价指标。

> 总的I/O时间开销、公平性

4. 请描述FIFO、SSTF、SCAN、CSCAN、LOOK、C-LOOK、N-step-SCAN和FSCAN等磁盘调度算法的工作原理。

> 磁盘调度算法就是优化磁盘数据块的访问顺序；

> 先进先出(FIFO)磁盘调度算法：按请求顺序访问

> 最短寻道时间优先(SSTF)磁盘调度算法：从当前位置找当前最近的访问数据块位置

> 扫描(SCAN)磁盘调度算法：保持磁头移动方向到最远处，并顺序访问需要访问的数据块

> 循环扫描(C-SCAN)磁盘调度算法：只在一个方向上移动时访问数据的SCAN算法；

> LOOK磁盘调度算法：保持磁头移动方向到已有的最后一个请求，并顺序访问需要访问的数据块

> C-LOOK磁盘调度算法：只在一个方向上移动时访问数据的LOOK算法；

> N步扫描(N-step-SCAN)磁盘调度算法：1）将磁盘请求队列分成长度为N的子队列；2）按FIFO算法依次处理所有子队列；3）按扫描算法处理每个队列

> 双队列扫描(FSCAN)磁盘调度算法：1）把磁盘I/O请求分成两个队列，交替使用扫描算法处理一个队列；2）新生成的磁盘I/O请求放入另一队列中

### 23.5 磁盘缓存

1. 磁盘缓存的作用是什么？

> 磁盘扇区在内存中的缓存区，作用是通过缓存访问，减少磁盘访问；

2. 请描述单缓存(Single Buffer Cache)的工作原理

> 只一个缓存区，用户进程和I/O设备只能交替访问缓存区；

3. 请描述双缓存(Double Buffer Cache)的工作原理

> 设置两个缓存区，任何时刻用户进程和I/O设备可同时访问不同的缓存区；

4. 请描述访问频率置换算法(Frequency-based Replacement)的基本原理

> 思路：短周期内采用LRU，长周期内采用LFU

> 做法：把栈分成三个区域：新区域、中间区域、旧区域

> 新区域中数据块的引用，不计数；

> 中间区域和旧区域中数据块的引用，引用计数加1；

> 淘汰只在旧区域中找引用计数最小的数据块

