# 操作系统 Lab3 实验报告

###### 张钰晖 计算机系计55班 2015011372 yuhui-zh15@mails.tsinghua.edu.cn

## 练习0：填写已有实验

从lab1中复制`kern/debug/kdebug.c`的函数`print_stackframe`和`kern/trap/trap.c`的函数`idt_init`、`trap_dispatch`。

从lab2中复制`kern/mm/default_pmm.c`的函数`default_init_memmap`、`default_alloc_pages`、`default_free_pages`和`kern/mm/pmm.c`的函数`get_pte`、`page_remove_pte`。

## 练习1：给未被映射的地址映射上物理页

### 设计：

当系统发生缺页异常时，便会经过异常处理程序调用`do_pgfault`函数，该函数根据异常情况进行相应的处理。

函数先根据线性地址找到一个合法的虚拟内存区域，如果没有，报错并返回。

函数再检查是否为以下三种情况之一：

- 企图写入且页缺失，但地址不可写
- 企图读出且页存在
- 企图读出且页缺失，但地址不可读

报错并返回。

此时，必然为以下三种情况之一：

- 企图写入且页存在
- 企图写入且页缺失，地址可写
- 企图读出且页缺失，地址可读

继续函数。

根据页目录项和线性地址查出对应的页表项，若页表项不存在则创建。

若页表项对应物理地址不存在，则创建页并建立物理地址与逻辑地址的映射。

伪代码如下：

```c
ptep = ??? //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
if (*ptep == 0) {
//(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
}
```

此时页表项对应物理地址存在，但不存在于内存，需要从磁盘进行换入操作。根据地址从磁盘载入内存，建立映射，并设置该页可换出。（练习2部分）

伪代码如下：

```c
if(swap_init_ok) {
    struct Page *page=NULL;
    //(1) According to the mm AND addr, try to load the content of right disk page into the memory which page managed.
    //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
    //(3) make the page swappable.
}
else {
    //error
}
```

### 实现：

根据设计分析和伪代码，具体实现代码如下：

`do_pgfault`函数：

```c
ptep = get_pte(mm->pgdir, addr, 1);
if (*ptep == 0) {
    pgdir_alloc_page(mm->pgdir, addr, perm);
}
else {
    if (swap_init_ok) {
        struct Page *page = NULL;
        swap_in(mm, addr, &page);
        page_insert(mm->pgdir, page, addr, perm);
        swap_map_swappable(mm, addr, page, 1);
        page->pra_vaddr = addr; // [答案]此处需要设置换出地址
    }
    else {
        cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
        goto failed;
    }
}
```

本部分实现正确后会输出`check_pgfault() succeeded!`

### 问题：

#### 请描述页目录项（Page Directory Entry）和页表（Page Table Entry）中组成部分对ucore实现页替换算法的潜在用处。

根据`kern/mm/mmu.h`中宏定义，我们可以清晰的理解页目录项和页表项的组成。

```c
/* page table/directory entry flags */
#define PTE_P           0x001                   // Present
#define PTE_W           0x002                   // Writeable
#define PTE_U           0x004                   // User
#define PTE_PWT         0x008                   // Write-Through
#define PTE_PCD         0x010                   // Cache-Disable
#define PTE_A           0x020                   // Accessed
#define PTE_D           0x040                   // Dirty
#define PTE_PS          0x080                   // Page Size
#define PTE_MBZ         0x180                   // Bits must be zero
#define PTE_AVAIL       0xE00                   // Available for software use
```

页目录项和页表项存储的都是：

- 某个页的地址

- 一些标记位

因此数据结构完全相同，长度均为32bit，其中组成如下：

| 位       | 意义                                            |
| -------- | ----------------------------------------------- |
| [32, 13] | 物理地址的高20位，页大小为4K，因此低12位必然全0 |
| [12, 10] | Available for software use                      |
| [9, 8]   | Bits must be zero                               |
| 8        | Page Size                                       |
| 7        | Dirty                                           |
| 6        | Accessed                                        |
| 5        | Cache-Disable                                   |
| 4        | Write-Through                                   |
| 3        | User                                            |
| 2        | Writeable                                       |
| 1        | Present                                         |

对于ucore的页替换算法：

- 页目录项PDE：根据PDE和LA可以通过`get_pte`函数得到页表项PTE。
- 页表项PTE：高24位存储了放在硬盘上的页起始扇区号，低8位最后一位为0表示该页位于硬盘上，其余7位保留。
  - 换入时，ucore根据高24位确定硬盘扇区号，将其从硬盘读入内存；
  - 换出时，ucore根据该页面虚拟地址确定对应的扇区（一一映射），存入其高24位，并将最后一位（PTE\_P）置0，表示该页已被换出。

#### 如果ucore的缺页服务例程在执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？

异常嵌套，硬件会进行以下操作：

