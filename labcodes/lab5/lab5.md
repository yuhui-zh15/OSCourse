# 操作系统 Lab5 实验报告

###### 张钰晖 计算机系计55班 2015011372 yuhui-zh15@mails.tsinghua.edu.cn

## 练习0.0：填写已有实验

从lab1中复制`kern/debug/kdebug.c`的函数`print_stackframe`和`kern/trap/trap.c`的函数`idt_init`、`trap_dispatch`。

从lab2中复制`kern/mm/default_pmm.c`的函数`default_init_memmap`、`default_alloc_pages`、`default_free_pages`和`kern/mm/pmm.c`的函数`get_pte`、`page_remove_pte`。

从lab3中复制`kern/mm/vmm.c`的函数`do_pgfault`和`kern/mm/swap_fifo.c`的函数`_fifo_map_swappable`、`_fifo_swap_out_victim`。

从lab4中复制`kern/process/proc.c`的函数`alloc_proc`、`do_fork`。

## 练习0.1：修改已有实验

为了正确执行lab5的测试应用程序，需要对已完成的实验1/2/3/4的代码进一步改进。

### `kern/trap/trap.c`中的函数`idt_init`

##### 设计：Lab5中，为了能够使得用户态的程序通过syscall完成系统调用，获得ucore提供的服务，需要设置syscall中断门。

##### 修改：

```c
void idt_init(void) {
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i++) {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER); // [LAB5] let user app to use syscall to get the service of ucore so you should setup the syscall interrupt gate in here
    lidt(&idt_pd);
}
```

### `kern/trap/trap.c`中的函数`trap_dispatch`

##### 设计：Lab5中，每一个TICK\_NUM周期，应该设置当前进程需要重新调度，以完成进程调度机制。同时应去掉print\_ticks函数，因为该函数最后会panic，影响最后评分。

##### 修改：

```c
static void trap_dispatch(struct trapframe *tf) {
	...
	case IRQ_OFFSET + IRQ_TIMER:
        ticks++;
        if (ticks % TICK_NUM == 0) {
            // print_ticks(); [PIAZZA]
            assert(current != NULL); // [LAB5]
            current->need_resched = 1; // [LAB5] Every TICK_NUM cycle, you should set current process's current->need_resched = 1
        }
        break;
	...
}
```

### `kern/process/proc.c`中的函数`alloc_proc`

##### 设计：Lab5中，proc\_struct新增了记录等待状态的字段wait\_state和记录进程关系的字段cptr、yptr、optr，需要对其初始化。

##### 修改：

```c
static struct proc_struct *alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL) {
		...
     	// [LAB5] wait state field need to be initialized
        proc->wait_state = 0;
        // [LAB5] relations between processes field need to be initialized
        proc->cptr = NULL;
        proc->yptr = NULL;
        proc->optr = NULL;
    }
    return proc;
}
```

### `kern/process/proc.c`中的函数`do_fork`

##### 设计：Lab5中，需要设置fork出的子进程parent字段指向当前进程，确保当前进程的wait\_state字段为0，同时将fork出的子进程插入哈希表和链表，设置子进程和其他进程的关系。

##### 修改：

```c
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    ...
    if ((proc = alloc_proc()) == NULL) goto fork_out;
    proc->parent = current; // [LAB5] set child proc's parent to current process
    assert(current->wait_state == 0); // [LAB5] make sure current process's wait_state is 0
    if (setup_kstack(proc) != 0) goto bad_fork_cleanup_proc;
    if (copy_mm(clone_flags, proc) != 0) goto bad_fork_cleanup_kstack;
    copy_thread(proc, stack, tf);
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        proc->pid = get_pid();
        hash_proc(proc);
        set_links(proc); // [LAB5] insert proc_struct into hash_list && proc_list, set the relation links of process
    }
    local_intr_restore(intr_flag);
    wakeup_proc(proc);
    ret = proc->pid;
	...
}
```

至此，通过对以上函数的完善与修改，使其与Lab5的实验框架进行了对接，从而可以正确执行Lab5的测试应用程序。

## 练习1：加载应用程序并执行

### 设计：

本实验中第一个用户进程是由第二个内核线程initproc通过把hello应用程序执行码覆盖到initproc的用户虚拟内存空间来创建的。

initproc的执行主体是init_main函数，这个函数在缺省情况下是执行宏KERNEL_EXECVE(hello)，而这个宏最终是调用kernel_execve函数来调用SYS_exec系统调用。

ucore收到SYS\_exec系统调用后，将依次调用如下函数：

