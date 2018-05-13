# 操作系统 Lab7 实验报告

###### 张钰晖 计算机系计55班 2015011372 yuhui-zh15@mails.tsinghua.edu.cn

## 练习0.0：填写已有实验

- 复制`kern/debug/kdebug.c`的函数`print_stackframe`
- 复制`kern/trap/trap.c`的函数`idt_init`、`trap_dispatch`。
- 复制`kern/mm/default_pmm.c`的函数`default_init_memmap`、`default_alloc_pages`、`default_free_pages`
- 复制`kern/mm/pmm.c`的函数`get_pte`、`page_remove_pte`、`copy_range`。
- 复制`kern/mm/vmm.c`的函数`do_pgfault`
- 复制`kern/mm/swap_fifo.c`的函数`_fifo_map_swappable`、`_fifo_swap_out_victim`、`load_icode`
- 复制`kern/process/proc.c`的函数`alloc_proc`、`do_fork`。
- 复制整个`kern/schedule/default_sched.c`

## 练习0.1：修改已有实验

为了正确执行lab7的测试应用程序，需要对已完成的实验1/2/3/4/5/6的代码进一步改进。

### `kern/trap/trap.c`中的函数`trap_dispatch`

##### 设计：Lab7中，由于实现了timer机制，需要调度者更新并检查是否时间到期，如到期，唤醒进程。

##### 修改：

```c
static void trap_dispatch(struct trapframe *tf) {
    ...
    case IRQ_OFFSET + IRQ_TIMER:
        /* you should upate you lab6 code
         * IMPORTANT FUNCTIONS:
	     * run_timer_list
         */
        ticks++;
        assert(current != NULL);
        run_timer_list();
        break;
    ...
}
```

## 练习1：理解内核级信号量的实现和基于内核级信号量的哲学家就餐问题

哲学家就餐问题是指：有五个哲学家，他们的生活方式是交替地进行思考和进餐。哲学家们公用一张圆桌，周围放有五把椅子，每人坐一把。在圆桌上有五个碗和五根筷子，当一个哲学家思考时，他不与其他人交谈，饥饿时便试图取用其左、右最靠近他的筷子，但他可能一根都拿不到。只有在他拿到两根筷子时，方能进餐，进餐完后，放下筷子又继续思考。

#### 请在实验报告中给出内核级信号量的设计描述，并说其大致执行流程。

内核级信号量的定义如下，可以看出，内核级信号量包含了值和等待队列两个成员变量：

```c
typedef struct {
    int value;
    wait_queue_t wait_queue;
} semaphore_t;
```

内核级信号量有两个核心操作`up()`和`down()`，分别对应课程讲义中的`V()`和`P()`函数，下面注释解释了两个函数的实现方式：

```c
void up(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    // 在进行up操作（即V操作）的时候，需要关闭中断保证其原子性
    local_intr_save(intr_flag);
    {
        wait_t *wait;
        // 当没有进程希望占用该资源的时候，资源释放
        if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {
            sem->value ++;
        }
        // 有进程希望占用此资源，应该唤醒下一个希望占用该资源的进程
        else {
            assert(wait->proc->wait_state == wait_state);
            wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);
        }
    }
    local_intr_restore(intr_flag);
}

uint32_t down(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    // 在进行down操作（即P操作）的时候，需要关闭中断保证其原子性
    local_intr_save(intr_flag);
    // 如果资源还有剩余，则信号量值减一，可以正常访问资源
    if (sem->value > 0) {
        sem->value --;
        local_intr_restore(intr_flag);
        return 0;
    }
    // 资源没有剩余，需要将当前进程加入信号量的等待队列，并重新调度
    wait_t __wait, *wait = &__wait;
    wait_current_set(&(sem->wait_queue), wait, wait_state);
    local_intr_restore(intr_flag);

    schedule();

    // 阻塞完毕，该进程被重新唤醒调度，说明现在可以使用该资源了。
    local_intr_save(intr_flag);
    wait_current_del(&(sem->wait_queue), wait);
    local_intr_restore(intr_flag);

    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
}
```

在ucore代码中，一个信号量的`value`值始终是大于等于0的。如果该值大于0，则表示该资源还有剩余，可以分配，而等于0则表示该资源已经被分配完，需要等待。而使用了`wait_queue`记录了当前希望访问该资源的进程之后，就可以通过判断该队列是否为空来确定是否已经没有进程需要此资源了，这个时候，`value`的值自然就可以自加了。

