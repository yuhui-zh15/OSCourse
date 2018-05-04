# 操作系统 Lab6 实验报告

###### 张钰晖 计算机系计55班 2015011372 yuhui-zh15@mails.tsinghua.edu.cn

## 练习0.0：填写已有实验

- 复制`kern/debug/kdebug.c`的函数`print_stackframe`
- 复制`kern/trap/trap.c`的函数`idt_init`、`trap_dispatch`。
- 复制`kern/mm/default_pmm.c`的函数`default_init_memmap`、`default_alloc_pages`、`default_free_pages`
- 复制`kern/mm/pmm.c`的函数`get_pte`、`page_remove_pte`、`copy_range`。
- 复制`kern/mm/vmm.c`的函数`do_pgfault`
- 复制`kern/mm/swap_fifo.c`的函数`_fifo_map_swappable`、`_fifo_swap_out_victim`、`load_icode`
- 复制`kern/process/proc.c`的函数`alloc_proc`、`do_fork`。

## 练习0.1：修改已有实验

为了正确执行lab6的测试应用程序，需要对已完成的实验1/2/3/4/5的代码进一步改进。

### `kern/trap/trap.c`中的函数`trap_dispatch`

##### 设计：Lab6中，由于实现了进程调度的时间片机制，每个tick都需要调用函数修改进程的剩余时间片。

##### 修改：

```c
static void trap_dispatch(struct trapframe *tf) {
    ...
    case IRQ_OFFSET + IRQ_TIMER:
        /* you should upate you lab5 code
         * IMPORTANT FUNCTIONS:
	     * sched_class_proc_tick
         */
        ticks++;
        assert(current != NULL);
        sched_class_proc_tick(current); // [COMMENT] NOT EVERY TICK_NUM CYCLE
        break;
    ...
}
```

### `kern/process/proc.c`中的函数`alloc_proc`


##### 设计：Lab6中，proc\_struct新增了针对进程调度使用的字段，需要对其初始化。

##### 修改：

```c
static struct proc_struct *alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL) {
		...
	/*
     * below fields(add in LAB6) in proc_struct need to be initialized
     *     struct run_queue *rq;                       // running queue contains Process
     *     list_entry_t run_link;                      // the entry linked in run queue
     *     int time_slice;                             // time slice for occupying the CPU
     *     skew_heap_entry_t lab6_run_pool;            // FOR LAB6 ONLY: the entry in the run pool
     *     uint32_t lab6_stride;                       // FOR LAB6 ONLY: the current stride of the process
     *     uint32_t lab6_priority;                     // FOR LAB6 ONLY: the priority of process, set by lab6_set_priority(uint32_t)
     */
     	proc->rq = NULL;
        list_init(&proc->run_link);
        proc->time_slice = 0;
        proc->lab6_run_pool.left = proc->lab6_run_pool.right = proc->lab6_run_pool.parent = NULL; // [ANSWER]
        proc->lab6_stride = 0;
        proc->lab6_priority = 0; // [COMMENT] set priority to 1 could simplify the code in ex2 using Stride Scheduling algorithm
    }
    return proc;
}
```

本部分实现正确后执行`make grade`只有run-priority无法通过。

## 练习1：使用Round Robin调度算法

### 设计：

Round Robin调度算法是一个简单的基于时间片的调度算法。其主要思想是存储每个进程的时间片，并建立一个调度队列（该队列是一个普通的队列），每次时钟中断更新当前运行进程时间片，若时间片用完，则调度器将当前进程加入调度队列，并从调度队列中寻找并取出第一个进程进行调度。

### 实现：

1. 初始化函数stride\_init

```c
static void
RR_init(struct run_queue *rq) {
    list_init(&(rq->run_list));
    rq->proc_num = 0;
}
```

2. 入队函数stride\_enque

```c
static void
RR_enqueue(struct run_queue *rq, struct proc_struct *proc) {
    assert(list_empty(&(proc->run_link)));
    list_add_before(&(rq->run_list), &(proc->run_link));
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
        proc->time_slice = rq->max_time_slice;
    }
    proc->rq = rq;
    rq->proc_num ++;
}
```


3. 出队函数stride\_deque

```c
static void
RR_dequeue(struct run_queue *rq, struct proc_struct *proc) {
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
    list_del_init(&(proc->run_link));
    rq->proc_num --;
}
```