```
vector128(vectors.S)-->__alltraps(trapentry.S)-->trap(trap.c)-->trap_dispatch(trap.c)-->syscall(syscall.c)-->sys_exec（syscall.c-->do_execve(proc.c)
```

最终通过do\_execve函数来完成用户进程的创建工作。

do\_execve函数首先为加载新的执行码做好用户态内存空间清空准备。接下来的一步是加载应用程序执行码到当前进程的新创建的用户态虚拟空间中。

这里涉及到读ELF格式的文件，申请内存空间，建立用户态虚存空间，加载应用程序执行码等。load_icode函数完成了整个复杂的工作。

load\_icode函数执行流程如下：

1. 调用mm_create函数来申请进程的内存管理数据结构mm所需内存空间，并对mm进行初始化；
2. 调用setup_pgdir来申请一个页目录表所需的一个页大小的内存空间，并把描述ucore内核虚空间映射的内核页表（boot_pgdir所指）的内容拷贝到此新目录表中，最后让mm->pgdir指向此页目录表，这就是进程新的页目录表了，且能够正确映射内核虚空间；
3. 根据应用程序执行码的起始位置来解析此ELF格式的执行程序，并调用mm_map函数根据ELF格式的执行程序说明的各个段（代码段、数据段、BSS段等）的起始位置和大小建立对应的vma结构，并把vma插入到mm结构中，从而表明了用户进程的合法用户态虚拟地址空间；
4. 调用根据执行程序各个段的大小分配物理内存空间，并根据执行程序各个段的起始位置确定虚拟地址，并在页表中建立好物理地址和虚拟地址的映射关系，然后把执行程序各个段的内容拷贝到相应的内核虚拟地址中，至此应用程序执行码和数据已经根据编译时设定地址放置到虚拟内存中了；
5. 需要给用户进程设置用户栈，为此调用mm_mmap函数建立用户栈的vma结构，明确用户栈的位置在用户虚空间的顶端，大小为256个页，即1MB，并分配一定数量的物理内存且建立好栈的虚地址\<—\>物理地址映射关系；
6. 至此,进程内的内存管理vma和mm数据结构已经建立完成，于是把mm->pgdir赋值到cr3寄存器中，即更新了用户进程的虚拟内存空间，此时的initproc已经被hello的代码和数据覆盖，成为了第一个用户进程，但此时这个用户进程的执行现场还没建立好；
7. 先清空进程的中断帧，再重新设置进程的中断帧，使得在执行中断返回指令“iret”后，能够让CPU转到用户态特权级，并回到用户态内存空间，使用用户态的代码段、数据段和堆栈，且能够跳转到用户进程的第一条指令执行，并确保在用户态能够响应中断；

至此，用户进程的用户环境已经搭建完毕。此时initproc将按产生系统调用的函数调用路径原路返回，执行中断返回指令“iret”（位于trapentry.S的最后一句）后，将切换到用户进程hello的第一条语句位置_start处（位于user/libs/initcode.S的第三句）开始执行。

本实验要做的，便是设置proc_struct结构中的成员变量trapframe中的内容，确保在执行此进程后，能够从内核态跳转到用户态，从应用程序设定的起始执行地址开始执行。

伪代码如下：

```
正确设置trapframe的内容: 
1.设置cs代码段为USER_CS(用户代码段) 
2.设置ds、es和ss数据段为USER_DS(用户数据段)
3.设置esp为USTACKTOP(用户栈栈顶)
4.设置eip为elf->e_entry(用户程序的入口地址) 
5.设置eflags为FL_IF，允许中断
```

结合虚拟内存布局图可以很好的理解设置内容：