通过内核级信号量可以解决哲学家就餐问题，n个内核线程代表n个思考的哲学家。所有哲学家共享临界区信号量`mutex`，这个信号量用于保证哲学家线程在操作`state_sema`数组时不产生冲突，因此在`take_forks`和`put_forks`函数里都需要加锁。另外，使用`s`信号量数组表示每个哲学家是否正在使用叉子进餐，当尝试开始进餐的时候，哲学家会试图取得两个叉子：如果不能取得，则使用`s`信号量进入阻塞状态。而只有当其他的哲学家进餐完毕之后，才会去检查周围的哲学家是否能够进餐，如果可以进餐，则解除`s`信号量引起的阻塞，代码和注释如下。

```c
//---------- philosophers problem using semaphore ----------------------
int state_sema[N]; /* 记录每个人状态的数组 */
/* 信号量是一个特殊的整型变量 */
semaphore_t mutex; /* 临界区互斥 */
semaphore_t s[N]; /* 每个哲学家一个信号量 */

struct proc_struct *philosopher_proc_sema[N];

void phi_test_sema(i) /* i：哲学家号码从0到N-1 */
{ 
    if(state_sema[i]==HUNGRY&&state_sema[LEFT]!=EATING
            &&state_sema[RIGHT]!=EATING)
    {
        state_sema[i]=EATING;
        up(&s[i]);
    }
}

void phi_take_forks_sema(int i) /* i：哲学家号码从0到N-1 */
{ 
        down(&mutex); /* 进入临界区 */
        state_sema[i]=HUNGRY; /* 记录下哲学家i饥饿的事实 */
        phi_test_sema(i); /* 试图得到两只叉子 */
        up(&mutex); /* 离开临界区 */
        down(&s[i]); /* 如果得不到叉子就阻塞 */
}

void phi_put_forks_sema(int i) /* i：哲学家号码从0到N-1 */
{ 
        down(&mutex); /* 进入临界区 */
        state_sema[i]=THINKING; /* 哲学家进餐结束 */
        phi_test_sema(LEFT); /* 看一下左邻居现在是否能进餐 */
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
        up(&mutex); /* 离开临界区 */
}

int philosopher_using_semaphore(void * arg) /* i：哲学家号码，从0到N-1 */
{
    int i, iter=0;
    i=(int)arg;
    cprintf("I am No.%d philosopher_sema\n",i);
    while(iter++<TIMES)
    { /* 无限循环 */
        cprintf("Iter %d, No.%d philosopher_sema is thinking\n",iter,i); /* 哲学家正在思考 */
        do_sleep(SLEEP_TIME);
        phi_take_forks_sema(i); 
        /* 需要两只叉子，或者阻塞 */
        cprintf("Iter %d, No.%d philosopher_sema is eating\n",iter,i); /* 进餐 */
        do_sleep(SLEEP_TIME);
        phi_put_forks_sema(i); 
        /* 把两把叉子同时放回桌子 */
    }
    cprintf("No.%d philosopher_sema quit\n",i);
    return 0;    
}
```

#### 请在实验报告中给出给用户态进程/线程提供信号量机制的设计方案，并比较说明给内核级提供信号量机制的异同。

用户态的进程/线程的信号量的数据结构应和内核级类似，为用户态程序增加三个系统调用，分别如下：

- init：设置sem.value，初始化sem.wait_queue。

- down：相当于信号量的P操作，由操作系统保证原子性。执行了这个系统调用之后应用程序可能会进入阻塞状态。

- up： 相当于V操作，由操作系统保证原子性。 

必须采用系统调用的方式来实现信号量，这是因为信号量原子性的要求以及进程切换的需要。操作系统为了保持PV操作的原子性，必须使用特权指令禁用中断，而这些指令在用户态是无法使用的。此外，如果设计进程切换，在内核态处理也更加方便。 但是频繁的PV操作可能引起过多的系统调用降低效率。

总结来看，用户态进程/线程提供信号量和内核级提供信号量机制有以下异同：

- 异：用户态进程/线程信号量需要通过系统调用实现。
- 同：数据结构和接口类似。 


## 练习2：完成内核级条件变量和基于内核级条件变量的哲学家就餐问题

引入了管程是为了将对共享资源的所有访问及其所需要的同步操作集中并封装起来。Hansan为管程所下的定义：“一个管程定义了一个数据结构和能为并发进程所执行（在该数据结构上）的一组操作，这组操作能同步进程和改变管程中的数据”。有上述定义可知，管程由四部分组成：

