
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 18 ea 10 00       	mov    $0x10ea18,%eax
  100010:	89 d1                	mov    %edx,%ecx
  100012:	29 c1                	sub    %eax,%ecx
  100014:	89 c8                	mov    %ecx,%eax
  100016:	89 44 24 08          	mov    %eax,0x8(%esp)
  10001a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100021:	00 
  100022:	c7 04 24 18 ea 10 00 	movl   $0x10ea18,(%esp)
  100029:	e8 dd 33 00 00       	call   10340b <memset>

    cons_init();                // init the console
  10002e:	e8 c7 15 00 00       	call   1015fa <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100033:	c7 45 f4 e0 35 10 00 	movl   $0x1035e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10003a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100041:	c7 04 24 fc 35 10 00 	movl   $0x1035fc,(%esp)
  100048:	e8 ce 02 00 00       	call   10031b <cprintf>

    print_kerninfo();
  10004d:	e8 d8 07 00 00       	call   10082a <print_kerninfo>

    grade_backtrace();
  100052:	e8 86 00 00 00       	call   1000dd <grade_backtrace>

    pmm_init();                 // init physical memory management
  100057:	e8 a1 29 00 00       	call   1029fd <pmm_init>

    pic_init();                 // init interrupt controller
  10005c:	e8 e4 16 00 00       	call   101745 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100061:	e8 5c 18 00 00       	call   1018c2 <idt_init>

    clock_init();               // init clock interrupt
  100066:	e8 e1 0c 00 00       	call   100d4c <clock_init>
    intr_enable();              // enable irq interrupt
  10006b:	e8 3c 16 00 00       	call   1016ac <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100070:	eb fe                	jmp    100070 <kern_init+0x70>

00100072 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100072:	55                   	push   %ebp
  100073:	89 e5                	mov    %esp,%ebp
  100075:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100078:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007f:	00 
  100080:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100087:	00 
  100088:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008f:	e8 e2 0b 00 00       	call   100c76 <mon_backtrace>
}
  100094:	c9                   	leave  
  100095:	c3                   	ret    

00100096 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100096:	55                   	push   %ebp
  100097:	89 e5                	mov    %esp,%ebp
  100099:	53                   	push   %ebx
  10009a:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009d:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a3:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b5:	89 04 24             	mov    %eax,(%esp)
  1000b8:	e8 b5 ff ff ff       	call   100072 <grade_backtrace2>
}
  1000bd:	83 c4 14             	add    $0x14,%esp
  1000c0:	5b                   	pop    %ebx
  1000c1:	5d                   	pop    %ebp
  1000c2:	c3                   	ret    

001000c3 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c3:	55                   	push   %ebp
  1000c4:	89 e5                	mov    %esp,%ebp
  1000c6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c9:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d3:	89 04 24             	mov    %eax,(%esp)
  1000d6:	e8 bb ff ff ff       	call   100096 <grade_backtrace1>
}
  1000db:	c9                   	leave  
  1000dc:	c3                   	ret    

001000dd <grade_backtrace>:

void
grade_backtrace(void) {
  1000dd:	55                   	push   %ebp
  1000de:	89 e5                	mov    %esp,%ebp
  1000e0:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e8:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ef:	ff 
  1000f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000fb:	e8 c3 ff ff ff       	call   1000c3 <grade_backtrace0>
}
  100100:	c9                   	leave  
  100101:	c3                   	ret    

00100102 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100102:	55                   	push   %ebp
  100103:	89 e5                	mov    %esp,%ebp
  100105:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100108:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10010b:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010e:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100111:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100114:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100118:	0f b7 c0             	movzwl %ax,%eax
  10011b:	89 c2                	mov    %eax,%edx
  10011d:	83 e2 03             	and    $0x3,%edx
  100120:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100125:	89 54 24 08          	mov    %edx,0x8(%esp)
  100129:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012d:	c7 04 24 01 36 10 00 	movl   $0x103601,(%esp)
  100134:	e8 e2 01 00 00       	call   10031b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100139:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013d:	0f b7 d0             	movzwl %ax,%edx
  100140:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100145:	89 54 24 08          	mov    %edx,0x8(%esp)
  100149:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014d:	c7 04 24 0f 36 10 00 	movl   $0x10360f,(%esp)
  100154:	e8 c2 01 00 00       	call   10031b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100159:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015d:	0f b7 d0             	movzwl %ax,%edx
  100160:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100165:	89 54 24 08          	mov    %edx,0x8(%esp)
  100169:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016d:	c7 04 24 1d 36 10 00 	movl   $0x10361d,(%esp)
  100174:	e8 a2 01 00 00       	call   10031b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100179:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017d:	0f b7 d0             	movzwl %ax,%edx
  100180:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100185:	89 54 24 08          	mov    %edx,0x8(%esp)
  100189:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018d:	c7 04 24 2b 36 10 00 	movl   $0x10362b,(%esp)
  100194:	e8 82 01 00 00       	call   10031b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100199:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019d:	0f b7 d0             	movzwl %ax,%edx
  1001a0:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ad:	c7 04 24 39 36 10 00 	movl   $0x103639,(%esp)
  1001b4:	e8 62 01 00 00       	call   10031b <cprintf>
    round ++;
  1001b9:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001be:	83 c0 01             	add    $0x1,%eax
  1001c1:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c6:	c9                   	leave  
  1001c7:	c3                   	ret    

001001c8 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c8:	55                   	push   %ebp
  1001c9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001cb:	5d                   	pop    %ebp
  1001cc:	c3                   	ret    

001001cd <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cd:	55                   	push   %ebp
  1001ce:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001d0:	5d                   	pop    %ebp
  1001d1:	c3                   	ret    

001001d2 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d2:	55                   	push   %ebp
  1001d3:	89 e5                	mov    %esp,%ebp
  1001d5:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d8:	e8 25 ff ff ff       	call   100102 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001dd:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  1001e4:	e8 32 01 00 00       	call   10031b <cprintf>
    lab1_switch_to_user();
  1001e9:	e8 da ff ff ff       	call   1001c8 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ee:	e8 0f ff ff ff       	call   100102 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f3:	c7 04 24 68 36 10 00 	movl   $0x103668,(%esp)
  1001fa:	e8 1c 01 00 00       	call   10031b <cprintf>
    lab1_switch_to_kernel();
  1001ff:	e8 c9 ff ff ff       	call   1001cd <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100204:	e8 f9 fe ff ff       	call   100102 <lab1_print_cur_status>
}
  100209:	c9                   	leave  
  10020a:	c3                   	ret    
	...

0010020c <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10020c:	55                   	push   %ebp
  10020d:	89 e5                	mov    %esp,%ebp
  10020f:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100212:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100216:	74 13                	je     10022b <readline+0x1f>
        cprintf("%s", prompt);
  100218:	8b 45 08             	mov    0x8(%ebp),%eax
  10021b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021f:	c7 04 24 87 36 10 00 	movl   $0x103687,(%esp)
  100226:	e8 f0 00 00 00       	call   10031b <cprintf>
    }
    int i = 0, c;
  10022b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100232:	eb 01                	jmp    100235 <readline+0x29>
        else if (c == '\n' || c == '\r') {
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
  100234:	90                   	nop
    if (prompt != NULL) {
        cprintf("%s", prompt);
    }
    int i = 0, c;
    while (1) {
        c = getchar();
  100235:	e8 6e 01 00 00       	call   1003a8 <getchar>
  10023a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10023d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100241:	79 07                	jns    10024a <readline+0x3e>
            return NULL;
  100243:	b8 00 00 00 00       	mov    $0x0,%eax
  100248:	eb 79                	jmp    1002c3 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10024a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10024e:	7e 28                	jle    100278 <readline+0x6c>
  100250:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100257:	7f 1f                	jg     100278 <readline+0x6c>
            cputchar(c);
  100259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10025c:	89 04 24             	mov    %eax,(%esp)
  10025f:	e8 df 00 00 00       	call   100343 <cputchar>
            buf[i ++] = c;
  100264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100267:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10026a:	81 c2 40 ea 10 00    	add    $0x10ea40,%edx
  100270:	88 02                	mov    %al,(%edx)
  100272:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100276:	eb 46                	jmp    1002be <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  100278:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10027c:	75 17                	jne    100295 <readline+0x89>
  10027e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100282:	7e 11                	jle    100295 <readline+0x89>
            cputchar(c);
  100284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100287:	89 04 24             	mov    %eax,(%esp)
  10028a:	e8 b4 00 00 00       	call   100343 <cputchar>
            i --;
  10028f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100293:	eb 29                	jmp    1002be <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  100295:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100299:	74 06                	je     1002a1 <readline+0x95>
  10029b:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10029f:	75 93                	jne    100234 <readline+0x28>
            cputchar(c);
  1002a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a4:	89 04 24             	mov    %eax,(%esp)
  1002a7:	e8 97 00 00 00       	call   100343 <cputchar>
            buf[i] = '\0';
  1002ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002af:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002b4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b7:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002bc:	eb 05                	jmp    1002c3 <readline+0xb7>
        }
    }
  1002be:	e9 71 ff ff ff       	jmp    100234 <readline+0x28>
}
  1002c3:	c9                   	leave  
  1002c4:	c3                   	ret    
  1002c5:	00 00                	add    %al,(%eax)
	...

001002c8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002c8:	55                   	push   %ebp
  1002c9:	89 e5                	mov    %esp,%ebp
  1002cb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d1:	89 04 24             	mov    %eax,(%esp)
  1002d4:	e8 4d 13 00 00       	call   101626 <cons_putc>
    (*cnt) ++;
  1002d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002dc:	8b 00                	mov    (%eax),%eax
  1002de:	8d 50 01             	lea    0x1(%eax),%edx
  1002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e4:	89 10                	mov    %edx,(%eax)
}
  1002e6:	c9                   	leave  
  1002e7:	c3                   	ret    

001002e8 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002e8:	55                   	push   %ebp
  1002e9:	89 e5                	mov    %esp,%ebp
  1002eb:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  100303:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100306:	89 44 24 04          	mov    %eax,0x4(%esp)
  10030a:	c7 04 24 c8 02 10 00 	movl   $0x1002c8,(%esp)
  100311:	e8 f8 28 00 00       	call   102c0e <vprintfmt>
    return cnt;
  100316:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100319:	c9                   	leave  
  10031a:	c3                   	ret    

0010031b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10031b:	55                   	push   %ebp
  10031c:	89 e5                	mov    %esp,%ebp
  10031e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100321:	8d 55 0c             	lea    0xc(%ebp),%edx
  100324:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100327:	89 10                	mov    %edx,(%eax)
    cnt = vcprintf(fmt, ap);
  100329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10032c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100330:	8b 45 08             	mov    0x8(%ebp),%eax
  100333:	89 04 24             	mov    %eax,(%esp)
  100336:	e8 ad ff ff ff       	call   1002e8 <vcprintf>
  10033b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100341:	c9                   	leave  
  100342:	c3                   	ret    

00100343 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100343:	55                   	push   %ebp
  100344:	89 e5                	mov    %esp,%ebp
  100346:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100349:	8b 45 08             	mov    0x8(%ebp),%eax
  10034c:	89 04 24             	mov    %eax,(%esp)
  10034f:	e8 d2 12 00 00       	call   101626 <cons_putc>
}
  100354:	c9                   	leave  
  100355:	c3                   	ret    

00100356 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100356:	55                   	push   %ebp
  100357:	89 e5                	mov    %esp,%ebp
  100359:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10035c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100363:	eb 13                	jmp    100378 <cputs+0x22>
        cputch(c, &cnt);
  100365:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100369:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10036c:	89 54 24 04          	mov    %edx,0x4(%esp)
  100370:	89 04 24             	mov    %eax,(%esp)
  100373:	e8 50 ff ff ff       	call   1002c8 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100378:	8b 45 08             	mov    0x8(%ebp),%eax
  10037b:	0f b6 00             	movzbl (%eax),%eax
  10037e:	88 45 f7             	mov    %al,-0x9(%ebp)
  100381:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100385:	0f 95 c0             	setne  %al
  100388:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10038c:	84 c0                	test   %al,%al
  10038e:	75 d5                	jne    100365 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100390:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100393:	89 44 24 04          	mov    %eax,0x4(%esp)
  100397:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10039e:	e8 25 ff ff ff       	call   1002c8 <cputch>
    return cnt;
  1003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003a6:	c9                   	leave  
  1003a7:	c3                   	ret    

001003a8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003a8:	55                   	push   %ebp
  1003a9:	89 e5                	mov    %esp,%ebp
  1003ab:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ae:	e8 9c 12 00 00       	call   10164f <cons_getc>
  1003b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ba:	74 f2                	je     1003ae <getchar+0x6>
        /* do nothing */;
    return c;
  1003bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003bf:	c9                   	leave  
  1003c0:	c3                   	ret    
  1003c1:	00 00                	add    %al,(%eax)
	...

001003c4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003cd:	8b 00                	mov    (%eax),%eax
  1003cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003d2:	8b 45 10             	mov    0x10(%ebp),%eax
  1003d5:	8b 00                	mov    (%eax),%eax
  1003d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003e1:	e9 c6 00 00 00       	jmp    1004ac <stab_binsearch+0xe8>
        int true_m = (l + r) / 2, m = true_m;
  1003e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003ec:	01 d0                	add    %edx,%eax
  1003ee:	89 c2                	mov    %eax,%edx
  1003f0:	c1 ea 1f             	shr    $0x1f,%edx
  1003f3:	01 d0                	add    %edx,%eax
  1003f5:	d1 f8                	sar    %eax
  1003f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003fd:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100400:	eb 04                	jmp    100406 <stab_binsearch+0x42>
            m --;
  100402:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100409:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10040c:	7c 1b                	jl     100429 <stab_binsearch+0x65>
  10040e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100411:	89 d0                	mov    %edx,%eax
  100413:	01 c0                	add    %eax,%eax
  100415:	01 d0                	add    %edx,%eax
  100417:	c1 e0 02             	shl    $0x2,%eax
  10041a:	03 45 08             	add    0x8(%ebp),%eax
  10041d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100421:	0f b6 c0             	movzbl %al,%eax
  100424:	3b 45 14             	cmp    0x14(%ebp),%eax
  100427:	75 d9                	jne    100402 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10042f:	7d 0b                	jge    10043c <stab_binsearch+0x78>
            l = true_m + 1;
  100431:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100434:	83 c0 01             	add    $0x1,%eax
  100437:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10043a:	eb 70                	jmp    1004ac <stab_binsearch+0xe8>
        }

        // actual binary search
        any_matches = 1;
  10043c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100443:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100446:	89 d0                	mov    %edx,%eax
  100448:	01 c0                	add    %eax,%eax
  10044a:	01 d0                	add    %edx,%eax
  10044c:	c1 e0 02             	shl    $0x2,%eax
  10044f:	03 45 08             	add    0x8(%ebp),%eax
  100452:	8b 40 08             	mov    0x8(%eax),%eax
  100455:	3b 45 18             	cmp    0x18(%ebp),%eax
  100458:	73 13                	jae    10046d <stab_binsearch+0xa9>
            *region_left = m;
  10045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10045d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100460:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100462:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100465:	83 c0 01             	add    $0x1,%eax
  100468:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10046b:	eb 3f                	jmp    1004ac <stab_binsearch+0xe8>
        } else if (stabs[m].n_value > addr) {
  10046d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100470:	89 d0                	mov    %edx,%eax
  100472:	01 c0                	add    %eax,%eax
  100474:	01 d0                	add    %edx,%eax
  100476:	c1 e0 02             	shl    $0x2,%eax
  100479:	03 45 08             	add    0x8(%ebp),%eax
  10047c:	8b 40 08             	mov    0x8(%eax),%eax
  10047f:	3b 45 18             	cmp    0x18(%ebp),%eax
  100482:	76 16                	jbe    10049a <stab_binsearch+0xd6>
            *region_right = m - 1;
  100484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100487:	8d 50 ff             	lea    -0x1(%eax),%edx
  10048a:	8b 45 10             	mov    0x10(%ebp),%eax
  10048d:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100492:	83 e8 01             	sub    $0x1,%eax
  100495:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100498:	eb 12                	jmp    1004ac <stab_binsearch+0xe8>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10049a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004a0:	89 10                	mov    %edx,(%eax)
            l = m;
  1004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004b2:	0f 8e 2e ff ff ff    	jle    1003e6 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004bc:	75 0f                	jne    1004cd <stab_binsearch+0x109>
        *region_right = *region_left - 1;
  1004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c1:	8b 00                	mov    (%eax),%eax
  1004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c9:	89 10                	mov    %edx,(%eax)
  1004cb:	eb 3b                	jmp    100508 <stab_binsearch+0x144>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d0:	8b 00                	mov    (%eax),%eax
  1004d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d5:	eb 04                	jmp    1004db <stab_binsearch+0x117>
  1004d7:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004de:	8b 00                	mov    (%eax),%eax
  1004e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e3:	7d 1b                	jge    100500 <stab_binsearch+0x13c>
  1004e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e8:	89 d0                	mov    %edx,%eax
  1004ea:	01 c0                	add    %eax,%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	c1 e0 02             	shl    $0x2,%eax
  1004f1:	03 45 08             	add    0x8(%ebp),%eax
  1004f4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f8:	0f b6 c0             	movzbl %al,%eax
  1004fb:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fe:	75 d7                	jne    1004d7 <stab_binsearch+0x113>
            /* do nothing */;
        *region_left = l;
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100506:	89 10                	mov    %edx,(%eax)
    }
}
  100508:	c9                   	leave  
  100509:	c3                   	ret    