```c
/* *
 * Virtual memory map:                                          Permissions
 *                                                              kernel/user
 *
 *     4G ------------------> +---------------------------------+
 *                            |                                 |
 *                            |         Empty Memory (*)        |
 *                            |                                 |
 *                            +---------------------------------+ 0xFB000000
 *                            |   Cur. Page Table (Kern, RW)    | RW/-- PTSIZE
 *     VPT -----------------> +---------------------------------+ 0xFAC00000
 *                            |        Invalid Memory (*)       | --/--
 *     KERNTOP -------------> +---------------------------------+ 0xF8000000
 *                            |                                 |
 *                            |    Remapped Physical Memory     | RW/-- KMEMSIZE
 *                            |                                 |
 *     KERNBASE ------------> +---------------------------------+ 0xC0000000
 *                            |        Invalid Memory (*)       | --/--
 *     USERTOP -------------> +---------------------------------+ 0xB0000000
 *                            |           User stack            |
 *                            +---------------------------------+
 *                            |                                 |
 *                            :                                 :
 *                            |         ~~~~~~~~~~~~~~~~        |
 *                            :                                 :
 *                            |                                 |
 *                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *                            |       User Program & Heap       |
 *     UTEXT ---------------> +---------------------------------+ 0x00800000
 *                            |        Invalid Memory (*)       | --/--
 *                            |  - - - - - - - - - - - - - - -  |
 *                            |    User STAB Data (optional)    |
 *     USERBASE, USTAB------> +---------------------------------+ 0x00200000
 *                            |        Invalid Memory (*)       | --/--
 *     0 -------------------> +---------------------------------+ 0x00000000
 * (*) Note: The kernel ensures that "Invalid Memory" is *never* mapped.
 *     "Empty Memory" is normally unmapped, but user programs may map pages
 *     there if desired.
 *
 * */
```

### 实现：

根据设计分析和伪代码，具体实现代码如下：

```c
/* load_icode - load the content of binary program(ELF format) as the new content of current process
 * @binary:  the memory addr of the content of binary program
 * @size:  the size of the content of binary program
 */
static int
load_icode(unsigned char *binary, size_t size) {
    if (current->mm != NULL) {
        panic("load_icode: current->mm must be empty.\n");
    }

    int ret = -E_NO_MEM;
    struct mm_struct *mm;
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if (setup_pgdir(mm) != 0) {
        goto bad_pgdir_cleanup_mm;
    }
    //(3) copy TEXT/DATA section, build BSS parts in binary to memory space of process
    struct Page *page;
    //(3.1) get the file header of the bianry program (ELF format)
    struct elfhdr *elf = (struct elfhdr *)binary;
    //(3.2) get the entry of the program section headers of the bianry program (ELF format)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
    //(3.3) This program is valid?
    if (elf->e_magic != ELF_MAGIC) {
        ret = -E_INVAL_ELF;
        goto bad_elf_cleanup_pgdir;
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
    for (; ph < ph_end; ph ++) {
    //(3.4) find every program section headers
        if (ph->p_type != ELF_PT_LOAD) {
            continue ;
        }
        if (ph->p_filesz > ph->p_memsz) {
            ret = -E_INVAL_ELF;
            goto bad_cleanup_mmap;
        }
        if (ph->p_filesz == 0) {
            continue ;
        }
    //(3.5) call mm_map fun to setup the new vma ( ph->p_va, ph->p_memsz)
        vm_flags = 0, perm = PTE_U;
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
        if (vm_flags & VM_WRITE) perm |= PTE_W;
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
            goto bad_cleanup_mmap;
        }
        unsigned char *from = binary + ph->p_offset;
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);

        ret = -E_NO_MEM;

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la) {
                size -= la - end;
            }
            memcpy(page2kva(page) + off, from, size);
            start += size, from += size;
        }

      //(3.6.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
        if (start < la) {
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
                continue ;
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
            if (end < la) {
                size -= la - end;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la) {
                size -= la - end;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }
    //(4) build user stack memory
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
        goto bad_cleanup_mmap;
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
    
    //(5) set current process's mm, sr3, and set CR3 reg = physical addr of Page Directory
    mm_count_inc(mm);
    current->mm = mm;
    current->cr3 = PADDR(mm->pgdir);
    lcr3(PADDR(mm->pgdir));

    //(6) setup trapframe for user environment
    struct trapframe *tf = current->tf;
    memset(tf, 0, sizeof(struct trapframe));
    /* LAB5:EXERCISE1 2015011372
     * should set tf_cs,tf_ds,tf_es,tf_ss,tf_esp,tf_eip,tf_eflags
     * NOTICE: If we set trapframe correctly, then the user level process can return to USER MODE from kernel. So
     *          tf_cs should be USER_CS segment (see memlayout.h)
     *          tf_ds=tf_es=tf_ss should be USER_DS segment
     *          tf_esp should be the top addr of user stack (USTACKTOP)
     *          tf_eip should be the entry point of this binary program (elf->e_entry)
     *          tf_eflags should be set to enable computer to produce Interrupt
     */
    tf->tf_cs = USER_CS;
    tf->tf_ds = USER_DS;
    tf->tf_es = USER_DS;
    tf->tf_ss = USER_DS;
    tf->tf_esp = USTACKTOP;
    tf->tf_eip = elf->e_entry;
    tf->tf_eflags = FL_IF; // [ANSWER] |= -> =
    ret = 0;
out:
    return ret;
bad_cleanup_mmap:
    exit_mmap(mm);
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    goto out;
}
```