- 管程内部的共享变量； 
- 管程内部的条件变量； 
- 管程内部并发执行的进程； 
- 对局部于管程内部的共享数据设置初始值的语句。

局限在管程中的数据结构，只能被局限在管程的操作过程所访问，任何管程之外的操作过程都不能访问它；另一方面，局限在管程中的操作过程也主要访问管程内的数据结构。由此可见，管程相当于一个隔离区，它把共享变量和对它进行操作的若干个过程围了起来，所有进程要访问临界资源时，都必须经过管程才能进入，而管程每次只允许一个进程进入管程，从而需要确保进程之间互斥。

#### 请在实验报告中给出内核级条件变量的设计描述，并说其大致执行流程。

管程的定义如下，管程中的成员变量mutex是一个二值信号量，是实现每次只允许一个进程进入管程的关键元素，确保了互斥访问性质。管程中的条件变量cv通过执行wait_cv，会使得等待某个条件C为真的进程能够离开管程并睡眠，且让其他进程进入管程继续执行；而进入管程的某进程设置条件C为真并执行signal_cv时，能够让等待某个条件C为真的睡眠进程被唤醒，从而继续进入管程中执行。管程中的成员变量信号量next和整形变量next_count是配合进程对条件变量cv的操作而设置的，这是由于发出signal_cv的进程A会唤醒睡眠进程B，进程B执行会导致进程A睡眠，直到进程B离开管程，进程A才能继续执行，这个同步过程是通过信号量next完成的；而next_count表示了由于发出singal_cv而睡眠的进程个数：

```c
typedef struct monitor{
    semaphore_t mutex;      // the mutex lock for going into the routines in monitor, should be initialized to 1
    semaphore_t next;       // the next semaphore is used to down the signaling proc itself, and the other OR wakeuped waiting proc should wake up the sleeped signaling proc.
    int next_count;         // the number of of sleeped signaling proc
    condvar_t *cv;          // the condvars in monitor
} monitor_t;
```

基于管程，内核级条件变量的定义如下，`sem`为条件变量提供了wait和signal的接口，`owner`则代表了该条件变量所处的管程，`count`记录了waiter数量：

```c
typedef struct condvar{
    semaphore_t sem;        // the sem semaphore  is used to down the waiting proc, and the signaling proc should up the waiting proc
    int count;              // the number of waiters on condvar
    monitor_t * owner;      // the owner(monitor) of this condvar
} condvar_t;
```

内核级条件变量有以下两个核心函数`signal`和`wait`，代码实现与注释如下：

```c
// Unlock one of threads waiting on the condition variable. 
void cond_signal (condvar_t *cvp) {
   // 执行了signal操作，需要观察是否有进程等在该条件变量上
   if (cvp->count > 0) {
       // 如果有，则需要转而执行等待的进程，将自己放在特殊的next里面，保证那个进程执行完毕或是wait的时候能切回自己
	   cvp->owner->next_count++;
       // 唤醒所有等待的进程，让他们执行。
	   up(&(cvp->sem));
       // 自己阻塞
	   down(&(cvp->owner->next));
       // 阻塞结束
	   cvp->owner->next_count--;
   }
   // 如果没有，什么也不做
}

// Suspend calling thread on a condition variable waiting for condition Atomically unlocks mutex and suspends calling thread on conditional variable after waking up locks mutex. Notice: mp is mutex semaphore for monitor's procedures
void cond_wait (condvar_t *cvp) {
    // 等待队列长度加1
    cvp->count++;
    // 需要将自己换出，让出管程，但是需要特别判断是否存在next优先进程。
    if (cvp->owner->next_count > 0) {
    	up(&(cvp->owner->next));
    } else {
    	up(&(cvp->owner->mutex));
    }
    // 自己阻塞
    down(&(cvp->sem));
    // 阻塞结束
    cvp->count--;
}
```

通过内核级条件变量，可以解决哲学家就餐问题，当尝试开始进餐的时候，哲学家会试图取得两个叉子，如果不能取得，则使用wait进入阻塞状态。而当其他的哲学家进餐完毕之后，才会去检查周围的哲学家是否能够进餐，如果可以进餐，则解除信号量引起的阻塞，代码和注释如下。

