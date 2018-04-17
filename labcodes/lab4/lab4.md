# 操作系统 Lab4 实验报告

###### 张钰晖 计算机系计55班 2015011372 yuhui-zh15@mails.tsinghua.edu.cn

## 练习0：填写已有实验

从lab1中复制`kern/debug/kdebug.c`的函数`print_stackframe`和`kern/trap/trap.c`的函数`idt_init`、`trap_dispatch`。

从lab2中复制`kern/mm/default_pmm.c`的函数`default_init_memmap`、`default_alloc_pages`、`default_free_pages`和`kern/mm/pmm.c`的函数`get_pte`、`page_remove_pte`。

从lab3中复制`kern/mm/vmm.c`的函数`do_pgfault`和`kern/mm/swap_fifo.c`的函数`_fifo_map_swappable`、`_fifo_swap_out_victim`。

## 练习1：分配并初始化一个进程控制块

### 设计：

alloc\_proc()函数返回一个进程控制块proc\_struct，用于存储内核线程的管理信息，需要对这个结构完成初始化过程。

进程控制块proc\_struct的定义如下：

```c
struct proc_struct {  
    enum proc_state state; // Process state  
    int pid; // Process ID  
    int runs; // the running times of Proces  
    uintptr_t kstack; // Process kernel stack  
    volatile bool need_resched; // need to be rescheduled to release CPU?  
    struct proc_struct *parent; // the parent process  
    struct mm_struct *mm; // Process's memory management field  
    struct context context; // Switch here to run process  
    struct trapframe *tf; // Trap frame for current interrupt  
    uintptr_t cr3; // the base addr of Page Directroy Table(PDT)  
    uint32_t flags; // Process flag  
    char name[PROC_NAME_LEN + 1]; // Process name  
    list_entry_t list_link; // Process link list  
    list_entry_t hash_link; // Process hash list  
};  
```

alloc\_proc()函数先调用kmalloc()函数获得proc\_struct的一块内存块，然后对其初始化（即把proc\_struct中的各个成员变量清零），有些成员变量设置了特殊的值，例如：

- proc->state = PROC_UNINIT; 设置进程为初始态，表示进程已出生，正在获取资源。
- proc->pid = -1; 设置进程pid的未初始化值，但身份证号还没办好。
- proc->cr3 = boot_cr3; 使用内核页目录表的基址，表示该内核线程在内核中运行。

伪代码如下：

```
分配proc_struct内存块
对各个成员变量清零
对部分成员变量设初值
```

### 实现：

根据设计分析和伪代码，具体实现代码如下：

```c
// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL) {
    /*
     * below fields in proc_struct need to be initialized
     *       enum proc_state state;                      // Process state
     *       int pid;                                    // Process ID
     *       int runs;                                   // the running times of Proces
     *       uintptr_t kstack;                           // Process kernel stack
     *       volatile bool need_resched;                 // bool value: need to be rescheduled to release CPU?
     *       struct proc_struct *parent;                 // the parent process
     *       struct mm_struct *mm;                       // Process's memory management field
     *       struct context context;                     // Switch here to run process
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
        proc->state = PROC_UNINIT;
        proc->pid = -1;
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&proc->context, 0, sizeof(proc->context));
        proc->tf = NULL;
        proc->cr3 = boot_cr3;
        proc->flags = 0;
        memset(proc->name, 0, sizeof(proc->name));
    }
    return proc;
}
```

### 问题：

#### 请说明`proc_struct`中，`struct context context`和`struct trapframe *tf`成员变量含义和在本实验中的作用是啥？（提示通过看代码和编程调试可以判断出来）

##### context的定义如下：

```c
struct context {
    uint32_t eip;
    uint32_t esp;
    uint32_t ebx;
    uint32_t ecx;
    uint32_t edx;
    uint32_t esi;
    uint32_t edi;
    uint32_t ebp;
};
```

context即进程的上下文，也称执行现场。

context成员变量为通用寄存器(esp, ebx, ecx, edx, esi, edi, ebp)和指令地址寄存器(eip)。

context作用为用于进程切换时保存现场。由于所有的进程在ucore内核中相对独立，因此在内核态中进行上下文之间的切换需要由context保存寄存器。切换函数为`kern/process/switch.S`中的`switch_to`函数。

##### trapframe的定义如下：

```c
struct trapframe {
    struct pushregs tf_regs;
    uint16_t tf_gs;
    uint16_t tf_padding0;
    uint16_t tf_fs;
    uint16_t tf_padding1;
    uint16_t tf_es;
    uint16_t tf_padding2;
    uint16_t tf_ds;
    uint16_t tf_padding3;
    uint32_t tf_trapno;
    /* below here defined by x86 hardware */
    uint32_t tf_err;
    uintptr_t tf_eip;
    uint16_t tf_cs;
    uint16_t tf_padding4;
    uint32_t tf_eflags;
    /* below here only when crossing rings, such as from user to kernel */
    uintptr_t tf_esp;
    uint16_t tf_ss;
    uint16_t tf_padding5;
} __attribute__((packed));
```

