# 操作系统 Lab2 实验报告

###### 张钰晖 计算机系计55班 2015011372 yuhui-zh15@mails.tsinghua.edu.cn

## 练习0：填写已有实验

从lab1中复制`kern/debug/kdebug.c`的函数`print_stackframe`和`kern/trap/trap.c`的函数`idt_init`和`trap_dispatch`即可。

## 练习1：实现first-fit连续物理内存分配算法

### 设计：

- 分配时：

在空闲块列表中搜索第一个块大小大于需求大小的空闲块，如果找到空闲块，若块大小大于需求大小，进行块分裂，返回其地址。

```
当前块 = 块头
while 当前块 != 块头
	if 块大小 > 需求大小
		break
	当前块 = 下一块
if 找到空闲块
	if 块大小 > 需求大小
		建立新块，设置其块大小为剩余大小，加入当前块后
	列表中删除当前块
return 找到的空闲块
```

- 回收时：

将空闲块插入空闲块列表，同时检查前后是否有相邻空闲块，如果有则进行合并。

```
对空闲块中的所有页清除属性
当前块 = 块头下一块
插入位 = 块头
while 当前块 != 块头
	if 当前块地址 < 空闲块地址 and 不能合并
		插入位 = 当前块
	if 当前块其前紧邻空闲块，合并并删除
	elif 当前块其后紧邻空闲块，合并并删除
	当前块 = 下一块
在空闲块列表插入位插入空闲块
```

### 实现：

- 分配时：

分配算法已经基本实现，但是存在一个问题：分裂后的块插入操作没有按照空闲块起始地址来排序，没有形成一个有序的列表。修改此问题即可。

```c
static struct Page *
default_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
        if (page->property > n) {
            struct Page *p = page + n;
            p->property = page->property - n;
            SetPageProperty(p);
            // [修改]: 分裂后的块插入当前块后，保证列表有序
            list_add(&(page->page_link), &(p->page_link));
        }
        list_del(&(page->page_link));
        nr_free -= n;
        ClearPageProperty(page);
    }
    return page;
}
```

- 回收时：

回收算法已经基本实现，但是存在一个问题：新的空闲块插入操作没有按照空闲块起始地址来排序，没有形成一个有序的列表。修改此问题即可。

```c
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    // [修改]: 记录新空闲块应该插入的位置
    list_entry_t *last = &free_list;
    while (le != &free_list) {
        p = le2page(le, page_link);
        // [修改]: 更新插入位
        if (p < base && !(p + p->property == base)) last = le;
        le = list_next(le);
        if (base + base->property == p) {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
        else if (p + p->property == base) {
            p->property += base->property;
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
    // [修改]: 将新空闲块插入到插入位后
    list_add(last, &(base->page_link));
}
```

### 问题：

#### 你的first-fit算法是否有进一步的改进空间？

first-fit算法从空闲块列表开始查找，直至找到一个能满足其大小要求的空闲块为止。然后再按照需求的大小，划出一块内存分配给请求者，余下的空闲块仍留在空闲块列表中。

优点：该算法倾向于使用内存中低地址部分的空闲块，在高地址部分的空闲块很少被利用，从而保留了高地址部分的大空闲块。显然为以后分配大的内存空间创造了条件。

缺点：低地址部分不断被划分，留下许多难以利用、很小的空闲块，而每次查找又都从低地址部分开始，会增加查找的开销。

改进：

- 合并时无需遍历，根据归纳法，只需检查空闲块前后是否可以合并即可。
- 可以定期进行物理内存整理，将使用的物理内存整理至连续空间，将低地址空间遗留的大部分难以利用、很小的空闲块合并成新的空闲块，提高分配效率。

## 练习2：实现寻找虚拟地址对应的页表项

### 设计：

查找虚拟地址对应的页表项，如果不存在且需要创建则新建页表项。

```
页目录项 = 页目录首地址[线性地址]
if 页目录项不存在
	if 不创建 return 空
	if 新建一个页表为空(内存分配失败) return 空
	设置页表引用
	得到页表首地址
	将页表内容清空
	页目录项内容 = 页表首地址 + 所有标志位全开
return 页表首地址[线性地址]
```

### 实现：