### 问题：

#### 请描述当创建一个用户态进程并加载了应用程序后，CPU是如何让这个应用程序最终在用户态执行起来的。即这个用户态进程被ucore选择占用CPU执行(RUNNING态)到具体执行应用程序第一条指令的整个经过。

创建一个用户进程之后，通过`load_icode`函数进行用户进程环境的搭建，具体是设置用户堆栈，建立虚实地址映射关系，建立页表等。通过在该函数中改写trapframe，能够让CPU转到用户特权级，回到用户态的内存空间，跳转到用户进程进行执行，并且确保用户态可以进行中断响应。

在`load_icode`函数执行后，`initproc`函数将按产生系统调用的函数调用路径返回，通过中断执行iret，将根据tf_eip的值切换到用户进程的第一条指令。


## 练习2：父进程复制自己的内存空间给子进程

### 设计：

创建子进程的函数do_fork在执行中将拷贝当前进程（即父进程）的用户内存地址空间中的合法内容到新进程中（子进程），完成内存资源的复制。该拷贝过程是通过copy_range函数（位于kern/mm/pmm.c中），通过循环实现的。具体调用过程是copy_mm-->dup_mmap—>copy_range。

本实验需要补全从page拷贝至npage，并建立映射的过程。

伪代码如下：

```
1. 使用page2kva查询源内核虚地址
2. 使用page2kva查询目标内核虚地址
3. 通过memcpy将内容由源拷贝至目标，大小为PGSIZE
4. 通过page_insert建立物理页与虚拟页的映射
```


### 实现：

根据设计分析和伪代码，具体实现代码如下：

```c
/* copy_range - copy content of memory (start, end) of one process A to another process B
 * @to:    the addr of process B's Page Directory
 * @from:  the addr of process A's Page Directory
 * @share: flags to indicate to dup OR share. We just use dup method, so it didn't be used.
 *
 * CALL GRAPH: copy_mm-->dup_mmap-->copy_range
 */
int
copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end, bool share) {
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
    assert(USER_ACCESS(start, end));
    // copy content by page unit.
    do {
        //call get_pte to find process A's pte according to the addr start
        pte_t *ptep = get_pte(from, start, 0), *nptep;
        if (ptep == NULL) {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
            continue ;
        }
        //call get_pte to find process B's pte according to the addr start. If pte is NULL, just alloc a PT
        if (*ptep & PTE_P) {
            if ((nptep = get_pte(to, start, 1)) == NULL) {
                return -E_NO_MEM;
            }
        uint32_t perm = (*ptep & PTE_USER);
        //get page from ptep
        struct Page *page = pte2page(*ptep);
        // alloc a page for process B
        struct Page *npage=alloc_page();
        assert(page!=NULL);
        assert(npage!=NULL);
        int ret=0;
        /* LAB5:EXERCISE2 2015011372
         * replicate content of page to npage, build the map of phy addr of nage with the linear addr start
         *
         * Some Useful MACROs and DEFINEs, you can use them in below implementation.
         * MACROs or Functions:
         *    page2kva(struct Page *page): return the kernel vritual addr of memory which page managed (SEE pmm.h)
         *    page_insert: build the map of phy addr of an Page with the linear addr la
         *    memcpy: typical memory copy function
         *
         * (1) find src_kvaddr: the kernel virtual address of page
         * (2) find dst_kvaddr: the kernel virtual address of npage
         * (3) memory copy from src_kvaddr to dst_kvaddr, size is PGSIZE
         * (4) build the map of phy addr of  nage with the linear addr start
         */
        void* src_kvaddr = page2kva(page);
        void* dst_kvaddr = page2kva(npage);
        memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
        page_insert(to, npage, start, perm);
        assert(ret == 0);
        }
        start += PGSIZE;
    } while (start != 0 && start < end);
    return 0;
}
```

本部分实现正确后执行`make grade`会得到满分。

### 问题：

#### 请简要说明如何设计实现“Copy on Write”机制，给出概要设计，鼓励给出详细设计。

> Copy-on-write（简称COW）的基本概念是指如果有多个使用者对一个资源A（比如内存块）进行读操作，则每个使用者只需获得一个指向同一个资源A的指针，就可以该资源了。若某使用者需要对这个资源A进行写操作，系统会对该资源进行拷贝操作，从而使得该“写操作”使用者获得一个该资源A的“私有”拷贝—资源B，可对资源B进行写操作。该“写操作”使用者对资源B的改变对于其他的使用者而言是不可见的，因为其他使用者看到的还是资源A。