trapframe即中断帧的指针。

trapframe成员变量为段寄存器(gs, fs, es, ds, cs, ss)，指令地址寄存器(eip)，错误信息(err)，错误标志(eflags)，栈寄存器(esp)和补充字段(padding)。

trapframe的作用是中断帧的指针，总是指向内核栈的某个位置：当进程从用户空间跳到内核空间时，中断帧记录了进程在被中断前的状态。当内核需要跳回用户空间时，需要调整中断帧以恢复让进程继续执行的各寄存器值。除此之外，ucore内核允许嵌套中断。因此为了保证嵌套中断发生时tf总是能够指向当前的tf，ucore 在内核栈上维护了tf的链，可以参考`kern/trap/trap.c`中的`trap`函数。

## 练习2：为新创建的内核线程分配资源

### 设计：

创建线程需要分配和设置资源，alloc_proc()函数只是找到了一小块内存用以记录进程的必要信息，并没有实际分配这些资源，通过do_fork()函数实际创建新的内核线程。

do_fork的作用是，创建当前内核线程的一个副本，它们的执行上下文、代码、数据都一样，但是存储位置不同。在这个过程中，需要给新内核线程分配资源，并且复制原进程的状态。

上述操作真正完成了资源分配的工作，与第一步中的工作有着明显的区别。

伪代码如下：

```
分配并初始化进程控制块（alloc_proc函数）
分配并初始化内核栈（setup_stack函数）
根据clone_flag标志复制或共享进程内存管理结构（copy_mm函数）
设置进程在内核（将来也包括用户态）正常运行和调度所需的中断帧和执行上下文（copy_thread函数）
把设置好的进程控制块放入hash_list和proc_list两个全局进程链表中
自此，进程已经准备好执行了，把进程状态设置为“就绪”态
设置返回码为子进程的id号
```

需要注意的是，如果前三步没有执行成功，需要进行出错处理，把相关已经占有的内存释放掉。

### 实现：

根据设计分析和伪代码，具体实现代码如下：

```c
/* do_fork -     parent process for a new child process
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
    }
    ret = -E_NO_MEM;
    //LAB4:EXERCISE2 2015011372
    /*
     * Some Useful MACROs, Functions and DEFINEs, you can use them in below implementation.
     * MACROs or Functions:
     *   alloc_proc:   create a proc struct and init fields (lab4:exercise1)
     *   setup_kstack: alloc pages with size KSTACKPAGE as process kernel stack
     *   copy_mm:      process "proc" duplicate OR share process "current"'s mm according clone_flags
     *                 if clone_flags & CLONE_VM, then "share" ; else "duplicate"
     *   copy_thread:  setup the trapframe on the  process's kernel stack top and
     *                 setup the kernel entry point and stack of process
     *   hash_proc:    add proc into proc hash_list
     *   get_pid:      alloc a unique pid for process
     *   wakeup_proc:  set proc->state = PROC_RUNNABLE
     * VARIABLES:
     *   proc_list:    the process set's list
     *   nr_process:   the number of process set
     */

    //    1. call alloc_proc to allocate a proc_struct
    //    2. call setup_kstack to allocate a kernel stack for child process
    //    3. call copy_mm to dup OR share mm according clone_flag
    //    4. call copy_thread to setup tf & context in proc_struct
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakeup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid
    if ((proc = alloc_proc()) == NULL) goto fork_out;
    if (setup_kstack(proc) != 0) goto bad_fork_cleanup_proc;
    if (copy_mm(clone_flags, proc) != 0) goto bad_fork_cleanup_kstack;
    copy_thread(proc, stack, tf);
    proc->parent = current;
    bool intr_flag; // [ANSWER]
    local_intr_save(intr_flag); // [ANSWER]
    {
        proc->pid = get_pid();
        hash_proc(proc);
        list_add(&proc_list, &(proc->list_link));
        nr_process++;
    }
    local_intr_restore(intr_flag); // [ANSWER]
    wakeup_proc(proc);
    ret = proc->pid;

fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
```

[ANSWER]的部分摘自于答案，在实现过程中需注意分配PID的过程必须是原子操作，具体的说，在分配PID时，需要设置一个保护锁，暂时不允许中断，保证了ID的唯一性。（事实上，不加锁仍然可以得到满分，但是不安全）

本部分实现正确后执行`make grade`会得到满分。

### 问题：

#### 请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由。

ucore每个新fork的线程都有唯一id，注意代码中`local_intr_save`到`local_intr_restore`函数之间的部分。