0010050a <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10050a:	55                   	push   %ebp
  10050b:	89 e5                	mov    %esp,%ebp
  10050d:	53                   	push   %ebx
  10050e:	83 ec 54             	sub    $0x54,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100511:	8b 45 0c             	mov    0xc(%ebp),%eax
  100514:	c7 00 8c 36 10 00    	movl   $0x10368c,(%eax)
    info->eip_line = 0;
  10051a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100524:	8b 45 0c             	mov    0xc(%ebp),%eax
  100527:	c7 40 08 8c 36 10 00 	movl   $0x10368c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100531:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100538:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053b:	8b 55 08             	mov    0x8(%ebp),%edx
  10053e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100541:	8b 45 0c             	mov    0xc(%ebp),%eax
  100544:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10054b:	c7 45 f4 0c 3f 10 00 	movl   $0x103f0c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100552:	c7 45 f0 9c b7 10 00 	movl   $0x10b79c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100559:	c7 45 ec 9d b7 10 00 	movl   $0x10b79d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100560:	c7 45 e8 50 d7 10 00 	movl   $0x10d750,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100567:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10056a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056d:	76 0d                	jbe    10057c <debuginfo_eip+0x72>
  10056f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100572:	83 e8 01             	sub    $0x1,%eax
  100575:	0f b6 00             	movzbl (%eax),%eax
  100578:	84 c0                	test   %al,%al
  10057a:	74 0a                	je     100586 <debuginfo_eip+0x7c>
        return -1;
  10057c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100581:	e9 9e 02 00 00       	jmp    100824 <debuginfo_eip+0x31a>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100586:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100593:	89 d1                	mov    %edx,%ecx
  100595:	29 c1                	sub    %eax,%ecx
  100597:	89 c8                	mov    %ecx,%eax
  100599:	c1 f8 02             	sar    $0x2,%eax
  10059c:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005a2:	83 e8 01             	sub    $0x1,%eax
  1005a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005af:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b6:	00 
  1005b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005be:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c8:	89 04 24             	mov    %eax,(%esp)
  1005cb:	e8 f4 fd ff ff       	call   1003c4 <stab_binsearch>
    if (lfile == 0)
  1005d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005d3:	85 c0                	test   %eax,%eax
  1005d5:	75 0a                	jne    1005e1 <debuginfo_eip+0xd7>
        return -1;
  1005d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005dc:	e9 43 02 00 00       	jmp    100824 <debuginfo_eip+0x31a>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f0:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f4:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005fb:	00 
  1005fc:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  100603:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100606:	89 44 24 04          	mov    %eax,0x4(%esp)
  10060a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10060d:	89 04 24             	mov    %eax,(%esp)
  100610:	e8 af fd ff ff       	call   1003c4 <stab_binsearch>

    if (lfun <= rfun) {
  100615:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100618:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10061b:	39 c2                	cmp    %eax,%edx
  10061d:	7f 72                	jg     100691 <debuginfo_eip+0x187>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100622:	89 c2                	mov    %eax,%edx
  100624:	89 d0                	mov    %edx,%eax
  100626:	01 c0                	add    %eax,%eax
  100628:	01 d0                	add    %edx,%eax
  10062a:	c1 e0 02             	shl    $0x2,%eax
  10062d:	03 45 f4             	add    -0xc(%ebp),%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	89 cb                	mov    %ecx,%ebx
  10063a:	29 c3                	sub    %eax,%ebx
  10063c:	89 d8                	mov    %ebx,%eax
  10063e:	39 c2                	cmp    %eax,%edx
  100640:	73 1e                	jae    100660 <debuginfo_eip+0x156>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100642:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100645:	89 c2                	mov    %eax,%edx
  100647:	89 d0                	mov    %edx,%eax
  100649:	01 c0                	add    %eax,%eax
  10064b:	01 d0                	add    %edx,%eax
  10064d:	c1 e0 02             	shl    $0x2,%eax
  100650:	03 45 f4             	add    -0xc(%ebp),%eax
  100653:	8b 00                	mov    (%eax),%eax
  100655:	89 c2                	mov    %eax,%edx
  100657:	03 55 ec             	add    -0x14(%ebp),%edx
  10065a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065d:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100660:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100663:	89 c2                	mov    %eax,%edx
  100665:	89 d0                	mov    %edx,%eax
  100667:	01 c0                	add    %eax,%eax
  100669:	01 d0                	add    %edx,%eax
  10066b:	c1 e0 02             	shl    $0x2,%eax
  10066e:	03 45 f4             	add    -0xc(%ebp),%eax
  100671:	8b 50 08             	mov    0x8(%eax),%edx
  100674:	8b 45 0c             	mov    0xc(%ebp),%eax
  100677:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	8b 40 10             	mov    0x10(%eax),%eax
  100680:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100683:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100689:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10068c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10068f:	eb 15                	jmp    1006a6 <debuginfo_eip+0x19c>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100691:	8b 45 0c             	mov    0xc(%ebp),%eax
  100694:	8b 55 08             	mov    0x8(%ebp),%edx
  100697:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10069a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10069d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a9:	8b 40 08             	mov    0x8(%eax),%eax
  1006ac:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b3:	00 
  1006b4:	89 04 24             	mov    %eax,(%esp)
  1006b7:	e8 c7 2b 00 00       	call   103283 <strfind>
  1006bc:	89 c2                	mov    %eax,%edx
  1006be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c1:	8b 40 08             	mov    0x8(%eax),%eax
  1006c4:	29 c2                	sub    %eax,%edx
  1006c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006cf:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d3:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006da:	00 
  1006db:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006de:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e2:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ec:	89 04 24             	mov    %eax,(%esp)
  1006ef:	e8 d0 fc ff ff       	call   1003c4 <stab_binsearch>
    if (lline <= rline) {
  1006f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1006fa:	39 c2                	cmp    %eax,%edx
  1006fc:	7f 20                	jg     10071e <debuginfo_eip+0x214>
        info->eip_line = stabs[rline].n_desc;
  1006fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100701:	89 c2                	mov    %eax,%edx
  100703:	89 d0                	mov    %edx,%eax
  100705:	01 c0                	add    %eax,%eax
  100707:	01 d0                	add    %edx,%eax
  100709:	c1 e0 02             	shl    $0x2,%eax
  10070c:	03 45 f4             	add    -0xc(%ebp),%eax
  10070f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100713:	0f b7 d0             	movzwl %ax,%edx
  100716:	8b 45 0c             	mov    0xc(%ebp),%eax
  100719:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10071c:	eb 13                	jmp    100731 <debuginfo_eip+0x227>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10071e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100723:	e9 fc 00 00 00       	jmp    100824 <debuginfo_eip+0x31a>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100728:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10072b:	83 e8 01             	sub    $0x1,%eax
  10072e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100731:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100734:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100737:	39 c2                	cmp    %eax,%edx
  100739:	7c 4a                	jl     100785 <debuginfo_eip+0x27b>
           && stabs[lline].n_type != N_SOL
  10073b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10073e:	89 c2                	mov    %eax,%edx
  100740:	89 d0                	mov    %edx,%eax
  100742:	01 c0                	add    %eax,%eax
  100744:	01 d0                	add    %edx,%eax
  100746:	c1 e0 02             	shl    $0x2,%eax
  100749:	03 45 f4             	add    -0xc(%ebp),%eax
  10074c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100750:	3c 84                	cmp    $0x84,%al
  100752:	74 31                	je     100785 <debuginfo_eip+0x27b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100757:	89 c2                	mov    %eax,%edx
  100759:	89 d0                	mov    %edx,%eax
  10075b:	01 c0                	add    %eax,%eax
  10075d:	01 d0                	add    %edx,%eax
  10075f:	c1 e0 02             	shl    $0x2,%eax
  100762:	03 45 f4             	add    -0xc(%ebp),%eax
  100765:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100769:	3c 64                	cmp    $0x64,%al
  10076b:	75 bb                	jne    100728 <debuginfo_eip+0x21e>
  10076d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	89 d0                	mov    %edx,%eax
  100774:	01 c0                	add    %eax,%eax
  100776:	01 d0                	add    %edx,%eax
  100778:	c1 e0 02             	shl    $0x2,%eax
  10077b:	03 45 f4             	add    -0xc(%ebp),%eax
  10077e:	8b 40 08             	mov    0x8(%eax),%eax
  100781:	85 c0                	test   %eax,%eax
  100783:	74 a3                	je     100728 <debuginfo_eip+0x21e>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100785:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10078b:	39 c2                	cmp    %eax,%edx
  10078d:	7c 40                	jl     1007cf <debuginfo_eip+0x2c5>
  10078f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100792:	89 c2                	mov    %eax,%edx
  100794:	89 d0                	mov    %edx,%eax
  100796:	01 c0                	add    %eax,%eax
  100798:	01 d0                	add    %edx,%eax
  10079a:	c1 e0 02             	shl    $0x2,%eax
  10079d:	03 45 f4             	add    -0xc(%ebp),%eax
  1007a0:	8b 10                	mov    (%eax),%edx
  1007a2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007a8:	89 cb                	mov    %ecx,%ebx
  1007aa:	29 c3                	sub    %eax,%ebx
  1007ac:	89 d8                	mov    %ebx,%eax
  1007ae:	39 c2                	cmp    %eax,%edx
  1007b0:	73 1d                	jae    1007cf <debuginfo_eip+0x2c5>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b5:	89 c2                	mov    %eax,%edx
  1007b7:	89 d0                	mov    %edx,%eax
  1007b9:	01 c0                	add    %eax,%eax
  1007bb:	01 d0                	add    %edx,%eax
  1007bd:	c1 e0 02             	shl    $0x2,%eax
  1007c0:	03 45 f4             	add    -0xc(%ebp),%eax
  1007c3:	8b 00                	mov    (%eax),%eax
  1007c5:	89 c2                	mov    %eax,%edx
  1007c7:	03 55 ec             	add    -0x14(%ebp),%edx
  1007ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cd:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007cf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007d5:	39 c2                	cmp    %eax,%edx
  1007d7:	7d 46                	jge    10081f <debuginfo_eip+0x315>
        for (lline = lfun + 1;
  1007d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007dc:	83 c0 01             	add    $0x1,%eax
  1007df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007e2:	eb 18                	jmp    1007fc <debuginfo_eip+0x2f2>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1007e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e7:	8b 40 14             	mov    0x14(%eax),%eax
  1007ea:	8d 50 01             	lea    0x1(%eax),%edx
  1007ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f0:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1007f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f6:	83 c0 01             	add    $0x1,%eax
  1007f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1007fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100802:	39 c2                	cmp    %eax,%edx
  100804:	7d 19                	jge    10081f <debuginfo_eip+0x315>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100806:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100809:	89 c2                	mov    %eax,%edx
  10080b:	89 d0                	mov    %edx,%eax
  10080d:	01 c0                	add    %eax,%eax
  10080f:	01 d0                	add    %edx,%eax
  100811:	c1 e0 02             	shl    $0x2,%eax
  100814:	03 45 f4             	add    -0xc(%ebp),%eax
  100817:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10081b:	3c a0                	cmp    $0xa0,%al
  10081d:	74 c5                	je     1007e4 <debuginfo_eip+0x2da>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10081f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100824:	83 c4 54             	add    $0x54,%esp
  100827:	5b                   	pop    %ebx
  100828:	5d                   	pop    %ebp
  100829:	c3                   	ret    

0010082a <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10082a:	55                   	push   %ebp
  10082b:	89 e5                	mov    %esp,%ebp
  10082d:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100830:	c7 04 24 96 36 10 00 	movl   $0x103696,(%esp)
  100837:	e8 df fa ff ff       	call   10031b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10083c:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100843:	00 
  100844:	c7 04 24 af 36 10 00 	movl   $0x1036af,(%esp)
  10084b:	e8 cb fa ff ff       	call   10031b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100850:	c7 44 24 04 c3 35 10 	movl   $0x1035c3,0x4(%esp)
  100857:	00 
  100858:	c7 04 24 c7 36 10 00 	movl   $0x1036c7,(%esp)
  10085f:	e8 b7 fa ff ff       	call   10031b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100864:	c7 44 24 04 18 ea 10 	movl   $0x10ea18,0x4(%esp)
  10086b:	00 
  10086c:	c7 04 24 df 36 10 00 	movl   $0x1036df,(%esp)
  100873:	e8 a3 fa ff ff       	call   10031b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100878:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10087f:	00 
  100880:	c7 04 24 f7 36 10 00 	movl   $0x1036f7,(%esp)
  100887:	e8 8f fa ff ff       	call   10031b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10088c:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  100891:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100897:	b8 00 00 10 00       	mov    $0x100000,%eax
  10089c:	89 d1                	mov    %edx,%ecx
  10089e:	29 c1                	sub    %eax,%ecx
  1008a0:	89 c8                	mov    %ecx,%eax
  1008a2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008a8:	85 c0                	test   %eax,%eax
  1008aa:	0f 48 c2             	cmovs  %edx,%eax
  1008ad:	c1 f8 0a             	sar    $0xa,%eax
  1008b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008b4:	c7 04 24 10 37 10 00 	movl   $0x103710,(%esp)
  1008bb:	e8 5b fa ff ff       	call   10031b <cprintf>
}
  1008c0:	c9                   	leave  
  1008c1:	c3                   	ret    

001008c2 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008c2:	55                   	push   %ebp
  1008c3:	89 e5                	mov    %esp,%ebp
  1008c5:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008cb:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1008d5:	89 04 24             	mov    %eax,(%esp)
  1008d8:	e8 2d fc ff ff       	call   10050a <debuginfo_eip>
  1008dd:	85 c0                	test   %eax,%eax
  1008df:	74 15                	je     1008f6 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1008e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008e8:	c7 04 24 3a 37 10 00 	movl   $0x10373a,(%esp)
  1008ef:	e8 27 fa ff ff       	call   10031b <cprintf>
  1008f4:	eb 69                	jmp    10095f <print_debuginfo+0x9d>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1008f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1008fd:	eb 1a                	jmp    100919 <print_debuginfo+0x57>
            fnname[j] = info.eip_fn_name[j];
  1008ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100905:	01 d0                	add    %edx,%eax
  100907:	0f b6 10             	movzbl (%eax),%edx
  10090a:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  100910:	03 45 f4             	add    -0xc(%ebp),%eax
  100913:	88 10                	mov    %dl,(%eax)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100915:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100919:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10091c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10091f:	7f de                	jg     1008ff <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100921:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  100927:	03 45 f4             	add    -0xc(%ebp),%eax
  10092a:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10092d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100930:	8b 55 08             	mov    0x8(%ebp),%edx
  100933:	89 d1                	mov    %edx,%ecx
  100935:	29 c1                	sub    %eax,%ecx
  100937:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10093a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10093d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
                fnname, eip - info.eip_fn_addr);
  100941:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100947:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10094f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100953:	c7 04 24 56 37 10 00 	movl   $0x103756,(%esp)
  10095a:	e8 bc f9 ff ff       	call   10031b <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10095f:	c9                   	leave  
  100960:	c3                   	ret    

00100961 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100961:	55                   	push   %ebp
  100962:	89 e5                	mov    %esp,%ebp
  100964:	53                   	push   %ebx
  100965:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100968:	8b 5d 04             	mov    0x4(%ebp),%ebx
  10096b:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return eip;
  10096e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  100971:	83 c4 10             	add    $0x10,%esp
  100974:	5b                   	pop    %ebx
  100975:	5d                   	pop    %ebp
  100976:	c3                   	ret    

00100977 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100977:	55                   	push   %ebp
  100978:	89 e5                	mov    %esp,%ebp
  10097a:	53                   	push   %ebx
  10097b:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  10097e:	89 eb                	mov    %ebp,%ebx
  100980:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    return ebp;
  100983:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
  100986:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
  100989:	e8 d3 ff ff ff       	call   100961 <read_eip>
  10098e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++) {
  100991:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100998:	e9 8e 00 00 00       	jmp    100a2b <print_stackframe+0xb4>
        cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  10099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ab:	c7 04 24 68 37 10 00 	movl   $0x103768,(%esp)
  1009b2:	e8 64 f9 ff ff       	call   10031b <cprintf>
		uint32_t* args = (uint32_t*)ebp + 2;
  1009b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ba:	83 c0 08             	add    $0x8,%eax
  1009bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int j;
		cprintf("args:");
  1009c0:	c7 04 24 7f 37 10 00 	movl   $0x10377f,(%esp)
  1009c7:	e8 4f f9 ff ff       	call   10031b <cprintf>
		for (j = 0; j < 4; j++) cprintf("0x%08x ", args[j]);
  1009cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009d3:	eb 1f                	jmp    1009f4 <print_stackframe+0x7d>
  1009d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009d8:	c1 e0 02             	shl    $0x2,%eax
  1009db:	03 45 e4             	add    -0x1c(%ebp),%eax
  1009de:	8b 00                	mov    (%eax),%eax
  1009e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009e4:	c7 04 24 85 37 10 00 	movl   $0x103785,(%esp)
  1009eb:	e8 2b f9 ff ff       	call   10031b <cprintf>
  1009f0:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  1009f4:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  1009f8:	7e db                	jle    1009d5 <print_stackframe+0x5e>
		cprintf("\n");
  1009fa:	c7 04 24 8d 37 10 00 	movl   $0x10378d,(%esp)
  100a01:	e8 15 f9 ff ff       	call   10031b <cprintf>
		print_debuginfo(eip - 1);
  100a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a09:	83 e8 01             	sub    $0x1,%eax
  100a0c:	89 04 24             	mov    %eax,(%esp)
  100a0f:	e8 ae fe ff ff       	call   1008c2 <print_debuginfo>
		eip = *((uint32_t*)ebp + 1);
  100a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a17:	83 c0 04             	add    $0x4,%eax
  100a1a:	8b 00                	mov    (%eax),%eax
  100a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t*)ebp);
  100a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a22:	8b 00                	mov    (%eax),%eax
  100a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
    uint32_t eip = read_eip();
    int i;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++) {
  100a27:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a2f:	74 0a                	je     100a3b <print_stackframe+0xc4>
  100a31:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a35:	0f 8e 62 ff ff ff    	jle    10099d <print_stackframe+0x26>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t*)ebp + 1);
		ebp = *((uint32_t*)ebp);
    }
}
  100a3b:	83 c4 34             	add    $0x34,%esp
  100a3e:	5b                   	pop    %ebx
  100a3f:	5d                   	pop    %ebp
  100a40:	c3                   	ret    
  100a41:	00 00                	add    %al,(%eax)
	...

00100a44 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a44:	55                   	push   %ebp
  100a45:	89 e5                	mov    %esp,%ebp
  100a47:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a51:	eb 0d                	jmp    100a60 <parse+0x1c>
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
  100a53:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a54:	eb 0a                	jmp    100a60 <parse+0x1c>
            *buf ++ = '\0';
  100a56:	8b 45 08             	mov    0x8(%ebp),%eax
  100a59:	c6 00 00             	movb   $0x0,(%eax)
  100a5c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a60:	8b 45 08             	mov    0x8(%ebp),%eax
  100a63:	0f b6 00             	movzbl (%eax),%eax
  100a66:	84 c0                	test   %al,%al
  100a68:	74 1d                	je     100a87 <parse+0x43>
  100a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6d:	0f b6 00             	movzbl (%eax),%eax
  100a70:	0f be c0             	movsbl %al,%eax
  100a73:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a77:	c7 04 24 10 38 10 00 	movl   $0x103810,(%esp)
  100a7e:	e8 cd 27 00 00       	call   103250 <strchr>
  100a83:	85 c0                	test   %eax,%eax
  100a85:	75 cf                	jne    100a56 <parse+0x12>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a87:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8a:	0f b6 00             	movzbl (%eax),%eax
  100a8d:	84 c0                	test   %al,%al
  100a8f:	74 5e                	je     100aef <parse+0xab>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a91:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a95:	75 14                	jne    100aab <parse+0x67>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a97:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100a9e:	00 
  100a9f:	c7 04 24 15 38 10 00 	movl   $0x103815,(%esp)
  100aa6:	e8 70 f8 ff ff       	call   10031b <cprintf>
        }
        argv[argc ++] = buf;
  100aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aae:	c1 e0 02             	shl    $0x2,%eax
  100ab1:	03 45 0c             	add    0xc(%ebp),%eax
  100ab4:	8b 55 08             	mov    0x8(%ebp),%edx
  100ab7:	89 10                	mov    %edx,(%eax)
  100ab9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100abd:	eb 04                	jmp    100ac3 <parse+0x7f>
            buf ++;
  100abf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac6:	0f b6 00             	movzbl (%eax),%eax
  100ac9:	84 c0                	test   %al,%al
  100acb:	74 86                	je     100a53 <parse+0xf>
  100acd:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad0:	0f b6 00             	movzbl (%eax),%eax
  100ad3:	0f be c0             	movsbl %al,%eax
  100ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ada:	c7 04 24 10 38 10 00 	movl   $0x103810,(%esp)
  100ae1:	e8 6a 27 00 00       	call   103250 <strchr>
  100ae6:	85 c0                	test   %eax,%eax
  100ae8:	74 d5                	je     100abf <parse+0x7b>
            buf ++;
        }
    }
  100aea:	e9 64 ff ff ff       	jmp    100a53 <parse+0xf>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100aef:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100af3:	c9                   	leave  
  100af4:	c3                   	ret    

00100af5 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100af5:	55                   	push   %ebp
  100af6:	89 e5                	mov    %esp,%ebp
  100af8:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100afb:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b02:	8b 45 08             	mov    0x8(%ebp),%eax
  100b05:	89 04 24             	mov    %eax,(%esp)
  100b08:	e8 37 ff ff ff       	call   100a44 <parse>
  100b0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b14:	75 0a                	jne    100b20 <runcmd+0x2b>
        return 0;
  100b16:	b8 00 00 00 00       	mov    $0x0,%eax
  100b1b:	e9 85 00 00 00       	jmp    100ba5 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b27:	eb 5c                	jmp    100b85 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b29:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b2f:	89 d0                	mov    %edx,%eax
  100b31:	01 c0                	add    %eax,%eax
  100b33:	01 d0                	add    %edx,%eax
  100b35:	c1 e0 02             	shl    $0x2,%eax
  100b38:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b3d:	8b 00                	mov    (%eax),%eax
  100b3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b43:	89 04 24             	mov    %eax,(%esp)
  100b46:	e8 60 26 00 00       	call   1031ab <strcmp>
  100b4b:	85 c0                	test   %eax,%eax
  100b4d:	75 32                	jne    100b81 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b52:	89 d0                	mov    %edx,%eax
  100b54:	01 c0                	add    %eax,%eax
  100b56:	01 d0                	add    %edx,%eax
  100b58:	c1 e0 02             	shl    $0x2,%eax
  100b5b:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b60:	8b 50 08             	mov    0x8(%eax),%edx
  100b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b66:	8d 48 ff             	lea    -0x1(%eax),%ecx
  100b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b70:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b73:	83 c0 04             	add    $0x4,%eax
  100b76:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b7a:	89 0c 24             	mov    %ecx,(%esp)
  100b7d:	ff d2                	call   *%edx
  100b7f:	eb 24                	jmp    100ba5 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b81:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b88:	83 f8 02             	cmp    $0x2,%eax
  100b8b:	76 9c                	jbe    100b29 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b8d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b90:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b94:	c7 04 24 33 38 10 00 	movl   $0x103833,(%esp)
  100b9b:	e8 7b f7 ff ff       	call   10031b <cprintf>
    return 0;
  100ba0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ba5:	c9                   	leave  
  100ba6:	c3                   	ret    

00100ba7 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100ba7:	55                   	push   %ebp
  100ba8:	89 e5                	mov    %esp,%ebp
  100baa:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bad:	c7 04 24 4c 38 10 00 	movl   $0x10384c,(%esp)
  100bb4:	e8 62 f7 ff ff       	call   10031b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bb9:	c7 04 24 74 38 10 00 	movl   $0x103874,(%esp)
  100bc0:	e8 56 f7 ff ff       	call   10031b <cprintf>

    if (tf != NULL) {
  100bc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bc9:	74 0e                	je     100bd9 <kmonitor+0x32>
        print_trapframe(tf);
  100bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  100bce:	89 04 24             	mov    %eax,(%esp)
  100bd1:	e8 a3 0e 00 00       	call   101a79 <print_trapframe>
  100bd6:	eb 01                	jmp    100bd9 <kmonitor+0x32>
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
            }
        }
    }
  100bd8:	90                   	nop
        print_trapframe(tf);
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bd9:	c7 04 24 99 38 10 00 	movl   $0x103899,(%esp)
  100be0:	e8 27 f6 ff ff       	call   10020c <readline>
  100be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100be8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bec:	74 ea                	je     100bd8 <kmonitor+0x31>
            if (runcmd(buf, tf) < 0) {
  100bee:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bf8:	89 04 24             	mov    %eax,(%esp)
  100bfb:	e8 f5 fe ff ff       	call   100af5 <runcmd>
  100c00:	85 c0                	test   %eax,%eax
  100c02:	79 d4                	jns    100bd8 <kmonitor+0x31>
                break;
  100c04:	90                   	nop
            }
        }
    }
}
  100c05:	c9                   	leave  
  100c06:	c3                   	ret    

00100c07 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c07:	55                   	push   %ebp
  100c08:	89 e5                	mov    %esp,%ebp
  100c0a:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c14:	eb 3f                	jmp    100c55 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c19:	89 d0                	mov    %edx,%eax
  100c1b:	01 c0                	add    %eax,%eax
  100c1d:	01 d0                	add    %edx,%eax
  100c1f:	c1 e0 02             	shl    $0x2,%eax
  100c22:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c27:	8b 48 04             	mov    0x4(%eax),%ecx
  100c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c2d:	89 d0                	mov    %edx,%eax
  100c2f:	01 c0                	add    %eax,%eax
  100c31:	01 d0                	add    %edx,%eax
  100c33:	c1 e0 02             	shl    $0x2,%eax
  100c36:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c3b:	8b 00                	mov    (%eax),%eax
  100c3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c45:	c7 04 24 9d 38 10 00 	movl   $0x10389d,(%esp)
  100c4c:	e8 ca f6 ff ff       	call   10031b <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c51:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c58:	83 f8 02             	cmp    $0x2,%eax
  100c5b:	76 b9                	jbe    100c16 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c62:	c9                   	leave  
  100c63:	c3                   	ret    

00100c64 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c64:	55                   	push   %ebp
  100c65:	89 e5                	mov    %esp,%ebp
  100c67:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c6a:	e8 bb fb ff ff       	call   10082a <print_kerninfo>
    return 0;
  100c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c74:	c9                   	leave  
  100c75:	c3                   	ret    

00100c76 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c76:	55                   	push   %ebp
  100c77:	89 e5                	mov    %esp,%ebp
  100c79:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c7c:	e8 f6 fc ff ff       	call   100977 <print_stackframe>
    return 0;
  100c81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c86:	c9                   	leave  
  100c87:	c3                   	ret    

00100c88 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c88:	55                   	push   %ebp
  100c89:	89 e5                	mov    %esp,%ebp
  100c8b:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100c8e:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100c93:	85 c0                	test   %eax,%eax
  100c95:	75 4c                	jne    100ce3 <__panic+0x5b>
        goto panic_dead;
    }
    is_panic = 1;
  100c97:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100c9e:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ca1:	8d 55 14             	lea    0x14(%ebp),%edx
  100ca4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100ca7:	89 10                	mov    %edx,(%eax)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cac:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  100cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb7:	c7 04 24 a6 38 10 00 	movl   $0x1038a6,(%esp)
  100cbe:	e8 58 f6 ff ff       	call   10031b <cprintf>
    vcprintf(fmt, ap);
  100cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cca:	8b 45 10             	mov    0x10(%ebp),%eax
  100ccd:	89 04 24             	mov    %eax,(%esp)
  100cd0:	e8 13 f6 ff ff       	call   1002e8 <vcprintf>
    cprintf("\n");
  100cd5:	c7 04 24 c2 38 10 00 	movl   $0x1038c2,(%esp)
  100cdc:	e8 3a f6 ff ff       	call   10031b <cprintf>
  100ce1:	eb 01                	jmp    100ce4 <__panic+0x5c>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  100ce3:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  100ce4:	e8 c9 09 00 00       	call   1016b2 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100ce9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100cf0:	e8 b2 fe ff ff       	call   100ba7 <kmonitor>
    }
  100cf5:	eb f2                	jmp    100ce9 <__panic+0x61>

00100cf7 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100cf7:	55                   	push   %ebp
  100cf8:	89 e5                	mov    %esp,%ebp
  100cfa:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100cfd:	8d 55 14             	lea    0x14(%ebp),%edx
  100d00:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100d03:	89 10                	mov    %edx,(%eax)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d08:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d13:	c7 04 24 c4 38 10 00 	movl   $0x1038c4,(%esp)
  100d1a:	e8 fc f5 ff ff       	call   10031b <cprintf>
    vcprintf(fmt, ap);
  100d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d22:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d26:	8b 45 10             	mov    0x10(%ebp),%eax
  100d29:	89 04 24             	mov    %eax,(%esp)
  100d2c:	e8 b7 f5 ff ff       	call   1002e8 <vcprintf>
    cprintf("\n");
  100d31:	c7 04 24 c2 38 10 00 	movl   $0x1038c2,(%esp)
  100d38:	e8 de f5 ff ff       	call   10031b <cprintf>
    va_end(ap);
}
  100d3d:	c9                   	leave  
  100d3e:	c3                   	ret    

00100d3f <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d3f:	55                   	push   %ebp
  100d40:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d42:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d47:	5d                   	pop    %ebp
  100d48:	c3                   	ret    
  100d49:	00 00                	add    %al,(%eax)
	...

00100d4c <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d4c:	55                   	push   %ebp
  100d4d:	89 e5                	mov    %esp,%ebp
  100d4f:	83 ec 28             	sub    $0x28,%esp
  100d52:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d58:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d5c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d60:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d64:	ee                   	out    %al,(%dx)
  100d65:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d6b:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d6f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d73:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d77:	ee                   	out    %al,(%dx)
  100d78:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d7e:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d82:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d86:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d8a:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d8b:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d92:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d95:	c7 04 24 e2 38 10 00 	movl   $0x1038e2,(%esp)
  100d9c:	e8 7a f5 ff ff       	call   10031b <cprintf>
    pic_enable(IRQ_TIMER);
  100da1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100da8:	e8 63 09 00 00       	call   101710 <pic_enable>
}
  100dad:	c9                   	leave  
  100dae:	c3                   	ret    
	...

