# 操作系统 Lab8 实验报告

###### 张钰晖 计算机系计55班 2015011372 yuhui-zh15@mails.tsinghua.edu.cn

## 练习0.0：填写已有实验

- 复制`kern/debug/kdebug.c`的函数`print_stackframe`
- 复制`kern/trap/trap.c`的函数`idt_init`、`trap_dispatch`
- 复制`kern/mm/default_pmm.c`的函数`default_init_memmap`、`default_alloc_pages`、`default_free_pages`
- 复制`kern/mm/pmm.c`的函数`get_pte`、`page_remove_pte`、`copy_range`
- 复制`kern/mm/vmm.c`的函数`do_pgfault`
- 复制`kern/mm/swap_fifo.c`的函数`_fifo_map_swappable`、`_fifo_swap_out_victim`
- 复制`kern/process/proc.c`的函数`alloc_proc`、`do_fork`、`load_icode`。
- 复制整个`kern/schedule/default_sched.c`
- 复制`kern/sync/check_sync.c`的函数`phi_test_convar`和`phi_put_forks_condvar`
- 复制`kern/sync/monitor.c`的函数`cond_signal`和`cond_wait`

## 练习0.1：修改已有实验

为了正确执行lab8的测试应用程序，需要对已完成的实验1/2/3/4/5/6/7的代码进一步改进。

### `kern/process/proc.c`中的函数`alloc_proc`

##### 设计：Lab8中，由于引入了文件系统，每个进程需要维护自己的文件信息filesp。

##### 修改：

```c
// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL) {
        ....
        proc->filesp = NULL; // [LAB8] need add some code to init fs in proc_struct, ...
    }
    return proc
}    
```

### `kern/process/proc.c`中的函数`do_fork`

##### 设计：Lab8中，由于引入了文件系统，在进程复制时，子进程还需要复制父进程的文件信息。ucore提供了`copy_files`函数，可以直接使用其用来复制文件信息，再修改对复制错误的处理即可。

##### 修改：

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
    if ((proc = alloc_proc()) == NULL) goto fork_out;
    proc->parent = current;
    assert(current->wait_state == 0);
    if (setup_kstack(proc) != 0) goto bad_fork_cleanup_proc;
    if (copy_files(clone_flags, proc) != 0) goto bad_fork_cleanup_kstack; // [LAB8] copy the fs in parent's proc_struct
    if (copy_mm(clone_flags, proc) != 0) goto bad_fork_cleanup_fs; // [LAB8] error restore
    copy_thread(proc, stack, tf);
    
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        proc->pid = get_pid();
        hash_proc(proc);
        set_links(proc);
    }
    local_intr_restore(intr_flag);
    wakeup_proc(proc);
    ret = proc->pid;
	
fork_out:
    return ret;
bad_fork_cleanup_fs: // [LAB8] error restore
    put_files(proc); // [LAB8] error restore
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
```


## 练习1：完成读文件操作的实现

### 设计：

在实现过程中，主要修改的是位于`kern/fs/sfs/sfs_inode`的`sfs_io_nolock`函数，该函数的作用是从sfs文件系统中，给定一个文件的`inode`以及需要读写的偏移量和大小，转换成block级别的读写操作。

其函数的定义和参数如下：

```c
/*  
 * sfs_io_nolock - Rd/Wr a file contentfrom offset position to offset+ length  disk blocks<-->buffer (in memroy)
 * @sfs:      sfs file system
 * @sin:      sfs inode in memory
 * @buf:      the buffer Rd/Wr
 * @offset:   the offset of file
 * @alenp:    the length need to read (is a pointer). and will RETURN the really Rd/Wr lenght
 * @write:    BOOL, 0 read, 1 write
 */