4. 队列选择函数stride\_pick\_next

```c
static struct proc_struct *
RR_pick_next(struct run_queue *rq) {
    list_entry_t *le = list_next(&(rq->run_list));
    if (le != &(rq->run_list)) {
        return le2proc(le, run_link);
    }
    return NULL;
}
```

5. 进程更新函数stride\_proc\_tick

```c
static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
    if (proc->time_slice > 0) {
        proc->time_slice --;
    }
    if (proc->time_slice == 0) {
        proc->need_resched = 1;
    }
}
```

### 问题：

#### 请理解并分析sched\_class中各个函数指针的用法，并结合Round Robin调度算法描述ucore的调度执行过程

sched\_class定义如下：

```c
struct sched_class {
    // the name of sched_class
    const char *name;
    // Init the run queue
    void (*init)(struct run_queue *rq);
    // put the proc into runqueue, and this function must be called with rq_lock
    void (*enqueue)(struct run_queue *rq, struct proc_struct *proc);
    // get the proc out runqueue, and this function must be called with rq_lock
    void (*dequeue)(struct run_queue *rq, struct proc_struct *proc);
    // choose the next runnable task
    struct proc_struct *(*pick_next)(struct run_queue *rq);
    // dealer of the time-tick
    void (*proc_tick)(struct run_queue *rq, struct proc_struct *proc);
};
```

调度器类中的主要功能函数分别如下：

- init：初始化调度器的相关参数
- enqueue：将进程放入调度队列，等待调度器进行调度
- dequeue：从调度队列中移除一个进程
- pick_next：根据调度策略选择下一个调度的进程
- proc_tick：每次时钟中断之后更新进程的相关信息

ucore有如下调度点：

- `do_exit`, `do_wait`, `init_main`, `cpu_idle`, `lock`中调用schedule函数时由于要执行等待操作或退出操作，如果不放弃CPU使用权是对资源的浪费，属于主动放弃CPU使用权，不涉及调度器规则中的打断
- `trap`函数中，首先要判断是否中断处于用户态，如果处于用户态且已经被标记为需要调度，则该进程会被主动打断，至于何时被标记需要调度，一部分取决于调度器的设计

当操作系统调用schedule函数进行调度的时候（以RR调度器为例），首先会使用enqueue函数将当前进程加入调度队列run\_queue，接着使用pick\_next和dequeue函数选出等待队列最前方的进程进行执行。考虑到RR算法主要通过时钟中断来确定调度点，所以每次时钟中断的时候都会执行proc\_tick函数，对于当前执行的进程的time\_slice进行减一操作，当进程的时间片用完之后就需要运行调度器。

#### 请在实验报告中简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计，鼓励给出详细设计

多级反馈队列调度算法是指：

- 进程在进入待调度的队列等待时，首先进入优先级最高的Q1队列等待

- 首先调度优先级高的队列中的进程。若高优先级中队列中已没有调度的进程，则调度次优先级队列中的进程

- 对于同一个队列中的各个进程，按照时间片轮转法调度。比如Q1队列的时间片为N，那么Q1中的作业在经历了N个时间片后若还没有完成，则进入Q2队列等待，若Q2的时间片用完后作业还不能完成，一直进入下一级队列，直至完成。
- 在低优先级的队列中的进程在运行时，又有新到达的作业，那么在运行完这个时间片后，CPU马上分配给新到达的作业。

为了实现多级反馈队列调度算法，并最大限度保证当前的调度器设计架构，应该新增一个调度器类，在enqueue的时候判断进程的类型放入到不同的进程队列中，每次在进行进程切换的时候按照优先级选择一个合适的进程进行调度。需要注意的是需要在每个PCB中加入priority变量代表优先级，在入队和出队的时候动态进行优先级修改。


## 练习2：实现Stride Scheduling调度算法

### 设计：

Stride调度算法是一个稍复杂的基于时间片的调度算法，考虑了进程的优先级。其主要思想是存储每个进程的时间片，当前位置stride和优先级priority，并建立一个调度队列（该队列为优先队列，根据进程当前位置stride由小到大对进程进行排序），每次时钟中断更新当前运行进程时间片，若时间片用完，则调度器将当前进程加入调度队列，并从调度队列中寻找并取出优先级最高（当前位置stride最小）的进程进行调度，同时对其当前位置stride增加步长pass（pass=BIG\_STRIDE/priority）。（BIG\_STRIDE的选取见个人理解部分）