00100db0 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100db0:	55                   	push   %ebp
  100db1:	89 e5                	mov    %esp,%ebp
  100db3:	53                   	push   %ebx
  100db4:	83 ec 14             	sub    $0x14,%esp
  100db7:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dbd:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100dc1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100dc5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100dc9:	ec                   	in     (%dx),%al
  100dca:	89 c3                	mov    %eax,%ebx
  100dcc:	88 5d f9             	mov    %bl,-0x7(%ebp)
    return data;
  100dcf:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dd5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dd9:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100ddd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100de1:	ec                   	in     (%dx),%al
  100de2:	89 c3                	mov    %eax,%ebx
  100de4:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  100de7:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ded:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100df1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100df5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100df9:	ec                   	in     (%dx),%al
  100dfa:	89 c3                	mov    %eax,%ebx
  100dfc:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
  100dff:	66 c7 45 ee 84 00    	movw   $0x84,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e05:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e09:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e0d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e11:	ec                   	in     (%dx),%al
  100e12:	89 c3                	mov    %eax,%ebx
  100e14:	88 5d ed             	mov    %bl,-0x13(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e17:	83 c4 14             	add    $0x14,%esp
  100e1a:	5b                   	pop    %ebx
  100e1b:	5d                   	pop    %ebp
  100e1c:	c3                   	ret    

00100e1d <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e1d:	55                   	push   %ebp
  100e1e:	89 e5                	mov    %esp,%ebp
  100e20:	53                   	push   %ebx
  100e21:	83 ec 24             	sub    $0x24,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e24:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e2e:	0f b7 00             	movzwl (%eax),%eax
  100e31:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e38:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e40:	0f b7 00             	movzwl (%eax),%eax
  100e43:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e47:	74 12                	je     100e5b <cga_init+0x3e>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e49:	c7 45 f8 00 00 0b 00 	movl   $0xb0000,-0x8(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e50:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e57:	b4 03 
  100e59:	eb 13                	jmp    100e6e <cga_init+0x51>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e5e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e62:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e65:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e6c:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e6e:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e75:	0f b7 c0             	movzwl %ax,%eax
  100e78:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e7c:	c6 45 ed 0e          	movb   $0xe,-0x13(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e80:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e84:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e88:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e89:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e90:	83 c0 01             	add    $0x1,%eax
  100e93:	0f b7 c0             	movzwl %ax,%eax
  100e96:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e9a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e9e:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  100ea2:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100ea6:	ec                   	in     (%dx),%al
  100ea7:	89 c3                	mov    %eax,%ebx
  100ea9:	88 5d e9             	mov    %bl,-0x17(%ebp)
    return data;
  100eac:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eb0:	0f b6 c0             	movzbl %al,%eax
  100eb3:	c1 e0 08             	shl    $0x8,%eax
  100eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    outb(addr_6845, 15);
  100eb9:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ec0:	0f b7 c0             	movzwl %ax,%eax
  100ec3:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ec7:	c6 45 e5 0f          	movb   $0xf,-0x1b(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ecb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ecf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ed3:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ed4:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100edb:	83 c0 01             	add    $0x1,%eax
  100ede:	0f b7 c0             	movzwl %ax,%eax
  100ee1:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ee5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100ee9:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  100eed:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100ef1:	ec                   	in     (%dx),%al
  100ef2:	89 c3                	mov    %eax,%ebx
  100ef4:	88 5d e1             	mov    %bl,-0x1f(%ebp)
    return data;
  100ef7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100efb:	0f b6 c0             	movzbl %al,%eax
  100efe:	09 45 f0             	or     %eax,-0x10(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100f04:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100f0c:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100f12:	83 c4 24             	add    $0x24,%esp
  100f15:	5b                   	pop    %ebx
  100f16:	5d                   	pop    %ebp
  100f17:	c3                   	ret    

00100f18 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f18:	55                   	push   %ebp
  100f19:	89 e5                	mov    %esp,%ebp
  100f1b:	53                   	push   %ebx
  100f1c:	83 ec 54             	sub    $0x54,%esp
  100f1f:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f25:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f29:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f2d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f31:	ee                   	out    %al,(%dx)
  100f32:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f38:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f3c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f40:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f44:	ee                   	out    %al,(%dx)
  100f45:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f4b:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f4f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f53:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f57:	ee                   	out    %al,(%dx)
  100f58:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f5e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f62:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f66:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f6a:	ee                   	out    %al,(%dx)
  100f6b:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f71:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f75:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f79:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f7d:	ee                   	out    %al,(%dx)
  100f7e:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f84:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f88:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f8c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f90:	ee                   	out    %al,(%dx)
  100f91:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f97:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f9b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f9f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fa3:	ee                   	out    %al,(%dx)
  100fa4:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100faa:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fae:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  100fb2:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  100fb6:	ec                   	in     (%dx),%al
  100fb7:	89 c3                	mov    %eax,%ebx
  100fb9:	88 5d d9             	mov    %bl,-0x27(%ebp)
    return data;
  100fbc:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fc0:	3c ff                	cmp    $0xff,%al
  100fc2:	0f 95 c0             	setne  %al
  100fc5:	0f b6 c0             	movzbl %al,%eax
  100fc8:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fcd:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fd3:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fd7:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  100fdb:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  100fdf:	ec                   	in     (%dx),%al
  100fe0:	89 c3                	mov    %eax,%ebx
  100fe2:	88 5d d5             	mov    %bl,-0x2b(%ebp)
    return data;
  100fe5:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100feb:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fef:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  100ff3:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  100ff7:	ec                   	in     (%dx),%al
  100ff8:	89 c3                	mov    %eax,%ebx
  100ffa:	88 5d d1             	mov    %bl,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100ffd:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101002:	85 c0                	test   %eax,%eax
  101004:	74 0c                	je     101012 <serial_init+0xfa>
        pic_enable(IRQ_COM1);
  101006:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10100d:	e8 fe 06 00 00       	call   101710 <pic_enable>
    }
}
  101012:	83 c4 54             	add    $0x54,%esp
  101015:	5b                   	pop    %ebx
  101016:	5d                   	pop    %ebp
  101017:	c3                   	ret    

00101018 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101018:	55                   	push   %ebp
  101019:	89 e5                	mov    %esp,%ebp
  10101b:	53                   	push   %ebx
  10101c:	83 ec 24             	sub    $0x24,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10101f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  101026:	eb 09                	jmp    101031 <lpt_putc_sub+0x19>
        delay();
  101028:	e8 83 fd ff ff       	call   100db0 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10102d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  101031:	66 c7 45 f6 79 03    	movw   $0x379,-0xa(%ebp)
  101037:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10103b:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  10103f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101043:	ec                   	in     (%dx),%al
  101044:	89 c3                	mov    %eax,%ebx
  101046:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  101049:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10104d:	84 c0                	test   %al,%al
  10104f:	78 09                	js     10105a <lpt_putc_sub+0x42>
  101051:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
  101058:	7e ce                	jle    101028 <lpt_putc_sub+0x10>
        delay();
    }
    outb(LPTPORT + 0, c);
  10105a:	8b 45 08             	mov    0x8(%ebp),%eax
  10105d:	0f b6 c0             	movzbl %al,%eax
  101060:	66 c7 45 f2 78 03    	movw   $0x378,-0xe(%ebp)
  101066:	88 45 f1             	mov    %al,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101069:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10106d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101071:	ee                   	out    %al,(%dx)
  101072:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101078:	c6 45 ed 0d          	movb   $0xd,-0x13(%ebp)
  10107c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101080:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101084:	ee                   	out    %al,(%dx)
  101085:	66 c7 45 ea 7a 03    	movw   $0x37a,-0x16(%ebp)
  10108b:	c6 45 e9 08          	movb   $0x8,-0x17(%ebp)
  10108f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101093:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101097:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101098:	83 c4 24             	add    $0x24,%esp
  10109b:	5b                   	pop    %ebx
  10109c:	5d                   	pop    %ebp
  10109d:	c3                   	ret    

0010109e <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10109e:	55                   	push   %ebp
  10109f:	89 e5                	mov    %esp,%ebp
  1010a1:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010a4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010a8:	74 0d                	je     1010b7 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ad:	89 04 24             	mov    %eax,(%esp)
  1010b0:	e8 63 ff ff ff       	call   101018 <lpt_putc_sub>
  1010b5:	eb 24                	jmp    1010db <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010b7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010be:	e8 55 ff ff ff       	call   101018 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010c3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010ca:	e8 49 ff ff ff       	call   101018 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010cf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d6:	e8 3d ff ff ff       	call   101018 <lpt_putc_sub>
    }
}
  1010db:	c9                   	leave  
  1010dc:	c3                   	ret    

001010dd <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010dd:	55                   	push   %ebp
  1010de:	89 e5                	mov    %esp,%ebp
  1010e0:	53                   	push   %ebx
  1010e1:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e7:	b0 00                	mov    $0x0,%al
  1010e9:	85 c0                	test   %eax,%eax
  1010eb:	75 07                	jne    1010f4 <cga_putc+0x17>
        c |= 0x0700;
  1010ed:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f7:	25 ff 00 00 00       	and    $0xff,%eax
  1010fc:	83 f8 0a             	cmp    $0xa,%eax
  1010ff:	74 4e                	je     10114f <cga_putc+0x72>
  101101:	83 f8 0d             	cmp    $0xd,%eax
  101104:	74 59                	je     10115f <cga_putc+0x82>
  101106:	83 f8 08             	cmp    $0x8,%eax
  101109:	0f 85 8c 00 00 00    	jne    10119b <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
  10110f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101116:	66 85 c0             	test   %ax,%ax
  101119:	0f 84 a1 00 00 00    	je     1011c0 <cga_putc+0xe3>
            crt_pos --;
  10111f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101126:	83 e8 01             	sub    $0x1,%eax
  101129:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10112f:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101134:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  10113b:	0f b7 d2             	movzwl %dx,%edx
  10113e:	01 d2                	add    %edx,%edx
  101140:	01 c2                	add    %eax,%edx
  101142:	8b 45 08             	mov    0x8(%ebp),%eax
  101145:	b0 00                	mov    $0x0,%al
  101147:	83 c8 20             	or     $0x20,%eax
  10114a:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10114d:	eb 71                	jmp    1011c0 <cga_putc+0xe3>
    case '\n':
        crt_pos += CRT_COLS;
  10114f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101156:	83 c0 50             	add    $0x50,%eax
  101159:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10115f:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101166:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10116d:	0f b7 c1             	movzwl %cx,%eax
  101170:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101176:	c1 e8 10             	shr    $0x10,%eax
  101179:	89 c2                	mov    %eax,%edx
  10117b:	66 c1 ea 06          	shr    $0x6,%dx
  10117f:	89 d0                	mov    %edx,%eax
  101181:	c1 e0 02             	shl    $0x2,%eax
  101184:	01 d0                	add    %edx,%eax
  101186:	c1 e0 04             	shl    $0x4,%eax
  101189:	89 ca                	mov    %ecx,%edx
  10118b:	66 29 c2             	sub    %ax,%dx
  10118e:	89 d8                	mov    %ebx,%eax
  101190:	66 29 d0             	sub    %dx,%ax
  101193:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101199:	eb 26                	jmp    1011c1 <cga_putc+0xe4>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10119b:	8b 15 60 ee 10 00    	mov    0x10ee60,%edx
  1011a1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011a8:	0f b7 c8             	movzwl %ax,%ecx
  1011ab:	01 c9                	add    %ecx,%ecx
  1011ad:	01 d1                	add    %edx,%ecx
  1011af:	8b 55 08             	mov    0x8(%ebp),%edx
  1011b2:	66 89 11             	mov    %dx,(%ecx)
  1011b5:	83 c0 01             	add    $0x1,%eax
  1011b8:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  1011be:	eb 01                	jmp    1011c1 <cga_putc+0xe4>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  1011c0:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011c1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011c8:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011cc:	76 5b                	jbe    101229 <cga_putc+0x14c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011ce:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011d3:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011d9:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011de:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011e5:	00 
  1011e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011ea:	89 04 24             	mov    %eax,(%esp)
  1011ed:	e8 64 22 00 00       	call   103456 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011f2:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011f9:	eb 15                	jmp    101210 <cga_putc+0x133>
            crt_buf[i] = 0x0700 | ' ';
  1011fb:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101200:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101203:	01 d2                	add    %edx,%edx
  101205:	01 d0                	add    %edx,%eax
  101207:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10120c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101210:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101217:	7e e2                	jle    1011fb <cga_putc+0x11e>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101219:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101220:	83 e8 50             	sub    $0x50,%eax
  101223:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101229:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101230:	0f b7 c0             	movzwl %ax,%eax
  101233:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101237:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10123b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10123f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101243:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101244:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10124b:	66 c1 e8 08          	shr    $0x8,%ax
  10124f:	0f b6 c0             	movzbl %al,%eax
  101252:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101259:	83 c2 01             	add    $0x1,%edx
  10125c:	0f b7 d2             	movzwl %dx,%edx
  10125f:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101263:	88 45 ed             	mov    %al,-0x13(%ebp)
  101266:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10126a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10126e:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10126f:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101276:	0f b7 c0             	movzwl %ax,%eax
  101279:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10127d:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101281:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101285:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101289:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10128a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101291:	0f b6 c0             	movzbl %al,%eax
  101294:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10129b:	83 c2 01             	add    $0x1,%edx
  10129e:	0f b7 d2             	movzwl %dx,%edx
  1012a1:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012a5:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012a8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012ac:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012b0:	ee                   	out    %al,(%dx)
}
  1012b1:	83 c4 34             	add    $0x34,%esp
  1012b4:	5b                   	pop    %ebx
  1012b5:	5d                   	pop    %ebp
  1012b6:	c3                   	ret    

001012b7 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012b7:	55                   	push   %ebp
  1012b8:	89 e5                	mov    %esp,%ebp
  1012ba:	53                   	push   %ebx
  1012bb:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  1012c5:	eb 09                	jmp    1012d0 <serial_putc_sub+0x19>
        delay();
  1012c7:	e8 e4 fa ff ff       	call   100db0 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012cc:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  1012d0:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012d6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012da:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012de:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012e2:	ec                   	in     (%dx),%al
  1012e3:	89 c3                	mov    %eax,%ebx
  1012e5:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  1012e8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012ec:	0f b6 c0             	movzbl %al,%eax
  1012ef:	83 e0 20             	and    $0x20,%eax
  1012f2:	85 c0                	test   %eax,%eax
  1012f4:	75 09                	jne    1012ff <serial_putc_sub+0x48>
  1012f6:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
  1012fd:	7e c8                	jle    1012c7 <serial_putc_sub+0x10>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  101302:	0f b6 c0             	movzbl %al,%eax
  101305:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  10130b:	88 45 f1             	mov    %al,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10130e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101312:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101316:	ee                   	out    %al,(%dx)
}
  101317:	83 c4 14             	add    $0x14,%esp
  10131a:	5b                   	pop    %ebx
  10131b:	5d                   	pop    %ebp
  10131c:	c3                   	ret    

0010131d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10131d:	55                   	push   %ebp
  10131e:	89 e5                	mov    %esp,%ebp
  101320:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101323:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101327:	74 0d                	je     101336 <serial_putc+0x19>
        serial_putc_sub(c);
  101329:	8b 45 08             	mov    0x8(%ebp),%eax
  10132c:	89 04 24             	mov    %eax,(%esp)
  10132f:	e8 83 ff ff ff       	call   1012b7 <serial_putc_sub>
  101334:	eb 24                	jmp    10135a <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101336:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133d:	e8 75 ff ff ff       	call   1012b7 <serial_putc_sub>
        serial_putc_sub(' ');
  101342:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101349:	e8 69 ff ff ff       	call   1012b7 <serial_putc_sub>
        serial_putc_sub('\b');
  10134e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101355:	e8 5d ff ff ff       	call   1012b7 <serial_putc_sub>
    }
}
  10135a:	c9                   	leave  
  10135b:	c3                   	ret    

0010135c <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10135c:	55                   	push   %ebp
  10135d:	89 e5                	mov    %esp,%ebp
  10135f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101362:	eb 32                	jmp    101396 <cons_intr+0x3a>
        if (c != 0) {
  101364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101368:	74 2c                	je     101396 <cons_intr+0x3a>
            cons.buf[cons.wpos ++] = c;
  10136a:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10136f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101372:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
  101378:	83 c0 01             	add    $0x1,%eax
  10137b:	a3 84 f0 10 00       	mov    %eax,0x10f084
            if (cons.wpos == CONSBUFSIZE) {
  101380:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101385:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138a:	75 0a                	jne    101396 <cons_intr+0x3a>
                cons.wpos = 0;
  10138c:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101393:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101396:	8b 45 08             	mov    0x8(%ebp),%eax
  101399:	ff d0                	call   *%eax
  10139b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10139e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a2:	75 c0                	jne    101364 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a4:	c9                   	leave  
  1013a5:	c3                   	ret    

001013a6 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a6:	55                   	push   %ebp
  1013a7:	89 e5                	mov    %esp,%ebp
  1013a9:	53                   	push   %ebx
  1013aa:	83 ec 14             	sub    $0x14,%esp
  1013ad:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013b3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1013b7:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1013bb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1013bf:	ec                   	in     (%dx),%al
  1013c0:	89 c3                	mov    %eax,%ebx
  1013c2:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  1013c5:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c9:	0f b6 c0             	movzbl %al,%eax
  1013cc:	83 e0 01             	and    $0x1,%eax
  1013cf:	85 c0                	test   %eax,%eax
  1013d1:	75 07                	jne    1013da <serial_proc_data+0x34>
        return -1;
  1013d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d8:	eb 32                	jmp    10140c <serial_proc_data+0x66>
  1013da:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013e0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1013e4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1013e8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1013ec:	ec                   	in     (%dx),%al
  1013ed:	89 c3                	mov    %eax,%ebx
  1013ef:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
  1013f2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013f6:	0f b6 c0             	movzbl %al,%eax
  1013f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (c == 127) {
  1013fc:	83 7d f8 7f          	cmpl   $0x7f,-0x8(%ebp)
  101400:	75 07                	jne    101409 <serial_proc_data+0x63>
        c = '\b';
  101402:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%ebp)
    }
    return c;
  101409:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10140c:	83 c4 14             	add    $0x14,%esp
  10140f:	5b                   	pop    %ebx
  101410:	5d                   	pop    %ebp
  101411:	c3                   	ret    

00101412 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101412:	55                   	push   %ebp
  101413:	89 e5                	mov    %esp,%ebp
  101415:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101418:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10141d:	85 c0                	test   %eax,%eax
  10141f:	74 0c                	je     10142d <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101421:	c7 04 24 a6 13 10 00 	movl   $0x1013a6,(%esp)
  101428:	e8 2f ff ff ff       	call   10135c <cons_intr>
    }
}
  10142d:	c9                   	leave  
  10142e:	c3                   	ret    

0010142f <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10142f:	55                   	push   %ebp
  101430:	89 e5                	mov    %esp,%ebp
  101432:	53                   	push   %ebx
  101433:	83 ec 44             	sub    $0x44,%esp
  101436:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10143c:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101440:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
  101444:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101448:	ec                   	in     (%dx),%al
  101449:	89 c3                	mov    %eax,%ebx
  10144b:	88 5d ef             	mov    %bl,-0x11(%ebp)
    return data;
  10144e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101452:	0f b6 c0             	movzbl %al,%eax
  101455:	83 e0 01             	and    $0x1,%eax
  101458:	85 c0                	test   %eax,%eax
  10145a:	75 0a                	jne    101466 <kbd_proc_data+0x37>
        return -1;
  10145c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101461:	e9 61 01 00 00       	jmp    1015c7 <kbd_proc_data+0x198>
  101466:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10146c:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101470:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
  101474:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101478:	ec                   	in     (%dx),%al
  101479:	89 c3                	mov    %eax,%ebx
  10147b:	88 5d eb             	mov    %bl,-0x15(%ebp)
    return data;
  10147e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101482:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101485:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101489:	75 17                	jne    1014a2 <kbd_proc_data+0x73>
        // E0 escape character
        shift |= E0ESC;
  10148b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101490:	83 c8 40             	or     $0x40,%eax
  101493:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101498:	b8 00 00 00 00       	mov    $0x0,%eax
  10149d:	e9 25 01 00 00       	jmp    1015c7 <kbd_proc_data+0x198>
    } else if (data & 0x80) {
  1014a2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a6:	84 c0                	test   %al,%al
  1014a8:	79 47                	jns    1014f1 <kbd_proc_data+0xc2>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014aa:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014af:	83 e0 40             	and    $0x40,%eax
  1014b2:	85 c0                	test   %eax,%eax
  1014b4:	75 09                	jne    1014bf <kbd_proc_data+0x90>
  1014b6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ba:	83 e0 7f             	and    $0x7f,%eax
  1014bd:	eb 04                	jmp    1014c3 <kbd_proc_data+0x94>
  1014bf:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c3:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014c6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ca:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014d1:	83 c8 40             	or     $0x40,%eax
  1014d4:	0f b6 c0             	movzbl %al,%eax
  1014d7:	f7 d0                	not    %eax
  1014d9:	89 c2                	mov    %eax,%edx
  1014db:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e0:	21 d0                	and    %edx,%eax
  1014e2:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1014e7:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ec:	e9 d6 00 00 00       	jmp    1015c7 <kbd_proc_data+0x198>
    } else if (shift & E0ESC) {
  1014f1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f6:	83 e0 40             	and    $0x40,%eax
  1014f9:	85 c0                	test   %eax,%eax
  1014fb:	74 11                	je     10150e <kbd_proc_data+0xdf>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014fd:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101501:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101506:	83 e0 bf             	and    $0xffffffbf,%eax
  101509:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10150e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101512:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101519:	0f b6 d0             	movzbl %al,%edx
  10151c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101521:	09 d0                	or     %edx,%eax
  101523:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152c:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101533:	0f b6 d0             	movzbl %al,%edx
  101536:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10153b:	31 d0                	xor    %edx,%eax
  10153d:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  101542:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101547:	83 e0 03             	and    $0x3,%eax
  10154a:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  101551:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101555:	01 d0                	add    %edx,%eax
  101557:	0f b6 00             	movzbl (%eax),%eax
  10155a:	0f b6 c0             	movzbl %al,%eax
  10155d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101560:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101565:	83 e0 08             	and    $0x8,%eax
  101568:	85 c0                	test   %eax,%eax
  10156a:	74 22                	je     10158e <kbd_proc_data+0x15f>
        if ('a' <= c && c <= 'z')
  10156c:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101570:	7e 0c                	jle    10157e <kbd_proc_data+0x14f>
  101572:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101576:	7f 06                	jg     10157e <kbd_proc_data+0x14f>
            c += 'A' - 'a';
  101578:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10157c:	eb 10                	jmp    10158e <kbd_proc_data+0x15f>
        else if ('A' <= c && c <= 'Z')
  10157e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101582:	7e 0a                	jle    10158e <kbd_proc_data+0x15f>
  101584:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101588:	7f 04                	jg     10158e <kbd_proc_data+0x15f>
            c += 'a' - 'A';
  10158a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10158e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101593:	f7 d0                	not    %eax
  101595:	83 e0 06             	and    $0x6,%eax
  101598:	85 c0                	test   %eax,%eax
  10159a:	75 28                	jne    1015c4 <kbd_proc_data+0x195>
  10159c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015a3:	75 1f                	jne    1015c4 <kbd_proc_data+0x195>
        cprintf("Rebooting!\n");
  1015a5:	c7 04 24 fd 38 10 00 	movl   $0x1038fd,(%esp)
  1015ac:	e8 6a ed ff ff       	call   10031b <cprintf>
  1015b1:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015b7:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015bb:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015bf:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015c3:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015c7:	83 c4 44             	add    $0x44,%esp
  1015ca:	5b                   	pop    %ebx
  1015cb:	5d                   	pop    %ebp
  1015cc:	c3                   	ret    

001015cd <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015cd:	55                   	push   %ebp
  1015ce:	89 e5                	mov    %esp,%ebp
  1015d0:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015d3:	c7 04 24 2f 14 10 00 	movl   $0x10142f,(%esp)
  1015da:	e8 7d fd ff ff       	call   10135c <cons_intr>
}
  1015df:	c9                   	leave  
  1015e0:	c3                   	ret    

001015e1 <kbd_init>:

static void
kbd_init(void) {
  1015e1:	55                   	push   %ebp
  1015e2:	89 e5                	mov    %esp,%ebp
  1015e4:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015e7:	e8 e1 ff ff ff       	call   1015cd <kbd_intr>
    pic_enable(IRQ_KBD);
  1015ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015f3:	e8 18 01 00 00       	call   101710 <pic_enable>
}
  1015f8:	c9                   	leave  
  1015f9:	c3                   	ret    

001015fa <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015fa:	55                   	push   %ebp
  1015fb:	89 e5                	mov    %esp,%ebp
  1015fd:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101600:	e8 18 f8 ff ff       	call   100e1d <cga_init>
    serial_init();
  101605:	e8 0e f9 ff ff       	call   100f18 <serial_init>
    kbd_init();
  10160a:	e8 d2 ff ff ff       	call   1015e1 <kbd_init>
    if (!serial_exists) {
  10160f:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101614:	85 c0                	test   %eax,%eax
  101616:	75 0c                	jne    101624 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101618:	c7 04 24 09 39 10 00 	movl   $0x103909,(%esp)
  10161f:	e8 f7 ec ff ff       	call   10031b <cprintf>
    }
}
  101624:	c9                   	leave  
  101625:	c3                   	ret    

00101626 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101626:	55                   	push   %ebp
  101627:	89 e5                	mov    %esp,%ebp
  101629:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  10162c:	8b 45 08             	mov    0x8(%ebp),%eax
  10162f:	89 04 24             	mov    %eax,(%esp)
  101632:	e8 67 fa ff ff       	call   10109e <lpt_putc>
    cga_putc(c);
  101637:	8b 45 08             	mov    0x8(%ebp),%eax
  10163a:	89 04 24             	mov    %eax,(%esp)
  10163d:	e8 9b fa ff ff       	call   1010dd <cga_putc>
    serial_putc(c);
  101642:	8b 45 08             	mov    0x8(%ebp),%eax
  101645:	89 04 24             	mov    %eax,(%esp)
  101648:	e8 d0 fc ff ff       	call   10131d <serial_putc>
}
  10164d:	c9                   	leave  
  10164e:	c3                   	ret    

0010164f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10164f:	55                   	push   %ebp
  101650:	89 e5                	mov    %esp,%ebp
  101652:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101655:	e8 b8 fd ff ff       	call   101412 <serial_intr>
    kbd_intr();
  10165a:	e8 6e ff ff ff       	call   1015cd <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  10165f:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  101665:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10166a:	39 c2                	cmp    %eax,%edx
  10166c:	74 35                	je     1016a3 <cons_getc+0x54>
        c = cons.buf[cons.rpos ++];
  10166e:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101673:	0f b6 90 80 ee 10 00 	movzbl 0x10ee80(%eax),%edx
  10167a:	0f b6 d2             	movzbl %dl,%edx
  10167d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  101680:	83 c0 01             	add    $0x1,%eax
  101683:	a3 80 f0 10 00       	mov    %eax,0x10f080
        if (cons.rpos == CONSBUFSIZE) {
  101688:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10168d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101692:	75 0a                	jne    10169e <cons_getc+0x4f>
            cons.rpos = 0;
  101694:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10169b:	00 00 00 
        }
        return c;
  10169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016a1:	eb 05                	jmp    1016a8 <cons_getc+0x59>
    }
    return 0;
  1016a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1016a8:	c9                   	leave  
  1016a9:	c3                   	ret    
	...