```

在实现该函数时，需要调用以下三个函数：

- `sfs_bmap_load_nolock`: 根据inode和index，转换成磁盘block编号
- `sfs_block_op` ：根据磁盘block编号和读写block数目，对block级别进行读写
- `sfs_buff_op`：根据磁盘block编号、读写长度和读写偏移，对一个block进行读写

由于用户希望读取的文件大小和偏移并非是和数据块一一对齐的，因此在边界情况的时候需要特殊处理，`sfs_io_nolock`函数便是通过对偏移的开头未对齐部分和结尾未对齐部分专门进行处理，而中间部分则调用block级别操作进行处理。

具体地说，开头和结尾计算好读写长度和偏移，使用`sfs_buff_op`函数完成读写；中间部分使用`sfs_block_op`函数整个block级别读写。

实际上，观察函数`sfs_buff_op`的调用可以得知：该函数在进行设备操作的时候也是以块为单位的。如果要读取一个块内的小部分数据，就必须将数据块整体读出或整体写入。这与操作系统原理部分也是契合的。

### 实现：

具体的C实现如下，添加了注释，函数错误恢复部分参考了答案，其余和答案基本相同。

```c
static int
sfs_io_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, void *buf, off_t offset, size_t *alenp, bool write) {
    struct sfs_disk_inode *din = sin->din;
    assert(din->type != SFS_TYPE_DIR);
    off_t endpos = offset + *alenp, blkoff;
    *alenp = 0;
	// calculate the Rd/Wr end position
    if (offset < 0 || offset >= SFS_MAX_FILE_SIZE || offset > endpos) {
        return -E_INVAL;
    }
    if (offset == endpos) {
        return 0;
    }
    if (endpos > SFS_MAX_FILE_SIZE) {
        endpos = SFS_MAX_FILE_SIZE;
    }
    if (!write) {
        if (offset >= din->size) {
            return 0;
        }
        if (endpos > din->size) {
            endpos = din->size;
        }
    }

    int (*sfs_buf_op)(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset);
    int (*sfs_block_op)(struct sfs_fs *sfs, void *buf, uint32_t blkno, uint32_t nblks);
    if (write) {
        sfs_buf_op = sfs_wbuf, sfs_block_op = sfs_wblock;
    }
    else {
        sfs_buf_op = sfs_rbuf, sfs_block_op = sfs_rblock;
    }

    int ret = 0; 
    size_t size, alen = 0;
    uint32_t ino;
    uint32_t blkno = offset / SFS_BLKSIZE;          // The NO. of Rd/Wr begin block
    uint32_t nblks = endpos / SFS_BLKSIZE - blkno;  // The size of Rd/Wr blocks 注意此处向下取整

  //LAB8:EXERCISE1 2015011372 HINT: call sfs_bmap_load_nolock, sfs_rbuf, sfs_rblock,etc. read different kind of blocks in file
	/*
	 * (1) If offset isn't aligned with the first block, Rd/Wr some content from offset to the end of the first block
	 *       NOTICE: useful function: sfs_bmap_load_nolock, sfs_buf_op
	 *               Rd/Wr size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset)
	 * (2) Rd/Wr aligned blocks 
	 *       NOTICE: useful function: sfs_bmap_load_nolock, sfs_block_op
     * (3) If end position isn't aligned with the last block, Rd/Wr some content from begin to the (endpos % SFS_BLKSIZE) of the last block
	 *       NOTICE: useful function: sfs_bmap_load_nolock, sfs_buf_op	
	*/
	// 开头部分，计算偏移和大小，完成读写
    if ((blkoff = offset % SFS_BLKSIZE) != 0) {
        size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) goto out;
        if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)) != 0) goto out;
        alen += size;
        buf += size;
        if (nblks == 0) goto out;
        blkno++;
        nblks--;
    }
    // 中间部分，整块整块读写
    size = SFS_BLKSIZE;
    while (nblks != 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) goto out;
        if ((ret = sfs_block_op(sfs, buf, ino, 1)) != 0) goto out;
        alen += size;
        buf += size;
        blkno++;
        nblks--;
    }
    // 结尾部分，计算大小（偏移为0），完成读写
    if ((size = endpos % SFS_BLKSIZE) != 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) goto out;
        if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)) != 0) goto out;
        alen += size;
        buf += size;
    }
