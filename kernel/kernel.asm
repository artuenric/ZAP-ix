
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	89013103          	ld	sp,-1904(sp) # 80008890 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	660050ef          	jal	ra,80005676 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	d2078793          	addi	a5,a5,-736 # 80021d50 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	89090913          	addi	s2,s2,-1904 # 800088e0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	004080e7          	jalr	4(ra) # 8000605e <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	0a4080e7          	jalr	164(ra) # 80006112 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	a9c080e7          	jalr	-1380(ra) # 80005b26 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00008517          	auipc	a0,0x8
    800000f2:	7f250513          	addi	a0,a0,2034 # 800088e0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	ed8080e7          	jalr	-296(ra) # 80005fce <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	c4e50513          	addi	a0,a0,-946 # 80021d50 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00008497          	auipc	s1,0x8
    80000128:	7bc48493          	addi	s1,s1,1980 # 800088e0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	f30080e7          	jalr	-208(ra) # 8000605e <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7a450513          	addi	a0,a0,1956 # 800088e0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	fcc080e7          	jalr	-52(ra) # 80006112 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	77850513          	addi	a0,a0,1912 # 800088e0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	fa2080e7          	jalr	-94(ra) # 80006112 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd2b1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	87aa                	mv	a5,a0
    8000028e:	86b2                	mv	a3,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	00d05963          	blez	a3,800002a4 <strncpy+0x1e>
    80000296:	0785                	addi	a5,a5,1
    80000298:	0005c703          	lbu	a4,0(a1)
    8000029c:	fee78fa3          	sb	a4,-1(a5)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f775                	bnez	a4,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	873e                	mv	a4,a5
    800002a6:	9fb5                	addw	a5,a5,a3
    800002a8:	37fd                	addiw	a5,a5,-1
    800002aa:	00c05963          	blez	a2,800002bc <strncpy+0x36>
    *s++ = 0;
    800002ae:	0705                	addi	a4,a4,1
    800002b0:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002b4:	40e786bb          	subw	a3,a5,a4
    800002b8:	fed04be3          	bgtz	a3,800002ae <strncpy+0x28>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	86be                	mv	a3,a5
    80000306:	0785                	addi	a5,a5,1
    80000308:	fff7c703          	lbu	a4,-1(a5)
    8000030c:	ff65                	bnez	a4,80000304 <strlen+0x10>
    8000030e:	40a6853b          	subw	a0,a3,a0
    80000312:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	b00080e7          	jalr	-1280(ra) # 80000e26 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	58270713          	addi	a4,a4,1410 # 800088b0 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	ae4080e7          	jalr	-1308(ra) # 80000e26 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	81c080e7          	jalr	-2020(ra) # 80005b70 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	78c080e7          	jalr	1932(ra) # 80001af0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	cc4080e7          	jalr	-828(ra) # 80005030 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fd4080e7          	jalr	-44(ra) # 80001348 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	6ba080e7          	jalr	1722(ra) # 80005a36 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	9cc080e7          	jalr	-1588(ra) # 80005d50 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00005097          	auipc	ra,0x5
    80000398:	7dc080e7          	jalr	2012(ra) # 80005b70 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00005097          	auipc	ra,0x5
    800003a8:	7cc080e7          	jalr	1996(ra) # 80005b70 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00005097          	auipc	ra,0x5
    800003b8:	7bc080e7          	jalr	1980(ra) # 80005b70 <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d22080e7          	jalr	-734(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	326080e7          	jalr	806(ra) # 800006ea <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	99e080e7          	jalr	-1634(ra) # 80000d72 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	6ec080e7          	jalr	1772(ra) # 80001ac8 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	70c080e7          	jalr	1804(ra) # 80001af0 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	c2e080e7          	jalr	-978(ra) # 8000501a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	c3c080e7          	jalr	-964(ra) # 80005030 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	e34080e7          	jalr	-460(ra) # 80002230 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	4d2080e7          	jalr	1234(ra) # 800028d6 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	448080e7          	jalr	1096(ra) # 80003854 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	d24080e7          	jalr	-732(ra) # 80005138 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d0e080e7          	jalr	-754(ra) # 8000112a <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	48f72323          	sw	a5,1158(a4) # 800088b0 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	47a7b783          	ld	a5,1146(a5) # 800088b8 <kernel_pagetable>
    80000446:	83b1                	srli	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	slli	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	addi	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	addi	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srli	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	addi	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	69c080e7          	jalr	1692(ra) # 80005b26 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c84080e7          	jalr	-892(ra) # 8000011a <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd4080e7          	jalr	-812(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srli	a5,s1,0xc
    800004b2:	07aa                	slli	a5,a5,0xa
    800004b4:	0017e793          	ori	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd2a7>
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	andi	s2,s2,511
    800004ca:	090e                	slli	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	andi	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srli	s1,s1,0xa
    800004da:	04b2                	slli	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srli	a0,s3,0xc
    800004e2:	1ff57513          	andi	a0,a0,511
    800004e6:	050e                	slli	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	addi	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srli	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	addi	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	andi	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	83a9                	srli	a5,a5,0xa
    8000053a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	addi	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055a:	c639                	beqz	a2,800005a8 <mappages+0x64>
    8000055c:	8aaa                	mv	s5,a0
    8000055e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000560:	777d                	lui	a4,0xfffff
    80000562:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000566:	fff58993          	addi	s3,a1,-1
    8000056a:	99b2                	add	s3,s3,a2
    8000056c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000570:	893e                	mv	s2,a5
    80000572:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000576:	6b85                	lui	s7,0x1
    80000578:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057c:	4605                	li	a2,1
    8000057e:	85ca                	mv	a1,s2
    80000580:	8556                	mv	a0,s5
    80000582:	00000097          	auipc	ra,0x0
    80000586:	eda080e7          	jalr	-294(ra) # 8000045c <walk>
    8000058a:	cd1d                	beqz	a0,800005c8 <mappages+0x84>
    if(*pte & PTE_V)
    8000058c:	611c                	ld	a5,0(a0)
    8000058e:	8b85                	andi	a5,a5,1
    80000590:	e785                	bnez	a5,800005b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000592:	80b1                	srli	s1,s1,0xc
    80000594:	04aa                	slli	s1,s1,0xa
    80000596:	0164e4b3          	or	s1,s1,s6
    8000059a:	0014e493          	ori	s1,s1,1
    8000059e:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a0:	05390063          	beq	s2,s3,800005e0 <mappages+0x9c>
    a += PGSIZE;
    800005a4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	bfc9                	j	80000578 <mappages+0x34>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	addi	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	576080e7          	jalr	1398(ra) # 80005b26 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	566080e7          	jalr	1382(ra) # 80005b26 <panic>
      return -1;
    800005c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ca:	60a6                	ld	ra,72(sp)
    800005cc:	6406                	ld	s0,64(sp)
    800005ce:	74e2                	ld	s1,56(sp)
    800005d0:	7942                	ld	s2,48(sp)
    800005d2:	79a2                	ld	s3,40(sp)
    800005d4:	7a02                	ld	s4,32(sp)
    800005d6:	6ae2                	ld	s5,24(sp)
    800005d8:	6b42                	ld	s6,16(sp)
    800005da:	6ba2                	ld	s7,8(sp)
    800005dc:	6161                	addi	sp,sp,80
    800005de:	8082                	ret
  return 0;
    800005e0:	4501                	li	a0,0
    800005e2:	b7e5                	j	800005ca <mappages+0x86>

00000000800005e4 <kvmmap>:
{
    800005e4:	1141                	addi	sp,sp,-16
    800005e6:	e406                	sd	ra,8(sp)
    800005e8:	e022                	sd	s0,0(sp)
    800005ea:	0800                	addi	s0,sp,16
    800005ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ee:	86b2                	mv	a3,a2
    800005f0:	863e                	mv	a2,a5
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	f52080e7          	jalr	-174(ra) # 80000544 <mappages>
    800005fa:	e509                	bnez	a0,80000604 <kvmmap+0x20>
}
    800005fc:	60a2                	ld	ra,8(sp)
    800005fe:	6402                	ld	s0,0(sp)
    80000600:	0141                	addi	sp,sp,16
    80000602:	8082                	ret
    panic("kvmmap");
    80000604:	00008517          	auipc	a0,0x8
    80000608:	a7450513          	addi	a0,a0,-1420 # 80008078 <etext+0x78>
    8000060c:	00005097          	auipc	ra,0x5
    80000610:	51a080e7          	jalr	1306(ra) # 80005b26 <panic>

0000000080000614 <kvmmake>:
{
    80000614:	1101                	addi	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	e04a                	sd	s2,0(sp)
    8000061e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000620:	00000097          	auipc	ra,0x0
    80000624:	afa080e7          	jalr	-1286(ra) # 8000011a <kalloc>
    80000628:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062a:	6605                	lui	a2,0x1
    8000062c:	4581                	li	a1,0
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	b4c080e7          	jalr	-1204(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000636:	4719                	li	a4,6
    80000638:	6685                	lui	a3,0x1
    8000063a:	10000637          	lui	a2,0x10000
    8000063e:	100005b7          	lui	a1,0x10000
    80000642:	8526                	mv	a0,s1
    80000644:	00000097          	auipc	ra,0x0
    80000648:	fa0080e7          	jalr	-96(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064c:	4719                	li	a4,6
    8000064e:	6685                	lui	a3,0x1
    80000650:	10001637          	lui	a2,0x10001
    80000654:	100015b7          	lui	a1,0x10001
    80000658:	8526                	mv	a0,s1
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f8a080e7          	jalr	-118(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	004006b7          	lui	a3,0x400
    80000668:	0c000637          	lui	a2,0xc000
    8000066c:	0c0005b7          	lui	a1,0xc000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f72080e7          	jalr	-142(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067a:	00008917          	auipc	s2,0x8
    8000067e:	98690913          	addi	s2,s2,-1658 # 80008000 <etext>
    80000682:	4729                	li	a4,10
    80000684:	80008697          	auipc	a3,0x80008
    80000688:	97c68693          	addi	a3,a3,-1668 # 8000 <_entry-0x7fff8000>
    8000068c:	4605                	li	a2,1
    8000068e:	067e                	slli	a2,a2,0x1f
    80000690:	85b2                	mv	a1,a2
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f50080e7          	jalr	-176(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069c:	4719                	li	a4,6
    8000069e:	46c5                	li	a3,17
    800006a0:	06ee                	slli	a3,a3,0x1b
    800006a2:	412686b3          	sub	a3,a3,s2
    800006a6:	864a                	mv	a2,s2
    800006a8:	85ca                	mv	a1,s2
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f38080e7          	jalr	-200(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b4:	4729                	li	a4,10
    800006b6:	6685                	lui	a3,0x1
    800006b8:	00007617          	auipc	a2,0x7
    800006bc:	94860613          	addi	a2,a2,-1720 # 80007000 <_trampoline>
    800006c0:	040005b7          	lui	a1,0x4000
    800006c4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c6:	05b2                	slli	a1,a1,0xc
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f1a080e7          	jalr	-230(ra) # 800005e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	608080e7          	jalr	1544(ra) # 80000cdc <proc_mapstacks>
}
    800006dc:	8526                	mv	a0,s1
    800006de:	60e2                	ld	ra,24(sp)
    800006e0:	6442                	ld	s0,16(sp)
    800006e2:	64a2                	ld	s1,8(sp)
    800006e4:	6902                	ld	s2,0(sp)
    800006e6:	6105                	addi	sp,sp,32
    800006e8:	8082                	ret

00000000800006ea <kvminit>:
{
    800006ea:	1141                	addi	sp,sp,-16
    800006ec:	e406                	sd	ra,8(sp)
    800006ee:	e022                	sd	s0,0(sp)
    800006f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f22080e7          	jalr	-222(ra) # 80000614 <kvmmake>
    800006fa:	00008797          	auipc	a5,0x8
    800006fe:	1aa7bf23          	sd	a0,446(a5) # 800088b8 <kernel_pagetable>
}
    80000702:	60a2                	ld	ra,8(sp)
    80000704:	6402                	ld	s0,0(sp)
    80000706:	0141                	addi	sp,sp,16
    80000708:	8082                	ret

000000008000070a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070a:	715d                	addi	sp,sp,-80
    8000070c:	e486                	sd	ra,72(sp)
    8000070e:	e0a2                	sd	s0,64(sp)
    80000710:	fc26                	sd	s1,56(sp)
    80000712:	f84a                	sd	s2,48(sp)
    80000714:	f44e                	sd	s3,40(sp)
    80000716:	f052                	sd	s4,32(sp)
    80000718:	ec56                	sd	s5,24(sp)
    8000071a:	e85a                	sd	s6,16(sp)
    8000071c:	e45e                	sd	s7,8(sp)
    8000071e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000720:	03459793          	slli	a5,a1,0x34
    80000724:	e795                	bnez	a5,80000750 <uvmunmap+0x46>
    80000726:	8a2a                	mv	s4,a0
    80000728:	892e                	mv	s2,a1
    8000072a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072c:	0632                	slli	a2,a2,0xc
    8000072e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000732:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	6b05                	lui	s6,0x1
    80000736:	0735e263          	bltu	a1,s3,8000079a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073a:	60a6                	ld	ra,72(sp)
    8000073c:	6406                	ld	s0,64(sp)
    8000073e:	74e2                	ld	s1,56(sp)
    80000740:	7942                	ld	s2,48(sp)
    80000742:	79a2                	ld	s3,40(sp)
    80000744:	7a02                	ld	s4,32(sp)
    80000746:	6ae2                	ld	s5,24(sp)
    80000748:	6b42                	ld	s6,16(sp)
    8000074a:	6ba2                	ld	s7,8(sp)
    8000074c:	6161                	addi	sp,sp,80
    8000074e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	93050513          	addi	a0,a0,-1744 # 80008080 <etext+0x80>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	3ce080e7          	jalr	974(ra) # 80005b26 <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	3be080e7          	jalr	958(ra) # 80005b26 <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	3ae080e7          	jalr	942(ra) # 80005b26 <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	39e080e7          	jalr	926(ra) # 80005b26 <panic>
    *pte = 0;
    80000790:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000794:	995a                	add	s2,s2,s6
    80000796:	fb3972e3          	bgeu	s2,s3,8000073a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079a:	4601                	li	a2,0
    8000079c:	85ca                	mv	a1,s2
    8000079e:	8552                	mv	a0,s4
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	cbc080e7          	jalr	-836(ra) # 8000045c <walk>
    800007a8:	84aa                	mv	s1,a0
    800007aa:	d95d                	beqz	a0,80000760 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ac:	6108                	ld	a0,0(a0)
    800007ae:	00157793          	andi	a5,a0,1
    800007b2:	dfdd                	beqz	a5,80000770 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b4:	3ff57793          	andi	a5,a0,1023
    800007b8:	fd7784e3          	beq	a5,s7,80000780 <uvmunmap+0x76>
    if(do_free){
    800007bc:	fc0a8ae3          	beqz	s5,80000790 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c2:	0532                	slli	a0,a0,0xc
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	858080e7          	jalr	-1960(ra) # 8000001c <kfree>
    800007cc:	b7d1                	j	80000790 <uvmunmap+0x86>

00000000800007ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	942080e7          	jalr	-1726(ra) # 8000011a <kalloc>
    800007e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e2:	c519                	beqz	a0,800007f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e4:	6605                	lui	a2,0x1
    800007e6:	4581                	li	a1,0
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	992080e7          	jalr	-1646(ra) # 8000017a <memset>
  return pagetable;
}
    800007f0:	8526                	mv	a0,s1
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fc:	7179                	addi	sp,sp,-48
    800007fe:	f406                	sd	ra,40(sp)
    80000800:	f022                	sd	s0,32(sp)
    80000802:	ec26                	sd	s1,24(sp)
    80000804:	e84a                	sd	s2,16(sp)
    80000806:	e44e                	sd	s3,8(sp)
    80000808:	e052                	sd	s4,0(sp)
    8000080a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080c:	6785                	lui	a5,0x1
    8000080e:	04f67863          	bgeu	a2,a5,8000085e <uvmfirst+0x62>
    80000812:	8a2a                	mv	s4,a0
    80000814:	89ae                	mv	s3,a1
    80000816:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	902080e7          	jalr	-1790(ra) # 8000011a <kalloc>
    80000820:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	954080e7          	jalr	-1708(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082e:	4779                	li	a4,30
    80000830:	86ca                	mv	a3,s2
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	8552                	mv	a0,s4
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	d0c080e7          	jalr	-756(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000840:	8626                	mv	a2,s1
    80000842:	85ce                	mv	a1,s3
    80000844:	854a                	mv	a0,s2
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	990080e7          	jalr	-1648(ra) # 800001d6 <memmove>
}
    8000084e:	70a2                	ld	ra,40(sp)
    80000850:	7402                	ld	s0,32(sp)
    80000852:	64e2                	ld	s1,24(sp)
    80000854:	6942                	ld	s2,16(sp)
    80000856:	69a2                	ld	s3,8(sp)
    80000858:	6a02                	ld	s4,0(sp)
    8000085a:	6145                	addi	sp,sp,48
    8000085c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	87a50513          	addi	a0,a0,-1926 # 800080d8 <etext+0xd8>
    80000866:	00005097          	auipc	ra,0x5
    8000086a:	2c0080e7          	jalr	704(ra) # 80005b26 <panic>

000000008000086e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086e:	1101                	addi	sp,sp,-32
    80000870:	ec06                	sd	ra,24(sp)
    80000872:	e822                	sd	s0,16(sp)
    80000874:	e426                	sd	s1,8(sp)
    80000876:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000878:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087a:	00b67d63          	bgeu	a2,a1,80000894 <uvmdealloc+0x26>
    8000087e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000880:	6785                	lui	a5,0x1
    80000882:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000884:	00f60733          	add	a4,a2,a5
    80000888:	76fd                	lui	a3,0xfffff
    8000088a:	8f75                	and	a4,a4,a3
    8000088c:	97ae                	add	a5,a5,a1
    8000088e:	8ff5                	and	a5,a5,a3
    80000890:	00f76863          	bltu	a4,a5,800008a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000894:	8526                	mv	a0,s1
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a0:	8f99                	sub	a5,a5,a4
    800008a2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a4:	4685                	li	a3,1
    800008a6:	0007861b          	sext.w	a2,a5
    800008aa:	85ba                	mv	a1,a4
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	e5e080e7          	jalr	-418(ra) # 8000070a <uvmunmap>
    800008b4:	b7c5                	j	80000894 <uvmdealloc+0x26>

00000000800008b6 <uvmalloc>:
  if(newsz < oldsz)
    800008b6:	0ab66563          	bltu	a2,a1,80000960 <uvmalloc+0xaa>
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	f426                	sd	s1,40(sp)
    800008c2:	f04a                	sd	s2,32(sp)
    800008c4:	ec4e                	sd	s3,24(sp)
    800008c6:	e852                	sd	s4,16(sp)
    800008c8:	e456                	sd	s5,8(sp)
    800008ca:	e05a                	sd	s6,0(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	77fd                	lui	a5,0xfffff
    800008da:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f363          	bgeu	s3,a2,80000964 <uvmalloc+0xae>
    800008e2:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e4:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c51d                	beqz	a0,80000920 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000900:	875a                	mv	a4,s6
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c3a080e7          	jalr	-966(ra) # 80000544 <mappages>
    80000912:	e90d                	bnez	a0,80000944 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x32>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	a809                	j	80000930 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000920:	864e                	mv	a2,s3
    80000922:	85ca                	mv	a1,s2
    80000924:	8556                	mv	a0,s5
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	f48080e7          	jalr	-184(ra) # 8000086e <uvmdealloc>
      return 0;
    8000092e:	4501                	li	a0,0
}
    80000930:	70e2                	ld	ra,56(sp)
    80000932:	7442                	ld	s0,48(sp)
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
    80000938:	69e2                	ld	s3,24(sp)
    8000093a:	6a42                	ld	s4,16(sp)
    8000093c:	6aa2                	ld	s5,8(sp)
    8000093e:	6b02                	ld	s6,0(sp)
    80000940:	6121                	addi	sp,sp,64
    80000942:	8082                	ret
      kfree(mem);
    80000944:	8526                	mv	a0,s1
    80000946:	fffff097          	auipc	ra,0xfffff
    8000094a:	6d6080e7          	jalr	1750(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094e:	864e                	mv	a2,s3
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	f1a080e7          	jalr	-230(ra) # 8000086e <uvmdealloc>
      return 0;
    8000095c:	4501                	li	a0,0
    8000095e:	bfc9                	j	80000930 <uvmalloc+0x7a>
    return oldsz;
    80000960:	852e                	mv	a0,a1
}
    80000962:	8082                	ret
  return newsz;
    80000964:	8532                	mv	a0,a2
    80000966:	b7e9                	j	80000930 <uvmalloc+0x7a>

0000000080000968 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000968:	7179                	addi	sp,sp,-48
    8000096a:	f406                	sd	ra,40(sp)
    8000096c:	f022                	sd	s0,32(sp)
    8000096e:	ec26                	sd	s1,24(sp)
    80000970:	e84a                	sd	s2,16(sp)
    80000972:	e44e                	sd	s3,8(sp)
    80000974:	e052                	sd	s4,0(sp)
    80000976:	1800                	addi	s0,sp,48
    80000978:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097a:	84aa                	mv	s1,a0
    8000097c:	6905                	lui	s2,0x1
    8000097e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000980:	4985                	li	s3,1
    80000982:	a829                	j	8000099c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000984:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000986:	00c79513          	slli	a0,a5,0xc
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	fde080e7          	jalr	-34(ra) # 80000968 <freewalk>
      pagetable[i] = 0;
    80000992:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000996:	04a1                	addi	s1,s1,8
    80000998:	03248163          	beq	s1,s2,800009ba <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099e:	00f7f713          	andi	a4,a5,15
    800009a2:	ff3701e3          	beq	a4,s3,80000984 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a6:	8b85                	andi	a5,a5,1
    800009a8:	d7fd                	beqz	a5,80000996 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009aa:	00007517          	auipc	a0,0x7
    800009ae:	74e50513          	addi	a0,a0,1870 # 800080f8 <etext+0xf8>
    800009b2:	00005097          	auipc	ra,0x5
    800009b6:	174080e7          	jalr	372(ra) # 80005b26 <panic>
    }
  }
  kfree((void*)pagetable);
    800009ba:	8552                	mv	a0,s4
    800009bc:	fffff097          	auipc	ra,0xfffff
    800009c0:	660080e7          	jalr	1632(ra) # 8000001c <kfree>
}
    800009c4:	70a2                	ld	ra,40(sp)
    800009c6:	7402                	ld	s0,32(sp)
    800009c8:	64e2                	ld	s1,24(sp)
    800009ca:	6942                	ld	s2,16(sp)
    800009cc:	69a2                	ld	s3,8(sp)
    800009ce:	6a02                	ld	s4,0(sp)
    800009d0:	6145                	addi	sp,sp,48
    800009d2:	8082                	ret

00000000800009d4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d4:	1101                	addi	sp,sp,-32
    800009d6:	ec06                	sd	ra,24(sp)
    800009d8:	e822                	sd	s0,16(sp)
    800009da:	e426                	sd	s1,8(sp)
    800009dc:	1000                	addi	s0,sp,32
    800009de:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e0:	e999                	bnez	a1,800009f6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e2:	8526                	mv	a0,s1
    800009e4:	00000097          	auipc	ra,0x0
    800009e8:	f84080e7          	jalr	-124(ra) # 80000968 <freewalk>
}
    800009ec:	60e2                	ld	ra,24(sp)
    800009ee:	6442                	ld	s0,16(sp)
    800009f0:	64a2                	ld	s1,8(sp)
    800009f2:	6105                	addi	sp,sp,32
    800009f4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f6:	6785                	lui	a5,0x1
    800009f8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009fa:	95be                	add	a1,a1,a5
    800009fc:	4685                	li	a3,1
    800009fe:	00c5d613          	srli	a2,a1,0xc
    80000a02:	4581                	li	a1,0
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	d06080e7          	jalr	-762(ra) # 8000070a <uvmunmap>
    80000a0c:	bfd9                	j	800009e2 <uvmfree+0xe>

0000000080000a0e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a0e:	c679                	beqz	a2,80000adc <uvmcopy+0xce>
{
    80000a10:	715d                	addi	sp,sp,-80
    80000a12:	e486                	sd	ra,72(sp)
    80000a14:	e0a2                	sd	s0,64(sp)
    80000a16:	fc26                	sd	s1,56(sp)
    80000a18:	f84a                	sd	s2,48(sp)
    80000a1a:	f44e                	sd	s3,40(sp)
    80000a1c:	f052                	sd	s4,32(sp)
    80000a1e:	ec56                	sd	s5,24(sp)
    80000a20:	e85a                	sd	s6,16(sp)
    80000a22:	e45e                	sd	s7,8(sp)
    80000a24:	0880                	addi	s0,sp,80
    80000a26:	8b2a                	mv	s6,a0
    80000a28:	8aae                	mv	s5,a1
    80000a2a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a2c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a2e:	4601                	li	a2,0
    80000a30:	85ce                	mv	a1,s3
    80000a32:	855a                	mv	a0,s6
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	a28080e7          	jalr	-1496(ra) # 8000045c <walk>
    80000a3c:	c531                	beqz	a0,80000a88 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a3e:	6118                	ld	a4,0(a0)
    80000a40:	00177793          	andi	a5,a4,1
    80000a44:	cbb1                	beqz	a5,80000a98 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a46:	00a75593          	srli	a1,a4,0xa
    80000a4a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a4e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a52:	fffff097          	auipc	ra,0xfffff
    80000a56:	6c8080e7          	jalr	1736(ra) # 8000011a <kalloc>
    80000a5a:	892a                	mv	s2,a0
    80000a5c:	c939                	beqz	a0,80000ab2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a5e:	6605                	lui	a2,0x1
    80000a60:	85de                	mv	a1,s7
    80000a62:	fffff097          	auipc	ra,0xfffff
    80000a66:	774080e7          	jalr	1908(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6a:	8726                	mv	a4,s1
    80000a6c:	86ca                	mv	a3,s2
    80000a6e:	6605                	lui	a2,0x1
    80000a70:	85ce                	mv	a1,s3
    80000a72:	8556                	mv	a0,s5
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	ad0080e7          	jalr	-1328(ra) # 80000544 <mappages>
    80000a7c:	e515                	bnez	a0,80000aa8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a7e:	6785                	lui	a5,0x1
    80000a80:	99be                	add	s3,s3,a5
    80000a82:	fb49e6e3          	bltu	s3,s4,80000a2e <uvmcopy+0x20>
    80000a86:	a081                	j	80000ac6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	68050513          	addi	a0,a0,1664 # 80008108 <etext+0x108>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	096080e7          	jalr	150(ra) # 80005b26 <panic>
      panic("uvmcopy: page not present");
    80000a98:	00007517          	auipc	a0,0x7
    80000a9c:	69050513          	addi	a0,a0,1680 # 80008128 <etext+0x128>
    80000aa0:	00005097          	auipc	ra,0x5
    80000aa4:	086080e7          	jalr	134(ra) # 80005b26 <panic>
      kfree(mem);
    80000aa8:	854a                	mv	a0,s2
    80000aaa:	fffff097          	auipc	ra,0xfffff
    80000aae:	572080e7          	jalr	1394(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab2:	4685                	li	a3,1
    80000ab4:	00c9d613          	srli	a2,s3,0xc
    80000ab8:	4581                	li	a1,0
    80000aba:	8556                	mv	a0,s5
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	c4e080e7          	jalr	-946(ra) # 8000070a <uvmunmap>
  return -1;
    80000ac4:	557d                	li	a0,-1
}
    80000ac6:	60a6                	ld	ra,72(sp)
    80000ac8:	6406                	ld	s0,64(sp)
    80000aca:	74e2                	ld	s1,56(sp)
    80000acc:	7942                	ld	s2,48(sp)
    80000ace:	79a2                	ld	s3,40(sp)
    80000ad0:	7a02                	ld	s4,32(sp)
    80000ad2:	6ae2                	ld	s5,24(sp)
    80000ad4:	6b42                	ld	s6,16(sp)
    80000ad6:	6ba2                	ld	s7,8(sp)
    80000ad8:	6161                	addi	sp,sp,80
    80000ada:	8082                	ret
  return 0;
    80000adc:	4501                	li	a0,0
}
    80000ade:	8082                	ret

0000000080000ae0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae0:	1141                	addi	sp,sp,-16
    80000ae2:	e406                	sd	ra,8(sp)
    80000ae4:	e022                	sd	s0,0(sp)
    80000ae6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae8:	4601                	li	a2,0
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	972080e7          	jalr	-1678(ra) # 8000045c <walk>
  if(pte == 0)
    80000af2:	c901                	beqz	a0,80000b02 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af4:	611c                	ld	a5,0(a0)
    80000af6:	9bbd                	andi	a5,a5,-17
    80000af8:	e11c                	sd	a5,0(a0)
}
    80000afa:	60a2                	ld	ra,8(sp)
    80000afc:	6402                	ld	s0,0(sp)
    80000afe:	0141                	addi	sp,sp,16
    80000b00:	8082                	ret
    panic("uvmclear");
    80000b02:	00007517          	auipc	a0,0x7
    80000b06:	64650513          	addi	a0,a0,1606 # 80008148 <etext+0x148>
    80000b0a:	00005097          	auipc	ra,0x5
    80000b0e:	01c080e7          	jalr	28(ra) # 80005b26 <panic>

0000000080000b12 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b12:	c6bd                	beqz	a3,80000b80 <copyout+0x6e>
{
    80000b14:	715d                	addi	sp,sp,-80
    80000b16:	e486                	sd	ra,72(sp)
    80000b18:	e0a2                	sd	s0,64(sp)
    80000b1a:	fc26                	sd	s1,56(sp)
    80000b1c:	f84a                	sd	s2,48(sp)
    80000b1e:	f44e                	sd	s3,40(sp)
    80000b20:	f052                	sd	s4,32(sp)
    80000b22:	ec56                	sd	s5,24(sp)
    80000b24:	e85a                	sd	s6,16(sp)
    80000b26:	e45e                	sd	s7,8(sp)
    80000b28:	e062                	sd	s8,0(sp)
    80000b2a:	0880                	addi	s0,sp,80
    80000b2c:	8b2a                	mv	s6,a0
    80000b2e:	8c2e                	mv	s8,a1
    80000b30:	8a32                	mv	s4,a2
    80000b32:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b34:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b36:	6a85                	lui	s5,0x1
    80000b38:	a015                	j	80000b5c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3a:	9562                	add	a0,a0,s8
    80000b3c:	0004861b          	sext.w	a2,s1
    80000b40:	85d2                	mv	a1,s4
    80000b42:	41250533          	sub	a0,a0,s2
    80000b46:	fffff097          	auipc	ra,0xfffff
    80000b4a:	690080e7          	jalr	1680(ra) # 800001d6 <memmove>

    len -= n;
    80000b4e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b52:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b54:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b58:	02098263          	beqz	s3,80000b7c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b5c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b60:	85ca                	mv	a1,s2
    80000b62:	855a                	mv	a0,s6
    80000b64:	00000097          	auipc	ra,0x0
    80000b68:	99e080e7          	jalr	-1634(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000b6c:	cd01                	beqz	a0,80000b84 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b6e:	418904b3          	sub	s1,s2,s8
    80000b72:	94d6                	add	s1,s1,s5
    80000b74:	fc99f3e3          	bgeu	s3,s1,80000b3a <copyout+0x28>
    80000b78:	84ce                	mv	s1,s3
    80000b7a:	b7c1                	j	80000b3a <copyout+0x28>
  }
  return 0;
    80000b7c:	4501                	li	a0,0
    80000b7e:	a021                	j	80000b86 <copyout+0x74>
    80000b80:	4501                	li	a0,0
}
    80000b82:	8082                	ret
      return -1;
    80000b84:	557d                	li	a0,-1
}
    80000b86:	60a6                	ld	ra,72(sp)
    80000b88:	6406                	ld	s0,64(sp)
    80000b8a:	74e2                	ld	s1,56(sp)
    80000b8c:	7942                	ld	s2,48(sp)
    80000b8e:	79a2                	ld	s3,40(sp)
    80000b90:	7a02                	ld	s4,32(sp)
    80000b92:	6ae2                	ld	s5,24(sp)
    80000b94:	6b42                	ld	s6,16(sp)
    80000b96:	6ba2                	ld	s7,8(sp)
    80000b98:	6c02                	ld	s8,0(sp)
    80000b9a:	6161                	addi	sp,sp,80
    80000b9c:	8082                	ret

0000000080000b9e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b9e:	caa5                	beqz	a3,80000c0e <copyin+0x70>
{
    80000ba0:	715d                	addi	sp,sp,-80
    80000ba2:	e486                	sd	ra,72(sp)
    80000ba4:	e0a2                	sd	s0,64(sp)
    80000ba6:	fc26                	sd	s1,56(sp)
    80000ba8:	f84a                	sd	s2,48(sp)
    80000baa:	f44e                	sd	s3,40(sp)
    80000bac:	f052                	sd	s4,32(sp)
    80000bae:	ec56                	sd	s5,24(sp)
    80000bb0:	e85a                	sd	s6,16(sp)
    80000bb2:	e45e                	sd	s7,8(sp)
    80000bb4:	e062                	sd	s8,0(sp)
    80000bb6:	0880                	addi	s0,sp,80
    80000bb8:	8b2a                	mv	s6,a0
    80000bba:	8a2e                	mv	s4,a1
    80000bbc:	8c32                	mv	s8,a2
    80000bbe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc2:	6a85                	lui	s5,0x1
    80000bc4:	a01d                	j	80000bea <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc6:	018505b3          	add	a1,a0,s8
    80000bca:	0004861b          	sext.w	a2,s1
    80000bce:	412585b3          	sub	a1,a1,s2
    80000bd2:	8552                	mv	a0,s4
    80000bd4:	fffff097          	auipc	ra,0xfffff
    80000bd8:	602080e7          	jalr	1538(ra) # 800001d6 <memmove>

    len -= n;
    80000bdc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be6:	02098263          	beqz	s3,80000c0a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bea:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bee:	85ca                	mv	a1,s2
    80000bf0:	855a                	mv	a0,s6
    80000bf2:	00000097          	auipc	ra,0x0
    80000bf6:	910080e7          	jalr	-1776(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000bfa:	cd01                	beqz	a0,80000c12 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bfc:	418904b3          	sub	s1,s2,s8
    80000c00:	94d6                	add	s1,s1,s5
    80000c02:	fc99f2e3          	bgeu	s3,s1,80000bc6 <copyin+0x28>
    80000c06:	84ce                	mv	s1,s3
    80000c08:	bf7d                	j	80000bc6 <copyin+0x28>
  }
  return 0;
    80000c0a:	4501                	li	a0,0
    80000c0c:	a021                	j	80000c14 <copyin+0x76>
    80000c0e:	4501                	li	a0,0
}
    80000c10:	8082                	ret
      return -1;
    80000c12:	557d                	li	a0,-1
}
    80000c14:	60a6                	ld	ra,72(sp)
    80000c16:	6406                	ld	s0,64(sp)
    80000c18:	74e2                	ld	s1,56(sp)
    80000c1a:	7942                	ld	s2,48(sp)
    80000c1c:	79a2                	ld	s3,40(sp)
    80000c1e:	7a02                	ld	s4,32(sp)
    80000c20:	6ae2                	ld	s5,24(sp)
    80000c22:	6b42                	ld	s6,16(sp)
    80000c24:	6ba2                	ld	s7,8(sp)
    80000c26:	6c02                	ld	s8,0(sp)
    80000c28:	6161                	addi	sp,sp,80
    80000c2a:	8082                	ret

0000000080000c2c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2c:	c2dd                	beqz	a3,80000cd2 <copyinstr+0xa6>
{
    80000c2e:	715d                	addi	sp,sp,-80
    80000c30:	e486                	sd	ra,72(sp)
    80000c32:	e0a2                	sd	s0,64(sp)
    80000c34:	fc26                	sd	s1,56(sp)
    80000c36:	f84a                	sd	s2,48(sp)
    80000c38:	f44e                	sd	s3,40(sp)
    80000c3a:	f052                	sd	s4,32(sp)
    80000c3c:	ec56                	sd	s5,24(sp)
    80000c3e:	e85a                	sd	s6,16(sp)
    80000c40:	e45e                	sd	s7,8(sp)
    80000c42:	0880                	addi	s0,sp,80
    80000c44:	8a2a                	mv	s4,a0
    80000c46:	8b2e                	mv	s6,a1
    80000c48:	8bb2                	mv	s7,a2
    80000c4a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4e:	6985                	lui	s3,0x1
    80000c50:	a02d                	j	80000c7a <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c52:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c56:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c58:	37fd                	addiw	a5,a5,-1
    80000c5a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c5e:	60a6                	ld	ra,72(sp)
    80000c60:	6406                	ld	s0,64(sp)
    80000c62:	74e2                	ld	s1,56(sp)
    80000c64:	7942                	ld	s2,48(sp)
    80000c66:	79a2                	ld	s3,40(sp)
    80000c68:	7a02                	ld	s4,32(sp)
    80000c6a:	6ae2                	ld	s5,24(sp)
    80000c6c:	6b42                	ld	s6,16(sp)
    80000c6e:	6ba2                	ld	s7,8(sp)
    80000c70:	6161                	addi	sp,sp,80
    80000c72:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c74:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c78:	c8a9                	beqz	s1,80000cca <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c7a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c7e:	85ca                	mv	a1,s2
    80000c80:	8552                	mv	a0,s4
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	880080e7          	jalr	-1920(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c8a:	c131                	beqz	a0,80000cce <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c8c:	417906b3          	sub	a3,s2,s7
    80000c90:	96ce                	add	a3,a3,s3
    80000c92:	00d4f363          	bgeu	s1,a3,80000c98 <copyinstr+0x6c>
    80000c96:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c98:	955e                	add	a0,a0,s7
    80000c9a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c9e:	daf9                	beqz	a3,80000c74 <copyinstr+0x48>
    80000ca0:	87da                	mv	a5,s6
    80000ca2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ca8:	96da                	add	a3,a3,s6
    80000caa:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cac:	00f60733          	add	a4,a2,a5
    80000cb0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd2b0>
    80000cb4:	df59                	beqz	a4,80000c52 <copyinstr+0x26>
        *dst = *p;
    80000cb6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000cba:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cbc:	fed797e3          	bne	a5,a3,80000caa <copyinstr+0x7e>
    80000cc0:	14fd                	addi	s1,s1,-1
    80000cc2:	94c2                	add	s1,s1,a6
      --max;
    80000cc4:	8c8d                	sub	s1,s1,a1
      dst++;
    80000cc6:	8b3e                	mv	s6,a5
    80000cc8:	b775                	j	80000c74 <copyinstr+0x48>
    80000cca:	4781                	li	a5,0
    80000ccc:	b771                	j	80000c58 <copyinstr+0x2c>
      return -1;
    80000cce:	557d                	li	a0,-1
    80000cd0:	b779                	j	80000c5e <copyinstr+0x32>
  int got_null = 0;
    80000cd2:	4781                	li	a5,0
  if(got_null){
    80000cd4:	37fd                	addiw	a5,a5,-1
    80000cd6:	0007851b          	sext.w	a0,a5
}
    80000cda:	8082                	ret

0000000080000cdc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cdc:	7139                	addi	sp,sp,-64
    80000cde:	fc06                	sd	ra,56(sp)
    80000ce0:	f822                	sd	s0,48(sp)
    80000ce2:	f426                	sd	s1,40(sp)
    80000ce4:	f04a                	sd	s2,32(sp)
    80000ce6:	ec4e                	sd	s3,24(sp)
    80000ce8:	e852                	sd	s4,16(sp)
    80000cea:	e456                	sd	s5,8(sp)
    80000cec:	e05a                	sd	s6,0(sp)
    80000cee:	0080                	addi	s0,sp,64
    80000cf0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	00008497          	auipc	s1,0x8
    80000cf6:	03e48493          	addi	s1,s1,62 # 80008d30 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfa:	8b26                	mv	s6,s1
    80000cfc:	00007a97          	auipc	s5,0x7
    80000d00:	304a8a93          	addi	s5,s5,772 # 80008000 <etext>
    80000d04:	04000937          	lui	s2,0x4000
    80000d08:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d0a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	0000ea17          	auipc	s4,0xe
    80000d10:	a24a0a13          	addi	s4,s4,-1500 # 8000e730 <tickslock>
    char *pa = kalloc();
    80000d14:	fffff097          	auipc	ra,0xfffff
    80000d18:	406080e7          	jalr	1030(ra) # 8000011a <kalloc>
    80000d1c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d1e:	c131                	beqz	a0,80000d62 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d20:	416485b3          	sub	a1,s1,s6
    80000d24:	858d                	srai	a1,a1,0x3
    80000d26:	000ab783          	ld	a5,0(s5)
    80000d2a:	02f585b3          	mul	a1,a1,a5
    80000d2e:	2585                	addiw	a1,a1,1
    80000d30:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d34:	4719                	li	a4,6
    80000d36:	6685                	lui	a3,0x1
    80000d38:	40b905b3          	sub	a1,s2,a1
    80000d3c:	854e                	mv	a0,s3
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	8a6080e7          	jalr	-1882(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d46:	16848493          	addi	s1,s1,360
    80000d4a:	fd4495e3          	bne	s1,s4,80000d14 <proc_mapstacks+0x38>
  }
}
    80000d4e:	70e2                	ld	ra,56(sp)
    80000d50:	7442                	ld	s0,48(sp)
    80000d52:	74a2                	ld	s1,40(sp)
    80000d54:	7902                	ld	s2,32(sp)
    80000d56:	69e2                	ld	s3,24(sp)
    80000d58:	6a42                	ld	s4,16(sp)
    80000d5a:	6aa2                	ld	s5,8(sp)
    80000d5c:	6b02                	ld	s6,0(sp)
    80000d5e:	6121                	addi	sp,sp,64
    80000d60:	8082                	ret
      panic("kalloc");
    80000d62:	00007517          	auipc	a0,0x7
    80000d66:	3f650513          	addi	a0,a0,1014 # 80008158 <etext+0x158>
    80000d6a:	00005097          	auipc	ra,0x5
    80000d6e:	dbc080e7          	jalr	-580(ra) # 80005b26 <panic>

0000000080000d72 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d72:	7139                	addi	sp,sp,-64
    80000d74:	fc06                	sd	ra,56(sp)
    80000d76:	f822                	sd	s0,48(sp)
    80000d78:	f426                	sd	s1,40(sp)
    80000d7a:	f04a                	sd	s2,32(sp)
    80000d7c:	ec4e                	sd	s3,24(sp)
    80000d7e:	e852                	sd	s4,16(sp)
    80000d80:	e456                	sd	s5,8(sp)
    80000d82:	e05a                	sd	s6,0(sp)
    80000d84:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d86:	00007597          	auipc	a1,0x7
    80000d8a:	3da58593          	addi	a1,a1,986 # 80008160 <etext+0x160>
    80000d8e:	00008517          	auipc	a0,0x8
    80000d92:	b7250513          	addi	a0,a0,-1166 # 80008900 <pid_lock>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	238080e7          	jalr	568(ra) # 80005fce <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9e:	00007597          	auipc	a1,0x7
    80000da2:	3ca58593          	addi	a1,a1,970 # 80008168 <etext+0x168>
    80000da6:	00008517          	auipc	a0,0x8
    80000daa:	b7250513          	addi	a0,a0,-1166 # 80008918 <wait_lock>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	220080e7          	jalr	544(ra) # 80005fce <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db6:	00008497          	auipc	s1,0x8
    80000dba:	f7a48493          	addi	s1,s1,-134 # 80008d30 <proc>
      initlock(&p->lock, "proc");
    80000dbe:	00007b17          	auipc	s6,0x7
    80000dc2:	3bab0b13          	addi	s6,s6,954 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dc6:	8aa6                	mv	s5,s1
    80000dc8:	00007a17          	auipc	s4,0x7
    80000dcc:	238a0a13          	addi	s4,s4,568 # 80008000 <etext>
    80000dd0:	04000937          	lui	s2,0x4000
    80000dd4:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dd6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd8:	0000e997          	auipc	s3,0xe
    80000ddc:	95898993          	addi	s3,s3,-1704 # 8000e730 <tickslock>
      initlock(&p->lock, "proc");
    80000de0:	85da                	mv	a1,s6
    80000de2:	8526                	mv	a0,s1
    80000de4:	00005097          	auipc	ra,0x5
    80000de8:	1ea080e7          	jalr	490(ra) # 80005fce <initlock>
      p->state = UNUSED;
    80000dec:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df0:	415487b3          	sub	a5,s1,s5
    80000df4:	878d                	srai	a5,a5,0x3
    80000df6:	000a3703          	ld	a4,0(s4)
    80000dfa:	02e787b3          	mul	a5,a5,a4
    80000dfe:	2785                	addiw	a5,a5,1
    80000e00:	00d7979b          	slliw	a5,a5,0xd
    80000e04:	40f907b3          	sub	a5,s2,a5
    80000e08:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	16848493          	addi	s1,s1,360
    80000e0e:	fd3499e3          	bne	s1,s3,80000de0 <procinit+0x6e>
  }
}
    80000e12:	70e2                	ld	ra,56(sp)
    80000e14:	7442                	ld	s0,48(sp)
    80000e16:	74a2                	ld	s1,40(sp)
    80000e18:	7902                	ld	s2,32(sp)
    80000e1a:	69e2                	ld	s3,24(sp)
    80000e1c:	6a42                	ld	s4,16(sp)
    80000e1e:	6aa2                	ld	s5,8(sp)
    80000e20:	6b02                	ld	s6,0(sp)
    80000e22:	6121                	addi	sp,sp,64
    80000e24:	8082                	ret

0000000080000e26 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e422                	sd	s0,8(sp)
    80000e2a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e2c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e2e:	2501                	sext.w	a0,a0
    80000e30:	6422                	ld	s0,8(sp)
    80000e32:	0141                	addi	sp,sp,16
    80000e34:	8082                	ret

0000000080000e36 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
    80000e3c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e3e:	2781                	sext.w	a5,a5
    80000e40:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e42:	00008517          	auipc	a0,0x8
    80000e46:	aee50513          	addi	a0,a0,-1298 # 80008930 <cpus>
    80000e4a:	953e                	add	a0,a0,a5
    80000e4c:	6422                	ld	s0,8(sp)
    80000e4e:	0141                	addi	sp,sp,16
    80000e50:	8082                	ret

0000000080000e52 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e52:	1101                	addi	sp,sp,-32
    80000e54:	ec06                	sd	ra,24(sp)
    80000e56:	e822                	sd	s0,16(sp)
    80000e58:	e426                	sd	s1,8(sp)
    80000e5a:	1000                	addi	s0,sp,32
  push_off();
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	1b6080e7          	jalr	438(ra) # 80006012 <push_off>
    80000e64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e66:	2781                	sext.w	a5,a5
    80000e68:	079e                	slli	a5,a5,0x7
    80000e6a:	00008717          	auipc	a4,0x8
    80000e6e:	a9670713          	addi	a4,a4,-1386 # 80008900 <pid_lock>
    80000e72:	97ba                	add	a5,a5,a4
    80000e74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	23c080e7          	jalr	572(ra) # 800060b2 <pop_off>
  return p;
}
    80000e7e:	8526                	mv	a0,s1
    80000e80:	60e2                	ld	ra,24(sp)
    80000e82:	6442                	ld	s0,16(sp)
    80000e84:	64a2                	ld	s1,8(sp)
    80000e86:	6105                	addi	sp,sp,32
    80000e88:	8082                	ret

0000000080000e8a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e8a:	1141                	addi	sp,sp,-16
    80000e8c:	e406                	sd	ra,8(sp)
    80000e8e:	e022                	sd	s0,0(sp)
    80000e90:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e92:	00000097          	auipc	ra,0x0
    80000e96:	fc0080e7          	jalr	-64(ra) # 80000e52 <myproc>
    80000e9a:	00005097          	auipc	ra,0x5
    80000e9e:	278080e7          	jalr	632(ra) # 80006112 <release>

  if (first) {
    80000ea2:	00008797          	auipc	a5,0x8
    80000ea6:	99e7a783          	lw	a5,-1634(a5) # 80008840 <first.1>
    80000eaa:	eb89                	bnez	a5,80000ebc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eac:	00001097          	auipc	ra,0x1
    80000eb0:	c5c080e7          	jalr	-932(ra) # 80001b08 <usertrapret>
}
    80000eb4:	60a2                	ld	ra,8(sp)
    80000eb6:	6402                	ld	s0,0(sp)
    80000eb8:	0141                	addi	sp,sp,16
    80000eba:	8082                	ret
    first = 0;
    80000ebc:	00008797          	auipc	a5,0x8
    80000ec0:	9807a223          	sw	zero,-1660(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000ec4:	4505                	li	a0,1
    80000ec6:	00002097          	auipc	ra,0x2
    80000eca:	990080e7          	jalr	-1648(ra) # 80002856 <fsinit>
    80000ece:	bff9                	j	80000eac <forkret+0x22>

0000000080000ed0 <allocpid>:
{
    80000ed0:	1101                	addi	sp,sp,-32
    80000ed2:	ec06                	sd	ra,24(sp)
    80000ed4:	e822                	sd	s0,16(sp)
    80000ed6:	e426                	sd	s1,8(sp)
    80000ed8:	e04a                	sd	s2,0(sp)
    80000eda:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000edc:	00008917          	auipc	s2,0x8
    80000ee0:	a2490913          	addi	s2,s2,-1500 # 80008900 <pid_lock>
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	178080e7          	jalr	376(ra) # 8000605e <acquire>
  pid = nextpid;
    80000eee:	00008797          	auipc	a5,0x8
    80000ef2:	95678793          	addi	a5,a5,-1706 # 80008844 <nextpid>
    80000ef6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef8:	0014871b          	addiw	a4,s1,1
    80000efc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efe:	854a                	mv	a0,s2
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	212080e7          	jalr	530(ra) # 80006112 <release>
}
    80000f08:	8526                	mv	a0,s1
    80000f0a:	60e2                	ld	ra,24(sp)
    80000f0c:	6442                	ld	s0,16(sp)
    80000f0e:	64a2                	ld	s1,8(sp)
    80000f10:	6902                	ld	s2,0(sp)
    80000f12:	6105                	addi	sp,sp,32
    80000f14:	8082                	ret

0000000080000f16 <proc_pagetable>:
{
    80000f16:	1101                	addi	sp,sp,-32
    80000f18:	ec06                	sd	ra,24(sp)
    80000f1a:	e822                	sd	s0,16(sp)
    80000f1c:	e426                	sd	s1,8(sp)
    80000f1e:	e04a                	sd	s2,0(sp)
    80000f20:	1000                	addi	s0,sp,32
    80000f22:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	8aa080e7          	jalr	-1878(ra) # 800007ce <uvmcreate>
    80000f2c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f2e:	c121                	beqz	a0,80000f6e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f30:	4729                	li	a4,10
    80000f32:	00006697          	auipc	a3,0x6
    80000f36:	0ce68693          	addi	a3,a3,206 # 80007000 <_trampoline>
    80000f3a:	6605                	lui	a2,0x1
    80000f3c:	040005b7          	lui	a1,0x4000
    80000f40:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f42:	05b2                	slli	a1,a1,0xc
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	600080e7          	jalr	1536(ra) # 80000544 <mappages>
    80000f4c:	02054863          	bltz	a0,80000f7c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f50:	4719                	li	a4,6
    80000f52:	05893683          	ld	a3,88(s2)
    80000f56:	6605                	lui	a2,0x1
    80000f58:	020005b7          	lui	a1,0x2000
    80000f5c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f5e:	05b6                	slli	a1,a1,0xd
    80000f60:	8526                	mv	a0,s1
    80000f62:	fffff097          	auipc	ra,0xfffff
    80000f66:	5e2080e7          	jalr	1506(ra) # 80000544 <mappages>
    80000f6a:	02054163          	bltz	a0,80000f8c <proc_pagetable+0x76>
}
    80000f6e:	8526                	mv	a0,s1
    80000f70:	60e2                	ld	ra,24(sp)
    80000f72:	6442                	ld	s0,16(sp)
    80000f74:	64a2                	ld	s1,8(sp)
    80000f76:	6902                	ld	s2,0(sp)
    80000f78:	6105                	addi	sp,sp,32
    80000f7a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f7c:	4581                	li	a1,0
    80000f7e:	8526                	mv	a0,s1
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	a54080e7          	jalr	-1452(ra) # 800009d4 <uvmfree>
    return 0;
    80000f88:	4481                	li	s1,0
    80000f8a:	b7d5                	j	80000f6e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8c:	4681                	li	a3,0
    80000f8e:	4605                	li	a2,1
    80000f90:	040005b7          	lui	a1,0x4000
    80000f94:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f96:	05b2                	slli	a1,a1,0xc
    80000f98:	8526                	mv	a0,s1
    80000f9a:	fffff097          	auipc	ra,0xfffff
    80000f9e:	770080e7          	jalr	1904(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa2:	4581                	li	a1,0
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	a2e080e7          	jalr	-1490(ra) # 800009d4 <uvmfree>
    return 0;
    80000fae:	4481                	li	s1,0
    80000fb0:	bf7d                	j	80000f6e <proc_pagetable+0x58>

0000000080000fb2 <proc_freepagetable>:
{
    80000fb2:	1101                	addi	sp,sp,-32
    80000fb4:	ec06                	sd	ra,24(sp)
    80000fb6:	e822                	sd	s0,16(sp)
    80000fb8:	e426                	sd	s1,8(sp)
    80000fba:	e04a                	sd	s2,0(sp)
    80000fbc:	1000                	addi	s0,sp,32
    80000fbe:	84aa                	mv	s1,a0
    80000fc0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc2:	4681                	li	a3,0
    80000fc4:	4605                	li	a2,1
    80000fc6:	040005b7          	lui	a1,0x4000
    80000fca:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fcc:	05b2                	slli	a1,a1,0xc
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	73c080e7          	jalr	1852(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd6:	4681                	li	a3,0
    80000fd8:	4605                	li	a2,1
    80000fda:	020005b7          	lui	a1,0x2000
    80000fde:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fe0:	05b6                	slli	a1,a1,0xd
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	726080e7          	jalr	1830(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80000fec:	85ca                	mv	a1,s2
    80000fee:	8526                	mv	a0,s1
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	9e4080e7          	jalr	-1564(ra) # 800009d4 <uvmfree>
}
    80000ff8:	60e2                	ld	ra,24(sp)
    80000ffa:	6442                	ld	s0,16(sp)
    80000ffc:	64a2                	ld	s1,8(sp)
    80000ffe:	6902                	ld	s2,0(sp)
    80001000:	6105                	addi	sp,sp,32
    80001002:	8082                	ret

0000000080001004 <freeproc>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	1000                	addi	s0,sp,32
    8000100e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001010:	6d28                	ld	a0,88(a0)
    80001012:	c509                	beqz	a0,8000101c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	008080e7          	jalr	8(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000101c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001020:	68a8                	ld	a0,80(s1)
    80001022:	c511                	beqz	a0,8000102e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001024:	64ac                	ld	a1,72(s1)
    80001026:	00000097          	auipc	ra,0x0
    8000102a:	f8c080e7          	jalr	-116(ra) # 80000fb2 <proc_freepagetable>
  p->pagetable = 0;
    8000102e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001032:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001036:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000103a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000103e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001042:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001046:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000104a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000104e:	0004ac23          	sw	zero,24(s1)
}
    80001052:	60e2                	ld	ra,24(sp)
    80001054:	6442                	ld	s0,16(sp)
    80001056:	64a2                	ld	s1,8(sp)
    80001058:	6105                	addi	sp,sp,32
    8000105a:	8082                	ret

000000008000105c <allocproc>:
{
    8000105c:	1101                	addi	sp,sp,-32
    8000105e:	ec06                	sd	ra,24(sp)
    80001060:	e822                	sd	s0,16(sp)
    80001062:	e426                	sd	s1,8(sp)
    80001064:	e04a                	sd	s2,0(sp)
    80001066:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001068:	00008497          	auipc	s1,0x8
    8000106c:	cc848493          	addi	s1,s1,-824 # 80008d30 <proc>
    80001070:	0000d917          	auipc	s2,0xd
    80001074:	6c090913          	addi	s2,s2,1728 # 8000e730 <tickslock>
    acquire(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	fe4080e7          	jalr	-28(ra) # 8000605e <acquire>
    if(p->state == UNUSED) {
    80001082:	4c9c                	lw	a5,24(s1)
    80001084:	cf81                	beqz	a5,8000109c <allocproc+0x40>
      release(&p->lock);
    80001086:	8526                	mv	a0,s1
    80001088:	00005097          	auipc	ra,0x5
    8000108c:	08a080e7          	jalr	138(ra) # 80006112 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001090:	16848493          	addi	s1,s1,360
    80001094:	ff2492e3          	bne	s1,s2,80001078 <allocproc+0x1c>
  return 0;
    80001098:	4481                	li	s1,0
    8000109a:	a889                	j	800010ec <allocproc+0x90>
  p->pid = allocpid();
    8000109c:	00000097          	auipc	ra,0x0
    800010a0:	e34080e7          	jalr	-460(ra) # 80000ed0 <allocpid>
    800010a4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a6:	4785                	li	a5,1
    800010a8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	070080e7          	jalr	112(ra) # 8000011a <kalloc>
    800010b2:	892a                	mv	s2,a0
    800010b4:	eca8                	sd	a0,88(s1)
    800010b6:	c131                	beqz	a0,800010fa <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010b8:	8526                	mv	a0,s1
    800010ba:	00000097          	auipc	ra,0x0
    800010be:	e5c080e7          	jalr	-420(ra) # 80000f16 <proc_pagetable>
    800010c2:	892a                	mv	s2,a0
    800010c4:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c6:	c531                	beqz	a0,80001112 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010c8:	07000613          	li	a2,112
    800010cc:	4581                	li	a1,0
    800010ce:	06048513          	addi	a0,s1,96
    800010d2:	fffff097          	auipc	ra,0xfffff
    800010d6:	0a8080e7          	jalr	168(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010da:	00000797          	auipc	a5,0x0
    800010de:	db078793          	addi	a5,a5,-592 # 80000e8a <forkret>
    800010e2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e4:	60bc                	ld	a5,64(s1)
    800010e6:	6705                	lui	a4,0x1
    800010e8:	97ba                	add	a5,a5,a4
    800010ea:	f4bc                	sd	a5,104(s1)
}
    800010ec:	8526                	mv	a0,s1
    800010ee:	60e2                	ld	ra,24(sp)
    800010f0:	6442                	ld	s0,16(sp)
    800010f2:	64a2                	ld	s1,8(sp)
    800010f4:	6902                	ld	s2,0(sp)
    800010f6:	6105                	addi	sp,sp,32
    800010f8:	8082                	ret
    freeproc(p);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	f08080e7          	jalr	-248(ra) # 80001004 <freeproc>
    release(&p->lock);
    80001104:	8526                	mv	a0,s1
    80001106:	00005097          	auipc	ra,0x5
    8000110a:	00c080e7          	jalr	12(ra) # 80006112 <release>
    return 0;
    8000110e:	84ca                	mv	s1,s2
    80001110:	bff1                	j	800010ec <allocproc+0x90>
    freeproc(p);
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	ef0080e7          	jalr	-272(ra) # 80001004 <freeproc>
    release(&p->lock);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00005097          	auipc	ra,0x5
    80001122:	ff4080e7          	jalr	-12(ra) # 80006112 <release>
    return 0;
    80001126:	84ca                	mv	s1,s2
    80001128:	b7d1                	j	800010ec <allocproc+0x90>

000000008000112a <userinit>:
{
    8000112a:	1101                	addi	sp,sp,-32
    8000112c:	ec06                	sd	ra,24(sp)
    8000112e:	e822                	sd	s0,16(sp)
    80001130:	e426                	sd	s1,8(sp)
    80001132:	1000                	addi	s0,sp,32
  p = allocproc();
    80001134:	00000097          	auipc	ra,0x0
    80001138:	f28080e7          	jalr	-216(ra) # 8000105c <allocproc>
    8000113c:	84aa                	mv	s1,a0
  initproc = p;
    8000113e:	00007797          	auipc	a5,0x7
    80001142:	78a7b123          	sd	a0,1922(a5) # 800088c0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001146:	03400613          	li	a2,52
    8000114a:	00007597          	auipc	a1,0x7
    8000114e:	70658593          	addi	a1,a1,1798 # 80008850 <initcode>
    80001152:	6928                	ld	a0,80(a0)
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	6a8080e7          	jalr	1704(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    8000115c:	6785                	lui	a5,0x1
    8000115e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001160:	6cb8                	ld	a4,88(s1)
    80001162:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001166:	6cb8                	ld	a4,88(s1)
    80001168:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116a:	4641                	li	a2,16
    8000116c:	00007597          	auipc	a1,0x7
    80001170:	01458593          	addi	a1,a1,20 # 80008180 <etext+0x180>
    80001174:	15848513          	addi	a0,s1,344
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	14a080e7          	jalr	330(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001180:	00007517          	auipc	a0,0x7
    80001184:	01050513          	addi	a0,a0,16 # 80008190 <etext+0x190>
    80001188:	00002097          	auipc	ra,0x2
    8000118c:	0ec080e7          	jalr	236(ra) # 80003274 <namei>
    80001190:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001194:	478d                	li	a5,3
    80001196:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001198:	8526                	mv	a0,s1
    8000119a:	00005097          	auipc	ra,0x5
    8000119e:	f78080e7          	jalr	-136(ra) # 80006112 <release>
}
    800011a2:	60e2                	ld	ra,24(sp)
    800011a4:	6442                	ld	s0,16(sp)
    800011a6:	64a2                	ld	s1,8(sp)
    800011a8:	6105                	addi	sp,sp,32
    800011aa:	8082                	ret

00000000800011ac <growproc>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	e04a                	sd	s2,0(sp)
    800011b6:	1000                	addi	s0,sp,32
    800011b8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	c98080e7          	jalr	-872(ra) # 80000e52 <myproc>
    800011c2:	84aa                	mv	s1,a0
  sz = p->sz;
    800011c4:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011c6:	01204c63          	bgtz	s2,800011de <growproc+0x32>
  } else if(n < 0){
    800011ca:	02094663          	bltz	s2,800011f6 <growproc+0x4a>
  p->sz = sz;
    800011ce:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011de:	4691                	li	a3,4
    800011e0:	00b90633          	add	a2,s2,a1
    800011e4:	6928                	ld	a0,80(a0)
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	6d0080e7          	jalr	1744(ra) # 800008b6 <uvmalloc>
    800011ee:	85aa                	mv	a1,a0
    800011f0:	fd79                	bnez	a0,800011ce <growproc+0x22>
      return -1;
    800011f2:	557d                	li	a0,-1
    800011f4:	bff9                	j	800011d2 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f6:	00b90633          	add	a2,s2,a1
    800011fa:	6928                	ld	a0,80(a0)
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	672080e7          	jalr	1650(ra) # 8000086e <uvmdealloc>
    80001204:	85aa                	mv	a1,a0
    80001206:	b7e1                	j	800011ce <growproc+0x22>

0000000080001208 <fork>:
{
    80001208:	7139                	addi	sp,sp,-64
    8000120a:	fc06                	sd	ra,56(sp)
    8000120c:	f822                	sd	s0,48(sp)
    8000120e:	f426                	sd	s1,40(sp)
    80001210:	f04a                	sd	s2,32(sp)
    80001212:	ec4e                	sd	s3,24(sp)
    80001214:	e852                	sd	s4,16(sp)
    80001216:	e456                	sd	s5,8(sp)
    80001218:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	c38080e7          	jalr	-968(ra) # 80000e52 <myproc>
    80001222:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001224:	00000097          	auipc	ra,0x0
    80001228:	e38080e7          	jalr	-456(ra) # 8000105c <allocproc>
    8000122c:	10050c63          	beqz	a0,80001344 <fork+0x13c>
    80001230:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001232:	048ab603          	ld	a2,72(s5)
    80001236:	692c                	ld	a1,80(a0)
    80001238:	050ab503          	ld	a0,80(s5)
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	7d2080e7          	jalr	2002(ra) # 80000a0e <uvmcopy>
    80001244:	04054863          	bltz	a0,80001294 <fork+0x8c>
  np->sz = p->sz;
    80001248:	048ab783          	ld	a5,72(s5)
    8000124c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001250:	058ab683          	ld	a3,88(s5)
    80001254:	87b6                	mv	a5,a3
    80001256:	058a3703          	ld	a4,88(s4)
    8000125a:	12068693          	addi	a3,a3,288
    8000125e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001262:	6788                	ld	a0,8(a5)
    80001264:	6b8c                	ld	a1,16(a5)
    80001266:	6f90                	ld	a2,24(a5)
    80001268:	01073023          	sd	a6,0(a4)
    8000126c:	e708                	sd	a0,8(a4)
    8000126e:	eb0c                	sd	a1,16(a4)
    80001270:	ef10                	sd	a2,24(a4)
    80001272:	02078793          	addi	a5,a5,32
    80001276:	02070713          	addi	a4,a4,32
    8000127a:	fed792e3          	bne	a5,a3,8000125e <fork+0x56>
  np->trapframe->a0 = 0;
    8000127e:	058a3783          	ld	a5,88(s4)
    80001282:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001286:	0d0a8493          	addi	s1,s5,208
    8000128a:	0d0a0913          	addi	s2,s4,208
    8000128e:	150a8993          	addi	s3,s5,336
    80001292:	a00d                	j	800012b4 <fork+0xac>
    freeproc(np);
    80001294:	8552                	mv	a0,s4
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	d6e080e7          	jalr	-658(ra) # 80001004 <freeproc>
    release(&np->lock);
    8000129e:	8552                	mv	a0,s4
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	e72080e7          	jalr	-398(ra) # 80006112 <release>
    return -1;
    800012a8:	597d                	li	s2,-1
    800012aa:	a059                	j	80001330 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012ac:	04a1                	addi	s1,s1,8
    800012ae:	0921                	addi	s2,s2,8
    800012b0:	01348b63          	beq	s1,s3,800012c6 <fork+0xbe>
    if(p->ofile[i])
    800012b4:	6088                	ld	a0,0(s1)
    800012b6:	d97d                	beqz	a0,800012ac <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b8:	00002097          	auipc	ra,0x2
    800012bc:	62e080e7          	jalr	1582(ra) # 800038e6 <filedup>
    800012c0:	00a93023          	sd	a0,0(s2)
    800012c4:	b7e5                	j	800012ac <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012c6:	150ab503          	ld	a0,336(s5)
    800012ca:	00001097          	auipc	ra,0x1
    800012ce:	7c6080e7          	jalr	1990(ra) # 80002a90 <idup>
    800012d2:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012d6:	4641                	li	a2,16
    800012d8:	158a8593          	addi	a1,s5,344
    800012dc:	158a0513          	addi	a0,s4,344
    800012e0:	fffff097          	auipc	ra,0xfffff
    800012e4:	fe2080e7          	jalr	-30(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800012e8:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012ec:	8552                	mv	a0,s4
    800012ee:	00005097          	auipc	ra,0x5
    800012f2:	e24080e7          	jalr	-476(ra) # 80006112 <release>
  acquire(&wait_lock);
    800012f6:	00007497          	auipc	s1,0x7
    800012fa:	62248493          	addi	s1,s1,1570 # 80008918 <wait_lock>
    800012fe:	8526                	mv	a0,s1
    80001300:	00005097          	auipc	ra,0x5
    80001304:	d5e080e7          	jalr	-674(ra) # 8000605e <acquire>
  np->parent = p;
    80001308:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	e04080e7          	jalr	-508(ra) # 80006112 <release>
  acquire(&np->lock);
    80001316:	8552                	mv	a0,s4
    80001318:	00005097          	auipc	ra,0x5
    8000131c:	d46080e7          	jalr	-698(ra) # 8000605e <acquire>
  np->state = RUNNABLE;
    80001320:	478d                	li	a5,3
    80001322:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001326:	8552                	mv	a0,s4
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	dea080e7          	jalr	-534(ra) # 80006112 <release>
}
    80001330:	854a                	mv	a0,s2
    80001332:	70e2                	ld	ra,56(sp)
    80001334:	7442                	ld	s0,48(sp)
    80001336:	74a2                	ld	s1,40(sp)
    80001338:	7902                	ld	s2,32(sp)
    8000133a:	69e2                	ld	s3,24(sp)
    8000133c:	6a42                	ld	s4,16(sp)
    8000133e:	6aa2                	ld	s5,8(sp)
    80001340:	6121                	addi	sp,sp,64
    80001342:	8082                	ret
    return -1;
    80001344:	597d                	li	s2,-1
    80001346:	b7ed                	j	80001330 <fork+0x128>

0000000080001348 <scheduler>:
{
    80001348:	7139                	addi	sp,sp,-64
    8000134a:	fc06                	sd	ra,56(sp)
    8000134c:	f822                	sd	s0,48(sp)
    8000134e:	f426                	sd	s1,40(sp)
    80001350:	f04a                	sd	s2,32(sp)
    80001352:	ec4e                	sd	s3,24(sp)
    80001354:	e852                	sd	s4,16(sp)
    80001356:	e456                	sd	s5,8(sp)
    80001358:	e05a                	sd	s6,0(sp)
    8000135a:	0080                	addi	s0,sp,64
    8000135c:	8792                	mv	a5,tp
  int id = r_tp();
    8000135e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001360:	00779a93          	slli	s5,a5,0x7
    80001364:	00007717          	auipc	a4,0x7
    80001368:	59c70713          	addi	a4,a4,1436 # 80008900 <pid_lock>
    8000136c:	9756                	add	a4,a4,s5
    8000136e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001372:	00007717          	auipc	a4,0x7
    80001376:	5c670713          	addi	a4,a4,1478 # 80008938 <cpus+0x8>
    8000137a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000137c:	498d                	li	s3,3
        p->state = RUNNING;
    8000137e:	4b11                	li	s6,4
        c->proc = p;
    80001380:	079e                	slli	a5,a5,0x7
    80001382:	00007a17          	auipc	s4,0x7
    80001386:	57ea0a13          	addi	s4,s4,1406 # 80008900 <pid_lock>
    8000138a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000138c:	0000d917          	auipc	s2,0xd
    80001390:	3a490913          	addi	s2,s2,932 # 8000e730 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001394:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001398:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000139c:	10079073          	csrw	sstatus,a5
    800013a0:	00008497          	auipc	s1,0x8
    800013a4:	99048493          	addi	s1,s1,-1648 # 80008d30 <proc>
    800013a8:	a811                	j	800013bc <scheduler+0x74>
      release(&p->lock);
    800013aa:	8526                	mv	a0,s1
    800013ac:	00005097          	auipc	ra,0x5
    800013b0:	d66080e7          	jalr	-666(ra) # 80006112 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013b4:	16848493          	addi	s1,s1,360
    800013b8:	fd248ee3          	beq	s1,s2,80001394 <scheduler+0x4c>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	00005097          	auipc	ra,0x5
    800013c2:	ca0080e7          	jalr	-864(ra) # 8000605e <acquire>
      if(p->state == RUNNABLE) {
    800013c6:	4c9c                	lw	a5,24(s1)
    800013c8:	ff3791e3          	bne	a5,s3,800013aa <scheduler+0x62>
        p->state = RUNNING;
    800013cc:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013d0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013d4:	06048593          	addi	a1,s1,96
    800013d8:	8556                	mv	a0,s5
    800013da:	00000097          	auipc	ra,0x0
    800013de:	684080e7          	jalr	1668(ra) # 80001a5e <swtch>
        c->proc = 0;
    800013e2:	020a3823          	sd	zero,48(s4)
    800013e6:	b7d1                	j	800013aa <scheduler+0x62>

00000000800013e8 <sched>:
{
    800013e8:	7179                	addi	sp,sp,-48
    800013ea:	f406                	sd	ra,40(sp)
    800013ec:	f022                	sd	s0,32(sp)
    800013ee:	ec26                	sd	s1,24(sp)
    800013f0:	e84a                	sd	s2,16(sp)
    800013f2:	e44e                	sd	s3,8(sp)
    800013f4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f6:	00000097          	auipc	ra,0x0
    800013fa:	a5c080e7          	jalr	-1444(ra) # 80000e52 <myproc>
    800013fe:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001400:	00005097          	auipc	ra,0x5
    80001404:	be4080e7          	jalr	-1052(ra) # 80005fe4 <holding>
    80001408:	c93d                	beqz	a0,8000147e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000140a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000140c:	2781                	sext.w	a5,a5
    8000140e:	079e                	slli	a5,a5,0x7
    80001410:	00007717          	auipc	a4,0x7
    80001414:	4f070713          	addi	a4,a4,1264 # 80008900 <pid_lock>
    80001418:	97ba                	add	a5,a5,a4
    8000141a:	0a87a703          	lw	a4,168(a5)
    8000141e:	4785                	li	a5,1
    80001420:	06f71763          	bne	a4,a5,8000148e <sched+0xa6>
  if(p->state == RUNNING)
    80001424:	4c98                	lw	a4,24(s1)
    80001426:	4791                	li	a5,4
    80001428:	06f70b63          	beq	a4,a5,8000149e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001430:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001432:	efb5                	bnez	a5,800014ae <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001434:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001436:	00007917          	auipc	s2,0x7
    8000143a:	4ca90913          	addi	s2,s2,1226 # 80008900 <pid_lock>
    8000143e:	2781                	sext.w	a5,a5
    80001440:	079e                	slli	a5,a5,0x7
    80001442:	97ca                	add	a5,a5,s2
    80001444:	0ac7a983          	lw	s3,172(a5)
    80001448:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000144a:	2781                	sext.w	a5,a5
    8000144c:	079e                	slli	a5,a5,0x7
    8000144e:	00007597          	auipc	a1,0x7
    80001452:	4ea58593          	addi	a1,a1,1258 # 80008938 <cpus+0x8>
    80001456:	95be                	add	a1,a1,a5
    80001458:	06048513          	addi	a0,s1,96
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	602080e7          	jalr	1538(ra) # 80001a5e <swtch>
    80001464:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001466:	2781                	sext.w	a5,a5
    80001468:	079e                	slli	a5,a5,0x7
    8000146a:	993e                	add	s2,s2,a5
    8000146c:	0b392623          	sw	s3,172(s2)
}
    80001470:	70a2                	ld	ra,40(sp)
    80001472:	7402                	ld	s0,32(sp)
    80001474:	64e2                	ld	s1,24(sp)
    80001476:	6942                	ld	s2,16(sp)
    80001478:	69a2                	ld	s3,8(sp)
    8000147a:	6145                	addi	sp,sp,48
    8000147c:	8082                	ret
    panic("sched p->lock");
    8000147e:	00007517          	auipc	a0,0x7
    80001482:	d1a50513          	addi	a0,a0,-742 # 80008198 <etext+0x198>
    80001486:	00004097          	auipc	ra,0x4
    8000148a:	6a0080e7          	jalr	1696(ra) # 80005b26 <panic>
    panic("sched locks");
    8000148e:	00007517          	auipc	a0,0x7
    80001492:	d1a50513          	addi	a0,a0,-742 # 800081a8 <etext+0x1a8>
    80001496:	00004097          	auipc	ra,0x4
    8000149a:	690080e7          	jalr	1680(ra) # 80005b26 <panic>
    panic("sched running");
    8000149e:	00007517          	auipc	a0,0x7
    800014a2:	d1a50513          	addi	a0,a0,-742 # 800081b8 <etext+0x1b8>
    800014a6:	00004097          	auipc	ra,0x4
    800014aa:	680080e7          	jalr	1664(ra) # 80005b26 <panic>
    panic("sched interruptible");
    800014ae:	00007517          	auipc	a0,0x7
    800014b2:	d1a50513          	addi	a0,a0,-742 # 800081c8 <etext+0x1c8>
    800014b6:	00004097          	auipc	ra,0x4
    800014ba:	670080e7          	jalr	1648(ra) # 80005b26 <panic>

00000000800014be <yield>:
{
    800014be:	1101                	addi	sp,sp,-32
    800014c0:	ec06                	sd	ra,24(sp)
    800014c2:	e822                	sd	s0,16(sp)
    800014c4:	e426                	sd	s1,8(sp)
    800014c6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014c8:	00000097          	auipc	ra,0x0
    800014cc:	98a080e7          	jalr	-1654(ra) # 80000e52 <myproc>
    800014d0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014d2:	00005097          	auipc	ra,0x5
    800014d6:	b8c080e7          	jalr	-1140(ra) # 8000605e <acquire>
  p->state = RUNNABLE;
    800014da:	478d                	li	a5,3
    800014dc:	cc9c                	sw	a5,24(s1)
  sched();
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	f0a080e7          	jalr	-246(ra) # 800013e8 <sched>
  release(&p->lock);
    800014e6:	8526                	mv	a0,s1
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	c2a080e7          	jalr	-982(ra) # 80006112 <release>
}
    800014f0:	60e2                	ld	ra,24(sp)
    800014f2:	6442                	ld	s0,16(sp)
    800014f4:	64a2                	ld	s1,8(sp)
    800014f6:	6105                	addi	sp,sp,32
    800014f8:	8082                	ret

00000000800014fa <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014fa:	7179                	addi	sp,sp,-48
    800014fc:	f406                	sd	ra,40(sp)
    800014fe:	f022                	sd	s0,32(sp)
    80001500:	ec26                	sd	s1,24(sp)
    80001502:	e84a                	sd	s2,16(sp)
    80001504:	e44e                	sd	s3,8(sp)
    80001506:	1800                	addi	s0,sp,48
    80001508:	89aa                	mv	s3,a0
    8000150a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	946080e7          	jalr	-1722(ra) # 80000e52 <myproc>
    80001514:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	b48080e7          	jalr	-1208(ra) # 8000605e <acquire>
  release(lk);
    8000151e:	854a                	mv	a0,s2
    80001520:	00005097          	auipc	ra,0x5
    80001524:	bf2080e7          	jalr	-1038(ra) # 80006112 <release>

  // Go to sleep.
  p->chan = chan;
    80001528:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000152c:	4789                	li	a5,2
    8000152e:	cc9c                	sw	a5,24(s1)

  sched();
    80001530:	00000097          	auipc	ra,0x0
    80001534:	eb8080e7          	jalr	-328(ra) # 800013e8 <sched>

  // Tidy up.
  p->chan = 0;
    80001538:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000153c:	8526                	mv	a0,s1
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	bd4080e7          	jalr	-1068(ra) # 80006112 <release>
  acquire(lk);
    80001546:	854a                	mv	a0,s2
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	b16080e7          	jalr	-1258(ra) # 8000605e <acquire>
}
    80001550:	70a2                	ld	ra,40(sp)
    80001552:	7402                	ld	s0,32(sp)
    80001554:	64e2                	ld	s1,24(sp)
    80001556:	6942                	ld	s2,16(sp)
    80001558:	69a2                	ld	s3,8(sp)
    8000155a:	6145                	addi	sp,sp,48
    8000155c:	8082                	ret

000000008000155e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000155e:	7139                	addi	sp,sp,-64
    80001560:	fc06                	sd	ra,56(sp)
    80001562:	f822                	sd	s0,48(sp)
    80001564:	f426                	sd	s1,40(sp)
    80001566:	f04a                	sd	s2,32(sp)
    80001568:	ec4e                	sd	s3,24(sp)
    8000156a:	e852                	sd	s4,16(sp)
    8000156c:	e456                	sd	s5,8(sp)
    8000156e:	0080                	addi	s0,sp,64
    80001570:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001572:	00007497          	auipc	s1,0x7
    80001576:	7be48493          	addi	s1,s1,1982 # 80008d30 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000157a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000157c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000157e:	0000d917          	auipc	s2,0xd
    80001582:	1b290913          	addi	s2,s2,434 # 8000e730 <tickslock>
    80001586:	a811                	j	8000159a <wakeup+0x3c>
      }
      release(&p->lock);
    80001588:	8526                	mv	a0,s1
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	b88080e7          	jalr	-1144(ra) # 80006112 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001592:	16848493          	addi	s1,s1,360
    80001596:	03248663          	beq	s1,s2,800015c2 <wakeup+0x64>
    if(p != myproc()){
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	8b8080e7          	jalr	-1864(ra) # 80000e52 <myproc>
    800015a2:	fea488e3          	beq	s1,a0,80001592 <wakeup+0x34>
      acquire(&p->lock);
    800015a6:	8526                	mv	a0,s1
    800015a8:	00005097          	auipc	ra,0x5
    800015ac:	ab6080e7          	jalr	-1354(ra) # 8000605e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015b0:	4c9c                	lw	a5,24(s1)
    800015b2:	fd379be3          	bne	a5,s3,80001588 <wakeup+0x2a>
    800015b6:	709c                	ld	a5,32(s1)
    800015b8:	fd4798e3          	bne	a5,s4,80001588 <wakeup+0x2a>
        p->state = RUNNABLE;
    800015bc:	0154ac23          	sw	s5,24(s1)
    800015c0:	b7e1                	j	80001588 <wakeup+0x2a>
    }
  }
}
    800015c2:	70e2                	ld	ra,56(sp)
    800015c4:	7442                	ld	s0,48(sp)
    800015c6:	74a2                	ld	s1,40(sp)
    800015c8:	7902                	ld	s2,32(sp)
    800015ca:	69e2                	ld	s3,24(sp)
    800015cc:	6a42                	ld	s4,16(sp)
    800015ce:	6aa2                	ld	s5,8(sp)
    800015d0:	6121                	addi	sp,sp,64
    800015d2:	8082                	ret

00000000800015d4 <reparent>:
{
    800015d4:	7179                	addi	sp,sp,-48
    800015d6:	f406                	sd	ra,40(sp)
    800015d8:	f022                	sd	s0,32(sp)
    800015da:	ec26                	sd	s1,24(sp)
    800015dc:	e84a                	sd	s2,16(sp)
    800015de:	e44e                	sd	s3,8(sp)
    800015e0:	e052                	sd	s4,0(sp)
    800015e2:	1800                	addi	s0,sp,48
    800015e4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015e6:	00007497          	auipc	s1,0x7
    800015ea:	74a48493          	addi	s1,s1,1866 # 80008d30 <proc>
      pp->parent = initproc;
    800015ee:	00007a17          	auipc	s4,0x7
    800015f2:	2d2a0a13          	addi	s4,s4,722 # 800088c0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f6:	0000d997          	auipc	s3,0xd
    800015fa:	13a98993          	addi	s3,s3,314 # 8000e730 <tickslock>
    800015fe:	a029                	j	80001608 <reparent+0x34>
    80001600:	16848493          	addi	s1,s1,360
    80001604:	01348d63          	beq	s1,s3,8000161e <reparent+0x4a>
    if(pp->parent == p){
    80001608:	7c9c                	ld	a5,56(s1)
    8000160a:	ff279be3          	bne	a5,s2,80001600 <reparent+0x2c>
      pp->parent = initproc;
    8000160e:	000a3503          	ld	a0,0(s4)
    80001612:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001614:	00000097          	auipc	ra,0x0
    80001618:	f4a080e7          	jalr	-182(ra) # 8000155e <wakeup>
    8000161c:	b7d5                	j	80001600 <reparent+0x2c>
}
    8000161e:	70a2                	ld	ra,40(sp)
    80001620:	7402                	ld	s0,32(sp)
    80001622:	64e2                	ld	s1,24(sp)
    80001624:	6942                	ld	s2,16(sp)
    80001626:	69a2                	ld	s3,8(sp)
    80001628:	6a02                	ld	s4,0(sp)
    8000162a:	6145                	addi	sp,sp,48
    8000162c:	8082                	ret

000000008000162e <exit>:
{
    8000162e:	7179                	addi	sp,sp,-48
    80001630:	f406                	sd	ra,40(sp)
    80001632:	f022                	sd	s0,32(sp)
    80001634:	ec26                	sd	s1,24(sp)
    80001636:	e84a                	sd	s2,16(sp)
    80001638:	e44e                	sd	s3,8(sp)
    8000163a:	e052                	sd	s4,0(sp)
    8000163c:	1800                	addi	s0,sp,48
    8000163e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001640:	00000097          	auipc	ra,0x0
    80001644:	812080e7          	jalr	-2030(ra) # 80000e52 <myproc>
    80001648:	89aa                	mv	s3,a0
  if(p == initproc)
    8000164a:	00007797          	auipc	a5,0x7
    8000164e:	2767b783          	ld	a5,630(a5) # 800088c0 <initproc>
    80001652:	0d050493          	addi	s1,a0,208
    80001656:	15050913          	addi	s2,a0,336
    8000165a:	02a79363          	bne	a5,a0,80001680 <exit+0x52>
    panic("init exiting");
    8000165e:	00007517          	auipc	a0,0x7
    80001662:	b8250513          	addi	a0,a0,-1150 # 800081e0 <etext+0x1e0>
    80001666:	00004097          	auipc	ra,0x4
    8000166a:	4c0080e7          	jalr	1216(ra) # 80005b26 <panic>
      fileclose(f);
    8000166e:	00002097          	auipc	ra,0x2
    80001672:	2ca080e7          	jalr	714(ra) # 80003938 <fileclose>
      p->ofile[fd] = 0;
    80001676:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000167a:	04a1                	addi	s1,s1,8
    8000167c:	01248563          	beq	s1,s2,80001686 <exit+0x58>
    if(p->ofile[fd]){
    80001680:	6088                	ld	a0,0(s1)
    80001682:	f575                	bnez	a0,8000166e <exit+0x40>
    80001684:	bfdd                	j	8000167a <exit+0x4c>
  begin_op();
    80001686:	00002097          	auipc	ra,0x2
    8000168a:	dee080e7          	jalr	-530(ra) # 80003474 <begin_op>
  iput(p->cwd);
    8000168e:	1509b503          	ld	a0,336(s3)
    80001692:	00001097          	auipc	ra,0x1
    80001696:	5f6080e7          	jalr	1526(ra) # 80002c88 <iput>
  end_op();
    8000169a:	00002097          	auipc	ra,0x2
    8000169e:	e54080e7          	jalr	-428(ra) # 800034ee <end_op>
  p->cwd = 0;
    800016a2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a6:	00007497          	auipc	s1,0x7
    800016aa:	27248493          	addi	s1,s1,626 # 80008918 <wait_lock>
    800016ae:	8526                	mv	a0,s1
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	9ae080e7          	jalr	-1618(ra) # 8000605e <acquire>
  reparent(p);
    800016b8:	854e                	mv	a0,s3
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	f1a080e7          	jalr	-230(ra) # 800015d4 <reparent>
  wakeup(p->parent);
    800016c2:	0389b503          	ld	a0,56(s3)
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	e98080e7          	jalr	-360(ra) # 8000155e <wakeup>
  acquire(&p->lock);
    800016ce:	854e                	mv	a0,s3
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	98e080e7          	jalr	-1650(ra) # 8000605e <acquire>
  p->xstate = status;
    800016d8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016dc:	4795                	li	a5,5
    800016de:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016e2:	8526                	mv	a0,s1
    800016e4:	00005097          	auipc	ra,0x5
    800016e8:	a2e080e7          	jalr	-1490(ra) # 80006112 <release>
  sched();
    800016ec:	00000097          	auipc	ra,0x0
    800016f0:	cfc080e7          	jalr	-772(ra) # 800013e8 <sched>
  panic("zombie exit");
    800016f4:	00007517          	auipc	a0,0x7
    800016f8:	afc50513          	addi	a0,a0,-1284 # 800081f0 <etext+0x1f0>
    800016fc:	00004097          	auipc	ra,0x4
    80001700:	42a080e7          	jalr	1066(ra) # 80005b26 <panic>

0000000080001704 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001704:	7179                	addi	sp,sp,-48
    80001706:	f406                	sd	ra,40(sp)
    80001708:	f022                	sd	s0,32(sp)
    8000170a:	ec26                	sd	s1,24(sp)
    8000170c:	e84a                	sd	s2,16(sp)
    8000170e:	e44e                	sd	s3,8(sp)
    80001710:	1800                	addi	s0,sp,48
    80001712:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001714:	00007497          	auipc	s1,0x7
    80001718:	61c48493          	addi	s1,s1,1564 # 80008d30 <proc>
    8000171c:	0000d997          	auipc	s3,0xd
    80001720:	01498993          	addi	s3,s3,20 # 8000e730 <tickslock>
    acquire(&p->lock);
    80001724:	8526                	mv	a0,s1
    80001726:	00005097          	auipc	ra,0x5
    8000172a:	938080e7          	jalr	-1736(ra) # 8000605e <acquire>
    if(p->pid == pid){
    8000172e:	589c                	lw	a5,48(s1)
    80001730:	01278d63          	beq	a5,s2,8000174a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001734:	8526                	mv	a0,s1
    80001736:	00005097          	auipc	ra,0x5
    8000173a:	9dc080e7          	jalr	-1572(ra) # 80006112 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000173e:	16848493          	addi	s1,s1,360
    80001742:	ff3491e3          	bne	s1,s3,80001724 <kill+0x20>
  }
  return -1;
    80001746:	557d                	li	a0,-1
    80001748:	a829                	j	80001762 <kill+0x5e>
      p->killed = 1;
    8000174a:	4785                	li	a5,1
    8000174c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000174e:	4c98                	lw	a4,24(s1)
    80001750:	4789                	li	a5,2
    80001752:	00f70f63          	beq	a4,a5,80001770 <kill+0x6c>
      release(&p->lock);
    80001756:	8526                	mv	a0,s1
    80001758:	00005097          	auipc	ra,0x5
    8000175c:	9ba080e7          	jalr	-1606(ra) # 80006112 <release>
      return 0;
    80001760:	4501                	li	a0,0
}
    80001762:	70a2                	ld	ra,40(sp)
    80001764:	7402                	ld	s0,32(sp)
    80001766:	64e2                	ld	s1,24(sp)
    80001768:	6942                	ld	s2,16(sp)
    8000176a:	69a2                	ld	s3,8(sp)
    8000176c:	6145                	addi	sp,sp,48
    8000176e:	8082                	ret
        p->state = RUNNABLE;
    80001770:	478d                	li	a5,3
    80001772:	cc9c                	sw	a5,24(s1)
    80001774:	b7cd                	j	80001756 <kill+0x52>

0000000080001776 <setkilled>:

void
setkilled(struct proc *p)
{
    80001776:	1101                	addi	sp,sp,-32
    80001778:	ec06                	sd	ra,24(sp)
    8000177a:	e822                	sd	s0,16(sp)
    8000177c:	e426                	sd	s1,8(sp)
    8000177e:	1000                	addi	s0,sp,32
    80001780:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001782:	00005097          	auipc	ra,0x5
    80001786:	8dc080e7          	jalr	-1828(ra) # 8000605e <acquire>
  p->killed = 1;
    8000178a:	4785                	li	a5,1
    8000178c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000178e:	8526                	mv	a0,s1
    80001790:	00005097          	auipc	ra,0x5
    80001794:	982080e7          	jalr	-1662(ra) # 80006112 <release>
}
    80001798:	60e2                	ld	ra,24(sp)
    8000179a:	6442                	ld	s0,16(sp)
    8000179c:	64a2                	ld	s1,8(sp)
    8000179e:	6105                	addi	sp,sp,32
    800017a0:	8082                	ret

00000000800017a2 <killed>:

int
killed(struct proc *p)
{
    800017a2:	1101                	addi	sp,sp,-32
    800017a4:	ec06                	sd	ra,24(sp)
    800017a6:	e822                	sd	s0,16(sp)
    800017a8:	e426                	sd	s1,8(sp)
    800017aa:	e04a                	sd	s2,0(sp)
    800017ac:	1000                	addi	s0,sp,32
    800017ae:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	8ae080e7          	jalr	-1874(ra) # 8000605e <acquire>
  k = p->killed;
    800017b8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017bc:	8526                	mv	a0,s1
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	954080e7          	jalr	-1708(ra) # 80006112 <release>
  return k;
}
    800017c6:	854a                	mv	a0,s2
    800017c8:	60e2                	ld	ra,24(sp)
    800017ca:	6442                	ld	s0,16(sp)
    800017cc:	64a2                	ld	s1,8(sp)
    800017ce:	6902                	ld	s2,0(sp)
    800017d0:	6105                	addi	sp,sp,32
    800017d2:	8082                	ret

00000000800017d4 <wait>:
{
    800017d4:	715d                	addi	sp,sp,-80
    800017d6:	e486                	sd	ra,72(sp)
    800017d8:	e0a2                	sd	s0,64(sp)
    800017da:	fc26                	sd	s1,56(sp)
    800017dc:	f84a                	sd	s2,48(sp)
    800017de:	f44e                	sd	s3,40(sp)
    800017e0:	f052                	sd	s4,32(sp)
    800017e2:	ec56                	sd	s5,24(sp)
    800017e4:	e85a                	sd	s6,16(sp)
    800017e6:	e45e                	sd	s7,8(sp)
    800017e8:	e062                	sd	s8,0(sp)
    800017ea:	0880                	addi	s0,sp,80
    800017ec:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017ee:	fffff097          	auipc	ra,0xfffff
    800017f2:	664080e7          	jalr	1636(ra) # 80000e52 <myproc>
    800017f6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017f8:	00007517          	auipc	a0,0x7
    800017fc:	12050513          	addi	a0,a0,288 # 80008918 <wait_lock>
    80001800:	00005097          	auipc	ra,0x5
    80001804:	85e080e7          	jalr	-1954(ra) # 8000605e <acquire>
    havekids = 0;
    80001808:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000180a:	4a15                	li	s4,5
        havekids = 1;
    8000180c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000180e:	0000d997          	auipc	s3,0xd
    80001812:	f2298993          	addi	s3,s3,-222 # 8000e730 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001816:	00007c17          	auipc	s8,0x7
    8000181a:	102c0c13          	addi	s8,s8,258 # 80008918 <wait_lock>
    8000181e:	a0d1                	j	800018e2 <wait+0x10e>
          pid = pp->pid;
    80001820:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001824:	000b0e63          	beqz	s6,80001840 <wait+0x6c>
    80001828:	4691                	li	a3,4
    8000182a:	02c48613          	addi	a2,s1,44
    8000182e:	85da                	mv	a1,s6
    80001830:	05093503          	ld	a0,80(s2)
    80001834:	fffff097          	auipc	ra,0xfffff
    80001838:	2de080e7          	jalr	734(ra) # 80000b12 <copyout>
    8000183c:	04054163          	bltz	a0,8000187e <wait+0xaa>
          freeproc(pp);
    80001840:	8526                	mv	a0,s1
    80001842:	fffff097          	auipc	ra,0xfffff
    80001846:	7c2080e7          	jalr	1986(ra) # 80001004 <freeproc>
          release(&pp->lock);
    8000184a:	8526                	mv	a0,s1
    8000184c:	00005097          	auipc	ra,0x5
    80001850:	8c6080e7          	jalr	-1850(ra) # 80006112 <release>
          release(&wait_lock);
    80001854:	00007517          	auipc	a0,0x7
    80001858:	0c450513          	addi	a0,a0,196 # 80008918 <wait_lock>
    8000185c:	00005097          	auipc	ra,0x5
    80001860:	8b6080e7          	jalr	-1866(ra) # 80006112 <release>
}
    80001864:	854e                	mv	a0,s3
    80001866:	60a6                	ld	ra,72(sp)
    80001868:	6406                	ld	s0,64(sp)
    8000186a:	74e2                	ld	s1,56(sp)
    8000186c:	7942                	ld	s2,48(sp)
    8000186e:	79a2                	ld	s3,40(sp)
    80001870:	7a02                	ld	s4,32(sp)
    80001872:	6ae2                	ld	s5,24(sp)
    80001874:	6b42                	ld	s6,16(sp)
    80001876:	6ba2                	ld	s7,8(sp)
    80001878:	6c02                	ld	s8,0(sp)
    8000187a:	6161                	addi	sp,sp,80
    8000187c:	8082                	ret
            release(&pp->lock);
    8000187e:	8526                	mv	a0,s1
    80001880:	00005097          	auipc	ra,0x5
    80001884:	892080e7          	jalr	-1902(ra) # 80006112 <release>
            release(&wait_lock);
    80001888:	00007517          	auipc	a0,0x7
    8000188c:	09050513          	addi	a0,a0,144 # 80008918 <wait_lock>
    80001890:	00005097          	auipc	ra,0x5
    80001894:	882080e7          	jalr	-1918(ra) # 80006112 <release>
            return -1;
    80001898:	59fd                	li	s3,-1
    8000189a:	b7e9                	j	80001864 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000189c:	16848493          	addi	s1,s1,360
    800018a0:	03348463          	beq	s1,s3,800018c8 <wait+0xf4>
      if(pp->parent == p){
    800018a4:	7c9c                	ld	a5,56(s1)
    800018a6:	ff279be3          	bne	a5,s2,8000189c <wait+0xc8>
        acquire(&pp->lock);
    800018aa:	8526                	mv	a0,s1
    800018ac:	00004097          	auipc	ra,0x4
    800018b0:	7b2080e7          	jalr	1970(ra) # 8000605e <acquire>
        if(pp->state == ZOMBIE){
    800018b4:	4c9c                	lw	a5,24(s1)
    800018b6:	f74785e3          	beq	a5,s4,80001820 <wait+0x4c>
        release(&pp->lock);
    800018ba:	8526                	mv	a0,s1
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	856080e7          	jalr	-1962(ra) # 80006112 <release>
        havekids = 1;
    800018c4:	8756                	mv	a4,s5
    800018c6:	bfd9                	j	8000189c <wait+0xc8>
    if(!havekids || killed(p)){
    800018c8:	c31d                	beqz	a4,800018ee <wait+0x11a>
    800018ca:	854a                	mv	a0,s2
    800018cc:	00000097          	auipc	ra,0x0
    800018d0:	ed6080e7          	jalr	-298(ra) # 800017a2 <killed>
    800018d4:	ed09                	bnez	a0,800018ee <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018d6:	85e2                	mv	a1,s8
    800018d8:	854a                	mv	a0,s2
    800018da:	00000097          	auipc	ra,0x0
    800018de:	c20080e7          	jalr	-992(ra) # 800014fa <sleep>
    havekids = 0;
    800018e2:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018e4:	00007497          	auipc	s1,0x7
    800018e8:	44c48493          	addi	s1,s1,1100 # 80008d30 <proc>
    800018ec:	bf65                	j	800018a4 <wait+0xd0>
      release(&wait_lock);
    800018ee:	00007517          	auipc	a0,0x7
    800018f2:	02a50513          	addi	a0,a0,42 # 80008918 <wait_lock>
    800018f6:	00005097          	auipc	ra,0x5
    800018fa:	81c080e7          	jalr	-2020(ra) # 80006112 <release>
      return -1;
    800018fe:	59fd                	li	s3,-1
    80001900:	b795                	j	80001864 <wait+0x90>

0000000080001902 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001902:	7179                	addi	sp,sp,-48
    80001904:	f406                	sd	ra,40(sp)
    80001906:	f022                	sd	s0,32(sp)
    80001908:	ec26                	sd	s1,24(sp)
    8000190a:	e84a                	sd	s2,16(sp)
    8000190c:	e44e                	sd	s3,8(sp)
    8000190e:	e052                	sd	s4,0(sp)
    80001910:	1800                	addi	s0,sp,48
    80001912:	84aa                	mv	s1,a0
    80001914:	892e                	mv	s2,a1
    80001916:	89b2                	mv	s3,a2
    80001918:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	538080e7          	jalr	1336(ra) # 80000e52 <myproc>
  if(user_dst){
    80001922:	c08d                	beqz	s1,80001944 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001924:	86d2                	mv	a3,s4
    80001926:	864e                	mv	a2,s3
    80001928:	85ca                	mv	a1,s2
    8000192a:	6928                	ld	a0,80(a0)
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	1e6080e7          	jalr	486(ra) # 80000b12 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001934:	70a2                	ld	ra,40(sp)
    80001936:	7402                	ld	s0,32(sp)
    80001938:	64e2                	ld	s1,24(sp)
    8000193a:	6942                	ld	s2,16(sp)
    8000193c:	69a2                	ld	s3,8(sp)
    8000193e:	6a02                	ld	s4,0(sp)
    80001940:	6145                	addi	sp,sp,48
    80001942:	8082                	ret
    memmove((char *)dst, src, len);
    80001944:	000a061b          	sext.w	a2,s4
    80001948:	85ce                	mv	a1,s3
    8000194a:	854a                	mv	a0,s2
    8000194c:	fffff097          	auipc	ra,0xfffff
    80001950:	88a080e7          	jalr	-1910(ra) # 800001d6 <memmove>
    return 0;
    80001954:	8526                	mv	a0,s1
    80001956:	bff9                	j	80001934 <either_copyout+0x32>

0000000080001958 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001958:	7179                	addi	sp,sp,-48
    8000195a:	f406                	sd	ra,40(sp)
    8000195c:	f022                	sd	s0,32(sp)
    8000195e:	ec26                	sd	s1,24(sp)
    80001960:	e84a                	sd	s2,16(sp)
    80001962:	e44e                	sd	s3,8(sp)
    80001964:	e052                	sd	s4,0(sp)
    80001966:	1800                	addi	s0,sp,48
    80001968:	892a                	mv	s2,a0
    8000196a:	84ae                	mv	s1,a1
    8000196c:	89b2                	mv	s3,a2
    8000196e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	4e2080e7          	jalr	1250(ra) # 80000e52 <myproc>
  if(user_src){
    80001978:	c08d                	beqz	s1,8000199a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000197a:	86d2                	mv	a3,s4
    8000197c:	864e                	mv	a2,s3
    8000197e:	85ca                	mv	a1,s2
    80001980:	6928                	ld	a0,80(a0)
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	21c080e7          	jalr	540(ra) # 80000b9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000198a:	70a2                	ld	ra,40(sp)
    8000198c:	7402                	ld	s0,32(sp)
    8000198e:	64e2                	ld	s1,24(sp)
    80001990:	6942                	ld	s2,16(sp)
    80001992:	69a2                	ld	s3,8(sp)
    80001994:	6a02                	ld	s4,0(sp)
    80001996:	6145                	addi	sp,sp,48
    80001998:	8082                	ret
    memmove(dst, (char*)src, len);
    8000199a:	000a061b          	sext.w	a2,s4
    8000199e:	85ce                	mv	a1,s3
    800019a0:	854a                	mv	a0,s2
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	834080e7          	jalr	-1996(ra) # 800001d6 <memmove>
    return 0;
    800019aa:	8526                	mv	a0,s1
    800019ac:	bff9                	j	8000198a <either_copyin+0x32>

00000000800019ae <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ae:	715d                	addi	sp,sp,-80
    800019b0:	e486                	sd	ra,72(sp)
    800019b2:	e0a2                	sd	s0,64(sp)
    800019b4:	fc26                	sd	s1,56(sp)
    800019b6:	f84a                	sd	s2,48(sp)
    800019b8:	f44e                	sd	s3,40(sp)
    800019ba:	f052                	sd	s4,32(sp)
    800019bc:	ec56                	sd	s5,24(sp)
    800019be:	e85a                	sd	s6,16(sp)
    800019c0:	e45e                	sd	s7,8(sp)
    800019c2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c4:	00006517          	auipc	a0,0x6
    800019c8:	68450513          	addi	a0,a0,1668 # 80008048 <etext+0x48>
    800019cc:	00004097          	auipc	ra,0x4
    800019d0:	1a4080e7          	jalr	420(ra) # 80005b70 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d4:	00007497          	auipc	s1,0x7
    800019d8:	4b448493          	addi	s1,s1,1204 # 80008e88 <proc+0x158>
    800019dc:	0000d917          	auipc	s2,0xd
    800019e0:	eac90913          	addi	s2,s2,-340 # 8000e888 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e6:	00007997          	auipc	s3,0x7
    800019ea:	81a98993          	addi	s3,s3,-2022 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019ee:	00007a97          	auipc	s5,0x7
    800019f2:	81aa8a93          	addi	s5,s5,-2022 # 80008208 <etext+0x208>
    printf("\n");
    800019f6:	00006a17          	auipc	s4,0x6
    800019fa:	652a0a13          	addi	s4,s4,1618 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fe:	00007b97          	auipc	s7,0x7
    80001a02:	84ab8b93          	addi	s7,s7,-1974 # 80008248 <states.0>
    80001a06:	a00d                	j	80001a28 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a08:	ed86a583          	lw	a1,-296(a3)
    80001a0c:	8556                	mv	a0,s5
    80001a0e:	00004097          	auipc	ra,0x4
    80001a12:	162080e7          	jalr	354(ra) # 80005b70 <printf>
    printf("\n");
    80001a16:	8552                	mv	a0,s4
    80001a18:	00004097          	auipc	ra,0x4
    80001a1c:	158080e7          	jalr	344(ra) # 80005b70 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a20:	16848493          	addi	s1,s1,360
    80001a24:	03248263          	beq	s1,s2,80001a48 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a28:	86a6                	mv	a3,s1
    80001a2a:	ec04a783          	lw	a5,-320(s1)
    80001a2e:	dbed                	beqz	a5,80001a20 <procdump+0x72>
      state = "???";
    80001a30:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a32:	fcfb6be3          	bltu	s6,a5,80001a08 <procdump+0x5a>
    80001a36:	02079713          	slli	a4,a5,0x20
    80001a3a:	01d75793          	srli	a5,a4,0x1d
    80001a3e:	97de                	add	a5,a5,s7
    80001a40:	6390                	ld	a2,0(a5)
    80001a42:	f279                	bnez	a2,80001a08 <procdump+0x5a>
      state = "???";
    80001a44:	864e                	mv	a2,s3
    80001a46:	b7c9                	j	80001a08 <procdump+0x5a>
  }
}
    80001a48:	60a6                	ld	ra,72(sp)
    80001a4a:	6406                	ld	s0,64(sp)
    80001a4c:	74e2                	ld	s1,56(sp)
    80001a4e:	7942                	ld	s2,48(sp)
    80001a50:	79a2                	ld	s3,40(sp)
    80001a52:	7a02                	ld	s4,32(sp)
    80001a54:	6ae2                	ld	s5,24(sp)
    80001a56:	6b42                	ld	s6,16(sp)
    80001a58:	6ba2                	ld	s7,8(sp)
    80001a5a:	6161                	addi	sp,sp,80
    80001a5c:	8082                	ret

0000000080001a5e <swtch>:
    80001a5e:	00153023          	sd	ra,0(a0)
    80001a62:	00253423          	sd	sp,8(a0)
    80001a66:	e900                	sd	s0,16(a0)
    80001a68:	ed04                	sd	s1,24(a0)
    80001a6a:	03253023          	sd	s2,32(a0)
    80001a6e:	03353423          	sd	s3,40(a0)
    80001a72:	03453823          	sd	s4,48(a0)
    80001a76:	03553c23          	sd	s5,56(a0)
    80001a7a:	05653023          	sd	s6,64(a0)
    80001a7e:	05753423          	sd	s7,72(a0)
    80001a82:	05853823          	sd	s8,80(a0)
    80001a86:	05953c23          	sd	s9,88(a0)
    80001a8a:	07a53023          	sd	s10,96(a0)
    80001a8e:	07b53423          	sd	s11,104(a0)
    80001a92:	0005b083          	ld	ra,0(a1)
    80001a96:	0085b103          	ld	sp,8(a1)
    80001a9a:	6980                	ld	s0,16(a1)
    80001a9c:	6d84                	ld	s1,24(a1)
    80001a9e:	0205b903          	ld	s2,32(a1)
    80001aa2:	0285b983          	ld	s3,40(a1)
    80001aa6:	0305ba03          	ld	s4,48(a1)
    80001aaa:	0385ba83          	ld	s5,56(a1)
    80001aae:	0405bb03          	ld	s6,64(a1)
    80001ab2:	0485bb83          	ld	s7,72(a1)
    80001ab6:	0505bc03          	ld	s8,80(a1)
    80001aba:	0585bc83          	ld	s9,88(a1)
    80001abe:	0605bd03          	ld	s10,96(a1)
    80001ac2:	0685bd83          	ld	s11,104(a1)
    80001ac6:	8082                	ret

0000000080001ac8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ac8:	1141                	addi	sp,sp,-16
    80001aca:	e406                	sd	ra,8(sp)
    80001acc:	e022                	sd	s0,0(sp)
    80001ace:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ad0:	00006597          	auipc	a1,0x6
    80001ad4:	7a858593          	addi	a1,a1,1960 # 80008278 <states.0+0x30>
    80001ad8:	0000d517          	auipc	a0,0xd
    80001adc:	c5850513          	addi	a0,a0,-936 # 8000e730 <tickslock>
    80001ae0:	00004097          	auipc	ra,0x4
    80001ae4:	4ee080e7          	jalr	1262(ra) # 80005fce <initlock>
}
    80001ae8:	60a2                	ld	ra,8(sp)
    80001aea:	6402                	ld	s0,0(sp)
    80001aec:	0141                	addi	sp,sp,16
    80001aee:	8082                	ret

0000000080001af0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001af0:	1141                	addi	sp,sp,-16
    80001af2:	e422                	sd	s0,8(sp)
    80001af4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af6:	00003797          	auipc	a5,0x3
    80001afa:	46a78793          	addi	a5,a5,1130 # 80004f60 <kernelvec>
    80001afe:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b02:	6422                	ld	s0,8(sp)
    80001b04:	0141                	addi	sp,sp,16
    80001b06:	8082                	ret

0000000080001b08 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b08:	1141                	addi	sp,sp,-16
    80001b0a:	e406                	sd	ra,8(sp)
    80001b0c:	e022                	sd	s0,0(sp)
    80001b0e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b10:	fffff097          	auipc	ra,0xfffff
    80001b14:	342080e7          	jalr	834(ra) # 80000e52 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b18:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b1c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b1e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b22:	00005697          	auipc	a3,0x5
    80001b26:	4de68693          	addi	a3,a3,1246 # 80007000 <_trampoline>
    80001b2a:	00005717          	auipc	a4,0x5
    80001b2e:	4d670713          	addi	a4,a4,1238 # 80007000 <_trampoline>
    80001b32:	8f15                	sub	a4,a4,a3
    80001b34:	040007b7          	lui	a5,0x4000
    80001b38:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b3a:	07b2                	slli	a5,a5,0xc
    80001b3c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b3e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b42:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b44:	18002673          	csrr	a2,satp
    80001b48:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b4a:	6d30                	ld	a2,88(a0)
    80001b4c:	6138                	ld	a4,64(a0)
    80001b4e:	6585                	lui	a1,0x1
    80001b50:	972e                	add	a4,a4,a1
    80001b52:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b54:	6d38                	ld	a4,88(a0)
    80001b56:	00000617          	auipc	a2,0x0
    80001b5a:	13460613          	addi	a2,a2,308 # 80001c8a <usertrap>
    80001b5e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b60:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b62:	8612                	mv	a2,tp
    80001b64:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b66:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b6a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b6e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b72:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b76:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b78:	6f18                	ld	a4,24(a4)
    80001b7a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b7e:	6928                	ld	a0,80(a0)
    80001b80:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b82:	00005717          	auipc	a4,0x5
    80001b86:	51a70713          	addi	a4,a4,1306 # 8000709c <userret>
    80001b8a:	8f15                	sub	a4,a4,a3
    80001b8c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b8e:	577d                	li	a4,-1
    80001b90:	177e                	slli	a4,a4,0x3f
    80001b92:	8d59                	or	a0,a0,a4
    80001b94:	9782                	jalr	a5
}
    80001b96:	60a2                	ld	ra,8(sp)
    80001b98:	6402                	ld	s0,0(sp)
    80001b9a:	0141                	addi	sp,sp,16
    80001b9c:	8082                	ret

0000000080001b9e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b9e:	1101                	addi	sp,sp,-32
    80001ba0:	ec06                	sd	ra,24(sp)
    80001ba2:	e822                	sd	s0,16(sp)
    80001ba4:	e426                	sd	s1,8(sp)
    80001ba6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ba8:	0000d497          	auipc	s1,0xd
    80001bac:	b8848493          	addi	s1,s1,-1144 # 8000e730 <tickslock>
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	00004097          	auipc	ra,0x4
    80001bb6:	4ac080e7          	jalr	1196(ra) # 8000605e <acquire>
  ticks++;
    80001bba:	00007517          	auipc	a0,0x7
    80001bbe:	d0e50513          	addi	a0,a0,-754 # 800088c8 <ticks>
    80001bc2:	411c                	lw	a5,0(a0)
    80001bc4:	2785                	addiw	a5,a5,1
    80001bc6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bc8:	00000097          	auipc	ra,0x0
    80001bcc:	996080e7          	jalr	-1642(ra) # 8000155e <wakeup>
  release(&tickslock);
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	00004097          	auipc	ra,0x4
    80001bd6:	540080e7          	jalr	1344(ra) # 80006112 <release>
}
    80001bda:	60e2                	ld	ra,24(sp)
    80001bdc:	6442                	ld	s0,16(sp)
    80001bde:	64a2                	ld	s1,8(sp)
    80001be0:	6105                	addi	sp,sp,32
    80001be2:	8082                	ret

0000000080001be4 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001be4:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001be8:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001bea:	0807df63          	bgez	a5,80001c88 <devintr+0xa4>
{
    80001bee:	1101                	addi	sp,sp,-32
    80001bf0:	ec06                	sd	ra,24(sp)
    80001bf2:	e822                	sd	s0,16(sp)
    80001bf4:	e426                	sd	s1,8(sp)
    80001bf6:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001bf8:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001bfc:	46a5                	li	a3,9
    80001bfe:	00d70d63          	beq	a4,a3,80001c18 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001c02:	577d                	li	a4,-1
    80001c04:	177e                	slli	a4,a4,0x3f
    80001c06:	0705                	addi	a4,a4,1
    return 0;
    80001c08:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c0a:	04e78e63          	beq	a5,a4,80001c66 <devintr+0x82>
  }
}
    80001c0e:	60e2                	ld	ra,24(sp)
    80001c10:	6442                	ld	s0,16(sp)
    80001c12:	64a2                	ld	s1,8(sp)
    80001c14:	6105                	addi	sp,sp,32
    80001c16:	8082                	ret
    int irq = plic_claim();
    80001c18:	00003097          	auipc	ra,0x3
    80001c1c:	450080e7          	jalr	1104(ra) # 80005068 <plic_claim>
    80001c20:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c22:	47a9                	li	a5,10
    80001c24:	02f50763          	beq	a0,a5,80001c52 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001c28:	4785                	li	a5,1
    80001c2a:	02f50963          	beq	a0,a5,80001c5c <devintr+0x78>
    return 1;
    80001c2e:	4505                	li	a0,1
    } else if(irq){
    80001c30:	dcf9                	beqz	s1,80001c0e <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c32:	85a6                	mv	a1,s1
    80001c34:	00006517          	auipc	a0,0x6
    80001c38:	64c50513          	addi	a0,a0,1612 # 80008280 <states.0+0x38>
    80001c3c:	00004097          	auipc	ra,0x4
    80001c40:	f34080e7          	jalr	-204(ra) # 80005b70 <printf>
      plic_complete(irq);
    80001c44:	8526                	mv	a0,s1
    80001c46:	00003097          	auipc	ra,0x3
    80001c4a:	446080e7          	jalr	1094(ra) # 8000508c <plic_complete>
    return 1;
    80001c4e:	4505                	li	a0,1
    80001c50:	bf7d                	j	80001c0e <devintr+0x2a>
      uartintr();
    80001c52:	00004097          	auipc	ra,0x4
    80001c56:	32c080e7          	jalr	812(ra) # 80005f7e <uartintr>
    if(irq)
    80001c5a:	b7ed                	j	80001c44 <devintr+0x60>
      virtio_disk_intr();
    80001c5c:	00004097          	auipc	ra,0x4
    80001c60:	8f6080e7          	jalr	-1802(ra) # 80005552 <virtio_disk_intr>
    if(irq)
    80001c64:	b7c5                	j	80001c44 <devintr+0x60>
    if(cpuid() == 0){
    80001c66:	fffff097          	auipc	ra,0xfffff
    80001c6a:	1c0080e7          	jalr	448(ra) # 80000e26 <cpuid>
    80001c6e:	c901                	beqz	a0,80001c7e <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c70:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c74:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c76:	14479073          	csrw	sip,a5
    return 2;
    80001c7a:	4509                	li	a0,2
    80001c7c:	bf49                	j	80001c0e <devintr+0x2a>
      clockintr();
    80001c7e:	00000097          	auipc	ra,0x0
    80001c82:	f20080e7          	jalr	-224(ra) # 80001b9e <clockintr>
    80001c86:	b7ed                	j	80001c70 <devintr+0x8c>
}
    80001c88:	8082                	ret

0000000080001c8a <usertrap>:
{
    80001c8a:	1101                	addi	sp,sp,-32
    80001c8c:	ec06                	sd	ra,24(sp)
    80001c8e:	e822                	sd	s0,16(sp)
    80001c90:	e426                	sd	s1,8(sp)
    80001c92:	e04a                	sd	s2,0(sp)
    80001c94:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c96:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c9a:	1007f793          	andi	a5,a5,256
    80001c9e:	e3b1                	bnez	a5,80001ce2 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca0:	00003797          	auipc	a5,0x3
    80001ca4:	2c078793          	addi	a5,a5,704 # 80004f60 <kernelvec>
    80001ca8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cac:	fffff097          	auipc	ra,0xfffff
    80001cb0:	1a6080e7          	jalr	422(ra) # 80000e52 <myproc>
    80001cb4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cb6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cb8:	14102773          	csrr	a4,sepc
    80001cbc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cbe:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cc2:	47a1                	li	a5,8
    80001cc4:	02f70763          	beq	a4,a5,80001cf2 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001cc8:	00000097          	auipc	ra,0x0
    80001ccc:	f1c080e7          	jalr	-228(ra) # 80001be4 <devintr>
    80001cd0:	892a                	mv	s2,a0
    80001cd2:	c151                	beqz	a0,80001d56 <usertrap+0xcc>
  if(killed(p))
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	acc080e7          	jalr	-1332(ra) # 800017a2 <killed>
    80001cde:	c929                	beqz	a0,80001d30 <usertrap+0xa6>
    80001ce0:	a099                	j	80001d26 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001ce2:	00006517          	auipc	a0,0x6
    80001ce6:	5be50513          	addi	a0,a0,1470 # 800082a0 <states.0+0x58>
    80001cea:	00004097          	auipc	ra,0x4
    80001cee:	e3c080e7          	jalr	-452(ra) # 80005b26 <panic>
    if(killed(p))
    80001cf2:	00000097          	auipc	ra,0x0
    80001cf6:	ab0080e7          	jalr	-1360(ra) # 800017a2 <killed>
    80001cfa:	e921                	bnez	a0,80001d4a <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001cfc:	6cb8                	ld	a4,88(s1)
    80001cfe:	6f1c                	ld	a5,24(a4)
    80001d00:	0791                	addi	a5,a5,4
    80001d02:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d04:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d08:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d0c:	10079073          	csrw	sstatus,a5
    syscall();
    80001d10:	00000097          	auipc	ra,0x0
    80001d14:	2d4080e7          	jalr	724(ra) # 80001fe4 <syscall>
  if(killed(p))
    80001d18:	8526                	mv	a0,s1
    80001d1a:	00000097          	auipc	ra,0x0
    80001d1e:	a88080e7          	jalr	-1400(ra) # 800017a2 <killed>
    80001d22:	c911                	beqz	a0,80001d36 <usertrap+0xac>
    80001d24:	4901                	li	s2,0
    exit(-1);
    80001d26:	557d                	li	a0,-1
    80001d28:	00000097          	auipc	ra,0x0
    80001d2c:	906080e7          	jalr	-1786(ra) # 8000162e <exit>
  if(which_dev == 2)
    80001d30:	4789                	li	a5,2
    80001d32:	04f90f63          	beq	s2,a5,80001d90 <usertrap+0x106>
  usertrapret();
    80001d36:	00000097          	auipc	ra,0x0
    80001d3a:	dd2080e7          	jalr	-558(ra) # 80001b08 <usertrapret>
}
    80001d3e:	60e2                	ld	ra,24(sp)
    80001d40:	6442                	ld	s0,16(sp)
    80001d42:	64a2                	ld	s1,8(sp)
    80001d44:	6902                	ld	s2,0(sp)
    80001d46:	6105                	addi	sp,sp,32
    80001d48:	8082                	ret
      exit(-1);
    80001d4a:	557d                	li	a0,-1
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	8e2080e7          	jalr	-1822(ra) # 8000162e <exit>
    80001d54:	b765                	j	80001cfc <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d56:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d5a:	5890                	lw	a2,48(s1)
    80001d5c:	00006517          	auipc	a0,0x6
    80001d60:	56450513          	addi	a0,a0,1380 # 800082c0 <states.0+0x78>
    80001d64:	00004097          	auipc	ra,0x4
    80001d68:	e0c080e7          	jalr	-500(ra) # 80005b70 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d6c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d70:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d74:	00006517          	auipc	a0,0x6
    80001d78:	57c50513          	addi	a0,a0,1404 # 800082f0 <states.0+0xa8>
    80001d7c:	00004097          	auipc	ra,0x4
    80001d80:	df4080e7          	jalr	-524(ra) # 80005b70 <printf>
    setkilled(p);
    80001d84:	8526                	mv	a0,s1
    80001d86:	00000097          	auipc	ra,0x0
    80001d8a:	9f0080e7          	jalr	-1552(ra) # 80001776 <setkilled>
    80001d8e:	b769                	j	80001d18 <usertrap+0x8e>
    yield();
    80001d90:	fffff097          	auipc	ra,0xfffff
    80001d94:	72e080e7          	jalr	1838(ra) # 800014be <yield>
    80001d98:	bf79                	j	80001d36 <usertrap+0xac>

0000000080001d9a <kerneltrap>:
{
    80001d9a:	7179                	addi	sp,sp,-48
    80001d9c:	f406                	sd	ra,40(sp)
    80001d9e:	f022                	sd	s0,32(sp)
    80001da0:	ec26                	sd	s1,24(sp)
    80001da2:	e84a                	sd	s2,16(sp)
    80001da4:	e44e                	sd	s3,8(sp)
    80001da6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dac:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001db4:	1004f793          	andi	a5,s1,256
    80001db8:	cb85                	beqz	a5,80001de8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dbe:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dc0:	ef85                	bnez	a5,80001df8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dc2:	00000097          	auipc	ra,0x0
    80001dc6:	e22080e7          	jalr	-478(ra) # 80001be4 <devintr>
    80001dca:	cd1d                	beqz	a0,80001e08 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dcc:	4789                	li	a5,2
    80001dce:	06f50a63          	beq	a0,a5,80001e42 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dd2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd6:	10049073          	csrw	sstatus,s1
}
    80001dda:	70a2                	ld	ra,40(sp)
    80001ddc:	7402                	ld	s0,32(sp)
    80001dde:	64e2                	ld	s1,24(sp)
    80001de0:	6942                	ld	s2,16(sp)
    80001de2:	69a2                	ld	s3,8(sp)
    80001de4:	6145                	addi	sp,sp,48
    80001de6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001de8:	00006517          	auipc	a0,0x6
    80001dec:	52850513          	addi	a0,a0,1320 # 80008310 <states.0+0xc8>
    80001df0:	00004097          	auipc	ra,0x4
    80001df4:	d36080e7          	jalr	-714(ra) # 80005b26 <panic>
    panic("kerneltrap: interrupts enabled");
    80001df8:	00006517          	auipc	a0,0x6
    80001dfc:	54050513          	addi	a0,a0,1344 # 80008338 <states.0+0xf0>
    80001e00:	00004097          	auipc	ra,0x4
    80001e04:	d26080e7          	jalr	-730(ra) # 80005b26 <panic>
    printf("scause %p\n", scause);
    80001e08:	85ce                	mv	a1,s3
    80001e0a:	00006517          	auipc	a0,0x6
    80001e0e:	54e50513          	addi	a0,a0,1358 # 80008358 <states.0+0x110>
    80001e12:	00004097          	auipc	ra,0x4
    80001e16:	d5e080e7          	jalr	-674(ra) # 80005b70 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e1a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e1e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e22:	00006517          	auipc	a0,0x6
    80001e26:	54650513          	addi	a0,a0,1350 # 80008368 <states.0+0x120>
    80001e2a:	00004097          	auipc	ra,0x4
    80001e2e:	d46080e7          	jalr	-698(ra) # 80005b70 <printf>
    panic("kerneltrap");
    80001e32:	00006517          	auipc	a0,0x6
    80001e36:	54e50513          	addi	a0,a0,1358 # 80008380 <states.0+0x138>
    80001e3a:	00004097          	auipc	ra,0x4
    80001e3e:	cec080e7          	jalr	-788(ra) # 80005b26 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	010080e7          	jalr	16(ra) # 80000e52 <myproc>
    80001e4a:	d541                	beqz	a0,80001dd2 <kerneltrap+0x38>
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	006080e7          	jalr	6(ra) # 80000e52 <myproc>
    80001e54:	4d18                	lw	a4,24(a0)
    80001e56:	4791                	li	a5,4
    80001e58:	f6f71de3          	bne	a4,a5,80001dd2 <kerneltrap+0x38>
    yield();
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	662080e7          	jalr	1634(ra) # 800014be <yield>
    80001e64:	b7bd                	j	80001dd2 <kerneltrap+0x38>

0000000080001e66 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e66:	1101                	addi	sp,sp,-32
    80001e68:	ec06                	sd	ra,24(sp)
    80001e6a:	e822                	sd	s0,16(sp)
    80001e6c:	e426                	sd	s1,8(sp)
    80001e6e:	1000                	addi	s0,sp,32
    80001e70:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	fe0080e7          	jalr	-32(ra) # 80000e52 <myproc>
  switch (n) {
    80001e7a:	4795                	li	a5,5
    80001e7c:	0497e163          	bltu	a5,s1,80001ebe <argraw+0x58>
    80001e80:	048a                	slli	s1,s1,0x2
    80001e82:	00006717          	auipc	a4,0x6
    80001e86:	53670713          	addi	a4,a4,1334 # 800083b8 <states.0+0x170>
    80001e8a:	94ba                	add	s1,s1,a4
    80001e8c:	409c                	lw	a5,0(s1)
    80001e8e:	97ba                	add	a5,a5,a4
    80001e90:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e92:	6d3c                	ld	a5,88(a0)
    80001e94:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e96:	60e2                	ld	ra,24(sp)
    80001e98:	6442                	ld	s0,16(sp)
    80001e9a:	64a2                	ld	s1,8(sp)
    80001e9c:	6105                	addi	sp,sp,32
    80001e9e:	8082                	ret
    return p->trapframe->a1;
    80001ea0:	6d3c                	ld	a5,88(a0)
    80001ea2:	7fa8                	ld	a0,120(a5)
    80001ea4:	bfcd                	j	80001e96 <argraw+0x30>
    return p->trapframe->a2;
    80001ea6:	6d3c                	ld	a5,88(a0)
    80001ea8:	63c8                	ld	a0,128(a5)
    80001eaa:	b7f5                	j	80001e96 <argraw+0x30>
    return p->trapframe->a3;
    80001eac:	6d3c                	ld	a5,88(a0)
    80001eae:	67c8                	ld	a0,136(a5)
    80001eb0:	b7dd                	j	80001e96 <argraw+0x30>
    return p->trapframe->a4;
    80001eb2:	6d3c                	ld	a5,88(a0)
    80001eb4:	6bc8                	ld	a0,144(a5)
    80001eb6:	b7c5                	j	80001e96 <argraw+0x30>
    return p->trapframe->a5;
    80001eb8:	6d3c                	ld	a5,88(a0)
    80001eba:	6fc8                	ld	a0,152(a5)
    80001ebc:	bfe9                	j	80001e96 <argraw+0x30>
  panic("argraw");
    80001ebe:	00006517          	auipc	a0,0x6
    80001ec2:	4d250513          	addi	a0,a0,1234 # 80008390 <states.0+0x148>
    80001ec6:	00004097          	auipc	ra,0x4
    80001eca:	c60080e7          	jalr	-928(ra) # 80005b26 <panic>

0000000080001ece <fetchaddr>:
{
    80001ece:	1101                	addi	sp,sp,-32
    80001ed0:	ec06                	sd	ra,24(sp)
    80001ed2:	e822                	sd	s0,16(sp)
    80001ed4:	e426                	sd	s1,8(sp)
    80001ed6:	e04a                	sd	s2,0(sp)
    80001ed8:	1000                	addi	s0,sp,32
    80001eda:	84aa                	mv	s1,a0
    80001edc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	f74080e7          	jalr	-140(ra) # 80000e52 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ee6:	653c                	ld	a5,72(a0)
    80001ee8:	02f4f863          	bgeu	s1,a5,80001f18 <fetchaddr+0x4a>
    80001eec:	00848713          	addi	a4,s1,8
    80001ef0:	02e7e663          	bltu	a5,a4,80001f1c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ef4:	46a1                	li	a3,8
    80001ef6:	8626                	mv	a2,s1
    80001ef8:	85ca                	mv	a1,s2
    80001efa:	6928                	ld	a0,80(a0)
    80001efc:	fffff097          	auipc	ra,0xfffff
    80001f00:	ca2080e7          	jalr	-862(ra) # 80000b9e <copyin>
    80001f04:	00a03533          	snez	a0,a0
    80001f08:	40a00533          	neg	a0,a0
}
    80001f0c:	60e2                	ld	ra,24(sp)
    80001f0e:	6442                	ld	s0,16(sp)
    80001f10:	64a2                	ld	s1,8(sp)
    80001f12:	6902                	ld	s2,0(sp)
    80001f14:	6105                	addi	sp,sp,32
    80001f16:	8082                	ret
    return -1;
    80001f18:	557d                	li	a0,-1
    80001f1a:	bfcd                	j	80001f0c <fetchaddr+0x3e>
    80001f1c:	557d                	li	a0,-1
    80001f1e:	b7fd                	j	80001f0c <fetchaddr+0x3e>

0000000080001f20 <fetchstr>:
{
    80001f20:	7179                	addi	sp,sp,-48
    80001f22:	f406                	sd	ra,40(sp)
    80001f24:	f022                	sd	s0,32(sp)
    80001f26:	ec26                	sd	s1,24(sp)
    80001f28:	e84a                	sd	s2,16(sp)
    80001f2a:	e44e                	sd	s3,8(sp)
    80001f2c:	1800                	addi	s0,sp,48
    80001f2e:	892a                	mv	s2,a0
    80001f30:	84ae                	mv	s1,a1
    80001f32:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	f1e080e7          	jalr	-226(ra) # 80000e52 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f3c:	86ce                	mv	a3,s3
    80001f3e:	864a                	mv	a2,s2
    80001f40:	85a6                	mv	a1,s1
    80001f42:	6928                	ld	a0,80(a0)
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	ce8080e7          	jalr	-792(ra) # 80000c2c <copyinstr>
    80001f4c:	00054e63          	bltz	a0,80001f68 <fetchstr+0x48>
  return strlen(buf);
    80001f50:	8526                	mv	a0,s1
    80001f52:	ffffe097          	auipc	ra,0xffffe
    80001f56:	3a2080e7          	jalr	930(ra) # 800002f4 <strlen>
}
    80001f5a:	70a2                	ld	ra,40(sp)
    80001f5c:	7402                	ld	s0,32(sp)
    80001f5e:	64e2                	ld	s1,24(sp)
    80001f60:	6942                	ld	s2,16(sp)
    80001f62:	69a2                	ld	s3,8(sp)
    80001f64:	6145                	addi	sp,sp,48
    80001f66:	8082                	ret
    return -1;
    80001f68:	557d                	li	a0,-1
    80001f6a:	bfc5                	j	80001f5a <fetchstr+0x3a>

0000000080001f6c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f6c:	1101                	addi	sp,sp,-32
    80001f6e:	ec06                	sd	ra,24(sp)
    80001f70:	e822                	sd	s0,16(sp)
    80001f72:	e426                	sd	s1,8(sp)
    80001f74:	1000                	addi	s0,sp,32
    80001f76:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f78:	00000097          	auipc	ra,0x0
    80001f7c:	eee080e7          	jalr	-274(ra) # 80001e66 <argraw>
    80001f80:	c088                	sw	a0,0(s1)
}
    80001f82:	60e2                	ld	ra,24(sp)
    80001f84:	6442                	ld	s0,16(sp)
    80001f86:	64a2                	ld	s1,8(sp)
    80001f88:	6105                	addi	sp,sp,32
    80001f8a:	8082                	ret

0000000080001f8c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f8c:	1101                	addi	sp,sp,-32
    80001f8e:	ec06                	sd	ra,24(sp)
    80001f90:	e822                	sd	s0,16(sp)
    80001f92:	e426                	sd	s1,8(sp)
    80001f94:	1000                	addi	s0,sp,32
    80001f96:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f98:	00000097          	auipc	ra,0x0
    80001f9c:	ece080e7          	jalr	-306(ra) # 80001e66 <argraw>
    80001fa0:	e088                	sd	a0,0(s1)
}
    80001fa2:	60e2                	ld	ra,24(sp)
    80001fa4:	6442                	ld	s0,16(sp)
    80001fa6:	64a2                	ld	s1,8(sp)
    80001fa8:	6105                	addi	sp,sp,32
    80001faa:	8082                	ret

0000000080001fac <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fac:	7179                	addi	sp,sp,-48
    80001fae:	f406                	sd	ra,40(sp)
    80001fb0:	f022                	sd	s0,32(sp)
    80001fb2:	ec26                	sd	s1,24(sp)
    80001fb4:	e84a                	sd	s2,16(sp)
    80001fb6:	1800                	addi	s0,sp,48
    80001fb8:	84ae                	mv	s1,a1
    80001fba:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fbc:	fd840593          	addi	a1,s0,-40
    80001fc0:	00000097          	auipc	ra,0x0
    80001fc4:	fcc080e7          	jalr	-52(ra) # 80001f8c <argaddr>
  return fetchstr(addr, buf, max);
    80001fc8:	864a                	mv	a2,s2
    80001fca:	85a6                	mv	a1,s1
    80001fcc:	fd843503          	ld	a0,-40(s0)
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	f50080e7          	jalr	-176(ra) # 80001f20 <fetchstr>
}
    80001fd8:	70a2                	ld	ra,40(sp)
    80001fda:	7402                	ld	s0,32(sp)
    80001fdc:	64e2                	ld	s1,24(sp)
    80001fde:	6942                	ld	s2,16(sp)
    80001fe0:	6145                	addi	sp,sp,48
    80001fe2:	8082                	ret

0000000080001fe4 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001fe4:	1101                	addi	sp,sp,-32
    80001fe6:	ec06                	sd	ra,24(sp)
    80001fe8:	e822                	sd	s0,16(sp)
    80001fea:	e426                	sd	s1,8(sp)
    80001fec:	e04a                	sd	s2,0(sp)
    80001fee:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	e62080e7          	jalr	-414(ra) # 80000e52 <myproc>
    80001ff8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001ffa:	05853903          	ld	s2,88(a0)
    80001ffe:	0a893783          	ld	a5,168(s2)
    80002002:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002006:	37fd                	addiw	a5,a5,-1
    80002008:	4751                	li	a4,20
    8000200a:	00f76f63          	bltu	a4,a5,80002028 <syscall+0x44>
    8000200e:	00369713          	slli	a4,a3,0x3
    80002012:	00006797          	auipc	a5,0x6
    80002016:	3be78793          	addi	a5,a5,958 # 800083d0 <syscalls>
    8000201a:	97ba                	add	a5,a5,a4
    8000201c:	639c                	ld	a5,0(a5)
    8000201e:	c789                	beqz	a5,80002028 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002020:	9782                	jalr	a5
    80002022:	06a93823          	sd	a0,112(s2)
    80002026:	a839                	j	80002044 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002028:	15848613          	addi	a2,s1,344
    8000202c:	588c                	lw	a1,48(s1)
    8000202e:	00006517          	auipc	a0,0x6
    80002032:	36a50513          	addi	a0,a0,874 # 80008398 <states.0+0x150>
    80002036:	00004097          	auipc	ra,0x4
    8000203a:	b3a080e7          	jalr	-1222(ra) # 80005b70 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000203e:	6cbc                	ld	a5,88(s1)
    80002040:	577d                	li	a4,-1
    80002042:	fbb8                	sd	a4,112(a5)
  }
}
    80002044:	60e2                	ld	ra,24(sp)
    80002046:	6442                	ld	s0,16(sp)
    80002048:	64a2                	ld	s1,8(sp)
    8000204a:	6902                	ld	s2,0(sp)
    8000204c:	6105                	addi	sp,sp,32
    8000204e:	8082                	ret

0000000080002050 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002050:	1101                	addi	sp,sp,-32
    80002052:	ec06                	sd	ra,24(sp)
    80002054:	e822                	sd	s0,16(sp)
    80002056:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002058:	fec40593          	addi	a1,s0,-20
    8000205c:	4501                	li	a0,0
    8000205e:	00000097          	auipc	ra,0x0
    80002062:	f0e080e7          	jalr	-242(ra) # 80001f6c <argint>
  exit(n);
    80002066:	fec42503          	lw	a0,-20(s0)
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	5c4080e7          	jalr	1476(ra) # 8000162e <exit>
  return 0;  // not reached
}
    80002072:	4501                	li	a0,0
    80002074:	60e2                	ld	ra,24(sp)
    80002076:	6442                	ld	s0,16(sp)
    80002078:	6105                	addi	sp,sp,32
    8000207a:	8082                	ret

000000008000207c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000207c:	1141                	addi	sp,sp,-16
    8000207e:	e406                	sd	ra,8(sp)
    80002080:	e022                	sd	s0,0(sp)
    80002082:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002084:	fffff097          	auipc	ra,0xfffff
    80002088:	dce080e7          	jalr	-562(ra) # 80000e52 <myproc>
}
    8000208c:	5908                	lw	a0,48(a0)
    8000208e:	60a2                	ld	ra,8(sp)
    80002090:	6402                	ld	s0,0(sp)
    80002092:	0141                	addi	sp,sp,16
    80002094:	8082                	ret

0000000080002096 <sys_fork>:

uint64
sys_fork(void)
{
    80002096:	1141                	addi	sp,sp,-16
    80002098:	e406                	sd	ra,8(sp)
    8000209a:	e022                	sd	s0,0(sp)
    8000209c:	0800                	addi	s0,sp,16
  return fork();
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	16a080e7          	jalr	362(ra) # 80001208 <fork>
}
    800020a6:	60a2                	ld	ra,8(sp)
    800020a8:	6402                	ld	s0,0(sp)
    800020aa:	0141                	addi	sp,sp,16
    800020ac:	8082                	ret

00000000800020ae <sys_wait>:

uint64
sys_wait(void)
{
    800020ae:	1101                	addi	sp,sp,-32
    800020b0:	ec06                	sd	ra,24(sp)
    800020b2:	e822                	sd	s0,16(sp)
    800020b4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020b6:	fe840593          	addi	a1,s0,-24
    800020ba:	4501                	li	a0,0
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	ed0080e7          	jalr	-304(ra) # 80001f8c <argaddr>
  return wait(p);
    800020c4:	fe843503          	ld	a0,-24(s0)
    800020c8:	fffff097          	auipc	ra,0xfffff
    800020cc:	70c080e7          	jalr	1804(ra) # 800017d4 <wait>
}
    800020d0:	60e2                	ld	ra,24(sp)
    800020d2:	6442                	ld	s0,16(sp)
    800020d4:	6105                	addi	sp,sp,32
    800020d6:	8082                	ret

00000000800020d8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020d8:	7179                	addi	sp,sp,-48
    800020da:	f406                	sd	ra,40(sp)
    800020dc:	f022                	sd	s0,32(sp)
    800020de:	ec26                	sd	s1,24(sp)
    800020e0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020e2:	fdc40593          	addi	a1,s0,-36
    800020e6:	4501                	li	a0,0
    800020e8:	00000097          	auipc	ra,0x0
    800020ec:	e84080e7          	jalr	-380(ra) # 80001f6c <argint>
  addr = myproc()->sz;
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	d62080e7          	jalr	-670(ra) # 80000e52 <myproc>
    800020f8:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800020fa:	fdc42503          	lw	a0,-36(s0)
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	0ae080e7          	jalr	174(ra) # 800011ac <growproc>
    80002106:	00054863          	bltz	a0,80002116 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000210a:	8526                	mv	a0,s1
    8000210c:	70a2                	ld	ra,40(sp)
    8000210e:	7402                	ld	s0,32(sp)
    80002110:	64e2                	ld	s1,24(sp)
    80002112:	6145                	addi	sp,sp,48
    80002114:	8082                	ret
    return -1;
    80002116:	54fd                	li	s1,-1
    80002118:	bfcd                	j	8000210a <sys_sbrk+0x32>

000000008000211a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000211a:	7139                	addi	sp,sp,-64
    8000211c:	fc06                	sd	ra,56(sp)
    8000211e:	f822                	sd	s0,48(sp)
    80002120:	f426                	sd	s1,40(sp)
    80002122:	f04a                	sd	s2,32(sp)
    80002124:	ec4e                	sd	s3,24(sp)
    80002126:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002128:	fcc40593          	addi	a1,s0,-52
    8000212c:	4501                	li	a0,0
    8000212e:	00000097          	auipc	ra,0x0
    80002132:	e3e080e7          	jalr	-450(ra) # 80001f6c <argint>
  acquire(&tickslock);
    80002136:	0000c517          	auipc	a0,0xc
    8000213a:	5fa50513          	addi	a0,a0,1530 # 8000e730 <tickslock>
    8000213e:	00004097          	auipc	ra,0x4
    80002142:	f20080e7          	jalr	-224(ra) # 8000605e <acquire>
  ticks0 = ticks;
    80002146:	00006917          	auipc	s2,0x6
    8000214a:	78292903          	lw	s2,1922(s2) # 800088c8 <ticks>
  while(ticks - ticks0 < n){
    8000214e:	fcc42783          	lw	a5,-52(s0)
    80002152:	cf9d                	beqz	a5,80002190 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002154:	0000c997          	auipc	s3,0xc
    80002158:	5dc98993          	addi	s3,s3,1500 # 8000e730 <tickslock>
    8000215c:	00006497          	auipc	s1,0x6
    80002160:	76c48493          	addi	s1,s1,1900 # 800088c8 <ticks>
    if(killed(myproc())){
    80002164:	fffff097          	auipc	ra,0xfffff
    80002168:	cee080e7          	jalr	-786(ra) # 80000e52 <myproc>
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	636080e7          	jalr	1590(ra) # 800017a2 <killed>
    80002174:	ed15                	bnez	a0,800021b0 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002176:	85ce                	mv	a1,s3
    80002178:	8526                	mv	a0,s1
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	380080e7          	jalr	896(ra) # 800014fa <sleep>
  while(ticks - ticks0 < n){
    80002182:	409c                	lw	a5,0(s1)
    80002184:	412787bb          	subw	a5,a5,s2
    80002188:	fcc42703          	lw	a4,-52(s0)
    8000218c:	fce7ece3          	bltu	a5,a4,80002164 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002190:	0000c517          	auipc	a0,0xc
    80002194:	5a050513          	addi	a0,a0,1440 # 8000e730 <tickslock>
    80002198:	00004097          	auipc	ra,0x4
    8000219c:	f7a080e7          	jalr	-134(ra) # 80006112 <release>
  return 0;
    800021a0:	4501                	li	a0,0
}
    800021a2:	70e2                	ld	ra,56(sp)
    800021a4:	7442                	ld	s0,48(sp)
    800021a6:	74a2                	ld	s1,40(sp)
    800021a8:	7902                	ld	s2,32(sp)
    800021aa:	69e2                	ld	s3,24(sp)
    800021ac:	6121                	addi	sp,sp,64
    800021ae:	8082                	ret
      release(&tickslock);
    800021b0:	0000c517          	auipc	a0,0xc
    800021b4:	58050513          	addi	a0,a0,1408 # 8000e730 <tickslock>
    800021b8:	00004097          	auipc	ra,0x4
    800021bc:	f5a080e7          	jalr	-166(ra) # 80006112 <release>
      return -1;
    800021c0:	557d                	li	a0,-1
    800021c2:	b7c5                	j	800021a2 <sys_sleep+0x88>

00000000800021c4 <sys_kill>:

uint64
sys_kill(void)
{
    800021c4:	1101                	addi	sp,sp,-32
    800021c6:	ec06                	sd	ra,24(sp)
    800021c8:	e822                	sd	s0,16(sp)
    800021ca:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021cc:	fec40593          	addi	a1,s0,-20
    800021d0:	4501                	li	a0,0
    800021d2:	00000097          	auipc	ra,0x0
    800021d6:	d9a080e7          	jalr	-614(ra) # 80001f6c <argint>
  return kill(pid);
    800021da:	fec42503          	lw	a0,-20(s0)
    800021de:	fffff097          	auipc	ra,0xfffff
    800021e2:	526080e7          	jalr	1318(ra) # 80001704 <kill>
}
    800021e6:	60e2                	ld	ra,24(sp)
    800021e8:	6442                	ld	s0,16(sp)
    800021ea:	6105                	addi	sp,sp,32
    800021ec:	8082                	ret

00000000800021ee <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021ee:	1101                	addi	sp,sp,-32
    800021f0:	ec06                	sd	ra,24(sp)
    800021f2:	e822                	sd	s0,16(sp)
    800021f4:	e426                	sd	s1,8(sp)
    800021f6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021f8:	0000c517          	auipc	a0,0xc
    800021fc:	53850513          	addi	a0,a0,1336 # 8000e730 <tickslock>
    80002200:	00004097          	auipc	ra,0x4
    80002204:	e5e080e7          	jalr	-418(ra) # 8000605e <acquire>
  xticks = ticks;
    80002208:	00006497          	auipc	s1,0x6
    8000220c:	6c04a483          	lw	s1,1728(s1) # 800088c8 <ticks>
  release(&tickslock);
    80002210:	0000c517          	auipc	a0,0xc
    80002214:	52050513          	addi	a0,a0,1312 # 8000e730 <tickslock>
    80002218:	00004097          	auipc	ra,0x4
    8000221c:	efa080e7          	jalr	-262(ra) # 80006112 <release>
  return xticks;
}
    80002220:	02049513          	slli	a0,s1,0x20
    80002224:	9101                	srli	a0,a0,0x20
    80002226:	60e2                	ld	ra,24(sp)
    80002228:	6442                	ld	s0,16(sp)
    8000222a:	64a2                	ld	s1,8(sp)
    8000222c:	6105                	addi	sp,sp,32
    8000222e:	8082                	ret

0000000080002230 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002230:	7179                	addi	sp,sp,-48
    80002232:	f406                	sd	ra,40(sp)
    80002234:	f022                	sd	s0,32(sp)
    80002236:	ec26                	sd	s1,24(sp)
    80002238:	e84a                	sd	s2,16(sp)
    8000223a:	e44e                	sd	s3,8(sp)
    8000223c:	e052                	sd	s4,0(sp)
    8000223e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002240:	00006597          	auipc	a1,0x6
    80002244:	24058593          	addi	a1,a1,576 # 80008480 <syscalls+0xb0>
    80002248:	0000c517          	auipc	a0,0xc
    8000224c:	50050513          	addi	a0,a0,1280 # 8000e748 <bcache>
    80002250:	00004097          	auipc	ra,0x4
    80002254:	d7e080e7          	jalr	-642(ra) # 80005fce <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002258:	00014797          	auipc	a5,0x14
    8000225c:	4f078793          	addi	a5,a5,1264 # 80016748 <bcache+0x8000>
    80002260:	00014717          	auipc	a4,0x14
    80002264:	75070713          	addi	a4,a4,1872 # 800169b0 <bcache+0x8268>
    80002268:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000226c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002270:	0000c497          	auipc	s1,0xc
    80002274:	4f048493          	addi	s1,s1,1264 # 8000e760 <bcache+0x18>
    b->next = bcache.head.next;
    80002278:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000227a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000227c:	00006a17          	auipc	s4,0x6
    80002280:	20ca0a13          	addi	s4,s4,524 # 80008488 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002284:	2b893783          	ld	a5,696(s2)
    80002288:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000228a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000228e:	85d2                	mv	a1,s4
    80002290:	01048513          	addi	a0,s1,16
    80002294:	00001097          	auipc	ra,0x1
    80002298:	496080e7          	jalr	1174(ra) # 8000372a <initsleeplock>
    bcache.head.next->prev = b;
    8000229c:	2b893783          	ld	a5,696(s2)
    800022a0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022a2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022a6:	45848493          	addi	s1,s1,1112
    800022aa:	fd349de3          	bne	s1,s3,80002284 <binit+0x54>
  }
}
    800022ae:	70a2                	ld	ra,40(sp)
    800022b0:	7402                	ld	s0,32(sp)
    800022b2:	64e2                	ld	s1,24(sp)
    800022b4:	6942                	ld	s2,16(sp)
    800022b6:	69a2                	ld	s3,8(sp)
    800022b8:	6a02                	ld	s4,0(sp)
    800022ba:	6145                	addi	sp,sp,48
    800022bc:	8082                	ret

00000000800022be <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022be:	7179                	addi	sp,sp,-48
    800022c0:	f406                	sd	ra,40(sp)
    800022c2:	f022                	sd	s0,32(sp)
    800022c4:	ec26                	sd	s1,24(sp)
    800022c6:	e84a                	sd	s2,16(sp)
    800022c8:	e44e                	sd	s3,8(sp)
    800022ca:	1800                	addi	s0,sp,48
    800022cc:	892a                	mv	s2,a0
    800022ce:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022d0:	0000c517          	auipc	a0,0xc
    800022d4:	47850513          	addi	a0,a0,1144 # 8000e748 <bcache>
    800022d8:	00004097          	auipc	ra,0x4
    800022dc:	d86080e7          	jalr	-634(ra) # 8000605e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022e0:	00014497          	auipc	s1,0x14
    800022e4:	7204b483          	ld	s1,1824(s1) # 80016a00 <bcache+0x82b8>
    800022e8:	00014797          	auipc	a5,0x14
    800022ec:	6c878793          	addi	a5,a5,1736 # 800169b0 <bcache+0x8268>
    800022f0:	02f48f63          	beq	s1,a5,8000232e <bread+0x70>
    800022f4:	873e                	mv	a4,a5
    800022f6:	a021                	j	800022fe <bread+0x40>
    800022f8:	68a4                	ld	s1,80(s1)
    800022fa:	02e48a63          	beq	s1,a4,8000232e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022fe:	449c                	lw	a5,8(s1)
    80002300:	ff279ce3          	bne	a5,s2,800022f8 <bread+0x3a>
    80002304:	44dc                	lw	a5,12(s1)
    80002306:	ff3799e3          	bne	a5,s3,800022f8 <bread+0x3a>
      b->refcnt++;
    8000230a:	40bc                	lw	a5,64(s1)
    8000230c:	2785                	addiw	a5,a5,1
    8000230e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002310:	0000c517          	auipc	a0,0xc
    80002314:	43850513          	addi	a0,a0,1080 # 8000e748 <bcache>
    80002318:	00004097          	auipc	ra,0x4
    8000231c:	dfa080e7          	jalr	-518(ra) # 80006112 <release>
      acquiresleep(&b->lock);
    80002320:	01048513          	addi	a0,s1,16
    80002324:	00001097          	auipc	ra,0x1
    80002328:	440080e7          	jalr	1088(ra) # 80003764 <acquiresleep>
      return b;
    8000232c:	a8b9                	j	8000238a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000232e:	00014497          	auipc	s1,0x14
    80002332:	6ca4b483          	ld	s1,1738(s1) # 800169f8 <bcache+0x82b0>
    80002336:	00014797          	auipc	a5,0x14
    8000233a:	67a78793          	addi	a5,a5,1658 # 800169b0 <bcache+0x8268>
    8000233e:	00f48863          	beq	s1,a5,8000234e <bread+0x90>
    80002342:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002344:	40bc                	lw	a5,64(s1)
    80002346:	cf81                	beqz	a5,8000235e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002348:	64a4                	ld	s1,72(s1)
    8000234a:	fee49de3          	bne	s1,a4,80002344 <bread+0x86>
  panic("bget: no buffers");
    8000234e:	00006517          	auipc	a0,0x6
    80002352:	14250513          	addi	a0,a0,322 # 80008490 <syscalls+0xc0>
    80002356:	00003097          	auipc	ra,0x3
    8000235a:	7d0080e7          	jalr	2000(ra) # 80005b26 <panic>
      b->dev = dev;
    8000235e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002362:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002366:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000236a:	4785                	li	a5,1
    8000236c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000236e:	0000c517          	auipc	a0,0xc
    80002372:	3da50513          	addi	a0,a0,986 # 8000e748 <bcache>
    80002376:	00004097          	auipc	ra,0x4
    8000237a:	d9c080e7          	jalr	-612(ra) # 80006112 <release>
      acquiresleep(&b->lock);
    8000237e:	01048513          	addi	a0,s1,16
    80002382:	00001097          	auipc	ra,0x1
    80002386:	3e2080e7          	jalr	994(ra) # 80003764 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000238a:	409c                	lw	a5,0(s1)
    8000238c:	cb89                	beqz	a5,8000239e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000238e:	8526                	mv	a0,s1
    80002390:	70a2                	ld	ra,40(sp)
    80002392:	7402                	ld	s0,32(sp)
    80002394:	64e2                	ld	s1,24(sp)
    80002396:	6942                	ld	s2,16(sp)
    80002398:	69a2                	ld	s3,8(sp)
    8000239a:	6145                	addi	sp,sp,48
    8000239c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000239e:	4581                	li	a1,0
    800023a0:	8526                	mv	a0,s1
    800023a2:	00003097          	auipc	ra,0x3
    800023a6:	f80080e7          	jalr	-128(ra) # 80005322 <virtio_disk_rw>
    b->valid = 1;
    800023aa:	4785                	li	a5,1
    800023ac:	c09c                	sw	a5,0(s1)
  return b;
    800023ae:	b7c5                	j	8000238e <bread+0xd0>

00000000800023b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023b0:	1101                	addi	sp,sp,-32
    800023b2:	ec06                	sd	ra,24(sp)
    800023b4:	e822                	sd	s0,16(sp)
    800023b6:	e426                	sd	s1,8(sp)
    800023b8:	1000                	addi	s0,sp,32
    800023ba:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023bc:	0541                	addi	a0,a0,16
    800023be:	00001097          	auipc	ra,0x1
    800023c2:	440080e7          	jalr	1088(ra) # 800037fe <holdingsleep>
    800023c6:	cd01                	beqz	a0,800023de <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023c8:	4585                	li	a1,1
    800023ca:	8526                	mv	a0,s1
    800023cc:	00003097          	auipc	ra,0x3
    800023d0:	f56080e7          	jalr	-170(ra) # 80005322 <virtio_disk_rw>
}
    800023d4:	60e2                	ld	ra,24(sp)
    800023d6:	6442                	ld	s0,16(sp)
    800023d8:	64a2                	ld	s1,8(sp)
    800023da:	6105                	addi	sp,sp,32
    800023dc:	8082                	ret
    panic("bwrite");
    800023de:	00006517          	auipc	a0,0x6
    800023e2:	0ca50513          	addi	a0,a0,202 # 800084a8 <syscalls+0xd8>
    800023e6:	00003097          	auipc	ra,0x3
    800023ea:	740080e7          	jalr	1856(ra) # 80005b26 <panic>

00000000800023ee <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023ee:	1101                	addi	sp,sp,-32
    800023f0:	ec06                	sd	ra,24(sp)
    800023f2:	e822                	sd	s0,16(sp)
    800023f4:	e426                	sd	s1,8(sp)
    800023f6:	e04a                	sd	s2,0(sp)
    800023f8:	1000                	addi	s0,sp,32
    800023fa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023fc:	01050913          	addi	s2,a0,16
    80002400:	854a                	mv	a0,s2
    80002402:	00001097          	auipc	ra,0x1
    80002406:	3fc080e7          	jalr	1020(ra) # 800037fe <holdingsleep>
    8000240a:	c925                	beqz	a0,8000247a <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000240c:	854a                	mv	a0,s2
    8000240e:	00001097          	auipc	ra,0x1
    80002412:	3ac080e7          	jalr	940(ra) # 800037ba <releasesleep>

  acquire(&bcache.lock);
    80002416:	0000c517          	auipc	a0,0xc
    8000241a:	33250513          	addi	a0,a0,818 # 8000e748 <bcache>
    8000241e:	00004097          	auipc	ra,0x4
    80002422:	c40080e7          	jalr	-960(ra) # 8000605e <acquire>
  b->refcnt--;
    80002426:	40bc                	lw	a5,64(s1)
    80002428:	37fd                	addiw	a5,a5,-1
    8000242a:	0007871b          	sext.w	a4,a5
    8000242e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002430:	e71d                	bnez	a4,8000245e <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002432:	68b8                	ld	a4,80(s1)
    80002434:	64bc                	ld	a5,72(s1)
    80002436:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002438:	68b8                	ld	a4,80(s1)
    8000243a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000243c:	00014797          	auipc	a5,0x14
    80002440:	30c78793          	addi	a5,a5,780 # 80016748 <bcache+0x8000>
    80002444:	2b87b703          	ld	a4,696(a5)
    80002448:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000244a:	00014717          	auipc	a4,0x14
    8000244e:	56670713          	addi	a4,a4,1382 # 800169b0 <bcache+0x8268>
    80002452:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002454:	2b87b703          	ld	a4,696(a5)
    80002458:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000245a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000245e:	0000c517          	auipc	a0,0xc
    80002462:	2ea50513          	addi	a0,a0,746 # 8000e748 <bcache>
    80002466:	00004097          	auipc	ra,0x4
    8000246a:	cac080e7          	jalr	-852(ra) # 80006112 <release>
}
    8000246e:	60e2                	ld	ra,24(sp)
    80002470:	6442                	ld	s0,16(sp)
    80002472:	64a2                	ld	s1,8(sp)
    80002474:	6902                	ld	s2,0(sp)
    80002476:	6105                	addi	sp,sp,32
    80002478:	8082                	ret
    panic("brelse");
    8000247a:	00006517          	auipc	a0,0x6
    8000247e:	03650513          	addi	a0,a0,54 # 800084b0 <syscalls+0xe0>
    80002482:	00003097          	auipc	ra,0x3
    80002486:	6a4080e7          	jalr	1700(ra) # 80005b26 <panic>

000000008000248a <bpin>:

void
bpin(struct buf *b) {
    8000248a:	1101                	addi	sp,sp,-32
    8000248c:	ec06                	sd	ra,24(sp)
    8000248e:	e822                	sd	s0,16(sp)
    80002490:	e426                	sd	s1,8(sp)
    80002492:	1000                	addi	s0,sp,32
    80002494:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002496:	0000c517          	auipc	a0,0xc
    8000249a:	2b250513          	addi	a0,a0,690 # 8000e748 <bcache>
    8000249e:	00004097          	auipc	ra,0x4
    800024a2:	bc0080e7          	jalr	-1088(ra) # 8000605e <acquire>
  b->refcnt++;
    800024a6:	40bc                	lw	a5,64(s1)
    800024a8:	2785                	addiw	a5,a5,1
    800024aa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024ac:	0000c517          	auipc	a0,0xc
    800024b0:	29c50513          	addi	a0,a0,668 # 8000e748 <bcache>
    800024b4:	00004097          	auipc	ra,0x4
    800024b8:	c5e080e7          	jalr	-930(ra) # 80006112 <release>
}
    800024bc:	60e2                	ld	ra,24(sp)
    800024be:	6442                	ld	s0,16(sp)
    800024c0:	64a2                	ld	s1,8(sp)
    800024c2:	6105                	addi	sp,sp,32
    800024c4:	8082                	ret

00000000800024c6 <bunpin>:

void
bunpin(struct buf *b) {
    800024c6:	1101                	addi	sp,sp,-32
    800024c8:	ec06                	sd	ra,24(sp)
    800024ca:	e822                	sd	s0,16(sp)
    800024cc:	e426                	sd	s1,8(sp)
    800024ce:	1000                	addi	s0,sp,32
    800024d0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024d2:	0000c517          	auipc	a0,0xc
    800024d6:	27650513          	addi	a0,a0,630 # 8000e748 <bcache>
    800024da:	00004097          	auipc	ra,0x4
    800024de:	b84080e7          	jalr	-1148(ra) # 8000605e <acquire>
  b->refcnt--;
    800024e2:	40bc                	lw	a5,64(s1)
    800024e4:	37fd                	addiw	a5,a5,-1
    800024e6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024e8:	0000c517          	auipc	a0,0xc
    800024ec:	26050513          	addi	a0,a0,608 # 8000e748 <bcache>
    800024f0:	00004097          	auipc	ra,0x4
    800024f4:	c22080e7          	jalr	-990(ra) # 80006112 <release>
}
    800024f8:	60e2                	ld	ra,24(sp)
    800024fa:	6442                	ld	s0,16(sp)
    800024fc:	64a2                	ld	s1,8(sp)
    800024fe:	6105                	addi	sp,sp,32
    80002500:	8082                	ret

0000000080002502 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002502:	1101                	addi	sp,sp,-32
    80002504:	ec06                	sd	ra,24(sp)
    80002506:	e822                	sd	s0,16(sp)
    80002508:	e426                	sd	s1,8(sp)
    8000250a:	e04a                	sd	s2,0(sp)
    8000250c:	1000                	addi	s0,sp,32
    8000250e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002510:	00d5d59b          	srliw	a1,a1,0xd
    80002514:	00015797          	auipc	a5,0x15
    80002518:	9107a783          	lw	a5,-1776(a5) # 80016e24 <sb+0x1c>
    8000251c:	9dbd                	addw	a1,a1,a5
    8000251e:	00000097          	auipc	ra,0x0
    80002522:	da0080e7          	jalr	-608(ra) # 800022be <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002526:	0074f713          	andi	a4,s1,7
    8000252a:	4785                	li	a5,1
    8000252c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002530:	14ce                	slli	s1,s1,0x33
    80002532:	90d9                	srli	s1,s1,0x36
    80002534:	00950733          	add	a4,a0,s1
    80002538:	05874703          	lbu	a4,88(a4)
    8000253c:	00e7f6b3          	and	a3,a5,a4
    80002540:	c69d                	beqz	a3,8000256e <bfree+0x6c>
    80002542:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002544:	94aa                	add	s1,s1,a0
    80002546:	fff7c793          	not	a5,a5
    8000254a:	8f7d                	and	a4,a4,a5
    8000254c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002550:	00001097          	auipc	ra,0x1
    80002554:	0f6080e7          	jalr	246(ra) # 80003646 <log_write>
  brelse(bp);
    80002558:	854a                	mv	a0,s2
    8000255a:	00000097          	auipc	ra,0x0
    8000255e:	e94080e7          	jalr	-364(ra) # 800023ee <brelse>
}
    80002562:	60e2                	ld	ra,24(sp)
    80002564:	6442                	ld	s0,16(sp)
    80002566:	64a2                	ld	s1,8(sp)
    80002568:	6902                	ld	s2,0(sp)
    8000256a:	6105                	addi	sp,sp,32
    8000256c:	8082                	ret
    panic("freeing free block");
    8000256e:	00006517          	auipc	a0,0x6
    80002572:	f4a50513          	addi	a0,a0,-182 # 800084b8 <syscalls+0xe8>
    80002576:	00003097          	auipc	ra,0x3
    8000257a:	5b0080e7          	jalr	1456(ra) # 80005b26 <panic>

000000008000257e <balloc>:
{
    8000257e:	711d                	addi	sp,sp,-96
    80002580:	ec86                	sd	ra,88(sp)
    80002582:	e8a2                	sd	s0,80(sp)
    80002584:	e4a6                	sd	s1,72(sp)
    80002586:	e0ca                	sd	s2,64(sp)
    80002588:	fc4e                	sd	s3,56(sp)
    8000258a:	f852                	sd	s4,48(sp)
    8000258c:	f456                	sd	s5,40(sp)
    8000258e:	f05a                	sd	s6,32(sp)
    80002590:	ec5e                	sd	s7,24(sp)
    80002592:	e862                	sd	s8,16(sp)
    80002594:	e466                	sd	s9,8(sp)
    80002596:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002598:	00015797          	auipc	a5,0x15
    8000259c:	8747a783          	lw	a5,-1932(a5) # 80016e0c <sb+0x4>
    800025a0:	cff5                	beqz	a5,8000269c <balloc+0x11e>
    800025a2:	8baa                	mv	s7,a0
    800025a4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025a6:	00015b17          	auipc	s6,0x15
    800025aa:	862b0b13          	addi	s6,s6,-1950 # 80016e08 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ae:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025b0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025b2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025b4:	6c89                	lui	s9,0x2
    800025b6:	a061                	j	8000263e <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025b8:	97ca                	add	a5,a5,s2
    800025ba:	8e55                	or	a2,a2,a3
    800025bc:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800025c0:	854a                	mv	a0,s2
    800025c2:	00001097          	auipc	ra,0x1
    800025c6:	084080e7          	jalr	132(ra) # 80003646 <log_write>
        brelse(bp);
    800025ca:	854a                	mv	a0,s2
    800025cc:	00000097          	auipc	ra,0x0
    800025d0:	e22080e7          	jalr	-478(ra) # 800023ee <brelse>
  bp = bread(dev, bno);
    800025d4:	85a6                	mv	a1,s1
    800025d6:	855e                	mv	a0,s7
    800025d8:	00000097          	auipc	ra,0x0
    800025dc:	ce6080e7          	jalr	-794(ra) # 800022be <bread>
    800025e0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025e2:	40000613          	li	a2,1024
    800025e6:	4581                	li	a1,0
    800025e8:	05850513          	addi	a0,a0,88
    800025ec:	ffffe097          	auipc	ra,0xffffe
    800025f0:	b8e080e7          	jalr	-1138(ra) # 8000017a <memset>
  log_write(bp);
    800025f4:	854a                	mv	a0,s2
    800025f6:	00001097          	auipc	ra,0x1
    800025fa:	050080e7          	jalr	80(ra) # 80003646 <log_write>
  brelse(bp);
    800025fe:	854a                	mv	a0,s2
    80002600:	00000097          	auipc	ra,0x0
    80002604:	dee080e7          	jalr	-530(ra) # 800023ee <brelse>
}
    80002608:	8526                	mv	a0,s1
    8000260a:	60e6                	ld	ra,88(sp)
    8000260c:	6446                	ld	s0,80(sp)
    8000260e:	64a6                	ld	s1,72(sp)
    80002610:	6906                	ld	s2,64(sp)
    80002612:	79e2                	ld	s3,56(sp)
    80002614:	7a42                	ld	s4,48(sp)
    80002616:	7aa2                	ld	s5,40(sp)
    80002618:	7b02                	ld	s6,32(sp)
    8000261a:	6be2                	ld	s7,24(sp)
    8000261c:	6c42                	ld	s8,16(sp)
    8000261e:	6ca2                	ld	s9,8(sp)
    80002620:	6125                	addi	sp,sp,96
    80002622:	8082                	ret
    brelse(bp);
    80002624:	854a                	mv	a0,s2
    80002626:	00000097          	auipc	ra,0x0
    8000262a:	dc8080e7          	jalr	-568(ra) # 800023ee <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000262e:	015c87bb          	addw	a5,s9,s5
    80002632:	00078a9b          	sext.w	s5,a5
    80002636:	004b2703          	lw	a4,4(s6)
    8000263a:	06eaf163          	bgeu	s5,a4,8000269c <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000263e:	41fad79b          	sraiw	a5,s5,0x1f
    80002642:	0137d79b          	srliw	a5,a5,0x13
    80002646:	015787bb          	addw	a5,a5,s5
    8000264a:	40d7d79b          	sraiw	a5,a5,0xd
    8000264e:	01cb2583          	lw	a1,28(s6)
    80002652:	9dbd                	addw	a1,a1,a5
    80002654:	855e                	mv	a0,s7
    80002656:	00000097          	auipc	ra,0x0
    8000265a:	c68080e7          	jalr	-920(ra) # 800022be <bread>
    8000265e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002660:	004b2503          	lw	a0,4(s6)
    80002664:	000a849b          	sext.w	s1,s5
    80002668:	8762                	mv	a4,s8
    8000266a:	faa4fde3          	bgeu	s1,a0,80002624 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000266e:	00777693          	andi	a3,a4,7
    80002672:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002676:	41f7579b          	sraiw	a5,a4,0x1f
    8000267a:	01d7d79b          	srliw	a5,a5,0x1d
    8000267e:	9fb9                	addw	a5,a5,a4
    80002680:	4037d79b          	sraiw	a5,a5,0x3
    80002684:	00f90633          	add	a2,s2,a5
    80002688:	05864603          	lbu	a2,88(a2)
    8000268c:	00c6f5b3          	and	a1,a3,a2
    80002690:	d585                	beqz	a1,800025b8 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002692:	2705                	addiw	a4,a4,1
    80002694:	2485                	addiw	s1,s1,1
    80002696:	fd471ae3          	bne	a4,s4,8000266a <balloc+0xec>
    8000269a:	b769                	j	80002624 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000269c:	00006517          	auipc	a0,0x6
    800026a0:	e3450513          	addi	a0,a0,-460 # 800084d0 <syscalls+0x100>
    800026a4:	00003097          	auipc	ra,0x3
    800026a8:	4cc080e7          	jalr	1228(ra) # 80005b70 <printf>
  return 0;
    800026ac:	4481                	li	s1,0
    800026ae:	bfa9                	j	80002608 <balloc+0x8a>

00000000800026b0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026b0:	7179                	addi	sp,sp,-48
    800026b2:	f406                	sd	ra,40(sp)
    800026b4:	f022                	sd	s0,32(sp)
    800026b6:	ec26                	sd	s1,24(sp)
    800026b8:	e84a                	sd	s2,16(sp)
    800026ba:	e44e                	sd	s3,8(sp)
    800026bc:	e052                	sd	s4,0(sp)
    800026be:	1800                	addi	s0,sp,48
    800026c0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026c2:	47ad                	li	a5,11
    800026c4:	02b7e863          	bltu	a5,a1,800026f4 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800026c8:	02059793          	slli	a5,a1,0x20
    800026cc:	01e7d593          	srli	a1,a5,0x1e
    800026d0:	00b504b3          	add	s1,a0,a1
    800026d4:	0504a903          	lw	s2,80(s1)
    800026d8:	06091e63          	bnez	s2,80002754 <bmap+0xa4>
      addr = balloc(ip->dev);
    800026dc:	4108                	lw	a0,0(a0)
    800026de:	00000097          	auipc	ra,0x0
    800026e2:	ea0080e7          	jalr	-352(ra) # 8000257e <balloc>
    800026e6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800026ea:	06090563          	beqz	s2,80002754 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800026ee:	0524a823          	sw	s2,80(s1)
    800026f2:	a08d                	j	80002754 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800026f4:	ff45849b          	addiw	s1,a1,-12
    800026f8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026fc:	0ff00793          	li	a5,255
    80002700:	08e7e563          	bltu	a5,a4,8000278a <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002704:	08052903          	lw	s2,128(a0)
    80002708:	00091d63          	bnez	s2,80002722 <bmap+0x72>
      addr = balloc(ip->dev);
    8000270c:	4108                	lw	a0,0(a0)
    8000270e:	00000097          	auipc	ra,0x0
    80002712:	e70080e7          	jalr	-400(ra) # 8000257e <balloc>
    80002716:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000271a:	02090d63          	beqz	s2,80002754 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000271e:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002722:	85ca                	mv	a1,s2
    80002724:	0009a503          	lw	a0,0(s3)
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	b96080e7          	jalr	-1130(ra) # 800022be <bread>
    80002730:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002732:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002736:	02049713          	slli	a4,s1,0x20
    8000273a:	01e75593          	srli	a1,a4,0x1e
    8000273e:	00b784b3          	add	s1,a5,a1
    80002742:	0004a903          	lw	s2,0(s1)
    80002746:	02090063          	beqz	s2,80002766 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000274a:	8552                	mv	a0,s4
    8000274c:	00000097          	auipc	ra,0x0
    80002750:	ca2080e7          	jalr	-862(ra) # 800023ee <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002754:	854a                	mv	a0,s2
    80002756:	70a2                	ld	ra,40(sp)
    80002758:	7402                	ld	s0,32(sp)
    8000275a:	64e2                	ld	s1,24(sp)
    8000275c:	6942                	ld	s2,16(sp)
    8000275e:	69a2                	ld	s3,8(sp)
    80002760:	6a02                	ld	s4,0(sp)
    80002762:	6145                	addi	sp,sp,48
    80002764:	8082                	ret
      addr = balloc(ip->dev);
    80002766:	0009a503          	lw	a0,0(s3)
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	e14080e7          	jalr	-492(ra) # 8000257e <balloc>
    80002772:	0005091b          	sext.w	s2,a0
      if(addr){
    80002776:	fc090ae3          	beqz	s2,8000274a <bmap+0x9a>
        a[bn] = addr;
    8000277a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000277e:	8552                	mv	a0,s4
    80002780:	00001097          	auipc	ra,0x1
    80002784:	ec6080e7          	jalr	-314(ra) # 80003646 <log_write>
    80002788:	b7c9                	j	8000274a <bmap+0x9a>
  panic("bmap: out of range");
    8000278a:	00006517          	auipc	a0,0x6
    8000278e:	d5e50513          	addi	a0,a0,-674 # 800084e8 <syscalls+0x118>
    80002792:	00003097          	auipc	ra,0x3
    80002796:	394080e7          	jalr	916(ra) # 80005b26 <panic>

000000008000279a <iget>:
{
    8000279a:	7179                	addi	sp,sp,-48
    8000279c:	f406                	sd	ra,40(sp)
    8000279e:	f022                	sd	s0,32(sp)
    800027a0:	ec26                	sd	s1,24(sp)
    800027a2:	e84a                	sd	s2,16(sp)
    800027a4:	e44e                	sd	s3,8(sp)
    800027a6:	e052                	sd	s4,0(sp)
    800027a8:	1800                	addi	s0,sp,48
    800027aa:	89aa                	mv	s3,a0
    800027ac:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027ae:	00014517          	auipc	a0,0x14
    800027b2:	67a50513          	addi	a0,a0,1658 # 80016e28 <itable>
    800027b6:	00004097          	auipc	ra,0x4
    800027ba:	8a8080e7          	jalr	-1880(ra) # 8000605e <acquire>
  empty = 0;
    800027be:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027c0:	00014497          	auipc	s1,0x14
    800027c4:	68048493          	addi	s1,s1,1664 # 80016e40 <itable+0x18>
    800027c8:	00016697          	auipc	a3,0x16
    800027cc:	10868693          	addi	a3,a3,264 # 800188d0 <log>
    800027d0:	a039                	j	800027de <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027d2:	02090b63          	beqz	s2,80002808 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027d6:	08848493          	addi	s1,s1,136
    800027da:	02d48a63          	beq	s1,a3,8000280e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027de:	449c                	lw	a5,8(s1)
    800027e0:	fef059e3          	blez	a5,800027d2 <iget+0x38>
    800027e4:	4098                	lw	a4,0(s1)
    800027e6:	ff3716e3          	bne	a4,s3,800027d2 <iget+0x38>
    800027ea:	40d8                	lw	a4,4(s1)
    800027ec:	ff4713e3          	bne	a4,s4,800027d2 <iget+0x38>
      ip->ref++;
    800027f0:	2785                	addiw	a5,a5,1
    800027f2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800027f4:	00014517          	auipc	a0,0x14
    800027f8:	63450513          	addi	a0,a0,1588 # 80016e28 <itable>
    800027fc:	00004097          	auipc	ra,0x4
    80002800:	916080e7          	jalr	-1770(ra) # 80006112 <release>
      return ip;
    80002804:	8926                	mv	s2,s1
    80002806:	a03d                	j	80002834 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002808:	f7f9                	bnez	a5,800027d6 <iget+0x3c>
    8000280a:	8926                	mv	s2,s1
    8000280c:	b7e9                	j	800027d6 <iget+0x3c>
  if(empty == 0)
    8000280e:	02090c63          	beqz	s2,80002846 <iget+0xac>
  ip->dev = dev;
    80002812:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002816:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000281a:	4785                	li	a5,1
    8000281c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002820:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002824:	00014517          	auipc	a0,0x14
    80002828:	60450513          	addi	a0,a0,1540 # 80016e28 <itable>
    8000282c:	00004097          	auipc	ra,0x4
    80002830:	8e6080e7          	jalr	-1818(ra) # 80006112 <release>
}
    80002834:	854a                	mv	a0,s2
    80002836:	70a2                	ld	ra,40(sp)
    80002838:	7402                	ld	s0,32(sp)
    8000283a:	64e2                	ld	s1,24(sp)
    8000283c:	6942                	ld	s2,16(sp)
    8000283e:	69a2                	ld	s3,8(sp)
    80002840:	6a02                	ld	s4,0(sp)
    80002842:	6145                	addi	sp,sp,48
    80002844:	8082                	ret
    panic("iget: no inodes");
    80002846:	00006517          	auipc	a0,0x6
    8000284a:	cba50513          	addi	a0,a0,-838 # 80008500 <syscalls+0x130>
    8000284e:	00003097          	auipc	ra,0x3
    80002852:	2d8080e7          	jalr	728(ra) # 80005b26 <panic>

0000000080002856 <fsinit>:
fsinit(int dev) {
    80002856:	7179                	addi	sp,sp,-48
    80002858:	f406                	sd	ra,40(sp)
    8000285a:	f022                	sd	s0,32(sp)
    8000285c:	ec26                	sd	s1,24(sp)
    8000285e:	e84a                	sd	s2,16(sp)
    80002860:	e44e                	sd	s3,8(sp)
    80002862:	1800                	addi	s0,sp,48
    80002864:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002866:	4585                	li	a1,1
    80002868:	00000097          	auipc	ra,0x0
    8000286c:	a56080e7          	jalr	-1450(ra) # 800022be <bread>
    80002870:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002872:	00014997          	auipc	s3,0x14
    80002876:	59698993          	addi	s3,s3,1430 # 80016e08 <sb>
    8000287a:	02000613          	li	a2,32
    8000287e:	05850593          	addi	a1,a0,88
    80002882:	854e                	mv	a0,s3
    80002884:	ffffe097          	auipc	ra,0xffffe
    80002888:	952080e7          	jalr	-1710(ra) # 800001d6 <memmove>
  brelse(bp);
    8000288c:	8526                	mv	a0,s1
    8000288e:	00000097          	auipc	ra,0x0
    80002892:	b60080e7          	jalr	-1184(ra) # 800023ee <brelse>
  if(sb.magic != FSMAGIC)
    80002896:	0009a703          	lw	a4,0(s3)
    8000289a:	102037b7          	lui	a5,0x10203
    8000289e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028a2:	02f71263          	bne	a4,a5,800028c6 <fsinit+0x70>
  initlog(dev, &sb);
    800028a6:	00014597          	auipc	a1,0x14
    800028aa:	56258593          	addi	a1,a1,1378 # 80016e08 <sb>
    800028ae:	854a                	mv	a0,s2
    800028b0:	00001097          	auipc	ra,0x1
    800028b4:	b2c080e7          	jalr	-1236(ra) # 800033dc <initlog>
}
    800028b8:	70a2                	ld	ra,40(sp)
    800028ba:	7402                	ld	s0,32(sp)
    800028bc:	64e2                	ld	s1,24(sp)
    800028be:	6942                	ld	s2,16(sp)
    800028c0:	69a2                	ld	s3,8(sp)
    800028c2:	6145                	addi	sp,sp,48
    800028c4:	8082                	ret
    panic("invalid file system");
    800028c6:	00006517          	auipc	a0,0x6
    800028ca:	c4a50513          	addi	a0,a0,-950 # 80008510 <syscalls+0x140>
    800028ce:	00003097          	auipc	ra,0x3
    800028d2:	258080e7          	jalr	600(ra) # 80005b26 <panic>

00000000800028d6 <iinit>:
{
    800028d6:	7179                	addi	sp,sp,-48
    800028d8:	f406                	sd	ra,40(sp)
    800028da:	f022                	sd	s0,32(sp)
    800028dc:	ec26                	sd	s1,24(sp)
    800028de:	e84a                	sd	s2,16(sp)
    800028e0:	e44e                	sd	s3,8(sp)
    800028e2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028e4:	00006597          	auipc	a1,0x6
    800028e8:	c4458593          	addi	a1,a1,-956 # 80008528 <syscalls+0x158>
    800028ec:	00014517          	auipc	a0,0x14
    800028f0:	53c50513          	addi	a0,a0,1340 # 80016e28 <itable>
    800028f4:	00003097          	auipc	ra,0x3
    800028f8:	6da080e7          	jalr	1754(ra) # 80005fce <initlock>
  for(i = 0; i < NINODE; i++) {
    800028fc:	00014497          	auipc	s1,0x14
    80002900:	55448493          	addi	s1,s1,1364 # 80016e50 <itable+0x28>
    80002904:	00016997          	auipc	s3,0x16
    80002908:	fdc98993          	addi	s3,s3,-36 # 800188e0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000290c:	00006917          	auipc	s2,0x6
    80002910:	c2490913          	addi	s2,s2,-988 # 80008530 <syscalls+0x160>
    80002914:	85ca                	mv	a1,s2
    80002916:	8526                	mv	a0,s1
    80002918:	00001097          	auipc	ra,0x1
    8000291c:	e12080e7          	jalr	-494(ra) # 8000372a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002920:	08848493          	addi	s1,s1,136
    80002924:	ff3498e3          	bne	s1,s3,80002914 <iinit+0x3e>
}
    80002928:	70a2                	ld	ra,40(sp)
    8000292a:	7402                	ld	s0,32(sp)
    8000292c:	64e2                	ld	s1,24(sp)
    8000292e:	6942                	ld	s2,16(sp)
    80002930:	69a2                	ld	s3,8(sp)
    80002932:	6145                	addi	sp,sp,48
    80002934:	8082                	ret

0000000080002936 <ialloc>:
{
    80002936:	7139                	addi	sp,sp,-64
    80002938:	fc06                	sd	ra,56(sp)
    8000293a:	f822                	sd	s0,48(sp)
    8000293c:	f426                	sd	s1,40(sp)
    8000293e:	f04a                	sd	s2,32(sp)
    80002940:	ec4e                	sd	s3,24(sp)
    80002942:	e852                	sd	s4,16(sp)
    80002944:	e456                	sd	s5,8(sp)
    80002946:	e05a                	sd	s6,0(sp)
    80002948:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000294a:	00014717          	auipc	a4,0x14
    8000294e:	4ca72703          	lw	a4,1226(a4) # 80016e14 <sb+0xc>
    80002952:	4785                	li	a5,1
    80002954:	04e7f863          	bgeu	a5,a4,800029a4 <ialloc+0x6e>
    80002958:	8aaa                	mv	s5,a0
    8000295a:	8b2e                	mv	s6,a1
    8000295c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000295e:	00014a17          	auipc	s4,0x14
    80002962:	4aaa0a13          	addi	s4,s4,1194 # 80016e08 <sb>
    80002966:	00495593          	srli	a1,s2,0x4
    8000296a:	018a2783          	lw	a5,24(s4)
    8000296e:	9dbd                	addw	a1,a1,a5
    80002970:	8556                	mv	a0,s5
    80002972:	00000097          	auipc	ra,0x0
    80002976:	94c080e7          	jalr	-1716(ra) # 800022be <bread>
    8000297a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000297c:	05850993          	addi	s3,a0,88
    80002980:	00f97793          	andi	a5,s2,15
    80002984:	079a                	slli	a5,a5,0x6
    80002986:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002988:	00099783          	lh	a5,0(s3)
    8000298c:	cf9d                	beqz	a5,800029ca <ialloc+0x94>
    brelse(bp);
    8000298e:	00000097          	auipc	ra,0x0
    80002992:	a60080e7          	jalr	-1440(ra) # 800023ee <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002996:	0905                	addi	s2,s2,1
    80002998:	00ca2703          	lw	a4,12(s4)
    8000299c:	0009079b          	sext.w	a5,s2
    800029a0:	fce7e3e3          	bltu	a5,a4,80002966 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    800029a4:	00006517          	auipc	a0,0x6
    800029a8:	b9450513          	addi	a0,a0,-1132 # 80008538 <syscalls+0x168>
    800029ac:	00003097          	auipc	ra,0x3
    800029b0:	1c4080e7          	jalr	452(ra) # 80005b70 <printf>
  return 0;
    800029b4:	4501                	li	a0,0
}
    800029b6:	70e2                	ld	ra,56(sp)
    800029b8:	7442                	ld	s0,48(sp)
    800029ba:	74a2                	ld	s1,40(sp)
    800029bc:	7902                	ld	s2,32(sp)
    800029be:	69e2                	ld	s3,24(sp)
    800029c0:	6a42                	ld	s4,16(sp)
    800029c2:	6aa2                	ld	s5,8(sp)
    800029c4:	6b02                	ld	s6,0(sp)
    800029c6:	6121                	addi	sp,sp,64
    800029c8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029ca:	04000613          	li	a2,64
    800029ce:	4581                	li	a1,0
    800029d0:	854e                	mv	a0,s3
    800029d2:	ffffd097          	auipc	ra,0xffffd
    800029d6:	7a8080e7          	jalr	1960(ra) # 8000017a <memset>
      dip->type = type;
    800029da:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029de:	8526                	mv	a0,s1
    800029e0:	00001097          	auipc	ra,0x1
    800029e4:	c66080e7          	jalr	-922(ra) # 80003646 <log_write>
      brelse(bp);
    800029e8:	8526                	mv	a0,s1
    800029ea:	00000097          	auipc	ra,0x0
    800029ee:	a04080e7          	jalr	-1532(ra) # 800023ee <brelse>
      return iget(dev, inum);
    800029f2:	0009059b          	sext.w	a1,s2
    800029f6:	8556                	mv	a0,s5
    800029f8:	00000097          	auipc	ra,0x0
    800029fc:	da2080e7          	jalr	-606(ra) # 8000279a <iget>
    80002a00:	bf5d                	j	800029b6 <ialloc+0x80>

0000000080002a02 <iupdate>:
{
    80002a02:	1101                	addi	sp,sp,-32
    80002a04:	ec06                	sd	ra,24(sp)
    80002a06:	e822                	sd	s0,16(sp)
    80002a08:	e426                	sd	s1,8(sp)
    80002a0a:	e04a                	sd	s2,0(sp)
    80002a0c:	1000                	addi	s0,sp,32
    80002a0e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a10:	415c                	lw	a5,4(a0)
    80002a12:	0047d79b          	srliw	a5,a5,0x4
    80002a16:	00014597          	auipc	a1,0x14
    80002a1a:	40a5a583          	lw	a1,1034(a1) # 80016e20 <sb+0x18>
    80002a1e:	9dbd                	addw	a1,a1,a5
    80002a20:	4108                	lw	a0,0(a0)
    80002a22:	00000097          	auipc	ra,0x0
    80002a26:	89c080e7          	jalr	-1892(ra) # 800022be <bread>
    80002a2a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a2c:	05850793          	addi	a5,a0,88
    80002a30:	40d8                	lw	a4,4(s1)
    80002a32:	8b3d                	andi	a4,a4,15
    80002a34:	071a                	slli	a4,a4,0x6
    80002a36:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a38:	04449703          	lh	a4,68(s1)
    80002a3c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a40:	04649703          	lh	a4,70(s1)
    80002a44:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a48:	04849703          	lh	a4,72(s1)
    80002a4c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a50:	04a49703          	lh	a4,74(s1)
    80002a54:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a58:	44f8                	lw	a4,76(s1)
    80002a5a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a5c:	03400613          	li	a2,52
    80002a60:	05048593          	addi	a1,s1,80
    80002a64:	00c78513          	addi	a0,a5,12
    80002a68:	ffffd097          	auipc	ra,0xffffd
    80002a6c:	76e080e7          	jalr	1902(ra) # 800001d6 <memmove>
  log_write(bp);
    80002a70:	854a                	mv	a0,s2
    80002a72:	00001097          	auipc	ra,0x1
    80002a76:	bd4080e7          	jalr	-1068(ra) # 80003646 <log_write>
  brelse(bp);
    80002a7a:	854a                	mv	a0,s2
    80002a7c:	00000097          	auipc	ra,0x0
    80002a80:	972080e7          	jalr	-1678(ra) # 800023ee <brelse>
}
    80002a84:	60e2                	ld	ra,24(sp)
    80002a86:	6442                	ld	s0,16(sp)
    80002a88:	64a2                	ld	s1,8(sp)
    80002a8a:	6902                	ld	s2,0(sp)
    80002a8c:	6105                	addi	sp,sp,32
    80002a8e:	8082                	ret

0000000080002a90 <idup>:
{
    80002a90:	1101                	addi	sp,sp,-32
    80002a92:	ec06                	sd	ra,24(sp)
    80002a94:	e822                	sd	s0,16(sp)
    80002a96:	e426                	sd	s1,8(sp)
    80002a98:	1000                	addi	s0,sp,32
    80002a9a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a9c:	00014517          	auipc	a0,0x14
    80002aa0:	38c50513          	addi	a0,a0,908 # 80016e28 <itable>
    80002aa4:	00003097          	auipc	ra,0x3
    80002aa8:	5ba080e7          	jalr	1466(ra) # 8000605e <acquire>
  ip->ref++;
    80002aac:	449c                	lw	a5,8(s1)
    80002aae:	2785                	addiw	a5,a5,1
    80002ab0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ab2:	00014517          	auipc	a0,0x14
    80002ab6:	37650513          	addi	a0,a0,886 # 80016e28 <itable>
    80002aba:	00003097          	auipc	ra,0x3
    80002abe:	658080e7          	jalr	1624(ra) # 80006112 <release>
}
    80002ac2:	8526                	mv	a0,s1
    80002ac4:	60e2                	ld	ra,24(sp)
    80002ac6:	6442                	ld	s0,16(sp)
    80002ac8:	64a2                	ld	s1,8(sp)
    80002aca:	6105                	addi	sp,sp,32
    80002acc:	8082                	ret

0000000080002ace <ilock>:
{
    80002ace:	1101                	addi	sp,sp,-32
    80002ad0:	ec06                	sd	ra,24(sp)
    80002ad2:	e822                	sd	s0,16(sp)
    80002ad4:	e426                	sd	s1,8(sp)
    80002ad6:	e04a                	sd	s2,0(sp)
    80002ad8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ada:	c115                	beqz	a0,80002afe <ilock+0x30>
    80002adc:	84aa                	mv	s1,a0
    80002ade:	451c                	lw	a5,8(a0)
    80002ae0:	00f05f63          	blez	a5,80002afe <ilock+0x30>
  acquiresleep(&ip->lock);
    80002ae4:	0541                	addi	a0,a0,16
    80002ae6:	00001097          	auipc	ra,0x1
    80002aea:	c7e080e7          	jalr	-898(ra) # 80003764 <acquiresleep>
  if(ip->valid == 0){
    80002aee:	40bc                	lw	a5,64(s1)
    80002af0:	cf99                	beqz	a5,80002b0e <ilock+0x40>
}
    80002af2:	60e2                	ld	ra,24(sp)
    80002af4:	6442                	ld	s0,16(sp)
    80002af6:	64a2                	ld	s1,8(sp)
    80002af8:	6902                	ld	s2,0(sp)
    80002afa:	6105                	addi	sp,sp,32
    80002afc:	8082                	ret
    panic("ilock");
    80002afe:	00006517          	auipc	a0,0x6
    80002b02:	a5250513          	addi	a0,a0,-1454 # 80008550 <syscalls+0x180>
    80002b06:	00003097          	auipc	ra,0x3
    80002b0a:	020080e7          	jalr	32(ra) # 80005b26 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b0e:	40dc                	lw	a5,4(s1)
    80002b10:	0047d79b          	srliw	a5,a5,0x4
    80002b14:	00014597          	auipc	a1,0x14
    80002b18:	30c5a583          	lw	a1,780(a1) # 80016e20 <sb+0x18>
    80002b1c:	9dbd                	addw	a1,a1,a5
    80002b1e:	4088                	lw	a0,0(s1)
    80002b20:	fffff097          	auipc	ra,0xfffff
    80002b24:	79e080e7          	jalr	1950(ra) # 800022be <bread>
    80002b28:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b2a:	05850593          	addi	a1,a0,88
    80002b2e:	40dc                	lw	a5,4(s1)
    80002b30:	8bbd                	andi	a5,a5,15
    80002b32:	079a                	slli	a5,a5,0x6
    80002b34:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b36:	00059783          	lh	a5,0(a1)
    80002b3a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b3e:	00259783          	lh	a5,2(a1)
    80002b42:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b46:	00459783          	lh	a5,4(a1)
    80002b4a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b4e:	00659783          	lh	a5,6(a1)
    80002b52:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b56:	459c                	lw	a5,8(a1)
    80002b58:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b5a:	03400613          	li	a2,52
    80002b5e:	05b1                	addi	a1,a1,12
    80002b60:	05048513          	addi	a0,s1,80
    80002b64:	ffffd097          	auipc	ra,0xffffd
    80002b68:	672080e7          	jalr	1650(ra) # 800001d6 <memmove>
    brelse(bp);
    80002b6c:	854a                	mv	a0,s2
    80002b6e:	00000097          	auipc	ra,0x0
    80002b72:	880080e7          	jalr	-1920(ra) # 800023ee <brelse>
    ip->valid = 1;
    80002b76:	4785                	li	a5,1
    80002b78:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b7a:	04449783          	lh	a5,68(s1)
    80002b7e:	fbb5                	bnez	a5,80002af2 <ilock+0x24>
      panic("ilock: no type");
    80002b80:	00006517          	auipc	a0,0x6
    80002b84:	9d850513          	addi	a0,a0,-1576 # 80008558 <syscalls+0x188>
    80002b88:	00003097          	auipc	ra,0x3
    80002b8c:	f9e080e7          	jalr	-98(ra) # 80005b26 <panic>

0000000080002b90 <iunlock>:
{
    80002b90:	1101                	addi	sp,sp,-32
    80002b92:	ec06                	sd	ra,24(sp)
    80002b94:	e822                	sd	s0,16(sp)
    80002b96:	e426                	sd	s1,8(sp)
    80002b98:	e04a                	sd	s2,0(sp)
    80002b9a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002b9c:	c905                	beqz	a0,80002bcc <iunlock+0x3c>
    80002b9e:	84aa                	mv	s1,a0
    80002ba0:	01050913          	addi	s2,a0,16
    80002ba4:	854a                	mv	a0,s2
    80002ba6:	00001097          	auipc	ra,0x1
    80002baa:	c58080e7          	jalr	-936(ra) # 800037fe <holdingsleep>
    80002bae:	cd19                	beqz	a0,80002bcc <iunlock+0x3c>
    80002bb0:	449c                	lw	a5,8(s1)
    80002bb2:	00f05d63          	blez	a5,80002bcc <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bb6:	854a                	mv	a0,s2
    80002bb8:	00001097          	auipc	ra,0x1
    80002bbc:	c02080e7          	jalr	-1022(ra) # 800037ba <releasesleep>
}
    80002bc0:	60e2                	ld	ra,24(sp)
    80002bc2:	6442                	ld	s0,16(sp)
    80002bc4:	64a2                	ld	s1,8(sp)
    80002bc6:	6902                	ld	s2,0(sp)
    80002bc8:	6105                	addi	sp,sp,32
    80002bca:	8082                	ret
    panic("iunlock");
    80002bcc:	00006517          	auipc	a0,0x6
    80002bd0:	99c50513          	addi	a0,a0,-1636 # 80008568 <syscalls+0x198>
    80002bd4:	00003097          	auipc	ra,0x3
    80002bd8:	f52080e7          	jalr	-174(ra) # 80005b26 <panic>

0000000080002bdc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bdc:	7179                	addi	sp,sp,-48
    80002bde:	f406                	sd	ra,40(sp)
    80002be0:	f022                	sd	s0,32(sp)
    80002be2:	ec26                	sd	s1,24(sp)
    80002be4:	e84a                	sd	s2,16(sp)
    80002be6:	e44e                	sd	s3,8(sp)
    80002be8:	e052                	sd	s4,0(sp)
    80002bea:	1800                	addi	s0,sp,48
    80002bec:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002bee:	05050493          	addi	s1,a0,80
    80002bf2:	08050913          	addi	s2,a0,128
    80002bf6:	a021                	j	80002bfe <itrunc+0x22>
    80002bf8:	0491                	addi	s1,s1,4
    80002bfa:	01248d63          	beq	s1,s2,80002c14 <itrunc+0x38>
    if(ip->addrs[i]){
    80002bfe:	408c                	lw	a1,0(s1)
    80002c00:	dde5                	beqz	a1,80002bf8 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c02:	0009a503          	lw	a0,0(s3)
    80002c06:	00000097          	auipc	ra,0x0
    80002c0a:	8fc080e7          	jalr	-1796(ra) # 80002502 <bfree>
      ip->addrs[i] = 0;
    80002c0e:	0004a023          	sw	zero,0(s1)
    80002c12:	b7dd                	j	80002bf8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c14:	0809a583          	lw	a1,128(s3)
    80002c18:	e185                	bnez	a1,80002c38 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c1a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c1e:	854e                	mv	a0,s3
    80002c20:	00000097          	auipc	ra,0x0
    80002c24:	de2080e7          	jalr	-542(ra) # 80002a02 <iupdate>
}
    80002c28:	70a2                	ld	ra,40(sp)
    80002c2a:	7402                	ld	s0,32(sp)
    80002c2c:	64e2                	ld	s1,24(sp)
    80002c2e:	6942                	ld	s2,16(sp)
    80002c30:	69a2                	ld	s3,8(sp)
    80002c32:	6a02                	ld	s4,0(sp)
    80002c34:	6145                	addi	sp,sp,48
    80002c36:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c38:	0009a503          	lw	a0,0(s3)
    80002c3c:	fffff097          	auipc	ra,0xfffff
    80002c40:	682080e7          	jalr	1666(ra) # 800022be <bread>
    80002c44:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c46:	05850493          	addi	s1,a0,88
    80002c4a:	45850913          	addi	s2,a0,1112
    80002c4e:	a021                	j	80002c56 <itrunc+0x7a>
    80002c50:	0491                	addi	s1,s1,4
    80002c52:	01248b63          	beq	s1,s2,80002c68 <itrunc+0x8c>
      if(a[j])
    80002c56:	408c                	lw	a1,0(s1)
    80002c58:	dde5                	beqz	a1,80002c50 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c5a:	0009a503          	lw	a0,0(s3)
    80002c5e:	00000097          	auipc	ra,0x0
    80002c62:	8a4080e7          	jalr	-1884(ra) # 80002502 <bfree>
    80002c66:	b7ed                	j	80002c50 <itrunc+0x74>
    brelse(bp);
    80002c68:	8552                	mv	a0,s4
    80002c6a:	fffff097          	auipc	ra,0xfffff
    80002c6e:	784080e7          	jalr	1924(ra) # 800023ee <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c72:	0809a583          	lw	a1,128(s3)
    80002c76:	0009a503          	lw	a0,0(s3)
    80002c7a:	00000097          	auipc	ra,0x0
    80002c7e:	888080e7          	jalr	-1912(ra) # 80002502 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c82:	0809a023          	sw	zero,128(s3)
    80002c86:	bf51                	j	80002c1a <itrunc+0x3e>

0000000080002c88 <iput>:
{
    80002c88:	1101                	addi	sp,sp,-32
    80002c8a:	ec06                	sd	ra,24(sp)
    80002c8c:	e822                	sd	s0,16(sp)
    80002c8e:	e426                	sd	s1,8(sp)
    80002c90:	e04a                	sd	s2,0(sp)
    80002c92:	1000                	addi	s0,sp,32
    80002c94:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c96:	00014517          	auipc	a0,0x14
    80002c9a:	19250513          	addi	a0,a0,402 # 80016e28 <itable>
    80002c9e:	00003097          	auipc	ra,0x3
    80002ca2:	3c0080e7          	jalr	960(ra) # 8000605e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ca6:	4498                	lw	a4,8(s1)
    80002ca8:	4785                	li	a5,1
    80002caa:	02f70363          	beq	a4,a5,80002cd0 <iput+0x48>
  ip->ref--;
    80002cae:	449c                	lw	a5,8(s1)
    80002cb0:	37fd                	addiw	a5,a5,-1
    80002cb2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cb4:	00014517          	auipc	a0,0x14
    80002cb8:	17450513          	addi	a0,a0,372 # 80016e28 <itable>
    80002cbc:	00003097          	auipc	ra,0x3
    80002cc0:	456080e7          	jalr	1110(ra) # 80006112 <release>
}
    80002cc4:	60e2                	ld	ra,24(sp)
    80002cc6:	6442                	ld	s0,16(sp)
    80002cc8:	64a2                	ld	s1,8(sp)
    80002cca:	6902                	ld	s2,0(sp)
    80002ccc:	6105                	addi	sp,sp,32
    80002cce:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cd0:	40bc                	lw	a5,64(s1)
    80002cd2:	dff1                	beqz	a5,80002cae <iput+0x26>
    80002cd4:	04a49783          	lh	a5,74(s1)
    80002cd8:	fbf9                	bnez	a5,80002cae <iput+0x26>
    acquiresleep(&ip->lock);
    80002cda:	01048913          	addi	s2,s1,16
    80002cde:	854a                	mv	a0,s2
    80002ce0:	00001097          	auipc	ra,0x1
    80002ce4:	a84080e7          	jalr	-1404(ra) # 80003764 <acquiresleep>
    release(&itable.lock);
    80002ce8:	00014517          	auipc	a0,0x14
    80002cec:	14050513          	addi	a0,a0,320 # 80016e28 <itable>
    80002cf0:	00003097          	auipc	ra,0x3
    80002cf4:	422080e7          	jalr	1058(ra) # 80006112 <release>
    itrunc(ip);
    80002cf8:	8526                	mv	a0,s1
    80002cfa:	00000097          	auipc	ra,0x0
    80002cfe:	ee2080e7          	jalr	-286(ra) # 80002bdc <itrunc>
    ip->type = 0;
    80002d02:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d06:	8526                	mv	a0,s1
    80002d08:	00000097          	auipc	ra,0x0
    80002d0c:	cfa080e7          	jalr	-774(ra) # 80002a02 <iupdate>
    ip->valid = 0;
    80002d10:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d14:	854a                	mv	a0,s2
    80002d16:	00001097          	auipc	ra,0x1
    80002d1a:	aa4080e7          	jalr	-1372(ra) # 800037ba <releasesleep>
    acquire(&itable.lock);
    80002d1e:	00014517          	auipc	a0,0x14
    80002d22:	10a50513          	addi	a0,a0,266 # 80016e28 <itable>
    80002d26:	00003097          	auipc	ra,0x3
    80002d2a:	338080e7          	jalr	824(ra) # 8000605e <acquire>
    80002d2e:	b741                	j	80002cae <iput+0x26>

0000000080002d30 <iunlockput>:
{
    80002d30:	1101                	addi	sp,sp,-32
    80002d32:	ec06                	sd	ra,24(sp)
    80002d34:	e822                	sd	s0,16(sp)
    80002d36:	e426                	sd	s1,8(sp)
    80002d38:	1000                	addi	s0,sp,32
    80002d3a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d3c:	00000097          	auipc	ra,0x0
    80002d40:	e54080e7          	jalr	-428(ra) # 80002b90 <iunlock>
  iput(ip);
    80002d44:	8526                	mv	a0,s1
    80002d46:	00000097          	auipc	ra,0x0
    80002d4a:	f42080e7          	jalr	-190(ra) # 80002c88 <iput>
}
    80002d4e:	60e2                	ld	ra,24(sp)
    80002d50:	6442                	ld	s0,16(sp)
    80002d52:	64a2                	ld	s1,8(sp)
    80002d54:	6105                	addi	sp,sp,32
    80002d56:	8082                	ret

0000000080002d58 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d58:	1141                	addi	sp,sp,-16
    80002d5a:	e422                	sd	s0,8(sp)
    80002d5c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d5e:	411c                	lw	a5,0(a0)
    80002d60:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d62:	415c                	lw	a5,4(a0)
    80002d64:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d66:	04451783          	lh	a5,68(a0)
    80002d6a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d6e:	04a51783          	lh	a5,74(a0)
    80002d72:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d76:	04c56783          	lwu	a5,76(a0)
    80002d7a:	e99c                	sd	a5,16(a1)
}
    80002d7c:	6422                	ld	s0,8(sp)
    80002d7e:	0141                	addi	sp,sp,16
    80002d80:	8082                	ret

0000000080002d82 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d82:	457c                	lw	a5,76(a0)
    80002d84:	0ed7e963          	bltu	a5,a3,80002e76 <readi+0xf4>
{
    80002d88:	7159                	addi	sp,sp,-112
    80002d8a:	f486                	sd	ra,104(sp)
    80002d8c:	f0a2                	sd	s0,96(sp)
    80002d8e:	eca6                	sd	s1,88(sp)
    80002d90:	e8ca                	sd	s2,80(sp)
    80002d92:	e4ce                	sd	s3,72(sp)
    80002d94:	e0d2                	sd	s4,64(sp)
    80002d96:	fc56                	sd	s5,56(sp)
    80002d98:	f85a                	sd	s6,48(sp)
    80002d9a:	f45e                	sd	s7,40(sp)
    80002d9c:	f062                	sd	s8,32(sp)
    80002d9e:	ec66                	sd	s9,24(sp)
    80002da0:	e86a                	sd	s10,16(sp)
    80002da2:	e46e                	sd	s11,8(sp)
    80002da4:	1880                	addi	s0,sp,112
    80002da6:	8b2a                	mv	s6,a0
    80002da8:	8bae                	mv	s7,a1
    80002daa:	8a32                	mv	s4,a2
    80002dac:	84b6                	mv	s1,a3
    80002dae:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002db0:	9f35                	addw	a4,a4,a3
    return 0;
    80002db2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002db4:	0ad76063          	bltu	a4,a3,80002e54 <readi+0xd2>
  if(off + n > ip->size)
    80002db8:	00e7f463          	bgeu	a5,a4,80002dc0 <readi+0x3e>
    n = ip->size - off;
    80002dbc:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dc0:	0a0a8963          	beqz	s5,80002e72 <readi+0xf0>
    80002dc4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dc6:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dca:	5c7d                	li	s8,-1
    80002dcc:	a82d                	j	80002e06 <readi+0x84>
    80002dce:	020d1d93          	slli	s11,s10,0x20
    80002dd2:	020ddd93          	srli	s11,s11,0x20
    80002dd6:	05890613          	addi	a2,s2,88
    80002dda:	86ee                	mv	a3,s11
    80002ddc:	963a                	add	a2,a2,a4
    80002dde:	85d2                	mv	a1,s4
    80002de0:	855e                	mv	a0,s7
    80002de2:	fffff097          	auipc	ra,0xfffff
    80002de6:	b20080e7          	jalr	-1248(ra) # 80001902 <either_copyout>
    80002dea:	05850d63          	beq	a0,s8,80002e44 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002dee:	854a                	mv	a0,s2
    80002df0:	fffff097          	auipc	ra,0xfffff
    80002df4:	5fe080e7          	jalr	1534(ra) # 800023ee <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002df8:	013d09bb          	addw	s3,s10,s3
    80002dfc:	009d04bb          	addw	s1,s10,s1
    80002e00:	9a6e                	add	s4,s4,s11
    80002e02:	0559f763          	bgeu	s3,s5,80002e50 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e06:	00a4d59b          	srliw	a1,s1,0xa
    80002e0a:	855a                	mv	a0,s6
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	8a4080e7          	jalr	-1884(ra) # 800026b0 <bmap>
    80002e14:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e18:	cd85                	beqz	a1,80002e50 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e1a:	000b2503          	lw	a0,0(s6)
    80002e1e:	fffff097          	auipc	ra,0xfffff
    80002e22:	4a0080e7          	jalr	1184(ra) # 800022be <bread>
    80002e26:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e28:	3ff4f713          	andi	a4,s1,1023
    80002e2c:	40ec87bb          	subw	a5,s9,a4
    80002e30:	413a86bb          	subw	a3,s5,s3
    80002e34:	8d3e                	mv	s10,a5
    80002e36:	2781                	sext.w	a5,a5
    80002e38:	0006861b          	sext.w	a2,a3
    80002e3c:	f8f679e3          	bgeu	a2,a5,80002dce <readi+0x4c>
    80002e40:	8d36                	mv	s10,a3
    80002e42:	b771                	j	80002dce <readi+0x4c>
      brelse(bp);
    80002e44:	854a                	mv	a0,s2
    80002e46:	fffff097          	auipc	ra,0xfffff
    80002e4a:	5a8080e7          	jalr	1448(ra) # 800023ee <brelse>
      tot = -1;
    80002e4e:	59fd                	li	s3,-1
  }
  return tot;
    80002e50:	0009851b          	sext.w	a0,s3
}
    80002e54:	70a6                	ld	ra,104(sp)
    80002e56:	7406                	ld	s0,96(sp)
    80002e58:	64e6                	ld	s1,88(sp)
    80002e5a:	6946                	ld	s2,80(sp)
    80002e5c:	69a6                	ld	s3,72(sp)
    80002e5e:	6a06                	ld	s4,64(sp)
    80002e60:	7ae2                	ld	s5,56(sp)
    80002e62:	7b42                	ld	s6,48(sp)
    80002e64:	7ba2                	ld	s7,40(sp)
    80002e66:	7c02                	ld	s8,32(sp)
    80002e68:	6ce2                	ld	s9,24(sp)
    80002e6a:	6d42                	ld	s10,16(sp)
    80002e6c:	6da2                	ld	s11,8(sp)
    80002e6e:	6165                	addi	sp,sp,112
    80002e70:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e72:	89d6                	mv	s3,s5
    80002e74:	bff1                	j	80002e50 <readi+0xce>
    return 0;
    80002e76:	4501                	li	a0,0
}
    80002e78:	8082                	ret

0000000080002e7a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e7a:	457c                	lw	a5,76(a0)
    80002e7c:	10d7e863          	bltu	a5,a3,80002f8c <writei+0x112>
{
    80002e80:	7159                	addi	sp,sp,-112
    80002e82:	f486                	sd	ra,104(sp)
    80002e84:	f0a2                	sd	s0,96(sp)
    80002e86:	eca6                	sd	s1,88(sp)
    80002e88:	e8ca                	sd	s2,80(sp)
    80002e8a:	e4ce                	sd	s3,72(sp)
    80002e8c:	e0d2                	sd	s4,64(sp)
    80002e8e:	fc56                	sd	s5,56(sp)
    80002e90:	f85a                	sd	s6,48(sp)
    80002e92:	f45e                	sd	s7,40(sp)
    80002e94:	f062                	sd	s8,32(sp)
    80002e96:	ec66                	sd	s9,24(sp)
    80002e98:	e86a                	sd	s10,16(sp)
    80002e9a:	e46e                	sd	s11,8(sp)
    80002e9c:	1880                	addi	s0,sp,112
    80002e9e:	8aaa                	mv	s5,a0
    80002ea0:	8bae                	mv	s7,a1
    80002ea2:	8a32                	mv	s4,a2
    80002ea4:	8936                	mv	s2,a3
    80002ea6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ea8:	00e687bb          	addw	a5,a3,a4
    80002eac:	0ed7e263          	bltu	a5,a3,80002f90 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002eb0:	00043737          	lui	a4,0x43
    80002eb4:	0ef76063          	bltu	a4,a5,80002f94 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002eb8:	0c0b0863          	beqz	s6,80002f88 <writei+0x10e>
    80002ebc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ebe:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ec2:	5c7d                	li	s8,-1
    80002ec4:	a091                	j	80002f08 <writei+0x8e>
    80002ec6:	020d1d93          	slli	s11,s10,0x20
    80002eca:	020ddd93          	srli	s11,s11,0x20
    80002ece:	05848513          	addi	a0,s1,88
    80002ed2:	86ee                	mv	a3,s11
    80002ed4:	8652                	mv	a2,s4
    80002ed6:	85de                	mv	a1,s7
    80002ed8:	953a                	add	a0,a0,a4
    80002eda:	fffff097          	auipc	ra,0xfffff
    80002ede:	a7e080e7          	jalr	-1410(ra) # 80001958 <either_copyin>
    80002ee2:	07850263          	beq	a0,s8,80002f46 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ee6:	8526                	mv	a0,s1
    80002ee8:	00000097          	auipc	ra,0x0
    80002eec:	75e080e7          	jalr	1886(ra) # 80003646 <log_write>
    brelse(bp);
    80002ef0:	8526                	mv	a0,s1
    80002ef2:	fffff097          	auipc	ra,0xfffff
    80002ef6:	4fc080e7          	jalr	1276(ra) # 800023ee <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002efa:	013d09bb          	addw	s3,s10,s3
    80002efe:	012d093b          	addw	s2,s10,s2
    80002f02:	9a6e                	add	s4,s4,s11
    80002f04:	0569f663          	bgeu	s3,s6,80002f50 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f08:	00a9559b          	srliw	a1,s2,0xa
    80002f0c:	8556                	mv	a0,s5
    80002f0e:	fffff097          	auipc	ra,0xfffff
    80002f12:	7a2080e7          	jalr	1954(ra) # 800026b0 <bmap>
    80002f16:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f1a:	c99d                	beqz	a1,80002f50 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f1c:	000aa503          	lw	a0,0(s5)
    80002f20:	fffff097          	auipc	ra,0xfffff
    80002f24:	39e080e7          	jalr	926(ra) # 800022be <bread>
    80002f28:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f2a:	3ff97713          	andi	a4,s2,1023
    80002f2e:	40ec87bb          	subw	a5,s9,a4
    80002f32:	413b06bb          	subw	a3,s6,s3
    80002f36:	8d3e                	mv	s10,a5
    80002f38:	2781                	sext.w	a5,a5
    80002f3a:	0006861b          	sext.w	a2,a3
    80002f3e:	f8f674e3          	bgeu	a2,a5,80002ec6 <writei+0x4c>
    80002f42:	8d36                	mv	s10,a3
    80002f44:	b749                	j	80002ec6 <writei+0x4c>
      brelse(bp);
    80002f46:	8526                	mv	a0,s1
    80002f48:	fffff097          	auipc	ra,0xfffff
    80002f4c:	4a6080e7          	jalr	1190(ra) # 800023ee <brelse>
  }

  if(off > ip->size)
    80002f50:	04caa783          	lw	a5,76(s5)
    80002f54:	0127f463          	bgeu	a5,s2,80002f5c <writei+0xe2>
    ip->size = off;
    80002f58:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f5c:	8556                	mv	a0,s5
    80002f5e:	00000097          	auipc	ra,0x0
    80002f62:	aa4080e7          	jalr	-1372(ra) # 80002a02 <iupdate>

  return tot;
    80002f66:	0009851b          	sext.w	a0,s3
}
    80002f6a:	70a6                	ld	ra,104(sp)
    80002f6c:	7406                	ld	s0,96(sp)
    80002f6e:	64e6                	ld	s1,88(sp)
    80002f70:	6946                	ld	s2,80(sp)
    80002f72:	69a6                	ld	s3,72(sp)
    80002f74:	6a06                	ld	s4,64(sp)
    80002f76:	7ae2                	ld	s5,56(sp)
    80002f78:	7b42                	ld	s6,48(sp)
    80002f7a:	7ba2                	ld	s7,40(sp)
    80002f7c:	7c02                	ld	s8,32(sp)
    80002f7e:	6ce2                	ld	s9,24(sp)
    80002f80:	6d42                	ld	s10,16(sp)
    80002f82:	6da2                	ld	s11,8(sp)
    80002f84:	6165                	addi	sp,sp,112
    80002f86:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f88:	89da                	mv	s3,s6
    80002f8a:	bfc9                	j	80002f5c <writei+0xe2>
    return -1;
    80002f8c:	557d                	li	a0,-1
}
    80002f8e:	8082                	ret
    return -1;
    80002f90:	557d                	li	a0,-1
    80002f92:	bfe1                	j	80002f6a <writei+0xf0>
    return -1;
    80002f94:	557d                	li	a0,-1
    80002f96:	bfd1                	j	80002f6a <writei+0xf0>

0000000080002f98 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002f98:	1141                	addi	sp,sp,-16
    80002f9a:	e406                	sd	ra,8(sp)
    80002f9c:	e022                	sd	s0,0(sp)
    80002f9e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fa0:	4639                	li	a2,14
    80002fa2:	ffffd097          	auipc	ra,0xffffd
    80002fa6:	2a8080e7          	jalr	680(ra) # 8000024a <strncmp>
}
    80002faa:	60a2                	ld	ra,8(sp)
    80002fac:	6402                	ld	s0,0(sp)
    80002fae:	0141                	addi	sp,sp,16
    80002fb0:	8082                	ret

0000000080002fb2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fb2:	7139                	addi	sp,sp,-64
    80002fb4:	fc06                	sd	ra,56(sp)
    80002fb6:	f822                	sd	s0,48(sp)
    80002fb8:	f426                	sd	s1,40(sp)
    80002fba:	f04a                	sd	s2,32(sp)
    80002fbc:	ec4e                	sd	s3,24(sp)
    80002fbe:	e852                	sd	s4,16(sp)
    80002fc0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fc2:	04451703          	lh	a4,68(a0)
    80002fc6:	4785                	li	a5,1
    80002fc8:	00f71a63          	bne	a4,a5,80002fdc <dirlookup+0x2a>
    80002fcc:	892a                	mv	s2,a0
    80002fce:	89ae                	mv	s3,a1
    80002fd0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fd2:	457c                	lw	a5,76(a0)
    80002fd4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fd6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fd8:	e79d                	bnez	a5,80003006 <dirlookup+0x54>
    80002fda:	a8a5                	j	80003052 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002fdc:	00005517          	auipc	a0,0x5
    80002fe0:	59450513          	addi	a0,a0,1428 # 80008570 <syscalls+0x1a0>
    80002fe4:	00003097          	auipc	ra,0x3
    80002fe8:	b42080e7          	jalr	-1214(ra) # 80005b26 <panic>
      panic("dirlookup read");
    80002fec:	00005517          	auipc	a0,0x5
    80002ff0:	59c50513          	addi	a0,a0,1436 # 80008588 <syscalls+0x1b8>
    80002ff4:	00003097          	auipc	ra,0x3
    80002ff8:	b32080e7          	jalr	-1230(ra) # 80005b26 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ffc:	24c1                	addiw	s1,s1,16
    80002ffe:	04c92783          	lw	a5,76(s2)
    80003002:	04f4f763          	bgeu	s1,a5,80003050 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003006:	4741                	li	a4,16
    80003008:	86a6                	mv	a3,s1
    8000300a:	fc040613          	addi	a2,s0,-64
    8000300e:	4581                	li	a1,0
    80003010:	854a                	mv	a0,s2
    80003012:	00000097          	auipc	ra,0x0
    80003016:	d70080e7          	jalr	-656(ra) # 80002d82 <readi>
    8000301a:	47c1                	li	a5,16
    8000301c:	fcf518e3          	bne	a0,a5,80002fec <dirlookup+0x3a>
    if(de.inum == 0)
    80003020:	fc045783          	lhu	a5,-64(s0)
    80003024:	dfe1                	beqz	a5,80002ffc <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003026:	fc240593          	addi	a1,s0,-62
    8000302a:	854e                	mv	a0,s3
    8000302c:	00000097          	auipc	ra,0x0
    80003030:	f6c080e7          	jalr	-148(ra) # 80002f98 <namecmp>
    80003034:	f561                	bnez	a0,80002ffc <dirlookup+0x4a>
      if(poff)
    80003036:	000a0463          	beqz	s4,8000303e <dirlookup+0x8c>
        *poff = off;
    8000303a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000303e:	fc045583          	lhu	a1,-64(s0)
    80003042:	00092503          	lw	a0,0(s2)
    80003046:	fffff097          	auipc	ra,0xfffff
    8000304a:	754080e7          	jalr	1876(ra) # 8000279a <iget>
    8000304e:	a011                	j	80003052 <dirlookup+0xa0>
  return 0;
    80003050:	4501                	li	a0,0
}
    80003052:	70e2                	ld	ra,56(sp)
    80003054:	7442                	ld	s0,48(sp)
    80003056:	74a2                	ld	s1,40(sp)
    80003058:	7902                	ld	s2,32(sp)
    8000305a:	69e2                	ld	s3,24(sp)
    8000305c:	6a42                	ld	s4,16(sp)
    8000305e:	6121                	addi	sp,sp,64
    80003060:	8082                	ret

0000000080003062 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003062:	711d                	addi	sp,sp,-96
    80003064:	ec86                	sd	ra,88(sp)
    80003066:	e8a2                	sd	s0,80(sp)
    80003068:	e4a6                	sd	s1,72(sp)
    8000306a:	e0ca                	sd	s2,64(sp)
    8000306c:	fc4e                	sd	s3,56(sp)
    8000306e:	f852                	sd	s4,48(sp)
    80003070:	f456                	sd	s5,40(sp)
    80003072:	f05a                	sd	s6,32(sp)
    80003074:	ec5e                	sd	s7,24(sp)
    80003076:	e862                	sd	s8,16(sp)
    80003078:	e466                	sd	s9,8(sp)
    8000307a:	1080                	addi	s0,sp,96
    8000307c:	84aa                	mv	s1,a0
    8000307e:	8b2e                	mv	s6,a1
    80003080:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003082:	00054703          	lbu	a4,0(a0)
    80003086:	02f00793          	li	a5,47
    8000308a:	02f70263          	beq	a4,a5,800030ae <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000308e:	ffffe097          	auipc	ra,0xffffe
    80003092:	dc4080e7          	jalr	-572(ra) # 80000e52 <myproc>
    80003096:	15053503          	ld	a0,336(a0)
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	9f6080e7          	jalr	-1546(ra) # 80002a90 <idup>
    800030a2:	8a2a                	mv	s4,a0
  while(*path == '/')
    800030a4:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800030a8:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030aa:	4b85                	li	s7,1
    800030ac:	a875                	j	80003168 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800030ae:	4585                	li	a1,1
    800030b0:	4505                	li	a0,1
    800030b2:	fffff097          	auipc	ra,0xfffff
    800030b6:	6e8080e7          	jalr	1768(ra) # 8000279a <iget>
    800030ba:	8a2a                	mv	s4,a0
    800030bc:	b7e5                	j	800030a4 <namex+0x42>
      iunlockput(ip);
    800030be:	8552                	mv	a0,s4
    800030c0:	00000097          	auipc	ra,0x0
    800030c4:	c70080e7          	jalr	-912(ra) # 80002d30 <iunlockput>
      return 0;
    800030c8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030ca:	8552                	mv	a0,s4
    800030cc:	60e6                	ld	ra,88(sp)
    800030ce:	6446                	ld	s0,80(sp)
    800030d0:	64a6                	ld	s1,72(sp)
    800030d2:	6906                	ld	s2,64(sp)
    800030d4:	79e2                	ld	s3,56(sp)
    800030d6:	7a42                	ld	s4,48(sp)
    800030d8:	7aa2                	ld	s5,40(sp)
    800030da:	7b02                	ld	s6,32(sp)
    800030dc:	6be2                	ld	s7,24(sp)
    800030de:	6c42                	ld	s8,16(sp)
    800030e0:	6ca2                	ld	s9,8(sp)
    800030e2:	6125                	addi	sp,sp,96
    800030e4:	8082                	ret
      iunlock(ip);
    800030e6:	8552                	mv	a0,s4
    800030e8:	00000097          	auipc	ra,0x0
    800030ec:	aa8080e7          	jalr	-1368(ra) # 80002b90 <iunlock>
      return ip;
    800030f0:	bfe9                	j	800030ca <namex+0x68>
      iunlockput(ip);
    800030f2:	8552                	mv	a0,s4
    800030f4:	00000097          	auipc	ra,0x0
    800030f8:	c3c080e7          	jalr	-964(ra) # 80002d30 <iunlockput>
      return 0;
    800030fc:	8a4e                	mv	s4,s3
    800030fe:	b7f1                	j	800030ca <namex+0x68>
  len = path - s;
    80003100:	40998633          	sub	a2,s3,s1
    80003104:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003108:	099c5863          	bge	s8,s9,80003198 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000310c:	4639                	li	a2,14
    8000310e:	85a6                	mv	a1,s1
    80003110:	8556                	mv	a0,s5
    80003112:	ffffd097          	auipc	ra,0xffffd
    80003116:	0c4080e7          	jalr	196(ra) # 800001d6 <memmove>
    8000311a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000311c:	0004c783          	lbu	a5,0(s1)
    80003120:	01279763          	bne	a5,s2,8000312e <namex+0xcc>
    path++;
    80003124:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003126:	0004c783          	lbu	a5,0(s1)
    8000312a:	ff278de3          	beq	a5,s2,80003124 <namex+0xc2>
    ilock(ip);
    8000312e:	8552                	mv	a0,s4
    80003130:	00000097          	auipc	ra,0x0
    80003134:	99e080e7          	jalr	-1634(ra) # 80002ace <ilock>
    if(ip->type != T_DIR){
    80003138:	044a1783          	lh	a5,68(s4)
    8000313c:	f97791e3          	bne	a5,s7,800030be <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003140:	000b0563          	beqz	s6,8000314a <namex+0xe8>
    80003144:	0004c783          	lbu	a5,0(s1)
    80003148:	dfd9                	beqz	a5,800030e6 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000314a:	4601                	li	a2,0
    8000314c:	85d6                	mv	a1,s5
    8000314e:	8552                	mv	a0,s4
    80003150:	00000097          	auipc	ra,0x0
    80003154:	e62080e7          	jalr	-414(ra) # 80002fb2 <dirlookup>
    80003158:	89aa                	mv	s3,a0
    8000315a:	dd41                	beqz	a0,800030f2 <namex+0x90>
    iunlockput(ip);
    8000315c:	8552                	mv	a0,s4
    8000315e:	00000097          	auipc	ra,0x0
    80003162:	bd2080e7          	jalr	-1070(ra) # 80002d30 <iunlockput>
    ip = next;
    80003166:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003168:	0004c783          	lbu	a5,0(s1)
    8000316c:	01279763          	bne	a5,s2,8000317a <namex+0x118>
    path++;
    80003170:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003172:	0004c783          	lbu	a5,0(s1)
    80003176:	ff278de3          	beq	a5,s2,80003170 <namex+0x10e>
  if(*path == 0)
    8000317a:	cb9d                	beqz	a5,800031b0 <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000317c:	0004c783          	lbu	a5,0(s1)
    80003180:	89a6                	mv	s3,s1
  len = path - s;
    80003182:	4c81                	li	s9,0
    80003184:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003186:	01278963          	beq	a5,s2,80003198 <namex+0x136>
    8000318a:	dbbd                	beqz	a5,80003100 <namex+0x9e>
    path++;
    8000318c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000318e:	0009c783          	lbu	a5,0(s3)
    80003192:	ff279ce3          	bne	a5,s2,8000318a <namex+0x128>
    80003196:	b7ad                	j	80003100 <namex+0x9e>
    memmove(name, s, len);
    80003198:	2601                	sext.w	a2,a2
    8000319a:	85a6                	mv	a1,s1
    8000319c:	8556                	mv	a0,s5
    8000319e:	ffffd097          	auipc	ra,0xffffd
    800031a2:	038080e7          	jalr	56(ra) # 800001d6 <memmove>
    name[len] = 0;
    800031a6:	9cd6                	add	s9,s9,s5
    800031a8:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800031ac:	84ce                	mv	s1,s3
    800031ae:	b7bd                	j	8000311c <namex+0xba>
  if(nameiparent){
    800031b0:	f00b0de3          	beqz	s6,800030ca <namex+0x68>
    iput(ip);
    800031b4:	8552                	mv	a0,s4
    800031b6:	00000097          	auipc	ra,0x0
    800031ba:	ad2080e7          	jalr	-1326(ra) # 80002c88 <iput>
    return 0;
    800031be:	4a01                	li	s4,0
    800031c0:	b729                	j	800030ca <namex+0x68>

00000000800031c2 <dirlink>:
{
    800031c2:	7139                	addi	sp,sp,-64
    800031c4:	fc06                	sd	ra,56(sp)
    800031c6:	f822                	sd	s0,48(sp)
    800031c8:	f426                	sd	s1,40(sp)
    800031ca:	f04a                	sd	s2,32(sp)
    800031cc:	ec4e                	sd	s3,24(sp)
    800031ce:	e852                	sd	s4,16(sp)
    800031d0:	0080                	addi	s0,sp,64
    800031d2:	892a                	mv	s2,a0
    800031d4:	8a2e                	mv	s4,a1
    800031d6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031d8:	4601                	li	a2,0
    800031da:	00000097          	auipc	ra,0x0
    800031de:	dd8080e7          	jalr	-552(ra) # 80002fb2 <dirlookup>
    800031e2:	e93d                	bnez	a0,80003258 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031e4:	04c92483          	lw	s1,76(s2)
    800031e8:	c49d                	beqz	s1,80003216 <dirlink+0x54>
    800031ea:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031ec:	4741                	li	a4,16
    800031ee:	86a6                	mv	a3,s1
    800031f0:	fc040613          	addi	a2,s0,-64
    800031f4:	4581                	li	a1,0
    800031f6:	854a                	mv	a0,s2
    800031f8:	00000097          	auipc	ra,0x0
    800031fc:	b8a080e7          	jalr	-1142(ra) # 80002d82 <readi>
    80003200:	47c1                	li	a5,16
    80003202:	06f51163          	bne	a0,a5,80003264 <dirlink+0xa2>
    if(de.inum == 0)
    80003206:	fc045783          	lhu	a5,-64(s0)
    8000320a:	c791                	beqz	a5,80003216 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000320c:	24c1                	addiw	s1,s1,16
    8000320e:	04c92783          	lw	a5,76(s2)
    80003212:	fcf4ede3          	bltu	s1,a5,800031ec <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003216:	4639                	li	a2,14
    80003218:	85d2                	mv	a1,s4
    8000321a:	fc240513          	addi	a0,s0,-62
    8000321e:	ffffd097          	auipc	ra,0xffffd
    80003222:	068080e7          	jalr	104(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003226:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000322a:	4741                	li	a4,16
    8000322c:	86a6                	mv	a3,s1
    8000322e:	fc040613          	addi	a2,s0,-64
    80003232:	4581                	li	a1,0
    80003234:	854a                	mv	a0,s2
    80003236:	00000097          	auipc	ra,0x0
    8000323a:	c44080e7          	jalr	-956(ra) # 80002e7a <writei>
    8000323e:	1541                	addi	a0,a0,-16
    80003240:	00a03533          	snez	a0,a0
    80003244:	40a00533          	neg	a0,a0
}
    80003248:	70e2                	ld	ra,56(sp)
    8000324a:	7442                	ld	s0,48(sp)
    8000324c:	74a2                	ld	s1,40(sp)
    8000324e:	7902                	ld	s2,32(sp)
    80003250:	69e2                	ld	s3,24(sp)
    80003252:	6a42                	ld	s4,16(sp)
    80003254:	6121                	addi	sp,sp,64
    80003256:	8082                	ret
    iput(ip);
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	a30080e7          	jalr	-1488(ra) # 80002c88 <iput>
    return -1;
    80003260:	557d                	li	a0,-1
    80003262:	b7dd                	j	80003248 <dirlink+0x86>
      panic("dirlink read");
    80003264:	00005517          	auipc	a0,0x5
    80003268:	33450513          	addi	a0,a0,820 # 80008598 <syscalls+0x1c8>
    8000326c:	00003097          	auipc	ra,0x3
    80003270:	8ba080e7          	jalr	-1862(ra) # 80005b26 <panic>

0000000080003274 <namei>:

struct inode*
namei(char *path)
{
    80003274:	1101                	addi	sp,sp,-32
    80003276:	ec06                	sd	ra,24(sp)
    80003278:	e822                	sd	s0,16(sp)
    8000327a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000327c:	fe040613          	addi	a2,s0,-32
    80003280:	4581                	li	a1,0
    80003282:	00000097          	auipc	ra,0x0
    80003286:	de0080e7          	jalr	-544(ra) # 80003062 <namex>
}
    8000328a:	60e2                	ld	ra,24(sp)
    8000328c:	6442                	ld	s0,16(sp)
    8000328e:	6105                	addi	sp,sp,32
    80003290:	8082                	ret

0000000080003292 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003292:	1141                	addi	sp,sp,-16
    80003294:	e406                	sd	ra,8(sp)
    80003296:	e022                	sd	s0,0(sp)
    80003298:	0800                	addi	s0,sp,16
    8000329a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000329c:	4585                	li	a1,1
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	dc4080e7          	jalr	-572(ra) # 80003062 <namex>
}
    800032a6:	60a2                	ld	ra,8(sp)
    800032a8:	6402                	ld	s0,0(sp)
    800032aa:	0141                	addi	sp,sp,16
    800032ac:	8082                	ret

00000000800032ae <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032ae:	1101                	addi	sp,sp,-32
    800032b0:	ec06                	sd	ra,24(sp)
    800032b2:	e822                	sd	s0,16(sp)
    800032b4:	e426                	sd	s1,8(sp)
    800032b6:	e04a                	sd	s2,0(sp)
    800032b8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032ba:	00015917          	auipc	s2,0x15
    800032be:	61690913          	addi	s2,s2,1558 # 800188d0 <log>
    800032c2:	01892583          	lw	a1,24(s2)
    800032c6:	02892503          	lw	a0,40(s2)
    800032ca:	fffff097          	auipc	ra,0xfffff
    800032ce:	ff4080e7          	jalr	-12(ra) # 800022be <bread>
    800032d2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032d4:	02c92603          	lw	a2,44(s2)
    800032d8:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032da:	00c05f63          	blez	a2,800032f8 <write_head+0x4a>
    800032de:	00015717          	auipc	a4,0x15
    800032e2:	62270713          	addi	a4,a4,1570 # 80018900 <log+0x30>
    800032e6:	87aa                	mv	a5,a0
    800032e8:	060a                	slli	a2,a2,0x2
    800032ea:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800032ec:	4314                	lw	a3,0(a4)
    800032ee:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800032f0:	0711                	addi	a4,a4,4
    800032f2:	0791                	addi	a5,a5,4
    800032f4:	fec79ce3          	bne	a5,a2,800032ec <write_head+0x3e>
  }
  bwrite(buf);
    800032f8:	8526                	mv	a0,s1
    800032fa:	fffff097          	auipc	ra,0xfffff
    800032fe:	0b6080e7          	jalr	182(ra) # 800023b0 <bwrite>
  brelse(buf);
    80003302:	8526                	mv	a0,s1
    80003304:	fffff097          	auipc	ra,0xfffff
    80003308:	0ea080e7          	jalr	234(ra) # 800023ee <brelse>
}
    8000330c:	60e2                	ld	ra,24(sp)
    8000330e:	6442                	ld	s0,16(sp)
    80003310:	64a2                	ld	s1,8(sp)
    80003312:	6902                	ld	s2,0(sp)
    80003314:	6105                	addi	sp,sp,32
    80003316:	8082                	ret

0000000080003318 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003318:	00015797          	auipc	a5,0x15
    8000331c:	5e47a783          	lw	a5,1508(a5) # 800188fc <log+0x2c>
    80003320:	0af05d63          	blez	a5,800033da <install_trans+0xc2>
{
    80003324:	7139                	addi	sp,sp,-64
    80003326:	fc06                	sd	ra,56(sp)
    80003328:	f822                	sd	s0,48(sp)
    8000332a:	f426                	sd	s1,40(sp)
    8000332c:	f04a                	sd	s2,32(sp)
    8000332e:	ec4e                	sd	s3,24(sp)
    80003330:	e852                	sd	s4,16(sp)
    80003332:	e456                	sd	s5,8(sp)
    80003334:	e05a                	sd	s6,0(sp)
    80003336:	0080                	addi	s0,sp,64
    80003338:	8b2a                	mv	s6,a0
    8000333a:	00015a97          	auipc	s5,0x15
    8000333e:	5c6a8a93          	addi	s5,s5,1478 # 80018900 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003342:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003344:	00015997          	auipc	s3,0x15
    80003348:	58c98993          	addi	s3,s3,1420 # 800188d0 <log>
    8000334c:	a00d                	j	8000336e <install_trans+0x56>
    brelse(lbuf);
    8000334e:	854a                	mv	a0,s2
    80003350:	fffff097          	auipc	ra,0xfffff
    80003354:	09e080e7          	jalr	158(ra) # 800023ee <brelse>
    brelse(dbuf);
    80003358:	8526                	mv	a0,s1
    8000335a:	fffff097          	auipc	ra,0xfffff
    8000335e:	094080e7          	jalr	148(ra) # 800023ee <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003362:	2a05                	addiw	s4,s4,1
    80003364:	0a91                	addi	s5,s5,4
    80003366:	02c9a783          	lw	a5,44(s3)
    8000336a:	04fa5e63          	bge	s4,a5,800033c6 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000336e:	0189a583          	lw	a1,24(s3)
    80003372:	014585bb          	addw	a1,a1,s4
    80003376:	2585                	addiw	a1,a1,1
    80003378:	0289a503          	lw	a0,40(s3)
    8000337c:	fffff097          	auipc	ra,0xfffff
    80003380:	f42080e7          	jalr	-190(ra) # 800022be <bread>
    80003384:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003386:	000aa583          	lw	a1,0(s5)
    8000338a:	0289a503          	lw	a0,40(s3)
    8000338e:	fffff097          	auipc	ra,0xfffff
    80003392:	f30080e7          	jalr	-208(ra) # 800022be <bread>
    80003396:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003398:	40000613          	li	a2,1024
    8000339c:	05890593          	addi	a1,s2,88
    800033a0:	05850513          	addi	a0,a0,88
    800033a4:	ffffd097          	auipc	ra,0xffffd
    800033a8:	e32080e7          	jalr	-462(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033ac:	8526                	mv	a0,s1
    800033ae:	fffff097          	auipc	ra,0xfffff
    800033b2:	002080e7          	jalr	2(ra) # 800023b0 <bwrite>
    if(recovering == 0)
    800033b6:	f80b1ce3          	bnez	s6,8000334e <install_trans+0x36>
      bunpin(dbuf);
    800033ba:	8526                	mv	a0,s1
    800033bc:	fffff097          	auipc	ra,0xfffff
    800033c0:	10a080e7          	jalr	266(ra) # 800024c6 <bunpin>
    800033c4:	b769                	j	8000334e <install_trans+0x36>
}
    800033c6:	70e2                	ld	ra,56(sp)
    800033c8:	7442                	ld	s0,48(sp)
    800033ca:	74a2                	ld	s1,40(sp)
    800033cc:	7902                	ld	s2,32(sp)
    800033ce:	69e2                	ld	s3,24(sp)
    800033d0:	6a42                	ld	s4,16(sp)
    800033d2:	6aa2                	ld	s5,8(sp)
    800033d4:	6b02                	ld	s6,0(sp)
    800033d6:	6121                	addi	sp,sp,64
    800033d8:	8082                	ret
    800033da:	8082                	ret

00000000800033dc <initlog>:
{
    800033dc:	7179                	addi	sp,sp,-48
    800033de:	f406                	sd	ra,40(sp)
    800033e0:	f022                	sd	s0,32(sp)
    800033e2:	ec26                	sd	s1,24(sp)
    800033e4:	e84a                	sd	s2,16(sp)
    800033e6:	e44e                	sd	s3,8(sp)
    800033e8:	1800                	addi	s0,sp,48
    800033ea:	892a                	mv	s2,a0
    800033ec:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800033ee:	00015497          	auipc	s1,0x15
    800033f2:	4e248493          	addi	s1,s1,1250 # 800188d0 <log>
    800033f6:	00005597          	auipc	a1,0x5
    800033fa:	1b258593          	addi	a1,a1,434 # 800085a8 <syscalls+0x1d8>
    800033fe:	8526                	mv	a0,s1
    80003400:	00003097          	auipc	ra,0x3
    80003404:	bce080e7          	jalr	-1074(ra) # 80005fce <initlock>
  log.start = sb->logstart;
    80003408:	0149a583          	lw	a1,20(s3)
    8000340c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000340e:	0109a783          	lw	a5,16(s3)
    80003412:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003414:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003418:	854a                	mv	a0,s2
    8000341a:	fffff097          	auipc	ra,0xfffff
    8000341e:	ea4080e7          	jalr	-348(ra) # 800022be <bread>
  log.lh.n = lh->n;
    80003422:	4d30                	lw	a2,88(a0)
    80003424:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003426:	00c05f63          	blez	a2,80003444 <initlog+0x68>
    8000342a:	87aa                	mv	a5,a0
    8000342c:	00015717          	auipc	a4,0x15
    80003430:	4d470713          	addi	a4,a4,1236 # 80018900 <log+0x30>
    80003434:	060a                	slli	a2,a2,0x2
    80003436:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003438:	4ff4                	lw	a3,92(a5)
    8000343a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000343c:	0791                	addi	a5,a5,4
    8000343e:	0711                	addi	a4,a4,4
    80003440:	fec79ce3          	bne	a5,a2,80003438 <initlog+0x5c>
  brelse(buf);
    80003444:	fffff097          	auipc	ra,0xfffff
    80003448:	faa080e7          	jalr	-86(ra) # 800023ee <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000344c:	4505                	li	a0,1
    8000344e:	00000097          	auipc	ra,0x0
    80003452:	eca080e7          	jalr	-310(ra) # 80003318 <install_trans>
  log.lh.n = 0;
    80003456:	00015797          	auipc	a5,0x15
    8000345a:	4a07a323          	sw	zero,1190(a5) # 800188fc <log+0x2c>
  write_head(); // clear the log
    8000345e:	00000097          	auipc	ra,0x0
    80003462:	e50080e7          	jalr	-432(ra) # 800032ae <write_head>
}
    80003466:	70a2                	ld	ra,40(sp)
    80003468:	7402                	ld	s0,32(sp)
    8000346a:	64e2                	ld	s1,24(sp)
    8000346c:	6942                	ld	s2,16(sp)
    8000346e:	69a2                	ld	s3,8(sp)
    80003470:	6145                	addi	sp,sp,48
    80003472:	8082                	ret

0000000080003474 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003474:	1101                	addi	sp,sp,-32
    80003476:	ec06                	sd	ra,24(sp)
    80003478:	e822                	sd	s0,16(sp)
    8000347a:	e426                	sd	s1,8(sp)
    8000347c:	e04a                	sd	s2,0(sp)
    8000347e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003480:	00015517          	auipc	a0,0x15
    80003484:	45050513          	addi	a0,a0,1104 # 800188d0 <log>
    80003488:	00003097          	auipc	ra,0x3
    8000348c:	bd6080e7          	jalr	-1066(ra) # 8000605e <acquire>
  while(1){
    if(log.committing){
    80003490:	00015497          	auipc	s1,0x15
    80003494:	44048493          	addi	s1,s1,1088 # 800188d0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003498:	4979                	li	s2,30
    8000349a:	a039                	j	800034a8 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000349c:	85a6                	mv	a1,s1
    8000349e:	8526                	mv	a0,s1
    800034a0:	ffffe097          	auipc	ra,0xffffe
    800034a4:	05a080e7          	jalr	90(ra) # 800014fa <sleep>
    if(log.committing){
    800034a8:	50dc                	lw	a5,36(s1)
    800034aa:	fbed                	bnez	a5,8000349c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034ac:	5098                	lw	a4,32(s1)
    800034ae:	2705                	addiw	a4,a4,1
    800034b0:	0027179b          	slliw	a5,a4,0x2
    800034b4:	9fb9                	addw	a5,a5,a4
    800034b6:	0017979b          	slliw	a5,a5,0x1
    800034ba:	54d4                	lw	a3,44(s1)
    800034bc:	9fb5                	addw	a5,a5,a3
    800034be:	00f95963          	bge	s2,a5,800034d0 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034c2:	85a6                	mv	a1,s1
    800034c4:	8526                	mv	a0,s1
    800034c6:	ffffe097          	auipc	ra,0xffffe
    800034ca:	034080e7          	jalr	52(ra) # 800014fa <sleep>
    800034ce:	bfe9                	j	800034a8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800034d0:	00015517          	auipc	a0,0x15
    800034d4:	40050513          	addi	a0,a0,1024 # 800188d0 <log>
    800034d8:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800034da:	00003097          	auipc	ra,0x3
    800034de:	c38080e7          	jalr	-968(ra) # 80006112 <release>
      break;
    }
  }
}
    800034e2:	60e2                	ld	ra,24(sp)
    800034e4:	6442                	ld	s0,16(sp)
    800034e6:	64a2                	ld	s1,8(sp)
    800034e8:	6902                	ld	s2,0(sp)
    800034ea:	6105                	addi	sp,sp,32
    800034ec:	8082                	ret

00000000800034ee <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800034ee:	7139                	addi	sp,sp,-64
    800034f0:	fc06                	sd	ra,56(sp)
    800034f2:	f822                	sd	s0,48(sp)
    800034f4:	f426                	sd	s1,40(sp)
    800034f6:	f04a                	sd	s2,32(sp)
    800034f8:	ec4e                	sd	s3,24(sp)
    800034fa:	e852                	sd	s4,16(sp)
    800034fc:	e456                	sd	s5,8(sp)
    800034fe:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003500:	00015497          	auipc	s1,0x15
    80003504:	3d048493          	addi	s1,s1,976 # 800188d0 <log>
    80003508:	8526                	mv	a0,s1
    8000350a:	00003097          	auipc	ra,0x3
    8000350e:	b54080e7          	jalr	-1196(ra) # 8000605e <acquire>
  log.outstanding -= 1;
    80003512:	509c                	lw	a5,32(s1)
    80003514:	37fd                	addiw	a5,a5,-1
    80003516:	0007891b          	sext.w	s2,a5
    8000351a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000351c:	50dc                	lw	a5,36(s1)
    8000351e:	e7b9                	bnez	a5,8000356c <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003520:	04091e63          	bnez	s2,8000357c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003524:	00015497          	auipc	s1,0x15
    80003528:	3ac48493          	addi	s1,s1,940 # 800188d0 <log>
    8000352c:	4785                	li	a5,1
    8000352e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003530:	8526                	mv	a0,s1
    80003532:	00003097          	auipc	ra,0x3
    80003536:	be0080e7          	jalr	-1056(ra) # 80006112 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000353a:	54dc                	lw	a5,44(s1)
    8000353c:	06f04763          	bgtz	a5,800035aa <end_op+0xbc>
    acquire(&log.lock);
    80003540:	00015497          	auipc	s1,0x15
    80003544:	39048493          	addi	s1,s1,912 # 800188d0 <log>
    80003548:	8526                	mv	a0,s1
    8000354a:	00003097          	auipc	ra,0x3
    8000354e:	b14080e7          	jalr	-1260(ra) # 8000605e <acquire>
    log.committing = 0;
    80003552:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003556:	8526                	mv	a0,s1
    80003558:	ffffe097          	auipc	ra,0xffffe
    8000355c:	006080e7          	jalr	6(ra) # 8000155e <wakeup>
    release(&log.lock);
    80003560:	8526                	mv	a0,s1
    80003562:	00003097          	auipc	ra,0x3
    80003566:	bb0080e7          	jalr	-1104(ra) # 80006112 <release>
}
    8000356a:	a03d                	j	80003598 <end_op+0xaa>
    panic("log.committing");
    8000356c:	00005517          	auipc	a0,0x5
    80003570:	04450513          	addi	a0,a0,68 # 800085b0 <syscalls+0x1e0>
    80003574:	00002097          	auipc	ra,0x2
    80003578:	5b2080e7          	jalr	1458(ra) # 80005b26 <panic>
    wakeup(&log);
    8000357c:	00015497          	auipc	s1,0x15
    80003580:	35448493          	addi	s1,s1,852 # 800188d0 <log>
    80003584:	8526                	mv	a0,s1
    80003586:	ffffe097          	auipc	ra,0xffffe
    8000358a:	fd8080e7          	jalr	-40(ra) # 8000155e <wakeup>
  release(&log.lock);
    8000358e:	8526                	mv	a0,s1
    80003590:	00003097          	auipc	ra,0x3
    80003594:	b82080e7          	jalr	-1150(ra) # 80006112 <release>
}
    80003598:	70e2                	ld	ra,56(sp)
    8000359a:	7442                	ld	s0,48(sp)
    8000359c:	74a2                	ld	s1,40(sp)
    8000359e:	7902                	ld	s2,32(sp)
    800035a0:	69e2                	ld	s3,24(sp)
    800035a2:	6a42                	ld	s4,16(sp)
    800035a4:	6aa2                	ld	s5,8(sp)
    800035a6:	6121                	addi	sp,sp,64
    800035a8:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800035aa:	00015a97          	auipc	s5,0x15
    800035ae:	356a8a93          	addi	s5,s5,854 # 80018900 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035b2:	00015a17          	auipc	s4,0x15
    800035b6:	31ea0a13          	addi	s4,s4,798 # 800188d0 <log>
    800035ba:	018a2583          	lw	a1,24(s4)
    800035be:	012585bb          	addw	a1,a1,s2
    800035c2:	2585                	addiw	a1,a1,1
    800035c4:	028a2503          	lw	a0,40(s4)
    800035c8:	fffff097          	auipc	ra,0xfffff
    800035cc:	cf6080e7          	jalr	-778(ra) # 800022be <bread>
    800035d0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800035d2:	000aa583          	lw	a1,0(s5)
    800035d6:	028a2503          	lw	a0,40(s4)
    800035da:	fffff097          	auipc	ra,0xfffff
    800035de:	ce4080e7          	jalr	-796(ra) # 800022be <bread>
    800035e2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800035e4:	40000613          	li	a2,1024
    800035e8:	05850593          	addi	a1,a0,88
    800035ec:	05848513          	addi	a0,s1,88
    800035f0:	ffffd097          	auipc	ra,0xffffd
    800035f4:	be6080e7          	jalr	-1050(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800035f8:	8526                	mv	a0,s1
    800035fa:	fffff097          	auipc	ra,0xfffff
    800035fe:	db6080e7          	jalr	-586(ra) # 800023b0 <bwrite>
    brelse(from);
    80003602:	854e                	mv	a0,s3
    80003604:	fffff097          	auipc	ra,0xfffff
    80003608:	dea080e7          	jalr	-534(ra) # 800023ee <brelse>
    brelse(to);
    8000360c:	8526                	mv	a0,s1
    8000360e:	fffff097          	auipc	ra,0xfffff
    80003612:	de0080e7          	jalr	-544(ra) # 800023ee <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003616:	2905                	addiw	s2,s2,1
    80003618:	0a91                	addi	s5,s5,4
    8000361a:	02ca2783          	lw	a5,44(s4)
    8000361e:	f8f94ee3          	blt	s2,a5,800035ba <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003622:	00000097          	auipc	ra,0x0
    80003626:	c8c080e7          	jalr	-884(ra) # 800032ae <write_head>
    install_trans(0); // Now install writes to home locations
    8000362a:	4501                	li	a0,0
    8000362c:	00000097          	auipc	ra,0x0
    80003630:	cec080e7          	jalr	-788(ra) # 80003318 <install_trans>
    log.lh.n = 0;
    80003634:	00015797          	auipc	a5,0x15
    80003638:	2c07a423          	sw	zero,712(a5) # 800188fc <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000363c:	00000097          	auipc	ra,0x0
    80003640:	c72080e7          	jalr	-910(ra) # 800032ae <write_head>
    80003644:	bdf5                	j	80003540 <end_op+0x52>

0000000080003646 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003646:	1101                	addi	sp,sp,-32
    80003648:	ec06                	sd	ra,24(sp)
    8000364a:	e822                	sd	s0,16(sp)
    8000364c:	e426                	sd	s1,8(sp)
    8000364e:	e04a                	sd	s2,0(sp)
    80003650:	1000                	addi	s0,sp,32
    80003652:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003654:	00015917          	auipc	s2,0x15
    80003658:	27c90913          	addi	s2,s2,636 # 800188d0 <log>
    8000365c:	854a                	mv	a0,s2
    8000365e:	00003097          	auipc	ra,0x3
    80003662:	a00080e7          	jalr	-1536(ra) # 8000605e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003666:	02c92603          	lw	a2,44(s2)
    8000366a:	47f5                	li	a5,29
    8000366c:	06c7c563          	blt	a5,a2,800036d6 <log_write+0x90>
    80003670:	00015797          	auipc	a5,0x15
    80003674:	27c7a783          	lw	a5,636(a5) # 800188ec <log+0x1c>
    80003678:	37fd                	addiw	a5,a5,-1
    8000367a:	04f65e63          	bge	a2,a5,800036d6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000367e:	00015797          	auipc	a5,0x15
    80003682:	2727a783          	lw	a5,626(a5) # 800188f0 <log+0x20>
    80003686:	06f05063          	blez	a5,800036e6 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000368a:	4781                	li	a5,0
    8000368c:	06c05563          	blez	a2,800036f6 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003690:	44cc                	lw	a1,12(s1)
    80003692:	00015717          	auipc	a4,0x15
    80003696:	26e70713          	addi	a4,a4,622 # 80018900 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000369a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000369c:	4314                	lw	a3,0(a4)
    8000369e:	04b68c63          	beq	a3,a1,800036f6 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036a2:	2785                	addiw	a5,a5,1
    800036a4:	0711                	addi	a4,a4,4
    800036a6:	fef61be3          	bne	a2,a5,8000369c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036aa:	0621                	addi	a2,a2,8
    800036ac:	060a                	slli	a2,a2,0x2
    800036ae:	00015797          	auipc	a5,0x15
    800036b2:	22278793          	addi	a5,a5,546 # 800188d0 <log>
    800036b6:	97b2                	add	a5,a5,a2
    800036b8:	44d8                	lw	a4,12(s1)
    800036ba:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036bc:	8526                	mv	a0,s1
    800036be:	fffff097          	auipc	ra,0xfffff
    800036c2:	dcc080e7          	jalr	-564(ra) # 8000248a <bpin>
    log.lh.n++;
    800036c6:	00015717          	auipc	a4,0x15
    800036ca:	20a70713          	addi	a4,a4,522 # 800188d0 <log>
    800036ce:	575c                	lw	a5,44(a4)
    800036d0:	2785                	addiw	a5,a5,1
    800036d2:	d75c                	sw	a5,44(a4)
    800036d4:	a82d                	j	8000370e <log_write+0xc8>
    panic("too big a transaction");
    800036d6:	00005517          	auipc	a0,0x5
    800036da:	eea50513          	addi	a0,a0,-278 # 800085c0 <syscalls+0x1f0>
    800036de:	00002097          	auipc	ra,0x2
    800036e2:	448080e7          	jalr	1096(ra) # 80005b26 <panic>
    panic("log_write outside of trans");
    800036e6:	00005517          	auipc	a0,0x5
    800036ea:	ef250513          	addi	a0,a0,-270 # 800085d8 <syscalls+0x208>
    800036ee:	00002097          	auipc	ra,0x2
    800036f2:	438080e7          	jalr	1080(ra) # 80005b26 <panic>
  log.lh.block[i] = b->blockno;
    800036f6:	00878693          	addi	a3,a5,8
    800036fa:	068a                	slli	a3,a3,0x2
    800036fc:	00015717          	auipc	a4,0x15
    80003700:	1d470713          	addi	a4,a4,468 # 800188d0 <log>
    80003704:	9736                	add	a4,a4,a3
    80003706:	44d4                	lw	a3,12(s1)
    80003708:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000370a:	faf609e3          	beq	a2,a5,800036bc <log_write+0x76>
  }
  release(&log.lock);
    8000370e:	00015517          	auipc	a0,0x15
    80003712:	1c250513          	addi	a0,a0,450 # 800188d0 <log>
    80003716:	00003097          	auipc	ra,0x3
    8000371a:	9fc080e7          	jalr	-1540(ra) # 80006112 <release>
}
    8000371e:	60e2                	ld	ra,24(sp)
    80003720:	6442                	ld	s0,16(sp)
    80003722:	64a2                	ld	s1,8(sp)
    80003724:	6902                	ld	s2,0(sp)
    80003726:	6105                	addi	sp,sp,32
    80003728:	8082                	ret

000000008000372a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000372a:	1101                	addi	sp,sp,-32
    8000372c:	ec06                	sd	ra,24(sp)
    8000372e:	e822                	sd	s0,16(sp)
    80003730:	e426                	sd	s1,8(sp)
    80003732:	e04a                	sd	s2,0(sp)
    80003734:	1000                	addi	s0,sp,32
    80003736:	84aa                	mv	s1,a0
    80003738:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000373a:	00005597          	auipc	a1,0x5
    8000373e:	ebe58593          	addi	a1,a1,-322 # 800085f8 <syscalls+0x228>
    80003742:	0521                	addi	a0,a0,8
    80003744:	00003097          	auipc	ra,0x3
    80003748:	88a080e7          	jalr	-1910(ra) # 80005fce <initlock>
  lk->name = name;
    8000374c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003750:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003754:	0204a423          	sw	zero,40(s1)
}
    80003758:	60e2                	ld	ra,24(sp)
    8000375a:	6442                	ld	s0,16(sp)
    8000375c:	64a2                	ld	s1,8(sp)
    8000375e:	6902                	ld	s2,0(sp)
    80003760:	6105                	addi	sp,sp,32
    80003762:	8082                	ret

0000000080003764 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003764:	1101                	addi	sp,sp,-32
    80003766:	ec06                	sd	ra,24(sp)
    80003768:	e822                	sd	s0,16(sp)
    8000376a:	e426                	sd	s1,8(sp)
    8000376c:	e04a                	sd	s2,0(sp)
    8000376e:	1000                	addi	s0,sp,32
    80003770:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003772:	00850913          	addi	s2,a0,8
    80003776:	854a                	mv	a0,s2
    80003778:	00003097          	auipc	ra,0x3
    8000377c:	8e6080e7          	jalr	-1818(ra) # 8000605e <acquire>
  while (lk->locked) {
    80003780:	409c                	lw	a5,0(s1)
    80003782:	cb89                	beqz	a5,80003794 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003784:	85ca                	mv	a1,s2
    80003786:	8526                	mv	a0,s1
    80003788:	ffffe097          	auipc	ra,0xffffe
    8000378c:	d72080e7          	jalr	-654(ra) # 800014fa <sleep>
  while (lk->locked) {
    80003790:	409c                	lw	a5,0(s1)
    80003792:	fbed                	bnez	a5,80003784 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003794:	4785                	li	a5,1
    80003796:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003798:	ffffd097          	auipc	ra,0xffffd
    8000379c:	6ba080e7          	jalr	1722(ra) # 80000e52 <myproc>
    800037a0:	591c                	lw	a5,48(a0)
    800037a2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037a4:	854a                	mv	a0,s2
    800037a6:	00003097          	auipc	ra,0x3
    800037aa:	96c080e7          	jalr	-1684(ra) # 80006112 <release>
}
    800037ae:	60e2                	ld	ra,24(sp)
    800037b0:	6442                	ld	s0,16(sp)
    800037b2:	64a2                	ld	s1,8(sp)
    800037b4:	6902                	ld	s2,0(sp)
    800037b6:	6105                	addi	sp,sp,32
    800037b8:	8082                	ret

00000000800037ba <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037ba:	1101                	addi	sp,sp,-32
    800037bc:	ec06                	sd	ra,24(sp)
    800037be:	e822                	sd	s0,16(sp)
    800037c0:	e426                	sd	s1,8(sp)
    800037c2:	e04a                	sd	s2,0(sp)
    800037c4:	1000                	addi	s0,sp,32
    800037c6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037c8:	00850913          	addi	s2,a0,8
    800037cc:	854a                	mv	a0,s2
    800037ce:	00003097          	auipc	ra,0x3
    800037d2:	890080e7          	jalr	-1904(ra) # 8000605e <acquire>
  lk->locked = 0;
    800037d6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037da:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800037de:	8526                	mv	a0,s1
    800037e0:	ffffe097          	auipc	ra,0xffffe
    800037e4:	d7e080e7          	jalr	-642(ra) # 8000155e <wakeup>
  release(&lk->lk);
    800037e8:	854a                	mv	a0,s2
    800037ea:	00003097          	auipc	ra,0x3
    800037ee:	928080e7          	jalr	-1752(ra) # 80006112 <release>
}
    800037f2:	60e2                	ld	ra,24(sp)
    800037f4:	6442                	ld	s0,16(sp)
    800037f6:	64a2                	ld	s1,8(sp)
    800037f8:	6902                	ld	s2,0(sp)
    800037fa:	6105                	addi	sp,sp,32
    800037fc:	8082                	ret

00000000800037fe <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800037fe:	7179                	addi	sp,sp,-48
    80003800:	f406                	sd	ra,40(sp)
    80003802:	f022                	sd	s0,32(sp)
    80003804:	ec26                	sd	s1,24(sp)
    80003806:	e84a                	sd	s2,16(sp)
    80003808:	e44e                	sd	s3,8(sp)
    8000380a:	1800                	addi	s0,sp,48
    8000380c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000380e:	00850913          	addi	s2,a0,8
    80003812:	854a                	mv	a0,s2
    80003814:	00003097          	auipc	ra,0x3
    80003818:	84a080e7          	jalr	-1974(ra) # 8000605e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000381c:	409c                	lw	a5,0(s1)
    8000381e:	ef99                	bnez	a5,8000383c <holdingsleep+0x3e>
    80003820:	4481                	li	s1,0
  release(&lk->lk);
    80003822:	854a                	mv	a0,s2
    80003824:	00003097          	auipc	ra,0x3
    80003828:	8ee080e7          	jalr	-1810(ra) # 80006112 <release>
  return r;
}
    8000382c:	8526                	mv	a0,s1
    8000382e:	70a2                	ld	ra,40(sp)
    80003830:	7402                	ld	s0,32(sp)
    80003832:	64e2                	ld	s1,24(sp)
    80003834:	6942                	ld	s2,16(sp)
    80003836:	69a2                	ld	s3,8(sp)
    80003838:	6145                	addi	sp,sp,48
    8000383a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000383c:	0284a983          	lw	s3,40(s1)
    80003840:	ffffd097          	auipc	ra,0xffffd
    80003844:	612080e7          	jalr	1554(ra) # 80000e52 <myproc>
    80003848:	5904                	lw	s1,48(a0)
    8000384a:	413484b3          	sub	s1,s1,s3
    8000384e:	0014b493          	seqz	s1,s1
    80003852:	bfc1                	j	80003822 <holdingsleep+0x24>

0000000080003854 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003854:	1141                	addi	sp,sp,-16
    80003856:	e406                	sd	ra,8(sp)
    80003858:	e022                	sd	s0,0(sp)
    8000385a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000385c:	00005597          	auipc	a1,0x5
    80003860:	dac58593          	addi	a1,a1,-596 # 80008608 <syscalls+0x238>
    80003864:	00015517          	auipc	a0,0x15
    80003868:	1b450513          	addi	a0,a0,436 # 80018a18 <ftable>
    8000386c:	00002097          	auipc	ra,0x2
    80003870:	762080e7          	jalr	1890(ra) # 80005fce <initlock>
}
    80003874:	60a2                	ld	ra,8(sp)
    80003876:	6402                	ld	s0,0(sp)
    80003878:	0141                	addi	sp,sp,16
    8000387a:	8082                	ret

000000008000387c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000387c:	1101                	addi	sp,sp,-32
    8000387e:	ec06                	sd	ra,24(sp)
    80003880:	e822                	sd	s0,16(sp)
    80003882:	e426                	sd	s1,8(sp)
    80003884:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003886:	00015517          	auipc	a0,0x15
    8000388a:	19250513          	addi	a0,a0,402 # 80018a18 <ftable>
    8000388e:	00002097          	auipc	ra,0x2
    80003892:	7d0080e7          	jalr	2000(ra) # 8000605e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003896:	00015497          	auipc	s1,0x15
    8000389a:	19a48493          	addi	s1,s1,410 # 80018a30 <ftable+0x18>
    8000389e:	00016717          	auipc	a4,0x16
    800038a2:	13270713          	addi	a4,a4,306 # 800199d0 <disk>
    if(f->ref == 0){
    800038a6:	40dc                	lw	a5,4(s1)
    800038a8:	cf99                	beqz	a5,800038c6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038aa:	02848493          	addi	s1,s1,40
    800038ae:	fee49ce3          	bne	s1,a4,800038a6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038b2:	00015517          	auipc	a0,0x15
    800038b6:	16650513          	addi	a0,a0,358 # 80018a18 <ftable>
    800038ba:	00003097          	auipc	ra,0x3
    800038be:	858080e7          	jalr	-1960(ra) # 80006112 <release>
  return 0;
    800038c2:	4481                	li	s1,0
    800038c4:	a819                	j	800038da <filealloc+0x5e>
      f->ref = 1;
    800038c6:	4785                	li	a5,1
    800038c8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800038ca:	00015517          	auipc	a0,0x15
    800038ce:	14e50513          	addi	a0,a0,334 # 80018a18 <ftable>
    800038d2:	00003097          	auipc	ra,0x3
    800038d6:	840080e7          	jalr	-1984(ra) # 80006112 <release>
}
    800038da:	8526                	mv	a0,s1
    800038dc:	60e2                	ld	ra,24(sp)
    800038de:	6442                	ld	s0,16(sp)
    800038e0:	64a2                	ld	s1,8(sp)
    800038e2:	6105                	addi	sp,sp,32
    800038e4:	8082                	ret

00000000800038e6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800038e6:	1101                	addi	sp,sp,-32
    800038e8:	ec06                	sd	ra,24(sp)
    800038ea:	e822                	sd	s0,16(sp)
    800038ec:	e426                	sd	s1,8(sp)
    800038ee:	1000                	addi	s0,sp,32
    800038f0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800038f2:	00015517          	auipc	a0,0x15
    800038f6:	12650513          	addi	a0,a0,294 # 80018a18 <ftable>
    800038fa:	00002097          	auipc	ra,0x2
    800038fe:	764080e7          	jalr	1892(ra) # 8000605e <acquire>
  if(f->ref < 1)
    80003902:	40dc                	lw	a5,4(s1)
    80003904:	02f05263          	blez	a5,80003928 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003908:	2785                	addiw	a5,a5,1
    8000390a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000390c:	00015517          	auipc	a0,0x15
    80003910:	10c50513          	addi	a0,a0,268 # 80018a18 <ftable>
    80003914:	00002097          	auipc	ra,0x2
    80003918:	7fe080e7          	jalr	2046(ra) # 80006112 <release>
  return f;
}
    8000391c:	8526                	mv	a0,s1
    8000391e:	60e2                	ld	ra,24(sp)
    80003920:	6442                	ld	s0,16(sp)
    80003922:	64a2                	ld	s1,8(sp)
    80003924:	6105                	addi	sp,sp,32
    80003926:	8082                	ret
    panic("filedup");
    80003928:	00005517          	auipc	a0,0x5
    8000392c:	ce850513          	addi	a0,a0,-792 # 80008610 <syscalls+0x240>
    80003930:	00002097          	auipc	ra,0x2
    80003934:	1f6080e7          	jalr	502(ra) # 80005b26 <panic>

0000000080003938 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003938:	7139                	addi	sp,sp,-64
    8000393a:	fc06                	sd	ra,56(sp)
    8000393c:	f822                	sd	s0,48(sp)
    8000393e:	f426                	sd	s1,40(sp)
    80003940:	f04a                	sd	s2,32(sp)
    80003942:	ec4e                	sd	s3,24(sp)
    80003944:	e852                	sd	s4,16(sp)
    80003946:	e456                	sd	s5,8(sp)
    80003948:	0080                	addi	s0,sp,64
    8000394a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000394c:	00015517          	auipc	a0,0x15
    80003950:	0cc50513          	addi	a0,a0,204 # 80018a18 <ftable>
    80003954:	00002097          	auipc	ra,0x2
    80003958:	70a080e7          	jalr	1802(ra) # 8000605e <acquire>
  if(f->ref < 1)
    8000395c:	40dc                	lw	a5,4(s1)
    8000395e:	06f05163          	blez	a5,800039c0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003962:	37fd                	addiw	a5,a5,-1
    80003964:	0007871b          	sext.w	a4,a5
    80003968:	c0dc                	sw	a5,4(s1)
    8000396a:	06e04363          	bgtz	a4,800039d0 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000396e:	0004a903          	lw	s2,0(s1)
    80003972:	0094ca83          	lbu	s5,9(s1)
    80003976:	0104ba03          	ld	s4,16(s1)
    8000397a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000397e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003982:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003986:	00015517          	auipc	a0,0x15
    8000398a:	09250513          	addi	a0,a0,146 # 80018a18 <ftable>
    8000398e:	00002097          	auipc	ra,0x2
    80003992:	784080e7          	jalr	1924(ra) # 80006112 <release>

  if(ff.type == FD_PIPE){
    80003996:	4785                	li	a5,1
    80003998:	04f90d63          	beq	s2,a5,800039f2 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000399c:	3979                	addiw	s2,s2,-2
    8000399e:	4785                	li	a5,1
    800039a0:	0527e063          	bltu	a5,s2,800039e0 <fileclose+0xa8>
    begin_op();
    800039a4:	00000097          	auipc	ra,0x0
    800039a8:	ad0080e7          	jalr	-1328(ra) # 80003474 <begin_op>
    iput(ff.ip);
    800039ac:	854e                	mv	a0,s3
    800039ae:	fffff097          	auipc	ra,0xfffff
    800039b2:	2da080e7          	jalr	730(ra) # 80002c88 <iput>
    end_op();
    800039b6:	00000097          	auipc	ra,0x0
    800039ba:	b38080e7          	jalr	-1224(ra) # 800034ee <end_op>
    800039be:	a00d                	j	800039e0 <fileclose+0xa8>
    panic("fileclose");
    800039c0:	00005517          	auipc	a0,0x5
    800039c4:	c5850513          	addi	a0,a0,-936 # 80008618 <syscalls+0x248>
    800039c8:	00002097          	auipc	ra,0x2
    800039cc:	15e080e7          	jalr	350(ra) # 80005b26 <panic>
    release(&ftable.lock);
    800039d0:	00015517          	auipc	a0,0x15
    800039d4:	04850513          	addi	a0,a0,72 # 80018a18 <ftable>
    800039d8:	00002097          	auipc	ra,0x2
    800039dc:	73a080e7          	jalr	1850(ra) # 80006112 <release>
  }
}
    800039e0:	70e2                	ld	ra,56(sp)
    800039e2:	7442                	ld	s0,48(sp)
    800039e4:	74a2                	ld	s1,40(sp)
    800039e6:	7902                	ld	s2,32(sp)
    800039e8:	69e2                	ld	s3,24(sp)
    800039ea:	6a42                	ld	s4,16(sp)
    800039ec:	6aa2                	ld	s5,8(sp)
    800039ee:	6121                	addi	sp,sp,64
    800039f0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800039f2:	85d6                	mv	a1,s5
    800039f4:	8552                	mv	a0,s4
    800039f6:	00000097          	auipc	ra,0x0
    800039fa:	348080e7          	jalr	840(ra) # 80003d3e <pipeclose>
    800039fe:	b7cd                	j	800039e0 <fileclose+0xa8>

0000000080003a00 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a00:	715d                	addi	sp,sp,-80
    80003a02:	e486                	sd	ra,72(sp)
    80003a04:	e0a2                	sd	s0,64(sp)
    80003a06:	fc26                	sd	s1,56(sp)
    80003a08:	f84a                	sd	s2,48(sp)
    80003a0a:	f44e                	sd	s3,40(sp)
    80003a0c:	0880                	addi	s0,sp,80
    80003a0e:	84aa                	mv	s1,a0
    80003a10:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a12:	ffffd097          	auipc	ra,0xffffd
    80003a16:	440080e7          	jalr	1088(ra) # 80000e52 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a1a:	409c                	lw	a5,0(s1)
    80003a1c:	37f9                	addiw	a5,a5,-2
    80003a1e:	4705                	li	a4,1
    80003a20:	04f76763          	bltu	a4,a5,80003a6e <filestat+0x6e>
    80003a24:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a26:	6c88                	ld	a0,24(s1)
    80003a28:	fffff097          	auipc	ra,0xfffff
    80003a2c:	0a6080e7          	jalr	166(ra) # 80002ace <ilock>
    stati(f->ip, &st);
    80003a30:	fb840593          	addi	a1,s0,-72
    80003a34:	6c88                	ld	a0,24(s1)
    80003a36:	fffff097          	auipc	ra,0xfffff
    80003a3a:	322080e7          	jalr	802(ra) # 80002d58 <stati>
    iunlock(f->ip);
    80003a3e:	6c88                	ld	a0,24(s1)
    80003a40:	fffff097          	auipc	ra,0xfffff
    80003a44:	150080e7          	jalr	336(ra) # 80002b90 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a48:	46e1                	li	a3,24
    80003a4a:	fb840613          	addi	a2,s0,-72
    80003a4e:	85ce                	mv	a1,s3
    80003a50:	05093503          	ld	a0,80(s2)
    80003a54:	ffffd097          	auipc	ra,0xffffd
    80003a58:	0be080e7          	jalr	190(ra) # 80000b12 <copyout>
    80003a5c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a60:	60a6                	ld	ra,72(sp)
    80003a62:	6406                	ld	s0,64(sp)
    80003a64:	74e2                	ld	s1,56(sp)
    80003a66:	7942                	ld	s2,48(sp)
    80003a68:	79a2                	ld	s3,40(sp)
    80003a6a:	6161                	addi	sp,sp,80
    80003a6c:	8082                	ret
  return -1;
    80003a6e:	557d                	li	a0,-1
    80003a70:	bfc5                	j	80003a60 <filestat+0x60>

0000000080003a72 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003a72:	7179                	addi	sp,sp,-48
    80003a74:	f406                	sd	ra,40(sp)
    80003a76:	f022                	sd	s0,32(sp)
    80003a78:	ec26                	sd	s1,24(sp)
    80003a7a:	e84a                	sd	s2,16(sp)
    80003a7c:	e44e                	sd	s3,8(sp)
    80003a7e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003a80:	00854783          	lbu	a5,8(a0)
    80003a84:	c3d5                	beqz	a5,80003b28 <fileread+0xb6>
    80003a86:	84aa                	mv	s1,a0
    80003a88:	89ae                	mv	s3,a1
    80003a8a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003a8c:	411c                	lw	a5,0(a0)
    80003a8e:	4705                	li	a4,1
    80003a90:	04e78963          	beq	a5,a4,80003ae2 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003a94:	470d                	li	a4,3
    80003a96:	04e78d63          	beq	a5,a4,80003af0 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003a9a:	4709                	li	a4,2
    80003a9c:	06e79e63          	bne	a5,a4,80003b18 <fileread+0xa6>
    ilock(f->ip);
    80003aa0:	6d08                	ld	a0,24(a0)
    80003aa2:	fffff097          	auipc	ra,0xfffff
    80003aa6:	02c080e7          	jalr	44(ra) # 80002ace <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003aaa:	874a                	mv	a4,s2
    80003aac:	5094                	lw	a3,32(s1)
    80003aae:	864e                	mv	a2,s3
    80003ab0:	4585                	li	a1,1
    80003ab2:	6c88                	ld	a0,24(s1)
    80003ab4:	fffff097          	auipc	ra,0xfffff
    80003ab8:	2ce080e7          	jalr	718(ra) # 80002d82 <readi>
    80003abc:	892a                	mv	s2,a0
    80003abe:	00a05563          	blez	a0,80003ac8 <fileread+0x56>
      f->off += r;
    80003ac2:	509c                	lw	a5,32(s1)
    80003ac4:	9fa9                	addw	a5,a5,a0
    80003ac6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ac8:	6c88                	ld	a0,24(s1)
    80003aca:	fffff097          	auipc	ra,0xfffff
    80003ace:	0c6080e7          	jalr	198(ra) # 80002b90 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003ad2:	854a                	mv	a0,s2
    80003ad4:	70a2                	ld	ra,40(sp)
    80003ad6:	7402                	ld	s0,32(sp)
    80003ad8:	64e2                	ld	s1,24(sp)
    80003ada:	6942                	ld	s2,16(sp)
    80003adc:	69a2                	ld	s3,8(sp)
    80003ade:	6145                	addi	sp,sp,48
    80003ae0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ae2:	6908                	ld	a0,16(a0)
    80003ae4:	00000097          	auipc	ra,0x0
    80003ae8:	3c2080e7          	jalr	962(ra) # 80003ea6 <piperead>
    80003aec:	892a                	mv	s2,a0
    80003aee:	b7d5                	j	80003ad2 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003af0:	02451783          	lh	a5,36(a0)
    80003af4:	03079693          	slli	a3,a5,0x30
    80003af8:	92c1                	srli	a3,a3,0x30
    80003afa:	4725                	li	a4,9
    80003afc:	02d76863          	bltu	a4,a3,80003b2c <fileread+0xba>
    80003b00:	0792                	slli	a5,a5,0x4
    80003b02:	00015717          	auipc	a4,0x15
    80003b06:	e7670713          	addi	a4,a4,-394 # 80018978 <devsw>
    80003b0a:	97ba                	add	a5,a5,a4
    80003b0c:	639c                	ld	a5,0(a5)
    80003b0e:	c38d                	beqz	a5,80003b30 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b10:	4505                	li	a0,1
    80003b12:	9782                	jalr	a5
    80003b14:	892a                	mv	s2,a0
    80003b16:	bf75                	j	80003ad2 <fileread+0x60>
    panic("fileread");
    80003b18:	00005517          	auipc	a0,0x5
    80003b1c:	b1050513          	addi	a0,a0,-1264 # 80008628 <syscalls+0x258>
    80003b20:	00002097          	auipc	ra,0x2
    80003b24:	006080e7          	jalr	6(ra) # 80005b26 <panic>
    return -1;
    80003b28:	597d                	li	s2,-1
    80003b2a:	b765                	j	80003ad2 <fileread+0x60>
      return -1;
    80003b2c:	597d                	li	s2,-1
    80003b2e:	b755                	j	80003ad2 <fileread+0x60>
    80003b30:	597d                	li	s2,-1
    80003b32:	b745                	j	80003ad2 <fileread+0x60>

0000000080003b34 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003b34:	00954783          	lbu	a5,9(a0)
    80003b38:	10078e63          	beqz	a5,80003c54 <filewrite+0x120>
{
    80003b3c:	715d                	addi	sp,sp,-80
    80003b3e:	e486                	sd	ra,72(sp)
    80003b40:	e0a2                	sd	s0,64(sp)
    80003b42:	fc26                	sd	s1,56(sp)
    80003b44:	f84a                	sd	s2,48(sp)
    80003b46:	f44e                	sd	s3,40(sp)
    80003b48:	f052                	sd	s4,32(sp)
    80003b4a:	ec56                	sd	s5,24(sp)
    80003b4c:	e85a                	sd	s6,16(sp)
    80003b4e:	e45e                	sd	s7,8(sp)
    80003b50:	e062                	sd	s8,0(sp)
    80003b52:	0880                	addi	s0,sp,80
    80003b54:	892a                	mv	s2,a0
    80003b56:	8b2e                	mv	s6,a1
    80003b58:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b5a:	411c                	lw	a5,0(a0)
    80003b5c:	4705                	li	a4,1
    80003b5e:	02e78263          	beq	a5,a4,80003b82 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b62:	470d                	li	a4,3
    80003b64:	02e78563          	beq	a5,a4,80003b8e <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b68:	4709                	li	a4,2
    80003b6a:	0ce79d63          	bne	a5,a4,80003c44 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003b6e:	0ac05b63          	blez	a2,80003c24 <filewrite+0xf0>
    int i = 0;
    80003b72:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003b74:	6b85                	lui	s7,0x1
    80003b76:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003b7a:	6c05                	lui	s8,0x1
    80003b7c:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003b80:	a851                	j	80003c14 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003b82:	6908                	ld	a0,16(a0)
    80003b84:	00000097          	auipc	ra,0x0
    80003b88:	22a080e7          	jalr	554(ra) # 80003dae <pipewrite>
    80003b8c:	a045                	j	80003c2c <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003b8e:	02451783          	lh	a5,36(a0)
    80003b92:	03079693          	slli	a3,a5,0x30
    80003b96:	92c1                	srli	a3,a3,0x30
    80003b98:	4725                	li	a4,9
    80003b9a:	0ad76f63          	bltu	a4,a3,80003c58 <filewrite+0x124>
    80003b9e:	0792                	slli	a5,a5,0x4
    80003ba0:	00015717          	auipc	a4,0x15
    80003ba4:	dd870713          	addi	a4,a4,-552 # 80018978 <devsw>
    80003ba8:	97ba                	add	a5,a5,a4
    80003baa:	679c                	ld	a5,8(a5)
    80003bac:	cbc5                	beqz	a5,80003c5c <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003bae:	4505                	li	a0,1
    80003bb0:	9782                	jalr	a5
    80003bb2:	a8ad                	j	80003c2c <filewrite+0xf8>
      if(n1 > max)
    80003bb4:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003bb8:	00000097          	auipc	ra,0x0
    80003bbc:	8bc080e7          	jalr	-1860(ra) # 80003474 <begin_op>
      ilock(f->ip);
    80003bc0:	01893503          	ld	a0,24(s2)
    80003bc4:	fffff097          	auipc	ra,0xfffff
    80003bc8:	f0a080e7          	jalr	-246(ra) # 80002ace <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003bcc:	8756                	mv	a4,s5
    80003bce:	02092683          	lw	a3,32(s2)
    80003bd2:	01698633          	add	a2,s3,s6
    80003bd6:	4585                	li	a1,1
    80003bd8:	01893503          	ld	a0,24(s2)
    80003bdc:	fffff097          	auipc	ra,0xfffff
    80003be0:	29e080e7          	jalr	670(ra) # 80002e7a <writei>
    80003be4:	84aa                	mv	s1,a0
    80003be6:	00a05763          	blez	a0,80003bf4 <filewrite+0xc0>
        f->off += r;
    80003bea:	02092783          	lw	a5,32(s2)
    80003bee:	9fa9                	addw	a5,a5,a0
    80003bf0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003bf4:	01893503          	ld	a0,24(s2)
    80003bf8:	fffff097          	auipc	ra,0xfffff
    80003bfc:	f98080e7          	jalr	-104(ra) # 80002b90 <iunlock>
      end_op();
    80003c00:	00000097          	auipc	ra,0x0
    80003c04:	8ee080e7          	jalr	-1810(ra) # 800034ee <end_op>

      if(r != n1){
    80003c08:	009a9f63          	bne	s5,s1,80003c26 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003c0c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c10:	0149db63          	bge	s3,s4,80003c26 <filewrite+0xf2>
      int n1 = n - i;
    80003c14:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003c18:	0004879b          	sext.w	a5,s1
    80003c1c:	f8fbdce3          	bge	s7,a5,80003bb4 <filewrite+0x80>
    80003c20:	84e2                	mv	s1,s8
    80003c22:	bf49                	j	80003bb4 <filewrite+0x80>
    int i = 0;
    80003c24:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c26:	033a1d63          	bne	s4,s3,80003c60 <filewrite+0x12c>
    80003c2a:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c2c:	60a6                	ld	ra,72(sp)
    80003c2e:	6406                	ld	s0,64(sp)
    80003c30:	74e2                	ld	s1,56(sp)
    80003c32:	7942                	ld	s2,48(sp)
    80003c34:	79a2                	ld	s3,40(sp)
    80003c36:	7a02                	ld	s4,32(sp)
    80003c38:	6ae2                	ld	s5,24(sp)
    80003c3a:	6b42                	ld	s6,16(sp)
    80003c3c:	6ba2                	ld	s7,8(sp)
    80003c3e:	6c02                	ld	s8,0(sp)
    80003c40:	6161                	addi	sp,sp,80
    80003c42:	8082                	ret
    panic("filewrite");
    80003c44:	00005517          	auipc	a0,0x5
    80003c48:	9f450513          	addi	a0,a0,-1548 # 80008638 <syscalls+0x268>
    80003c4c:	00002097          	auipc	ra,0x2
    80003c50:	eda080e7          	jalr	-294(ra) # 80005b26 <panic>
    return -1;
    80003c54:	557d                	li	a0,-1
}
    80003c56:	8082                	ret
      return -1;
    80003c58:	557d                	li	a0,-1
    80003c5a:	bfc9                	j	80003c2c <filewrite+0xf8>
    80003c5c:	557d                	li	a0,-1
    80003c5e:	b7f9                	j	80003c2c <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003c60:	557d                	li	a0,-1
    80003c62:	b7e9                	j	80003c2c <filewrite+0xf8>

0000000080003c64 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003c64:	7179                	addi	sp,sp,-48
    80003c66:	f406                	sd	ra,40(sp)
    80003c68:	f022                	sd	s0,32(sp)
    80003c6a:	ec26                	sd	s1,24(sp)
    80003c6c:	e84a                	sd	s2,16(sp)
    80003c6e:	e44e                	sd	s3,8(sp)
    80003c70:	e052                	sd	s4,0(sp)
    80003c72:	1800                	addi	s0,sp,48
    80003c74:	84aa                	mv	s1,a0
    80003c76:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003c78:	0005b023          	sd	zero,0(a1)
    80003c7c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003c80:	00000097          	auipc	ra,0x0
    80003c84:	bfc080e7          	jalr	-1028(ra) # 8000387c <filealloc>
    80003c88:	e088                	sd	a0,0(s1)
    80003c8a:	c551                	beqz	a0,80003d16 <pipealloc+0xb2>
    80003c8c:	00000097          	auipc	ra,0x0
    80003c90:	bf0080e7          	jalr	-1040(ra) # 8000387c <filealloc>
    80003c94:	00aa3023          	sd	a0,0(s4)
    80003c98:	c92d                	beqz	a0,80003d0a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003c9a:	ffffc097          	auipc	ra,0xffffc
    80003c9e:	480080e7          	jalr	1152(ra) # 8000011a <kalloc>
    80003ca2:	892a                	mv	s2,a0
    80003ca4:	c125                	beqz	a0,80003d04 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ca6:	4985                	li	s3,1
    80003ca8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003cac:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003cb0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003cb4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003cb8:	00005597          	auipc	a1,0x5
    80003cbc:	99058593          	addi	a1,a1,-1648 # 80008648 <syscalls+0x278>
    80003cc0:	00002097          	auipc	ra,0x2
    80003cc4:	30e080e7          	jalr	782(ra) # 80005fce <initlock>
  (*f0)->type = FD_PIPE;
    80003cc8:	609c                	ld	a5,0(s1)
    80003cca:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003cce:	609c                	ld	a5,0(s1)
    80003cd0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003cd4:	609c                	ld	a5,0(s1)
    80003cd6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003cda:	609c                	ld	a5,0(s1)
    80003cdc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ce0:	000a3783          	ld	a5,0(s4)
    80003ce4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ce8:	000a3783          	ld	a5,0(s4)
    80003cec:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003cf0:	000a3783          	ld	a5,0(s4)
    80003cf4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003cf8:	000a3783          	ld	a5,0(s4)
    80003cfc:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d00:	4501                	li	a0,0
    80003d02:	a025                	j	80003d2a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d04:	6088                	ld	a0,0(s1)
    80003d06:	e501                	bnez	a0,80003d0e <pipealloc+0xaa>
    80003d08:	a039                	j	80003d16 <pipealloc+0xb2>
    80003d0a:	6088                	ld	a0,0(s1)
    80003d0c:	c51d                	beqz	a0,80003d3a <pipealloc+0xd6>
    fileclose(*f0);
    80003d0e:	00000097          	auipc	ra,0x0
    80003d12:	c2a080e7          	jalr	-982(ra) # 80003938 <fileclose>
  if(*f1)
    80003d16:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d1a:	557d                	li	a0,-1
  if(*f1)
    80003d1c:	c799                	beqz	a5,80003d2a <pipealloc+0xc6>
    fileclose(*f1);
    80003d1e:	853e                	mv	a0,a5
    80003d20:	00000097          	auipc	ra,0x0
    80003d24:	c18080e7          	jalr	-1000(ra) # 80003938 <fileclose>
  return -1;
    80003d28:	557d                	li	a0,-1
}
    80003d2a:	70a2                	ld	ra,40(sp)
    80003d2c:	7402                	ld	s0,32(sp)
    80003d2e:	64e2                	ld	s1,24(sp)
    80003d30:	6942                	ld	s2,16(sp)
    80003d32:	69a2                	ld	s3,8(sp)
    80003d34:	6a02                	ld	s4,0(sp)
    80003d36:	6145                	addi	sp,sp,48
    80003d38:	8082                	ret
  return -1;
    80003d3a:	557d                	li	a0,-1
    80003d3c:	b7fd                	j	80003d2a <pipealloc+0xc6>

0000000080003d3e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d3e:	1101                	addi	sp,sp,-32
    80003d40:	ec06                	sd	ra,24(sp)
    80003d42:	e822                	sd	s0,16(sp)
    80003d44:	e426                	sd	s1,8(sp)
    80003d46:	e04a                	sd	s2,0(sp)
    80003d48:	1000                	addi	s0,sp,32
    80003d4a:	84aa                	mv	s1,a0
    80003d4c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d4e:	00002097          	auipc	ra,0x2
    80003d52:	310080e7          	jalr	784(ra) # 8000605e <acquire>
  if(writable){
    80003d56:	02090d63          	beqz	s2,80003d90 <pipeclose+0x52>
    pi->writeopen = 0;
    80003d5a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d5e:	21848513          	addi	a0,s1,536
    80003d62:	ffffd097          	auipc	ra,0xffffd
    80003d66:	7fc080e7          	jalr	2044(ra) # 8000155e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003d6a:	2204b783          	ld	a5,544(s1)
    80003d6e:	eb95                	bnez	a5,80003da2 <pipeclose+0x64>
    release(&pi->lock);
    80003d70:	8526                	mv	a0,s1
    80003d72:	00002097          	auipc	ra,0x2
    80003d76:	3a0080e7          	jalr	928(ra) # 80006112 <release>
    kfree((char*)pi);
    80003d7a:	8526                	mv	a0,s1
    80003d7c:	ffffc097          	auipc	ra,0xffffc
    80003d80:	2a0080e7          	jalr	672(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003d84:	60e2                	ld	ra,24(sp)
    80003d86:	6442                	ld	s0,16(sp)
    80003d88:	64a2                	ld	s1,8(sp)
    80003d8a:	6902                	ld	s2,0(sp)
    80003d8c:	6105                	addi	sp,sp,32
    80003d8e:	8082                	ret
    pi->readopen = 0;
    80003d90:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003d94:	21c48513          	addi	a0,s1,540
    80003d98:	ffffd097          	auipc	ra,0xffffd
    80003d9c:	7c6080e7          	jalr	1990(ra) # 8000155e <wakeup>
    80003da0:	b7e9                	j	80003d6a <pipeclose+0x2c>
    release(&pi->lock);
    80003da2:	8526                	mv	a0,s1
    80003da4:	00002097          	auipc	ra,0x2
    80003da8:	36e080e7          	jalr	878(ra) # 80006112 <release>
}
    80003dac:	bfe1                	j	80003d84 <pipeclose+0x46>

0000000080003dae <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003dae:	711d                	addi	sp,sp,-96
    80003db0:	ec86                	sd	ra,88(sp)
    80003db2:	e8a2                	sd	s0,80(sp)
    80003db4:	e4a6                	sd	s1,72(sp)
    80003db6:	e0ca                	sd	s2,64(sp)
    80003db8:	fc4e                	sd	s3,56(sp)
    80003dba:	f852                	sd	s4,48(sp)
    80003dbc:	f456                	sd	s5,40(sp)
    80003dbe:	f05a                	sd	s6,32(sp)
    80003dc0:	ec5e                	sd	s7,24(sp)
    80003dc2:	e862                	sd	s8,16(sp)
    80003dc4:	1080                	addi	s0,sp,96
    80003dc6:	84aa                	mv	s1,a0
    80003dc8:	8aae                	mv	s5,a1
    80003dca:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003dcc:	ffffd097          	auipc	ra,0xffffd
    80003dd0:	086080e7          	jalr	134(ra) # 80000e52 <myproc>
    80003dd4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003dd6:	8526                	mv	a0,s1
    80003dd8:	00002097          	auipc	ra,0x2
    80003ddc:	286080e7          	jalr	646(ra) # 8000605e <acquire>
  while(i < n){
    80003de0:	0b405663          	blez	s4,80003e8c <pipewrite+0xde>
  int i = 0;
    80003de4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003de6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003de8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003dec:	21c48b93          	addi	s7,s1,540
    80003df0:	a089                	j	80003e32 <pipewrite+0x84>
      release(&pi->lock);
    80003df2:	8526                	mv	a0,s1
    80003df4:	00002097          	auipc	ra,0x2
    80003df8:	31e080e7          	jalr	798(ra) # 80006112 <release>
      return -1;
    80003dfc:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003dfe:	854a                	mv	a0,s2
    80003e00:	60e6                	ld	ra,88(sp)
    80003e02:	6446                	ld	s0,80(sp)
    80003e04:	64a6                	ld	s1,72(sp)
    80003e06:	6906                	ld	s2,64(sp)
    80003e08:	79e2                	ld	s3,56(sp)
    80003e0a:	7a42                	ld	s4,48(sp)
    80003e0c:	7aa2                	ld	s5,40(sp)
    80003e0e:	7b02                	ld	s6,32(sp)
    80003e10:	6be2                	ld	s7,24(sp)
    80003e12:	6c42                	ld	s8,16(sp)
    80003e14:	6125                	addi	sp,sp,96
    80003e16:	8082                	ret
      wakeup(&pi->nread);
    80003e18:	8562                	mv	a0,s8
    80003e1a:	ffffd097          	auipc	ra,0xffffd
    80003e1e:	744080e7          	jalr	1860(ra) # 8000155e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e22:	85a6                	mv	a1,s1
    80003e24:	855e                	mv	a0,s7
    80003e26:	ffffd097          	auipc	ra,0xffffd
    80003e2a:	6d4080e7          	jalr	1748(ra) # 800014fa <sleep>
  while(i < n){
    80003e2e:	07495063          	bge	s2,s4,80003e8e <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003e32:	2204a783          	lw	a5,544(s1)
    80003e36:	dfd5                	beqz	a5,80003df2 <pipewrite+0x44>
    80003e38:	854e                	mv	a0,s3
    80003e3a:	ffffe097          	auipc	ra,0xffffe
    80003e3e:	968080e7          	jalr	-1688(ra) # 800017a2 <killed>
    80003e42:	f945                	bnez	a0,80003df2 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e44:	2184a783          	lw	a5,536(s1)
    80003e48:	21c4a703          	lw	a4,540(s1)
    80003e4c:	2007879b          	addiw	a5,a5,512
    80003e50:	fcf704e3          	beq	a4,a5,80003e18 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e54:	4685                	li	a3,1
    80003e56:	01590633          	add	a2,s2,s5
    80003e5a:	faf40593          	addi	a1,s0,-81
    80003e5e:	0509b503          	ld	a0,80(s3)
    80003e62:	ffffd097          	auipc	ra,0xffffd
    80003e66:	d3c080e7          	jalr	-708(ra) # 80000b9e <copyin>
    80003e6a:	03650263          	beq	a0,s6,80003e8e <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003e6e:	21c4a783          	lw	a5,540(s1)
    80003e72:	0017871b          	addiw	a4,a5,1
    80003e76:	20e4ae23          	sw	a4,540(s1)
    80003e7a:	1ff7f793          	andi	a5,a5,511
    80003e7e:	97a6                	add	a5,a5,s1
    80003e80:	faf44703          	lbu	a4,-81(s0)
    80003e84:	00e78c23          	sb	a4,24(a5)
      i++;
    80003e88:	2905                	addiw	s2,s2,1
    80003e8a:	b755                	j	80003e2e <pipewrite+0x80>
  int i = 0;
    80003e8c:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003e8e:	21848513          	addi	a0,s1,536
    80003e92:	ffffd097          	auipc	ra,0xffffd
    80003e96:	6cc080e7          	jalr	1740(ra) # 8000155e <wakeup>
  release(&pi->lock);
    80003e9a:	8526                	mv	a0,s1
    80003e9c:	00002097          	auipc	ra,0x2
    80003ea0:	276080e7          	jalr	630(ra) # 80006112 <release>
  return i;
    80003ea4:	bfa9                	j	80003dfe <pipewrite+0x50>

0000000080003ea6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ea6:	715d                	addi	sp,sp,-80
    80003ea8:	e486                	sd	ra,72(sp)
    80003eaa:	e0a2                	sd	s0,64(sp)
    80003eac:	fc26                	sd	s1,56(sp)
    80003eae:	f84a                	sd	s2,48(sp)
    80003eb0:	f44e                	sd	s3,40(sp)
    80003eb2:	f052                	sd	s4,32(sp)
    80003eb4:	ec56                	sd	s5,24(sp)
    80003eb6:	e85a                	sd	s6,16(sp)
    80003eb8:	0880                	addi	s0,sp,80
    80003eba:	84aa                	mv	s1,a0
    80003ebc:	892e                	mv	s2,a1
    80003ebe:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003ec0:	ffffd097          	auipc	ra,0xffffd
    80003ec4:	f92080e7          	jalr	-110(ra) # 80000e52 <myproc>
    80003ec8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003eca:	8526                	mv	a0,s1
    80003ecc:	00002097          	auipc	ra,0x2
    80003ed0:	192080e7          	jalr	402(ra) # 8000605e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ed4:	2184a703          	lw	a4,536(s1)
    80003ed8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003edc:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ee0:	02f71763          	bne	a4,a5,80003f0e <piperead+0x68>
    80003ee4:	2244a783          	lw	a5,548(s1)
    80003ee8:	c39d                	beqz	a5,80003f0e <piperead+0x68>
    if(killed(pr)){
    80003eea:	8552                	mv	a0,s4
    80003eec:	ffffe097          	auipc	ra,0xffffe
    80003ef0:	8b6080e7          	jalr	-1866(ra) # 800017a2 <killed>
    80003ef4:	e949                	bnez	a0,80003f86 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ef6:	85a6                	mv	a1,s1
    80003ef8:	854e                	mv	a0,s3
    80003efa:	ffffd097          	auipc	ra,0xffffd
    80003efe:	600080e7          	jalr	1536(ra) # 800014fa <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f02:	2184a703          	lw	a4,536(s1)
    80003f06:	21c4a783          	lw	a5,540(s1)
    80003f0a:	fcf70de3          	beq	a4,a5,80003ee4 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f0e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f10:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f12:	05505463          	blez	s5,80003f5a <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80003f16:	2184a783          	lw	a5,536(s1)
    80003f1a:	21c4a703          	lw	a4,540(s1)
    80003f1e:	02f70e63          	beq	a4,a5,80003f5a <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f22:	0017871b          	addiw	a4,a5,1
    80003f26:	20e4ac23          	sw	a4,536(s1)
    80003f2a:	1ff7f793          	andi	a5,a5,511
    80003f2e:	97a6                	add	a5,a5,s1
    80003f30:	0187c783          	lbu	a5,24(a5)
    80003f34:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f38:	4685                	li	a3,1
    80003f3a:	fbf40613          	addi	a2,s0,-65
    80003f3e:	85ca                	mv	a1,s2
    80003f40:	050a3503          	ld	a0,80(s4)
    80003f44:	ffffd097          	auipc	ra,0xffffd
    80003f48:	bce080e7          	jalr	-1074(ra) # 80000b12 <copyout>
    80003f4c:	01650763          	beq	a0,s6,80003f5a <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f50:	2985                	addiw	s3,s3,1
    80003f52:	0905                	addi	s2,s2,1
    80003f54:	fd3a91e3          	bne	s5,s3,80003f16 <piperead+0x70>
    80003f58:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f5a:	21c48513          	addi	a0,s1,540
    80003f5e:	ffffd097          	auipc	ra,0xffffd
    80003f62:	600080e7          	jalr	1536(ra) # 8000155e <wakeup>
  release(&pi->lock);
    80003f66:	8526                	mv	a0,s1
    80003f68:	00002097          	auipc	ra,0x2
    80003f6c:	1aa080e7          	jalr	426(ra) # 80006112 <release>
  return i;
}
    80003f70:	854e                	mv	a0,s3
    80003f72:	60a6                	ld	ra,72(sp)
    80003f74:	6406                	ld	s0,64(sp)
    80003f76:	74e2                	ld	s1,56(sp)
    80003f78:	7942                	ld	s2,48(sp)
    80003f7a:	79a2                	ld	s3,40(sp)
    80003f7c:	7a02                	ld	s4,32(sp)
    80003f7e:	6ae2                	ld	s5,24(sp)
    80003f80:	6b42                	ld	s6,16(sp)
    80003f82:	6161                	addi	sp,sp,80
    80003f84:	8082                	ret
      release(&pi->lock);
    80003f86:	8526                	mv	a0,s1
    80003f88:	00002097          	auipc	ra,0x2
    80003f8c:	18a080e7          	jalr	394(ra) # 80006112 <release>
      return -1;
    80003f90:	59fd                	li	s3,-1
    80003f92:	bff9                	j	80003f70 <piperead+0xca>

0000000080003f94 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003f94:	1141                	addi	sp,sp,-16
    80003f96:	e422                	sd	s0,8(sp)
    80003f98:	0800                	addi	s0,sp,16
    80003f9a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003f9c:	8905                	andi	a0,a0,1
    80003f9e:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003fa0:	8b89                	andi	a5,a5,2
    80003fa2:	c399                	beqz	a5,80003fa8 <flags2perm+0x14>
      perm |= PTE_W;
    80003fa4:	00456513          	ori	a0,a0,4
    return perm;
}
    80003fa8:	6422                	ld	s0,8(sp)
    80003faa:	0141                	addi	sp,sp,16
    80003fac:	8082                	ret

0000000080003fae <exec>:

int
exec(char *path, char **argv)
{
    80003fae:	df010113          	addi	sp,sp,-528
    80003fb2:	20113423          	sd	ra,520(sp)
    80003fb6:	20813023          	sd	s0,512(sp)
    80003fba:	ffa6                	sd	s1,504(sp)
    80003fbc:	fbca                	sd	s2,496(sp)
    80003fbe:	f7ce                	sd	s3,488(sp)
    80003fc0:	f3d2                	sd	s4,480(sp)
    80003fc2:	efd6                	sd	s5,472(sp)
    80003fc4:	ebda                	sd	s6,464(sp)
    80003fc6:	e7de                	sd	s7,456(sp)
    80003fc8:	e3e2                	sd	s8,448(sp)
    80003fca:	ff66                	sd	s9,440(sp)
    80003fcc:	fb6a                	sd	s10,432(sp)
    80003fce:	f76e                	sd	s11,424(sp)
    80003fd0:	0c00                	addi	s0,sp,528
    80003fd2:	892a                	mv	s2,a0
    80003fd4:	dea43c23          	sd	a0,-520(s0)
    80003fd8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003fdc:	ffffd097          	auipc	ra,0xffffd
    80003fe0:	e76080e7          	jalr	-394(ra) # 80000e52 <myproc>
    80003fe4:	84aa                	mv	s1,a0

  begin_op();
    80003fe6:	fffff097          	auipc	ra,0xfffff
    80003fea:	48e080e7          	jalr	1166(ra) # 80003474 <begin_op>

  if((ip = namei(path)) == 0){
    80003fee:	854a                	mv	a0,s2
    80003ff0:	fffff097          	auipc	ra,0xfffff
    80003ff4:	284080e7          	jalr	644(ra) # 80003274 <namei>
    80003ff8:	c92d                	beqz	a0,8000406a <exec+0xbc>
    80003ffa:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003ffc:	fffff097          	auipc	ra,0xfffff
    80004000:	ad2080e7          	jalr	-1326(ra) # 80002ace <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004004:	04000713          	li	a4,64
    80004008:	4681                	li	a3,0
    8000400a:	e5040613          	addi	a2,s0,-432
    8000400e:	4581                	li	a1,0
    80004010:	8552                	mv	a0,s4
    80004012:	fffff097          	auipc	ra,0xfffff
    80004016:	d70080e7          	jalr	-656(ra) # 80002d82 <readi>
    8000401a:	04000793          	li	a5,64
    8000401e:	00f51a63          	bne	a0,a5,80004032 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004022:	e5042703          	lw	a4,-432(s0)
    80004026:	464c47b7          	lui	a5,0x464c4
    8000402a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000402e:	04f70463          	beq	a4,a5,80004076 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004032:	8552                	mv	a0,s4
    80004034:	fffff097          	auipc	ra,0xfffff
    80004038:	cfc080e7          	jalr	-772(ra) # 80002d30 <iunlockput>
    end_op();
    8000403c:	fffff097          	auipc	ra,0xfffff
    80004040:	4b2080e7          	jalr	1202(ra) # 800034ee <end_op>
  }
  return -1;
    80004044:	557d                	li	a0,-1
}
    80004046:	20813083          	ld	ra,520(sp)
    8000404a:	20013403          	ld	s0,512(sp)
    8000404e:	74fe                	ld	s1,504(sp)
    80004050:	795e                	ld	s2,496(sp)
    80004052:	79be                	ld	s3,488(sp)
    80004054:	7a1e                	ld	s4,480(sp)
    80004056:	6afe                	ld	s5,472(sp)
    80004058:	6b5e                	ld	s6,464(sp)
    8000405a:	6bbe                	ld	s7,456(sp)
    8000405c:	6c1e                	ld	s8,448(sp)
    8000405e:	7cfa                	ld	s9,440(sp)
    80004060:	7d5a                	ld	s10,432(sp)
    80004062:	7dba                	ld	s11,424(sp)
    80004064:	21010113          	addi	sp,sp,528
    80004068:	8082                	ret
    end_op();
    8000406a:	fffff097          	auipc	ra,0xfffff
    8000406e:	484080e7          	jalr	1156(ra) # 800034ee <end_op>
    return -1;
    80004072:	557d                	li	a0,-1
    80004074:	bfc9                	j	80004046 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004076:	8526                	mv	a0,s1
    80004078:	ffffd097          	auipc	ra,0xffffd
    8000407c:	e9e080e7          	jalr	-354(ra) # 80000f16 <proc_pagetable>
    80004080:	8b2a                	mv	s6,a0
    80004082:	d945                	beqz	a0,80004032 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004084:	e7042d03          	lw	s10,-400(s0)
    80004088:	e8845783          	lhu	a5,-376(s0)
    8000408c:	10078463          	beqz	a5,80004194 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004090:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004092:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004094:	6c85                	lui	s9,0x1
    80004096:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000409a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000409e:	6a85                	lui	s5,0x1
    800040a0:	a0b5                	j	8000410c <exec+0x15e>
      panic("loadseg: address should exist");
    800040a2:	00004517          	auipc	a0,0x4
    800040a6:	5ae50513          	addi	a0,a0,1454 # 80008650 <syscalls+0x280>
    800040aa:	00002097          	auipc	ra,0x2
    800040ae:	a7c080e7          	jalr	-1412(ra) # 80005b26 <panic>
    if(sz - i < PGSIZE)
    800040b2:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040b4:	8726                	mv	a4,s1
    800040b6:	012c06bb          	addw	a3,s8,s2
    800040ba:	4581                	li	a1,0
    800040bc:	8552                	mv	a0,s4
    800040be:	fffff097          	auipc	ra,0xfffff
    800040c2:	cc4080e7          	jalr	-828(ra) # 80002d82 <readi>
    800040c6:	2501                	sext.w	a0,a0
    800040c8:	24a49863          	bne	s1,a0,80004318 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    800040cc:	012a893b          	addw	s2,s5,s2
    800040d0:	03397563          	bgeu	s2,s3,800040fa <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    800040d4:	02091593          	slli	a1,s2,0x20
    800040d8:	9181                	srli	a1,a1,0x20
    800040da:	95de                	add	a1,a1,s7
    800040dc:	855a                	mv	a0,s6
    800040de:	ffffc097          	auipc	ra,0xffffc
    800040e2:	424080e7          	jalr	1060(ra) # 80000502 <walkaddr>
    800040e6:	862a                	mv	a2,a0
    if(pa == 0)
    800040e8:	dd4d                	beqz	a0,800040a2 <exec+0xf4>
    if(sz - i < PGSIZE)
    800040ea:	412984bb          	subw	s1,s3,s2
    800040ee:	0004879b          	sext.w	a5,s1
    800040f2:	fcfcf0e3          	bgeu	s9,a5,800040b2 <exec+0x104>
    800040f6:	84d6                	mv	s1,s5
    800040f8:	bf6d                	j	800040b2 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800040fa:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040fe:	2d85                	addiw	s11,s11,1
    80004100:	038d0d1b          	addiw	s10,s10,56
    80004104:	e8845783          	lhu	a5,-376(s0)
    80004108:	08fdd763          	bge	s11,a5,80004196 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000410c:	2d01                	sext.w	s10,s10
    8000410e:	03800713          	li	a4,56
    80004112:	86ea                	mv	a3,s10
    80004114:	e1840613          	addi	a2,s0,-488
    80004118:	4581                	li	a1,0
    8000411a:	8552                	mv	a0,s4
    8000411c:	fffff097          	auipc	ra,0xfffff
    80004120:	c66080e7          	jalr	-922(ra) # 80002d82 <readi>
    80004124:	03800793          	li	a5,56
    80004128:	1ef51663          	bne	a0,a5,80004314 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    8000412c:	e1842783          	lw	a5,-488(s0)
    80004130:	4705                	li	a4,1
    80004132:	fce796e3          	bne	a5,a4,800040fe <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004136:	e4043483          	ld	s1,-448(s0)
    8000413a:	e3843783          	ld	a5,-456(s0)
    8000413e:	1ef4e863          	bltu	s1,a5,8000432e <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004142:	e2843783          	ld	a5,-472(s0)
    80004146:	94be                	add	s1,s1,a5
    80004148:	1ef4e663          	bltu	s1,a5,80004334 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    8000414c:	df043703          	ld	a4,-528(s0)
    80004150:	8ff9                	and	a5,a5,a4
    80004152:	1e079463          	bnez	a5,8000433a <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004156:	e1c42503          	lw	a0,-484(s0)
    8000415a:	00000097          	auipc	ra,0x0
    8000415e:	e3a080e7          	jalr	-454(ra) # 80003f94 <flags2perm>
    80004162:	86aa                	mv	a3,a0
    80004164:	8626                	mv	a2,s1
    80004166:	85ca                	mv	a1,s2
    80004168:	855a                	mv	a0,s6
    8000416a:	ffffc097          	auipc	ra,0xffffc
    8000416e:	74c080e7          	jalr	1868(ra) # 800008b6 <uvmalloc>
    80004172:	e0a43423          	sd	a0,-504(s0)
    80004176:	1c050563          	beqz	a0,80004340 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000417a:	e2843b83          	ld	s7,-472(s0)
    8000417e:	e2042c03          	lw	s8,-480(s0)
    80004182:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004186:	00098463          	beqz	s3,8000418e <exec+0x1e0>
    8000418a:	4901                	li	s2,0
    8000418c:	b7a1                	j	800040d4 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000418e:	e0843903          	ld	s2,-504(s0)
    80004192:	b7b5                	j	800040fe <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004194:	4901                	li	s2,0
  iunlockput(ip);
    80004196:	8552                	mv	a0,s4
    80004198:	fffff097          	auipc	ra,0xfffff
    8000419c:	b98080e7          	jalr	-1128(ra) # 80002d30 <iunlockput>
  end_op();
    800041a0:	fffff097          	auipc	ra,0xfffff
    800041a4:	34e080e7          	jalr	846(ra) # 800034ee <end_op>
  p = myproc();
    800041a8:	ffffd097          	auipc	ra,0xffffd
    800041ac:	caa080e7          	jalr	-854(ra) # 80000e52 <myproc>
    800041b0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800041b2:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800041b6:	6985                	lui	s3,0x1
    800041b8:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800041ba:	99ca                	add	s3,s3,s2
    800041bc:	77fd                	lui	a5,0xfffff
    800041be:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041c2:	4691                	li	a3,4
    800041c4:	6609                	lui	a2,0x2
    800041c6:	964e                	add	a2,a2,s3
    800041c8:	85ce                	mv	a1,s3
    800041ca:	855a                	mv	a0,s6
    800041cc:	ffffc097          	auipc	ra,0xffffc
    800041d0:	6ea080e7          	jalr	1770(ra) # 800008b6 <uvmalloc>
    800041d4:	892a                	mv	s2,a0
    800041d6:	e0a43423          	sd	a0,-504(s0)
    800041da:	e509                	bnez	a0,800041e4 <exec+0x236>
  if(pagetable)
    800041dc:	e1343423          	sd	s3,-504(s0)
    800041e0:	4a01                	li	s4,0
    800041e2:	aa1d                	j	80004318 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041e4:	75f9                	lui	a1,0xffffe
    800041e6:	95aa                	add	a1,a1,a0
    800041e8:	855a                	mv	a0,s6
    800041ea:	ffffd097          	auipc	ra,0xffffd
    800041ee:	8f6080e7          	jalr	-1802(ra) # 80000ae0 <uvmclear>
  stackbase = sp - PGSIZE;
    800041f2:	7bfd                	lui	s7,0xfffff
    800041f4:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800041f6:	e0043783          	ld	a5,-512(s0)
    800041fa:	6388                	ld	a0,0(a5)
    800041fc:	c52d                	beqz	a0,80004266 <exec+0x2b8>
    800041fe:	e9040993          	addi	s3,s0,-368
    80004202:	f9040c13          	addi	s8,s0,-112
    80004206:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004208:	ffffc097          	auipc	ra,0xffffc
    8000420c:	0ec080e7          	jalr	236(ra) # 800002f4 <strlen>
    80004210:	0015079b          	addiw	a5,a0,1
    80004214:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004218:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000421c:	13796563          	bltu	s2,s7,80004346 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004220:	e0043d03          	ld	s10,-512(s0)
    80004224:	000d3a03          	ld	s4,0(s10)
    80004228:	8552                	mv	a0,s4
    8000422a:	ffffc097          	auipc	ra,0xffffc
    8000422e:	0ca080e7          	jalr	202(ra) # 800002f4 <strlen>
    80004232:	0015069b          	addiw	a3,a0,1
    80004236:	8652                	mv	a2,s4
    80004238:	85ca                	mv	a1,s2
    8000423a:	855a                	mv	a0,s6
    8000423c:	ffffd097          	auipc	ra,0xffffd
    80004240:	8d6080e7          	jalr	-1834(ra) # 80000b12 <copyout>
    80004244:	10054363          	bltz	a0,8000434a <exec+0x39c>
    ustack[argc] = sp;
    80004248:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000424c:	0485                	addi	s1,s1,1
    8000424e:	008d0793          	addi	a5,s10,8
    80004252:	e0f43023          	sd	a5,-512(s0)
    80004256:	008d3503          	ld	a0,8(s10)
    8000425a:	c909                	beqz	a0,8000426c <exec+0x2be>
    if(argc >= MAXARG)
    8000425c:	09a1                	addi	s3,s3,8
    8000425e:	fb8995e3          	bne	s3,s8,80004208 <exec+0x25a>
  ip = 0;
    80004262:	4a01                	li	s4,0
    80004264:	a855                	j	80004318 <exec+0x36a>
  sp = sz;
    80004266:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000426a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000426c:	00349793          	slli	a5,s1,0x3
    80004270:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdd240>
    80004274:	97a2                	add	a5,a5,s0
    80004276:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000427a:	00148693          	addi	a3,s1,1
    8000427e:	068e                	slli	a3,a3,0x3
    80004280:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004284:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004288:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000428c:	f57968e3          	bltu	s2,s7,800041dc <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004290:	e9040613          	addi	a2,s0,-368
    80004294:	85ca                	mv	a1,s2
    80004296:	855a                	mv	a0,s6
    80004298:	ffffd097          	auipc	ra,0xffffd
    8000429c:	87a080e7          	jalr	-1926(ra) # 80000b12 <copyout>
    800042a0:	0a054763          	bltz	a0,8000434e <exec+0x3a0>
  p->trapframe->a1 = sp;
    800042a4:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800042a8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042ac:	df843783          	ld	a5,-520(s0)
    800042b0:	0007c703          	lbu	a4,0(a5)
    800042b4:	cf11                	beqz	a4,800042d0 <exec+0x322>
    800042b6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042b8:	02f00693          	li	a3,47
    800042bc:	a039                	j	800042ca <exec+0x31c>
      last = s+1;
    800042be:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800042c2:	0785                	addi	a5,a5,1
    800042c4:	fff7c703          	lbu	a4,-1(a5)
    800042c8:	c701                	beqz	a4,800042d0 <exec+0x322>
    if(*s == '/')
    800042ca:	fed71ce3          	bne	a4,a3,800042c2 <exec+0x314>
    800042ce:	bfc5                	j	800042be <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    800042d0:	4641                	li	a2,16
    800042d2:	df843583          	ld	a1,-520(s0)
    800042d6:	158a8513          	addi	a0,s5,344
    800042da:	ffffc097          	auipc	ra,0xffffc
    800042de:	fe8080e7          	jalr	-24(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    800042e2:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800042e6:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800042ea:	e0843783          	ld	a5,-504(s0)
    800042ee:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800042f2:	058ab783          	ld	a5,88(s5)
    800042f6:	e6843703          	ld	a4,-408(s0)
    800042fa:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042fc:	058ab783          	ld	a5,88(s5)
    80004300:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004304:	85e6                	mv	a1,s9
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	cac080e7          	jalr	-852(ra) # 80000fb2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000430e:	0004851b          	sext.w	a0,s1
    80004312:	bb15                	j	80004046 <exec+0x98>
    80004314:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004318:	e0843583          	ld	a1,-504(s0)
    8000431c:	855a                	mv	a0,s6
    8000431e:	ffffd097          	auipc	ra,0xffffd
    80004322:	c94080e7          	jalr	-876(ra) # 80000fb2 <proc_freepagetable>
  return -1;
    80004326:	557d                	li	a0,-1
  if(ip){
    80004328:	d00a0fe3          	beqz	s4,80004046 <exec+0x98>
    8000432c:	b319                	j	80004032 <exec+0x84>
    8000432e:	e1243423          	sd	s2,-504(s0)
    80004332:	b7dd                	j	80004318 <exec+0x36a>
    80004334:	e1243423          	sd	s2,-504(s0)
    80004338:	b7c5                	j	80004318 <exec+0x36a>
    8000433a:	e1243423          	sd	s2,-504(s0)
    8000433e:	bfe9                	j	80004318 <exec+0x36a>
    80004340:	e1243423          	sd	s2,-504(s0)
    80004344:	bfd1                	j	80004318 <exec+0x36a>
  ip = 0;
    80004346:	4a01                	li	s4,0
    80004348:	bfc1                	j	80004318 <exec+0x36a>
    8000434a:	4a01                	li	s4,0
  if(pagetable)
    8000434c:	b7f1                	j	80004318 <exec+0x36a>
  sz = sz1;
    8000434e:	e0843983          	ld	s3,-504(s0)
    80004352:	b569                	j	800041dc <exec+0x22e>

0000000080004354 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004354:	7179                	addi	sp,sp,-48
    80004356:	f406                	sd	ra,40(sp)
    80004358:	f022                	sd	s0,32(sp)
    8000435a:	ec26                	sd	s1,24(sp)
    8000435c:	e84a                	sd	s2,16(sp)
    8000435e:	1800                	addi	s0,sp,48
    80004360:	892e                	mv	s2,a1
    80004362:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004364:	fdc40593          	addi	a1,s0,-36
    80004368:	ffffe097          	auipc	ra,0xffffe
    8000436c:	c04080e7          	jalr	-1020(ra) # 80001f6c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004370:	fdc42703          	lw	a4,-36(s0)
    80004374:	47bd                	li	a5,15
    80004376:	02e7eb63          	bltu	a5,a4,800043ac <argfd+0x58>
    8000437a:	ffffd097          	auipc	ra,0xffffd
    8000437e:	ad8080e7          	jalr	-1320(ra) # 80000e52 <myproc>
    80004382:	fdc42703          	lw	a4,-36(s0)
    80004386:	01a70793          	addi	a5,a4,26
    8000438a:	078e                	slli	a5,a5,0x3
    8000438c:	953e                	add	a0,a0,a5
    8000438e:	611c                	ld	a5,0(a0)
    80004390:	c385                	beqz	a5,800043b0 <argfd+0x5c>
    return -1;
  if(pfd)
    80004392:	00090463          	beqz	s2,8000439a <argfd+0x46>
    *pfd = fd;
    80004396:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000439a:	4501                	li	a0,0
  if(pf)
    8000439c:	c091                	beqz	s1,800043a0 <argfd+0x4c>
    *pf = f;
    8000439e:	e09c                	sd	a5,0(s1)
}
    800043a0:	70a2                	ld	ra,40(sp)
    800043a2:	7402                	ld	s0,32(sp)
    800043a4:	64e2                	ld	s1,24(sp)
    800043a6:	6942                	ld	s2,16(sp)
    800043a8:	6145                	addi	sp,sp,48
    800043aa:	8082                	ret
    return -1;
    800043ac:	557d                	li	a0,-1
    800043ae:	bfcd                	j	800043a0 <argfd+0x4c>
    800043b0:	557d                	li	a0,-1
    800043b2:	b7fd                	j	800043a0 <argfd+0x4c>

00000000800043b4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800043b4:	1101                	addi	sp,sp,-32
    800043b6:	ec06                	sd	ra,24(sp)
    800043b8:	e822                	sd	s0,16(sp)
    800043ba:	e426                	sd	s1,8(sp)
    800043bc:	1000                	addi	s0,sp,32
    800043be:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800043c0:	ffffd097          	auipc	ra,0xffffd
    800043c4:	a92080e7          	jalr	-1390(ra) # 80000e52 <myproc>
    800043c8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800043ca:	0d050793          	addi	a5,a0,208
    800043ce:	4501                	li	a0,0
    800043d0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800043d2:	6398                	ld	a4,0(a5)
    800043d4:	cb19                	beqz	a4,800043ea <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800043d6:	2505                	addiw	a0,a0,1
    800043d8:	07a1                	addi	a5,a5,8
    800043da:	fed51ce3          	bne	a0,a3,800043d2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800043de:	557d                	li	a0,-1
}
    800043e0:	60e2                	ld	ra,24(sp)
    800043e2:	6442                	ld	s0,16(sp)
    800043e4:	64a2                	ld	s1,8(sp)
    800043e6:	6105                	addi	sp,sp,32
    800043e8:	8082                	ret
      p->ofile[fd] = f;
    800043ea:	01a50793          	addi	a5,a0,26
    800043ee:	078e                	slli	a5,a5,0x3
    800043f0:	963e                	add	a2,a2,a5
    800043f2:	e204                	sd	s1,0(a2)
      return fd;
    800043f4:	b7f5                	j	800043e0 <fdalloc+0x2c>

00000000800043f6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800043f6:	715d                	addi	sp,sp,-80
    800043f8:	e486                	sd	ra,72(sp)
    800043fa:	e0a2                	sd	s0,64(sp)
    800043fc:	fc26                	sd	s1,56(sp)
    800043fe:	f84a                	sd	s2,48(sp)
    80004400:	f44e                	sd	s3,40(sp)
    80004402:	f052                	sd	s4,32(sp)
    80004404:	ec56                	sd	s5,24(sp)
    80004406:	e85a                	sd	s6,16(sp)
    80004408:	0880                	addi	s0,sp,80
    8000440a:	8b2e                	mv	s6,a1
    8000440c:	89b2                	mv	s3,a2
    8000440e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004410:	fb040593          	addi	a1,s0,-80
    80004414:	fffff097          	auipc	ra,0xfffff
    80004418:	e7e080e7          	jalr	-386(ra) # 80003292 <nameiparent>
    8000441c:	84aa                	mv	s1,a0
    8000441e:	14050b63          	beqz	a0,80004574 <create+0x17e>
    return 0;

  ilock(dp);
    80004422:	ffffe097          	auipc	ra,0xffffe
    80004426:	6ac080e7          	jalr	1708(ra) # 80002ace <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000442a:	4601                	li	a2,0
    8000442c:	fb040593          	addi	a1,s0,-80
    80004430:	8526                	mv	a0,s1
    80004432:	fffff097          	auipc	ra,0xfffff
    80004436:	b80080e7          	jalr	-1152(ra) # 80002fb2 <dirlookup>
    8000443a:	8aaa                	mv	s5,a0
    8000443c:	c921                	beqz	a0,8000448c <create+0x96>
    iunlockput(dp);
    8000443e:	8526                	mv	a0,s1
    80004440:	fffff097          	auipc	ra,0xfffff
    80004444:	8f0080e7          	jalr	-1808(ra) # 80002d30 <iunlockput>
    ilock(ip);
    80004448:	8556                	mv	a0,s5
    8000444a:	ffffe097          	auipc	ra,0xffffe
    8000444e:	684080e7          	jalr	1668(ra) # 80002ace <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004452:	4789                	li	a5,2
    80004454:	02fb1563          	bne	s6,a5,8000447e <create+0x88>
    80004458:	044ad783          	lhu	a5,68(s5)
    8000445c:	37f9                	addiw	a5,a5,-2
    8000445e:	17c2                	slli	a5,a5,0x30
    80004460:	93c1                	srli	a5,a5,0x30
    80004462:	4705                	li	a4,1
    80004464:	00f76d63          	bltu	a4,a5,8000447e <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004468:	8556                	mv	a0,s5
    8000446a:	60a6                	ld	ra,72(sp)
    8000446c:	6406                	ld	s0,64(sp)
    8000446e:	74e2                	ld	s1,56(sp)
    80004470:	7942                	ld	s2,48(sp)
    80004472:	79a2                	ld	s3,40(sp)
    80004474:	7a02                	ld	s4,32(sp)
    80004476:	6ae2                	ld	s5,24(sp)
    80004478:	6b42                	ld	s6,16(sp)
    8000447a:	6161                	addi	sp,sp,80
    8000447c:	8082                	ret
    iunlockput(ip);
    8000447e:	8556                	mv	a0,s5
    80004480:	fffff097          	auipc	ra,0xfffff
    80004484:	8b0080e7          	jalr	-1872(ra) # 80002d30 <iunlockput>
    return 0;
    80004488:	4a81                	li	s5,0
    8000448a:	bff9                	j	80004468 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000448c:	85da                	mv	a1,s6
    8000448e:	4088                	lw	a0,0(s1)
    80004490:	ffffe097          	auipc	ra,0xffffe
    80004494:	4a6080e7          	jalr	1190(ra) # 80002936 <ialloc>
    80004498:	8a2a                	mv	s4,a0
    8000449a:	c529                	beqz	a0,800044e4 <create+0xee>
  ilock(ip);
    8000449c:	ffffe097          	auipc	ra,0xffffe
    800044a0:	632080e7          	jalr	1586(ra) # 80002ace <ilock>
  ip->major = major;
    800044a4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800044a8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800044ac:	4905                	li	s2,1
    800044ae:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800044b2:	8552                	mv	a0,s4
    800044b4:	ffffe097          	auipc	ra,0xffffe
    800044b8:	54e080e7          	jalr	1358(ra) # 80002a02 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800044bc:	032b0b63          	beq	s6,s2,800044f2 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800044c0:	004a2603          	lw	a2,4(s4)
    800044c4:	fb040593          	addi	a1,s0,-80
    800044c8:	8526                	mv	a0,s1
    800044ca:	fffff097          	auipc	ra,0xfffff
    800044ce:	cf8080e7          	jalr	-776(ra) # 800031c2 <dirlink>
    800044d2:	06054f63          	bltz	a0,80004550 <create+0x15a>
  iunlockput(dp);
    800044d6:	8526                	mv	a0,s1
    800044d8:	fffff097          	auipc	ra,0xfffff
    800044dc:	858080e7          	jalr	-1960(ra) # 80002d30 <iunlockput>
  return ip;
    800044e0:	8ad2                	mv	s5,s4
    800044e2:	b759                	j	80004468 <create+0x72>
    iunlockput(dp);
    800044e4:	8526                	mv	a0,s1
    800044e6:	fffff097          	auipc	ra,0xfffff
    800044ea:	84a080e7          	jalr	-1974(ra) # 80002d30 <iunlockput>
    return 0;
    800044ee:	8ad2                	mv	s5,s4
    800044f0:	bfa5                	j	80004468 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800044f2:	004a2603          	lw	a2,4(s4)
    800044f6:	00004597          	auipc	a1,0x4
    800044fa:	17a58593          	addi	a1,a1,378 # 80008670 <syscalls+0x2a0>
    800044fe:	8552                	mv	a0,s4
    80004500:	fffff097          	auipc	ra,0xfffff
    80004504:	cc2080e7          	jalr	-830(ra) # 800031c2 <dirlink>
    80004508:	04054463          	bltz	a0,80004550 <create+0x15a>
    8000450c:	40d0                	lw	a2,4(s1)
    8000450e:	00004597          	auipc	a1,0x4
    80004512:	16a58593          	addi	a1,a1,362 # 80008678 <syscalls+0x2a8>
    80004516:	8552                	mv	a0,s4
    80004518:	fffff097          	auipc	ra,0xfffff
    8000451c:	caa080e7          	jalr	-854(ra) # 800031c2 <dirlink>
    80004520:	02054863          	bltz	a0,80004550 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004524:	004a2603          	lw	a2,4(s4)
    80004528:	fb040593          	addi	a1,s0,-80
    8000452c:	8526                	mv	a0,s1
    8000452e:	fffff097          	auipc	ra,0xfffff
    80004532:	c94080e7          	jalr	-876(ra) # 800031c2 <dirlink>
    80004536:	00054d63          	bltz	a0,80004550 <create+0x15a>
    dp->nlink++;  // for ".."
    8000453a:	04a4d783          	lhu	a5,74(s1)
    8000453e:	2785                	addiw	a5,a5,1
    80004540:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004544:	8526                	mv	a0,s1
    80004546:	ffffe097          	auipc	ra,0xffffe
    8000454a:	4bc080e7          	jalr	1212(ra) # 80002a02 <iupdate>
    8000454e:	b761                	j	800044d6 <create+0xe0>
  ip->nlink = 0;
    80004550:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004554:	8552                	mv	a0,s4
    80004556:	ffffe097          	auipc	ra,0xffffe
    8000455a:	4ac080e7          	jalr	1196(ra) # 80002a02 <iupdate>
  iunlockput(ip);
    8000455e:	8552                	mv	a0,s4
    80004560:	ffffe097          	auipc	ra,0xffffe
    80004564:	7d0080e7          	jalr	2000(ra) # 80002d30 <iunlockput>
  iunlockput(dp);
    80004568:	8526                	mv	a0,s1
    8000456a:	ffffe097          	auipc	ra,0xffffe
    8000456e:	7c6080e7          	jalr	1990(ra) # 80002d30 <iunlockput>
  return 0;
    80004572:	bddd                	j	80004468 <create+0x72>
    return 0;
    80004574:	8aaa                	mv	s5,a0
    80004576:	bdcd                	j	80004468 <create+0x72>

0000000080004578 <sys_dup>:
{
    80004578:	7179                	addi	sp,sp,-48
    8000457a:	f406                	sd	ra,40(sp)
    8000457c:	f022                	sd	s0,32(sp)
    8000457e:	ec26                	sd	s1,24(sp)
    80004580:	e84a                	sd	s2,16(sp)
    80004582:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004584:	fd840613          	addi	a2,s0,-40
    80004588:	4581                	li	a1,0
    8000458a:	4501                	li	a0,0
    8000458c:	00000097          	auipc	ra,0x0
    80004590:	dc8080e7          	jalr	-568(ra) # 80004354 <argfd>
    return -1;
    80004594:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004596:	02054363          	bltz	a0,800045bc <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000459a:	fd843903          	ld	s2,-40(s0)
    8000459e:	854a                	mv	a0,s2
    800045a0:	00000097          	auipc	ra,0x0
    800045a4:	e14080e7          	jalr	-492(ra) # 800043b4 <fdalloc>
    800045a8:	84aa                	mv	s1,a0
    return -1;
    800045aa:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800045ac:	00054863          	bltz	a0,800045bc <sys_dup+0x44>
  filedup(f);
    800045b0:	854a                	mv	a0,s2
    800045b2:	fffff097          	auipc	ra,0xfffff
    800045b6:	334080e7          	jalr	820(ra) # 800038e6 <filedup>
  return fd;
    800045ba:	87a6                	mv	a5,s1
}
    800045bc:	853e                	mv	a0,a5
    800045be:	70a2                	ld	ra,40(sp)
    800045c0:	7402                	ld	s0,32(sp)
    800045c2:	64e2                	ld	s1,24(sp)
    800045c4:	6942                	ld	s2,16(sp)
    800045c6:	6145                	addi	sp,sp,48
    800045c8:	8082                	ret

00000000800045ca <sys_read>:
{
    800045ca:	7179                	addi	sp,sp,-48
    800045cc:	f406                	sd	ra,40(sp)
    800045ce:	f022                	sd	s0,32(sp)
    800045d0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800045d2:	fd840593          	addi	a1,s0,-40
    800045d6:	4505                	li	a0,1
    800045d8:	ffffe097          	auipc	ra,0xffffe
    800045dc:	9b4080e7          	jalr	-1612(ra) # 80001f8c <argaddr>
  argint(2, &n);
    800045e0:	fe440593          	addi	a1,s0,-28
    800045e4:	4509                	li	a0,2
    800045e6:	ffffe097          	auipc	ra,0xffffe
    800045ea:	986080e7          	jalr	-1658(ra) # 80001f6c <argint>
  if(argfd(0, 0, &f) < 0)
    800045ee:	fe840613          	addi	a2,s0,-24
    800045f2:	4581                	li	a1,0
    800045f4:	4501                	li	a0,0
    800045f6:	00000097          	auipc	ra,0x0
    800045fa:	d5e080e7          	jalr	-674(ra) # 80004354 <argfd>
    800045fe:	87aa                	mv	a5,a0
    return -1;
    80004600:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004602:	0007cc63          	bltz	a5,8000461a <sys_read+0x50>
  return fileread(f, p, n);
    80004606:	fe442603          	lw	a2,-28(s0)
    8000460a:	fd843583          	ld	a1,-40(s0)
    8000460e:	fe843503          	ld	a0,-24(s0)
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	460080e7          	jalr	1120(ra) # 80003a72 <fileread>
}
    8000461a:	70a2                	ld	ra,40(sp)
    8000461c:	7402                	ld	s0,32(sp)
    8000461e:	6145                	addi	sp,sp,48
    80004620:	8082                	ret

0000000080004622 <sys_write>:
{
    80004622:	7179                	addi	sp,sp,-48
    80004624:	f406                	sd	ra,40(sp)
    80004626:	f022                	sd	s0,32(sp)
    80004628:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000462a:	fd840593          	addi	a1,s0,-40
    8000462e:	4505                	li	a0,1
    80004630:	ffffe097          	auipc	ra,0xffffe
    80004634:	95c080e7          	jalr	-1700(ra) # 80001f8c <argaddr>
  argint(2, &n);
    80004638:	fe440593          	addi	a1,s0,-28
    8000463c:	4509                	li	a0,2
    8000463e:	ffffe097          	auipc	ra,0xffffe
    80004642:	92e080e7          	jalr	-1746(ra) # 80001f6c <argint>
  if(argfd(0, 0, &f) < 0)
    80004646:	fe840613          	addi	a2,s0,-24
    8000464a:	4581                	li	a1,0
    8000464c:	4501                	li	a0,0
    8000464e:	00000097          	auipc	ra,0x0
    80004652:	d06080e7          	jalr	-762(ra) # 80004354 <argfd>
    80004656:	87aa                	mv	a5,a0
    return -1;
    80004658:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000465a:	0007cc63          	bltz	a5,80004672 <sys_write+0x50>
  return filewrite(f, p, n);
    8000465e:	fe442603          	lw	a2,-28(s0)
    80004662:	fd843583          	ld	a1,-40(s0)
    80004666:	fe843503          	ld	a0,-24(s0)
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	4ca080e7          	jalr	1226(ra) # 80003b34 <filewrite>
}
    80004672:	70a2                	ld	ra,40(sp)
    80004674:	7402                	ld	s0,32(sp)
    80004676:	6145                	addi	sp,sp,48
    80004678:	8082                	ret

000000008000467a <sys_close>:
{
    8000467a:	1101                	addi	sp,sp,-32
    8000467c:	ec06                	sd	ra,24(sp)
    8000467e:	e822                	sd	s0,16(sp)
    80004680:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004682:	fe040613          	addi	a2,s0,-32
    80004686:	fec40593          	addi	a1,s0,-20
    8000468a:	4501                	li	a0,0
    8000468c:	00000097          	auipc	ra,0x0
    80004690:	cc8080e7          	jalr	-824(ra) # 80004354 <argfd>
    return -1;
    80004694:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004696:	02054463          	bltz	a0,800046be <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000469a:	ffffc097          	auipc	ra,0xffffc
    8000469e:	7b8080e7          	jalr	1976(ra) # 80000e52 <myproc>
    800046a2:	fec42783          	lw	a5,-20(s0)
    800046a6:	07e9                	addi	a5,a5,26
    800046a8:	078e                	slli	a5,a5,0x3
    800046aa:	953e                	add	a0,a0,a5
    800046ac:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800046b0:	fe043503          	ld	a0,-32(s0)
    800046b4:	fffff097          	auipc	ra,0xfffff
    800046b8:	284080e7          	jalr	644(ra) # 80003938 <fileclose>
  return 0;
    800046bc:	4781                	li	a5,0
}
    800046be:	853e                	mv	a0,a5
    800046c0:	60e2                	ld	ra,24(sp)
    800046c2:	6442                	ld	s0,16(sp)
    800046c4:	6105                	addi	sp,sp,32
    800046c6:	8082                	ret

00000000800046c8 <sys_fstat>:
{
    800046c8:	1101                	addi	sp,sp,-32
    800046ca:	ec06                	sd	ra,24(sp)
    800046cc:	e822                	sd	s0,16(sp)
    800046ce:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800046d0:	fe040593          	addi	a1,s0,-32
    800046d4:	4505                	li	a0,1
    800046d6:	ffffe097          	auipc	ra,0xffffe
    800046da:	8b6080e7          	jalr	-1866(ra) # 80001f8c <argaddr>
  if(argfd(0, 0, &f) < 0)
    800046de:	fe840613          	addi	a2,s0,-24
    800046e2:	4581                	li	a1,0
    800046e4:	4501                	li	a0,0
    800046e6:	00000097          	auipc	ra,0x0
    800046ea:	c6e080e7          	jalr	-914(ra) # 80004354 <argfd>
    800046ee:	87aa                	mv	a5,a0
    return -1;
    800046f0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046f2:	0007ca63          	bltz	a5,80004706 <sys_fstat+0x3e>
  return filestat(f, st);
    800046f6:	fe043583          	ld	a1,-32(s0)
    800046fa:	fe843503          	ld	a0,-24(s0)
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	302080e7          	jalr	770(ra) # 80003a00 <filestat>
}
    80004706:	60e2                	ld	ra,24(sp)
    80004708:	6442                	ld	s0,16(sp)
    8000470a:	6105                	addi	sp,sp,32
    8000470c:	8082                	ret

000000008000470e <sys_link>:
{
    8000470e:	7169                	addi	sp,sp,-304
    80004710:	f606                	sd	ra,296(sp)
    80004712:	f222                	sd	s0,288(sp)
    80004714:	ee26                	sd	s1,280(sp)
    80004716:	ea4a                	sd	s2,272(sp)
    80004718:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000471a:	08000613          	li	a2,128
    8000471e:	ed040593          	addi	a1,s0,-304
    80004722:	4501                	li	a0,0
    80004724:	ffffe097          	auipc	ra,0xffffe
    80004728:	888080e7          	jalr	-1912(ra) # 80001fac <argstr>
    return -1;
    8000472c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000472e:	10054e63          	bltz	a0,8000484a <sys_link+0x13c>
    80004732:	08000613          	li	a2,128
    80004736:	f5040593          	addi	a1,s0,-176
    8000473a:	4505                	li	a0,1
    8000473c:	ffffe097          	auipc	ra,0xffffe
    80004740:	870080e7          	jalr	-1936(ra) # 80001fac <argstr>
    return -1;
    80004744:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004746:	10054263          	bltz	a0,8000484a <sys_link+0x13c>
  begin_op();
    8000474a:	fffff097          	auipc	ra,0xfffff
    8000474e:	d2a080e7          	jalr	-726(ra) # 80003474 <begin_op>
  if((ip = namei(old)) == 0){
    80004752:	ed040513          	addi	a0,s0,-304
    80004756:	fffff097          	auipc	ra,0xfffff
    8000475a:	b1e080e7          	jalr	-1250(ra) # 80003274 <namei>
    8000475e:	84aa                	mv	s1,a0
    80004760:	c551                	beqz	a0,800047ec <sys_link+0xde>
  ilock(ip);
    80004762:	ffffe097          	auipc	ra,0xffffe
    80004766:	36c080e7          	jalr	876(ra) # 80002ace <ilock>
  if(ip->type == T_DIR){
    8000476a:	04449703          	lh	a4,68(s1)
    8000476e:	4785                	li	a5,1
    80004770:	08f70463          	beq	a4,a5,800047f8 <sys_link+0xea>
  ip->nlink++;
    80004774:	04a4d783          	lhu	a5,74(s1)
    80004778:	2785                	addiw	a5,a5,1
    8000477a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000477e:	8526                	mv	a0,s1
    80004780:	ffffe097          	auipc	ra,0xffffe
    80004784:	282080e7          	jalr	642(ra) # 80002a02 <iupdate>
  iunlock(ip);
    80004788:	8526                	mv	a0,s1
    8000478a:	ffffe097          	auipc	ra,0xffffe
    8000478e:	406080e7          	jalr	1030(ra) # 80002b90 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004792:	fd040593          	addi	a1,s0,-48
    80004796:	f5040513          	addi	a0,s0,-176
    8000479a:	fffff097          	auipc	ra,0xfffff
    8000479e:	af8080e7          	jalr	-1288(ra) # 80003292 <nameiparent>
    800047a2:	892a                	mv	s2,a0
    800047a4:	c935                	beqz	a0,80004818 <sys_link+0x10a>
  ilock(dp);
    800047a6:	ffffe097          	auipc	ra,0xffffe
    800047aa:	328080e7          	jalr	808(ra) # 80002ace <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800047ae:	00092703          	lw	a4,0(s2)
    800047b2:	409c                	lw	a5,0(s1)
    800047b4:	04f71d63          	bne	a4,a5,8000480e <sys_link+0x100>
    800047b8:	40d0                	lw	a2,4(s1)
    800047ba:	fd040593          	addi	a1,s0,-48
    800047be:	854a                	mv	a0,s2
    800047c0:	fffff097          	auipc	ra,0xfffff
    800047c4:	a02080e7          	jalr	-1534(ra) # 800031c2 <dirlink>
    800047c8:	04054363          	bltz	a0,8000480e <sys_link+0x100>
  iunlockput(dp);
    800047cc:	854a                	mv	a0,s2
    800047ce:	ffffe097          	auipc	ra,0xffffe
    800047d2:	562080e7          	jalr	1378(ra) # 80002d30 <iunlockput>
  iput(ip);
    800047d6:	8526                	mv	a0,s1
    800047d8:	ffffe097          	auipc	ra,0xffffe
    800047dc:	4b0080e7          	jalr	1200(ra) # 80002c88 <iput>
  end_op();
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	d0e080e7          	jalr	-754(ra) # 800034ee <end_op>
  return 0;
    800047e8:	4781                	li	a5,0
    800047ea:	a085                	j	8000484a <sys_link+0x13c>
    end_op();
    800047ec:	fffff097          	auipc	ra,0xfffff
    800047f0:	d02080e7          	jalr	-766(ra) # 800034ee <end_op>
    return -1;
    800047f4:	57fd                	li	a5,-1
    800047f6:	a891                	j	8000484a <sys_link+0x13c>
    iunlockput(ip);
    800047f8:	8526                	mv	a0,s1
    800047fa:	ffffe097          	auipc	ra,0xffffe
    800047fe:	536080e7          	jalr	1334(ra) # 80002d30 <iunlockput>
    end_op();
    80004802:	fffff097          	auipc	ra,0xfffff
    80004806:	cec080e7          	jalr	-788(ra) # 800034ee <end_op>
    return -1;
    8000480a:	57fd                	li	a5,-1
    8000480c:	a83d                	j	8000484a <sys_link+0x13c>
    iunlockput(dp);
    8000480e:	854a                	mv	a0,s2
    80004810:	ffffe097          	auipc	ra,0xffffe
    80004814:	520080e7          	jalr	1312(ra) # 80002d30 <iunlockput>
  ilock(ip);
    80004818:	8526                	mv	a0,s1
    8000481a:	ffffe097          	auipc	ra,0xffffe
    8000481e:	2b4080e7          	jalr	692(ra) # 80002ace <ilock>
  ip->nlink--;
    80004822:	04a4d783          	lhu	a5,74(s1)
    80004826:	37fd                	addiw	a5,a5,-1
    80004828:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000482c:	8526                	mv	a0,s1
    8000482e:	ffffe097          	auipc	ra,0xffffe
    80004832:	1d4080e7          	jalr	468(ra) # 80002a02 <iupdate>
  iunlockput(ip);
    80004836:	8526                	mv	a0,s1
    80004838:	ffffe097          	auipc	ra,0xffffe
    8000483c:	4f8080e7          	jalr	1272(ra) # 80002d30 <iunlockput>
  end_op();
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	cae080e7          	jalr	-850(ra) # 800034ee <end_op>
  return -1;
    80004848:	57fd                	li	a5,-1
}
    8000484a:	853e                	mv	a0,a5
    8000484c:	70b2                	ld	ra,296(sp)
    8000484e:	7412                	ld	s0,288(sp)
    80004850:	64f2                	ld	s1,280(sp)
    80004852:	6952                	ld	s2,272(sp)
    80004854:	6155                	addi	sp,sp,304
    80004856:	8082                	ret

0000000080004858 <sys_unlink>:
{
    80004858:	7151                	addi	sp,sp,-240
    8000485a:	f586                	sd	ra,232(sp)
    8000485c:	f1a2                	sd	s0,224(sp)
    8000485e:	eda6                	sd	s1,216(sp)
    80004860:	e9ca                	sd	s2,208(sp)
    80004862:	e5ce                	sd	s3,200(sp)
    80004864:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004866:	08000613          	li	a2,128
    8000486a:	f3040593          	addi	a1,s0,-208
    8000486e:	4501                	li	a0,0
    80004870:	ffffd097          	auipc	ra,0xffffd
    80004874:	73c080e7          	jalr	1852(ra) # 80001fac <argstr>
    80004878:	18054163          	bltz	a0,800049fa <sys_unlink+0x1a2>
  begin_op();
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	bf8080e7          	jalr	-1032(ra) # 80003474 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004884:	fb040593          	addi	a1,s0,-80
    80004888:	f3040513          	addi	a0,s0,-208
    8000488c:	fffff097          	auipc	ra,0xfffff
    80004890:	a06080e7          	jalr	-1530(ra) # 80003292 <nameiparent>
    80004894:	84aa                	mv	s1,a0
    80004896:	c979                	beqz	a0,8000496c <sys_unlink+0x114>
  ilock(dp);
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	236080e7          	jalr	566(ra) # 80002ace <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800048a0:	00004597          	auipc	a1,0x4
    800048a4:	dd058593          	addi	a1,a1,-560 # 80008670 <syscalls+0x2a0>
    800048a8:	fb040513          	addi	a0,s0,-80
    800048ac:	ffffe097          	auipc	ra,0xffffe
    800048b0:	6ec080e7          	jalr	1772(ra) # 80002f98 <namecmp>
    800048b4:	14050a63          	beqz	a0,80004a08 <sys_unlink+0x1b0>
    800048b8:	00004597          	auipc	a1,0x4
    800048bc:	dc058593          	addi	a1,a1,-576 # 80008678 <syscalls+0x2a8>
    800048c0:	fb040513          	addi	a0,s0,-80
    800048c4:	ffffe097          	auipc	ra,0xffffe
    800048c8:	6d4080e7          	jalr	1748(ra) # 80002f98 <namecmp>
    800048cc:	12050e63          	beqz	a0,80004a08 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800048d0:	f2c40613          	addi	a2,s0,-212
    800048d4:	fb040593          	addi	a1,s0,-80
    800048d8:	8526                	mv	a0,s1
    800048da:	ffffe097          	auipc	ra,0xffffe
    800048de:	6d8080e7          	jalr	1752(ra) # 80002fb2 <dirlookup>
    800048e2:	892a                	mv	s2,a0
    800048e4:	12050263          	beqz	a0,80004a08 <sys_unlink+0x1b0>
  ilock(ip);
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	1e6080e7          	jalr	486(ra) # 80002ace <ilock>
  if(ip->nlink < 1)
    800048f0:	04a91783          	lh	a5,74(s2)
    800048f4:	08f05263          	blez	a5,80004978 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800048f8:	04491703          	lh	a4,68(s2)
    800048fc:	4785                	li	a5,1
    800048fe:	08f70563          	beq	a4,a5,80004988 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004902:	4641                	li	a2,16
    80004904:	4581                	li	a1,0
    80004906:	fc040513          	addi	a0,s0,-64
    8000490a:	ffffc097          	auipc	ra,0xffffc
    8000490e:	870080e7          	jalr	-1936(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004912:	4741                	li	a4,16
    80004914:	f2c42683          	lw	a3,-212(s0)
    80004918:	fc040613          	addi	a2,s0,-64
    8000491c:	4581                	li	a1,0
    8000491e:	8526                	mv	a0,s1
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	55a080e7          	jalr	1370(ra) # 80002e7a <writei>
    80004928:	47c1                	li	a5,16
    8000492a:	0af51563          	bne	a0,a5,800049d4 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    8000492e:	04491703          	lh	a4,68(s2)
    80004932:	4785                	li	a5,1
    80004934:	0af70863          	beq	a4,a5,800049e4 <sys_unlink+0x18c>
  iunlockput(dp);
    80004938:	8526                	mv	a0,s1
    8000493a:	ffffe097          	auipc	ra,0xffffe
    8000493e:	3f6080e7          	jalr	1014(ra) # 80002d30 <iunlockput>
  ip->nlink--;
    80004942:	04a95783          	lhu	a5,74(s2)
    80004946:	37fd                	addiw	a5,a5,-1
    80004948:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000494c:	854a                	mv	a0,s2
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	0b4080e7          	jalr	180(ra) # 80002a02 <iupdate>
  iunlockput(ip);
    80004956:	854a                	mv	a0,s2
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	3d8080e7          	jalr	984(ra) # 80002d30 <iunlockput>
  end_op();
    80004960:	fffff097          	auipc	ra,0xfffff
    80004964:	b8e080e7          	jalr	-1138(ra) # 800034ee <end_op>
  return 0;
    80004968:	4501                	li	a0,0
    8000496a:	a84d                	j	80004a1c <sys_unlink+0x1c4>
    end_op();
    8000496c:	fffff097          	auipc	ra,0xfffff
    80004970:	b82080e7          	jalr	-1150(ra) # 800034ee <end_op>
    return -1;
    80004974:	557d                	li	a0,-1
    80004976:	a05d                	j	80004a1c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004978:	00004517          	auipc	a0,0x4
    8000497c:	d0850513          	addi	a0,a0,-760 # 80008680 <syscalls+0x2b0>
    80004980:	00001097          	auipc	ra,0x1
    80004984:	1a6080e7          	jalr	422(ra) # 80005b26 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004988:	04c92703          	lw	a4,76(s2)
    8000498c:	02000793          	li	a5,32
    80004990:	f6e7f9e3          	bgeu	a5,a4,80004902 <sys_unlink+0xaa>
    80004994:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004998:	4741                	li	a4,16
    8000499a:	86ce                	mv	a3,s3
    8000499c:	f1840613          	addi	a2,s0,-232
    800049a0:	4581                	li	a1,0
    800049a2:	854a                	mv	a0,s2
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	3de080e7          	jalr	990(ra) # 80002d82 <readi>
    800049ac:	47c1                	li	a5,16
    800049ae:	00f51b63          	bne	a0,a5,800049c4 <sys_unlink+0x16c>
    if(de.inum != 0)
    800049b2:	f1845783          	lhu	a5,-232(s0)
    800049b6:	e7a1                	bnez	a5,800049fe <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049b8:	29c1                	addiw	s3,s3,16
    800049ba:	04c92783          	lw	a5,76(s2)
    800049be:	fcf9ede3          	bltu	s3,a5,80004998 <sys_unlink+0x140>
    800049c2:	b781                	j	80004902 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800049c4:	00004517          	auipc	a0,0x4
    800049c8:	cd450513          	addi	a0,a0,-812 # 80008698 <syscalls+0x2c8>
    800049cc:	00001097          	auipc	ra,0x1
    800049d0:	15a080e7          	jalr	346(ra) # 80005b26 <panic>
    panic("unlink: writei");
    800049d4:	00004517          	auipc	a0,0x4
    800049d8:	cdc50513          	addi	a0,a0,-804 # 800086b0 <syscalls+0x2e0>
    800049dc:	00001097          	auipc	ra,0x1
    800049e0:	14a080e7          	jalr	330(ra) # 80005b26 <panic>
    dp->nlink--;
    800049e4:	04a4d783          	lhu	a5,74(s1)
    800049e8:	37fd                	addiw	a5,a5,-1
    800049ea:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800049ee:	8526                	mv	a0,s1
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	012080e7          	jalr	18(ra) # 80002a02 <iupdate>
    800049f8:	b781                	j	80004938 <sys_unlink+0xe0>
    return -1;
    800049fa:	557d                	li	a0,-1
    800049fc:	a005                	j	80004a1c <sys_unlink+0x1c4>
    iunlockput(ip);
    800049fe:	854a                	mv	a0,s2
    80004a00:	ffffe097          	auipc	ra,0xffffe
    80004a04:	330080e7          	jalr	816(ra) # 80002d30 <iunlockput>
  iunlockput(dp);
    80004a08:	8526                	mv	a0,s1
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	326080e7          	jalr	806(ra) # 80002d30 <iunlockput>
  end_op();
    80004a12:	fffff097          	auipc	ra,0xfffff
    80004a16:	adc080e7          	jalr	-1316(ra) # 800034ee <end_op>
  return -1;
    80004a1a:	557d                	li	a0,-1
}
    80004a1c:	70ae                	ld	ra,232(sp)
    80004a1e:	740e                	ld	s0,224(sp)
    80004a20:	64ee                	ld	s1,216(sp)
    80004a22:	694e                	ld	s2,208(sp)
    80004a24:	69ae                	ld	s3,200(sp)
    80004a26:	616d                	addi	sp,sp,240
    80004a28:	8082                	ret

0000000080004a2a <sys_open>:

uint64
sys_open(void)
{
    80004a2a:	7131                	addi	sp,sp,-192
    80004a2c:	fd06                	sd	ra,184(sp)
    80004a2e:	f922                	sd	s0,176(sp)
    80004a30:	f526                	sd	s1,168(sp)
    80004a32:	f14a                	sd	s2,160(sp)
    80004a34:	ed4e                	sd	s3,152(sp)
    80004a36:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004a38:	f4c40593          	addi	a1,s0,-180
    80004a3c:	4505                	li	a0,1
    80004a3e:	ffffd097          	auipc	ra,0xffffd
    80004a42:	52e080e7          	jalr	1326(ra) # 80001f6c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a46:	08000613          	li	a2,128
    80004a4a:	f5040593          	addi	a1,s0,-176
    80004a4e:	4501                	li	a0,0
    80004a50:	ffffd097          	auipc	ra,0xffffd
    80004a54:	55c080e7          	jalr	1372(ra) # 80001fac <argstr>
    80004a58:	87aa                	mv	a5,a0
    return -1;
    80004a5a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a5c:	0a07c863          	bltz	a5,80004b0c <sys_open+0xe2>

  begin_op();
    80004a60:	fffff097          	auipc	ra,0xfffff
    80004a64:	a14080e7          	jalr	-1516(ra) # 80003474 <begin_op>

  if(omode & O_CREATE){
    80004a68:	f4c42783          	lw	a5,-180(s0)
    80004a6c:	2007f793          	andi	a5,a5,512
    80004a70:	cbdd                	beqz	a5,80004b26 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004a72:	4681                	li	a3,0
    80004a74:	4601                	li	a2,0
    80004a76:	4589                	li	a1,2
    80004a78:	f5040513          	addi	a0,s0,-176
    80004a7c:	00000097          	auipc	ra,0x0
    80004a80:	97a080e7          	jalr	-1670(ra) # 800043f6 <create>
    80004a84:	84aa                	mv	s1,a0
    if(ip == 0){
    80004a86:	c951                	beqz	a0,80004b1a <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004a88:	04449703          	lh	a4,68(s1)
    80004a8c:	478d                	li	a5,3
    80004a8e:	00f71763          	bne	a4,a5,80004a9c <sys_open+0x72>
    80004a92:	0464d703          	lhu	a4,70(s1)
    80004a96:	47a5                	li	a5,9
    80004a98:	0ce7ec63          	bltu	a5,a4,80004b70 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	de0080e7          	jalr	-544(ra) # 8000387c <filealloc>
    80004aa4:	892a                	mv	s2,a0
    80004aa6:	c56d                	beqz	a0,80004b90 <sys_open+0x166>
    80004aa8:	00000097          	auipc	ra,0x0
    80004aac:	90c080e7          	jalr	-1780(ra) # 800043b4 <fdalloc>
    80004ab0:	89aa                	mv	s3,a0
    80004ab2:	0c054a63          	bltz	a0,80004b86 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ab6:	04449703          	lh	a4,68(s1)
    80004aba:	478d                	li	a5,3
    80004abc:	0ef70563          	beq	a4,a5,80004ba6 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ac0:	4789                	li	a5,2
    80004ac2:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004ac6:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004aca:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004ace:	f4c42783          	lw	a5,-180(s0)
    80004ad2:	0017c713          	xori	a4,a5,1
    80004ad6:	8b05                	andi	a4,a4,1
    80004ad8:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004adc:	0037f713          	andi	a4,a5,3
    80004ae0:	00e03733          	snez	a4,a4
    80004ae4:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ae8:	4007f793          	andi	a5,a5,1024
    80004aec:	c791                	beqz	a5,80004af8 <sys_open+0xce>
    80004aee:	04449703          	lh	a4,68(s1)
    80004af2:	4789                	li	a5,2
    80004af4:	0cf70063          	beq	a4,a5,80004bb4 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004af8:	8526                	mv	a0,s1
    80004afa:	ffffe097          	auipc	ra,0xffffe
    80004afe:	096080e7          	jalr	150(ra) # 80002b90 <iunlock>
  end_op();
    80004b02:	fffff097          	auipc	ra,0xfffff
    80004b06:	9ec080e7          	jalr	-1556(ra) # 800034ee <end_op>

  return fd;
    80004b0a:	854e                	mv	a0,s3
}
    80004b0c:	70ea                	ld	ra,184(sp)
    80004b0e:	744a                	ld	s0,176(sp)
    80004b10:	74aa                	ld	s1,168(sp)
    80004b12:	790a                	ld	s2,160(sp)
    80004b14:	69ea                	ld	s3,152(sp)
    80004b16:	6129                	addi	sp,sp,192
    80004b18:	8082                	ret
      end_op();
    80004b1a:	fffff097          	auipc	ra,0xfffff
    80004b1e:	9d4080e7          	jalr	-1580(ra) # 800034ee <end_op>
      return -1;
    80004b22:	557d                	li	a0,-1
    80004b24:	b7e5                	j	80004b0c <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004b26:	f5040513          	addi	a0,s0,-176
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	74a080e7          	jalr	1866(ra) # 80003274 <namei>
    80004b32:	84aa                	mv	s1,a0
    80004b34:	c905                	beqz	a0,80004b64 <sys_open+0x13a>
    ilock(ip);
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	f98080e7          	jalr	-104(ra) # 80002ace <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004b3e:	04449703          	lh	a4,68(s1)
    80004b42:	4785                	li	a5,1
    80004b44:	f4f712e3          	bne	a4,a5,80004a88 <sys_open+0x5e>
    80004b48:	f4c42783          	lw	a5,-180(s0)
    80004b4c:	dba1                	beqz	a5,80004a9c <sys_open+0x72>
      iunlockput(ip);
    80004b4e:	8526                	mv	a0,s1
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	1e0080e7          	jalr	480(ra) # 80002d30 <iunlockput>
      end_op();
    80004b58:	fffff097          	auipc	ra,0xfffff
    80004b5c:	996080e7          	jalr	-1642(ra) # 800034ee <end_op>
      return -1;
    80004b60:	557d                	li	a0,-1
    80004b62:	b76d                	j	80004b0c <sys_open+0xe2>
      end_op();
    80004b64:	fffff097          	auipc	ra,0xfffff
    80004b68:	98a080e7          	jalr	-1654(ra) # 800034ee <end_op>
      return -1;
    80004b6c:	557d                	li	a0,-1
    80004b6e:	bf79                	j	80004b0c <sys_open+0xe2>
    iunlockput(ip);
    80004b70:	8526                	mv	a0,s1
    80004b72:	ffffe097          	auipc	ra,0xffffe
    80004b76:	1be080e7          	jalr	446(ra) # 80002d30 <iunlockput>
    end_op();
    80004b7a:	fffff097          	auipc	ra,0xfffff
    80004b7e:	974080e7          	jalr	-1676(ra) # 800034ee <end_op>
    return -1;
    80004b82:	557d                	li	a0,-1
    80004b84:	b761                	j	80004b0c <sys_open+0xe2>
      fileclose(f);
    80004b86:	854a                	mv	a0,s2
    80004b88:	fffff097          	auipc	ra,0xfffff
    80004b8c:	db0080e7          	jalr	-592(ra) # 80003938 <fileclose>
    iunlockput(ip);
    80004b90:	8526                	mv	a0,s1
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	19e080e7          	jalr	414(ra) # 80002d30 <iunlockput>
    end_op();
    80004b9a:	fffff097          	auipc	ra,0xfffff
    80004b9e:	954080e7          	jalr	-1708(ra) # 800034ee <end_op>
    return -1;
    80004ba2:	557d                	li	a0,-1
    80004ba4:	b7a5                	j	80004b0c <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004ba6:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004baa:	04649783          	lh	a5,70(s1)
    80004bae:	02f91223          	sh	a5,36(s2)
    80004bb2:	bf21                	j	80004aca <sys_open+0xa0>
    itrunc(ip);
    80004bb4:	8526                	mv	a0,s1
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	026080e7          	jalr	38(ra) # 80002bdc <itrunc>
    80004bbe:	bf2d                	j	80004af8 <sys_open+0xce>

0000000080004bc0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004bc0:	7175                	addi	sp,sp,-144
    80004bc2:	e506                	sd	ra,136(sp)
    80004bc4:	e122                	sd	s0,128(sp)
    80004bc6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	8ac080e7          	jalr	-1876(ra) # 80003474 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004bd0:	08000613          	li	a2,128
    80004bd4:	f7040593          	addi	a1,s0,-144
    80004bd8:	4501                	li	a0,0
    80004bda:	ffffd097          	auipc	ra,0xffffd
    80004bde:	3d2080e7          	jalr	978(ra) # 80001fac <argstr>
    80004be2:	02054963          	bltz	a0,80004c14 <sys_mkdir+0x54>
    80004be6:	4681                	li	a3,0
    80004be8:	4601                	li	a2,0
    80004bea:	4585                	li	a1,1
    80004bec:	f7040513          	addi	a0,s0,-144
    80004bf0:	00000097          	auipc	ra,0x0
    80004bf4:	806080e7          	jalr	-2042(ra) # 800043f6 <create>
    80004bf8:	cd11                	beqz	a0,80004c14 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004bfa:	ffffe097          	auipc	ra,0xffffe
    80004bfe:	136080e7          	jalr	310(ra) # 80002d30 <iunlockput>
  end_op();
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	8ec080e7          	jalr	-1812(ra) # 800034ee <end_op>
  return 0;
    80004c0a:	4501                	li	a0,0
}
    80004c0c:	60aa                	ld	ra,136(sp)
    80004c0e:	640a                	ld	s0,128(sp)
    80004c10:	6149                	addi	sp,sp,144
    80004c12:	8082                	ret
    end_op();
    80004c14:	fffff097          	auipc	ra,0xfffff
    80004c18:	8da080e7          	jalr	-1830(ra) # 800034ee <end_op>
    return -1;
    80004c1c:	557d                	li	a0,-1
    80004c1e:	b7fd                	j	80004c0c <sys_mkdir+0x4c>

0000000080004c20 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c20:	7135                	addi	sp,sp,-160
    80004c22:	ed06                	sd	ra,152(sp)
    80004c24:	e922                	sd	s0,144(sp)
    80004c26:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	84c080e7          	jalr	-1972(ra) # 80003474 <begin_op>
  argint(1, &major);
    80004c30:	f6c40593          	addi	a1,s0,-148
    80004c34:	4505                	li	a0,1
    80004c36:	ffffd097          	auipc	ra,0xffffd
    80004c3a:	336080e7          	jalr	822(ra) # 80001f6c <argint>
  argint(2, &minor);
    80004c3e:	f6840593          	addi	a1,s0,-152
    80004c42:	4509                	li	a0,2
    80004c44:	ffffd097          	auipc	ra,0xffffd
    80004c48:	328080e7          	jalr	808(ra) # 80001f6c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c4c:	08000613          	li	a2,128
    80004c50:	f7040593          	addi	a1,s0,-144
    80004c54:	4501                	li	a0,0
    80004c56:	ffffd097          	auipc	ra,0xffffd
    80004c5a:	356080e7          	jalr	854(ra) # 80001fac <argstr>
    80004c5e:	02054b63          	bltz	a0,80004c94 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004c62:	f6841683          	lh	a3,-152(s0)
    80004c66:	f6c41603          	lh	a2,-148(s0)
    80004c6a:	458d                	li	a1,3
    80004c6c:	f7040513          	addi	a0,s0,-144
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	786080e7          	jalr	1926(ra) # 800043f6 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c78:	cd11                	beqz	a0,80004c94 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	0b6080e7          	jalr	182(ra) # 80002d30 <iunlockput>
  end_op();
    80004c82:	fffff097          	auipc	ra,0xfffff
    80004c86:	86c080e7          	jalr	-1940(ra) # 800034ee <end_op>
  return 0;
    80004c8a:	4501                	li	a0,0
}
    80004c8c:	60ea                	ld	ra,152(sp)
    80004c8e:	644a                	ld	s0,144(sp)
    80004c90:	610d                	addi	sp,sp,160
    80004c92:	8082                	ret
    end_op();
    80004c94:	fffff097          	auipc	ra,0xfffff
    80004c98:	85a080e7          	jalr	-1958(ra) # 800034ee <end_op>
    return -1;
    80004c9c:	557d                	li	a0,-1
    80004c9e:	b7fd                	j	80004c8c <sys_mknod+0x6c>

0000000080004ca0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ca0:	7135                	addi	sp,sp,-160
    80004ca2:	ed06                	sd	ra,152(sp)
    80004ca4:	e922                	sd	s0,144(sp)
    80004ca6:	e526                	sd	s1,136(sp)
    80004ca8:	e14a                	sd	s2,128(sp)
    80004caa:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004cac:	ffffc097          	auipc	ra,0xffffc
    80004cb0:	1a6080e7          	jalr	422(ra) # 80000e52 <myproc>
    80004cb4:	892a                	mv	s2,a0
  
  begin_op();
    80004cb6:	ffffe097          	auipc	ra,0xffffe
    80004cba:	7be080e7          	jalr	1982(ra) # 80003474 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004cbe:	08000613          	li	a2,128
    80004cc2:	f6040593          	addi	a1,s0,-160
    80004cc6:	4501                	li	a0,0
    80004cc8:	ffffd097          	auipc	ra,0xffffd
    80004ccc:	2e4080e7          	jalr	740(ra) # 80001fac <argstr>
    80004cd0:	04054b63          	bltz	a0,80004d26 <sys_chdir+0x86>
    80004cd4:	f6040513          	addi	a0,s0,-160
    80004cd8:	ffffe097          	auipc	ra,0xffffe
    80004cdc:	59c080e7          	jalr	1436(ra) # 80003274 <namei>
    80004ce0:	84aa                	mv	s1,a0
    80004ce2:	c131                	beqz	a0,80004d26 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ce4:	ffffe097          	auipc	ra,0xffffe
    80004ce8:	dea080e7          	jalr	-534(ra) # 80002ace <ilock>
  if(ip->type != T_DIR){
    80004cec:	04449703          	lh	a4,68(s1)
    80004cf0:	4785                	li	a5,1
    80004cf2:	04f71063          	bne	a4,a5,80004d32 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	e98080e7          	jalr	-360(ra) # 80002b90 <iunlock>
  iput(p->cwd);
    80004d00:	15093503          	ld	a0,336(s2)
    80004d04:	ffffe097          	auipc	ra,0xffffe
    80004d08:	f84080e7          	jalr	-124(ra) # 80002c88 <iput>
  end_op();
    80004d0c:	ffffe097          	auipc	ra,0xffffe
    80004d10:	7e2080e7          	jalr	2018(ra) # 800034ee <end_op>
  p->cwd = ip;
    80004d14:	14993823          	sd	s1,336(s2)
  return 0;
    80004d18:	4501                	li	a0,0
}
    80004d1a:	60ea                	ld	ra,152(sp)
    80004d1c:	644a                	ld	s0,144(sp)
    80004d1e:	64aa                	ld	s1,136(sp)
    80004d20:	690a                	ld	s2,128(sp)
    80004d22:	610d                	addi	sp,sp,160
    80004d24:	8082                	ret
    end_op();
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	7c8080e7          	jalr	1992(ra) # 800034ee <end_op>
    return -1;
    80004d2e:	557d                	li	a0,-1
    80004d30:	b7ed                	j	80004d1a <sys_chdir+0x7a>
    iunlockput(ip);
    80004d32:	8526                	mv	a0,s1
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	ffc080e7          	jalr	-4(ra) # 80002d30 <iunlockput>
    end_op();
    80004d3c:	ffffe097          	auipc	ra,0xffffe
    80004d40:	7b2080e7          	jalr	1970(ra) # 800034ee <end_op>
    return -1;
    80004d44:	557d                	li	a0,-1
    80004d46:	bfd1                	j	80004d1a <sys_chdir+0x7a>

0000000080004d48 <sys_exec>:

uint64
sys_exec(void)
{
    80004d48:	7121                	addi	sp,sp,-448
    80004d4a:	ff06                	sd	ra,440(sp)
    80004d4c:	fb22                	sd	s0,432(sp)
    80004d4e:	f726                	sd	s1,424(sp)
    80004d50:	f34a                	sd	s2,416(sp)
    80004d52:	ef4e                	sd	s3,408(sp)
    80004d54:	eb52                	sd	s4,400(sp)
    80004d56:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004d58:	e4840593          	addi	a1,s0,-440
    80004d5c:	4505                	li	a0,1
    80004d5e:	ffffd097          	auipc	ra,0xffffd
    80004d62:	22e080e7          	jalr	558(ra) # 80001f8c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004d66:	08000613          	li	a2,128
    80004d6a:	f5040593          	addi	a1,s0,-176
    80004d6e:	4501                	li	a0,0
    80004d70:	ffffd097          	auipc	ra,0xffffd
    80004d74:	23c080e7          	jalr	572(ra) # 80001fac <argstr>
    80004d78:	87aa                	mv	a5,a0
    return -1;
    80004d7a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004d7c:	0c07c263          	bltz	a5,80004e40 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004d80:	10000613          	li	a2,256
    80004d84:	4581                	li	a1,0
    80004d86:	e5040513          	addi	a0,s0,-432
    80004d8a:	ffffb097          	auipc	ra,0xffffb
    80004d8e:	3f0080e7          	jalr	1008(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004d92:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004d96:	89a6                	mv	s3,s1
    80004d98:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004d9a:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004d9e:	00391513          	slli	a0,s2,0x3
    80004da2:	e4040593          	addi	a1,s0,-448
    80004da6:	e4843783          	ld	a5,-440(s0)
    80004daa:	953e                	add	a0,a0,a5
    80004dac:	ffffd097          	auipc	ra,0xffffd
    80004db0:	122080e7          	jalr	290(ra) # 80001ece <fetchaddr>
    80004db4:	02054a63          	bltz	a0,80004de8 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004db8:	e4043783          	ld	a5,-448(s0)
    80004dbc:	c3b9                	beqz	a5,80004e02 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004dbe:	ffffb097          	auipc	ra,0xffffb
    80004dc2:	35c080e7          	jalr	860(ra) # 8000011a <kalloc>
    80004dc6:	85aa                	mv	a1,a0
    80004dc8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004dcc:	cd11                	beqz	a0,80004de8 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004dce:	6605                	lui	a2,0x1
    80004dd0:	e4043503          	ld	a0,-448(s0)
    80004dd4:	ffffd097          	auipc	ra,0xffffd
    80004dd8:	14c080e7          	jalr	332(ra) # 80001f20 <fetchstr>
    80004ddc:	00054663          	bltz	a0,80004de8 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004de0:	0905                	addi	s2,s2,1
    80004de2:	09a1                	addi	s3,s3,8
    80004de4:	fb491de3          	bne	s2,s4,80004d9e <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004de8:	f5040913          	addi	s2,s0,-176
    80004dec:	6088                	ld	a0,0(s1)
    80004dee:	c921                	beqz	a0,80004e3e <sys_exec+0xf6>
    kfree(argv[i]);
    80004df0:	ffffb097          	auipc	ra,0xffffb
    80004df4:	22c080e7          	jalr	556(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004df8:	04a1                	addi	s1,s1,8
    80004dfa:	ff2499e3          	bne	s1,s2,80004dec <sys_exec+0xa4>
  return -1;
    80004dfe:	557d                	li	a0,-1
    80004e00:	a081                	j	80004e40 <sys_exec+0xf8>
      argv[i] = 0;
    80004e02:	0009079b          	sext.w	a5,s2
    80004e06:	078e                	slli	a5,a5,0x3
    80004e08:	fd078793          	addi	a5,a5,-48
    80004e0c:	97a2                	add	a5,a5,s0
    80004e0e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004e12:	e5040593          	addi	a1,s0,-432
    80004e16:	f5040513          	addi	a0,s0,-176
    80004e1a:	fffff097          	auipc	ra,0xfffff
    80004e1e:	194080e7          	jalr	404(ra) # 80003fae <exec>
    80004e22:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e24:	f5040993          	addi	s3,s0,-176
    80004e28:	6088                	ld	a0,0(s1)
    80004e2a:	c901                	beqz	a0,80004e3a <sys_exec+0xf2>
    kfree(argv[i]);
    80004e2c:	ffffb097          	auipc	ra,0xffffb
    80004e30:	1f0080e7          	jalr	496(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e34:	04a1                	addi	s1,s1,8
    80004e36:	ff3499e3          	bne	s1,s3,80004e28 <sys_exec+0xe0>
  return ret;
    80004e3a:	854a                	mv	a0,s2
    80004e3c:	a011                	j	80004e40 <sys_exec+0xf8>
  return -1;
    80004e3e:	557d                	li	a0,-1
}
    80004e40:	70fa                	ld	ra,440(sp)
    80004e42:	745a                	ld	s0,432(sp)
    80004e44:	74ba                	ld	s1,424(sp)
    80004e46:	791a                	ld	s2,416(sp)
    80004e48:	69fa                	ld	s3,408(sp)
    80004e4a:	6a5a                	ld	s4,400(sp)
    80004e4c:	6139                	addi	sp,sp,448
    80004e4e:	8082                	ret

0000000080004e50 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004e50:	7139                	addi	sp,sp,-64
    80004e52:	fc06                	sd	ra,56(sp)
    80004e54:	f822                	sd	s0,48(sp)
    80004e56:	f426                	sd	s1,40(sp)
    80004e58:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004e5a:	ffffc097          	auipc	ra,0xffffc
    80004e5e:	ff8080e7          	jalr	-8(ra) # 80000e52 <myproc>
    80004e62:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004e64:	fd840593          	addi	a1,s0,-40
    80004e68:	4501                	li	a0,0
    80004e6a:	ffffd097          	auipc	ra,0xffffd
    80004e6e:	122080e7          	jalr	290(ra) # 80001f8c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004e72:	fc840593          	addi	a1,s0,-56
    80004e76:	fd040513          	addi	a0,s0,-48
    80004e7a:	fffff097          	auipc	ra,0xfffff
    80004e7e:	dea080e7          	jalr	-534(ra) # 80003c64 <pipealloc>
    return -1;
    80004e82:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004e84:	0c054463          	bltz	a0,80004f4c <sys_pipe+0xfc>
  fd0 = -1;
    80004e88:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004e8c:	fd043503          	ld	a0,-48(s0)
    80004e90:	fffff097          	auipc	ra,0xfffff
    80004e94:	524080e7          	jalr	1316(ra) # 800043b4 <fdalloc>
    80004e98:	fca42223          	sw	a0,-60(s0)
    80004e9c:	08054b63          	bltz	a0,80004f32 <sys_pipe+0xe2>
    80004ea0:	fc843503          	ld	a0,-56(s0)
    80004ea4:	fffff097          	auipc	ra,0xfffff
    80004ea8:	510080e7          	jalr	1296(ra) # 800043b4 <fdalloc>
    80004eac:	fca42023          	sw	a0,-64(s0)
    80004eb0:	06054863          	bltz	a0,80004f20 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004eb4:	4691                	li	a3,4
    80004eb6:	fc440613          	addi	a2,s0,-60
    80004eba:	fd843583          	ld	a1,-40(s0)
    80004ebe:	68a8                	ld	a0,80(s1)
    80004ec0:	ffffc097          	auipc	ra,0xffffc
    80004ec4:	c52080e7          	jalr	-942(ra) # 80000b12 <copyout>
    80004ec8:	02054063          	bltz	a0,80004ee8 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004ecc:	4691                	li	a3,4
    80004ece:	fc040613          	addi	a2,s0,-64
    80004ed2:	fd843583          	ld	a1,-40(s0)
    80004ed6:	0591                	addi	a1,a1,4
    80004ed8:	68a8                	ld	a0,80(s1)
    80004eda:	ffffc097          	auipc	ra,0xffffc
    80004ede:	c38080e7          	jalr	-968(ra) # 80000b12 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004ee2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ee4:	06055463          	bgez	a0,80004f4c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004ee8:	fc442783          	lw	a5,-60(s0)
    80004eec:	07e9                	addi	a5,a5,26
    80004eee:	078e                	slli	a5,a5,0x3
    80004ef0:	97a6                	add	a5,a5,s1
    80004ef2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004ef6:	fc042783          	lw	a5,-64(s0)
    80004efa:	07e9                	addi	a5,a5,26
    80004efc:	078e                	slli	a5,a5,0x3
    80004efe:	94be                	add	s1,s1,a5
    80004f00:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f04:	fd043503          	ld	a0,-48(s0)
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	a30080e7          	jalr	-1488(ra) # 80003938 <fileclose>
    fileclose(wf);
    80004f10:	fc843503          	ld	a0,-56(s0)
    80004f14:	fffff097          	auipc	ra,0xfffff
    80004f18:	a24080e7          	jalr	-1500(ra) # 80003938 <fileclose>
    return -1;
    80004f1c:	57fd                	li	a5,-1
    80004f1e:	a03d                	j	80004f4c <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004f20:	fc442783          	lw	a5,-60(s0)
    80004f24:	0007c763          	bltz	a5,80004f32 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004f28:	07e9                	addi	a5,a5,26
    80004f2a:	078e                	slli	a5,a5,0x3
    80004f2c:	97a6                	add	a5,a5,s1
    80004f2e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004f32:	fd043503          	ld	a0,-48(s0)
    80004f36:	fffff097          	auipc	ra,0xfffff
    80004f3a:	a02080e7          	jalr	-1534(ra) # 80003938 <fileclose>
    fileclose(wf);
    80004f3e:	fc843503          	ld	a0,-56(s0)
    80004f42:	fffff097          	auipc	ra,0xfffff
    80004f46:	9f6080e7          	jalr	-1546(ra) # 80003938 <fileclose>
    return -1;
    80004f4a:	57fd                	li	a5,-1
}
    80004f4c:	853e                	mv	a0,a5
    80004f4e:	70e2                	ld	ra,56(sp)
    80004f50:	7442                	ld	s0,48(sp)
    80004f52:	74a2                	ld	s1,40(sp)
    80004f54:	6121                	addi	sp,sp,64
    80004f56:	8082                	ret
	...

0000000080004f60 <kernelvec>:
    80004f60:	7111                	addi	sp,sp,-256
    80004f62:	e006                	sd	ra,0(sp)
    80004f64:	e40a                	sd	sp,8(sp)
    80004f66:	e80e                	sd	gp,16(sp)
    80004f68:	ec12                	sd	tp,24(sp)
    80004f6a:	f016                	sd	t0,32(sp)
    80004f6c:	f41a                	sd	t1,40(sp)
    80004f6e:	f81e                	sd	t2,48(sp)
    80004f70:	fc22                	sd	s0,56(sp)
    80004f72:	e0a6                	sd	s1,64(sp)
    80004f74:	e4aa                	sd	a0,72(sp)
    80004f76:	e8ae                	sd	a1,80(sp)
    80004f78:	ecb2                	sd	a2,88(sp)
    80004f7a:	f0b6                	sd	a3,96(sp)
    80004f7c:	f4ba                	sd	a4,104(sp)
    80004f7e:	f8be                	sd	a5,112(sp)
    80004f80:	fcc2                	sd	a6,120(sp)
    80004f82:	e146                	sd	a7,128(sp)
    80004f84:	e54a                	sd	s2,136(sp)
    80004f86:	e94e                	sd	s3,144(sp)
    80004f88:	ed52                	sd	s4,152(sp)
    80004f8a:	f156                	sd	s5,160(sp)
    80004f8c:	f55a                	sd	s6,168(sp)
    80004f8e:	f95e                	sd	s7,176(sp)
    80004f90:	fd62                	sd	s8,184(sp)
    80004f92:	e1e6                	sd	s9,192(sp)
    80004f94:	e5ea                	sd	s10,200(sp)
    80004f96:	e9ee                	sd	s11,208(sp)
    80004f98:	edf2                	sd	t3,216(sp)
    80004f9a:	f1f6                	sd	t4,224(sp)
    80004f9c:	f5fa                	sd	t5,232(sp)
    80004f9e:	f9fe                	sd	t6,240(sp)
    80004fa0:	dfbfc0ef          	jal	ra,80001d9a <kerneltrap>
    80004fa4:	6082                	ld	ra,0(sp)
    80004fa6:	6122                	ld	sp,8(sp)
    80004fa8:	61c2                	ld	gp,16(sp)
    80004faa:	7282                	ld	t0,32(sp)
    80004fac:	7322                	ld	t1,40(sp)
    80004fae:	73c2                	ld	t2,48(sp)
    80004fb0:	7462                	ld	s0,56(sp)
    80004fb2:	6486                	ld	s1,64(sp)
    80004fb4:	6526                	ld	a0,72(sp)
    80004fb6:	65c6                	ld	a1,80(sp)
    80004fb8:	6666                	ld	a2,88(sp)
    80004fba:	7686                	ld	a3,96(sp)
    80004fbc:	7726                	ld	a4,104(sp)
    80004fbe:	77c6                	ld	a5,112(sp)
    80004fc0:	7866                	ld	a6,120(sp)
    80004fc2:	688a                	ld	a7,128(sp)
    80004fc4:	692a                	ld	s2,136(sp)
    80004fc6:	69ca                	ld	s3,144(sp)
    80004fc8:	6a6a                	ld	s4,152(sp)
    80004fca:	7a8a                	ld	s5,160(sp)
    80004fcc:	7b2a                	ld	s6,168(sp)
    80004fce:	7bca                	ld	s7,176(sp)
    80004fd0:	7c6a                	ld	s8,184(sp)
    80004fd2:	6c8e                	ld	s9,192(sp)
    80004fd4:	6d2e                	ld	s10,200(sp)
    80004fd6:	6dce                	ld	s11,208(sp)
    80004fd8:	6e6e                	ld	t3,216(sp)
    80004fda:	7e8e                	ld	t4,224(sp)
    80004fdc:	7f2e                	ld	t5,232(sp)
    80004fde:	7fce                	ld	t6,240(sp)
    80004fe0:	6111                	addi	sp,sp,256
    80004fe2:	10200073          	sret
    80004fe6:	00000013          	nop
    80004fea:	00000013          	nop
    80004fee:	0001                	nop

0000000080004ff0 <timervec>:
    80004ff0:	34051573          	csrrw	a0,mscratch,a0
    80004ff4:	e10c                	sd	a1,0(a0)
    80004ff6:	e510                	sd	a2,8(a0)
    80004ff8:	e914                	sd	a3,16(a0)
    80004ffa:	6d0c                	ld	a1,24(a0)
    80004ffc:	7110                	ld	a2,32(a0)
    80004ffe:	6194                	ld	a3,0(a1)
    80005000:	96b2                	add	a3,a3,a2
    80005002:	e194                	sd	a3,0(a1)
    80005004:	4589                	li	a1,2
    80005006:	14459073          	csrw	sip,a1
    8000500a:	6914                	ld	a3,16(a0)
    8000500c:	6510                	ld	a2,8(a0)
    8000500e:	610c                	ld	a1,0(a0)
    80005010:	34051573          	csrrw	a0,mscratch,a0
    80005014:	30200073          	mret
	...

000000008000501a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000501a:	1141                	addi	sp,sp,-16
    8000501c:	e422                	sd	s0,8(sp)
    8000501e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005020:	0c0007b7          	lui	a5,0xc000
    80005024:	4705                	li	a4,1
    80005026:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005028:	c3d8                	sw	a4,4(a5)
}
    8000502a:	6422                	ld	s0,8(sp)
    8000502c:	0141                	addi	sp,sp,16
    8000502e:	8082                	ret

0000000080005030 <plicinithart>:

void
plicinithart(void)
{
    80005030:	1141                	addi	sp,sp,-16
    80005032:	e406                	sd	ra,8(sp)
    80005034:	e022                	sd	s0,0(sp)
    80005036:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005038:	ffffc097          	auipc	ra,0xffffc
    8000503c:	dee080e7          	jalr	-530(ra) # 80000e26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005040:	0085171b          	slliw	a4,a0,0x8
    80005044:	0c0027b7          	lui	a5,0xc002
    80005048:	97ba                	add	a5,a5,a4
    8000504a:	40200713          	li	a4,1026
    8000504e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005052:	00d5151b          	slliw	a0,a0,0xd
    80005056:	0c2017b7          	lui	a5,0xc201
    8000505a:	97aa                	add	a5,a5,a0
    8000505c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005060:	60a2                	ld	ra,8(sp)
    80005062:	6402                	ld	s0,0(sp)
    80005064:	0141                	addi	sp,sp,16
    80005066:	8082                	ret

0000000080005068 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005068:	1141                	addi	sp,sp,-16
    8000506a:	e406                	sd	ra,8(sp)
    8000506c:	e022                	sd	s0,0(sp)
    8000506e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005070:	ffffc097          	auipc	ra,0xffffc
    80005074:	db6080e7          	jalr	-586(ra) # 80000e26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005078:	00d5151b          	slliw	a0,a0,0xd
    8000507c:	0c2017b7          	lui	a5,0xc201
    80005080:	97aa                	add	a5,a5,a0
  return irq;
}
    80005082:	43c8                	lw	a0,4(a5)
    80005084:	60a2                	ld	ra,8(sp)
    80005086:	6402                	ld	s0,0(sp)
    80005088:	0141                	addi	sp,sp,16
    8000508a:	8082                	ret

000000008000508c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000508c:	1101                	addi	sp,sp,-32
    8000508e:	ec06                	sd	ra,24(sp)
    80005090:	e822                	sd	s0,16(sp)
    80005092:	e426                	sd	s1,8(sp)
    80005094:	1000                	addi	s0,sp,32
    80005096:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005098:	ffffc097          	auipc	ra,0xffffc
    8000509c:	d8e080e7          	jalr	-626(ra) # 80000e26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800050a0:	00d5151b          	slliw	a0,a0,0xd
    800050a4:	0c2017b7          	lui	a5,0xc201
    800050a8:	97aa                	add	a5,a5,a0
    800050aa:	c3c4                	sw	s1,4(a5)
}
    800050ac:	60e2                	ld	ra,24(sp)
    800050ae:	6442                	ld	s0,16(sp)
    800050b0:	64a2                	ld	s1,8(sp)
    800050b2:	6105                	addi	sp,sp,32
    800050b4:	8082                	ret

00000000800050b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800050b6:	1141                	addi	sp,sp,-16
    800050b8:	e406                	sd	ra,8(sp)
    800050ba:	e022                	sd	s0,0(sp)
    800050bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800050be:	479d                	li	a5,7
    800050c0:	04a7cc63          	blt	a5,a0,80005118 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800050c4:	00015797          	auipc	a5,0x15
    800050c8:	90c78793          	addi	a5,a5,-1780 # 800199d0 <disk>
    800050cc:	97aa                	add	a5,a5,a0
    800050ce:	0187c783          	lbu	a5,24(a5)
    800050d2:	ebb9                	bnez	a5,80005128 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800050d4:	00451693          	slli	a3,a0,0x4
    800050d8:	00015797          	auipc	a5,0x15
    800050dc:	8f878793          	addi	a5,a5,-1800 # 800199d0 <disk>
    800050e0:	6398                	ld	a4,0(a5)
    800050e2:	9736                	add	a4,a4,a3
    800050e4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800050e8:	6398                	ld	a4,0(a5)
    800050ea:	9736                	add	a4,a4,a3
    800050ec:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800050f0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800050f4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800050f8:	97aa                	add	a5,a5,a0
    800050fa:	4705                	li	a4,1
    800050fc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005100:	00015517          	auipc	a0,0x15
    80005104:	8e850513          	addi	a0,a0,-1816 # 800199e8 <disk+0x18>
    80005108:	ffffc097          	auipc	ra,0xffffc
    8000510c:	456080e7          	jalr	1110(ra) # 8000155e <wakeup>
}
    80005110:	60a2                	ld	ra,8(sp)
    80005112:	6402                	ld	s0,0(sp)
    80005114:	0141                	addi	sp,sp,16
    80005116:	8082                	ret
    panic("free_desc 1");
    80005118:	00003517          	auipc	a0,0x3
    8000511c:	5a850513          	addi	a0,a0,1448 # 800086c0 <syscalls+0x2f0>
    80005120:	00001097          	auipc	ra,0x1
    80005124:	a06080e7          	jalr	-1530(ra) # 80005b26 <panic>
    panic("free_desc 2");
    80005128:	00003517          	auipc	a0,0x3
    8000512c:	5a850513          	addi	a0,a0,1448 # 800086d0 <syscalls+0x300>
    80005130:	00001097          	auipc	ra,0x1
    80005134:	9f6080e7          	jalr	-1546(ra) # 80005b26 <panic>

0000000080005138 <virtio_disk_init>:
{
    80005138:	1101                	addi	sp,sp,-32
    8000513a:	ec06                	sd	ra,24(sp)
    8000513c:	e822                	sd	s0,16(sp)
    8000513e:	e426                	sd	s1,8(sp)
    80005140:	e04a                	sd	s2,0(sp)
    80005142:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005144:	00003597          	auipc	a1,0x3
    80005148:	59c58593          	addi	a1,a1,1436 # 800086e0 <syscalls+0x310>
    8000514c:	00015517          	auipc	a0,0x15
    80005150:	9ac50513          	addi	a0,a0,-1620 # 80019af8 <disk+0x128>
    80005154:	00001097          	auipc	ra,0x1
    80005158:	e7a080e7          	jalr	-390(ra) # 80005fce <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000515c:	100017b7          	lui	a5,0x10001
    80005160:	4398                	lw	a4,0(a5)
    80005162:	2701                	sext.w	a4,a4
    80005164:	747277b7          	lui	a5,0x74727
    80005168:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000516c:	14f71b63          	bne	a4,a5,800052c2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005170:	100017b7          	lui	a5,0x10001
    80005174:	43dc                	lw	a5,4(a5)
    80005176:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005178:	4709                	li	a4,2
    8000517a:	14e79463          	bne	a5,a4,800052c2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000517e:	100017b7          	lui	a5,0x10001
    80005182:	479c                	lw	a5,8(a5)
    80005184:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005186:	12e79e63          	bne	a5,a4,800052c2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000518a:	100017b7          	lui	a5,0x10001
    8000518e:	47d8                	lw	a4,12(a5)
    80005190:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005192:	554d47b7          	lui	a5,0x554d4
    80005196:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000519a:	12f71463          	bne	a4,a5,800052c2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000519e:	100017b7          	lui	a5,0x10001
    800051a2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051a6:	4705                	li	a4,1
    800051a8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051aa:	470d                	li	a4,3
    800051ac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800051ae:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800051b0:	c7ffe6b7          	lui	a3,0xc7ffe
    800051b4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdca0f>
    800051b8:	8f75                	and	a4,a4,a3
    800051ba:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051bc:	472d                	li	a4,11
    800051be:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800051c0:	5bbc                	lw	a5,112(a5)
    800051c2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800051c6:	8ba1                	andi	a5,a5,8
    800051c8:	10078563          	beqz	a5,800052d2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800051cc:	100017b7          	lui	a5,0x10001
    800051d0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800051d4:	43fc                	lw	a5,68(a5)
    800051d6:	2781                	sext.w	a5,a5
    800051d8:	10079563          	bnez	a5,800052e2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800051dc:	100017b7          	lui	a5,0x10001
    800051e0:	5bdc                	lw	a5,52(a5)
    800051e2:	2781                	sext.w	a5,a5
  if(max == 0)
    800051e4:	10078763          	beqz	a5,800052f2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800051e8:	471d                	li	a4,7
    800051ea:	10f77c63          	bgeu	a4,a5,80005302 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800051ee:	ffffb097          	auipc	ra,0xffffb
    800051f2:	f2c080e7          	jalr	-212(ra) # 8000011a <kalloc>
    800051f6:	00014497          	auipc	s1,0x14
    800051fa:	7da48493          	addi	s1,s1,2010 # 800199d0 <disk>
    800051fe:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005200:	ffffb097          	auipc	ra,0xffffb
    80005204:	f1a080e7          	jalr	-230(ra) # 8000011a <kalloc>
    80005208:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000520a:	ffffb097          	auipc	ra,0xffffb
    8000520e:	f10080e7          	jalr	-240(ra) # 8000011a <kalloc>
    80005212:	87aa                	mv	a5,a0
    80005214:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005216:	6088                	ld	a0,0(s1)
    80005218:	cd6d                	beqz	a0,80005312 <virtio_disk_init+0x1da>
    8000521a:	00014717          	auipc	a4,0x14
    8000521e:	7be73703          	ld	a4,1982(a4) # 800199d8 <disk+0x8>
    80005222:	cb65                	beqz	a4,80005312 <virtio_disk_init+0x1da>
    80005224:	c7fd                	beqz	a5,80005312 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005226:	6605                	lui	a2,0x1
    80005228:	4581                	li	a1,0
    8000522a:	ffffb097          	auipc	ra,0xffffb
    8000522e:	f50080e7          	jalr	-176(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005232:	00014497          	auipc	s1,0x14
    80005236:	79e48493          	addi	s1,s1,1950 # 800199d0 <disk>
    8000523a:	6605                	lui	a2,0x1
    8000523c:	4581                	li	a1,0
    8000523e:	6488                	ld	a0,8(s1)
    80005240:	ffffb097          	auipc	ra,0xffffb
    80005244:	f3a080e7          	jalr	-198(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005248:	6605                	lui	a2,0x1
    8000524a:	4581                	li	a1,0
    8000524c:	6888                	ld	a0,16(s1)
    8000524e:	ffffb097          	auipc	ra,0xffffb
    80005252:	f2c080e7          	jalr	-212(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005256:	100017b7          	lui	a5,0x10001
    8000525a:	4721                	li	a4,8
    8000525c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000525e:	4098                	lw	a4,0(s1)
    80005260:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005264:	40d8                	lw	a4,4(s1)
    80005266:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000526a:	6498                	ld	a4,8(s1)
    8000526c:	0007069b          	sext.w	a3,a4
    80005270:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005274:	9701                	srai	a4,a4,0x20
    80005276:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000527a:	6898                	ld	a4,16(s1)
    8000527c:	0007069b          	sext.w	a3,a4
    80005280:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005284:	9701                	srai	a4,a4,0x20
    80005286:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000528a:	4705                	li	a4,1
    8000528c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000528e:	00e48c23          	sb	a4,24(s1)
    80005292:	00e48ca3          	sb	a4,25(s1)
    80005296:	00e48d23          	sb	a4,26(s1)
    8000529a:	00e48da3          	sb	a4,27(s1)
    8000529e:	00e48e23          	sb	a4,28(s1)
    800052a2:	00e48ea3          	sb	a4,29(s1)
    800052a6:	00e48f23          	sb	a4,30(s1)
    800052aa:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800052ae:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b2:	0727a823          	sw	s2,112(a5)
}
    800052b6:	60e2                	ld	ra,24(sp)
    800052b8:	6442                	ld	s0,16(sp)
    800052ba:	64a2                	ld	s1,8(sp)
    800052bc:	6902                	ld	s2,0(sp)
    800052be:	6105                	addi	sp,sp,32
    800052c0:	8082                	ret
    panic("could not find virtio disk");
    800052c2:	00003517          	auipc	a0,0x3
    800052c6:	42e50513          	addi	a0,a0,1070 # 800086f0 <syscalls+0x320>
    800052ca:	00001097          	auipc	ra,0x1
    800052ce:	85c080e7          	jalr	-1956(ra) # 80005b26 <panic>
    panic("virtio disk FEATURES_OK unset");
    800052d2:	00003517          	auipc	a0,0x3
    800052d6:	43e50513          	addi	a0,a0,1086 # 80008710 <syscalls+0x340>
    800052da:	00001097          	auipc	ra,0x1
    800052de:	84c080e7          	jalr	-1972(ra) # 80005b26 <panic>
    panic("virtio disk should not be ready");
    800052e2:	00003517          	auipc	a0,0x3
    800052e6:	44e50513          	addi	a0,a0,1102 # 80008730 <syscalls+0x360>
    800052ea:	00001097          	auipc	ra,0x1
    800052ee:	83c080e7          	jalr	-1988(ra) # 80005b26 <panic>
    panic("virtio disk has no queue 0");
    800052f2:	00003517          	auipc	a0,0x3
    800052f6:	45e50513          	addi	a0,a0,1118 # 80008750 <syscalls+0x380>
    800052fa:	00001097          	auipc	ra,0x1
    800052fe:	82c080e7          	jalr	-2004(ra) # 80005b26 <panic>
    panic("virtio disk max queue too short");
    80005302:	00003517          	auipc	a0,0x3
    80005306:	46e50513          	addi	a0,a0,1134 # 80008770 <syscalls+0x3a0>
    8000530a:	00001097          	auipc	ra,0x1
    8000530e:	81c080e7          	jalr	-2020(ra) # 80005b26 <panic>
    panic("virtio disk kalloc");
    80005312:	00003517          	auipc	a0,0x3
    80005316:	47e50513          	addi	a0,a0,1150 # 80008790 <syscalls+0x3c0>
    8000531a:	00001097          	auipc	ra,0x1
    8000531e:	80c080e7          	jalr	-2036(ra) # 80005b26 <panic>

0000000080005322 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005322:	7159                	addi	sp,sp,-112
    80005324:	f486                	sd	ra,104(sp)
    80005326:	f0a2                	sd	s0,96(sp)
    80005328:	eca6                	sd	s1,88(sp)
    8000532a:	e8ca                	sd	s2,80(sp)
    8000532c:	e4ce                	sd	s3,72(sp)
    8000532e:	e0d2                	sd	s4,64(sp)
    80005330:	fc56                	sd	s5,56(sp)
    80005332:	f85a                	sd	s6,48(sp)
    80005334:	f45e                	sd	s7,40(sp)
    80005336:	f062                	sd	s8,32(sp)
    80005338:	ec66                	sd	s9,24(sp)
    8000533a:	e86a                	sd	s10,16(sp)
    8000533c:	1880                	addi	s0,sp,112
    8000533e:	8a2a                	mv	s4,a0
    80005340:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005342:	00c52c83          	lw	s9,12(a0)
    80005346:	001c9c9b          	slliw	s9,s9,0x1
    8000534a:	1c82                	slli	s9,s9,0x20
    8000534c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005350:	00014517          	auipc	a0,0x14
    80005354:	7a850513          	addi	a0,a0,1960 # 80019af8 <disk+0x128>
    80005358:	00001097          	auipc	ra,0x1
    8000535c:	d06080e7          	jalr	-762(ra) # 8000605e <acquire>
  for(int i = 0; i < 3; i++){
    80005360:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005362:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005364:	00014b17          	auipc	s6,0x14
    80005368:	66cb0b13          	addi	s6,s6,1644 # 800199d0 <disk>
  for(int i = 0; i < 3; i++){
    8000536c:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000536e:	00014c17          	auipc	s8,0x14
    80005372:	78ac0c13          	addi	s8,s8,1930 # 80019af8 <disk+0x128>
    80005376:	a095                	j	800053da <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005378:	00fb0733          	add	a4,s6,a5
    8000537c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005380:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005382:	0207c563          	bltz	a5,800053ac <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005386:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005388:	0591                	addi	a1,a1,4
    8000538a:	05560d63          	beq	a2,s5,800053e4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000538e:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005390:	00014717          	auipc	a4,0x14
    80005394:	64070713          	addi	a4,a4,1600 # 800199d0 <disk>
    80005398:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000539a:	01874683          	lbu	a3,24(a4)
    8000539e:	fee9                	bnez	a3,80005378 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    800053a0:	2785                	addiw	a5,a5,1
    800053a2:	0705                	addi	a4,a4,1
    800053a4:	fe979be3          	bne	a5,s1,8000539a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    800053a8:	57fd                	li	a5,-1
    800053aa:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800053ac:	00c05e63          	blez	a2,800053c8 <virtio_disk_rw+0xa6>
    800053b0:	060a                	slli	a2,a2,0x2
    800053b2:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800053b6:	0009a503          	lw	a0,0(s3)
    800053ba:	00000097          	auipc	ra,0x0
    800053be:	cfc080e7          	jalr	-772(ra) # 800050b6 <free_desc>
      for(int j = 0; j < i; j++)
    800053c2:	0991                	addi	s3,s3,4
    800053c4:	ffa999e3          	bne	s3,s10,800053b6 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053c8:	85e2                	mv	a1,s8
    800053ca:	00014517          	auipc	a0,0x14
    800053ce:	61e50513          	addi	a0,a0,1566 # 800199e8 <disk+0x18>
    800053d2:	ffffc097          	auipc	ra,0xffffc
    800053d6:	128080e7          	jalr	296(ra) # 800014fa <sleep>
  for(int i = 0; i < 3; i++){
    800053da:	f9040993          	addi	s3,s0,-112
{
    800053de:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800053e0:	864a                	mv	a2,s2
    800053e2:	b775                	j	8000538e <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800053e4:	f9042503          	lw	a0,-112(s0)
    800053e8:	00a50713          	addi	a4,a0,10
    800053ec:	0712                	slli	a4,a4,0x4

  if(write)
    800053ee:	00014797          	auipc	a5,0x14
    800053f2:	5e278793          	addi	a5,a5,1506 # 800199d0 <disk>
    800053f6:	00e786b3          	add	a3,a5,a4
    800053fa:	01703633          	snez	a2,s7
    800053fe:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005400:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005404:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005408:	f6070613          	addi	a2,a4,-160
    8000540c:	6394                	ld	a3,0(a5)
    8000540e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005410:	00870593          	addi	a1,a4,8
    80005414:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005416:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005418:	0007b803          	ld	a6,0(a5)
    8000541c:	9642                	add	a2,a2,a6
    8000541e:	46c1                	li	a3,16
    80005420:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005422:	4585                	li	a1,1
    80005424:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005428:	f9442683          	lw	a3,-108(s0)
    8000542c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005430:	0692                	slli	a3,a3,0x4
    80005432:	9836                	add	a6,a6,a3
    80005434:	058a0613          	addi	a2,s4,88
    80005438:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000543c:	0007b803          	ld	a6,0(a5)
    80005440:	96c2                	add	a3,a3,a6
    80005442:	40000613          	li	a2,1024
    80005446:	c690                	sw	a2,8(a3)
  if(write)
    80005448:	001bb613          	seqz	a2,s7
    8000544c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005450:	00166613          	ori	a2,a2,1
    80005454:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005458:	f9842603          	lw	a2,-104(s0)
    8000545c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005460:	00250693          	addi	a3,a0,2
    80005464:	0692                	slli	a3,a3,0x4
    80005466:	96be                	add	a3,a3,a5
    80005468:	58fd                	li	a7,-1
    8000546a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000546e:	0612                	slli	a2,a2,0x4
    80005470:	9832                	add	a6,a6,a2
    80005472:	f9070713          	addi	a4,a4,-112
    80005476:	973e                	add	a4,a4,a5
    80005478:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000547c:	6398                	ld	a4,0(a5)
    8000547e:	9732                	add	a4,a4,a2
    80005480:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005482:	4609                	li	a2,2
    80005484:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005488:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000548c:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005490:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005494:	6794                	ld	a3,8(a5)
    80005496:	0026d703          	lhu	a4,2(a3)
    8000549a:	8b1d                	andi	a4,a4,7
    8000549c:	0706                	slli	a4,a4,0x1
    8000549e:	96ba                	add	a3,a3,a4
    800054a0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800054a4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054a8:	6798                	ld	a4,8(a5)
    800054aa:	00275783          	lhu	a5,2(a4)
    800054ae:	2785                	addiw	a5,a5,1
    800054b0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800054b4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800054b8:	100017b7          	lui	a5,0x10001
    800054bc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800054c0:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800054c4:	00014917          	auipc	s2,0x14
    800054c8:	63490913          	addi	s2,s2,1588 # 80019af8 <disk+0x128>
  while(b->disk == 1) {
    800054cc:	4485                	li	s1,1
    800054ce:	00b79c63          	bne	a5,a1,800054e6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800054d2:	85ca                	mv	a1,s2
    800054d4:	8552                	mv	a0,s4
    800054d6:	ffffc097          	auipc	ra,0xffffc
    800054da:	024080e7          	jalr	36(ra) # 800014fa <sleep>
  while(b->disk == 1) {
    800054de:	004a2783          	lw	a5,4(s4)
    800054e2:	fe9788e3          	beq	a5,s1,800054d2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800054e6:	f9042903          	lw	s2,-112(s0)
    800054ea:	00290713          	addi	a4,s2,2
    800054ee:	0712                	slli	a4,a4,0x4
    800054f0:	00014797          	auipc	a5,0x14
    800054f4:	4e078793          	addi	a5,a5,1248 # 800199d0 <disk>
    800054f8:	97ba                	add	a5,a5,a4
    800054fa:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800054fe:	00014997          	auipc	s3,0x14
    80005502:	4d298993          	addi	s3,s3,1234 # 800199d0 <disk>
    80005506:	00491713          	slli	a4,s2,0x4
    8000550a:	0009b783          	ld	a5,0(s3)
    8000550e:	97ba                	add	a5,a5,a4
    80005510:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005514:	854a                	mv	a0,s2
    80005516:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000551a:	00000097          	auipc	ra,0x0
    8000551e:	b9c080e7          	jalr	-1124(ra) # 800050b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005522:	8885                	andi	s1,s1,1
    80005524:	f0ed                	bnez	s1,80005506 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005526:	00014517          	auipc	a0,0x14
    8000552a:	5d250513          	addi	a0,a0,1490 # 80019af8 <disk+0x128>
    8000552e:	00001097          	auipc	ra,0x1
    80005532:	be4080e7          	jalr	-1052(ra) # 80006112 <release>
}
    80005536:	70a6                	ld	ra,104(sp)
    80005538:	7406                	ld	s0,96(sp)
    8000553a:	64e6                	ld	s1,88(sp)
    8000553c:	6946                	ld	s2,80(sp)
    8000553e:	69a6                	ld	s3,72(sp)
    80005540:	6a06                	ld	s4,64(sp)
    80005542:	7ae2                	ld	s5,56(sp)
    80005544:	7b42                	ld	s6,48(sp)
    80005546:	7ba2                	ld	s7,40(sp)
    80005548:	7c02                	ld	s8,32(sp)
    8000554a:	6ce2                	ld	s9,24(sp)
    8000554c:	6d42                	ld	s10,16(sp)
    8000554e:	6165                	addi	sp,sp,112
    80005550:	8082                	ret

0000000080005552 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005552:	1101                	addi	sp,sp,-32
    80005554:	ec06                	sd	ra,24(sp)
    80005556:	e822                	sd	s0,16(sp)
    80005558:	e426                	sd	s1,8(sp)
    8000555a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000555c:	00014497          	auipc	s1,0x14
    80005560:	47448493          	addi	s1,s1,1140 # 800199d0 <disk>
    80005564:	00014517          	auipc	a0,0x14
    80005568:	59450513          	addi	a0,a0,1428 # 80019af8 <disk+0x128>
    8000556c:	00001097          	auipc	ra,0x1
    80005570:	af2080e7          	jalr	-1294(ra) # 8000605e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005574:	10001737          	lui	a4,0x10001
    80005578:	533c                	lw	a5,96(a4)
    8000557a:	8b8d                	andi	a5,a5,3
    8000557c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000557e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005582:	689c                	ld	a5,16(s1)
    80005584:	0204d703          	lhu	a4,32(s1)
    80005588:	0027d783          	lhu	a5,2(a5)
    8000558c:	04f70863          	beq	a4,a5,800055dc <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005590:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005594:	6898                	ld	a4,16(s1)
    80005596:	0204d783          	lhu	a5,32(s1)
    8000559a:	8b9d                	andi	a5,a5,7
    8000559c:	078e                	slli	a5,a5,0x3
    8000559e:	97ba                	add	a5,a5,a4
    800055a0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800055a2:	00278713          	addi	a4,a5,2
    800055a6:	0712                	slli	a4,a4,0x4
    800055a8:	9726                	add	a4,a4,s1
    800055aa:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800055ae:	e721                	bnez	a4,800055f6 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800055b0:	0789                	addi	a5,a5,2
    800055b2:	0792                	slli	a5,a5,0x4
    800055b4:	97a6                	add	a5,a5,s1
    800055b6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800055b8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800055bc:	ffffc097          	auipc	ra,0xffffc
    800055c0:	fa2080e7          	jalr	-94(ra) # 8000155e <wakeup>

    disk.used_idx += 1;
    800055c4:	0204d783          	lhu	a5,32(s1)
    800055c8:	2785                	addiw	a5,a5,1
    800055ca:	17c2                	slli	a5,a5,0x30
    800055cc:	93c1                	srli	a5,a5,0x30
    800055ce:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800055d2:	6898                	ld	a4,16(s1)
    800055d4:	00275703          	lhu	a4,2(a4)
    800055d8:	faf71ce3          	bne	a4,a5,80005590 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800055dc:	00014517          	auipc	a0,0x14
    800055e0:	51c50513          	addi	a0,a0,1308 # 80019af8 <disk+0x128>
    800055e4:	00001097          	auipc	ra,0x1
    800055e8:	b2e080e7          	jalr	-1234(ra) # 80006112 <release>
}
    800055ec:	60e2                	ld	ra,24(sp)
    800055ee:	6442                	ld	s0,16(sp)
    800055f0:	64a2                	ld	s1,8(sp)
    800055f2:	6105                	addi	sp,sp,32
    800055f4:	8082                	ret
      panic("virtio_disk_intr status");
    800055f6:	00003517          	auipc	a0,0x3
    800055fa:	1b250513          	addi	a0,a0,434 # 800087a8 <syscalls+0x3d8>
    800055fe:	00000097          	auipc	ra,0x0
    80005602:	528080e7          	jalr	1320(ra) # 80005b26 <panic>

0000000080005606 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005606:	1141                	addi	sp,sp,-16
    80005608:	e422                	sd	s0,8(sp)
    8000560a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000560c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005610:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005614:	0037979b          	slliw	a5,a5,0x3
    80005618:	02004737          	lui	a4,0x2004
    8000561c:	97ba                	add	a5,a5,a4
    8000561e:	0200c737          	lui	a4,0x200c
    80005622:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005626:	000f4637          	lui	a2,0xf4
    8000562a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000562e:	9732                	add	a4,a4,a2
    80005630:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005632:	00259693          	slli	a3,a1,0x2
    80005636:	96ae                	add	a3,a3,a1
    80005638:	068e                	slli	a3,a3,0x3
    8000563a:	00014717          	auipc	a4,0x14
    8000563e:	4d670713          	addi	a4,a4,1238 # 80019b10 <timer_scratch>
    80005642:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005644:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005646:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005648:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000564c:	00000797          	auipc	a5,0x0
    80005650:	9a478793          	addi	a5,a5,-1628 # 80004ff0 <timervec>
    80005654:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005658:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000565c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005660:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005664:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005668:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000566c:	30479073          	csrw	mie,a5
}
    80005670:	6422                	ld	s0,8(sp)
    80005672:	0141                	addi	sp,sp,16
    80005674:	8082                	ret

0000000080005676 <start>:
{
    80005676:	1141                	addi	sp,sp,-16
    80005678:	e406                	sd	ra,8(sp)
    8000567a:	e022                	sd	s0,0(sp)
    8000567c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000567e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005682:	7779                	lui	a4,0xffffe
    80005684:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdcaaf>
    80005688:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000568a:	6705                	lui	a4,0x1
    8000568c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005690:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005692:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005696:	ffffb797          	auipc	a5,0xffffb
    8000569a:	c8878793          	addi	a5,a5,-888 # 8000031e <main>
    8000569e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800056a2:	4781                	li	a5,0
    800056a4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800056a8:	67c1                	lui	a5,0x10
    800056aa:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800056ac:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800056b0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800056b4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800056b8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800056bc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800056c0:	57fd                	li	a5,-1
    800056c2:	83a9                	srli	a5,a5,0xa
    800056c4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800056c8:	47bd                	li	a5,15
    800056ca:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800056ce:	00000097          	auipc	ra,0x0
    800056d2:	f38080e7          	jalr	-200(ra) # 80005606 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056d6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800056da:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800056dc:	823e                	mv	tp,a5
  asm volatile("mret");
    800056de:	30200073          	mret
}
    800056e2:	60a2                	ld	ra,8(sp)
    800056e4:	6402                	ld	s0,0(sp)
    800056e6:	0141                	addi	sp,sp,16
    800056e8:	8082                	ret

00000000800056ea <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800056ea:	715d                	addi	sp,sp,-80
    800056ec:	e486                	sd	ra,72(sp)
    800056ee:	e0a2                	sd	s0,64(sp)
    800056f0:	fc26                	sd	s1,56(sp)
    800056f2:	f84a                	sd	s2,48(sp)
    800056f4:	f44e                	sd	s3,40(sp)
    800056f6:	f052                	sd	s4,32(sp)
    800056f8:	ec56                	sd	s5,24(sp)
    800056fa:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800056fc:	04c05763          	blez	a2,8000574a <consolewrite+0x60>
    80005700:	8a2a                	mv	s4,a0
    80005702:	84ae                	mv	s1,a1
    80005704:	89b2                	mv	s3,a2
    80005706:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005708:	5afd                	li	s5,-1
    8000570a:	4685                	li	a3,1
    8000570c:	8626                	mv	a2,s1
    8000570e:	85d2                	mv	a1,s4
    80005710:	fbf40513          	addi	a0,s0,-65
    80005714:	ffffc097          	auipc	ra,0xffffc
    80005718:	244080e7          	jalr	580(ra) # 80001958 <either_copyin>
    8000571c:	01550d63          	beq	a0,s5,80005736 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005720:	fbf44503          	lbu	a0,-65(s0)
    80005724:	00000097          	auipc	ra,0x0
    80005728:	780080e7          	jalr	1920(ra) # 80005ea4 <uartputc>
  for(i = 0; i < n; i++){
    8000572c:	2905                	addiw	s2,s2,1
    8000572e:	0485                	addi	s1,s1,1
    80005730:	fd299de3          	bne	s3,s2,8000570a <consolewrite+0x20>
    80005734:	894e                	mv	s2,s3
  }

  return i;
}
    80005736:	854a                	mv	a0,s2
    80005738:	60a6                	ld	ra,72(sp)
    8000573a:	6406                	ld	s0,64(sp)
    8000573c:	74e2                	ld	s1,56(sp)
    8000573e:	7942                	ld	s2,48(sp)
    80005740:	79a2                	ld	s3,40(sp)
    80005742:	7a02                	ld	s4,32(sp)
    80005744:	6ae2                	ld	s5,24(sp)
    80005746:	6161                	addi	sp,sp,80
    80005748:	8082                	ret
  for(i = 0; i < n; i++){
    8000574a:	4901                	li	s2,0
    8000574c:	b7ed                	j	80005736 <consolewrite+0x4c>

000000008000574e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000574e:	711d                	addi	sp,sp,-96
    80005750:	ec86                	sd	ra,88(sp)
    80005752:	e8a2                	sd	s0,80(sp)
    80005754:	e4a6                	sd	s1,72(sp)
    80005756:	e0ca                	sd	s2,64(sp)
    80005758:	fc4e                	sd	s3,56(sp)
    8000575a:	f852                	sd	s4,48(sp)
    8000575c:	f456                	sd	s5,40(sp)
    8000575e:	f05a                	sd	s6,32(sp)
    80005760:	ec5e                	sd	s7,24(sp)
    80005762:	1080                	addi	s0,sp,96
    80005764:	8aaa                	mv	s5,a0
    80005766:	8a2e                	mv	s4,a1
    80005768:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000576a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000576e:	0001c517          	auipc	a0,0x1c
    80005772:	4e250513          	addi	a0,a0,1250 # 80021c50 <cons>
    80005776:	00001097          	auipc	ra,0x1
    8000577a:	8e8080e7          	jalr	-1816(ra) # 8000605e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000577e:	0001c497          	auipc	s1,0x1c
    80005782:	4d248493          	addi	s1,s1,1234 # 80021c50 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005786:	0001c917          	auipc	s2,0x1c
    8000578a:	56290913          	addi	s2,s2,1378 # 80021ce8 <cons+0x98>
  while(n > 0){
    8000578e:	09305263          	blez	s3,80005812 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005792:	0984a783          	lw	a5,152(s1)
    80005796:	09c4a703          	lw	a4,156(s1)
    8000579a:	02f71763          	bne	a4,a5,800057c8 <consoleread+0x7a>
      if(killed(myproc())){
    8000579e:	ffffb097          	auipc	ra,0xffffb
    800057a2:	6b4080e7          	jalr	1716(ra) # 80000e52 <myproc>
    800057a6:	ffffc097          	auipc	ra,0xffffc
    800057aa:	ffc080e7          	jalr	-4(ra) # 800017a2 <killed>
    800057ae:	ed2d                	bnez	a0,80005828 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800057b0:	85a6                	mv	a1,s1
    800057b2:	854a                	mv	a0,s2
    800057b4:	ffffc097          	auipc	ra,0xffffc
    800057b8:	d46080e7          	jalr	-698(ra) # 800014fa <sleep>
    while(cons.r == cons.w){
    800057bc:	0984a783          	lw	a5,152(s1)
    800057c0:	09c4a703          	lw	a4,156(s1)
    800057c4:	fcf70de3          	beq	a4,a5,8000579e <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800057c8:	0001c717          	auipc	a4,0x1c
    800057cc:	48870713          	addi	a4,a4,1160 # 80021c50 <cons>
    800057d0:	0017869b          	addiw	a3,a5,1
    800057d4:	08d72c23          	sw	a3,152(a4)
    800057d8:	07f7f693          	andi	a3,a5,127
    800057dc:	9736                	add	a4,a4,a3
    800057de:	01874703          	lbu	a4,24(a4)
    800057e2:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800057e6:	4691                	li	a3,4
    800057e8:	06db8463          	beq	s7,a3,80005850 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800057ec:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800057f0:	4685                	li	a3,1
    800057f2:	faf40613          	addi	a2,s0,-81
    800057f6:	85d2                	mv	a1,s4
    800057f8:	8556                	mv	a0,s5
    800057fa:	ffffc097          	auipc	ra,0xffffc
    800057fe:	108080e7          	jalr	264(ra) # 80001902 <either_copyout>
    80005802:	57fd                	li	a5,-1
    80005804:	00f50763          	beq	a0,a5,80005812 <consoleread+0xc4>
      break;

    dst++;
    80005808:	0a05                	addi	s4,s4,1
    --n;
    8000580a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000580c:	47a9                	li	a5,10
    8000580e:	f8fb90e3          	bne	s7,a5,8000578e <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005812:	0001c517          	auipc	a0,0x1c
    80005816:	43e50513          	addi	a0,a0,1086 # 80021c50 <cons>
    8000581a:	00001097          	auipc	ra,0x1
    8000581e:	8f8080e7          	jalr	-1800(ra) # 80006112 <release>

  return target - n;
    80005822:	413b053b          	subw	a0,s6,s3
    80005826:	a811                	j	8000583a <consoleread+0xec>
        release(&cons.lock);
    80005828:	0001c517          	auipc	a0,0x1c
    8000582c:	42850513          	addi	a0,a0,1064 # 80021c50 <cons>
    80005830:	00001097          	auipc	ra,0x1
    80005834:	8e2080e7          	jalr	-1822(ra) # 80006112 <release>
        return -1;
    80005838:	557d                	li	a0,-1
}
    8000583a:	60e6                	ld	ra,88(sp)
    8000583c:	6446                	ld	s0,80(sp)
    8000583e:	64a6                	ld	s1,72(sp)
    80005840:	6906                	ld	s2,64(sp)
    80005842:	79e2                	ld	s3,56(sp)
    80005844:	7a42                	ld	s4,48(sp)
    80005846:	7aa2                	ld	s5,40(sp)
    80005848:	7b02                	ld	s6,32(sp)
    8000584a:	6be2                	ld	s7,24(sp)
    8000584c:	6125                	addi	sp,sp,96
    8000584e:	8082                	ret
      if(n < target){
    80005850:	0009871b          	sext.w	a4,s3
    80005854:	fb677fe3          	bgeu	a4,s6,80005812 <consoleread+0xc4>
        cons.r--;
    80005858:	0001c717          	auipc	a4,0x1c
    8000585c:	48f72823          	sw	a5,1168(a4) # 80021ce8 <cons+0x98>
    80005860:	bf4d                	j	80005812 <consoleread+0xc4>

0000000080005862 <consputc>:
{
    80005862:	1141                	addi	sp,sp,-16
    80005864:	e406                	sd	ra,8(sp)
    80005866:	e022                	sd	s0,0(sp)
    80005868:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000586a:	10000793          	li	a5,256
    8000586e:	00f50a63          	beq	a0,a5,80005882 <consputc+0x20>
    uartputc_sync(c);
    80005872:	00000097          	auipc	ra,0x0
    80005876:	560080e7          	jalr	1376(ra) # 80005dd2 <uartputc_sync>
}
    8000587a:	60a2                	ld	ra,8(sp)
    8000587c:	6402                	ld	s0,0(sp)
    8000587e:	0141                	addi	sp,sp,16
    80005880:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005882:	4521                	li	a0,8
    80005884:	00000097          	auipc	ra,0x0
    80005888:	54e080e7          	jalr	1358(ra) # 80005dd2 <uartputc_sync>
    8000588c:	02000513          	li	a0,32
    80005890:	00000097          	auipc	ra,0x0
    80005894:	542080e7          	jalr	1346(ra) # 80005dd2 <uartputc_sync>
    80005898:	4521                	li	a0,8
    8000589a:	00000097          	auipc	ra,0x0
    8000589e:	538080e7          	jalr	1336(ra) # 80005dd2 <uartputc_sync>
    800058a2:	bfe1                	j	8000587a <consputc+0x18>

00000000800058a4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800058a4:	1101                	addi	sp,sp,-32
    800058a6:	ec06                	sd	ra,24(sp)
    800058a8:	e822                	sd	s0,16(sp)
    800058aa:	e426                	sd	s1,8(sp)
    800058ac:	e04a                	sd	s2,0(sp)
    800058ae:	1000                	addi	s0,sp,32
    800058b0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800058b2:	0001c517          	auipc	a0,0x1c
    800058b6:	39e50513          	addi	a0,a0,926 # 80021c50 <cons>
    800058ba:	00000097          	auipc	ra,0x0
    800058be:	7a4080e7          	jalr	1956(ra) # 8000605e <acquire>

  switch(c){
    800058c2:	47d5                	li	a5,21
    800058c4:	0af48663          	beq	s1,a5,80005970 <consoleintr+0xcc>
    800058c8:	0297ca63          	blt	a5,s1,800058fc <consoleintr+0x58>
    800058cc:	47a1                	li	a5,8
    800058ce:	0ef48763          	beq	s1,a5,800059bc <consoleintr+0x118>
    800058d2:	47c1                	li	a5,16
    800058d4:	10f49a63          	bne	s1,a5,800059e8 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800058d8:	ffffc097          	auipc	ra,0xffffc
    800058dc:	0d6080e7          	jalr	214(ra) # 800019ae <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800058e0:	0001c517          	auipc	a0,0x1c
    800058e4:	37050513          	addi	a0,a0,880 # 80021c50 <cons>
    800058e8:	00001097          	auipc	ra,0x1
    800058ec:	82a080e7          	jalr	-2006(ra) # 80006112 <release>
}
    800058f0:	60e2                	ld	ra,24(sp)
    800058f2:	6442                	ld	s0,16(sp)
    800058f4:	64a2                	ld	s1,8(sp)
    800058f6:	6902                	ld	s2,0(sp)
    800058f8:	6105                	addi	sp,sp,32
    800058fa:	8082                	ret
  switch(c){
    800058fc:	07f00793          	li	a5,127
    80005900:	0af48e63          	beq	s1,a5,800059bc <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005904:	0001c717          	auipc	a4,0x1c
    80005908:	34c70713          	addi	a4,a4,844 # 80021c50 <cons>
    8000590c:	0a072783          	lw	a5,160(a4)
    80005910:	09872703          	lw	a4,152(a4)
    80005914:	9f99                	subw	a5,a5,a4
    80005916:	07f00713          	li	a4,127
    8000591a:	fcf763e3          	bltu	a4,a5,800058e0 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000591e:	47b5                	li	a5,13
    80005920:	0cf48763          	beq	s1,a5,800059ee <consoleintr+0x14a>
      consputc(c);
    80005924:	8526                	mv	a0,s1
    80005926:	00000097          	auipc	ra,0x0
    8000592a:	f3c080e7          	jalr	-196(ra) # 80005862 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000592e:	0001c797          	auipc	a5,0x1c
    80005932:	32278793          	addi	a5,a5,802 # 80021c50 <cons>
    80005936:	0a07a683          	lw	a3,160(a5)
    8000593a:	0016871b          	addiw	a4,a3,1
    8000593e:	0007061b          	sext.w	a2,a4
    80005942:	0ae7a023          	sw	a4,160(a5)
    80005946:	07f6f693          	andi	a3,a3,127
    8000594a:	97b6                	add	a5,a5,a3
    8000594c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005950:	47a9                	li	a5,10
    80005952:	0cf48563          	beq	s1,a5,80005a1c <consoleintr+0x178>
    80005956:	4791                	li	a5,4
    80005958:	0cf48263          	beq	s1,a5,80005a1c <consoleintr+0x178>
    8000595c:	0001c797          	auipc	a5,0x1c
    80005960:	38c7a783          	lw	a5,908(a5) # 80021ce8 <cons+0x98>
    80005964:	9f1d                	subw	a4,a4,a5
    80005966:	08000793          	li	a5,128
    8000596a:	f6f71be3          	bne	a4,a5,800058e0 <consoleintr+0x3c>
    8000596e:	a07d                	j	80005a1c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005970:	0001c717          	auipc	a4,0x1c
    80005974:	2e070713          	addi	a4,a4,736 # 80021c50 <cons>
    80005978:	0a072783          	lw	a5,160(a4)
    8000597c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005980:	0001c497          	auipc	s1,0x1c
    80005984:	2d048493          	addi	s1,s1,720 # 80021c50 <cons>
    while(cons.e != cons.w &&
    80005988:	4929                	li	s2,10
    8000598a:	f4f70be3          	beq	a4,a5,800058e0 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000598e:	37fd                	addiw	a5,a5,-1
    80005990:	07f7f713          	andi	a4,a5,127
    80005994:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005996:	01874703          	lbu	a4,24(a4)
    8000599a:	f52703e3          	beq	a4,s2,800058e0 <consoleintr+0x3c>
      cons.e--;
    8000599e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800059a2:	10000513          	li	a0,256
    800059a6:	00000097          	auipc	ra,0x0
    800059aa:	ebc080e7          	jalr	-324(ra) # 80005862 <consputc>
    while(cons.e != cons.w &&
    800059ae:	0a04a783          	lw	a5,160(s1)
    800059b2:	09c4a703          	lw	a4,156(s1)
    800059b6:	fcf71ce3          	bne	a4,a5,8000598e <consoleintr+0xea>
    800059ba:	b71d                	j	800058e0 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800059bc:	0001c717          	auipc	a4,0x1c
    800059c0:	29470713          	addi	a4,a4,660 # 80021c50 <cons>
    800059c4:	0a072783          	lw	a5,160(a4)
    800059c8:	09c72703          	lw	a4,156(a4)
    800059cc:	f0f70ae3          	beq	a4,a5,800058e0 <consoleintr+0x3c>
      cons.e--;
    800059d0:	37fd                	addiw	a5,a5,-1
    800059d2:	0001c717          	auipc	a4,0x1c
    800059d6:	30f72f23          	sw	a5,798(a4) # 80021cf0 <cons+0xa0>
      consputc(BACKSPACE);
    800059da:	10000513          	li	a0,256
    800059de:	00000097          	auipc	ra,0x0
    800059e2:	e84080e7          	jalr	-380(ra) # 80005862 <consputc>
    800059e6:	bded                	j	800058e0 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800059e8:	ee048ce3          	beqz	s1,800058e0 <consoleintr+0x3c>
    800059ec:	bf21                	j	80005904 <consoleintr+0x60>
      consputc(c);
    800059ee:	4529                	li	a0,10
    800059f0:	00000097          	auipc	ra,0x0
    800059f4:	e72080e7          	jalr	-398(ra) # 80005862 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800059f8:	0001c797          	auipc	a5,0x1c
    800059fc:	25878793          	addi	a5,a5,600 # 80021c50 <cons>
    80005a00:	0a07a703          	lw	a4,160(a5)
    80005a04:	0017069b          	addiw	a3,a4,1
    80005a08:	0006861b          	sext.w	a2,a3
    80005a0c:	0ad7a023          	sw	a3,160(a5)
    80005a10:	07f77713          	andi	a4,a4,127
    80005a14:	97ba                	add	a5,a5,a4
    80005a16:	4729                	li	a4,10
    80005a18:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a1c:	0001c797          	auipc	a5,0x1c
    80005a20:	2cc7a823          	sw	a2,720(a5) # 80021cec <cons+0x9c>
        wakeup(&cons.r);
    80005a24:	0001c517          	auipc	a0,0x1c
    80005a28:	2c450513          	addi	a0,a0,708 # 80021ce8 <cons+0x98>
    80005a2c:	ffffc097          	auipc	ra,0xffffc
    80005a30:	b32080e7          	jalr	-1230(ra) # 8000155e <wakeup>
    80005a34:	b575                	j	800058e0 <consoleintr+0x3c>

0000000080005a36 <consoleinit>:

void
consoleinit(void)
{
    80005a36:	1141                	addi	sp,sp,-16
    80005a38:	e406                	sd	ra,8(sp)
    80005a3a:	e022                	sd	s0,0(sp)
    80005a3c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005a3e:	00003597          	auipc	a1,0x3
    80005a42:	d8258593          	addi	a1,a1,-638 # 800087c0 <syscalls+0x3f0>
    80005a46:	0001c517          	auipc	a0,0x1c
    80005a4a:	20a50513          	addi	a0,a0,522 # 80021c50 <cons>
    80005a4e:	00000097          	auipc	ra,0x0
    80005a52:	580080e7          	jalr	1408(ra) # 80005fce <initlock>

  uartinit();
    80005a56:	00000097          	auipc	ra,0x0
    80005a5a:	32c080e7          	jalr	812(ra) # 80005d82 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005a5e:	00013797          	auipc	a5,0x13
    80005a62:	f1a78793          	addi	a5,a5,-230 # 80018978 <devsw>
    80005a66:	00000717          	auipc	a4,0x0
    80005a6a:	ce870713          	addi	a4,a4,-792 # 8000574e <consoleread>
    80005a6e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005a70:	00000717          	auipc	a4,0x0
    80005a74:	c7a70713          	addi	a4,a4,-902 # 800056ea <consolewrite>
    80005a78:	ef98                	sd	a4,24(a5)
}
    80005a7a:	60a2                	ld	ra,8(sp)
    80005a7c:	6402                	ld	s0,0(sp)
    80005a7e:	0141                	addi	sp,sp,16
    80005a80:	8082                	ret

0000000080005a82 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005a82:	7179                	addi	sp,sp,-48
    80005a84:	f406                	sd	ra,40(sp)
    80005a86:	f022                	sd	s0,32(sp)
    80005a88:	ec26                	sd	s1,24(sp)
    80005a8a:	e84a                	sd	s2,16(sp)
    80005a8c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005a8e:	c219                	beqz	a2,80005a94 <printint+0x12>
    80005a90:	08054763          	bltz	a0,80005b1e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005a94:	2501                	sext.w	a0,a0
    80005a96:	4881                	li	a7,0
    80005a98:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005a9c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005a9e:	2581                	sext.w	a1,a1
    80005aa0:	00003617          	auipc	a2,0x3
    80005aa4:	d5060613          	addi	a2,a2,-688 # 800087f0 <digits>
    80005aa8:	883a                	mv	a6,a4
    80005aaa:	2705                	addiw	a4,a4,1
    80005aac:	02b577bb          	remuw	a5,a0,a1
    80005ab0:	1782                	slli	a5,a5,0x20
    80005ab2:	9381                	srli	a5,a5,0x20
    80005ab4:	97b2                	add	a5,a5,a2
    80005ab6:	0007c783          	lbu	a5,0(a5)
    80005aba:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005abe:	0005079b          	sext.w	a5,a0
    80005ac2:	02b5553b          	divuw	a0,a0,a1
    80005ac6:	0685                	addi	a3,a3,1
    80005ac8:	feb7f0e3          	bgeu	a5,a1,80005aa8 <printint+0x26>

  if(sign)
    80005acc:	00088c63          	beqz	a7,80005ae4 <printint+0x62>
    buf[i++] = '-';
    80005ad0:	fe070793          	addi	a5,a4,-32
    80005ad4:	00878733          	add	a4,a5,s0
    80005ad8:	02d00793          	li	a5,45
    80005adc:	fef70823          	sb	a5,-16(a4)
    80005ae0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ae4:	02e05763          	blez	a4,80005b12 <printint+0x90>
    80005ae8:	fd040793          	addi	a5,s0,-48
    80005aec:	00e784b3          	add	s1,a5,a4
    80005af0:	fff78913          	addi	s2,a5,-1
    80005af4:	993a                	add	s2,s2,a4
    80005af6:	377d                	addiw	a4,a4,-1
    80005af8:	1702                	slli	a4,a4,0x20
    80005afa:	9301                	srli	a4,a4,0x20
    80005afc:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b00:	fff4c503          	lbu	a0,-1(s1)
    80005b04:	00000097          	auipc	ra,0x0
    80005b08:	d5e080e7          	jalr	-674(ra) # 80005862 <consputc>
  while(--i >= 0)
    80005b0c:	14fd                	addi	s1,s1,-1
    80005b0e:	ff2499e3          	bne	s1,s2,80005b00 <printint+0x7e>
}
    80005b12:	70a2                	ld	ra,40(sp)
    80005b14:	7402                	ld	s0,32(sp)
    80005b16:	64e2                	ld	s1,24(sp)
    80005b18:	6942                	ld	s2,16(sp)
    80005b1a:	6145                	addi	sp,sp,48
    80005b1c:	8082                	ret
    x = -xx;
    80005b1e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b22:	4885                	li	a7,1
    x = -xx;
    80005b24:	bf95                	j	80005a98 <printint+0x16>

0000000080005b26 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b26:	1101                	addi	sp,sp,-32
    80005b28:	ec06                	sd	ra,24(sp)
    80005b2a:	e822                	sd	s0,16(sp)
    80005b2c:	e426                	sd	s1,8(sp)
    80005b2e:	1000                	addi	s0,sp,32
    80005b30:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005b32:	0001c797          	auipc	a5,0x1c
    80005b36:	1c07af23          	sw	zero,478(a5) # 80021d10 <pr+0x18>
  printf("panic: ");
    80005b3a:	00003517          	auipc	a0,0x3
    80005b3e:	c8e50513          	addi	a0,a0,-882 # 800087c8 <syscalls+0x3f8>
    80005b42:	00000097          	auipc	ra,0x0
    80005b46:	02e080e7          	jalr	46(ra) # 80005b70 <printf>
  printf(s);
    80005b4a:	8526                	mv	a0,s1
    80005b4c:	00000097          	auipc	ra,0x0
    80005b50:	024080e7          	jalr	36(ra) # 80005b70 <printf>
  printf("\n");
    80005b54:	00002517          	auipc	a0,0x2
    80005b58:	4f450513          	addi	a0,a0,1268 # 80008048 <etext+0x48>
    80005b5c:	00000097          	auipc	ra,0x0
    80005b60:	014080e7          	jalr	20(ra) # 80005b70 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005b64:	4785                	li	a5,1
    80005b66:	00003717          	auipc	a4,0x3
    80005b6a:	d6f72323          	sw	a5,-666(a4) # 800088cc <panicked>
  for(;;)
    80005b6e:	a001                	j	80005b6e <panic+0x48>

0000000080005b70 <printf>:
{
    80005b70:	7131                	addi	sp,sp,-192
    80005b72:	fc86                	sd	ra,120(sp)
    80005b74:	f8a2                	sd	s0,112(sp)
    80005b76:	f4a6                	sd	s1,104(sp)
    80005b78:	f0ca                	sd	s2,96(sp)
    80005b7a:	ecce                	sd	s3,88(sp)
    80005b7c:	e8d2                	sd	s4,80(sp)
    80005b7e:	e4d6                	sd	s5,72(sp)
    80005b80:	e0da                	sd	s6,64(sp)
    80005b82:	fc5e                	sd	s7,56(sp)
    80005b84:	f862                	sd	s8,48(sp)
    80005b86:	f466                	sd	s9,40(sp)
    80005b88:	f06a                	sd	s10,32(sp)
    80005b8a:	ec6e                	sd	s11,24(sp)
    80005b8c:	0100                	addi	s0,sp,128
    80005b8e:	8a2a                	mv	s4,a0
    80005b90:	e40c                	sd	a1,8(s0)
    80005b92:	e810                	sd	a2,16(s0)
    80005b94:	ec14                	sd	a3,24(s0)
    80005b96:	f018                	sd	a4,32(s0)
    80005b98:	f41c                	sd	a5,40(s0)
    80005b9a:	03043823          	sd	a6,48(s0)
    80005b9e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ba2:	0001cd97          	auipc	s11,0x1c
    80005ba6:	16edad83          	lw	s11,366(s11) # 80021d10 <pr+0x18>
  if(locking)
    80005baa:	020d9b63          	bnez	s11,80005be0 <printf+0x70>
  if (fmt == 0)
    80005bae:	040a0263          	beqz	s4,80005bf2 <printf+0x82>
  va_start(ap, fmt);
    80005bb2:	00840793          	addi	a5,s0,8
    80005bb6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005bba:	000a4503          	lbu	a0,0(s4)
    80005bbe:	14050f63          	beqz	a0,80005d1c <printf+0x1ac>
    80005bc2:	4981                	li	s3,0
    if(c != '%'){
    80005bc4:	02500a93          	li	s5,37
    switch(c){
    80005bc8:	07000b93          	li	s7,112
  consputc('x');
    80005bcc:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005bce:	00003b17          	auipc	s6,0x3
    80005bd2:	c22b0b13          	addi	s6,s6,-990 # 800087f0 <digits>
    switch(c){
    80005bd6:	07300c93          	li	s9,115
    80005bda:	06400c13          	li	s8,100
    80005bde:	a82d                	j	80005c18 <printf+0xa8>
    acquire(&pr.lock);
    80005be0:	0001c517          	auipc	a0,0x1c
    80005be4:	11850513          	addi	a0,a0,280 # 80021cf8 <pr>
    80005be8:	00000097          	auipc	ra,0x0
    80005bec:	476080e7          	jalr	1142(ra) # 8000605e <acquire>
    80005bf0:	bf7d                	j	80005bae <printf+0x3e>
    panic("null fmt");
    80005bf2:	00003517          	auipc	a0,0x3
    80005bf6:	be650513          	addi	a0,a0,-1050 # 800087d8 <syscalls+0x408>
    80005bfa:	00000097          	auipc	ra,0x0
    80005bfe:	f2c080e7          	jalr	-212(ra) # 80005b26 <panic>
      consputc(c);
    80005c02:	00000097          	auipc	ra,0x0
    80005c06:	c60080e7          	jalr	-928(ra) # 80005862 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c0a:	2985                	addiw	s3,s3,1
    80005c0c:	013a07b3          	add	a5,s4,s3
    80005c10:	0007c503          	lbu	a0,0(a5)
    80005c14:	10050463          	beqz	a0,80005d1c <printf+0x1ac>
    if(c != '%'){
    80005c18:	ff5515e3          	bne	a0,s5,80005c02 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c1c:	2985                	addiw	s3,s3,1
    80005c1e:	013a07b3          	add	a5,s4,s3
    80005c22:	0007c783          	lbu	a5,0(a5)
    80005c26:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005c2a:	cbed                	beqz	a5,80005d1c <printf+0x1ac>
    switch(c){
    80005c2c:	05778a63          	beq	a5,s7,80005c80 <printf+0x110>
    80005c30:	02fbf663          	bgeu	s7,a5,80005c5c <printf+0xec>
    80005c34:	09978863          	beq	a5,s9,80005cc4 <printf+0x154>
    80005c38:	07800713          	li	a4,120
    80005c3c:	0ce79563          	bne	a5,a4,80005d06 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005c40:	f8843783          	ld	a5,-120(s0)
    80005c44:	00878713          	addi	a4,a5,8
    80005c48:	f8e43423          	sd	a4,-120(s0)
    80005c4c:	4605                	li	a2,1
    80005c4e:	85ea                	mv	a1,s10
    80005c50:	4388                	lw	a0,0(a5)
    80005c52:	00000097          	auipc	ra,0x0
    80005c56:	e30080e7          	jalr	-464(ra) # 80005a82 <printint>
      break;
    80005c5a:	bf45                	j	80005c0a <printf+0x9a>
    switch(c){
    80005c5c:	09578f63          	beq	a5,s5,80005cfa <printf+0x18a>
    80005c60:	0b879363          	bne	a5,s8,80005d06 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005c64:	f8843783          	ld	a5,-120(s0)
    80005c68:	00878713          	addi	a4,a5,8
    80005c6c:	f8e43423          	sd	a4,-120(s0)
    80005c70:	4605                	li	a2,1
    80005c72:	45a9                	li	a1,10
    80005c74:	4388                	lw	a0,0(a5)
    80005c76:	00000097          	auipc	ra,0x0
    80005c7a:	e0c080e7          	jalr	-500(ra) # 80005a82 <printint>
      break;
    80005c7e:	b771                	j	80005c0a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005c80:	f8843783          	ld	a5,-120(s0)
    80005c84:	00878713          	addi	a4,a5,8
    80005c88:	f8e43423          	sd	a4,-120(s0)
    80005c8c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005c90:	03000513          	li	a0,48
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	bce080e7          	jalr	-1074(ra) # 80005862 <consputc>
  consputc('x');
    80005c9c:	07800513          	li	a0,120
    80005ca0:	00000097          	auipc	ra,0x0
    80005ca4:	bc2080e7          	jalr	-1086(ra) # 80005862 <consputc>
    80005ca8:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005caa:	03c95793          	srli	a5,s2,0x3c
    80005cae:	97da                	add	a5,a5,s6
    80005cb0:	0007c503          	lbu	a0,0(a5)
    80005cb4:	00000097          	auipc	ra,0x0
    80005cb8:	bae080e7          	jalr	-1106(ra) # 80005862 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005cbc:	0912                	slli	s2,s2,0x4
    80005cbe:	34fd                	addiw	s1,s1,-1
    80005cc0:	f4ed                	bnez	s1,80005caa <printf+0x13a>
    80005cc2:	b7a1                	j	80005c0a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005cc4:	f8843783          	ld	a5,-120(s0)
    80005cc8:	00878713          	addi	a4,a5,8
    80005ccc:	f8e43423          	sd	a4,-120(s0)
    80005cd0:	6384                	ld	s1,0(a5)
    80005cd2:	cc89                	beqz	s1,80005cec <printf+0x17c>
      for(; *s; s++)
    80005cd4:	0004c503          	lbu	a0,0(s1)
    80005cd8:	d90d                	beqz	a0,80005c0a <printf+0x9a>
        consputc(*s);
    80005cda:	00000097          	auipc	ra,0x0
    80005cde:	b88080e7          	jalr	-1144(ra) # 80005862 <consputc>
      for(; *s; s++)
    80005ce2:	0485                	addi	s1,s1,1
    80005ce4:	0004c503          	lbu	a0,0(s1)
    80005ce8:	f96d                	bnez	a0,80005cda <printf+0x16a>
    80005cea:	b705                	j	80005c0a <printf+0x9a>
        s = "(null)";
    80005cec:	00003497          	auipc	s1,0x3
    80005cf0:	ae448493          	addi	s1,s1,-1308 # 800087d0 <syscalls+0x400>
      for(; *s; s++)
    80005cf4:	02800513          	li	a0,40
    80005cf8:	b7cd                	j	80005cda <printf+0x16a>
      consputc('%');
    80005cfa:	8556                	mv	a0,s5
    80005cfc:	00000097          	auipc	ra,0x0
    80005d00:	b66080e7          	jalr	-1178(ra) # 80005862 <consputc>
      break;
    80005d04:	b719                	j	80005c0a <printf+0x9a>
      consputc('%');
    80005d06:	8556                	mv	a0,s5
    80005d08:	00000097          	auipc	ra,0x0
    80005d0c:	b5a080e7          	jalr	-1190(ra) # 80005862 <consputc>
      consputc(c);
    80005d10:	8526                	mv	a0,s1
    80005d12:	00000097          	auipc	ra,0x0
    80005d16:	b50080e7          	jalr	-1200(ra) # 80005862 <consputc>
      break;
    80005d1a:	bdc5                	j	80005c0a <printf+0x9a>
  if(locking)
    80005d1c:	020d9163          	bnez	s11,80005d3e <printf+0x1ce>
}
    80005d20:	70e6                	ld	ra,120(sp)
    80005d22:	7446                	ld	s0,112(sp)
    80005d24:	74a6                	ld	s1,104(sp)
    80005d26:	7906                	ld	s2,96(sp)
    80005d28:	69e6                	ld	s3,88(sp)
    80005d2a:	6a46                	ld	s4,80(sp)
    80005d2c:	6aa6                	ld	s5,72(sp)
    80005d2e:	6b06                	ld	s6,64(sp)
    80005d30:	7be2                	ld	s7,56(sp)
    80005d32:	7c42                	ld	s8,48(sp)
    80005d34:	7ca2                	ld	s9,40(sp)
    80005d36:	7d02                	ld	s10,32(sp)
    80005d38:	6de2                	ld	s11,24(sp)
    80005d3a:	6129                	addi	sp,sp,192
    80005d3c:	8082                	ret
    release(&pr.lock);
    80005d3e:	0001c517          	auipc	a0,0x1c
    80005d42:	fba50513          	addi	a0,a0,-70 # 80021cf8 <pr>
    80005d46:	00000097          	auipc	ra,0x0
    80005d4a:	3cc080e7          	jalr	972(ra) # 80006112 <release>
}
    80005d4e:	bfc9                	j	80005d20 <printf+0x1b0>

0000000080005d50 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d50:	1101                	addi	sp,sp,-32
    80005d52:	ec06                	sd	ra,24(sp)
    80005d54:	e822                	sd	s0,16(sp)
    80005d56:	e426                	sd	s1,8(sp)
    80005d58:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d5a:	0001c497          	auipc	s1,0x1c
    80005d5e:	f9e48493          	addi	s1,s1,-98 # 80021cf8 <pr>
    80005d62:	00003597          	auipc	a1,0x3
    80005d66:	a8658593          	addi	a1,a1,-1402 # 800087e8 <syscalls+0x418>
    80005d6a:	8526                	mv	a0,s1
    80005d6c:	00000097          	auipc	ra,0x0
    80005d70:	262080e7          	jalr	610(ra) # 80005fce <initlock>
  pr.locking = 1;
    80005d74:	4785                	li	a5,1
    80005d76:	cc9c                	sw	a5,24(s1)
}
    80005d78:	60e2                	ld	ra,24(sp)
    80005d7a:	6442                	ld	s0,16(sp)
    80005d7c:	64a2                	ld	s1,8(sp)
    80005d7e:	6105                	addi	sp,sp,32
    80005d80:	8082                	ret

0000000080005d82 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005d82:	1141                	addi	sp,sp,-16
    80005d84:	e406                	sd	ra,8(sp)
    80005d86:	e022                	sd	s0,0(sp)
    80005d88:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005d8a:	100007b7          	lui	a5,0x10000
    80005d8e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005d92:	f8000713          	li	a4,-128
    80005d96:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005d9a:	470d                	li	a4,3
    80005d9c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005da0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005da4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005da8:	469d                	li	a3,7
    80005daa:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005dae:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005db2:	00003597          	auipc	a1,0x3
    80005db6:	a5658593          	addi	a1,a1,-1450 # 80008808 <digits+0x18>
    80005dba:	0001c517          	auipc	a0,0x1c
    80005dbe:	f5e50513          	addi	a0,a0,-162 # 80021d18 <uart_tx_lock>
    80005dc2:	00000097          	auipc	ra,0x0
    80005dc6:	20c080e7          	jalr	524(ra) # 80005fce <initlock>
}
    80005dca:	60a2                	ld	ra,8(sp)
    80005dcc:	6402                	ld	s0,0(sp)
    80005dce:	0141                	addi	sp,sp,16
    80005dd0:	8082                	ret

0000000080005dd2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005dd2:	1101                	addi	sp,sp,-32
    80005dd4:	ec06                	sd	ra,24(sp)
    80005dd6:	e822                	sd	s0,16(sp)
    80005dd8:	e426                	sd	s1,8(sp)
    80005dda:	1000                	addi	s0,sp,32
    80005ddc:	84aa                	mv	s1,a0
  push_off();
    80005dde:	00000097          	auipc	ra,0x0
    80005de2:	234080e7          	jalr	564(ra) # 80006012 <push_off>

  if(panicked){
    80005de6:	00003797          	auipc	a5,0x3
    80005dea:	ae67a783          	lw	a5,-1306(a5) # 800088cc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005dee:	10000737          	lui	a4,0x10000
  if(panicked){
    80005df2:	c391                	beqz	a5,80005df6 <uartputc_sync+0x24>
    for(;;)
    80005df4:	a001                	j	80005df4 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005df6:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005dfa:	0207f793          	andi	a5,a5,32
    80005dfe:	dfe5                	beqz	a5,80005df6 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e00:	0ff4f513          	zext.b	a0,s1
    80005e04:	100007b7          	lui	a5,0x10000
    80005e08:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e0c:	00000097          	auipc	ra,0x0
    80005e10:	2a6080e7          	jalr	678(ra) # 800060b2 <pop_off>
}
    80005e14:	60e2                	ld	ra,24(sp)
    80005e16:	6442                	ld	s0,16(sp)
    80005e18:	64a2                	ld	s1,8(sp)
    80005e1a:	6105                	addi	sp,sp,32
    80005e1c:	8082                	ret

0000000080005e1e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e1e:	00003797          	auipc	a5,0x3
    80005e22:	ab27b783          	ld	a5,-1358(a5) # 800088d0 <uart_tx_r>
    80005e26:	00003717          	auipc	a4,0x3
    80005e2a:	ab273703          	ld	a4,-1358(a4) # 800088d8 <uart_tx_w>
    80005e2e:	06f70a63          	beq	a4,a5,80005ea2 <uartstart+0x84>
{
    80005e32:	7139                	addi	sp,sp,-64
    80005e34:	fc06                	sd	ra,56(sp)
    80005e36:	f822                	sd	s0,48(sp)
    80005e38:	f426                	sd	s1,40(sp)
    80005e3a:	f04a                	sd	s2,32(sp)
    80005e3c:	ec4e                	sd	s3,24(sp)
    80005e3e:	e852                	sd	s4,16(sp)
    80005e40:	e456                	sd	s5,8(sp)
    80005e42:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e44:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e48:	0001ca17          	auipc	s4,0x1c
    80005e4c:	ed0a0a13          	addi	s4,s4,-304 # 80021d18 <uart_tx_lock>
    uart_tx_r += 1;
    80005e50:	00003497          	auipc	s1,0x3
    80005e54:	a8048493          	addi	s1,s1,-1408 # 800088d0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005e58:	00003997          	auipc	s3,0x3
    80005e5c:	a8098993          	addi	s3,s3,-1408 # 800088d8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e60:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005e64:	02077713          	andi	a4,a4,32
    80005e68:	c705                	beqz	a4,80005e90 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e6a:	01f7f713          	andi	a4,a5,31
    80005e6e:	9752                	add	a4,a4,s4
    80005e70:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005e74:	0785                	addi	a5,a5,1
    80005e76:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005e78:	8526                	mv	a0,s1
    80005e7a:	ffffb097          	auipc	ra,0xffffb
    80005e7e:	6e4080e7          	jalr	1764(ra) # 8000155e <wakeup>
    
    WriteReg(THR, c);
    80005e82:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005e86:	609c                	ld	a5,0(s1)
    80005e88:	0009b703          	ld	a4,0(s3)
    80005e8c:	fcf71ae3          	bne	a4,a5,80005e60 <uartstart+0x42>
  }
}
    80005e90:	70e2                	ld	ra,56(sp)
    80005e92:	7442                	ld	s0,48(sp)
    80005e94:	74a2                	ld	s1,40(sp)
    80005e96:	7902                	ld	s2,32(sp)
    80005e98:	69e2                	ld	s3,24(sp)
    80005e9a:	6a42                	ld	s4,16(sp)
    80005e9c:	6aa2                	ld	s5,8(sp)
    80005e9e:	6121                	addi	sp,sp,64
    80005ea0:	8082                	ret
    80005ea2:	8082                	ret

0000000080005ea4 <uartputc>:
{
    80005ea4:	7179                	addi	sp,sp,-48
    80005ea6:	f406                	sd	ra,40(sp)
    80005ea8:	f022                	sd	s0,32(sp)
    80005eaa:	ec26                	sd	s1,24(sp)
    80005eac:	e84a                	sd	s2,16(sp)
    80005eae:	e44e                	sd	s3,8(sp)
    80005eb0:	e052                	sd	s4,0(sp)
    80005eb2:	1800                	addi	s0,sp,48
    80005eb4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005eb6:	0001c517          	auipc	a0,0x1c
    80005eba:	e6250513          	addi	a0,a0,-414 # 80021d18 <uart_tx_lock>
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	1a0080e7          	jalr	416(ra) # 8000605e <acquire>
  if(panicked){
    80005ec6:	00003797          	auipc	a5,0x3
    80005eca:	a067a783          	lw	a5,-1530(a5) # 800088cc <panicked>
    80005ece:	e7c9                	bnez	a5,80005f58 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ed0:	00003717          	auipc	a4,0x3
    80005ed4:	a0873703          	ld	a4,-1528(a4) # 800088d8 <uart_tx_w>
    80005ed8:	00003797          	auipc	a5,0x3
    80005edc:	9f87b783          	ld	a5,-1544(a5) # 800088d0 <uart_tx_r>
    80005ee0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005ee4:	0001c997          	auipc	s3,0x1c
    80005ee8:	e3498993          	addi	s3,s3,-460 # 80021d18 <uart_tx_lock>
    80005eec:	00003497          	auipc	s1,0x3
    80005ef0:	9e448493          	addi	s1,s1,-1564 # 800088d0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ef4:	00003917          	auipc	s2,0x3
    80005ef8:	9e490913          	addi	s2,s2,-1564 # 800088d8 <uart_tx_w>
    80005efc:	00e79f63          	bne	a5,a4,80005f1a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f00:	85ce                	mv	a1,s3
    80005f02:	8526                	mv	a0,s1
    80005f04:	ffffb097          	auipc	ra,0xffffb
    80005f08:	5f6080e7          	jalr	1526(ra) # 800014fa <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f0c:	00093703          	ld	a4,0(s2)
    80005f10:	609c                	ld	a5,0(s1)
    80005f12:	02078793          	addi	a5,a5,32
    80005f16:	fee785e3          	beq	a5,a4,80005f00 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f1a:	0001c497          	auipc	s1,0x1c
    80005f1e:	dfe48493          	addi	s1,s1,-514 # 80021d18 <uart_tx_lock>
    80005f22:	01f77793          	andi	a5,a4,31
    80005f26:	97a6                	add	a5,a5,s1
    80005f28:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005f2c:	0705                	addi	a4,a4,1
    80005f2e:	00003797          	auipc	a5,0x3
    80005f32:	9ae7b523          	sd	a4,-1622(a5) # 800088d8 <uart_tx_w>
  uartstart();
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	ee8080e7          	jalr	-280(ra) # 80005e1e <uartstart>
  release(&uart_tx_lock);
    80005f3e:	8526                	mv	a0,s1
    80005f40:	00000097          	auipc	ra,0x0
    80005f44:	1d2080e7          	jalr	466(ra) # 80006112 <release>
}
    80005f48:	70a2                	ld	ra,40(sp)
    80005f4a:	7402                	ld	s0,32(sp)
    80005f4c:	64e2                	ld	s1,24(sp)
    80005f4e:	6942                	ld	s2,16(sp)
    80005f50:	69a2                	ld	s3,8(sp)
    80005f52:	6a02                	ld	s4,0(sp)
    80005f54:	6145                	addi	sp,sp,48
    80005f56:	8082                	ret
    for(;;)
    80005f58:	a001                	j	80005f58 <uartputc+0xb4>

0000000080005f5a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005f5a:	1141                	addi	sp,sp,-16
    80005f5c:	e422                	sd	s0,8(sp)
    80005f5e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005f60:	100007b7          	lui	a5,0x10000
    80005f64:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005f68:	8b85                	andi	a5,a5,1
    80005f6a:	cb81                	beqz	a5,80005f7a <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80005f6c:	100007b7          	lui	a5,0x10000
    80005f70:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005f74:	6422                	ld	s0,8(sp)
    80005f76:	0141                	addi	sp,sp,16
    80005f78:	8082                	ret
    return -1;
    80005f7a:	557d                	li	a0,-1
    80005f7c:	bfe5                	j	80005f74 <uartgetc+0x1a>

0000000080005f7e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005f7e:	1101                	addi	sp,sp,-32
    80005f80:	ec06                	sd	ra,24(sp)
    80005f82:	e822                	sd	s0,16(sp)
    80005f84:	e426                	sd	s1,8(sp)
    80005f86:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005f88:	54fd                	li	s1,-1
    80005f8a:	a029                	j	80005f94 <uartintr+0x16>
      break;
    consoleintr(c);
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	918080e7          	jalr	-1768(ra) # 800058a4 <consoleintr>
    int c = uartgetc();
    80005f94:	00000097          	auipc	ra,0x0
    80005f98:	fc6080e7          	jalr	-58(ra) # 80005f5a <uartgetc>
    if(c == -1)
    80005f9c:	fe9518e3          	bne	a0,s1,80005f8c <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005fa0:	0001c497          	auipc	s1,0x1c
    80005fa4:	d7848493          	addi	s1,s1,-648 # 80021d18 <uart_tx_lock>
    80005fa8:	8526                	mv	a0,s1
    80005faa:	00000097          	auipc	ra,0x0
    80005fae:	0b4080e7          	jalr	180(ra) # 8000605e <acquire>
  uartstart();
    80005fb2:	00000097          	auipc	ra,0x0
    80005fb6:	e6c080e7          	jalr	-404(ra) # 80005e1e <uartstart>
  release(&uart_tx_lock);
    80005fba:	8526                	mv	a0,s1
    80005fbc:	00000097          	auipc	ra,0x0
    80005fc0:	156080e7          	jalr	342(ra) # 80006112 <release>
}
    80005fc4:	60e2                	ld	ra,24(sp)
    80005fc6:	6442                	ld	s0,16(sp)
    80005fc8:	64a2                	ld	s1,8(sp)
    80005fca:	6105                	addi	sp,sp,32
    80005fcc:	8082                	ret

0000000080005fce <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005fce:	1141                	addi	sp,sp,-16
    80005fd0:	e422                	sd	s0,8(sp)
    80005fd2:	0800                	addi	s0,sp,16
  lk->name = name;
    80005fd4:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005fd6:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005fda:	00053823          	sd	zero,16(a0)
}
    80005fde:	6422                	ld	s0,8(sp)
    80005fe0:	0141                	addi	sp,sp,16
    80005fe2:	8082                	ret

0000000080005fe4 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005fe4:	411c                	lw	a5,0(a0)
    80005fe6:	e399                	bnez	a5,80005fec <holding+0x8>
    80005fe8:	4501                	li	a0,0
  return r;
}
    80005fea:	8082                	ret
{
    80005fec:	1101                	addi	sp,sp,-32
    80005fee:	ec06                	sd	ra,24(sp)
    80005ff0:	e822                	sd	s0,16(sp)
    80005ff2:	e426                	sd	s1,8(sp)
    80005ff4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005ff6:	6904                	ld	s1,16(a0)
    80005ff8:	ffffb097          	auipc	ra,0xffffb
    80005ffc:	e3e080e7          	jalr	-450(ra) # 80000e36 <mycpu>
    80006000:	40a48533          	sub	a0,s1,a0
    80006004:	00153513          	seqz	a0,a0
}
    80006008:	60e2                	ld	ra,24(sp)
    8000600a:	6442                	ld	s0,16(sp)
    8000600c:	64a2                	ld	s1,8(sp)
    8000600e:	6105                	addi	sp,sp,32
    80006010:	8082                	ret

0000000080006012 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006012:	1101                	addi	sp,sp,-32
    80006014:	ec06                	sd	ra,24(sp)
    80006016:	e822                	sd	s0,16(sp)
    80006018:	e426                	sd	s1,8(sp)
    8000601a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000601c:	100024f3          	csrr	s1,sstatus
    80006020:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006024:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006026:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000602a:	ffffb097          	auipc	ra,0xffffb
    8000602e:	e0c080e7          	jalr	-500(ra) # 80000e36 <mycpu>
    80006032:	5d3c                	lw	a5,120(a0)
    80006034:	cf89                	beqz	a5,8000604e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006036:	ffffb097          	auipc	ra,0xffffb
    8000603a:	e00080e7          	jalr	-512(ra) # 80000e36 <mycpu>
    8000603e:	5d3c                	lw	a5,120(a0)
    80006040:	2785                	addiw	a5,a5,1
    80006042:	dd3c                	sw	a5,120(a0)
}
    80006044:	60e2                	ld	ra,24(sp)
    80006046:	6442                	ld	s0,16(sp)
    80006048:	64a2                	ld	s1,8(sp)
    8000604a:	6105                	addi	sp,sp,32
    8000604c:	8082                	ret
    mycpu()->intena = old;
    8000604e:	ffffb097          	auipc	ra,0xffffb
    80006052:	de8080e7          	jalr	-536(ra) # 80000e36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006056:	8085                	srli	s1,s1,0x1
    80006058:	8885                	andi	s1,s1,1
    8000605a:	dd64                	sw	s1,124(a0)
    8000605c:	bfe9                	j	80006036 <push_off+0x24>

000000008000605e <acquire>:
{
    8000605e:	1101                	addi	sp,sp,-32
    80006060:	ec06                	sd	ra,24(sp)
    80006062:	e822                	sd	s0,16(sp)
    80006064:	e426                	sd	s1,8(sp)
    80006066:	1000                	addi	s0,sp,32
    80006068:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000606a:	00000097          	auipc	ra,0x0
    8000606e:	fa8080e7          	jalr	-88(ra) # 80006012 <push_off>
  if(holding(lk))
    80006072:	8526                	mv	a0,s1
    80006074:	00000097          	auipc	ra,0x0
    80006078:	f70080e7          	jalr	-144(ra) # 80005fe4 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000607c:	4705                	li	a4,1
  if(holding(lk))
    8000607e:	e115                	bnez	a0,800060a2 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006080:	87ba                	mv	a5,a4
    80006082:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006086:	2781                	sext.w	a5,a5
    80006088:	ffe5                	bnez	a5,80006080 <acquire+0x22>
  __sync_synchronize();
    8000608a:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000608e:	ffffb097          	auipc	ra,0xffffb
    80006092:	da8080e7          	jalr	-600(ra) # 80000e36 <mycpu>
    80006096:	e888                	sd	a0,16(s1)
}
    80006098:	60e2                	ld	ra,24(sp)
    8000609a:	6442                	ld	s0,16(sp)
    8000609c:	64a2                	ld	s1,8(sp)
    8000609e:	6105                	addi	sp,sp,32
    800060a0:	8082                	ret
    panic("acquire");
    800060a2:	00002517          	auipc	a0,0x2
    800060a6:	76e50513          	addi	a0,a0,1902 # 80008810 <digits+0x20>
    800060aa:	00000097          	auipc	ra,0x0
    800060ae:	a7c080e7          	jalr	-1412(ra) # 80005b26 <panic>

00000000800060b2 <pop_off>:

void
pop_off(void)
{
    800060b2:	1141                	addi	sp,sp,-16
    800060b4:	e406                	sd	ra,8(sp)
    800060b6:	e022                	sd	s0,0(sp)
    800060b8:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800060ba:	ffffb097          	auipc	ra,0xffffb
    800060be:	d7c080e7          	jalr	-644(ra) # 80000e36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060c2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800060c6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800060c8:	e78d                	bnez	a5,800060f2 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800060ca:	5d3c                	lw	a5,120(a0)
    800060cc:	02f05b63          	blez	a5,80006102 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800060d0:	37fd                	addiw	a5,a5,-1
    800060d2:	0007871b          	sext.w	a4,a5
    800060d6:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800060d8:	eb09                	bnez	a4,800060ea <pop_off+0x38>
    800060da:	5d7c                	lw	a5,124(a0)
    800060dc:	c799                	beqz	a5,800060ea <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060de:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800060e2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800060e6:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800060ea:	60a2                	ld	ra,8(sp)
    800060ec:	6402                	ld	s0,0(sp)
    800060ee:	0141                	addi	sp,sp,16
    800060f0:	8082                	ret
    panic("pop_off - interruptible");
    800060f2:	00002517          	auipc	a0,0x2
    800060f6:	72650513          	addi	a0,a0,1830 # 80008818 <digits+0x28>
    800060fa:	00000097          	auipc	ra,0x0
    800060fe:	a2c080e7          	jalr	-1492(ra) # 80005b26 <panic>
    panic("pop_off");
    80006102:	00002517          	auipc	a0,0x2
    80006106:	72e50513          	addi	a0,a0,1838 # 80008830 <digits+0x40>
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	a1c080e7          	jalr	-1508(ra) # 80005b26 <panic>

0000000080006112 <release>:
{
    80006112:	1101                	addi	sp,sp,-32
    80006114:	ec06                	sd	ra,24(sp)
    80006116:	e822                	sd	s0,16(sp)
    80006118:	e426                	sd	s1,8(sp)
    8000611a:	1000                	addi	s0,sp,32
    8000611c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	ec6080e7          	jalr	-314(ra) # 80005fe4 <holding>
    80006126:	c115                	beqz	a0,8000614a <release+0x38>
  lk->cpu = 0;
    80006128:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000612c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006130:	0f50000f          	fence	iorw,ow
    80006134:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	f7a080e7          	jalr	-134(ra) # 800060b2 <pop_off>
}
    80006140:	60e2                	ld	ra,24(sp)
    80006142:	6442                	ld	s0,16(sp)
    80006144:	64a2                	ld	s1,8(sp)
    80006146:	6105                	addi	sp,sp,32
    80006148:	8082                	ret
    panic("release");
    8000614a:	00002517          	auipc	a0,0x2
    8000614e:	6ee50513          	addi	a0,a0,1774 # 80008838 <digits+0x48>
    80006152:	00000097          	auipc	ra,0x0
    80006156:	9d4080e7          	jalr	-1580(ra) # 80005b26 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