001016ac <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016ac:	55                   	push   %ebp
  1016ad:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016af:	fb                   	sti    
    sti();
}
  1016b0:	5d                   	pop    %ebp
  1016b1:	c3                   	ret    

001016b2 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016b2:	55                   	push   %ebp
  1016b3:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1016b5:	fa                   	cli    
    cli();
}
  1016b6:	5d                   	pop    %ebp
  1016b7:	c3                   	ret    

001016b8 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016b8:	55                   	push   %ebp
  1016b9:	89 e5                	mov    %esp,%ebp
  1016bb:	83 ec 14             	sub    $0x14,%esp
  1016be:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c9:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  1016cf:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  1016d4:	85 c0                	test   %eax,%eax
  1016d6:	74 36                	je     10170e <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016d8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016dc:	0f b6 c0             	movzbl %al,%eax
  1016df:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e5:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016e8:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ec:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016f0:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016f1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f5:	66 c1 e8 08          	shr    $0x8,%ax
  1016f9:	0f b6 c0             	movzbl %al,%eax
  1016fc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101702:	88 45 f9             	mov    %al,-0x7(%ebp)
  101705:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101709:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170d:	ee                   	out    %al,(%dx)
    }
}
  10170e:	c9                   	leave  
  10170f:	c3                   	ret    

00101710 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101710:	55                   	push   %ebp
  101711:	89 e5                	mov    %esp,%ebp
  101713:	53                   	push   %ebx
  101714:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101717:	8b 45 08             	mov    0x8(%ebp),%eax
  10171a:	ba 01 00 00 00       	mov    $0x1,%edx
  10171f:	89 d3                	mov    %edx,%ebx
  101721:	89 c1                	mov    %eax,%ecx
  101723:	d3 e3                	shl    %cl,%ebx
  101725:	89 d8                	mov    %ebx,%eax
  101727:	89 c2                	mov    %eax,%edx
  101729:	f7 d2                	not    %edx
  10172b:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101732:	21 d0                	and    %edx,%eax
  101734:	0f b7 c0             	movzwl %ax,%eax
  101737:	89 04 24             	mov    %eax,(%esp)
  10173a:	e8 79 ff ff ff       	call   1016b8 <pic_setmask>
}
  10173f:	83 c4 04             	add    $0x4,%esp
  101742:	5b                   	pop    %ebx
  101743:	5d                   	pop    %ebp
  101744:	c3                   	ret    

00101745 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101745:	55                   	push   %ebp
  101746:	89 e5                	mov    %esp,%ebp
  101748:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10174b:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  101752:	00 00 00 
  101755:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10175b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10175f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101763:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101767:	ee                   	out    %al,(%dx)
  101768:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10176e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101772:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101776:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10177a:	ee                   	out    %al,(%dx)
  10177b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101781:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101785:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101789:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10178d:	ee                   	out    %al,(%dx)
  10178e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101794:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101798:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10179c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017a0:	ee                   	out    %al,(%dx)
  1017a1:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017a7:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017ab:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017af:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017b3:	ee                   	out    %al,(%dx)
  1017b4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017ba:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017be:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017c2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017c6:	ee                   	out    %al,(%dx)
  1017c7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017cd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017d1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017d5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017d9:	ee                   	out    %al,(%dx)
  1017da:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017e0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017e4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017e8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017ec:	ee                   	out    %al,(%dx)
  1017ed:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017f3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017f7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017fb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017ff:	ee                   	out    %al,(%dx)
  101800:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101806:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10180a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10180e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101812:	ee                   	out    %al,(%dx)
  101813:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101819:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10181d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101821:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101825:	ee                   	out    %al,(%dx)
  101826:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10182c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101830:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101834:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101838:	ee                   	out    %al,(%dx)
  101839:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10183f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101843:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101847:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10184b:	ee                   	out    %al,(%dx)
  10184c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101852:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101856:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10185a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10185e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10185f:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101866:	66 83 f8 ff          	cmp    $0xffff,%ax
  10186a:	74 12                	je     10187e <pic_init+0x139>
        pic_setmask(irq_mask);
  10186c:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101873:	0f b7 c0             	movzwl %ax,%eax
  101876:	89 04 24             	mov    %eax,(%esp)
  101879:	e8 3a fe ff ff       	call   1016b8 <pic_setmask>
    }
}
  10187e:	c9                   	leave  
  10187f:	c3                   	ret    

00101880 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101880:	55                   	push   %ebp
  101881:	89 e5                	mov    %esp,%ebp
  101883:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101886:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10188d:	00 
  10188e:	c7 04 24 40 39 10 00 	movl   $0x103940,(%esp)
  101895:	e8 81 ea ff ff       	call   10031b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10189a:	c7 04 24 4a 39 10 00 	movl   $0x10394a,(%esp)
  1018a1:	e8 75 ea ff ff       	call   10031b <cprintf>
    panic("EOT: kernel seems ok.");
  1018a6:	c7 44 24 08 58 39 10 	movl   $0x103958,0x8(%esp)
  1018ad:	00 
  1018ae:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018b5:	00 
  1018b6:	c7 04 24 6e 39 10 00 	movl   $0x10396e,(%esp)
  1018bd:	e8 c6 f3 ff ff       	call   100c88 <__panic>

001018c2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018c2:	55                   	push   %ebp
  1018c3:	89 e5                	mov    %esp,%ebp
  1018c5:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i++) {
  1018c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018cf:	e9 c3 00 00 00       	jmp    101997 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d7:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018de:	89 c2                	mov    %eax,%edx
  1018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e3:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  1018ea:	00 
  1018eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ee:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  1018f5:	00 08 00 
  1018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fb:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101902:	00 
  101903:	83 e2 e0             	and    $0xffffffe0,%edx
  101906:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10190d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101910:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101917:	00 
  101918:	83 e2 1f             	and    $0x1f,%edx
  10191b:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101922:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101925:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10192c:	00 
  10192d:	83 e2 f0             	and    $0xfffffff0,%edx
  101930:	83 ca 0e             	or     $0xe,%edx
  101933:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10193a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193d:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101944:	00 
  101945:	83 e2 ef             	and    $0xffffffef,%edx
  101948:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101952:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101959:	00 
  10195a:	83 e2 9f             	and    $0xffffff9f,%edx
  10195d:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101964:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101967:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10196e:	00 
  10196f:	83 ca 80             	or     $0xffffff80,%edx
  101972:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101979:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197c:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101983:	c1 e8 10             	shr    $0x10,%eax
  101986:	89 c2                	mov    %eax,%edx
  101988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198b:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101992:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i++) {
  101993:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101997:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  10199e:	0f 8e 30 ff ff ff    	jle    1018d4 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019a4:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1019a9:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  1019af:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  1019b6:	08 00 
  1019b8:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1019bf:	83 e0 e0             	and    $0xffffffe0,%eax
  1019c2:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1019c7:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1019ce:	83 e0 1f             	and    $0x1f,%eax
  1019d1:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1019d6:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019dd:	83 e0 f0             	and    $0xfffffff0,%eax
  1019e0:	83 c8 0e             	or     $0xe,%eax
  1019e3:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019e8:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019ef:	83 e0 ef             	and    $0xffffffef,%eax
  1019f2:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019f7:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019fe:	83 c8 60             	or     $0x60,%eax
  101a01:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101a06:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101a0d:	83 c8 80             	or     $0xffffff80,%eax
  101a10:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101a15:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101a1a:	c1 e8 10             	shr    $0x10,%eax
  101a1d:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101a23:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a2d:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
  101a30:	c9                   	leave  
  101a31:	c3                   	ret    

00101a32 <trapname>:

static const char *
trapname(int trapno) {
  101a32:	55                   	push   %ebp
  101a33:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a35:	8b 45 08             	mov    0x8(%ebp),%eax
  101a38:	83 f8 13             	cmp    $0x13,%eax
  101a3b:	77 0c                	ja     101a49 <trapname+0x17>
        return excnames[trapno];
  101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a40:	8b 04 85 c0 3c 10 00 	mov    0x103cc0(,%eax,4),%eax
  101a47:	eb 18                	jmp    101a61 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a49:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a4d:	7e 0d                	jle    101a5c <trapname+0x2a>
  101a4f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a53:	7f 07                	jg     101a5c <trapname+0x2a>
        return "Hardware Interrupt";
  101a55:	b8 7f 39 10 00       	mov    $0x10397f,%eax
  101a5a:	eb 05                	jmp    101a61 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a5c:	b8 92 39 10 00       	mov    $0x103992,%eax
}
  101a61:	5d                   	pop    %ebp
  101a62:	c3                   	ret    

00101a63 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a63:	55                   	push   %ebp
  101a64:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a66:	8b 45 08             	mov    0x8(%ebp),%eax
  101a69:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a6d:	66 83 f8 08          	cmp    $0x8,%ax
  101a71:	0f 94 c0             	sete   %al
  101a74:	0f b6 c0             	movzbl %al,%eax
}
  101a77:	5d                   	pop    %ebp
  101a78:	c3                   	ret    

00101a79 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a79:	55                   	push   %ebp
  101a7a:	89 e5                	mov    %esp,%ebp
  101a7c:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a86:	c7 04 24 d3 39 10 00 	movl   $0x1039d3,(%esp)
  101a8d:	e8 89 e8 ff ff       	call   10031b <cprintf>
    print_regs(&tf->tf_regs);
  101a92:	8b 45 08             	mov    0x8(%ebp),%eax
  101a95:	89 04 24             	mov    %eax,(%esp)
  101a98:	e8 a1 01 00 00       	call   101c3e <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa0:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101aa4:	0f b7 c0             	movzwl %ax,%eax
  101aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aab:	c7 04 24 e4 39 10 00 	movl   $0x1039e4,(%esp)
  101ab2:	e8 64 e8 ff ff       	call   10031b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aba:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101abe:	0f b7 c0             	movzwl %ax,%eax
  101ac1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac5:	c7 04 24 f7 39 10 00 	movl   $0x1039f7,(%esp)
  101acc:	e8 4a e8 ff ff       	call   10031b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad4:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ad8:	0f b7 c0             	movzwl %ax,%eax
  101adb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101adf:	c7 04 24 0a 3a 10 00 	movl   $0x103a0a,(%esp)
  101ae6:	e8 30 e8 ff ff       	call   10031b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  101aee:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101af2:	0f b7 c0             	movzwl %ax,%eax
  101af5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af9:	c7 04 24 1d 3a 10 00 	movl   $0x103a1d,(%esp)
  101b00:	e8 16 e8 ff ff       	call   10031b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b05:	8b 45 08             	mov    0x8(%ebp),%eax
  101b08:	8b 40 30             	mov    0x30(%eax),%eax
  101b0b:	89 04 24             	mov    %eax,(%esp)
  101b0e:	e8 1f ff ff ff       	call   101a32 <trapname>
  101b13:	8b 55 08             	mov    0x8(%ebp),%edx
  101b16:	8b 52 30             	mov    0x30(%edx),%edx
  101b19:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b1d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b21:	c7 04 24 30 3a 10 00 	movl   $0x103a30,(%esp)
  101b28:	e8 ee e7 ff ff       	call   10031b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b30:	8b 40 34             	mov    0x34(%eax),%eax
  101b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b37:	c7 04 24 42 3a 10 00 	movl   $0x103a42,(%esp)
  101b3e:	e8 d8 e7 ff ff       	call   10031b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b43:	8b 45 08             	mov    0x8(%ebp),%eax
  101b46:	8b 40 38             	mov    0x38(%eax),%eax
  101b49:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4d:	c7 04 24 51 3a 10 00 	movl   $0x103a51,(%esp)
  101b54:	e8 c2 e7 ff ff       	call   10031b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b59:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b60:	0f b7 c0             	movzwl %ax,%eax
  101b63:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b67:	c7 04 24 60 3a 10 00 	movl   $0x103a60,(%esp)
  101b6e:	e8 a8 e7 ff ff       	call   10031b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b73:	8b 45 08             	mov    0x8(%ebp),%eax
  101b76:	8b 40 40             	mov    0x40(%eax),%eax
  101b79:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7d:	c7 04 24 73 3a 10 00 	movl   $0x103a73,(%esp)
  101b84:	e8 92 e7 ff ff       	call   10031b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b90:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b97:	eb 3e                	jmp    101bd7 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b99:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9c:	8b 50 40             	mov    0x40(%eax),%edx
  101b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ba2:	21 d0                	and    %edx,%eax
  101ba4:	85 c0                	test   %eax,%eax
  101ba6:	74 28                	je     101bd0 <print_trapframe+0x157>
  101ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bab:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101bb2:	85 c0                	test   %eax,%eax
  101bb4:	74 1a                	je     101bd0 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb9:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc4:	c7 04 24 82 3a 10 00 	movl   $0x103a82,(%esp)
  101bcb:	e8 4b e7 ff ff       	call   10031b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bd0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bd4:	d1 65 f0             	shll   -0x10(%ebp)
  101bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bda:	83 f8 17             	cmp    $0x17,%eax
  101bdd:	76 ba                	jbe    101b99 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  101be2:	8b 40 40             	mov    0x40(%eax),%eax
  101be5:	25 00 30 00 00       	and    $0x3000,%eax
  101bea:	c1 e8 0c             	shr    $0xc,%eax
  101bed:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf1:	c7 04 24 86 3a 10 00 	movl   $0x103a86,(%esp)
  101bf8:	e8 1e e7 ff ff       	call   10031b <cprintf>

    if (!trap_in_kernel(tf)) {
  101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  101c00:	89 04 24             	mov    %eax,(%esp)
  101c03:	e8 5b fe ff ff       	call   101a63 <trap_in_kernel>
  101c08:	85 c0                	test   %eax,%eax
  101c0a:	75 30                	jne    101c3c <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0f:	8b 40 44             	mov    0x44(%eax),%eax
  101c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c16:	c7 04 24 8f 3a 10 00 	movl   $0x103a8f,(%esp)
  101c1d:	e8 f9 e6 ff ff       	call   10031b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c22:	8b 45 08             	mov    0x8(%ebp),%eax
  101c25:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c29:	0f b7 c0             	movzwl %ax,%eax
  101c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c30:	c7 04 24 9e 3a 10 00 	movl   $0x103a9e,(%esp)
  101c37:	e8 df e6 ff ff       	call   10031b <cprintf>
    }
}
  101c3c:	c9                   	leave  
  101c3d:	c3                   	ret    

00101c3e <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c3e:	55                   	push   %ebp
  101c3f:	89 e5                	mov    %esp,%ebp
  101c41:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c44:	8b 45 08             	mov    0x8(%ebp),%eax
  101c47:	8b 00                	mov    (%eax),%eax
  101c49:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4d:	c7 04 24 b1 3a 10 00 	movl   $0x103ab1,(%esp)
  101c54:	e8 c2 e6 ff ff       	call   10031b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c59:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5c:	8b 40 04             	mov    0x4(%eax),%eax
  101c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c63:	c7 04 24 c0 3a 10 00 	movl   $0x103ac0,(%esp)
  101c6a:	e8 ac e6 ff ff       	call   10031b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c72:	8b 40 08             	mov    0x8(%eax),%eax
  101c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c79:	c7 04 24 cf 3a 10 00 	movl   $0x103acf,(%esp)
  101c80:	e8 96 e6 ff ff       	call   10031b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c85:	8b 45 08             	mov    0x8(%ebp),%eax
  101c88:	8b 40 0c             	mov    0xc(%eax),%eax
  101c8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8f:	c7 04 24 de 3a 10 00 	movl   $0x103ade,(%esp)
  101c96:	e8 80 e6 ff ff       	call   10031b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9e:	8b 40 10             	mov    0x10(%eax),%eax
  101ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca5:	c7 04 24 ed 3a 10 00 	movl   $0x103aed,(%esp)
  101cac:	e8 6a e6 ff ff       	call   10031b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb4:	8b 40 14             	mov    0x14(%eax),%eax
  101cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbb:	c7 04 24 fc 3a 10 00 	movl   $0x103afc,(%esp)
  101cc2:	e8 54 e6 ff ff       	call   10031b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101cca:	8b 40 18             	mov    0x18(%eax),%eax
  101ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd1:	c7 04 24 0b 3b 10 00 	movl   $0x103b0b,(%esp)
  101cd8:	e8 3e e6 ff ff       	call   10031b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce0:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce7:	c7 04 24 1a 3b 10 00 	movl   $0x103b1a,(%esp)
  101cee:	e8 28 e6 ff ff       	call   10031b <cprintf>
}
  101cf3:	c9                   	leave  
  101cf4:	c3                   	ret    

00101cf5 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cf5:	55                   	push   %ebp
  101cf6:	89 e5                	mov    %esp,%ebp
  101cf8:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfe:	8b 40 30             	mov    0x30(%eax),%eax
  101d01:	83 f8 2f             	cmp    $0x2f,%eax
  101d04:	77 21                	ja     101d27 <trap_dispatch+0x32>
  101d06:	83 f8 2e             	cmp    $0x2e,%eax
  101d09:	0f 83 05 01 00 00    	jae    101e14 <trap_dispatch+0x11f>
  101d0f:	83 f8 21             	cmp    $0x21,%eax
  101d12:	0f 84 82 00 00 00    	je     101d9a <trap_dispatch+0xa5>
  101d18:	83 f8 24             	cmp    $0x24,%eax
  101d1b:	74 57                	je     101d74 <trap_dispatch+0x7f>
  101d1d:	83 f8 20             	cmp    $0x20,%eax
  101d20:	74 16                	je     101d38 <trap_dispatch+0x43>
  101d22:	e9 b5 00 00 00       	jmp    101ddc <trap_dispatch+0xe7>
  101d27:	83 e8 78             	sub    $0x78,%eax
  101d2a:	83 f8 01             	cmp    $0x1,%eax
  101d2d:	0f 87 a9 00 00 00    	ja     101ddc <trap_dispatch+0xe7>
  101d33:	e9 88 00 00 00       	jmp    101dc0 <trap_dispatch+0xcb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101d38:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101d3d:	83 c0 01             	add    $0x1,%eax
  101d40:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0) print_ticks();
  101d45:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101d4b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d50:	89 c8                	mov    %ecx,%eax
  101d52:	f7 e2                	mul    %edx
  101d54:	89 d0                	mov    %edx,%eax
  101d56:	c1 e8 05             	shr    $0x5,%eax
  101d59:	6b c0 64             	imul   $0x64,%eax,%eax
  101d5c:	89 ca                	mov    %ecx,%edx
  101d5e:	29 c2                	sub    %eax,%edx
  101d60:	89 d0                	mov    %edx,%eax
  101d62:	85 c0                	test   %eax,%eax
  101d64:	0f 85 ad 00 00 00    	jne    101e17 <trap_dispatch+0x122>
  101d6a:	e8 11 fb ff ff       	call   101880 <print_ticks>
        break;
  101d6f:	e9 a3 00 00 00       	jmp    101e17 <trap_dispatch+0x122>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d74:	e8 d6 f8 ff ff       	call   10164f <cons_getc>
  101d79:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d7c:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d80:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d84:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d8c:	c7 04 24 29 3b 10 00 	movl   $0x103b29,(%esp)
  101d93:	e8 83 e5 ff ff       	call   10031b <cprintf>
        break;
  101d98:	eb 7e                	jmp    101e18 <trap_dispatch+0x123>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d9a:	e8 b0 f8 ff ff       	call   10164f <cons_getc>
  101d9f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101da2:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101da6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101daa:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dae:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db2:	c7 04 24 3b 3b 10 00 	movl   $0x103b3b,(%esp)
  101db9:	e8 5d e5 ff ff       	call   10031b <cprintf>
        break;
  101dbe:	eb 58                	jmp    101e18 <trap_dispatch+0x123>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101dc0:	c7 44 24 08 4a 3b 10 	movl   $0x103b4a,0x8(%esp)
  101dc7:	00 
  101dc8:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  101dcf:	00 
  101dd0:	c7 04 24 6e 39 10 00 	movl   $0x10396e,(%esp)
  101dd7:	e8 ac ee ff ff       	call   100c88 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  101ddf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101de3:	0f b7 c0             	movzwl %ax,%eax
  101de6:	83 e0 03             	and    $0x3,%eax
  101de9:	85 c0                	test   %eax,%eax
  101deb:	75 2b                	jne    101e18 <trap_dispatch+0x123>
            print_trapframe(tf);
  101ded:	8b 45 08             	mov    0x8(%ebp),%eax
  101df0:	89 04 24             	mov    %eax,(%esp)
  101df3:	e8 81 fc ff ff       	call   101a79 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101df8:	c7 44 24 08 5a 3b 10 	movl   $0x103b5a,0x8(%esp)
  101dff:	00 
  101e00:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  101e07:	00 
  101e08:	c7 04 24 6e 39 10 00 	movl   $0x10396e,(%esp)
  101e0f:	e8 74 ee ff ff       	call   100c88 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e14:	90                   	nop
  101e15:	eb 01                	jmp    101e18 <trap_dispatch+0x123>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
        if (ticks % TICK_NUM == 0) print_ticks();
        break;
  101e17:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e18:	c9                   	leave  
  101e19:	c3                   	ret    

00101e1a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e1a:	55                   	push   %ebp
  101e1b:	89 e5                	mov    %esp,%ebp
  101e1d:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e20:	8b 45 08             	mov    0x8(%ebp),%eax
  101e23:	89 04 24             	mov    %eax,(%esp)
  101e26:	e8 ca fe ff ff       	call   101cf5 <trap_dispatch>
}
  101e2b:	c9                   	leave  
  101e2c:	c3                   	ret    
  101e2d:	00 00                	add    %al,(%eax)
	...

00101e30 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e30:	1e                   	push   %ds
    pushl %es
  101e31:	06                   	push   %es
    pushl %fs
  101e32:	0f a0                	push   %fs
    pushl %gs
  101e34:	0f a8                	push   %gs
    pushal
  101e36:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e37:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e3c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e3e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e40:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e41:	e8 d4 ff ff ff       	call   101e1a <trap>

    # pop the pushed stack pointer
    popl %esp
  101e46:	5c                   	pop    %esp

00101e47 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e47:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e48:	0f a9                	pop    %gs
    popl %fs
  101e4a:	0f a1                	pop    %fs
    popl %es
  101e4c:	07                   	pop    %es
    popl %ds
  101e4d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e4e:	83 c4 08             	add    $0x8,%esp
    iret
  101e51:	cf                   	iret   
	...

00101e54 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e54:	6a 00                	push   $0x0
  pushl $0
  101e56:	6a 00                	push   $0x0
  jmp __alltraps
  101e58:	e9 d3 ff ff ff       	jmp    101e30 <__alltraps>

00101e5d <vector1>:
.globl vector1
vector1:
  pushl $0
  101e5d:	6a 00                	push   $0x0
  pushl $1
  101e5f:	6a 01                	push   $0x1
  jmp __alltraps
  101e61:	e9 ca ff ff ff       	jmp    101e30 <__alltraps>

00101e66 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e66:	6a 00                	push   $0x0
  pushl $2
  101e68:	6a 02                	push   $0x2
  jmp __alltraps
  101e6a:	e9 c1 ff ff ff       	jmp    101e30 <__alltraps>

00101e6f <vector3>:
.globl vector3
vector3:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $3
  101e71:	6a 03                	push   $0x3
  jmp __alltraps
  101e73:	e9 b8 ff ff ff       	jmp    101e30 <__alltraps>

00101e78 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $4
  101e7a:	6a 04                	push   $0x4
  jmp __alltraps
  101e7c:	e9 af ff ff ff       	jmp    101e30 <__alltraps>

00101e81 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $5
  101e83:	6a 05                	push   $0x5
  jmp __alltraps
  101e85:	e9 a6 ff ff ff       	jmp    101e30 <__alltraps>

00101e8a <vector6>:
.globl vector6
vector6:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $6
  101e8c:	6a 06                	push   $0x6
  jmp __alltraps
  101e8e:	e9 9d ff ff ff       	jmp    101e30 <__alltraps>

00101e93 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $7
  101e95:	6a 07                	push   $0x7
  jmp __alltraps
  101e97:	e9 94 ff ff ff       	jmp    101e30 <__alltraps>

00101e9c <vector8>:
.globl vector8
vector8:
  pushl $8
  101e9c:	6a 08                	push   $0x8
  jmp __alltraps
  101e9e:	e9 8d ff ff ff       	jmp    101e30 <__alltraps>

00101ea3 <vector9>:
.globl vector9
vector9:
  pushl $0
  101ea3:	6a 00                	push   $0x0
  pushl $9
  101ea5:	6a 09                	push   $0x9
  jmp __alltraps
  101ea7:	e9 84 ff ff ff       	jmp    101e30 <__alltraps>

00101eac <vector10>:
.globl vector10
vector10:
  pushl $10
  101eac:	6a 0a                	push   $0xa
  jmp __alltraps
  101eae:	e9 7d ff ff ff       	jmp    101e30 <__alltraps>

00101eb3 <vector11>:
.globl vector11
vector11:
  pushl $11
  101eb3:	6a 0b                	push   $0xb
  jmp __alltraps
  101eb5:	e9 76 ff ff ff       	jmp    101e30 <__alltraps>

00101eba <vector12>:
.globl vector12
vector12:
  pushl $12
  101eba:	6a 0c                	push   $0xc
  jmp __alltraps
  101ebc:	e9 6f ff ff ff       	jmp    101e30 <__alltraps>