根据伪代码实现，注意各种宏的使用，例如PDX(将线性地址转页目录index)，PTX(将线性地址转页表index)，KADDR(将实地址转内核虚地址), PDE\_ADDR(根据页目录项得到页表首地址)。

```c
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
    pde_t *pdep = &pgdir[PDX(la)];
    if (!(*pdep & PTE_P)) {
        if (!create) return NULL;
        struct Page *page;
        page = alloc_page();
        if (page == NULL) return NULL;
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
        *pdep = pa | PTE_U | PTE_W | PTE_P;
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
}
```

### 问题：

#### 请描述页目录项(Page Directory Entry)和页表(Page Table Entry)中每个组合部分的含义和以及对ucore而言的潜在用处。

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

对ucore而言，其作用在于：

- 维护二级页表，进行虚地址与实地址的转换。

- 设置各种功能，通过修改标记位实现，例如记录状态，设置访问权限等。

#### 如果ucore执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？

当ucore出现页访问异常时，硬件会进行以下操作：

- 把产生异常的线性地址存储在CR2寄存器中。
- 保存中断现场：在内核栈中依次压入当前中断的程序使用的EFLAGS、CS、EIP、errorCode，并将pgfault对应的中断(中断号0xE)对应的中断服务程序例程地址vector14加载到CS和EIP寄存器中。

## 练习3：释放某虚拟地址所在的页并取消对应二级页表项的映射

### 设计：

释放页并清除对应页表项。

```
if 页表项不存在 return
根据页表项得到页
页引用 -= 1
if 页引用 == 0 释放该页
清除页表项
更新TLB
```

### 实现：

根据伪代码实现，注意各种函数的使用。

```c
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
    if (!(*ptep & PTE_P)) return;
    struct Page *page = pte2page(*ptep);
    if (page_ref_dec(page) == 0) free_page(page);
    *ptep = 0;
    tlb_invalidate(pgdir, la);
}
```

### 问题：

#### 数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？

Page类型全局变量pages定义在`pmm.c`中。

根据`kern/mm/pmm.h`的`pa2page`函数：

```c
static inline struct Page *
pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa)];
}
```

和`kern/mm/mmu.h`的`PPN`宏：

```c
#define PTXSHIFT        12                      // offset of PTX in a linear address
#define PPN(la) (((uintptr_t)(la)) >> PTXSHIFT)
```

可知，可以根据页表中的页目录项和页表项查询得到页的物理地址pa，再根据转换关系index=pa >> 12得到对应的页pages[index]。

#### 如果希望虚拟地址与物理地址相等，则需要如何修改lab2，完成此事？鼓励通过编程来具体完成这个问题。

ucore最终建立的地址映射关系是virtual addr = linear addr = physical addr + 0xC0000000。

要使虚拟地址与物理地址相等，应做以下修改：

- 将`kern/mm/memlayout.h`的`#define KERNBASE 0xC0000000`改为`#define KERNBASE 0x0`
- 将`tools/kernel.ld`的`. = 0xC0100000`改为`. = 0x100000`

修改后运行正常，通过cprintf发现此时虚拟地址与物理地址相等。

## 总结

### 与参考答案区别：

- 练习1
  1. 答案在`default_init_memmap`函数结尾将`list_add`改为`list_add_before`，由于链表为双向链表且该函数只被调用一次，实际没有区别。
  2. 答案在`default_alloc_pages`函数中分裂页的时候调用了`SetPageProperty(p)`，但实际上不调用依然可以通过，为了保持一致性，改为答案。
  3. 答案在`default_alloc_pages`函数中最终又通过while循环找到块插入的位置，笔者的实现在合并查找的时候同时确定了块插入位置，效率更优。

- 练习2

  和答案基本一致，有一部分参考了答案。

- 练习3

  和答案基本一致。
### 重要知识点：

- 内存分配算法
- 内存回收算法
- first-fit内存管理算法
- 分页机制
- 二级页表
- 虚实地址转换

### 缺失知识点：

- 其余内存分配算法的实现与比较

### 小结：

通过本次试验——物理内存管理，我对内存管理和ucore内核代码的理解有了质的提高，理解了分配物理内存、释放物理内存、管理二级页表等多个知识点，对操作系统的认知和热情进一步加深。