- 把产生异常的线性地址存储在CR2寄存器中。
- 保存中断现场：在内核栈中依次压入当前中断的程序使用的EFLAGS、CS、EIP、errorCode，并将pgfault对应的中断(中断号0xE)对应的中断服务程序例程地址vector14加载到CS和EIP寄存器中。

## 练习2：补充完成基于FIFO的页面替换算法

### 设计：

`do_pgfault`函数：练习2部分练习1已经完成，参见练习1。

根据实验指导手册，队列头部存放最新访问的页，尾部存放最后访问的页。

`map_swappable`函数：换入时，根据FIFA页面替换算法，需要将最新访问的页插入队首。

```
link the most recent arrival page at the back of the pra_list_head qeueue.
```

`swap_out_victicm`函数：换出时，根据FIFA页面替换算法，需要将最后访问的页（队尾）从列表删除。

伪代码如下：

```
(1) unlink the  earliest arrival page in front of pra_list_head qeueue
(2) assign the value of *ptr_page to the addr of this page
```

### 实现：

根据设计分析和伪代码，具体实现代码如下：

`map_swappable`函数：

```c
static int _fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);
    assert(entry != NULL && head != NULL);
    list_add(head, entry);
    return 0;
}
```

`swap_out_victim`函数：

```c
static int _fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    assert(head != NULL);
    assert(in_tick==0);
    list_entry_t *entry = list_prev(head);
    struct Page *page = le2page(entry, pra_page_link);
    list_del(entry);
    *ptr_page = page;
    return 0;
}
```

本部分实现正确后会输出`check_swap() succeeded!`

### 问题：

#### 如果要在ucore上实现"extended clock页替换算法"，请给出你的设计方案。现有的swap\_manager框架是否足以支持在ucore中实现此算法？如果是，请给你的设计方案。如果不是，请给你的新的扩展和基于此扩展的设计方案。并需要回答如下问题

extended clock页替换算法需要综合考虑页面被访问和被修改情况（因为被修改的页面置换代价大于未被修改的页面）。

根据`kern/mm/mmu.h`中宏定义，我们可以发现可以用`PTE_A`表示该页是否被访问，`PTE_D`表示该页是否被修改。

```c
/* page table/directory entry flags */
#define PTE_P           0x001                   // Present
#define PTE_W           0x002                   // Writeable
#define PTE_U           0x004                   // User
#define PTE_PWT         0x008                   // Write-Through
#define PTE_PCD         0x010                   // Cache-Disable
#define PTE_A           0x020                   // Accessed
#define PTE_D           0x040                   // Dirty
#define PTE_PS          0x080                   // Page Size
#define PTE_MBZ         0x180                   // Bits must be zero
#define PTE_AVAIL       0xE00                   // Available for software use
```

因此目前的swap_manager框架可以实现extended clock页替换算法。修改`kern/mm/vmm.h`中的`_fifo_swap_out_victim()`函数即可，`PTE_A`和`PTE_D`分别是表示访问位和修改位，根据extended clock算法，未被访问的页应优先考虑换出，在此基础上，未被修改的页应该优先换出。

#### 需要被换出的页的特征是什么？

根据extended clock算法，未被访问的页应优先考虑换出，在此基础上，未被修改的页应该优先换出，因为被修改的页面置换代价大于未被修改的页面。

访问位和修改位组合起来考虑有4种特征，最近未被引用也未被修改，最近未被引用但被修改，最近被引用但未被修改，最近被引用也被修改，其置换的优先级依次降低。

#### 在ucore中如何判断具有这样特征的页？

多次扫描，观察并更新其访问位和修改位。

#### 何时进行换入和换出操作？

换入：

当程序访问地址所在的页不在内存且位于硬盘时，通过引起page fault异常，调用`do_pgfault`函数换入。

换出：

- 积极换出策略：周期地主动把某些认为不常用的页换出到硬盘。
- 消极换出策略：试图得到空闲页时，发现当前没有空闲的物理页可分配。

## 总结

### 与参考答案区别：

- 练习1：
  - 答案对`get_pte`，`pgdir_alloc_page`，`swap_in`等多个函数返回值进行了异常检查报错处理，更加鲁棒。


- 练习2
  - 答案设置了页面换出地址`page->pra_addr`，已改正。
  - 答案对一些可能的异常进行了assert检测，更加鲁棒。


### 重要知识点：

- 异常与异常处理
- PDE与PTE
- Page Fault异常处理方式
- FIFA算法换入换出的实现

### 缺失知识点：

- FIFA算法的缺点的观察：Belady现象


- 其余换入换出算法的实现与性能比较

### 小结：

通过本次试验——虚拟内存管理，我对内存管理和ucore内核代码的理解有了质的提高，理解了虚拟内存管理、页缺失异常的处理、FIFA页置换算法等多个知识点，对操作系统的认知和热情进一步加深。