00101ec1 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ec1:	6a 0d                	push   $0xd
  jmp __alltraps
  101ec3:	e9 68 ff ff ff       	jmp    101e30 <__alltraps>

00101ec8 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ec8:	6a 0e                	push   $0xe
  jmp __alltraps
  101eca:	e9 61 ff ff ff       	jmp    101e30 <__alltraps>

00101ecf <vector15>:
.globl vector15
vector15:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $15
  101ed1:	6a 0f                	push   $0xf
  jmp __alltraps
  101ed3:	e9 58 ff ff ff       	jmp    101e30 <__alltraps>

00101ed8 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $16
  101eda:	6a 10                	push   $0x10
  jmp __alltraps
  101edc:	e9 4f ff ff ff       	jmp    101e30 <__alltraps>

00101ee1 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ee1:	6a 11                	push   $0x11
  jmp __alltraps
  101ee3:	e9 48 ff ff ff       	jmp    101e30 <__alltraps>

00101ee8 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ee8:	6a 00                	push   $0x0
  pushl $18
  101eea:	6a 12                	push   $0x12
  jmp __alltraps
  101eec:	e9 3f ff ff ff       	jmp    101e30 <__alltraps>

00101ef1 <vector19>:
.globl vector19
vector19:
  pushl $0
  101ef1:	6a 00                	push   $0x0
  pushl $19
  101ef3:	6a 13                	push   $0x13
  jmp __alltraps
  101ef5:	e9 36 ff ff ff       	jmp    101e30 <__alltraps>

00101efa <vector20>:
.globl vector20
vector20:
  pushl $0
  101efa:	6a 00                	push   $0x0
  pushl $20
  101efc:	6a 14                	push   $0x14
  jmp __alltraps
  101efe:	e9 2d ff ff ff       	jmp    101e30 <__alltraps>

00101f03 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f03:	6a 00                	push   $0x0
  pushl $21
  101f05:	6a 15                	push   $0x15
  jmp __alltraps
  101f07:	e9 24 ff ff ff       	jmp    101e30 <__alltraps>

00101f0c <vector22>:
.globl vector22
vector22:
  pushl $0
  101f0c:	6a 00                	push   $0x0
  pushl $22
  101f0e:	6a 16                	push   $0x16
  jmp __alltraps
  101f10:	e9 1b ff ff ff       	jmp    101e30 <__alltraps>

00101f15 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f15:	6a 00                	push   $0x0
  pushl $23
  101f17:	6a 17                	push   $0x17
  jmp __alltraps
  101f19:	e9 12 ff ff ff       	jmp    101e30 <__alltraps>

00101f1e <vector24>:
.globl vector24
vector24:
  pushl $0
  101f1e:	6a 00                	push   $0x0
  pushl $24
  101f20:	6a 18                	push   $0x18
  jmp __alltraps
  101f22:	e9 09 ff ff ff       	jmp    101e30 <__alltraps>

00101f27 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f27:	6a 00                	push   $0x0
  pushl $25
  101f29:	6a 19                	push   $0x19
  jmp __alltraps
  101f2b:	e9 00 ff ff ff       	jmp    101e30 <__alltraps>

00101f30 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f30:	6a 00                	push   $0x0
  pushl $26
  101f32:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f34:	e9 f7 fe ff ff       	jmp    101e30 <__alltraps>

00101f39 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f39:	6a 00                	push   $0x0
  pushl $27
  101f3b:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f3d:	e9 ee fe ff ff       	jmp    101e30 <__alltraps>

00101f42 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $28
  101f44:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f46:	e9 e5 fe ff ff       	jmp    101e30 <__alltraps>

00101f4b <vector29>:
.globl vector29
vector29:
  pushl $0
  101f4b:	6a 00                	push   $0x0
  pushl $29
  101f4d:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f4f:	e9 dc fe ff ff       	jmp    101e30 <__alltraps>

00101f54 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f54:	6a 00                	push   $0x0
  pushl $30
  101f56:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f58:	e9 d3 fe ff ff       	jmp    101e30 <__alltraps>

00101f5d <vector31>:
.globl vector31
vector31:
  pushl $0
  101f5d:	6a 00                	push   $0x0
  pushl $31
  101f5f:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f61:	e9 ca fe ff ff       	jmp    101e30 <__alltraps>

00101f66 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f66:	6a 00                	push   $0x0
  pushl $32
  101f68:	6a 20                	push   $0x20
  jmp __alltraps
  101f6a:	e9 c1 fe ff ff       	jmp    101e30 <__alltraps>

00101f6f <vector33>:
.globl vector33
vector33:
  pushl $0
  101f6f:	6a 00                	push   $0x0
  pushl $33
  101f71:	6a 21                	push   $0x21
  jmp __alltraps
  101f73:	e9 b8 fe ff ff       	jmp    101e30 <__alltraps>

00101f78 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f78:	6a 00                	push   $0x0
  pushl $34
  101f7a:	6a 22                	push   $0x22
  jmp __alltraps
  101f7c:	e9 af fe ff ff       	jmp    101e30 <__alltraps>

00101f81 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f81:	6a 00                	push   $0x0
  pushl $35
  101f83:	6a 23                	push   $0x23
  jmp __alltraps
  101f85:	e9 a6 fe ff ff       	jmp    101e30 <__alltraps>

00101f8a <vector36>:
.globl vector36
vector36:
  pushl $0
  101f8a:	6a 00                	push   $0x0
  pushl $36
  101f8c:	6a 24                	push   $0x24
  jmp __alltraps
  101f8e:	e9 9d fe ff ff       	jmp    101e30 <__alltraps>

00101f93 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f93:	6a 00                	push   $0x0
  pushl $37
  101f95:	6a 25                	push   $0x25
  jmp __alltraps
  101f97:	e9 94 fe ff ff       	jmp    101e30 <__alltraps>

00101f9c <vector38>:
.globl vector38
vector38:
  pushl $0
  101f9c:	6a 00                	push   $0x0
  pushl $38
  101f9e:	6a 26                	push   $0x26
  jmp __alltraps
  101fa0:	e9 8b fe ff ff       	jmp    101e30 <__alltraps>

00101fa5 <vector39>:
.globl vector39
vector39:
  pushl $0
  101fa5:	6a 00                	push   $0x0
  pushl $39
  101fa7:	6a 27                	push   $0x27
  jmp __alltraps
  101fa9:	e9 82 fe ff ff       	jmp    101e30 <__alltraps>

00101fae <vector40>:
.globl vector40
vector40:
  pushl $0
  101fae:	6a 00                	push   $0x0
  pushl $40
  101fb0:	6a 28                	push   $0x28
  jmp __alltraps
  101fb2:	e9 79 fe ff ff       	jmp    101e30 <__alltraps>

00101fb7 <vector41>:
.globl vector41
vector41:
  pushl $0
  101fb7:	6a 00                	push   $0x0
  pushl $41
  101fb9:	6a 29                	push   $0x29
  jmp __alltraps
  101fbb:	e9 70 fe ff ff       	jmp    101e30 <__alltraps>

00101fc0 <vector42>:
.globl vector42
vector42:
  pushl $0
  101fc0:	6a 00                	push   $0x0
  pushl $42
  101fc2:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fc4:	e9 67 fe ff ff       	jmp    101e30 <__alltraps>

00101fc9 <vector43>:
.globl vector43
vector43:
  pushl $0
  101fc9:	6a 00                	push   $0x0
  pushl $43
  101fcb:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fcd:	e9 5e fe ff ff       	jmp    101e30 <__alltraps>

00101fd2 <vector44>:
.globl vector44
vector44:
  pushl $0
  101fd2:	6a 00                	push   $0x0
  pushl $44
  101fd4:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fd6:	e9 55 fe ff ff       	jmp    101e30 <__alltraps>

00101fdb <vector45>:
.globl vector45
vector45:
  pushl $0
  101fdb:	6a 00                	push   $0x0
  pushl $45
  101fdd:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fdf:	e9 4c fe ff ff       	jmp    101e30 <__alltraps>

00101fe4 <vector46>:
.globl vector46
vector46:
  pushl $0
  101fe4:	6a 00                	push   $0x0
  pushl $46
  101fe6:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fe8:	e9 43 fe ff ff       	jmp    101e30 <__alltraps>

00101fed <vector47>:
.globl vector47
vector47:
  pushl $0
  101fed:	6a 00                	push   $0x0
  pushl $47
  101fef:	6a 2f                	push   $0x2f
  jmp __alltraps
  101ff1:	e9 3a fe ff ff       	jmp    101e30 <__alltraps>

00101ff6 <vector48>:
.globl vector48
vector48:
  pushl $0
  101ff6:	6a 00                	push   $0x0
  pushl $48
  101ff8:	6a 30                	push   $0x30
  jmp __alltraps
  101ffa:	e9 31 fe ff ff       	jmp    101e30 <__alltraps>

00101fff <vector49>:
.globl vector49
vector49:
  pushl $0
  101fff:	6a 00                	push   $0x0
  pushl $49
  102001:	6a 31                	push   $0x31
  jmp __alltraps
  102003:	e9 28 fe ff ff       	jmp    101e30 <__alltraps>

00102008 <vector50>:
.globl vector50
vector50:
  pushl $0
  102008:	6a 00                	push   $0x0
  pushl $50
  10200a:	6a 32                	push   $0x32
  jmp __alltraps
  10200c:	e9 1f fe ff ff       	jmp    101e30 <__alltraps>

00102011 <vector51>:
.globl vector51
vector51:
  pushl $0
  102011:	6a 00                	push   $0x0
  pushl $51
  102013:	6a 33                	push   $0x33
  jmp __alltraps
  102015:	e9 16 fe ff ff       	jmp    101e30 <__alltraps>

0010201a <vector52>:
.globl vector52
vector52:
  pushl $0
  10201a:	6a 00                	push   $0x0
  pushl $52
  10201c:	6a 34                	push   $0x34
  jmp __alltraps
  10201e:	e9 0d fe ff ff       	jmp    101e30 <__alltraps>

00102023 <vector53>:
.globl vector53
vector53:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $53
  102025:	6a 35                	push   $0x35
  jmp __alltraps
  102027:	e9 04 fe ff ff       	jmp    101e30 <__alltraps>

0010202c <vector54>:
.globl vector54
vector54:
  pushl $0
  10202c:	6a 00                	push   $0x0
  pushl $54
  10202e:	6a 36                	push   $0x36
  jmp __alltraps
  102030:	e9 fb fd ff ff       	jmp    101e30 <__alltraps>

00102035 <vector55>:
.globl vector55
vector55:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $55
  102037:	6a 37                	push   $0x37
  jmp __alltraps
  102039:	e9 f2 fd ff ff       	jmp    101e30 <__alltraps>

0010203e <vector56>:
.globl vector56
vector56:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $56
  102040:	6a 38                	push   $0x38
  jmp __alltraps
  102042:	e9 e9 fd ff ff       	jmp    101e30 <__alltraps>

00102047 <vector57>:
.globl vector57
vector57:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $57
  102049:	6a 39                	push   $0x39
  jmp __alltraps
  10204b:	e9 e0 fd ff ff       	jmp    101e30 <__alltraps>

00102050 <vector58>:
.globl vector58
vector58:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $58
  102052:	6a 3a                	push   $0x3a
  jmp __alltraps
  102054:	e9 d7 fd ff ff       	jmp    101e30 <__alltraps>

00102059 <vector59>:
.globl vector59
vector59:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $59
  10205b:	6a 3b                	push   $0x3b
  jmp __alltraps
  10205d:	e9 ce fd ff ff       	jmp    101e30 <__alltraps>

00102062 <vector60>:
.globl vector60
vector60:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $60
  102064:	6a 3c                	push   $0x3c
  jmp __alltraps
  102066:	e9 c5 fd ff ff       	jmp    101e30 <__alltraps>

0010206b <vector61>:
.globl vector61
vector61:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $61
  10206d:	6a 3d                	push   $0x3d
  jmp __alltraps
  10206f:	e9 bc fd ff ff       	jmp    101e30 <__alltraps>

00102074 <vector62>:
.globl vector62
vector62:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $62
  102076:	6a 3e                	push   $0x3e
  jmp __alltraps
  102078:	e9 b3 fd ff ff       	jmp    101e30 <__alltraps>

0010207d <vector63>:
.globl vector63
vector63:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $63
  10207f:	6a 3f                	push   $0x3f
  jmp __alltraps
  102081:	e9 aa fd ff ff       	jmp    101e30 <__alltraps>

00102086 <vector64>:
.globl vector64
vector64:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $64
  102088:	6a 40                	push   $0x40
  jmp __alltraps
  10208a:	e9 a1 fd ff ff       	jmp    101e30 <__alltraps>

0010208f <vector65>:
.globl vector65
vector65:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $65
  102091:	6a 41                	push   $0x41
  jmp __alltraps
  102093:	e9 98 fd ff ff       	jmp    101e30 <__alltraps>

00102098 <vector66>:
.globl vector66
vector66:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $66
  10209a:	6a 42                	push   $0x42
  jmp __alltraps
  10209c:	e9 8f fd ff ff       	jmp    101e30 <__alltraps>

001020a1 <vector67>:
.globl vector67
vector67:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $67
  1020a3:	6a 43                	push   $0x43
  jmp __alltraps
  1020a5:	e9 86 fd ff ff       	jmp    101e30 <__alltraps>

001020aa <vector68>:
.globl vector68
vector68:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $68
  1020ac:	6a 44                	push   $0x44
  jmp __alltraps
  1020ae:	e9 7d fd ff ff       	jmp    101e30 <__alltraps>

001020b3 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $69
  1020b5:	6a 45                	push   $0x45
  jmp __alltraps
  1020b7:	e9 74 fd ff ff       	jmp    101e30 <__alltraps>

001020bc <vector70>:
.globl vector70
vector70:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $70
  1020be:	6a 46                	push   $0x46
  jmp __alltraps
  1020c0:	e9 6b fd ff ff       	jmp    101e30 <__alltraps>

001020c5 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $71
  1020c7:	6a 47                	push   $0x47
  jmp __alltraps
  1020c9:	e9 62 fd ff ff       	jmp    101e30 <__alltraps>

001020ce <vector72>:
.globl vector72
vector72:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $72
  1020d0:	6a 48                	push   $0x48
  jmp __alltraps
  1020d2:	e9 59 fd ff ff       	jmp    101e30 <__alltraps>

001020d7 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $73
  1020d9:	6a 49                	push   $0x49
  jmp __alltraps
  1020db:	e9 50 fd ff ff       	jmp    101e30 <__alltraps>

001020e0 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $74
  1020e2:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020e4:	e9 47 fd ff ff       	jmp    101e30 <__alltraps>

001020e9 <vector75>:
.globl vector75
vector75:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $75
  1020eb:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020ed:	e9 3e fd ff ff       	jmp    101e30 <__alltraps>

001020f2 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $76
  1020f4:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020f6:	e9 35 fd ff ff       	jmp    101e30 <__alltraps>

001020fb <vector77>:
.globl vector77
vector77:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $77
  1020fd:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020ff:	e9 2c fd ff ff       	jmp    101e30 <__alltraps>

00102104 <vector78>:
.globl vector78
vector78:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $78
  102106:	6a 4e                	push   $0x4e
  jmp __alltraps
  102108:	e9 23 fd ff ff       	jmp    101e30 <__alltraps>

0010210d <vector79>:
.globl vector79
vector79:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $79
  10210f:	6a 4f                	push   $0x4f
  jmp __alltraps
  102111:	e9 1a fd ff ff       	jmp    101e30 <__alltraps>

00102116 <vector80>:
.globl vector80
vector80:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $80
  102118:	6a 50                	push   $0x50
  jmp __alltraps
  10211a:	e9 11 fd ff ff       	jmp    101e30 <__alltraps>

0010211f <vector81>:
.globl vector81
vector81:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $81
  102121:	6a 51                	push   $0x51
  jmp __alltraps
  102123:	e9 08 fd ff ff       	jmp    101e30 <__alltraps>

00102128 <vector82>:
.globl vector82
vector82:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $82
  10212a:	6a 52                	push   $0x52
  jmp __alltraps
  10212c:	e9 ff fc ff ff       	jmp    101e30 <__alltraps>

00102131 <vector83>:
.globl vector83
vector83:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $83
  102133:	6a 53                	push   $0x53
  jmp __alltraps
  102135:	e9 f6 fc ff ff       	jmp    101e30 <__alltraps>

0010213a <vector84>:
.globl vector84
vector84:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $84
  10213c:	6a 54                	push   $0x54
  jmp __alltraps
  10213e:	e9 ed fc ff ff       	jmp    101e30 <__alltraps>

00102143 <vector85>:
.globl vector85
vector85:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $85
  102145:	6a 55                	push   $0x55
  jmp __alltraps
  102147:	e9 e4 fc ff ff       	jmp    101e30 <__alltraps>

0010214c <vector86>:
.globl vector86
vector86:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $86
  10214e:	6a 56                	push   $0x56
  jmp __alltraps
  102150:	e9 db fc ff ff       	jmp    101e30 <__alltraps>

00102155 <vector87>:
.globl vector87
vector87:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $87
  102157:	6a 57                	push   $0x57
  jmp __alltraps
  102159:	e9 d2 fc ff ff       	jmp    101e30 <__alltraps>

0010215e <vector88>:
.globl vector88
vector88:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $88
  102160:	6a 58                	push   $0x58
  jmp __alltraps
  102162:	e9 c9 fc ff ff       	jmp    101e30 <__alltraps>

00102167 <vector89>:
.globl vector89
vector89:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $89
  102169:	6a 59                	push   $0x59
  jmp __alltraps
  10216b:	e9 c0 fc ff ff       	jmp    101e30 <__alltraps>

00102170 <vector90>:
.globl vector90
vector90:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $90
  102172:	6a 5a                	push   $0x5a
  jmp __alltraps
  102174:	e9 b7 fc ff ff       	jmp    101e30 <__alltraps>

00102179 <vector91>:
.globl vector91
vector91:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $91
  10217b:	6a 5b                	push   $0x5b
  jmp __alltraps
  10217d:	e9 ae fc ff ff       	jmp    101e30 <__alltraps>

00102182 <vector92>:
.globl vector92
vector92:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $92
  102184:	6a 5c                	push   $0x5c
  jmp __alltraps
  102186:	e9 a5 fc ff ff       	jmp    101e30 <__alltraps>

0010218b <vector93>:
.globl vector93
vector93:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $93
  10218d:	6a 5d                	push   $0x5d
  jmp __alltraps
  10218f:	e9 9c fc ff ff       	jmp    101e30 <__alltraps>

00102194 <vector94>:
.globl vector94
vector94:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $94
  102196:	6a 5e                	push   $0x5e
  jmp __alltraps
  102198:	e9 93 fc ff ff       	jmp    101e30 <__alltraps>

0010219d <vector95>:
.globl vector95
vector95:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $95
  10219f:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021a1:	e9 8a fc ff ff       	jmp    101e30 <__alltraps>

001021a6 <vector96>:
.globl vector96
vector96:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $96
  1021a8:	6a 60                	push   $0x60
  jmp __alltraps
  1021aa:	e9 81 fc ff ff       	jmp    101e30 <__alltraps>

001021af <vector97>:
.globl vector97
vector97:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $97
  1021b1:	6a 61                	push   $0x61
  jmp __alltraps
  1021b3:	e9 78 fc ff ff       	jmp    101e30 <__alltraps>

001021b8 <vector98>:
.globl vector98
vector98:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $98
  1021ba:	6a 62                	push   $0x62
  jmp __alltraps
  1021bc:	e9 6f fc ff ff       	jmp    101e30 <__alltraps>

001021c1 <vector99>:
.globl vector99
vector99:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $99
  1021c3:	6a 63                	push   $0x63
  jmp __alltraps
  1021c5:	e9 66 fc ff ff       	jmp    101e30 <__alltraps>

001021ca <vector100>:
.globl vector100
vector100:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $100
  1021cc:	6a 64                	push   $0x64
  jmp __alltraps
  1021ce:	e9 5d fc ff ff       	jmp    101e30 <__alltraps>

001021d3 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $101
  1021d5:	6a 65                	push   $0x65
  jmp __alltraps
  1021d7:	e9 54 fc ff ff       	jmp    101e30 <__alltraps>

001021dc <vector102>:
.globl vector102
vector102:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $102
  1021de:	6a 66                	push   $0x66
  jmp __alltraps
  1021e0:	e9 4b fc ff ff       	jmp    101e30 <__alltraps>

001021e5 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $103
  1021e7:	6a 67                	push   $0x67
  jmp __alltraps
  1021e9:	e9 42 fc ff ff       	jmp    101e30 <__alltraps>

001021ee <vector104>:
.globl vector104
vector104:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $104
  1021f0:	6a 68                	push   $0x68
  jmp __alltraps
  1021f2:	e9 39 fc ff ff       	jmp    101e30 <__alltraps>

001021f7 <vector105>:
.globl vector105
vector105:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $105
  1021f9:	6a 69                	push   $0x69
  jmp __alltraps
  1021fb:	e9 30 fc ff ff       	jmp    101e30 <__alltraps>

00102200 <vector106>:
.globl vector106
vector106:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $106
  102202:	6a 6a                	push   $0x6a
  jmp __alltraps
  102204:	e9 27 fc ff ff       	jmp    101e30 <__alltraps>

00102209 <vector107>:
.globl vector107
vector107:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $107
  10220b:	6a 6b                	push   $0x6b
  jmp __alltraps
  10220d:	e9 1e fc ff ff       	jmp    101e30 <__alltraps>

00102212 <vector108>:
.globl vector108
vector108:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $108
  102214:	6a 6c                	push   $0x6c
  jmp __alltraps
  102216:	e9 15 fc ff ff       	jmp    101e30 <__alltraps>

0010221b <vector109>:
.globl vector109
vector109:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $109
  10221d:	6a 6d                	push   $0x6d
  jmp __alltraps
  10221f:	e9 0c fc ff ff       	jmp    101e30 <__alltraps>

00102224 <vector110>:
.globl vector110
vector110:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $110
  102226:	6a 6e                	push   $0x6e
  jmp __alltraps
  102228:	e9 03 fc ff ff       	jmp    101e30 <__alltraps>

0010222d <vector111>:
.globl vector111
vector111:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $111
  10222f:	6a 6f                	push   $0x6f
  jmp __alltraps
  102231:	e9 fa fb ff ff       	jmp    101e30 <__alltraps>

00102236 <vector112>:
.globl vector112
vector112:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $112
  102238:	6a 70                	push   $0x70
  jmp __alltraps
  10223a:	e9 f1 fb ff ff       	jmp    101e30 <__alltraps>

0010223f <vector113>:
.globl vector113
vector113:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $113
  102241:	6a 71                	push   $0x71
  jmp __alltraps
  102243:	e9 e8 fb ff ff       	jmp    101e30 <__alltraps>

00102248 <vector114>:
.globl vector114
vector114:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $114
  10224a:	6a 72                	push   $0x72
  jmp __alltraps
  10224c:	e9 df fb ff ff       	jmp    101e30 <__alltraps>

00102251 <vector115>:
.globl vector115
vector115:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $115
  102253:	6a 73                	push   $0x73
  jmp __alltraps
  102255:	e9 d6 fb ff ff       	jmp    101e30 <__alltraps>

0010225a <vector116>:
.globl vector116
vector116:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $116
  10225c:	6a 74                	push   $0x74
  jmp __alltraps
  10225e:	e9 cd fb ff ff       	jmp    101e30 <__alltraps>

00102263 <vector117>:
.globl vector117
vector117:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $117
  102265:	6a 75                	push   $0x75
  jmp __alltraps
  102267:	e9 c4 fb ff ff       	jmp    101e30 <__alltraps>

0010226c <vector118>:
.globl vector118
vector118:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $118
  10226e:	6a 76                	push   $0x76
  jmp __alltraps
  102270:	e9 bb fb ff ff       	jmp    101e30 <__alltraps>

00102275 <vector119>:
.globl vector119
vector119:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $119
  102277:	6a 77                	push   $0x77
  jmp __alltraps
  102279:	e9 b2 fb ff ff       	jmp    101e30 <__alltraps>

0010227e <vector120>:
.globl vector120
vector120:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $120
  102280:	6a 78                	push   $0x78
  jmp __alltraps
  102282:	e9 a9 fb ff ff       	jmp    101e30 <__alltraps>

00102287 <vector121>:
.globl vector121
vector121:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $121
  102289:	6a 79                	push   $0x79
  jmp __alltraps
  10228b:	e9 a0 fb ff ff       	jmp    101e30 <__alltraps>

00102290 <vector122>:
.globl vector122
vector122:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $122
  102292:	6a 7a                	push   $0x7a
  jmp __alltraps
  102294:	e9 97 fb ff ff       	jmp    101e30 <__alltraps>

00102299 <vector123>:
.globl vector123
vector123:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $123
  10229b:	6a 7b                	push   $0x7b
  jmp __alltraps
  10229d:	e9 8e fb ff ff       	jmp    101e30 <__alltraps>

001022a2 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $124
  1022a4:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022a6:	e9 85 fb ff ff       	jmp    101e30 <__alltraps>

001022ab <vector125>:
.globl vector125
vector125:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $125
  1022ad:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022af:	e9 7c fb ff ff       	jmp    101e30 <__alltraps>