out:
	// alen记录了实际读写大小
    *alenp = alen;
    if (offset + alen > sin->din->size) {
        sin->din->size = offset + alen;
        sin->dirty = 1;
    }
    return ret;
}
```

### 问题：

####1. “UNIX的PIPE机制”概要设计方案

管道机制是UNIX进程间通讯的重要机制，笔者认为可以将管道文件映射到一块内存区域，每次在文件系统清理的时候就将管道清空，符合管道机制的语义。

为了创建管道，与UNIX系统相同，需要增加相关的系统调用，此后就可以统一的使用write和read接口进行读和写操作了。

具体到ucore的实现，笔者认为可以在`sfs_inode`数据结构中增加特殊的标记位确定是不是管道文件，同时需要考虑到互斥访问的情况，增加两个信号量（由于之前已经有一个互斥锁，就不需要再多余使用一个锁了）用于进行类似“生产者-消费者”问题的同步互斥控制。

## 练习2：完成基于文件系统的执行程序机制的实现

### 设计：

在实现过程中，主要修改的是位于`kern/process/proc.c`的`load_icode`函数。

首先和Lab 7相比，`load_icode`函数的参数发生了变化：

```c
static int load_icode(unsigned char *binary, size_t size) // [LAB7]
static int load_icode(int fd, int argc, char **kargv) // [LAB8]
```

1. ELF文件不再从内存中读取，而是通过已经实现好的文件系统的从磁盘读取。
2. 加入了参数argc和argv的功能，使得应用程序能够接受命令行参数输入。

因此，需要解决两个问题：

1. 如何从磁盘读取文件：可执行文件是elf格式的，主要通过调用`load_icode_read`函数完成针对elf文件的磁盘读取，该函数又在文件系统之上调用了read和seek函数，基于SFS对文件进行读取和寻址操作。注意需要依次将elf header，program header以及program content读入内存，而Lab 7中这些都是已经在内存binary地址中。
2. 如何设置命令行参数：通过修改用户堆栈实现，将相关的字符串拷贝到用户栈的顶端，并将最开始的栈指针放在argc的起始地址。用户态的initcode.S和umain.c也需要做相应的改动，需要将参数寄存器设置为argc和argv的地址。

设置好的用户堆栈如下所示（new至old部分表示Lab 8新设置部分）：

```
--new---
| argc | <-- stack top
| argv |
| .... |
| argv |
--old---
| .... |
```

### 实现：

参考了答案的具体的C实现如下（很遗憾笔者调试了很久依然没有实现成功），添加了注释，Lab 8相比Lab 7改动的地方特别标注了出来。

```c
static int
load_icode(int fd, int argc, char **kargv) {
    /* LAB8:EXERCISE2 2015011372  HINT:how to load the file with handler fd  in to process's memory? how to setup argc/argv?
     * MACROs or Functions:
     *  mm_create        - create a mm
     *  setup_pgdir      - setup pgdir in mm
     *  load_icode_read  - read raw data content of program file
     *  mm_map           - build new vma
     *  pgdir_alloc_page - allocate new memory for  TEXT/DATA/BSS/stack parts
     *  lcr3             - update Page Directory Addr Register -- CR3
     */
	/* (1) create a new mm for current process
     * (2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
     * (3) copy TEXT/DATA/BSS parts in binary to memory space of process
     *    (3.1) read raw data content in file and resolve elfhdr
     *    (3.2) read raw data content in file and resolve proghdr based on info in elfhdr
     *    (3.3) call mm_map to build vma related to TEXT/DATA
     *    (3.4) callpgdir_alloc_page to allocate page for TEXT/DATA, read contents in file
     *          and copy them into the new allocated pages
     *    (3.5) callpgdir_alloc_page to allocate pages for BSS, memset zero in these pages
     * (4) call mm_map to setup user stack, and put parameters into user stack
     * (5) setup current process's mm, cr3, reset pgidr (using lcr3 MARCO)
     * (6) setup uargc and uargv in user stacks
     * (7) setup trapframe for user environment
     * (8) if up steps failed, you should cleanup the env.
     */
    assert(argc >= 0 && argc <= EXEC_MAX_ARG_NUM); // [ANSWER]

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
    struct elfhdr __elf, *elf = &__elf; // [LAB8] elf header
    if ((ret = load_icode_read(fd, elf, sizeof(struct elfhdr), 0)) != 0) {
        goto bad_elf_cleanup_pgdir;
    } // [LAB8] 从磁盘读出elf header
    //(3.2) This program is valid?
    if (elf->e_magic != ELF_MAGIC) {
        ret = -E_INVAL_ELF;
        goto bad_elf_cleanup_pgdir;
    }
    //(3.3) get the entry of the program section headers of the bianry program (ELF format)
    struct proghdr __ph, *ph = &__ph; // [LAB8] program header
    uint32_t vm_flags, perm, phnum;
    for (phnum = 0; phnum < elf->e_phnum; phnum ++) {
    //(3.4) find every program section headers
        off_t phoff = elf->e_phoff + sizeof(struct proghdr) * phnum;
        if ((ret = load_icode_read(fd, ph, sizeof(struct proghdr), phoff)) != 0) { 
            goto bad_cleanup_mmap; 
        } // [LAB8] 从磁盘读出program header
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
        off_t offset = ph->p_offset;
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);

        ret = -E_NO_MEM;
    //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
        //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                ret = -E_NO_MEM;
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la) {
                size -= la - end;
            }
            if ((ret = load_icode_read(fd, page2kva(page) + off, size, offset)) != 0) {
                goto bad_cleanup_mmap;
            } // [LAB8] 从磁盘读出program content
            start += size, offset += size;
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
                ret = -E_NO_MEM;
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
    sysfile_close(fd); // [LAB8] 关闭file descriptor
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

    // [LAB8] 设置用户命令行参数，通过设置堆栈实现
    uint32_t argv_size=0, i;
    for (i = 0; i < argc; i ++) {
        argv_size += strnlen(kargv[i],EXEC_MAX_ARG_LEN + 1)+1;
    }

    uintptr_t stacktop = USTACKTOP - (argv_size/sizeof(long)+1)*sizeof(long);
    char** uargv=(char **)(stacktop  - argc * sizeof(char *));
    
    argv_size = 0;
    for (i = 0; i < argc; i ++) {
        uargv[i] = strcpy((char *)(stacktop + argv_size ), kargv[i]);
        argv_size +=  strnlen(kargv[i],EXEC_MAX_ARG_LEN + 1)+1;
    }
    
    stacktop = (uintptr_t)uargv - sizeof(int);
    *(int *)stacktop = argc;
    //(6) setup trapframe for user environment
    struct trapframe *tf = current->tf;
    memset(tf, 0, sizeof(struct trapframe));
    tf->tf_cs = USER_CS;
    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
    tf->tf_esp = stacktop;
    tf->tf_eip = elf->e_entry;
    tf->tf_eflags = FL_IF;
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