Stride调度算法的调度队列既可以通过列表，又可以通过堆实现。其本是都是从调度队列中寻找并取出优先级最高的进程进行调度，通过堆实现效率更高，可以直接取出堆顶元素，列表则需要遍历取出优先级最高的元素。但因为调度进程数量很少，实际运行效率差别不大。

通过堆实现需要维护`run_pool`，通过列表实现需要维护`run_list`，笔者的实现可以通过宏进行选择。

### 实现：

1. 重要的宏BIG\_STRIDE（BIG\_STRIDE的选取见后文个人理解部分）

```c
/* You should define the BigStride constant here*/
/* LAB6: 2015011372 */
#define BIG_STRIDE 2147483647   /* you should give a value, and is 0x7fffffff */
```

2. 初始化函数stride\_init：初始化`rq`和`run_pool/run_list`

```c
/*
 * stride_init initializes the run-queue rq with correct assignment for
 * member variables, including:
 *
 *   - run_list: should be a empty list after initialization.
 *   - lab6_run_pool: NULL
 *   - proc_num: 0
 *   - max_time_slice: no need here, the variable would be assigned by the caller.
 *
 * hint: see libs/list.h for routines of the list structures.
 */
static void
stride_init(struct run_queue *rq) {
     /* LAB6: 2015011372 
      * (1) init the ready process list: rq->run_list
      * (2) init the run pool: rq->lab6_run_pool
      * (3) set number of process: rq->proc_num to 0       
      */
#if USE_SKEW_HEAP
    rq->lab6_run_pool = NULL;
#else
    list_init(&(rq->run_list));
#endif
    rq->proc_num = 0;
}
```

3. 入队函数stride\_enque：调用斜堆的插入功能将新的进程按照`stride`的大小插入斜堆，或直接插入列表尾部，并且将`rq`的进程总数加1

```c
/*
 * stride_enqueue inserts the process ``proc'' into the run-queue
 * ``rq''. The procedure should verify/initialize the relevant members
 * of ``proc'', and then put the ``lab6_run_pool'' node into the
 * queue(since we use priority queue here). The procedure should also
 * update the meta date in ``rq'' structure.
 *
 * proc->time_slice denotes the time slices allocation for the
 * process, which should set to rq->max_time_slice.
 * 
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static void
stride_enqueue(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: 2015011372 
      * (1) insert the proc into rq correctly
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_insert: insert a entry into skew_heap
      *         list_add_before: insert  a entry into the last of list   
      * (2) recalculate proc->time_slice
      * (3) set proc->rq pointer to rq
      * (4) increase rq->proc_num
      */
#if USE_SKEW_HEAP
    rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
#else
    assert(list_empty(&(proc->run_link)));
    list_add_before(&(rq->run_list), &(proc->run_link));
#endif
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
        proc->time_slice = rq->max_time_slice;
    }
    proc->rq = rq;
    rq->proc_num ++;
}
```

4. 出队函数stride\_deque：调用斜堆的删除功能删除斜堆的根结点（即`stride`值最小的进程）或删除对应列表项

```c
/*
 * stride_dequeue removes the process ``proc'' from the run-queue
 * ``rq'', the operation would be finished by the skew_heap_remove
 * operations. Remember to update the ``rq'' structure.
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static void
stride_dequeue(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: 2015011372
      * (1) remove the proc from rq correctly
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_remove: remove a entry from skew_heap
      *         list_del_init: remove a entry from the  list
      */
#if USE_SKEW_HEAP
    rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
#else
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
    list_del_init(&(proc->run_link));
#endif
    rq->proc_num --;
}
```

5. 队列选择函数stride\_pick\_next：选择最小stride的进程，并更新stride，使之前进BIG\_STRIDE / priority