001022b4 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $126
  1022b6:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022b8:	e9 73 fb ff ff       	jmp    101e30 <__alltraps>

001022bd <vector127>:
.globl vector127
vector127:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $127
  1022bf:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022c1:	e9 6a fb ff ff       	jmp    101e30 <__alltraps>

001022c6 <vector128>:
.globl vector128
vector128:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $128
  1022c8:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022cd:	e9 5e fb ff ff       	jmp    101e30 <__alltraps>

001022d2 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022d2:	6a 00                	push   $0x0
  pushl $129
  1022d4:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022d9:	e9 52 fb ff ff       	jmp    101e30 <__alltraps>

001022de <vector130>:
.globl vector130
vector130:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $130
  1022e0:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022e5:	e9 46 fb ff ff       	jmp    101e30 <__alltraps>

001022ea <vector131>:
.globl vector131
vector131:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $131
  1022ec:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022f1:	e9 3a fb ff ff       	jmp    101e30 <__alltraps>

001022f6 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022f6:	6a 00                	push   $0x0
  pushl $132
  1022f8:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022fd:	e9 2e fb ff ff       	jmp    101e30 <__alltraps>

00102302 <vector133>:
.globl vector133
vector133:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $133
  102304:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102309:	e9 22 fb ff ff       	jmp    101e30 <__alltraps>

0010230e <vector134>:
.globl vector134
vector134:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $134
  102310:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102315:	e9 16 fb ff ff       	jmp    101e30 <__alltraps>

0010231a <vector135>:
.globl vector135
vector135:
  pushl $0
  10231a:	6a 00                	push   $0x0
  pushl $135
  10231c:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102321:	e9 0a fb ff ff       	jmp    101e30 <__alltraps>

00102326 <vector136>:
.globl vector136
vector136:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $136
  102328:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10232d:	e9 fe fa ff ff       	jmp    101e30 <__alltraps>

00102332 <vector137>:
.globl vector137
vector137:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $137
  102334:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102339:	e9 f2 fa ff ff       	jmp    101e30 <__alltraps>

0010233e <vector138>:
.globl vector138
vector138:
  pushl $0
  10233e:	6a 00                	push   $0x0
  pushl $138
  102340:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102345:	e9 e6 fa ff ff       	jmp    101e30 <__alltraps>

0010234a <vector139>:
.globl vector139
vector139:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $139
  10234c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102351:	e9 da fa ff ff       	jmp    101e30 <__alltraps>

00102356 <vector140>:
.globl vector140
vector140:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $140
  102358:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10235d:	e9 ce fa ff ff       	jmp    101e30 <__alltraps>

00102362 <vector141>:
.globl vector141
vector141:
  pushl $0
  102362:	6a 00                	push   $0x0
  pushl $141
  102364:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102369:	e9 c2 fa ff ff       	jmp    101e30 <__alltraps>

0010236e <vector142>:
.globl vector142
vector142:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $142
  102370:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102375:	e9 b6 fa ff ff       	jmp    101e30 <__alltraps>

0010237a <vector143>:
.globl vector143
vector143:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $143
  10237c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102381:	e9 aa fa ff ff       	jmp    101e30 <__alltraps>

00102386 <vector144>:
.globl vector144
vector144:
  pushl $0
  102386:	6a 00                	push   $0x0
  pushl $144
  102388:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10238d:	e9 9e fa ff ff       	jmp    101e30 <__alltraps>

00102392 <vector145>:
.globl vector145
vector145:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $145
  102394:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102399:	e9 92 fa ff ff       	jmp    101e30 <__alltraps>

0010239e <vector146>:
.globl vector146
vector146:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $146
  1023a0:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023a5:	e9 86 fa ff ff       	jmp    101e30 <__alltraps>

001023aa <vector147>:
.globl vector147
vector147:
  pushl $0
  1023aa:	6a 00                	push   $0x0
  pushl $147
  1023ac:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023b1:	e9 7a fa ff ff       	jmp    101e30 <__alltraps>

001023b6 <vector148>:
.globl vector148
vector148:
  pushl $0
  1023b6:	6a 00                	push   $0x0
  pushl $148
  1023b8:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023bd:	e9 6e fa ff ff       	jmp    101e30 <__alltraps>

001023c2 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $149
  1023c4:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023c9:	e9 62 fa ff ff       	jmp    101e30 <__alltraps>

001023ce <vector150>:
.globl vector150
vector150:
  pushl $0
  1023ce:	6a 00                	push   $0x0
  pushl $150
  1023d0:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023d5:	e9 56 fa ff ff       	jmp    101e30 <__alltraps>

001023da <vector151>:
.globl vector151
vector151:
  pushl $0
  1023da:	6a 00                	push   $0x0
  pushl $151
  1023dc:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023e1:	e9 4a fa ff ff       	jmp    101e30 <__alltraps>

001023e6 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $152
  1023e8:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023ed:	e9 3e fa ff ff       	jmp    101e30 <__alltraps>

001023f2 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023f2:	6a 00                	push   $0x0
  pushl $153
  1023f4:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023f9:	e9 32 fa ff ff       	jmp    101e30 <__alltraps>

001023fe <vector154>:
.globl vector154
vector154:
  pushl $0
  1023fe:	6a 00                	push   $0x0
  pushl $154
  102400:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102405:	e9 26 fa ff ff       	jmp    101e30 <__alltraps>

0010240a <vector155>:
.globl vector155
vector155:
  pushl $0
  10240a:	6a 00                	push   $0x0
  pushl $155
  10240c:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102411:	e9 1a fa ff ff       	jmp    101e30 <__alltraps>

00102416 <vector156>:
.globl vector156
vector156:
  pushl $0
  102416:	6a 00                	push   $0x0
  pushl $156
  102418:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10241d:	e9 0e fa ff ff       	jmp    101e30 <__alltraps>

00102422 <vector157>:
.globl vector157
vector157:
  pushl $0
  102422:	6a 00                	push   $0x0
  pushl $157
  102424:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102429:	e9 02 fa ff ff       	jmp    101e30 <__alltraps>

0010242e <vector158>:
.globl vector158
vector158:
  pushl $0
  10242e:	6a 00                	push   $0x0
  pushl $158
  102430:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102435:	e9 f6 f9 ff ff       	jmp    101e30 <__alltraps>

0010243a <vector159>:
.globl vector159
vector159:
  pushl $0
  10243a:	6a 00                	push   $0x0
  pushl $159
  10243c:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102441:	e9 ea f9 ff ff       	jmp    101e30 <__alltraps>

00102446 <vector160>:
.globl vector160
vector160:
  pushl $0
  102446:	6a 00                	push   $0x0
  pushl $160
  102448:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10244d:	e9 de f9 ff ff       	jmp    101e30 <__alltraps>

00102452 <vector161>:
.globl vector161
vector161:
  pushl $0
  102452:	6a 00                	push   $0x0
  pushl $161
  102454:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102459:	e9 d2 f9 ff ff       	jmp    101e30 <__alltraps>

0010245e <vector162>:
.globl vector162
vector162:
  pushl $0
  10245e:	6a 00                	push   $0x0
  pushl $162
  102460:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102465:	e9 c6 f9 ff ff       	jmp    101e30 <__alltraps>

0010246a <vector163>:
.globl vector163
vector163:
  pushl $0
  10246a:	6a 00                	push   $0x0
  pushl $163
  10246c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102471:	e9 ba f9 ff ff       	jmp    101e30 <__alltraps>

00102476 <vector164>:
.globl vector164
vector164:
  pushl $0
  102476:	6a 00                	push   $0x0
  pushl $164
  102478:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10247d:	e9 ae f9 ff ff       	jmp    101e30 <__alltraps>

00102482 <vector165>:
.globl vector165
vector165:
  pushl $0
  102482:	6a 00                	push   $0x0
  pushl $165
  102484:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102489:	e9 a2 f9 ff ff       	jmp    101e30 <__alltraps>

0010248e <vector166>:
.globl vector166
vector166:
  pushl $0
  10248e:	6a 00                	push   $0x0
  pushl $166
  102490:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102495:	e9 96 f9 ff ff       	jmp    101e30 <__alltraps>

0010249a <vector167>:
.globl vector167
vector167:
  pushl $0
  10249a:	6a 00                	push   $0x0
  pushl $167
  10249c:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024a1:	e9 8a f9 ff ff       	jmp    101e30 <__alltraps>

001024a6 <vector168>:
.globl vector168
vector168:
  pushl $0
  1024a6:	6a 00                	push   $0x0
  pushl $168
  1024a8:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024ad:	e9 7e f9 ff ff       	jmp    101e30 <__alltraps>

001024b2 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $169
  1024b4:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024b9:	e9 72 f9 ff ff       	jmp    101e30 <__alltraps>

001024be <vector170>:
.globl vector170
vector170:
  pushl $0
  1024be:	6a 00                	push   $0x0
  pushl $170
  1024c0:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024c5:	e9 66 f9 ff ff       	jmp    101e30 <__alltraps>

001024ca <vector171>:
.globl vector171
vector171:
  pushl $0
  1024ca:	6a 00                	push   $0x0
  pushl $171
  1024cc:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024d1:	e9 5a f9 ff ff       	jmp    101e30 <__alltraps>

001024d6 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $172
  1024d8:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024dd:	e9 4e f9 ff ff       	jmp    101e30 <__alltraps>

001024e2 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024e2:	6a 00                	push   $0x0
  pushl $173
  1024e4:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024e9:	e9 42 f9 ff ff       	jmp    101e30 <__alltraps>

001024ee <vector174>:
.globl vector174
vector174:
  pushl $0
  1024ee:	6a 00                	push   $0x0
  pushl $174
  1024f0:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024f5:	e9 36 f9 ff ff       	jmp    101e30 <__alltraps>

001024fa <vector175>:
.globl vector175
vector175:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $175
  1024fc:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102501:	e9 2a f9 ff ff       	jmp    101e30 <__alltraps>

00102506 <vector176>:
.globl vector176
vector176:
  pushl $0
  102506:	6a 00                	push   $0x0
  pushl $176
  102508:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10250d:	e9 1e f9 ff ff       	jmp    101e30 <__alltraps>

00102512 <vector177>:
.globl vector177
vector177:
  pushl $0
  102512:	6a 00                	push   $0x0
  pushl $177
  102514:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102519:	e9 12 f9 ff ff       	jmp    101e30 <__alltraps>

0010251e <vector178>:
.globl vector178
vector178:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $178
  102520:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102525:	e9 06 f9 ff ff       	jmp    101e30 <__alltraps>

0010252a <vector179>:
.globl vector179
vector179:
  pushl $0
  10252a:	6a 00                	push   $0x0
  pushl $179
  10252c:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102531:	e9 fa f8 ff ff       	jmp    101e30 <__alltraps>

00102536 <vector180>:
.globl vector180
vector180:
  pushl $0
  102536:	6a 00                	push   $0x0
  pushl $180
  102538:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10253d:	e9 ee f8 ff ff       	jmp    101e30 <__alltraps>

00102542 <vector181>:
.globl vector181
vector181:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $181
  102544:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102549:	e9 e2 f8 ff ff       	jmp    101e30 <__alltraps>

0010254e <vector182>:
.globl vector182
vector182:
  pushl $0
  10254e:	6a 00                	push   $0x0
  pushl $182
  102550:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102555:	e9 d6 f8 ff ff       	jmp    101e30 <__alltraps>

0010255a <vector183>:
.globl vector183
vector183:
  pushl $0
  10255a:	6a 00                	push   $0x0
  pushl $183
  10255c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102561:	e9 ca f8 ff ff       	jmp    101e30 <__alltraps>

00102566 <vector184>:
.globl vector184
vector184:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $184
  102568:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10256d:	e9 be f8 ff ff       	jmp    101e30 <__alltraps>

00102572 <vector185>:
.globl vector185
vector185:
  pushl $0
  102572:	6a 00                	push   $0x0
  pushl $185
  102574:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102579:	e9 b2 f8 ff ff       	jmp    101e30 <__alltraps>

0010257e <vector186>:
.globl vector186
vector186:
  pushl $0
  10257e:	6a 00                	push   $0x0
  pushl $186
  102580:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102585:	e9 a6 f8 ff ff       	jmp    101e30 <__alltraps>

0010258a <vector187>:
.globl vector187
vector187:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $187
  10258c:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102591:	e9 9a f8 ff ff       	jmp    101e30 <__alltraps>

00102596 <vector188>:
.globl vector188
vector188:
  pushl $0
  102596:	6a 00                	push   $0x0
  pushl $188
  102598:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10259d:	e9 8e f8 ff ff       	jmp    101e30 <__alltraps>

001025a2 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025a2:	6a 00                	push   $0x0
  pushl $189
  1025a4:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025a9:	e9 82 f8 ff ff       	jmp    101e30 <__alltraps>

001025ae <vector190>:
.globl vector190
vector190:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $190
  1025b0:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025b5:	e9 76 f8 ff ff       	jmp    101e30 <__alltraps>

001025ba <vector191>:
.globl vector191
vector191:
  pushl $0
  1025ba:	6a 00                	push   $0x0
  pushl $191
  1025bc:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025c1:	e9 6a f8 ff ff       	jmp    101e30 <__alltraps>

001025c6 <vector192>:
.globl vector192
vector192:
  pushl $0
  1025c6:	6a 00                	push   $0x0
  pushl $192
  1025c8:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025cd:	e9 5e f8 ff ff       	jmp    101e30 <__alltraps>

001025d2 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $193
  1025d4:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025d9:	e9 52 f8 ff ff       	jmp    101e30 <__alltraps>

001025de <vector194>:
.globl vector194
vector194:
  pushl $0
  1025de:	6a 00                	push   $0x0
  pushl $194
  1025e0:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025e5:	e9 46 f8 ff ff       	jmp    101e30 <__alltraps>

001025ea <vector195>:
.globl vector195
vector195:
  pushl $0
  1025ea:	6a 00                	push   $0x0
  pushl $195
  1025ec:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025f1:	e9 3a f8 ff ff       	jmp    101e30 <__alltraps>

001025f6 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $196
  1025f8:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025fd:	e9 2e f8 ff ff       	jmp    101e30 <__alltraps>

00102602 <vector197>:
.globl vector197
vector197:
  pushl $0
  102602:	6a 00                	push   $0x0
  pushl $197
  102604:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102609:	e9 22 f8 ff ff       	jmp    101e30 <__alltraps>

0010260e <vector198>:
.globl vector198
vector198:
  pushl $0
  10260e:	6a 00                	push   $0x0
  pushl $198
  102610:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102615:	e9 16 f8 ff ff       	jmp    101e30 <__alltraps>

0010261a <vector199>:
.globl vector199
vector199:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $199
  10261c:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102621:	e9 0a f8 ff ff       	jmp    101e30 <__alltraps>

00102626 <vector200>:
.globl vector200
vector200:
  pushl $0
  102626:	6a 00                	push   $0x0
  pushl $200
  102628:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10262d:	e9 fe f7 ff ff       	jmp    101e30 <__alltraps>

00102632 <vector201>:
.globl vector201
vector201:
  pushl $0
  102632:	6a 00                	push   $0x0
  pushl $201
  102634:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102639:	e9 f2 f7 ff ff       	jmp    101e30 <__alltraps>

0010263e <vector202>:
.globl vector202
vector202:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $202
  102640:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102645:	e9 e6 f7 ff ff       	jmp    101e30 <__alltraps>

0010264a <vector203>:
.globl vector203
vector203:
  pushl $0
  10264a:	6a 00                	push   $0x0
  pushl $203
  10264c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102651:	e9 da f7 ff ff       	jmp    101e30 <__alltraps>

00102656 <vector204>:
.globl vector204
vector204:
  pushl $0
  102656:	6a 00                	push   $0x0
  pushl $204
  102658:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10265d:	e9 ce f7 ff ff       	jmp    101e30 <__alltraps>

00102662 <vector205>:
.globl vector205
vector205:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $205
  102664:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102669:	e9 c2 f7 ff ff       	jmp    101e30 <__alltraps>

0010266e <vector206>:
.globl vector206
vector206:
  pushl $0
  10266e:	6a 00                	push   $0x0
  pushl $206
  102670:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102675:	e9 b6 f7 ff ff       	jmp    101e30 <__alltraps>

0010267a <vector207>:
.globl vector207
vector207:
  pushl $0
  10267a:	6a 00                	push   $0x0
  pushl $207
  10267c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102681:	e9 aa f7 ff ff       	jmp    101e30 <__alltraps>

00102686 <vector208>:
.globl vector208
vector208:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $208
  102688:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10268d:	e9 9e f7 ff ff       	jmp    101e30 <__alltraps>

00102692 <vector209>:
.globl vector209
vector209:
  pushl $0
  102692:	6a 00                	push   $0x0
  pushl $209
  102694:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102699:	e9 92 f7 ff ff       	jmp    101e30 <__alltraps>

0010269e <vector210>:
.globl vector210
vector210:
  pushl $0
  10269e:	6a 00                	push   $0x0
  pushl $210
  1026a0:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026a5:	e9 86 f7 ff ff       	jmp    101e30 <__alltraps>

001026aa <vector211>:
.globl vector211
vector211:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $211
  1026ac:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026b1:	e9 7a f7 ff ff       	jmp    101e30 <__alltraps>

001026b6 <vector212>:
.globl vector212
vector212:
  pushl $0
  1026b6:	6a 00                	push   $0x0
  pushl $212
  1026b8:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026bd:	e9 6e f7 ff ff       	jmp    101e30 <__alltraps>

001026c2 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026c2:	6a 00                	push   $0x0
  pushl $213
  1026c4:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026c9:	e9 62 f7 ff ff       	jmp    101e30 <__alltraps>

001026ce <vector214>:
.globl vector214
vector214:
  pushl $0
  1026ce:	6a 00                	push   $0x0
  pushl $214
  1026d0:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026d5:	e9 56 f7 ff ff       	jmp    101e30 <__alltraps>

001026da <vector215>:
.globl vector215
vector215:
  pushl $0
  1026da:	6a 00                	push   $0x0
  pushl $215
  1026dc:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026e1:	e9 4a f7 ff ff       	jmp    101e30 <__alltraps>

001026e6 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026e6:	6a 00                	push   $0x0
  pushl $216
  1026e8:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026ed:	e9 3e f7 ff ff       	jmp    101e30 <__alltraps>

001026f2 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026f2:	6a 00                	push   $0x0
  pushl $217
  1026f4:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026f9:	e9 32 f7 ff ff       	jmp    101e30 <__alltraps>

001026fe <vector218>:
.globl vector218
vector218:
  pushl $0
  1026fe:	6a 00                	push   $0x0
  pushl $218
  102700:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102705:	e9 26 f7 ff ff       	jmp    101e30 <__alltraps>

0010270a <vector219>:
.globl vector219
vector219:
  pushl $0
  10270a:	6a 00                	push   $0x0
  pushl $219
  10270c:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102711:	e9 1a f7 ff ff       	jmp    101e30 <__alltraps>

00102716 <vector220>:
.globl vector220
vector220:
  pushl $0
  102716:	6a 00                	push   $0x0
  pushl $220
  102718:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10271d:	e9 0e f7 ff ff       	jmp    101e30 <__alltraps>

00102722 <vector221>:
.globl vector221
vector221:
  pushl $0
  102722:	6a 00                	push   $0x0
  pushl $221
  102724:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102729:	e9 02 f7 ff ff       	jmp    101e30 <__alltraps>

0010272e <vector222>:
.globl vector222
vector222:
  pushl $0
  10272e:	6a 00                	push   $0x0
  pushl $222
  102730:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102735:	e9 f6 f6 ff ff       	jmp    101e30 <__alltraps>

0010273a <vector223>:
.globl vector223
vector223:
  pushl $0
  10273a:	6a 00                	push   $0x0
  pushl $223
  10273c:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102741:	e9 ea f6 ff ff       	jmp    101e30 <__alltraps>

00102746 <vector224>:
.globl vector224
vector224:
  pushl $0
  102746:	6a 00                	push   $0x0
  pushl $224
  102748:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10274d:	e9 de f6 ff ff       	jmp    101e30 <__alltraps>

00102752 <vector225>:
.globl vector225
vector225:
  pushl $0
  102752:	6a 00                	push   $0x0
  pushl $225
  102754:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102759:	e9 d2 f6 ff ff       	jmp    101e30 <__alltraps>

0010275e <vector226>:
.globl vector226
vector226:
  pushl $0
  10275e:	6a 00                	push   $0x0
  pushl $226
  102760:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102765:	e9 c6 f6 ff ff       	jmp    101e30 <__alltraps>

0010276a <vector227>:
.globl vector227
vector227:
  pushl $0
  10276a:	6a 00                	push   $0x0
  pushl $227
  10276c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102771:	e9 ba f6 ff ff       	jmp    101e30 <__alltraps>

00102776 <vector228>:
.globl vector228
vector228:
  pushl $0
  102776:	6a 00                	push   $0x0
  pushl $228
  102778:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10277d:	e9 ae f6 ff ff       	jmp    101e30 <__alltraps>

00102782 <vector229>:
.globl vector229
vector229:
  pushl $0
  102782:	6a 00                	push   $0x0
  pushl $229
  102784:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102789:	e9 a2 f6 ff ff       	jmp    101e30 <__alltraps>

0010278e <vector230>:
.globl vector230
vector230:
  pushl $0
  10278e:	6a 00                	push   $0x0
  pushl $230
  102790:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102795:	e9 96 f6 ff ff       	jmp    101e30 <__alltraps>

0010279a <vector231>:
.globl vector231
vector231:
  pushl $0
  10279a:	6a 00                	push   $0x0
  pushl $231
  10279c:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027a1:	e9 8a f6 ff ff       	jmp    101e30 <__alltraps>

001027a6 <vector232>:
.globl vector232
vector232:
  pushl $0
  1027a6:	6a 00                	push   $0x0
  pushl $232
  1027a8:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027ad:	e9 7e f6 ff ff       	jmp    101e30 <__alltraps>

001027b2 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027b2:	6a 00                	push   $0x0
  pushl $233
  1027b4:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027b9:	e9 72 f6 ff ff       	jmp    101e30 <__alltraps>

001027be <vector234>:
.globl vector234
vector234:
  pushl $0
  1027be:	6a 00                	push   $0x0
  pushl $234
  1027c0:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027c5:	e9 66 f6 ff ff       	jmp    101e30 <__alltraps>

001027ca <vector235>:
.globl vector235
vector235:
  pushl $0
  1027ca:	6a 00                	push   $0x0
  pushl $235
  1027cc:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027d1:	e9 5a f6 ff ff       	jmp    101e30 <__alltraps>

001027d6 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027d6:	6a 00                	push   $0x0
  pushl $236
  1027d8:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027dd:	e9 4e f6 ff ff       	jmp    101e30 <__alltraps>

001027e2 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027e2:	6a 00                	push   $0x0
  pushl $237
  1027e4:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027e9:	e9 42 f6 ff ff       	jmp    101e30 <__alltraps>

001027ee <vector238>:
.globl vector238
vector238:
  pushl $0
  1027ee:	6a 00                	push   $0x0
  pushl $238
  1027f0:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027f5:	e9 36 f6 ff ff       	jmp    101e30 <__alltraps>

001027fa <vector239>:
.globl vector239
vector239:
  pushl $0
  1027fa:	6a 00                	push   $0x0
  pushl $239
  1027fc:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102801:	e9 2a f6 ff ff       	jmp    101e30 <__alltraps>

00102806 <vector240>:
.globl vector240
vector240:
  pushl $0
  102806:	6a 00                	push   $0x0
  pushl $240
  102808:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10280d:	e9 1e f6 ff ff       	jmp    101e30 <__alltraps>

00102812 <vector241>:
.globl vector241
vector241:
  pushl $0
  102812:	6a 00                	push   $0x0
  pushl $241
  102814:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102819:	e9 12 f6 ff ff       	jmp    101e30 <__alltraps>

0010281e <vector242>:
.globl vector242
vector242:
  pushl $0
  10281e:	6a 00                	push   $0x0
  pushl $242
  102820:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102825:	e9 06 f6 ff ff       	jmp    101e30 <__alltraps>

0010282a <vector243>:
.globl vector243
vector243:
  pushl $0
  10282a:	6a 00                	push   $0x0
  pushl $243
  10282c:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102831:	e9 fa f5 ff ff       	jmp    101e30 <__alltraps>

00102836 <vector244>:
.globl vector244
vector244:
  pushl $0
  102836:	6a 00                	push   $0x0
  pushl $244
  102838:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10283d:	e9 ee f5 ff ff       	jmp    101e30 <__alltraps>

00102842 <vector245>:
.globl vector245
vector245:
  pushl $0
  102842:	6a 00                	push   $0x0
  pushl $245
  102844:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102849:	e9 e2 f5 ff ff       	jmp    101e30 <__alltraps>

0010284e <vector246>:
.globl vector246
vector246:
  pushl $0
  10284e:	6a 00                	push   $0x0
  pushl $246
  102850:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102855:	e9 d6 f5 ff ff       	jmp    101e30 <__alltraps>

0010285a <vector247>:
.globl vector247
vector247:
  pushl $0
  10285a:	6a 00                	push   $0x0
  pushl $247
  10285c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102861:	e9 ca f5 ff ff       	jmp    101e30 <__alltraps>