完成本练习后，执行`make grade`可以得到满分。

通过参考piazza上的提问，发现只有去掉`kern/process/proc.c`中`init_main`函数`check_sync()`后，执行`make qemu`才可以进入操作系统，接收键盘输入，正常运行在磁盘中的程序。

### 问题：

####1. 基于“UNIX的硬链接和软链接机制”概要设计方案

- 硬链接：在SFS文件系统中inode数据结构中已经存储了代表了指向这个inode的硬链接个数nlinks，因此只需要添加一个系统调用，找到被链接文件对应的inode，然后在目标文件夹的控制块中增加一个描述符，二者的inode指针相同，同时增加引用计数nlinks。
- 软链接：软链接相当于一个类似指针的快捷方式，需要在inode上增加文件是普通文件还是软链接文件的标记位，在对文件操作时，操作系统需要根据软链接指向的地址在文件目录中进行查询，寻找或创建相应的inode。注意与硬链接不同，创建软链接的时候不增加引用计数nlinks，同时也需要增加一个系统调用以创建软链接这个特殊的文件。

## Ubuntu 32bits环境遇到的编译问题

由于course wiki推荐的操作系统过于老旧（Ubuntu 12.04 32bits LTS），导致实验一直编译失败。经过笔者的分析，发现`tools/mksfs.c`中有一句`static_assert(sizeof(off_t)==8)`，`off_t`实际上是`int`，在32位ubuntu系统上`sizeof(off_t)`是4而不是8，这就导致`sizeof(off_t)==8`实际值为0，而`static_assert(0)`会导致重复定义`0`。

`static_assert`的定义如下（实现非常巧妙，利用switch中case不得重复的语法特性实现了编译期错误检查）：

```c
#define static_assert(x) switch (x) { case 0: case (x): ; }
```

经过与老师同学的讨论，有以下两种解决方案，都可以正常进行本实验：

- 删去`static_assert`，尽管会导致生成的`sfs.img`与64位操作系统不同，但一切编译运行正常
- 修改`makefile`，增加编译选项`-D_FILE_OFFSET_BITS=64 `，强行指定其为64位，编译运行正常

在此感谢陈瑜老师和谭闻德同学，节约了笔者更换操作系统的大量时间！

## 总结

### 与参考答案区别：

- 练习1：没有对可能发生的错误进行异常处理，即没有对返回值ret进行异常情况下的赋值，已参考答案进行修改。由于有伪代码较为详尽的解释，其余实现和答案基本相同。
- 练习2：由于没有伪代码，笔者最终并没有调试出来此部分，部分参考了答案，已在上述实现中注明。

### 重要知识点：

- 文件系统与文件
- 文件描述符
- 文件与目录的定义与区别
- 虚拟文件系统

### 缺失知识点：

- 冗余磁盘阵列RAID
- 文件分配
- I/O子系统的相关控制

### 小结：

通过本次试验——文件系统，我对文件和文件系统、文件描述符和ucore代码的理解有了质的提高，深入理解了ucore系统中如何具体的实现一个文件系统，这是操作系统最后一个实验，通过这八个实验，我对操作系统的理解和热情进一步加深，希望考试顺利！