```c
/*
 * stride_pick_next pick the element from the ``run-queue'', with the
 * minimum value of stride, and returns the corresponding process
 * pointer. The process pointer would be calculated by macro le2proc,
 * see kern/process/proc.h for definition. Return NULL if
 * there is no process in the queue.
 *
 * When one proc structure is selected, remember to update the stride
 * property of the proc. (stride += BIG_STRIDE / priority)
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static struct proc_struct *
stride_pick_next(struct run_queue *rq) {
     /* LAB6: 2015011372
      * (1) get a  proc_struct pointer p  with the minimum value of stride
             (1.1) If using skew_heap, we can use le2proc get the p from rq->lab6_run_poll
             (1.2) If using list, we have to search list to find the p with minimum stride value
      * (2) update p;s stride value: p->lab6_stride
      * (3) return p
      */
#if USE_SKEW_HEAP
    if (rq->lab6_run_pool == NULL) return NULL;
    struct proc_struct *proc = le2proc(rq->lab6_run_pool, lab6_run_pool);
#else
    list_entry_t *le = list_next(&(rq->run_list));
    if (le == &rq->run_list) return NULL;
    struct proc_struct *proc = le2proc(le, run_link);
    le = list_next(le);
    while (le != &rq->run_list) {
        struct proc_struct *proc_tmp = le2proc(le, run_link);
        if ((int32_t)(proc->lab6_stride - proc_tmp->lab6_stride) > 0) proc = proc_tmp;
        le = list_next(le);
    }
#endif
    if (proc->lab6_priority == 0) proc->lab6_stride += BIG_STRIDE;  
    else proc->lab6_stride += BIG_STRIDE / proc->lab6_priority;  
    return proc;
}
```

6. 进程更新函数stride\_proc\_tick：每次时钟中断之后应该执行的函数，减小剩余时间片，如果进程剩余的时间为0则将在下一步调用调度器重新选择下一个应该被执行的进程

```c
/*
 * stride_proc_tick works with the tick event of current process. You
 * should check whether the time slices for current process is
 * exhausted and update the proc struct ``proc''. proc->time_slice
 * denotes the time slices left for current
 * process. proc->need_resched is the flag variable for process
 * switching.
 */
static void
stride_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: 2015011372 */
    if (proc->time_slice > 0) {
        proc->time_slice --;
    }
    if (proc->time_slice == 0) {
        proc->need_resched = 1;
    }
}
```

需要使用一个重要的进程比较函数proc\_stride\_comp_f来维护堆

```c
/* The compare function for two skew_heap_node_t's and the
 * corresponding procs*/
static int
proc_stride_comp_f(void *a, void *b)
{
     struct proc_struct *p = le2proc(a, lab6_run_pool);
     struct proc_struct *q = le2proc(b, lab6_run_pool);
     int32_t c = p->lab6_stride - q->lab6_stride;
     if (c > 0) return 1;
     else if (c == 0) return 0;
     else return -1;
}
```

通过设置宏来选择使用堆还是队列实现stride调度算法

```c
#define USE_SKEW_HEAP 1/0
```

本部分实现正确后执行`make grade`会得到满分。

#### 个人思考：Lab6中BIG_STRIDE取值0x7FFFFFFF的理解

在调度比较时，两个进程的uint类型的stride相减转为int类型与0比较，因此必须保证这个int有意义。

首先证明$stride_{max}-stride_{min}\le pass_{max}$，stride可以理解为行走的距离，pass可以理解为步幅大小，在一次完整的调度中，一定有走的最近的人跨上最大的一步追上走的最远的人，否则走的最近的人会连续走两次，即进程被调度两次。

其次$pass_{max}=\frac{stride_{big}}{priority_{min}}\le stride_{big}$，考虑到$priority\ge 1$

故有$stride_{max}-stride_{min}\le stride_{big}$

对于任意两个进程a,b，$|stride_a-stride_b| \le stride_{max}-stride_{min}\le stride_{big}$

那么有$-stride_{big}\le|stride_a-stride_b|\le stride_{big}$

为使上式有意义，必须有$stride_{big}\le int表示最大范围$

故对32位整数，$stride_{big}<=2^{31}-1=0x7FFFFFFF$

## 总结

### 与参考答案区别：

- 练习1：proc->lab6\_run\_pool初始化方式有误，参考答案已改正
- 练习2：只实现了priority\_queue方式，对照答案利用宏同时实现了list方式，发现性能差别很小，因为进程数量较少

### 重要知识点：

- 进程管理
- 进程调度
- Round Robin调度算法
- Stride Scheduling调度算法

### 缺失知识点：

- 优先级反置
- 实时调度和多处理器调度

### 小结：

通过本次试验——调度器，我对进程调度和ucore代码的理解有了质的提高，深入理解了Round Robin调度算法和Stride Scheduling调度算法，对操作系统的认知和热情进一步加深。