00102866 <vector248>:
.globl vector248
vector248:
  pushl $0
  102866:	6a 00                	push   $0x0
  pushl $248
  102868:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10286d:	e9 be f5 ff ff       	jmp    101e30 <__alltraps>

00102872 <vector249>:
.globl vector249
vector249:
  pushl $0
  102872:	6a 00                	push   $0x0
  pushl $249
  102874:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102879:	e9 b2 f5 ff ff       	jmp    101e30 <__alltraps>

0010287e <vector250>:
.globl vector250
vector250:
  pushl $0
  10287e:	6a 00                	push   $0x0
  pushl $250
  102880:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102885:	e9 a6 f5 ff ff       	jmp    101e30 <__alltraps>

0010288a <vector251>:
.globl vector251
vector251:
  pushl $0
  10288a:	6a 00                	push   $0x0
  pushl $251
  10288c:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102891:	e9 9a f5 ff ff       	jmp    101e30 <__alltraps>

00102896 <vector252>:
.globl vector252
vector252:
  pushl $0
  102896:	6a 00                	push   $0x0
  pushl $252
  102898:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10289d:	e9 8e f5 ff ff       	jmp    101e30 <__alltraps>

001028a2 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028a2:	6a 00                	push   $0x0
  pushl $253
  1028a4:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028a9:	e9 82 f5 ff ff       	jmp    101e30 <__alltraps>

001028ae <vector254>:
.globl vector254
vector254:
  pushl $0
  1028ae:	6a 00                	push   $0x0
  pushl $254
  1028b0:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028b5:	e9 76 f5 ff ff       	jmp    101e30 <__alltraps>

001028ba <vector255>:
.globl vector255
vector255:
  pushl $0
  1028ba:	6a 00                	push   $0x0
  pushl $255
  1028bc:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028c1:	e9 6a f5 ff ff       	jmp    101e30 <__alltraps>
	...

001028c8 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1028c8:	55                   	push   %ebp
  1028c9:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1028cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ce:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1028d1:	b8 23 00 00 00       	mov    $0x23,%eax
  1028d6:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1028d8:	b8 23 00 00 00       	mov    $0x23,%eax
  1028dd:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1028df:	b8 10 00 00 00       	mov    $0x10,%eax
  1028e4:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1028e6:	b8 10 00 00 00       	mov    $0x10,%eax
  1028eb:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1028ed:	b8 10 00 00 00       	mov    $0x10,%eax
  1028f2:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1028f4:	ea fb 28 10 00 08 00 	ljmp   $0x8,$0x1028fb
}
  1028fb:	5d                   	pop    %ebp
  1028fc:	c3                   	ret    

001028fd <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1028fd:	55                   	push   %ebp
  1028fe:	89 e5                	mov    %esp,%ebp
  102900:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102903:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102908:	05 00 04 00 00       	add    $0x400,%eax
  10290d:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102912:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102919:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10291b:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102922:	68 00 
  102924:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102929:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  10292f:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102934:	c1 e8 10             	shr    $0x10,%eax
  102937:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  10293c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102943:	83 e0 f0             	and    $0xfffffff0,%eax
  102946:	83 c8 09             	or     $0x9,%eax
  102949:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10294e:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102955:	83 c8 10             	or     $0x10,%eax
  102958:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10295d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102964:	83 e0 9f             	and    $0xffffff9f,%eax
  102967:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10296c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102973:	83 c8 80             	or     $0xffffff80,%eax
  102976:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10297b:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102982:	83 e0 f0             	and    $0xfffffff0,%eax
  102985:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10298a:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102991:	83 e0 ef             	and    $0xffffffef,%eax
  102994:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102999:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029a0:	83 e0 df             	and    $0xffffffdf,%eax
  1029a3:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029a8:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029af:	83 c8 40             	or     $0x40,%eax
  1029b2:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029b7:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029be:	83 e0 7f             	and    $0x7f,%eax
  1029c1:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029c6:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029cb:	c1 e8 18             	shr    $0x18,%eax
  1029ce:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1029d3:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029da:	83 e0 ef             	and    $0xffffffef,%eax
  1029dd:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  1029e2:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  1029e9:	e8 da fe ff ff       	call   1028c8 <lgdt>
  1029ee:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  1029f4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1029f8:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1029fb:	c9                   	leave  
  1029fc:	c3                   	ret    

001029fd <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1029fd:	55                   	push   %ebp
  1029fe:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a00:	e8 f8 fe ff ff       	call   1028fd <gdt_init>
}
  102a05:	5d                   	pop    %ebp
  102a06:	c3                   	ret    
	...

00102a08 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102a08:	55                   	push   %ebp
  102a09:	89 e5                	mov    %esp,%ebp
  102a0b:	56                   	push   %esi
  102a0c:	53                   	push   %ebx
  102a0d:	83 ec 60             	sub    $0x60,%esp
  102a10:	8b 45 10             	mov    0x10(%ebp),%eax
  102a13:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a16:	8b 45 14             	mov    0x14(%ebp),%eax
  102a19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102a1c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a1f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a22:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102a25:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102a28:	8b 45 18             	mov    0x18(%ebp),%eax
  102a2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102a2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a31:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102a34:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102a37:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102a3a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102a3d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a40:	89 d3                	mov    %edx,%ebx
  102a42:	89 c6                	mov    %eax,%esi
  102a44:	89 75 e0             	mov    %esi,-0x20(%ebp)
  102a47:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  102a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102a54:	74 1c                	je     102a72 <printnum+0x6a>
  102a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a59:	ba 00 00 00 00       	mov    $0x0,%edx
  102a5e:	f7 75 e4             	divl   -0x1c(%ebp)
  102a61:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a67:	ba 00 00 00 00       	mov    $0x0,%edx
  102a6c:	f7 75 e4             	divl   -0x1c(%ebp)
  102a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a72:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a78:	89 d6                	mov    %edx,%esi
  102a7a:	89 c3                	mov    %eax,%ebx
  102a7c:	89 f0                	mov    %esi,%eax
  102a7e:	89 da                	mov    %ebx,%edx
  102a80:	f7 75 e4             	divl   -0x1c(%ebp)
  102a83:	89 d3                	mov    %edx,%ebx
  102a85:	89 c6                	mov    %eax,%esi
  102a87:	89 75 e0             	mov    %esi,-0x20(%ebp)
  102a8a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  102a8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a90:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102a93:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102a96:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102a99:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102a9c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102a9f:	89 c3                	mov    %eax,%ebx
  102aa1:	89 d6                	mov    %edx,%esi
  102aa3:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  102aa6:	89 75 ec             	mov    %esi,-0x14(%ebp)
  102aa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102aac:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102aaf:	8b 45 18             	mov    0x18(%ebp),%eax
  102ab2:	ba 00 00 00 00       	mov    $0x0,%edx
  102ab7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102aba:	77 56                	ja     102b12 <printnum+0x10a>
  102abc:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102abf:	72 05                	jb     102ac6 <printnum+0xbe>
  102ac1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102ac4:	77 4c                	ja     102b12 <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
  102ac6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102ac9:	8d 50 ff             	lea    -0x1(%eax),%edx
  102acc:	8b 45 20             	mov    0x20(%ebp),%eax
  102acf:	89 44 24 18          	mov    %eax,0x18(%esp)
  102ad3:	89 54 24 14          	mov    %edx,0x14(%esp)
  102ad7:	8b 45 18             	mov    0x18(%ebp),%eax
  102ada:	89 44 24 10          	mov    %eax,0x10(%esp)
  102ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ae1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ae4:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ae8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  102aef:	89 44 24 04          	mov    %eax,0x4(%esp)
  102af3:	8b 45 08             	mov    0x8(%ebp),%eax
  102af6:	89 04 24             	mov    %eax,(%esp)
  102af9:	e8 0a ff ff ff       	call   102a08 <printnum>
  102afe:	eb 1c                	jmp    102b1c <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b07:	8b 45 20             	mov    0x20(%ebp),%eax
  102b0a:	89 04 24             	mov    %eax,(%esp)
  102b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b10:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102b12:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102b16:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102b1a:	7f e4                	jg     102b00 <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102b1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b1f:	05 90 3d 10 00       	add    $0x103d90,%eax
  102b24:	0f b6 00             	movzbl (%eax),%eax
  102b27:	0f be c0             	movsbl %al,%eax
  102b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b31:	89 04 24             	mov    %eax,(%esp)
  102b34:	8b 45 08             	mov    0x8(%ebp),%eax
  102b37:	ff d0                	call   *%eax
}
  102b39:	83 c4 60             	add    $0x60,%esp
  102b3c:	5b                   	pop    %ebx
  102b3d:	5e                   	pop    %esi
  102b3e:	5d                   	pop    %ebp
  102b3f:	c3                   	ret    

00102b40 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102b40:	55                   	push   %ebp
  102b41:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102b43:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102b47:	7e 14                	jle    102b5d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102b49:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4c:	8b 00                	mov    (%eax),%eax
  102b4e:	8d 48 08             	lea    0x8(%eax),%ecx
  102b51:	8b 55 08             	mov    0x8(%ebp),%edx
  102b54:	89 0a                	mov    %ecx,(%edx)
  102b56:	8b 50 04             	mov    0x4(%eax),%edx
  102b59:	8b 00                	mov    (%eax),%eax
  102b5b:	eb 30                	jmp    102b8d <getuint+0x4d>
    }
    else if (lflag) {
  102b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b61:	74 16                	je     102b79 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102b63:	8b 45 08             	mov    0x8(%ebp),%eax
  102b66:	8b 00                	mov    (%eax),%eax
  102b68:	8d 48 04             	lea    0x4(%eax),%ecx
  102b6b:	8b 55 08             	mov    0x8(%ebp),%edx
  102b6e:	89 0a                	mov    %ecx,(%edx)
  102b70:	8b 00                	mov    (%eax),%eax
  102b72:	ba 00 00 00 00       	mov    $0x0,%edx
  102b77:	eb 14                	jmp    102b8d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102b79:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7c:	8b 00                	mov    (%eax),%eax
  102b7e:	8d 48 04             	lea    0x4(%eax),%ecx
  102b81:	8b 55 08             	mov    0x8(%ebp),%edx
  102b84:	89 0a                	mov    %ecx,(%edx)
  102b86:	8b 00                	mov    (%eax),%eax
  102b88:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102b8d:	5d                   	pop    %ebp
  102b8e:	c3                   	ret    

00102b8f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102b8f:	55                   	push   %ebp
  102b90:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102b92:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102b96:	7e 14                	jle    102bac <getint+0x1d>
        return va_arg(*ap, long long);
  102b98:	8b 45 08             	mov    0x8(%ebp),%eax
  102b9b:	8b 00                	mov    (%eax),%eax
  102b9d:	8d 48 08             	lea    0x8(%eax),%ecx
  102ba0:	8b 55 08             	mov    0x8(%ebp),%edx
  102ba3:	89 0a                	mov    %ecx,(%edx)
  102ba5:	8b 50 04             	mov    0x4(%eax),%edx
  102ba8:	8b 00                	mov    (%eax),%eax
  102baa:	eb 30                	jmp    102bdc <getint+0x4d>
    }
    else if (lflag) {
  102bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bb0:	74 16                	je     102bc8 <getint+0x39>
        return va_arg(*ap, long);
  102bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb5:	8b 00                	mov    (%eax),%eax
  102bb7:	8d 48 04             	lea    0x4(%eax),%ecx
  102bba:	8b 55 08             	mov    0x8(%ebp),%edx
  102bbd:	89 0a                	mov    %ecx,(%edx)
  102bbf:	8b 00                	mov    (%eax),%eax
  102bc1:	89 c2                	mov    %eax,%edx
  102bc3:	c1 fa 1f             	sar    $0x1f,%edx
  102bc6:	eb 14                	jmp    102bdc <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
  102bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  102bcb:	8b 00                	mov    (%eax),%eax
  102bcd:	8d 48 04             	lea    0x4(%eax),%ecx
  102bd0:	8b 55 08             	mov    0x8(%ebp),%edx
  102bd3:	89 0a                	mov    %ecx,(%edx)
  102bd5:	8b 00                	mov    (%eax),%eax
  102bd7:	89 c2                	mov    %eax,%edx
  102bd9:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
  102bdc:	5d                   	pop    %ebp
  102bdd:	c3                   	ret    

00102bde <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102bde:	55                   	push   %ebp
  102bdf:	89 e5                	mov    %esp,%ebp
  102be1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102be4:	8d 55 14             	lea    0x14(%ebp),%edx
  102be7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  102bea:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
  102bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  102bf6:	89 44 24 08          	mov    %eax,0x8(%esp)
  102bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c01:	8b 45 08             	mov    0x8(%ebp),%eax
  102c04:	89 04 24             	mov    %eax,(%esp)
  102c07:	e8 02 00 00 00       	call   102c0e <vprintfmt>
    va_end(ap);
}
  102c0c:	c9                   	leave  
  102c0d:	c3                   	ret    

00102c0e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102c0e:	55                   	push   %ebp
  102c0f:	89 e5                	mov    %esp,%ebp
  102c11:	56                   	push   %esi
  102c12:	53                   	push   %ebx
  102c13:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c16:	eb 17                	jmp    102c2f <vprintfmt+0x21>
            if (ch == '\0') {
  102c18:	85 db                	test   %ebx,%ebx
  102c1a:	0f 84 db 03 00 00    	je     102ffb <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
  102c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c23:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c27:	89 1c 24             	mov    %ebx,(%esp)
  102c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2d:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  102c32:	0f b6 00             	movzbl (%eax),%eax
  102c35:	0f b6 d8             	movzbl %al,%ebx
  102c38:	83 fb 25             	cmp    $0x25,%ebx
  102c3b:	0f 95 c0             	setne  %al
  102c3e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  102c42:	84 c0                	test   %al,%al
  102c44:	75 d2                	jne    102c18 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102c46:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102c4a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c54:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102c57:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102c5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c64:	eb 04                	jmp    102c6a <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
  102c66:	90                   	nop
  102c67:	eb 01                	jmp    102c6a <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
  102c69:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102c6a:	8b 45 10             	mov    0x10(%ebp),%eax
  102c6d:	0f b6 00             	movzbl (%eax),%eax
  102c70:	0f b6 d8             	movzbl %al,%ebx
  102c73:	89 d8                	mov    %ebx,%eax
  102c75:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  102c79:	83 e8 23             	sub    $0x23,%eax
  102c7c:	83 f8 55             	cmp    $0x55,%eax
  102c7f:	0f 87 45 03 00 00    	ja     102fca <vprintfmt+0x3bc>
  102c85:	8b 04 85 b4 3d 10 00 	mov    0x103db4(,%eax,4),%eax
  102c8c:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102c8e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102c92:	eb d6                	jmp    102c6a <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102c94:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102c98:	eb d0                	jmp    102c6a <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102c9a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102ca1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ca4:	89 d0                	mov    %edx,%eax
  102ca6:	c1 e0 02             	shl    $0x2,%eax
  102ca9:	01 d0                	add    %edx,%eax
  102cab:	01 c0                	add    %eax,%eax
  102cad:	01 d8                	add    %ebx,%eax
  102caf:	83 e8 30             	sub    $0x30,%eax
  102cb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102cb5:	8b 45 10             	mov    0x10(%ebp),%eax
  102cb8:	0f b6 00             	movzbl (%eax),%eax
  102cbb:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102cbe:	83 fb 2f             	cmp    $0x2f,%ebx
  102cc1:	7e 39                	jle    102cfc <vprintfmt+0xee>
  102cc3:	83 fb 39             	cmp    $0x39,%ebx
  102cc6:	7f 34                	jg     102cfc <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102cc8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102ccc:	eb d3                	jmp    102ca1 <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102cce:	8b 45 14             	mov    0x14(%ebp),%eax
  102cd1:	8d 50 04             	lea    0x4(%eax),%edx
  102cd4:	89 55 14             	mov    %edx,0x14(%ebp)
  102cd7:	8b 00                	mov    (%eax),%eax
  102cd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102cdc:	eb 1f                	jmp    102cfd <vprintfmt+0xef>

        case '.':
            if (width < 0)
  102cde:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ce2:	79 82                	jns    102c66 <vprintfmt+0x58>
                width = 0;
  102ce4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102ceb:	e9 76 ff ff ff       	jmp    102c66 <vprintfmt+0x58>

        case '#':
            altflag = 1;
  102cf0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102cf7:	e9 6e ff ff ff       	jmp    102c6a <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  102cfc:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  102cfd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d01:	0f 89 62 ff ff ff    	jns    102c69 <vprintfmt+0x5b>
                width = precision, precision = -1;
  102d07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d0d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102d14:	e9 50 ff ff ff       	jmp    102c69 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102d19:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102d1d:	e9 48 ff ff ff       	jmp    102c6a <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102d22:	8b 45 14             	mov    0x14(%ebp),%eax
  102d25:	8d 50 04             	lea    0x4(%eax),%edx
  102d28:	89 55 14             	mov    %edx,0x14(%ebp)
  102d2b:	8b 00                	mov    (%eax),%eax
  102d2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d30:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d34:	89 04 24             	mov    %eax,(%esp)
  102d37:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3a:	ff d0                	call   *%eax
            break;
  102d3c:	e9 b4 02 00 00       	jmp    102ff5 <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102d41:	8b 45 14             	mov    0x14(%ebp),%eax
  102d44:	8d 50 04             	lea    0x4(%eax),%edx
  102d47:	89 55 14             	mov    %edx,0x14(%ebp)
  102d4a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102d4c:	85 db                	test   %ebx,%ebx
  102d4e:	79 02                	jns    102d52 <vprintfmt+0x144>
                err = -err;
  102d50:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102d52:	83 fb 06             	cmp    $0x6,%ebx
  102d55:	7f 0b                	jg     102d62 <vprintfmt+0x154>
  102d57:	8b 34 9d 74 3d 10 00 	mov    0x103d74(,%ebx,4),%esi
  102d5e:	85 f6                	test   %esi,%esi
  102d60:	75 23                	jne    102d85 <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
  102d62:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102d66:	c7 44 24 08 a1 3d 10 	movl   $0x103da1,0x8(%esp)
  102d6d:	00 
  102d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d71:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d75:	8b 45 08             	mov    0x8(%ebp),%eax
  102d78:	89 04 24             	mov    %eax,(%esp)
  102d7b:	e8 5e fe ff ff       	call   102bde <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102d80:	e9 70 02 00 00       	jmp    102ff5 <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102d85:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102d89:	c7 44 24 08 aa 3d 10 	movl   $0x103daa,0x8(%esp)
  102d90:	00 
  102d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d94:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d98:	8b 45 08             	mov    0x8(%ebp),%eax
  102d9b:	89 04 24             	mov    %eax,(%esp)
  102d9e:	e8 3b fe ff ff       	call   102bde <printfmt>
            }
            break;
  102da3:	e9 4d 02 00 00       	jmp    102ff5 <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102da8:	8b 45 14             	mov    0x14(%ebp),%eax
  102dab:	8d 50 04             	lea    0x4(%eax),%edx
  102dae:	89 55 14             	mov    %edx,0x14(%ebp)
  102db1:	8b 30                	mov    (%eax),%esi
  102db3:	85 f6                	test   %esi,%esi
  102db5:	75 05                	jne    102dbc <vprintfmt+0x1ae>
                p = "(null)";
  102db7:	be ad 3d 10 00       	mov    $0x103dad,%esi
            }
            if (width > 0 && padc != '-') {
  102dbc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dc0:	7e 7c                	jle    102e3e <vprintfmt+0x230>
  102dc2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102dc6:	74 76                	je     102e3e <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102dc8:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102dce:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dd2:	89 34 24             	mov    %esi,(%esp)
  102dd5:	e8 21 03 00 00       	call   1030fb <strnlen>
  102dda:	89 da                	mov    %ebx,%edx
  102ddc:	29 c2                	sub    %eax,%edx
  102dde:	89 d0                	mov    %edx,%eax
  102de0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102de3:	eb 17                	jmp    102dfc <vprintfmt+0x1ee>
                    putch(padc, putdat);
  102de5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102de9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102dec:	89 54 24 04          	mov    %edx,0x4(%esp)
  102df0:	89 04 24             	mov    %eax,(%esp)
  102df3:	8b 45 08             	mov    0x8(%ebp),%eax
  102df6:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102df8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102dfc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e00:	7f e3                	jg     102de5 <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e02:	eb 3a                	jmp    102e3e <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
  102e04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102e08:	74 1f                	je     102e29 <vprintfmt+0x21b>
  102e0a:	83 fb 1f             	cmp    $0x1f,%ebx
  102e0d:	7e 05                	jle    102e14 <vprintfmt+0x206>
  102e0f:	83 fb 7e             	cmp    $0x7e,%ebx
  102e12:	7e 15                	jle    102e29 <vprintfmt+0x21b>
                    putch('?', putdat);
  102e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e17:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e1b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102e22:	8b 45 08             	mov    0x8(%ebp),%eax
  102e25:	ff d0                	call   *%eax
  102e27:	eb 0f                	jmp    102e38 <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
  102e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e30:	89 1c 24             	mov    %ebx,(%esp)
  102e33:	8b 45 08             	mov    0x8(%ebp),%eax
  102e36:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e38:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e3c:	eb 01                	jmp    102e3f <vprintfmt+0x231>
  102e3e:	90                   	nop
  102e3f:	0f b6 06             	movzbl (%esi),%eax
  102e42:	0f be d8             	movsbl %al,%ebx
  102e45:	85 db                	test   %ebx,%ebx
  102e47:	0f 95 c0             	setne  %al
  102e4a:	83 c6 01             	add    $0x1,%esi
  102e4d:	84 c0                	test   %al,%al
  102e4f:	74 29                	je     102e7a <vprintfmt+0x26c>
  102e51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e55:	78 ad                	js     102e04 <vprintfmt+0x1f6>
  102e57:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102e5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e5f:	79 a3                	jns    102e04 <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102e61:	eb 17                	jmp    102e7a <vprintfmt+0x26c>
                putch(' ', putdat);
  102e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e66:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e6a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102e71:	8b 45 08             	mov    0x8(%ebp),%eax
  102e74:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102e76:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e7e:	7f e3                	jg     102e63 <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
  102e80:	e9 70 01 00 00       	jmp    102ff5 <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102e85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e88:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e8c:	8d 45 14             	lea    0x14(%ebp),%eax
  102e8f:	89 04 24             	mov    %eax,(%esp)
  102e92:	e8 f8 fc ff ff       	call   102b8f <getint>
  102e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ea3:	85 d2                	test   %edx,%edx
  102ea5:	79 26                	jns    102ecd <vprintfmt+0x2bf>
                putch('-', putdat);
  102ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eaa:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eae:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb8:	ff d0                	call   *%eax
                num = -(long long)num;
  102eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ec0:	f7 d8                	neg    %eax
  102ec2:	83 d2 00             	adc    $0x0,%edx
  102ec5:	f7 da                	neg    %edx
  102ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eca:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102ecd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102ed4:	e9 a8 00 00 00       	jmp    102f81 <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102ed9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102edc:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ee0:	8d 45 14             	lea    0x14(%ebp),%eax
  102ee3:	89 04 24             	mov    %eax,(%esp)
  102ee6:	e8 55 fc ff ff       	call   102b40 <getuint>
  102eeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eee:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102ef1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102ef8:	e9 84 00 00 00       	jmp    102f81 <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102efd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f00:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f04:	8d 45 14             	lea    0x14(%ebp),%eax
  102f07:	89 04 24             	mov    %eax,(%esp)
  102f0a:	e8 31 fc ff ff       	call   102b40 <getuint>
  102f0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f12:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102f15:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102f1c:	eb 63                	jmp    102f81 <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
  102f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f21:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f25:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2f:	ff d0                	call   *%eax
            putch('x', putdat);
  102f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f34:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f38:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f42:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102f44:	8b 45 14             	mov    0x14(%ebp),%eax
  102f47:	8d 50 04             	lea    0x4(%eax),%edx
  102f4a:	89 55 14             	mov    %edx,0x14(%ebp)
  102f4d:	8b 00                	mov    (%eax),%eax
  102f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102f59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102f60:	eb 1f                	jmp    102f81 <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102f62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f65:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f69:	8d 45 14             	lea    0x14(%ebp),%eax
  102f6c:	89 04 24             	mov    %eax,(%esp)
  102f6f:	e8 cc fb ff ff       	call   102b40 <getuint>
  102f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f77:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102f7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102f81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f88:	89 54 24 18          	mov    %edx,0x18(%esp)
  102f8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102f8f:	89 54 24 14          	mov    %edx,0x14(%esp)
  102f93:	89 44 24 10          	mov    %eax,0x10(%esp)
  102f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f9d:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fa1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fac:	8b 45 08             	mov    0x8(%ebp),%eax
  102faf:	89 04 24             	mov    %eax,(%esp)
  102fb2:	e8 51 fa ff ff       	call   102a08 <printnum>
            break;
  102fb7:	eb 3c                	jmp    102ff5 <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fc0:	89 1c 24             	mov    %ebx,(%esp)
  102fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc6:	ff d0                	call   *%eax
            break;
  102fc8:	eb 2b                	jmp    102ff5 <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fd1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  102fdb:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102fdd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102fe1:	eb 04                	jmp    102fe7 <vprintfmt+0x3d9>
  102fe3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  102fea:	83 e8 01             	sub    $0x1,%eax
  102fed:	0f b6 00             	movzbl (%eax),%eax
  102ff0:	3c 25                	cmp    $0x25,%al
  102ff2:	75 ef                	jne    102fe3 <vprintfmt+0x3d5>
                /* do nothing */;
            break;
  102ff4:	90                   	nop
        }
    }
  102ff5:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ff6:	e9 34 fc ff ff       	jmp    102c2f <vprintfmt+0x21>
            if (ch == '\0') {
                return;
  102ffb:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102ffc:	83 c4 40             	add    $0x40,%esp
  102fff:	5b                   	pop    %ebx
  103000:	5e                   	pop    %esi
  103001:	5d                   	pop    %ebp
  103002:	c3                   	ret    

00103003 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103003:	55                   	push   %ebp
  103004:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103006:	8b 45 0c             	mov    0xc(%ebp),%eax
  103009:	8b 40 08             	mov    0x8(%eax),%eax
  10300c:	8d 50 01             	lea    0x1(%eax),%edx
  10300f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103012:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103015:	8b 45 0c             	mov    0xc(%ebp),%eax
  103018:	8b 10                	mov    (%eax),%edx
  10301a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10301d:	8b 40 04             	mov    0x4(%eax),%eax
  103020:	39 c2                	cmp    %eax,%edx
  103022:	73 12                	jae    103036 <sprintputch+0x33>
        *b->buf ++ = ch;
  103024:	8b 45 0c             	mov    0xc(%ebp),%eax
  103027:	8b 00                	mov    (%eax),%eax
  103029:	8b 55 08             	mov    0x8(%ebp),%edx
  10302c:	88 10                	mov    %dl,(%eax)
  10302e:	8d 50 01             	lea    0x1(%eax),%edx
  103031:	8b 45 0c             	mov    0xc(%ebp),%eax
  103034:	89 10                	mov    %edx,(%eax)
    }
}
  103036:	5d                   	pop    %ebp
  103037:	c3                   	ret    