```c
//-----------------philosopher problem using monitor ------------
struct proc_struct *philosopher_proc_condvar[N]; // N philosopher
int state_condvar[N];                            // the philosopher's state: EATING, HUNGARY, THINKING  
monitor_t mt, *mtp=&mt;                          // monitor

void phi_test_condvar (i) { 
    if(state_condvar[i]==HUNGRY&&state_condvar[LEFT]!=EATING
            &&state_condvar[RIGHT]!=EATING) {
        cprintf("phi_test_condvar: state_condvar[%d] will eating\n",i);
        state_condvar[i] = EATING ;
        cprintf("phi_test_condvar: signal self_cv[%d] \n",i);
        cond_signal(&mtp->cv[i]) ;
    }
}

void phi_take_forks_condvar(int i) {
     down(&(mtp->mutex));
//--------into routine in monitor--------------
     state_condvar[i]=HUNGRY; //记录哲学家i是否饥饿
     phi_test_condvar(i); //试图拿到叉子 
     if (state_condvar[i] != EATING) {
         cprintf("phi_take_forks_condvar: %d didn't get fork and will wait\n",i);
         cond_wait(&mtp->cv[i]); //得不到叉子就睡眠
     }
//--------leave routine in monitor--------------
      if(mtp->next_count>0)
         up(&(mtp->next));
      else
         up(&(mtp->mutex));
}

void phi_put_forks_condvar(int i) {
     down(&(mtp->mutex));
//--------into routine in monitor--------------
     // LAB7 EXERCISE1: 2015011372
     // I ate over
     // test left and right neighbors
     state_condvar[i]=THINKING; //记录进餐结束的状态
     phi_test_condvar(LEFT); //看一下左边哲学家现在是否能进餐
     phi_test_condvar(RIGHT); //看一下右边哲学家现在是否能进餐
//--------leave routine in monitor--------------
     if(mtp->next_count>0)
        up(&(mtp->next));
     else
        up(&(mtp->mutex));
}

//---------- philosophers using monitor (condition variable) ----------------------
int philosopher_using_condvar(void * arg) { /* arg is the No. of philosopher 0~N-1*/
  
    int i, iter=0;
    i=(int)arg;
    cprintf("I am No.%d philosopher_condvar\n",i);
    while(iter++<TIMES)
    { /* iterate*/
        cprintf("Iter %d, No.%d philosopher_condvar is thinking\n",iter,i); /* thinking*/
        do_sleep(SLEEP_TIME);
        phi_take_forks_condvar(i); 
        /* need two forks, maybe blocked */
        cprintf("Iter %d, No.%d philosopher_condvar is eating\n",iter,i); /* eating*/
        do_sleep(SLEEP_TIME);
        phi_put_forks_condvar(i); 
        /* return two forks back*/
    }
    cprintf("No.%d philosopher_condvar quit\n",i);
    return 0;    
}
```

其中，每次进入管程和退出管程都需要执行：

```c
down(&(mtp->mutex));
/*
	管程
*/
if(mtp->next_count>0)
   up(&(mtp->next));
else
   up(&(mtp->mutex));
```

才能使得管程机制正常工作。这两句实际上相当于`lock->Acquire()`和`lock->Release()`操作。使得进入管程取得共享资源的仅有一个进程。

#### 请在实验报告中给出给用户态进程/线程提供条件变量机制的设计方案，并比较说明给内核级提供条件变量机制的异同。

根据分析和代码可以看出，`cond_signal`和`cond_wait`导致的阻塞与唤醒都可以由信号量的相关接口进行完成，因此可以借助于之前分析的用户态进程/线程的信号量实现方式，整体数据结构与接口相似。但为了保证原子性，依然需要通过系统调用进入内核态，关闭中断，完成对信号量的PV操作。

- 异：用户态进程/线程条件变量需要通过系统调用实现。
- 同：数据结构和接口类似。 

#### 请在实验报告中回答：能否不用基于信号量机制来完成条件变量？如果不能，请给出理由，如果能，请给出设计说明和具体实现。

我认为可以不用信号量实现，但是需要另外的局部锁机制，需要把`signal`和`wait`等原本需要调用`up`和`down`操作的地方换成关于管程的实现。但没有必要，因为在执行`signal`或是`wait`操作的时候，可以直接通过调用信号量`up`和`down`接口来实现这些功能，使得程序设计更加灵活。

## 总结

### 与参考答案区别：

- 练习1：无需编码
- 练习2：由于提供了伪代码，和答案实现基本相同

### 重要知识点：

- 同步互斥
- 信号量
- 管程和条件变量
- 哲学家就餐问题

### 缺失知识点：

- 原子指令
- 利用原子指令实现同步互斥

### 小结：

通过本次试验——同步互斥，我对同步互斥、信号量与条件变量和ucore代码的理解有了质的提高，深入理解了管程的概念和哲学家就餐问题，对操作系统的认知和热情进一步加深。