为了给每个新fork的线程一个唯一的id，在实现过程中需注意分配PID的过程必须是原子操作，具体的说，在分配PID时，需要设置一个保护锁，即调用`local_intr_save`函数，暂时不允许中断，分配完成后，再调用`local_intr_restore`函数恢复中断，从而保证了ID的唯一性。

## 练习3：阅读代码，理解`proc_run`函数和它调用的函数如何完成进程切换的。

### 分析：

ucore在实验四中实现了一个最简单的FIFO调度器，一共有2个线程，线程切换的调用顺序是schedule()->proc\_run()->switch\_to()函数，依次进行剖析。

县城调度其核心是schedule函数。

##### schedule函数定义如下：

```c
void
schedule(void) {
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
        last = (current == idleproc) ? &proc_list : &(current->list_link);
        le = last;
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
                    break;
                }
            }
        } while (le != last);
        if (next == NULL || next->state != PROC_RUNNABLE) {
            next = idleproc;
        }
        next->runs ++;
        if (next != current) {
            proc_run(next);
        }
    }
    local_intr_restore(intr_flag);
}
```

其主要流程如下：

1．设置当前内核线程current->need_resched为0；
2．在proc_list队列中查找下一个处于“就绪”态的线程或进程next；
3．找到这样的进程后，就调用proc_run函数，保存当前进程current的执行现场（进程上下文），恢复新进程的执行现场，完成进程切换。

##### proc\_run函数定义如下：

```c
void
proc_run(struct proc_struct *proc) {
    if (proc != current) {
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
        local_intr_save(intr_flag);
        {
            current = proc;
            load_esp0(next->kstack + KSTACKSIZE);
            lcr3(next->cr3);
            switch_to(&(prev->context), &(next->context));
        }
        local_intr_restore(intr_flag);
    }
}
```

其主要流程如下：

1. 让current指向next内核线程；
2. 设置任务状态段ts中特权态0下的栈顶指针esp0为next内核线程的内核栈的栈顶，即next->kstack + KSTACKSIZE ；
3. 设置CR3寄存器的值为next内核线程的页目录表起始地址next->cr3，这实际上是完成进程间的页表切换；
4. 由switch_to函数完成具体的两个线程的执行现场切换

##### switch\_to函数定义如下：
```asm
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
    popl 0(%eax)                # save eip !popl
    movl %esp, 4(%eax)          # save esp::context of from
    movl %ebx, 8(%eax)          # save ebx::context of from
    movl %ecx, 12(%eax)         # save ecx::context of from
    movl %edx, 16(%eax)         # save edx::context of from
    movl %esi, 20(%eax)         # save esi::context of from
    movl %edi, 24(%eax)         # save edi::context of from
    movl %ebp, 28(%eax)         # save ebp::context of from

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
                                # eax now points to to
    movl 28(%eax), %ebp         # restore ebp::context of to
    movl 24(%eax), %edi         # restore edi::context of to
    movl 20(%eax), %esi         # restore esi::context of to
    movl 16(%eax), %edx         # restore edx::context of to
    movl 12(%eax), %ecx         # restore ecx::context of to
    movl 8(%eax), %ebx          # restore ebx::context of to
    movl 4(%eax), %esp          # restore esp::context of to

    pushl 0(%eax)               # push eip

    ret

```

其主要流程即切换各个寄存器，保存前一个进程的执行现场，恢复后一个进程的执行现场，当switch_to函数执行完“ret”指令后，就切换到下一个进程执行了。

### 问题：

#### 在本实验的执行过程中，创建且运行了几个内核线程？

在ucore执行完proc\_init函数后，创建好了两个内核线程：idleproc和initproc。

此时ucore当前的执行线程是idleproc，用于进行ucore的初始化工作，直到执行到init函数的最后一个函数cpu\_idle之前，idleproc将通过执行cpu\_idle函数让出CPU，给initproc线程执行。

具体切换过程如上分析所述。

#### 语句`local_intr_save(intr_flag);...local_intr_restore(intr_flag);`在这里有何作用？请说明理由。

可以理解为设置一个保护锁，即先调用`local_intr_save`函数，暂时不允许中断，之后再调用`local_intr_restore`函数，恢复中断，从而保护进程切换不会被中断，以免进程切换时其他进程再进行调度。

## 总结

### 与参考答案区别：

- 练习1：和答案相同


- 练习2：分配PID时，没有加锁确保其唯一性，已经在报告中详细论述


### 重要知识点：

- 线程控制块
- 线程fork
- 线程调度

### 缺失知识点：

- 没有COW(copy on write)拓展实验
- 没有用户线程拓展实验


### 小结：

通过本次试验——内核线程管理，我对内核线程和ucore代码的理解有了质的提高，理解了进程控制块、进程创建、进程调度与切换等多个知识点，对操作系统的认知和热情进一步加深。