00103038 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103038:	55                   	push   %ebp
  103039:	89 e5                	mov    %esp,%ebp
  10303b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10303e:	8d 55 14             	lea    0x14(%ebp),%edx
  103041:	8d 45 f0             	lea    -0x10(%ebp),%eax
  103044:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
  103046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103049:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10304d:	8b 45 10             	mov    0x10(%ebp),%eax
  103050:	89 44 24 08          	mov    %eax,0x8(%esp)
  103054:	8b 45 0c             	mov    0xc(%ebp),%eax
  103057:	89 44 24 04          	mov    %eax,0x4(%esp)
  10305b:	8b 45 08             	mov    0x8(%ebp),%eax
  10305e:	89 04 24             	mov    %eax,(%esp)
  103061:	e8 08 00 00 00       	call   10306e <vsnprintf>
  103066:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103069:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10306c:	c9                   	leave  
  10306d:	c3                   	ret    

0010306e <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10306e:	55                   	push   %ebp
  10306f:	89 e5                	mov    %esp,%ebp
  103071:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103074:	8b 45 08             	mov    0x8(%ebp),%eax
  103077:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10307a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10307d:	83 e8 01             	sub    $0x1,%eax
  103080:	03 45 08             	add    0x8(%ebp),%eax
  103083:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103086:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10308d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103091:	74 0a                	je     10309d <vsnprintf+0x2f>
  103093:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103099:	39 c2                	cmp    %eax,%edx
  10309b:	76 07                	jbe    1030a4 <vsnprintf+0x36>
        return -E_INVAL;
  10309d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1030a2:	eb 2a                	jmp    1030ce <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1030a4:	8b 45 14             	mov    0x14(%ebp),%eax
  1030a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030ab:	8b 45 10             	mov    0x10(%ebp),%eax
  1030ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1030b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030b9:	c7 04 24 03 30 10 00 	movl   $0x103003,(%esp)
  1030c0:	e8 49 fb ff ff       	call   102c0e <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1030c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030c8:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030ce:	c9                   	leave  
  1030cf:	c3                   	ret    

001030d0 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1030d0:	55                   	push   %ebp
  1030d1:	89 e5                	mov    %esp,%ebp
  1030d3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1030d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1030dd:	eb 04                	jmp    1030e3 <strlen+0x13>
        cnt ++;
  1030df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e6:	0f b6 00             	movzbl (%eax),%eax
  1030e9:	84 c0                	test   %al,%al
  1030eb:	0f 95 c0             	setne  %al
  1030ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1030f2:	84 c0                	test   %al,%al
  1030f4:	75 e9                	jne    1030df <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1030f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1030f9:	c9                   	leave  
  1030fa:	c3                   	ret    

001030fb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1030fb:	55                   	push   %ebp
  1030fc:	89 e5                	mov    %esp,%ebp
  1030fe:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103108:	eb 04                	jmp    10310e <strnlen+0x13>
        cnt ++;
  10310a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10310e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103111:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103114:	73 13                	jae    103129 <strnlen+0x2e>
  103116:	8b 45 08             	mov    0x8(%ebp),%eax
  103119:	0f b6 00             	movzbl (%eax),%eax
  10311c:	84 c0                	test   %al,%al
  10311e:	0f 95 c0             	setne  %al
  103121:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103125:	84 c0                	test   %al,%al
  103127:	75 e1                	jne    10310a <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  103129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10312c:	c9                   	leave  
  10312d:	c3                   	ret    

0010312e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10312e:	55                   	push   %ebp
  10312f:	89 e5                	mov    %esp,%ebp
  103131:	57                   	push   %edi
  103132:	56                   	push   %esi
  103133:	53                   	push   %ebx
  103134:	83 ec 24             	sub    $0x24,%esp
  103137:	8b 45 08             	mov    0x8(%ebp),%eax
  10313a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10313d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103140:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103143:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103149:	89 d6                	mov    %edx,%esi
  10314b:	89 c3                	mov    %eax,%ebx
  10314d:	89 df                	mov    %ebx,%edi
  10314f:	ac                   	lods   %ds:(%esi),%al
  103150:	aa                   	stos   %al,%es:(%edi)
  103151:	84 c0                	test   %al,%al
  103153:	75 fa                	jne    10314f <strcpy+0x21>
  103155:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103158:	89 fb                	mov    %edi,%ebx
  10315a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  10315d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  103160:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103163:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103166:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103169:	83 c4 24             	add    $0x24,%esp
  10316c:	5b                   	pop    %ebx
  10316d:	5e                   	pop    %esi
  10316e:	5f                   	pop    %edi
  10316f:	5d                   	pop    %ebp
  103170:	c3                   	ret    

00103171 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103171:	55                   	push   %ebp
  103172:	89 e5                	mov    %esp,%ebp
  103174:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103177:	8b 45 08             	mov    0x8(%ebp),%eax
  10317a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10317d:	eb 21                	jmp    1031a0 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10317f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103182:	0f b6 10             	movzbl (%eax),%edx
  103185:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103188:	88 10                	mov    %dl,(%eax)
  10318a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10318d:	0f b6 00             	movzbl (%eax),%eax
  103190:	84 c0                	test   %al,%al
  103192:	74 04                	je     103198 <strncpy+0x27>
            src ++;
  103194:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103198:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10319c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1031a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031a4:	75 d9                	jne    10317f <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1031a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1031a9:	c9                   	leave  
  1031aa:	c3                   	ret    

001031ab <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1031ab:	55                   	push   %ebp
  1031ac:	89 e5                	mov    %esp,%ebp
  1031ae:	57                   	push   %edi
  1031af:	56                   	push   %esi
  1031b0:	53                   	push   %ebx
  1031b1:	83 ec 24             	sub    $0x24,%esp
  1031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1031c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1031c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031c6:	89 d6                	mov    %edx,%esi
  1031c8:	89 c3                	mov    %eax,%ebx
  1031ca:	89 df                	mov    %ebx,%edi
  1031cc:	ac                   	lods   %ds:(%esi),%al
  1031cd:	ae                   	scas   %es:(%edi),%al
  1031ce:	75 08                	jne    1031d8 <strcmp+0x2d>
  1031d0:	84 c0                	test   %al,%al
  1031d2:	75 f8                	jne    1031cc <strcmp+0x21>
  1031d4:	31 c0                	xor    %eax,%eax
  1031d6:	eb 04                	jmp    1031dc <strcmp+0x31>
  1031d8:	19 c0                	sbb    %eax,%eax
  1031da:	0c 01                	or     $0x1,%al
  1031dc:	89 fb                	mov    %edi,%ebx
  1031de:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1031e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1031e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031e7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  1031ea:	89 5d e0             	mov    %ebx,-0x20(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1031ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1031f0:	83 c4 24             	add    $0x24,%esp
  1031f3:	5b                   	pop    %ebx
  1031f4:	5e                   	pop    %esi
  1031f5:	5f                   	pop    %edi
  1031f6:	5d                   	pop    %ebp
  1031f7:	c3                   	ret    

001031f8 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1031f8:	55                   	push   %ebp
  1031f9:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1031fb:	eb 0c                	jmp    103209 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1031fd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103201:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103205:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103209:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10320d:	74 1a                	je     103229 <strncmp+0x31>
  10320f:	8b 45 08             	mov    0x8(%ebp),%eax
  103212:	0f b6 00             	movzbl (%eax),%eax
  103215:	84 c0                	test   %al,%al
  103217:	74 10                	je     103229 <strncmp+0x31>
  103219:	8b 45 08             	mov    0x8(%ebp),%eax
  10321c:	0f b6 10             	movzbl (%eax),%edx
  10321f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103222:	0f b6 00             	movzbl (%eax),%eax
  103225:	38 c2                	cmp    %al,%dl
  103227:	74 d4                	je     1031fd <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103229:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10322d:	74 1a                	je     103249 <strncmp+0x51>
  10322f:	8b 45 08             	mov    0x8(%ebp),%eax
  103232:	0f b6 00             	movzbl (%eax),%eax
  103235:	0f b6 d0             	movzbl %al,%edx
  103238:	8b 45 0c             	mov    0xc(%ebp),%eax
  10323b:	0f b6 00             	movzbl (%eax),%eax
  10323e:	0f b6 c0             	movzbl %al,%eax
  103241:	89 d1                	mov    %edx,%ecx
  103243:	29 c1                	sub    %eax,%ecx
  103245:	89 c8                	mov    %ecx,%eax
  103247:	eb 05                	jmp    10324e <strncmp+0x56>
  103249:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10324e:	5d                   	pop    %ebp
  10324f:	c3                   	ret    

00103250 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103250:	55                   	push   %ebp
  103251:	89 e5                	mov    %esp,%ebp
  103253:	83 ec 04             	sub    $0x4,%esp
  103256:	8b 45 0c             	mov    0xc(%ebp),%eax
  103259:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10325c:	eb 14                	jmp    103272 <strchr+0x22>
        if (*s == c) {
  10325e:	8b 45 08             	mov    0x8(%ebp),%eax
  103261:	0f b6 00             	movzbl (%eax),%eax
  103264:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103267:	75 05                	jne    10326e <strchr+0x1e>
            return (char *)s;
  103269:	8b 45 08             	mov    0x8(%ebp),%eax
  10326c:	eb 13                	jmp    103281 <strchr+0x31>
        }
        s ++;
  10326e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  103272:	8b 45 08             	mov    0x8(%ebp),%eax
  103275:	0f b6 00             	movzbl (%eax),%eax
  103278:	84 c0                	test   %al,%al
  10327a:	75 e2                	jne    10325e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  10327c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103281:	c9                   	leave  
  103282:	c3                   	ret    

00103283 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103283:	55                   	push   %ebp
  103284:	89 e5                	mov    %esp,%ebp
  103286:	83 ec 04             	sub    $0x4,%esp
  103289:	8b 45 0c             	mov    0xc(%ebp),%eax
  10328c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10328f:	eb 0f                	jmp    1032a0 <strfind+0x1d>
        if (*s == c) {
  103291:	8b 45 08             	mov    0x8(%ebp),%eax
  103294:	0f b6 00             	movzbl (%eax),%eax
  103297:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10329a:	74 10                	je     1032ac <strfind+0x29>
            break;
        }
        s ++;
  10329c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a3:	0f b6 00             	movzbl (%eax),%eax
  1032a6:	84 c0                	test   %al,%al
  1032a8:	75 e7                	jne    103291 <strfind+0xe>
  1032aa:	eb 01                	jmp    1032ad <strfind+0x2a>
        if (*s == c) {
            break;
  1032ac:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  1032ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1032b0:	c9                   	leave  
  1032b1:	c3                   	ret    

001032b2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1032b2:	55                   	push   %ebp
  1032b3:	89 e5                	mov    %esp,%ebp
  1032b5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1032b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1032bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032c6:	eb 04                	jmp    1032cc <strtol+0x1a>
        s ++;
  1032c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1032cf:	0f b6 00             	movzbl (%eax),%eax
  1032d2:	3c 20                	cmp    $0x20,%al
  1032d4:	74 f2                	je     1032c8 <strtol+0x16>
  1032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d9:	0f b6 00             	movzbl (%eax),%eax
  1032dc:	3c 09                	cmp    $0x9,%al
  1032de:	74 e8                	je     1032c8 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e3:	0f b6 00             	movzbl (%eax),%eax
  1032e6:	3c 2b                	cmp    $0x2b,%al
  1032e8:	75 06                	jne    1032f0 <strtol+0x3e>
        s ++;
  1032ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032ee:	eb 15                	jmp    103305 <strtol+0x53>
    }
    else if (*s == '-') {
  1032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032f3:	0f b6 00             	movzbl (%eax),%eax
  1032f6:	3c 2d                	cmp    $0x2d,%al
  1032f8:	75 0b                	jne    103305 <strtol+0x53>
        s ++, neg = 1;
  1032fa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103305:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103309:	74 06                	je     103311 <strtol+0x5f>
  10330b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10330f:	75 24                	jne    103335 <strtol+0x83>
  103311:	8b 45 08             	mov    0x8(%ebp),%eax
  103314:	0f b6 00             	movzbl (%eax),%eax
  103317:	3c 30                	cmp    $0x30,%al
  103319:	75 1a                	jne    103335 <strtol+0x83>
  10331b:	8b 45 08             	mov    0x8(%ebp),%eax
  10331e:	83 c0 01             	add    $0x1,%eax
  103321:	0f b6 00             	movzbl (%eax),%eax
  103324:	3c 78                	cmp    $0x78,%al
  103326:	75 0d                	jne    103335 <strtol+0x83>
        s += 2, base = 16;
  103328:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10332c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103333:	eb 2a                	jmp    10335f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103335:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103339:	75 17                	jne    103352 <strtol+0xa0>
  10333b:	8b 45 08             	mov    0x8(%ebp),%eax
  10333e:	0f b6 00             	movzbl (%eax),%eax
  103341:	3c 30                	cmp    $0x30,%al
  103343:	75 0d                	jne    103352 <strtol+0xa0>
        s ++, base = 8;
  103345:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103349:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103350:	eb 0d                	jmp    10335f <strtol+0xad>
    }
    else if (base == 0) {
  103352:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103356:	75 07                	jne    10335f <strtol+0xad>
        base = 10;
  103358:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10335f:	8b 45 08             	mov    0x8(%ebp),%eax
  103362:	0f b6 00             	movzbl (%eax),%eax
  103365:	3c 2f                	cmp    $0x2f,%al
  103367:	7e 1b                	jle    103384 <strtol+0xd2>
  103369:	8b 45 08             	mov    0x8(%ebp),%eax
  10336c:	0f b6 00             	movzbl (%eax),%eax
  10336f:	3c 39                	cmp    $0x39,%al
  103371:	7f 11                	jg     103384 <strtol+0xd2>
            dig = *s - '0';
  103373:	8b 45 08             	mov    0x8(%ebp),%eax
  103376:	0f b6 00             	movzbl (%eax),%eax
  103379:	0f be c0             	movsbl %al,%eax
  10337c:	83 e8 30             	sub    $0x30,%eax
  10337f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103382:	eb 48                	jmp    1033cc <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103384:	8b 45 08             	mov    0x8(%ebp),%eax
  103387:	0f b6 00             	movzbl (%eax),%eax
  10338a:	3c 60                	cmp    $0x60,%al
  10338c:	7e 1b                	jle    1033a9 <strtol+0xf7>
  10338e:	8b 45 08             	mov    0x8(%ebp),%eax
  103391:	0f b6 00             	movzbl (%eax),%eax
  103394:	3c 7a                	cmp    $0x7a,%al
  103396:	7f 11                	jg     1033a9 <strtol+0xf7>
            dig = *s - 'a' + 10;
  103398:	8b 45 08             	mov    0x8(%ebp),%eax
  10339b:	0f b6 00             	movzbl (%eax),%eax
  10339e:	0f be c0             	movsbl %al,%eax
  1033a1:	83 e8 57             	sub    $0x57,%eax
  1033a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033a7:	eb 23                	jmp    1033cc <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033ac:	0f b6 00             	movzbl (%eax),%eax
  1033af:	3c 40                	cmp    $0x40,%al
  1033b1:	7e 38                	jle    1033eb <strtol+0x139>
  1033b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b6:	0f b6 00             	movzbl (%eax),%eax
  1033b9:	3c 5a                	cmp    $0x5a,%al
  1033bb:	7f 2e                	jg     1033eb <strtol+0x139>
            dig = *s - 'A' + 10;
  1033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c0:	0f b6 00             	movzbl (%eax),%eax
  1033c3:	0f be c0             	movsbl %al,%eax
  1033c6:	83 e8 37             	sub    $0x37,%eax
  1033c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  1033d2:	7d 16                	jge    1033ea <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
  1033d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1033d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033db:	0f af 45 10          	imul   0x10(%ebp),%eax
  1033df:	03 45 f4             	add    -0xc(%ebp),%eax
  1033e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1033e5:	e9 75 ff ff ff       	jmp    10335f <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  1033ea:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  1033eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1033ef:	74 08                	je     1033f9 <strtol+0x147>
        *endptr = (char *) s;
  1033f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033f4:	8b 55 08             	mov    0x8(%ebp),%edx
  1033f7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1033f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1033fd:	74 07                	je     103406 <strtol+0x154>
  1033ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103402:	f7 d8                	neg    %eax
  103404:	eb 03                	jmp    103409 <strtol+0x157>
  103406:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103409:	c9                   	leave  
  10340a:	c3                   	ret    

0010340b <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10340b:	55                   	push   %ebp
  10340c:	89 e5                	mov    %esp,%ebp
  10340e:	57                   	push   %edi
  10340f:	56                   	push   %esi
  103410:	53                   	push   %ebx
  103411:	83 ec 24             	sub    $0x24,%esp
  103414:	8b 45 0c             	mov    0xc(%ebp),%eax
  103417:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10341a:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
  10341e:	8b 55 08             	mov    0x8(%ebp),%edx
  103421:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103424:	88 45 ef             	mov    %al,-0x11(%ebp)
  103427:	8b 45 10             	mov    0x10(%ebp),%eax
  10342a:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10342d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  103430:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  103434:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103437:	89 ce                	mov    %ecx,%esi
  103439:	89 d3                	mov    %edx,%ebx
  10343b:	89 f1                	mov    %esi,%ecx
  10343d:	89 df                	mov    %ebx,%edi
  10343f:	f3 aa                	rep stos %al,%es:(%edi)
  103441:	89 fb                	mov    %edi,%ebx
  103443:	89 ce                	mov    %ecx,%esi
  103445:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  103448:	89 5d e0             	mov    %ebx,-0x20(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10344b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10344e:	83 c4 24             	add    $0x24,%esp
  103451:	5b                   	pop    %ebx
  103452:	5e                   	pop    %esi
  103453:	5f                   	pop    %edi
  103454:	5d                   	pop    %ebp
  103455:	c3                   	ret    

00103456 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103456:	55                   	push   %ebp
  103457:	89 e5                	mov    %esp,%ebp
  103459:	57                   	push   %edi
  10345a:	56                   	push   %esi
  10345b:	53                   	push   %ebx
  10345c:	83 ec 38             	sub    $0x38,%esp
  10345f:	8b 45 08             	mov    0x8(%ebp),%eax
  103462:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103465:	8b 45 0c             	mov    0xc(%ebp),%eax
  103468:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10346b:	8b 45 10             	mov    0x10(%ebp),%eax
  10346e:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103474:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103477:	73 4e                	jae    1034c7 <memmove+0x71>
  103479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10347c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10347f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103482:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103485:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103488:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10348b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10348e:	89 c1                	mov    %eax,%ecx
  103490:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103493:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103496:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103499:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  10349c:	89 d7                	mov    %edx,%edi
  10349e:	89 c3                	mov    %eax,%ebx
  1034a0:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  1034a3:	89 de                	mov    %ebx,%esi
  1034a5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1034a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1034aa:	83 e1 03             	and    $0x3,%ecx
  1034ad:	74 02                	je     1034b1 <memmove+0x5b>
  1034af:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034b1:	89 f3                	mov    %esi,%ebx
  1034b3:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  1034b6:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  1034b9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1034bc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  1034bf:	89 5d d0             	mov    %ebx,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1034c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034c5:	eb 3b                	jmp    103502 <memmove+0xac>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1034c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034ca:	83 e8 01             	sub    $0x1,%eax
  1034cd:	89 c2                	mov    %eax,%edx
  1034cf:	03 55 ec             	add    -0x14(%ebp),%edx
  1034d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034d5:	83 e8 01             	sub    $0x1,%eax
  1034d8:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1034db:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1034de:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  1034e1:	89 d6                	mov    %edx,%esi
  1034e3:	89 c3                	mov    %eax,%ebx
  1034e5:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  1034e8:	89 df                	mov    %ebx,%edi
  1034ea:	fd                   	std    
  1034eb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034ed:	fc                   	cld    
  1034ee:	89 fb                	mov    %edi,%ebx
  1034f0:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  1034f3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  1034f6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1034f9:	89 75 c8             	mov    %esi,-0x38(%ebp)
  1034fc:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1034ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103502:	83 c4 38             	add    $0x38,%esp
  103505:	5b                   	pop    %ebx
  103506:	5e                   	pop    %esi
  103507:	5f                   	pop    %edi
  103508:	5d                   	pop    %ebp
  103509:	c3                   	ret    

0010350a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10350a:	55                   	push   %ebp
  10350b:	89 e5                	mov    %esp,%ebp
  10350d:	57                   	push   %edi
  10350e:	56                   	push   %esi
  10350f:	53                   	push   %ebx
  103510:	83 ec 24             	sub    $0x24,%esp
  103513:	8b 45 08             	mov    0x8(%ebp),%eax
  103516:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103519:	8b 45 0c             	mov    0xc(%ebp),%eax
  10351c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10351f:	8b 45 10             	mov    0x10(%ebp),%eax
  103522:	89 45 e8             	mov    %eax,-0x18(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103525:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103528:	89 c1                	mov    %eax,%ecx
  10352a:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10352d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103533:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  103536:	89 d7                	mov    %edx,%edi
  103538:	89 c3                	mov    %eax,%ebx
  10353a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  10353d:	89 de                	mov    %ebx,%esi
  10353f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103541:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  103544:	83 e1 03             	and    $0x3,%ecx
  103547:	74 02                	je     10354b <memcpy+0x41>
  103549:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10354b:	89 f3                	mov    %esi,%ebx
  10354d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  103550:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  103553:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  103556:	89 7d e0             	mov    %edi,-0x20(%ebp)
  103559:	89 5d dc             	mov    %ebx,-0x24(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  10355c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10355f:	83 c4 24             	add    $0x24,%esp
  103562:	5b                   	pop    %ebx
  103563:	5e                   	pop    %esi
  103564:	5f                   	pop    %edi
  103565:	5d                   	pop    %ebp
  103566:	c3                   	ret    

00103567 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103567:	55                   	push   %ebp
  103568:	89 e5                	mov    %esp,%ebp
  10356a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10356d:	8b 45 08             	mov    0x8(%ebp),%eax
  103570:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103573:	8b 45 0c             	mov    0xc(%ebp),%eax
  103576:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103579:	eb 32                	jmp    1035ad <memcmp+0x46>
        if (*s1 != *s2) {
  10357b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10357e:	0f b6 10             	movzbl (%eax),%edx
  103581:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103584:	0f b6 00             	movzbl (%eax),%eax
  103587:	38 c2                	cmp    %al,%dl
  103589:	74 1a                	je     1035a5 <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10358b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10358e:	0f b6 00             	movzbl (%eax),%eax
  103591:	0f b6 d0             	movzbl %al,%edx
  103594:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103597:	0f b6 00             	movzbl (%eax),%eax
  10359a:	0f b6 c0             	movzbl %al,%eax
  10359d:	89 d1                	mov    %edx,%ecx
  10359f:	29 c1                	sub    %eax,%ecx
  1035a1:	89 c8                	mov    %ecx,%eax
  1035a3:	eb 1c                	jmp    1035c1 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
  1035a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1035a9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1035ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1035b1:	0f 95 c0             	setne  %al
  1035b4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1035b8:	84 c0                	test   %al,%al
  1035ba:	75 bf                	jne    10357b <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1035bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035c1:	c9                   	leave  
  1035c2:	c3                   	ret    