大致思路是共享父进程的内存空间，当一个用户父进程创建自己的子进程时，父进程把其申请的用户空间权限设置为只读，子进程共享父进程占用的用户内存空间中的页面，从而免除重新拷贝。通过设置权限，读操作正常执行，当要执行写操作，其中任何一个进程修改此用户内存空间中的某页面时，ucore会通过pagefault异常获知该操作，并完成拷贝内存页面，使得两个进程都有各自的内存页面。这样一个进程所做的修改不会被另外一个进程可见了。

即在copy_range时，并不进行复制，只是让`pde_t *to`赋值为`pde_t *from`，并将该页的COPY_ON_WRITE位置1（只读），在需要写时会产生缺页错误，此时才将内存中的内容进行复制。


## 练习3：阅读分析源代码，理解进程执行fork/exec/wait/exit的实现，以及系统调用的实现

### 分析：

#### fork的实现

调用栈：fork->sys\_fork->do\_fork->wakeup\_proc

分析：当程序执行fork时，fork使用了系统调用sys_fork，而系统调用sys_fork则主要是由do_fork和wakeup_proc函数来完成的。

#### exec的实现

调用栈：exec->sys\_exec->do\_execve

分析：当程序执行时，会调用sys_exec系统调用，当系统收到此系统调用，则会使用do_execve函数来实现。

#### wait的实现

调用栈：wait->sys\_wait->do\_wait

分析：当程序执行wait时，会调用系统调用sys_wait，而该系统调用的功能则主要由do_wait函数实现。

#### exit的实现

调用栈：exit->sys\_exit->do\_exit

分析：当程序执行exit时，会调用系统调用SYS_exit，而该系统调用的功能主要是由do_exit函数实现。

#### 系统调用的实现

通过分析，我们发现fork/exec/wait/exit的实现均通过系统调用sys\_fork/sys\_exec/sys\_wait/sys\_exit实现。

一般来说，用户进程只能执行一般的指令，无法执行特权指令。采用系统调用机制为用户进程提供一个获得操作系统服务的统一接口层，简化用户进程的实现。

应用程序调用的库函数最终都会调用syscall函数，只是调用的参数不同而已。
当应用程序调用系统函数时，一般执行INT T_SYSCALL指令后，CPU根据操作系统建立的系统调用中断描述符，根据不同的系统调用号码进行系统调用的选择，转入内核态，然后开始了操作系统系统调用的执行过程。

在内核函数执行之前，会保留软件执行系统调用前的执行现场，然后保存当前进程的tf结构体中，之后操作系统就可以开始完成具体的系统调用服务，完成服务后，调用IRET返回用户态，并恢复现场。这样整个系统调用就执行完毕了。


### 问题：

#### 请分析fork/exec/wait/exit在实现中是如何影响进程的执行状态的？

fork父进程通过拷贝自己复制出子进程，exec使用一个程序对另外一个进程进行复制，wait等待子进程或者IO操作的结束，exit进程退出，可以触发父进程的wait条件。当程序执行fork/exec/wait/exit，会调用sys\_fork/sys\_exec/sys\_wait/sys\_exit函数，以上函数又会调用syscall函数，syscall函数嵌入了内联汇编指令，int产生系统调用与中断。而kernel则会对这些系统调用进行统一的处理。这些函数会产生中断，如果此时current -> need_resched ==1，则会进行调度。

#### 请给出ucore中一个用户态进程的执行状态生命周期图(包括执行状态，执行状态之间的变换关系，以及产生变换的事件或函数调用)。(字符方式画即可)

```sequence
创建->就绪: fork函数或exec函数
就绪->执行: schedule函数
执行->就绪: 时间片用完或被优先级更高任务抢占
执行->等待: 等待特定事件
等待->就绪: 等待事件发生
执行->退出: do_exit函数
```

## 总结

### 与参考答案区别：

- 练习1：eflags修改答案为=，自己实现为|=


- 练习2：和答案相同


### 重要知识点：

- 用户进程与内核进程
- 特权级的转换
- 系统调用
- 进程管理

### 缺失知识点：

- 真正属于本实验需要填充的代码有些少，没有能充分考察学生对核心代码的理解

### 小结：

通过本次试验——用户进程管理，我对用户进程和ucore代码的理解有了质的提高，理解了用户进程与内核进程的区别、系统调用框架的实现机制、通过系统调用进行进程管理等多个知识点，对操作系统的认知和热情进一步加深。