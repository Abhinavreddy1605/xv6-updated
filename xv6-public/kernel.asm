
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 10 8f 11 80       	mov    $0x80118f10,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 31 10 80       	mov    $0x80103150,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 7a 10 80       	push   $0x80107a00
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 15 45 00 00       	call   80104570 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 7a 10 80       	push   $0x80107a07
80100097:	50                   	push   %eax
80100098:	e8 a3 43 00 00       	call   80104440 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 77 46 00 00       	call   80104760 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 99 45 00 00       	call   80104700 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 43 00 00       	call   80104480 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 0f 22 00 00       	call   801023a0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 7a 10 80       	push   $0x80107a0e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 5d 43 00 00       	call   80104520 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 c7 21 00 00       	jmp    801023a0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 7a 10 80       	push   $0x80107a1f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 43 00 00       	call   80104520 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 cc 42 00 00       	call   801044e0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 40 45 00 00       	call   80104760 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 92 44 00 00       	jmp    80104700 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 26 7a 10 80       	push   $0x80107a26
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:



int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 b7 16 00 00       	call   80101950 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 bb 44 00 00       	call   80104760 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 6e 3f 00 00       	call   80104240 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 37 00 00       	call   80103ab0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 05 44 00 00       	call   80104700 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 6c 15 00 00       	call   80101870 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 af 43 00 00       	call   80104700 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 16 15 00 00       	call   80101870 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 02 26 00 00       	call   801029a0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 7a 10 80       	push   $0x80107a2d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 5e 7f 10 80 	movl   $0x80107f5e,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 c3 41 00 00       	call   80104590 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 7a 10 80       	push   $0x80107a41
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 2c 61 00 00       	call   80106550 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 61 60 00 00       	call   80106550 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 55 60 00 00       	call   80106550 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 49 60 00 00       	call   80106550 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 8a 43 00 00       	call   801048f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 e5 42 00 00       	call   80104860 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 45 7a 10 80       	push   $0x80107a45
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 8c 13 00 00       	call   80101950 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005cb:	e8 90 41 00 00       	call   80104760 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ff 10 80       	push   $0x8010ff20
80100604:	e8 f7 40 00 00       	call   80104700 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 5e 12 00 00       	call   80101870 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 b0 7f 10 80 	movzbl -0x7fef8050(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ff 10 80       	push   $0x8010ff20
801007d8:	e8 83 3f 00 00       	call   80104760 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ff 10 80       	push   $0x8010ff20
801007fb:	e8 00 3f 00 00       	call   80104700 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 58 7a 10 80       	mov    $0x80107a58,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 5f 7a 10 80       	push   $0x80107a5f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ff 10 80       	push   $0x8010ff20
801008b3:	e8 a8 3e 00 00       	call   80104760 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 26                	js     801008e9 <consoleintr+0x49>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 4b                	je     80100913 <consoleintr+0x73>
801008c8:	7f 7e                	jg     80100948 <consoleintr+0xa8>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	0f 84 ed 00 00 00    	je     801009c0 <consoleintr+0x120>
801008d3:	83 fb 10             	cmp    $0x10,%ebx
801008d6:	0f 85 42 01 00 00    	jne    80100a1e <consoleintr+0x17e>
  while((c = getc()) >= 0){
801008dc:	ff d6                	call   *%esi
    switch(c){
801008de:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008e3:	89 c3                	mov    %eax,%ebx
801008e5:	85 c0                	test   %eax,%eax
801008e7:	79 da                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e9:	83 ec 0c             	sub    $0xc,%esp
801008ec:	68 20 ff 10 80       	push   $0x8010ff20
801008f1:	e8 0a 3e 00 00       	call   80104700 <release>
  if(doprocdump) {
801008f6:	83 c4 10             	add    $0x10,%esp
801008f9:	85 ff                	test   %edi,%edi
801008fb:	0f 85 9f 01 00 00    	jne    80100aa0 <consoleintr+0x200>
}
80100901:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100904:	5b                   	pop    %ebx
80100905:	5e                   	pop    %esi
80100906:	5f                   	pop    %edi
80100907:	5d                   	pop    %ebp
80100908:	c3                   	ret
80100909:	b8 00 01 00 00       	mov    $0x100,%eax
8010090e:	e8 ed fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100913:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100918:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010091e:	74 9b                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100920:	83 e8 01             	sub    $0x1,%eax
80100923:	89 c2                	mov    %eax,%edx
80100925:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100928:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
8010092f:	74 8a                	je     801008bb <consoleintr+0x1b>
  if(panicked){
80100931:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
80100937:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
8010093c:	85 d2                	test   %edx,%edx
8010093e:	74 c9                	je     80100909 <consoleintr+0x69>
80100940:	fa                   	cli
    for(;;)
80100941:	eb fe                	jmp    80100941 <consoleintr+0xa1>
80100943:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    switch(c){
80100948:	83 fb 43             	cmp    $0x43,%ebx
8010094b:	0f 84 9f 00 00 00    	je     801009f0 <consoleintr+0x150>
80100951:	83 fb 7f             	cmp    $0x7f,%ebx
80100954:	74 6a                	je     801009c0 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100956:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010095b:	89 c2                	mov    %eax,%edx
8010095d:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80100963:	83 fa 7f             	cmp    $0x7f,%edx
80100966:	0f 87 4f ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
8010096c:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100972:	8d 50 01             	lea    0x1(%eax),%edx
80100975:	83 e0 7f             	and    $0x7f,%eax
80100978:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
8010097e:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100984:	85 c9                	test   %ecx,%ecx
80100986:	0f 85 0e 01 00 00    	jne    80100a9a <consoleintr+0x1fa>
8010098c:	89 d8                	mov    %ebx,%eax
8010098e:	e8 6d fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100993:	83 fb 0a             	cmp    $0xa,%ebx
80100996:	0f 84 d0 00 00 00    	je     80100a6c <consoleintr+0x1cc>
8010099c:	83 fb 04             	cmp    $0x4,%ebx
8010099f:	0f 84 c7 00 00 00    	je     80100a6c <consoleintr+0x1cc>
801009a5:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801009aa:	83 e8 80             	sub    $0xffffff80,%eax
801009ad:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
801009b3:	0f 85 02 ff ff ff    	jne    801008bb <consoleintr+0x1b>
801009b9:	e9 b3 00 00 00       	jmp    80100a71 <consoleintr+0x1d1>
801009be:	66 90                	xchg   %ax,%ax
      if(input.e != input.w){
801009c0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009c5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009cb:	0f 84 ea fe ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
801009d1:	83 e8 01             	sub    $0x1,%eax
801009d4:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
801009d9:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801009de:	85 c0                	test   %eax,%eax
801009e0:	0f 84 a5 00 00 00    	je     80100a8b <consoleintr+0x1eb>
801009e6:	fa                   	cli
    for(;;)
801009e7:	eb fe                	jmp    801009e7 <consoleintr+0x147>
801009e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("Shift+C detected\n");  // Debugging statement
801009f0:	83 ec 0c             	sub    $0xc,%esp
801009f3:	68 68 7a 10 80       	push   $0x80107a68
801009f8:	e8 b3 fc ff ff       	call   801006b0 <cprintf>
      if (myproc()) {
801009fd:	e8 ae 30 00 00       	call   80103ab0 <myproc>
80100a02:	83 c4 10             	add    $0x10,%esp
80100a05:	85 c0                	test   %eax,%eax
80100a07:	0f 84 ae fe ff ff    	je     801008bb <consoleintr+0x1b>
        myproc()->pending_signals |= (1 << 2);  // Raise SIGINT (signal number 2)
80100a0d:	e8 9e 30 00 00       	call   80103ab0 <myproc>
80100a12:	83 88 fc 00 00 00 04 	orl    $0x4,0xfc(%eax)
80100a19:	e9 9d fe ff ff       	jmp    801008bb <consoleintr+0x1b>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a1e:	85 db                	test   %ebx,%ebx
80100a20:	0f 84 95 fe ff ff    	je     801008bb <consoleintr+0x1b>
80100a26:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a2b:	89 c2                	mov    %eax,%edx
80100a2d:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80100a33:	83 fa 7f             	cmp    $0x7f,%edx
80100a36:	0f 87 7f fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a3c:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
80100a3f:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a45:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a48:	83 fb 0d             	cmp    $0xd,%ebx
80100a4b:	0f 85 27 ff ff ff    	jne    80100978 <consoleintr+0xd8>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a51:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100a57:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a5e:	85 c9                	test   %ecx,%ecx
80100a60:	75 38                	jne    80100a9a <consoleintr+0x1fa>
80100a62:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a67:	e8 94 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a6c:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a71:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a74:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a79:	68 00 ff 10 80       	push   $0x8010ff00
80100a7e:	e8 7d 38 00 00       	call   80104300 <wakeup>
80100a83:	83 c4 10             	add    $0x10,%esp
80100a86:	e9 30 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a8b:	b8 00 01 00 00       	mov    $0x100,%eax
80100a90:	e8 6b f9 ff ff       	call   80100400 <consputc.part.0>
80100a95:	e9 21 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a9a:	fa                   	cli
    for(;;)
80100a9b:	eb fe                	jmp    80100a9b <consoleintr+0x1fb>
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi
}
80100aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aa3:	5b                   	pop    %ebx
80100aa4:	5e                   	pop    %esi
80100aa5:	5f                   	pop    %edi
80100aa6:	5d                   	pop    %ebp
    procdump();  // now call procdump() without cons.lock held
80100aa7:	e9 34 39 00 00       	jmp    801043e0 <procdump>
80100aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ab0 <consoleinit>:

void
consoleinit(void)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ab6:	68 7a 7a 10 80       	push   $0x80107a7a
80100abb:	68 20 ff 10 80       	push   $0x8010ff20
80100ac0:	e8 ab 3a 00 00       	call   80104570 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ac5:	58                   	pop    %eax
80100ac6:	5a                   	pop    %edx
80100ac7:	6a 00                	push   $0x0
80100ac9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100acb:	c7 05 0c 09 11 80 b0 	movl   $0x801005b0,0x8011090c
80100ad2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ad5:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100adc:	02 10 80 
  cons.locking = 1;
80100adf:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100ae6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100ae9:	e8 42 1a 00 00       	call   80102530 <ioapicenable>
}
80100aee:	83 c4 10             	add    $0x10,%esp
80100af1:	c9                   	leave
80100af2:	c3                   	ret
80100af3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100afa:	00 
80100afb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100b00 <consoleclear>:

void consoleclear(void) {
80100b00:	55                   	push   %ebp
80100b01:	89 e5                	mov    %esp,%ebp
80100b03:	56                   	push   %esi
80100b04:	53                   	push   %ebx
    acquire(&cons.lock); // Acquire console lock
80100b05:	83 ec 0c             	sub    $0xc,%esp
80100b08:	68 20 ff 10 80       	push   $0x8010ff20
80100b0d:	e8 4e 3c 00 00       	call   80104760 <acquire>
80100b12:	83 c4 10             	add    $0x10,%esp
80100b15:	b8 00 80 0b 80       	mov    $0x800b8000,%eax
80100b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // Clear the screen buffer completely
    for (int i = 0; i < 25 * 80; i++) {
        crt[i] = ' ' | 0x0700;  // Black text on white background
80100b20:	ba 20 07 00 00       	mov    $0x720,%edx
80100b25:	b9 20 07 00 00       	mov    $0x720,%ecx
    for (int i = 0; i < 25 * 80; i++) {
80100b2a:	83 c0 04             	add    $0x4,%eax
        crt[i] = ' ' | 0x0700;  // Black text on white background
80100b2d:	66 89 50 fc          	mov    %dx,-0x4(%eax)
80100b31:	66 89 48 fe          	mov    %cx,-0x2(%eax)
    for (int i = 0; i < 25 * 80; i++) {
80100b35:	3d a0 8f 0b 80       	cmp    $0x800b8fa0,%eax
80100b3a:	75 e4                	jne    80100b20 <consoleclear+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b3c:	be d4 03 00 00       	mov    $0x3d4,%esi
80100b41:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b46:	89 f2                	mov    %esi,%edx
80100b48:	ee                   	out    %al,(%dx)
80100b49:	31 c9                	xor    %ecx,%ecx
80100b4b:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100b50:	89 c8                	mov    %ecx,%eax
80100b52:	89 da                	mov    %ebx,%edx
80100b54:	ee                   	out    %al,(%dx)
80100b55:	b8 0f 00 00 00       	mov    $0xf,%eax
80100b5a:	89 f2                	mov    %esi,%edx
80100b5c:	ee                   	out    %al,(%dx)
80100b5d:	89 c8                	mov    %ecx,%eax
80100b5f:	89 da                	mov    %ebx,%edx
80100b61:	ee                   	out    %al,(%dx)
    outb(CRTPORT, 14);
    outb(CRTPORT + 1, 0 >> 8);
    outb(CRTPORT, 15);
    outb(CRTPORT + 1, 0);

    release(&cons.lock); // Release console lock
80100b62:	83 ec 0c             	sub    $0xc,%esp
80100b65:	68 20 ff 10 80       	push   $0x8010ff20
80100b6a:	e8 91 3b 00 00       	call   80104700 <release>
}
80100b6f:	83 c4 10             	add    $0x10,%esp
80100b72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100b75:	5b                   	pop    %ebx
80100b76:	5e                   	pop    %esi
80100b77:	5d                   	pop    %ebp
80100b78:	c3                   	ret
80100b79:	66 90                	xchg   %ax,%ax
80100b7b:	66 90                	xchg   %ax,%ax
80100b7d:	66 90                	xchg   %ax,%ax
80100b7f:	90                   	nop

80100b80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b80:	55                   	push   %ebp
80100b81:	89 e5                	mov    %esp,%ebp
80100b83:	57                   	push   %edi
80100b84:	56                   	push   %esi
80100b85:	53                   	push   %ebx
80100b86:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b8c:	e8 1f 2f 00 00       	call   80103ab0 <myproc>
80100b91:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100b97:	e8 74 22 00 00       	call   80102e10 <begin_op>

  if((ip = namei(path)) == 0){
80100b9c:	83 ec 0c             	sub    $0xc,%esp
80100b9f:	ff 75 08             	push   0x8(%ebp)
80100ba2:	e8 a9 15 00 00       	call   80102150 <namei>
80100ba7:	83 c4 10             	add    $0x10,%esp
80100baa:	85 c0                	test   %eax,%eax
80100bac:	0f 84 30 03 00 00    	je     80100ee2 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100bb2:	83 ec 0c             	sub    $0xc,%esp
80100bb5:	89 c7                	mov    %eax,%edi
80100bb7:	50                   	push   %eax
80100bb8:	e8 b3 0c 00 00       	call   80101870 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bbd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100bc3:	6a 34                	push   $0x34
80100bc5:	6a 00                	push   $0x0
80100bc7:	50                   	push   %eax
80100bc8:	57                   	push   %edi
80100bc9:	e8 b2 0f 00 00       	call   80101b80 <readi>
80100bce:	83 c4 20             	add    $0x20,%esp
80100bd1:	83 f8 34             	cmp    $0x34,%eax
80100bd4:	0f 85 01 01 00 00    	jne    80100cdb <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100bda:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100be1:	45 4c 46 
80100be4:	0f 85 f1 00 00 00    	jne    80100cdb <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100bea:	e8 d1 6a 00 00       	call   801076c0 <setupkvm>
80100bef:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100bf5:	85 c0                	test   %eax,%eax
80100bf7:	0f 84 de 00 00 00    	je     80100cdb <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bfd:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c04:	00 
80100c05:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100c0b:	0f 84 a1 02 00 00    	je     80100eb2 <exec+0x332>
  sz = 0;
80100c11:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100c18:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c1b:	31 db                	xor    %ebx,%ebx
80100c1d:	e9 8c 00 00 00       	jmp    80100cae <exec+0x12e>
80100c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c28:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100c2f:	75 6c                	jne    80100c9d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100c31:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100c37:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100c3d:	0f 82 87 00 00 00    	jb     80100cca <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c43:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100c49:	72 7f                	jb     80100cca <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c4b:	83 ec 04             	sub    $0x4,%esp
80100c4e:	50                   	push   %eax
80100c4f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100c55:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c5b:	e8 90 68 00 00       	call   801074f0 <allocuvm>
80100c60:	83 c4 10             	add    $0x10,%esp
80100c63:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c69:	85 c0                	test   %eax,%eax
80100c6b:	74 5d                	je     80100cca <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100c6d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c73:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c78:	75 50                	jne    80100cca <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c7a:	83 ec 0c             	sub    $0xc,%esp
80100c7d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100c83:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100c89:	57                   	push   %edi
80100c8a:	50                   	push   %eax
80100c8b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c91:	e8 8a 67 00 00       	call   80107420 <loaduvm>
80100c96:	83 c4 20             	add    $0x20,%esp
80100c99:	85 c0                	test   %eax,%eax
80100c9b:	78 2d                	js     80100cca <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c9d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ca4:	83 c3 01             	add    $0x1,%ebx
80100ca7:	83 c6 20             	add    $0x20,%esi
80100caa:	39 d8                	cmp    %ebx,%eax
80100cac:	7e 52                	jle    80100d00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cae:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100cb4:	6a 20                	push   $0x20
80100cb6:	56                   	push   %esi
80100cb7:	50                   	push   %eax
80100cb8:	57                   	push   %edi
80100cb9:	e8 c2 0e 00 00       	call   80101b80 <readi>
80100cbe:	83 c4 10             	add    $0x10,%esp
80100cc1:	83 f8 20             	cmp    $0x20,%eax
80100cc4:	0f 84 5e ff ff ff    	je     80100c28 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100cca:	83 ec 0c             	sub    $0xc,%esp
80100ccd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cd3:	e8 68 69 00 00       	call   80107640 <freevm>
  if(ip){
80100cd8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100cdb:	83 ec 0c             	sub    $0xc,%esp
80100cde:	57                   	push   %edi
80100cdf:	e8 1c 0e 00 00       	call   80101b00 <iunlockput>
    end_op();
80100ce4:	e8 97 21 00 00       	call   80102e80 <end_op>
80100ce9:	83 c4 10             	add    $0x10,%esp
    return -1;
80100cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100cf4:	5b                   	pop    %ebx
80100cf5:	5e                   	pop    %esi
80100cf6:	5f                   	pop    %edi
80100cf7:	5d                   	pop    %ebp
80100cf8:	c3                   	ret
80100cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100d00:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100d06:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100d0c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d12:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100d18:	83 ec 0c             	sub    $0xc,%esp
80100d1b:	57                   	push   %edi
80100d1c:	e8 df 0d 00 00       	call   80101b00 <iunlockput>
  end_op();
80100d21:	e8 5a 21 00 00       	call   80102e80 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d26:	83 c4 0c             	add    $0xc,%esp
80100d29:	53                   	push   %ebx
80100d2a:	56                   	push   %esi
80100d2b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100d31:	56                   	push   %esi
80100d32:	e8 b9 67 00 00       	call   801074f0 <allocuvm>
80100d37:	83 c4 10             	add    $0x10,%esp
80100d3a:	89 c7                	mov    %eax,%edi
80100d3c:	85 c0                	test   %eax,%eax
80100d3e:	0f 84 86 00 00 00    	je     80100dca <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d44:	83 ec 08             	sub    $0x8,%esp
80100d47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100d4d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d4f:	50                   	push   %eax
80100d50:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100d51:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d53:	e8 08 6a 00 00       	call   80107760 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100d58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d5b:	83 c4 10             	add    $0x10,%esp
80100d5e:	8b 10                	mov    (%eax),%edx
80100d60:	85 d2                	test   %edx,%edx
80100d62:	0f 84 56 01 00 00    	je     80100ebe <exec+0x33e>
80100d68:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100d6e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100d71:	eb 23                	jmp    80100d96 <exec+0x216>
80100d73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d78:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100d7b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100d82:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100d88:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100d8b:	85 d2                	test   %edx,%edx
80100d8d:	74 51                	je     80100de0 <exec+0x260>
    if(argc >= MAXARG)
80100d8f:	83 f8 20             	cmp    $0x20,%eax
80100d92:	74 36                	je     80100dca <exec+0x24a>
80100d94:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d96:	83 ec 0c             	sub    $0xc,%esp
80100d99:	52                   	push   %edx
80100d9a:	e8 b1 3c 00 00       	call   80104a50 <strlen>
80100d9f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100da1:	58                   	pop    %eax
80100da2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100da5:	83 eb 01             	sub    $0x1,%ebx
80100da8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dab:	e8 a0 3c 00 00       	call   80104a50 <strlen>
80100db0:	83 c0 01             	add    $0x1,%eax
80100db3:	50                   	push   %eax
80100db4:	ff 34 b7             	push   (%edi,%esi,4)
80100db7:	53                   	push   %ebx
80100db8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dbe:	e8 6d 6b 00 00       	call   80107930 <copyout>
80100dc3:	83 c4 20             	add    $0x20,%esp
80100dc6:	85 c0                	test   %eax,%eax
80100dc8:	79 ae                	jns    80100d78 <exec+0x1f8>
    freevm(pgdir);
80100dca:	83 ec 0c             	sub    $0xc,%esp
80100dcd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dd3:	e8 68 68 00 00       	call   80107640 <freevm>
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	e9 0c ff ff ff       	jmp    80100cec <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100de0:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100de7:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100ded:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100df3:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100df6:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100df9:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100e00:	00 00 00 00 
  ustack[1] = argc;
80100e04:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100e0a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e11:	ff ff ff 
  ustack[1] = argc;
80100e14:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e1a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100e1c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e1e:	29 d0                	sub    %edx,%eax
80100e20:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e26:	56                   	push   %esi
80100e27:	51                   	push   %ecx
80100e28:	53                   	push   %ebx
80100e29:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e2f:	e8 fc 6a 00 00       	call   80107930 <copyout>
80100e34:	83 c4 10             	add    $0x10,%esp
80100e37:	85 c0                	test   %eax,%eax
80100e39:	78 8f                	js     80100dca <exec+0x24a>
  for(last=s=path; *s; s++)
80100e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80100e3e:	8b 55 08             	mov    0x8(%ebp),%edx
80100e41:	0f b6 00             	movzbl (%eax),%eax
80100e44:	84 c0                	test   %al,%al
80100e46:	74 17                	je     80100e5f <exec+0x2df>
80100e48:	89 d1                	mov    %edx,%ecx
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100e50:	83 c1 01             	add    $0x1,%ecx
80100e53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100e55:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100e58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100e5b:	84 c0                	test   %al,%al
80100e5d:	75 f1                	jne    80100e50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100e5f:	83 ec 04             	sub    $0x4,%esp
80100e62:	6a 10                	push   $0x10
80100e64:	52                   	push   %edx
80100e65:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100e6b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100e6e:	50                   	push   %eax
80100e6f:	e8 9c 3b 00 00       	call   80104a10 <safestrcpy>
  curproc->pgdir = pgdir;
80100e74:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100e7a:	89 f0                	mov    %esi,%eax
80100e7c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100e7f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100e81:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100e84:	89 c1                	mov    %eax,%ecx
80100e86:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e8c:	8b 40 18             	mov    0x18(%eax),%eax
80100e8f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e92:	8b 41 18             	mov    0x18(%ecx),%eax
80100e95:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e98:	89 0c 24             	mov    %ecx,(%esp)
80100e9b:	e8 f0 63 00 00       	call   80107290 <switchuvm>
  freevm(oldpgdir);
80100ea0:	89 34 24             	mov    %esi,(%esp)
80100ea3:	e8 98 67 00 00       	call   80107640 <freevm>
  return 0;
80100ea8:	83 c4 10             	add    $0x10,%esp
80100eab:	31 c0                	xor    %eax,%eax
80100ead:	e9 3f fe ff ff       	jmp    80100cf1 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100eb2:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100eb7:	31 f6                	xor    %esi,%esi
80100eb9:	e9 5a fe ff ff       	jmp    80100d18 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100ebe:	be 10 00 00 00       	mov    $0x10,%esi
80100ec3:	ba 04 00 00 00       	mov    $0x4,%edx
80100ec8:	b8 03 00 00 00       	mov    $0x3,%eax
80100ecd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100ed4:	00 00 00 
80100ed7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100edd:	e9 17 ff ff ff       	jmp    80100df9 <exec+0x279>
    end_op();
80100ee2:	e8 99 1f 00 00       	call   80102e80 <end_op>
    cprintf("exec: fail\n");
80100ee7:	83 ec 0c             	sub    $0xc,%esp
80100eea:	68 82 7a 10 80       	push   $0x80107a82
80100eef:	e8 bc f7 ff ff       	call   801006b0 <cprintf>
    return -1;
80100ef4:	83 c4 10             	add    $0x10,%esp
80100ef7:	e9 f0 fd ff ff       	jmp    80100cec <exec+0x16c>
80100efc:	66 90                	xchg   %ax,%ax
80100efe:	66 90                	xchg   %ax,%ax

80100f00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f06:	68 8e 7a 10 80       	push   $0x80107a8e
80100f0b:	68 60 ff 10 80       	push   $0x8010ff60
80100f10:	e8 5b 36 00 00       	call   80104570 <initlock>
}
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	c9                   	leave
80100f19:	c3                   	ret
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f20 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f24:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100f29:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f2c:	68 60 ff 10 80       	push   $0x8010ff60
80100f31:	e8 2a 38 00 00       	call   80104760 <acquire>
80100f36:	83 c4 10             	add    $0x10,%esp
80100f39:	eb 10                	jmp    80100f4b <filealloc+0x2b>
80100f3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f40:	83 c3 18             	add    $0x18,%ebx
80100f43:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100f49:	74 25                	je     80100f70 <filealloc+0x50>
    if(f->ref == 0){
80100f4b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f4e:	85 c0                	test   %eax,%eax
80100f50:	75 ee                	jne    80100f40 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f52:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f55:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f5c:	68 60 ff 10 80       	push   $0x8010ff60
80100f61:	e8 9a 37 00 00       	call   80104700 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f66:	89 d8                	mov    %ebx,%eax
      return f;
80100f68:	83 c4 10             	add    $0x10,%esp
}
80100f6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f6e:	c9                   	leave
80100f6f:	c3                   	ret
  release(&ftable.lock);
80100f70:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f73:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f75:	68 60 ff 10 80       	push   $0x8010ff60
80100f7a:	e8 81 37 00 00       	call   80104700 <release>
}
80100f7f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f81:	83 c4 10             	add    $0x10,%esp
}
80100f84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f87:	c9                   	leave
80100f88:	c3                   	ret
80100f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f90 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	53                   	push   %ebx
80100f94:	83 ec 10             	sub    $0x10,%esp
80100f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f9a:	68 60 ff 10 80       	push   $0x8010ff60
80100f9f:	e8 bc 37 00 00       	call   80104760 <acquire>
  if(f->ref < 1)
80100fa4:	8b 43 04             	mov    0x4(%ebx),%eax
80100fa7:	83 c4 10             	add    $0x10,%esp
80100faa:	85 c0                	test   %eax,%eax
80100fac:	7e 1a                	jle    80100fc8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100fae:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100fb1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100fb4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fb7:	68 60 ff 10 80       	push   $0x8010ff60
80100fbc:	e8 3f 37 00 00       	call   80104700 <release>
  return f;
}
80100fc1:	89 d8                	mov    %ebx,%eax
80100fc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fc6:	c9                   	leave
80100fc7:	c3                   	ret
    panic("filedup");
80100fc8:	83 ec 0c             	sub    $0xc,%esp
80100fcb:	68 95 7a 10 80       	push   $0x80107a95
80100fd0:	e8 ab f3 ff ff       	call   80100380 <panic>
80100fd5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fdc:	00 
80100fdd:	8d 76 00             	lea    0x0(%esi),%esi

80100fe0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 28             	sub    $0x28,%esp
80100fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100fec:	68 60 ff 10 80       	push   $0x8010ff60
80100ff1:	e8 6a 37 00 00       	call   80104760 <acquire>
  if(f->ref < 1)
80100ff6:	8b 53 04             	mov    0x4(%ebx),%edx
80100ff9:	83 c4 10             	add    $0x10,%esp
80100ffc:	85 d2                	test   %edx,%edx
80100ffe:	0f 8e a5 00 00 00    	jle    801010a9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101004:	83 ea 01             	sub    $0x1,%edx
80101007:	89 53 04             	mov    %edx,0x4(%ebx)
8010100a:	75 44                	jne    80101050 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010100c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101010:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101013:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101015:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010101b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010101e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101021:	8b 43 10             	mov    0x10(%ebx),%eax
80101024:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101027:	68 60 ff 10 80       	push   $0x8010ff60
8010102c:	e8 cf 36 00 00       	call   80104700 <release>

  if(ff.type == FD_PIPE)
80101031:	83 c4 10             	add    $0x10,%esp
80101034:	83 ff 01             	cmp    $0x1,%edi
80101037:	74 57                	je     80101090 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101039:	83 ff 02             	cmp    $0x2,%edi
8010103c:	74 2a                	je     80101068 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010103e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101041:	5b                   	pop    %ebx
80101042:	5e                   	pop    %esi
80101043:	5f                   	pop    %edi
80101044:	5d                   	pop    %ebp
80101045:	c3                   	ret
80101046:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010104d:	00 
8010104e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80101050:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80101057:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105a:	5b                   	pop    %ebx
8010105b:	5e                   	pop    %esi
8010105c:	5f                   	pop    %edi
8010105d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010105e:	e9 9d 36 00 00       	jmp    80104700 <release>
80101063:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101068:	e8 a3 1d 00 00       	call   80102e10 <begin_op>
    iput(ff.ip);
8010106d:	83 ec 0c             	sub    $0xc,%esp
80101070:	ff 75 e0             	push   -0x20(%ebp)
80101073:	e8 28 09 00 00       	call   801019a0 <iput>
    end_op();
80101078:	83 c4 10             	add    $0x10,%esp
}
8010107b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010107e:	5b                   	pop    %ebx
8010107f:	5e                   	pop    %esi
80101080:	5f                   	pop    %edi
80101081:	5d                   	pop    %ebp
    end_op();
80101082:	e9 f9 1d 00 00       	jmp    80102e80 <end_op>
80101087:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010108e:	00 
8010108f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80101090:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101094:	83 ec 08             	sub    $0x8,%esp
80101097:	53                   	push   %ebx
80101098:	56                   	push   %esi
80101099:	e8 82 25 00 00       	call   80103620 <pipeclose>
8010109e:	83 c4 10             	add    $0x10,%esp
}
801010a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a4:	5b                   	pop    %ebx
801010a5:	5e                   	pop    %esi
801010a6:	5f                   	pop    %edi
801010a7:	5d                   	pop    %ebp
801010a8:	c3                   	ret
    panic("fileclose");
801010a9:	83 ec 0c             	sub    $0xc,%esp
801010ac:	68 9d 7a 10 80       	push   $0x80107a9d
801010b1:	e8 ca f2 ff ff       	call   80100380 <panic>
801010b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801010bd:	00 
801010be:	66 90                	xchg   %ax,%ax

801010c0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	53                   	push   %ebx
801010c4:	83 ec 04             	sub    $0x4,%esp
801010c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801010ca:	83 3b 02             	cmpl   $0x2,(%ebx)
801010cd:	75 31                	jne    80101100 <filestat+0x40>
    ilock(f->ip);
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	ff 73 10             	push   0x10(%ebx)
801010d5:	e8 96 07 00 00       	call   80101870 <ilock>
    stati(f->ip, st);
801010da:	58                   	pop    %eax
801010db:	5a                   	pop    %edx
801010dc:	ff 75 0c             	push   0xc(%ebp)
801010df:	ff 73 10             	push   0x10(%ebx)
801010e2:	e8 69 0a 00 00       	call   80101b50 <stati>
    iunlock(f->ip);
801010e7:	59                   	pop    %ecx
801010e8:	ff 73 10             	push   0x10(%ebx)
801010eb:	e8 60 08 00 00       	call   80101950 <iunlock>
    return 0;
  }
  return -1;
}
801010f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801010f3:	83 c4 10             	add    $0x10,%esp
801010f6:	31 c0                	xor    %eax,%eax
}
801010f8:	c9                   	leave
801010f9:	c3                   	ret
801010fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101100:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101108:	c9                   	leave
80101109:	c3                   	ret
8010110a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101110 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 0c             	sub    $0xc,%esp
80101119:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010111c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010111f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101122:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101126:	74 60                	je     80101188 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101128:	8b 03                	mov    (%ebx),%eax
8010112a:	83 f8 01             	cmp    $0x1,%eax
8010112d:	74 41                	je     80101170 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112f:	83 f8 02             	cmp    $0x2,%eax
80101132:	75 5b                	jne    8010118f <fileread+0x7f>
    ilock(f->ip);
80101134:	83 ec 0c             	sub    $0xc,%esp
80101137:	ff 73 10             	push   0x10(%ebx)
8010113a:	e8 31 07 00 00       	call   80101870 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010113f:	57                   	push   %edi
80101140:	ff 73 14             	push   0x14(%ebx)
80101143:	56                   	push   %esi
80101144:	ff 73 10             	push   0x10(%ebx)
80101147:	e8 34 0a 00 00       	call   80101b80 <readi>
8010114c:	83 c4 20             	add    $0x20,%esp
8010114f:	89 c6                	mov    %eax,%esi
80101151:	85 c0                	test   %eax,%eax
80101153:	7e 03                	jle    80101158 <fileread+0x48>
      f->off += r;
80101155:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101158:	83 ec 0c             	sub    $0xc,%esp
8010115b:	ff 73 10             	push   0x10(%ebx)
8010115e:	e8 ed 07 00 00       	call   80101950 <iunlock>
    return r;
80101163:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101166:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101169:	89 f0                	mov    %esi,%eax
8010116b:	5b                   	pop    %ebx
8010116c:	5e                   	pop    %esi
8010116d:	5f                   	pop    %edi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101170:	8b 43 0c             	mov    0xc(%ebx),%eax
80101173:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101176:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101179:	5b                   	pop    %ebx
8010117a:	5e                   	pop    %esi
8010117b:	5f                   	pop    %edi
8010117c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010117d:	e9 5e 26 00 00       	jmp    801037e0 <piperead>
80101182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101188:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010118d:	eb d7                	jmp    80101166 <fileread+0x56>
  panic("fileread");
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	68 a7 7a 10 80       	push   $0x80107aa7
80101197:	e8 e4 f1 ff ff       	call   80100380 <panic>
8010119c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	57                   	push   %edi
801011a4:	56                   	push   %esi
801011a5:	53                   	push   %ebx
801011a6:	83 ec 1c             	sub    $0x1c,%esp
801011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801011ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
801011af:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011b2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801011b5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801011b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011bc:	0f 84 bb 00 00 00    	je     8010127d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801011c2:	8b 03                	mov    (%ebx),%eax
801011c4:	83 f8 01             	cmp    $0x1,%eax
801011c7:	0f 84 bf 00 00 00    	je     8010128c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011cd:	83 f8 02             	cmp    $0x2,%eax
801011d0:	0f 85 c8 00 00 00    	jne    8010129e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801011d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801011d9:	31 f6                	xor    %esi,%esi
    while(i < n){
801011db:	85 c0                	test   %eax,%eax
801011dd:	7f 30                	jg     8010120f <filewrite+0x6f>
801011df:	e9 94 00 00 00       	jmp    80101278 <filewrite+0xd8>
801011e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801011e8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801011eb:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
801011ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011f1:	ff 73 10             	push   0x10(%ebx)
801011f4:	e8 57 07 00 00       	call   80101950 <iunlock>
      end_op();
801011f9:	e8 82 1c 00 00       	call   80102e80 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801011fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101201:	83 c4 10             	add    $0x10,%esp
80101204:	39 c7                	cmp    %eax,%edi
80101206:	75 5c                	jne    80101264 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101208:	01 fe                	add    %edi,%esi
    while(i < n){
8010120a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010120d:	7e 69                	jle    80101278 <filewrite+0xd8>
      int n1 = n - i;
8010120f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101212:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101217:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101219:	39 c7                	cmp    %eax,%edi
8010121b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010121e:	e8 ed 1b 00 00       	call   80102e10 <begin_op>
      ilock(f->ip);
80101223:	83 ec 0c             	sub    $0xc,%esp
80101226:	ff 73 10             	push   0x10(%ebx)
80101229:	e8 42 06 00 00       	call   80101870 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010122e:	57                   	push   %edi
8010122f:	ff 73 14             	push   0x14(%ebx)
80101232:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101235:	01 f0                	add    %esi,%eax
80101237:	50                   	push   %eax
80101238:	ff 73 10             	push   0x10(%ebx)
8010123b:	e8 40 0a 00 00       	call   80101c80 <writei>
80101240:	83 c4 20             	add    $0x20,%esp
80101243:	85 c0                	test   %eax,%eax
80101245:	7f a1                	jg     801011e8 <filewrite+0x48>
80101247:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010124a:	83 ec 0c             	sub    $0xc,%esp
8010124d:	ff 73 10             	push   0x10(%ebx)
80101250:	e8 fb 06 00 00       	call   80101950 <iunlock>
      end_op();
80101255:	e8 26 1c 00 00       	call   80102e80 <end_op>
      if(r < 0)
8010125a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010125d:	83 c4 10             	add    $0x10,%esp
80101260:	85 c0                	test   %eax,%eax
80101262:	75 14                	jne    80101278 <filewrite+0xd8>
        panic("short filewrite");
80101264:	83 ec 0c             	sub    $0xc,%esp
80101267:	68 b0 7a 10 80       	push   $0x80107ab0
8010126c:	e8 0f f1 ff ff       	call   80100380 <panic>
80101271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101278:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010127b:	74 05                	je     80101282 <filewrite+0xe2>
8010127d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80101282:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101285:	89 f0                	mov    %esi,%eax
80101287:	5b                   	pop    %ebx
80101288:	5e                   	pop    %esi
80101289:	5f                   	pop    %edi
8010128a:	5d                   	pop    %ebp
8010128b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010128c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010128f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101292:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101295:	5b                   	pop    %ebx
80101296:	5e                   	pop    %esi
80101297:	5f                   	pop    %edi
80101298:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101299:	e9 22 24 00 00       	jmp    801036c0 <pipewrite>
  panic("filewrite");
8010129e:	83 ec 0c             	sub    $0xc,%esp
801012a1:	68 b6 7a 10 80       	push   $0x80107ab6
801012a6:	e8 d5 f0 ff ff       	call   80100380 <panic>
801012ab:	66 90                	xchg   %ax,%ax
801012ad:	66 90                	xchg   %ax,%ax
801012af:	90                   	nop

801012b0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	56                   	push   %esi
801012b5:	53                   	push   %ebx
801012b6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801012b9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801012bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012c2:	85 c9                	test   %ecx,%ecx
801012c4:	0f 84 8c 00 00 00    	je     80101356 <balloc+0xa6>
801012ca:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801012cc:	89 f8                	mov    %edi,%eax
801012ce:	83 ec 08             	sub    $0x8,%esp
801012d1:	89 fe                	mov    %edi,%esi
801012d3:	c1 f8 0c             	sar    $0xc,%eax
801012d6:	03 05 cc 25 11 80    	add    0x801125cc,%eax
801012dc:	50                   	push   %eax
801012dd:	ff 75 dc             	push   -0x24(%ebp)
801012e0:	e8 eb ed ff ff       	call   801000d0 <bread>
801012e5:	89 7d d8             	mov    %edi,-0x28(%ebp)
801012e8:	83 c4 10             	add    $0x10,%esp
801012eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012ee:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801012f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012f6:	31 c0                	xor    %eax,%eax
801012f8:	eb 32                	jmp    8010132c <balloc+0x7c>
801012fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101300:	89 c1                	mov    %eax,%ecx
80101302:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101307:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010130a:	83 e1 07             	and    $0x7,%ecx
8010130d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010130f:	89 c1                	mov    %eax,%ecx
80101311:	c1 f9 03             	sar    $0x3,%ecx
80101314:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101319:	89 fa                	mov    %edi,%edx
8010131b:	85 df                	test   %ebx,%edi
8010131d:	74 49                	je     80101368 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010131f:	83 c0 01             	add    $0x1,%eax
80101322:	83 c6 01             	add    $0x1,%esi
80101325:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010132a:	74 07                	je     80101333 <balloc+0x83>
8010132c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010132f:	39 d6                	cmp    %edx,%esi
80101331:	72 cd                	jb     80101300 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101333:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101336:	83 ec 0c             	sub    $0xc,%esp
80101339:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010133c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101342:	e8 a9 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101347:	83 c4 10             	add    $0x10,%esp
8010134a:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
80101350:	0f 82 76 ff ff ff    	jb     801012cc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101356:	83 ec 0c             	sub    $0xc,%esp
80101359:	68 c0 7a 10 80       	push   $0x80107ac0
8010135e:	e8 1d f0 ff ff       	call   80100380 <panic>
80101363:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101368:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010136b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010136e:	09 da                	or     %ebx,%edx
80101370:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101374:	57                   	push   %edi
80101375:	e8 76 1c 00 00       	call   80102ff0 <log_write>
        brelse(bp);
8010137a:	89 3c 24             	mov    %edi,(%esp)
8010137d:	e8 6e ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101382:	58                   	pop    %eax
80101383:	5a                   	pop    %edx
80101384:	56                   	push   %esi
80101385:	ff 75 dc             	push   -0x24(%ebp)
80101388:	e8 43 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010138d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101390:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101392:	8d 40 5c             	lea    0x5c(%eax),%eax
80101395:	68 00 02 00 00       	push   $0x200
8010139a:	6a 00                	push   $0x0
8010139c:	50                   	push   %eax
8010139d:	e8 be 34 00 00       	call   80104860 <memset>
  log_write(bp);
801013a2:	89 1c 24             	mov    %ebx,(%esp)
801013a5:	e8 46 1c 00 00       	call   80102ff0 <log_write>
  brelse(bp);
801013aa:	89 1c 24             	mov    %ebx,(%esp)
801013ad:	e8 3e ee ff ff       	call   801001f0 <brelse>
}
801013b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b5:	89 f0                	mov    %esi,%eax
801013b7:	5b                   	pop    %ebx
801013b8:	5e                   	pop    %esi
801013b9:	5f                   	pop    %edi
801013ba:	5d                   	pop    %ebp
801013bb:	c3                   	ret
801013bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013c4:	31 ff                	xor    %edi,%edi
{
801013c6:	56                   	push   %esi
801013c7:	89 c6                	mov    %eax,%esi
801013c9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ca:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801013cf:	83 ec 28             	sub    $0x28,%esp
801013d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013d5:	68 60 09 11 80       	push   $0x80110960
801013da:	e8 81 33 00 00       	call   80104760 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013e2:	83 c4 10             	add    $0x10,%esp
801013e5:	eb 1b                	jmp    80101402 <iget+0x42>
801013e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013ee:	00 
801013ef:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 33                	cmp    %esi,(%ebx)
801013f2:	74 6c                	je     80101460 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013f4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013fa:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101400:	74 26                	je     80101428 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101402:	8b 43 08             	mov    0x8(%ebx),%eax
80101405:	85 c0                	test   %eax,%eax
80101407:	7f e7                	jg     801013f0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101409:	85 ff                	test   %edi,%edi
8010140b:	75 e7                	jne    801013f4 <iget+0x34>
8010140d:	85 c0                	test   %eax,%eax
8010140f:	75 76                	jne    80101487 <iget+0xc7>
      empty = ip;
80101411:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101413:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101419:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010141f:	75 e1                	jne    80101402 <iget+0x42>
80101421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101428:	85 ff                	test   %edi,%edi
8010142a:	74 79                	je     801014a5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010142c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010142f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101431:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101434:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010143b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101442:	68 60 09 11 80       	push   $0x80110960
80101447:	e8 b4 32 00 00       	call   80104700 <release>

  return ip;
8010144c:	83 c4 10             	add    $0x10,%esp
}
8010144f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101452:	89 f8                	mov    %edi,%eax
80101454:	5b                   	pop    %ebx
80101455:	5e                   	pop    %esi
80101456:	5f                   	pop    %edi
80101457:	5d                   	pop    %ebp
80101458:	c3                   	ret
80101459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101460:	39 53 04             	cmp    %edx,0x4(%ebx)
80101463:	75 8f                	jne    801013f4 <iget+0x34>
      ip->ref++;
80101465:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101468:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010146b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010146d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101470:	68 60 09 11 80       	push   $0x80110960
80101475:	e8 86 32 00 00       	call   80104700 <release>
      return ip;
8010147a:	83 c4 10             	add    $0x10,%esp
}
8010147d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101480:	89 f8                	mov    %edi,%eax
80101482:	5b                   	pop    %ebx
80101483:	5e                   	pop    %esi
80101484:	5f                   	pop    %edi
80101485:	5d                   	pop    %ebp
80101486:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101487:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010148d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101493:	74 10                	je     801014a5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101495:	8b 43 08             	mov    0x8(%ebx),%eax
80101498:	85 c0                	test   %eax,%eax
8010149a:	0f 8f 50 ff ff ff    	jg     801013f0 <iget+0x30>
801014a0:	e9 68 ff ff ff       	jmp    8010140d <iget+0x4d>
    panic("iget: no inodes");
801014a5:	83 ec 0c             	sub    $0xc,%esp
801014a8:	68 d6 7a 10 80       	push   $0x80107ad6
801014ad:	e8 ce ee ff ff       	call   80100380 <panic>
801014b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014b9:	00 
801014ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801014c0 <bfree>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801014c3:	89 d0                	mov    %edx,%eax
801014c5:	c1 e8 0c             	shr    $0xc,%eax
{
801014c8:	89 e5                	mov    %esp,%ebp
801014ca:	56                   	push   %esi
801014cb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801014cc:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801014d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801014d4:	83 ec 08             	sub    $0x8,%esp
801014d7:	50                   	push   %eax
801014d8:	51                   	push   %ecx
801014d9:	e8 f2 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014e0:	c1 fb 03             	sar    $0x3,%ebx
801014e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801014e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801014e8:	83 e1 07             	and    $0x7,%ecx
801014eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801014f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801014f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801014f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801014fd:	85 c1                	test   %eax,%ecx
801014ff:	74 23                	je     80101524 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101501:	f7 d0                	not    %eax
  log_write(bp);
80101503:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101506:	21 c8                	and    %ecx,%eax
80101508:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010150c:	56                   	push   %esi
8010150d:	e8 de 1a 00 00       	call   80102ff0 <log_write>
  brelse(bp);
80101512:	89 34 24             	mov    %esi,(%esp)
80101515:	e8 d6 ec ff ff       	call   801001f0 <brelse>
}
8010151a:	83 c4 10             	add    $0x10,%esp
8010151d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101520:	5b                   	pop    %ebx
80101521:	5e                   	pop    %esi
80101522:	5d                   	pop    %ebp
80101523:	c3                   	ret
    panic("freeing free block");
80101524:	83 ec 0c             	sub    $0xc,%esp
80101527:	68 e6 7a 10 80       	push   $0x80107ae6
8010152c:	e8 4f ee ff ff       	call   80100380 <panic>
80101531:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101538:	00 
80101539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101540 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	89 c6                	mov    %eax,%esi
80101547:	53                   	push   %ebx
80101548:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010154b:	83 fa 0b             	cmp    $0xb,%edx
8010154e:	0f 86 8c 00 00 00    	jbe    801015e0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101554:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101557:	83 fb 7f             	cmp    $0x7f,%ebx
8010155a:	0f 87 a2 00 00 00    	ja     80101602 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101560:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101566:	85 c0                	test   %eax,%eax
80101568:	74 5e                	je     801015c8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010156a:	83 ec 08             	sub    $0x8,%esp
8010156d:	50                   	push   %eax
8010156e:	ff 36                	push   (%esi)
80101570:	e8 5b eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101575:	83 c4 10             	add    $0x10,%esp
80101578:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010157c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010157e:	8b 3b                	mov    (%ebx),%edi
80101580:	85 ff                	test   %edi,%edi
80101582:	74 1c                	je     801015a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101584:	83 ec 0c             	sub    $0xc,%esp
80101587:	52                   	push   %edx
80101588:	e8 63 ec ff ff       	call   801001f0 <brelse>
8010158d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101590:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101593:	89 f8                	mov    %edi,%eax
80101595:	5b                   	pop    %ebx
80101596:	5e                   	pop    %esi
80101597:	5f                   	pop    %edi
80101598:	5d                   	pop    %ebp
80101599:	c3                   	ret
8010159a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801015a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801015a3:	8b 06                	mov    (%esi),%eax
801015a5:	e8 06 fd ff ff       	call   801012b0 <balloc>
      log_write(bp);
801015aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801015b0:	89 03                	mov    %eax,(%ebx)
801015b2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801015b4:	52                   	push   %edx
801015b5:	e8 36 1a 00 00       	call   80102ff0 <log_write>
801015ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015bd:	83 c4 10             	add    $0x10,%esp
801015c0:	eb c2                	jmp    80101584 <bmap+0x44>
801015c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015c8:	8b 06                	mov    (%esi),%eax
801015ca:	e8 e1 fc ff ff       	call   801012b0 <balloc>
801015cf:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015d5:	eb 93                	jmp    8010156a <bmap+0x2a>
801015d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015de:	00 
801015df:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
801015e0:	8d 5a 14             	lea    0x14(%edx),%ebx
801015e3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801015e7:	85 ff                	test   %edi,%edi
801015e9:	75 a5                	jne    80101590 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801015eb:	8b 00                	mov    (%eax),%eax
801015ed:	e8 be fc ff ff       	call   801012b0 <balloc>
801015f2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801015f6:	89 c7                	mov    %eax,%edi
}
801015f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015fb:	5b                   	pop    %ebx
801015fc:	89 f8                	mov    %edi,%eax
801015fe:	5e                   	pop    %esi
801015ff:	5f                   	pop    %edi
80101600:	5d                   	pop    %ebp
80101601:	c3                   	ret
  panic("bmap: out of range");
80101602:	83 ec 0c             	sub    $0xc,%esp
80101605:	68 f9 7a 10 80       	push   $0x80107af9
8010160a:	e8 71 ed ff ff       	call   80100380 <panic>
8010160f:	90                   	nop

80101610 <readsb>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101618:	83 ec 08             	sub    $0x8,%esp
8010161b:	6a 01                	push   $0x1
8010161d:	ff 75 08             	push   0x8(%ebp)
80101620:	e8 ab ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101625:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101628:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010162a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010162d:	6a 1c                	push   $0x1c
8010162f:	50                   	push   %eax
80101630:	56                   	push   %esi
80101631:	e8 ba 32 00 00       	call   801048f0 <memmove>
  brelse(bp);
80101636:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101639:	83 c4 10             	add    $0x10,%esp
}
8010163c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010163f:	5b                   	pop    %ebx
80101640:	5e                   	pop    %esi
80101641:	5d                   	pop    %ebp
  brelse(bp);
80101642:	e9 a9 eb ff ff       	jmp    801001f0 <brelse>
80101647:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010164e:	00 
8010164f:	90                   	nop

80101650 <iinit>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101659:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010165c:	68 0c 7b 10 80       	push   $0x80107b0c
80101661:	68 60 09 11 80       	push   $0x80110960
80101666:	e8 05 2f 00 00       	call   80104570 <initlock>
  for(i = 0; i < NINODE; i++) {
8010166b:	83 c4 10             	add    $0x10,%esp
8010166e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101670:	83 ec 08             	sub    $0x8,%esp
80101673:	68 13 7b 10 80       	push   $0x80107b13
80101678:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101679:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010167f:	e8 bc 2d 00 00       	call   80104440 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101684:	83 c4 10             	add    $0x10,%esp
80101687:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010168d:	75 e1                	jne    80101670 <iinit+0x20>
  bp = bread(dev, 1);
8010168f:	83 ec 08             	sub    $0x8,%esp
80101692:	6a 01                	push   $0x1
80101694:	ff 75 08             	push   0x8(%ebp)
80101697:	e8 34 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010169c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010169f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016a1:	8d 40 5c             	lea    0x5c(%eax),%eax
801016a4:	6a 1c                	push   $0x1c
801016a6:	50                   	push   %eax
801016a7:	68 b4 25 11 80       	push   $0x801125b4
801016ac:	e8 3f 32 00 00       	call   801048f0 <memmove>
  brelse(bp);
801016b1:	89 1c 24             	mov    %ebx,(%esp)
801016b4:	e8 37 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016b9:	ff 35 cc 25 11 80    	push   0x801125cc
801016bf:	ff 35 c8 25 11 80    	push   0x801125c8
801016c5:	ff 35 c4 25 11 80    	push   0x801125c4
801016cb:	ff 35 c0 25 11 80    	push   0x801125c0
801016d1:	ff 35 bc 25 11 80    	push   0x801125bc
801016d7:	ff 35 b8 25 11 80    	push   0x801125b8
801016dd:	ff 35 b4 25 11 80    	push   0x801125b4
801016e3:	68 c4 7f 10 80       	push   $0x80107fc4
801016e8:	e8 c3 ef ff ff       	call   801006b0 <cprintf>
}
801016ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016f0:	83 c4 30             	add    $0x30,%esp
801016f3:	c9                   	leave
801016f4:	c3                   	ret
801016f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016fc:	00 
801016fd:	8d 76 00             	lea    0x0(%esi),%esi

80101700 <ialloc>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	57                   	push   %edi
80101704:	56                   	push   %esi
80101705:	53                   	push   %ebx
80101706:	83 ec 1c             	sub    $0x1c,%esp
80101709:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010170c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101713:	8b 75 08             	mov    0x8(%ebp),%esi
80101716:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101719:	0f 86 91 00 00 00    	jbe    801017b0 <ialloc+0xb0>
8010171f:	bf 01 00 00 00       	mov    $0x1,%edi
80101724:	eb 21                	jmp    80101747 <ialloc+0x47>
80101726:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010172d:	00 
8010172e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101730:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101733:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101736:	53                   	push   %ebx
80101737:	e8 b4 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010173c:	83 c4 10             	add    $0x10,%esp
8010173f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101745:	73 69                	jae    801017b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101747:	89 f8                	mov    %edi,%eax
80101749:	83 ec 08             	sub    $0x8,%esp
8010174c:	c1 e8 03             	shr    $0x3,%eax
8010174f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101755:	50                   	push   %eax
80101756:	56                   	push   %esi
80101757:	e8 74 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010175c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010175f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101761:	89 f8                	mov    %edi,%eax
80101763:	83 e0 07             	and    $0x7,%eax
80101766:	c1 e0 06             	shl    $0x6,%eax
80101769:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010176d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101771:	75 bd                	jne    80101730 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101773:	83 ec 04             	sub    $0x4,%esp
80101776:	6a 40                	push   $0x40
80101778:	6a 00                	push   $0x0
8010177a:	51                   	push   %ecx
8010177b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010177e:	e8 dd 30 00 00       	call   80104860 <memset>
      dip->type = type;
80101783:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101787:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010178a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010178d:	89 1c 24             	mov    %ebx,(%esp)
80101790:	e8 5b 18 00 00       	call   80102ff0 <log_write>
      brelse(bp);
80101795:	89 1c 24             	mov    %ebx,(%esp)
80101798:	e8 53 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010179d:	83 c4 10             	add    $0x10,%esp
}
801017a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017a3:	89 fa                	mov    %edi,%edx
}
801017a5:	5b                   	pop    %ebx
      return iget(dev, inum);
801017a6:	89 f0                	mov    %esi,%eax
}
801017a8:	5e                   	pop    %esi
801017a9:	5f                   	pop    %edi
801017aa:	5d                   	pop    %ebp
      return iget(dev, inum);
801017ab:	e9 10 fc ff ff       	jmp    801013c0 <iget>
  panic("ialloc: no inodes");
801017b0:	83 ec 0c             	sub    $0xc,%esp
801017b3:	68 19 7b 10 80       	push   $0x80107b19
801017b8:	e8 c3 eb ff ff       	call   80100380 <panic>
801017bd:	8d 76 00             	lea    0x0(%esi),%esi

801017c0 <iupdate>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017cb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ce:	83 ec 08             	sub    $0x8,%esp
801017d1:	c1 e8 03             	shr    $0x3,%eax
801017d4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017da:	50                   	push   %eax
801017db:	ff 73 a4             	push   -0x5c(%ebx)
801017de:	e8 ed e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801017e3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017e7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ea:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ec:	8b 43 a8             	mov    -0x58(%ebx),%eax
801017ef:	83 e0 07             	and    $0x7,%eax
801017f2:	c1 e0 06             	shl    $0x6,%eax
801017f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801017f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101800:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101803:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101807:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010180b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010180f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101813:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101817:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010181a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010181d:	6a 34                	push   $0x34
8010181f:	53                   	push   %ebx
80101820:	50                   	push   %eax
80101821:	e8 ca 30 00 00       	call   801048f0 <memmove>
  log_write(bp);
80101826:	89 34 24             	mov    %esi,(%esp)
80101829:	e8 c2 17 00 00       	call   80102ff0 <log_write>
  brelse(bp);
8010182e:	89 75 08             	mov    %esi,0x8(%ebp)
80101831:	83 c4 10             	add    $0x10,%esp
}
80101834:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101837:	5b                   	pop    %ebx
80101838:	5e                   	pop    %esi
80101839:	5d                   	pop    %ebp
  brelse(bp);
8010183a:	e9 b1 e9 ff ff       	jmp    801001f0 <brelse>
8010183f:	90                   	nop

80101840 <idup>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	53                   	push   %ebx
80101844:	83 ec 10             	sub    $0x10,%esp
80101847:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010184a:	68 60 09 11 80       	push   $0x80110960
8010184f:	e8 0c 2f 00 00       	call   80104760 <acquire>
  ip->ref++;
80101854:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101858:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010185f:	e8 9c 2e 00 00       	call   80104700 <release>
}
80101864:	89 d8                	mov    %ebx,%eax
80101866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101869:	c9                   	leave
8010186a:	c3                   	ret
8010186b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101870 <ilock>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101878:	85 db                	test   %ebx,%ebx
8010187a:	0f 84 b7 00 00 00    	je     80101937 <ilock+0xc7>
80101880:	8b 53 08             	mov    0x8(%ebx),%edx
80101883:	85 d2                	test   %edx,%edx
80101885:	0f 8e ac 00 00 00    	jle    80101937 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010188b:	83 ec 0c             	sub    $0xc,%esp
8010188e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101891:	50                   	push   %eax
80101892:	e8 e9 2b 00 00       	call   80104480 <acquiresleep>
  if(ip->valid == 0){
80101897:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010189a:	83 c4 10             	add    $0x10,%esp
8010189d:	85 c0                	test   %eax,%eax
8010189f:	74 0f                	je     801018b0 <ilock+0x40>
}
801018a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018a4:	5b                   	pop    %ebx
801018a5:	5e                   	pop    %esi
801018a6:	5d                   	pop    %ebp
801018a7:	c3                   	ret
801018a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018af:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018b0:	8b 43 04             	mov    0x4(%ebx),%eax
801018b3:	83 ec 08             	sub    $0x8,%esp
801018b6:	c1 e8 03             	shr    $0x3,%eax
801018b9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801018bf:	50                   	push   %eax
801018c0:	ff 33                	push   (%ebx)
801018c2:	e8 09 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018cc:	8b 43 04             	mov    0x4(%ebx),%eax
801018cf:	83 e0 07             	and    $0x7,%eax
801018d2:	c1 e0 06             	shl    $0x6,%eax
801018d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801018d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801018e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801018e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801018eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801018ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801018f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801018f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801018fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801018fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101901:	6a 34                	push   $0x34
80101903:	50                   	push   %eax
80101904:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101907:	50                   	push   %eax
80101908:	e8 e3 2f 00 00       	call   801048f0 <memmove>
    brelse(bp);
8010190d:	89 34 24             	mov    %esi,(%esp)
80101910:	e8 db e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101915:	83 c4 10             	add    $0x10,%esp
80101918:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010191d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101924:	0f 85 77 ff ff ff    	jne    801018a1 <ilock+0x31>
      panic("ilock: no type");
8010192a:	83 ec 0c             	sub    $0xc,%esp
8010192d:	68 31 7b 10 80       	push   $0x80107b31
80101932:	e8 49 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101937:	83 ec 0c             	sub    $0xc,%esp
8010193a:	68 2b 7b 10 80       	push   $0x80107b2b
8010193f:	e8 3c ea ff ff       	call   80100380 <panic>
80101944:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010194b:	00 
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <iunlock>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	56                   	push   %esi
80101954:	53                   	push   %ebx
80101955:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101958:	85 db                	test   %ebx,%ebx
8010195a:	74 28                	je     80101984 <iunlock+0x34>
8010195c:	83 ec 0c             	sub    $0xc,%esp
8010195f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101962:	56                   	push   %esi
80101963:	e8 b8 2b 00 00       	call   80104520 <holdingsleep>
80101968:	83 c4 10             	add    $0x10,%esp
8010196b:	85 c0                	test   %eax,%eax
8010196d:	74 15                	je     80101984 <iunlock+0x34>
8010196f:	8b 43 08             	mov    0x8(%ebx),%eax
80101972:	85 c0                	test   %eax,%eax
80101974:	7e 0e                	jle    80101984 <iunlock+0x34>
  releasesleep(&ip->lock);
80101976:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101979:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010197c:	5b                   	pop    %ebx
8010197d:	5e                   	pop    %esi
8010197e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010197f:	e9 5c 2b 00 00       	jmp    801044e0 <releasesleep>
    panic("iunlock");
80101984:	83 ec 0c             	sub    $0xc,%esp
80101987:	68 40 7b 10 80       	push   $0x80107b40
8010198c:	e8 ef e9 ff ff       	call   80100380 <panic>
80101991:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101998:	00 
80101999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801019a0 <iput>:
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 28             	sub    $0x28,%esp
801019a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019ac:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019af:	57                   	push   %edi
801019b0:	e8 cb 2a 00 00       	call   80104480 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019b5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	85 d2                	test   %edx,%edx
801019bd:	74 07                	je     801019c6 <iput+0x26>
801019bf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019c4:	74 32                	je     801019f8 <iput+0x58>
  releasesleep(&ip->lock);
801019c6:	83 ec 0c             	sub    $0xc,%esp
801019c9:	57                   	push   %edi
801019ca:	e8 11 2b 00 00       	call   801044e0 <releasesleep>
  acquire(&icache.lock);
801019cf:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801019d6:	e8 85 2d 00 00       	call   80104760 <acquire>
  ip->ref--;
801019db:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019df:	83 c4 10             	add    $0x10,%esp
801019e2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801019e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ec:	5b                   	pop    %ebx
801019ed:	5e                   	pop    %esi
801019ee:	5f                   	pop    %edi
801019ef:	5d                   	pop    %ebp
  release(&icache.lock);
801019f0:	e9 0b 2d 00 00       	jmp    80104700 <release>
801019f5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019f8:	83 ec 0c             	sub    $0xc,%esp
801019fb:	68 60 09 11 80       	push   $0x80110960
80101a00:	e8 5b 2d 00 00       	call   80104760 <acquire>
    int r = ip->ref;
80101a05:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a08:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a0f:	e8 ec 2c 00 00       	call   80104700 <release>
    if(r == 1){
80101a14:	83 c4 10             	add    $0x10,%esp
80101a17:	83 fe 01             	cmp    $0x1,%esi
80101a1a:	75 aa                	jne    801019c6 <iput+0x26>
80101a1c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a22:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a25:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a28:	89 df                	mov    %ebx,%edi
80101a2a:	89 cb                	mov    %ecx,%ebx
80101a2c:	eb 09                	jmp    80101a37 <iput+0x97>
80101a2e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a30:	83 c6 04             	add    $0x4,%esi
80101a33:	39 de                	cmp    %ebx,%esi
80101a35:	74 19                	je     80101a50 <iput+0xb0>
    if(ip->addrs[i]){
80101a37:	8b 16                	mov    (%esi),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a3d:	8b 07                	mov    (%edi),%eax
80101a3f:	e8 7c fa ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
80101a44:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a4a:	eb e4                	jmp    80101a30 <iput+0x90>
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a50:	89 fb                	mov    %edi,%ebx
80101a52:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a55:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a5b:	85 c0                	test   %eax,%eax
80101a5d:	75 2d                	jne    80101a8c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a5f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a62:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a69:	53                   	push   %ebx
80101a6a:	e8 51 fd ff ff       	call   801017c0 <iupdate>
      ip->type = 0;
80101a6f:	31 c0                	xor    %eax,%eax
80101a71:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a75:	89 1c 24             	mov    %ebx,(%esp)
80101a78:	e8 43 fd ff ff       	call   801017c0 <iupdate>
      ip->valid = 0;
80101a7d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a84:	83 c4 10             	add    $0x10,%esp
80101a87:	e9 3a ff ff ff       	jmp    801019c6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a8c:	83 ec 08             	sub    $0x8,%esp
80101a8f:	50                   	push   %eax
80101a90:	ff 33                	push   (%ebx)
80101a92:	e8 39 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a97:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a9a:	83 c4 10             	add    $0x10,%esp
80101a9d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101aa3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101aa6:	8d 70 5c             	lea    0x5c(%eax),%esi
80101aa9:	89 cf                	mov    %ecx,%edi
80101aab:	eb 0a                	jmp    80101ab7 <iput+0x117>
80101aad:	8d 76 00             	lea    0x0(%esi),%esi
80101ab0:	83 c6 04             	add    $0x4,%esi
80101ab3:	39 fe                	cmp    %edi,%esi
80101ab5:	74 0f                	je     80101ac6 <iput+0x126>
      if(a[j])
80101ab7:	8b 16                	mov    (%esi),%edx
80101ab9:	85 d2                	test   %edx,%edx
80101abb:	74 f3                	je     80101ab0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101abd:	8b 03                	mov    (%ebx),%eax
80101abf:	e8 fc f9 ff ff       	call   801014c0 <bfree>
80101ac4:	eb ea                	jmp    80101ab0 <iput+0x110>
    brelse(bp);
80101ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ac9:	83 ec 0c             	sub    $0xc,%esp
80101acc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101acf:	50                   	push   %eax
80101ad0:	e8 1b e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ad5:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101adb:	8b 03                	mov    (%ebx),%eax
80101add:	e8 de f9 ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101ae2:	83 c4 10             	add    $0x10,%esp
80101ae5:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101aec:	00 00 00 
80101aef:	e9 6b ff ff ff       	jmp    80101a5f <iput+0xbf>
80101af4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101afb:	00 
80101afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b00 <iunlockput>:
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	56                   	push   %esi
80101b04:	53                   	push   %ebx
80101b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b08:	85 db                	test   %ebx,%ebx
80101b0a:	74 34                	je     80101b40 <iunlockput+0x40>
80101b0c:	83 ec 0c             	sub    $0xc,%esp
80101b0f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b12:	56                   	push   %esi
80101b13:	e8 08 2a 00 00       	call   80104520 <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 21                	je     80101b40 <iunlockput+0x40>
80101b1f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b22:	85 c0                	test   %eax,%eax
80101b24:	7e 1a                	jle    80101b40 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b26:	83 ec 0c             	sub    $0xc,%esp
80101b29:	56                   	push   %esi
80101b2a:	e8 b1 29 00 00       	call   801044e0 <releasesleep>
  iput(ip);
80101b2f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b32:	83 c4 10             	add    $0x10,%esp
}
80101b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b38:	5b                   	pop    %ebx
80101b39:	5e                   	pop    %esi
80101b3a:	5d                   	pop    %ebp
  iput(ip);
80101b3b:	e9 60 fe ff ff       	jmp    801019a0 <iput>
    panic("iunlock");
80101b40:	83 ec 0c             	sub    $0xc,%esp
80101b43:	68 40 7b 10 80       	push   $0x80107b40
80101b48:	e8 33 e8 ff ff       	call   80100380 <panic>
80101b4d:	8d 76 00             	lea    0x0(%esi),%esi

80101b50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	8b 55 08             	mov    0x8(%ebp),%edx
80101b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b59:	8b 0a                	mov    (%edx),%ecx
80101b5b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b5e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b61:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b64:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b68:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b6b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b6f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b73:	8b 52 58             	mov    0x58(%edx),%edx
80101b76:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b79:	5d                   	pop    %ebp
80101b7a:	c3                   	ret
80101b7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101b80 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	57                   	push   %edi
80101b84:	56                   	push   %esi
80101b85:	53                   	push   %ebx
80101b86:	83 ec 1c             	sub    $0x1c,%esp
80101b89:	8b 75 08             	mov    0x8(%ebp),%esi
80101b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b92:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101b97:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b9a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101ba0:	0f 84 aa 00 00 00    	je     80101c50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ba6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101ba9:	8b 56 58             	mov    0x58(%esi),%edx
80101bac:	39 fa                	cmp    %edi,%edx
80101bae:	0f 82 bd 00 00 00    	jb     80101c71 <readi+0xf1>
80101bb4:	89 f9                	mov    %edi,%ecx
80101bb6:	31 db                	xor    %ebx,%ebx
80101bb8:	01 c1                	add    %eax,%ecx
80101bba:	0f 92 c3             	setb   %bl
80101bbd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101bc0:	0f 82 ab 00 00 00    	jb     80101c71 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101bc6:	89 d3                	mov    %edx,%ebx
80101bc8:	29 fb                	sub    %edi,%ebx
80101bca:	39 ca                	cmp    %ecx,%edx
80101bcc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bcf:	85 c0                	test   %eax,%eax
80101bd1:	74 73                	je     80101c46 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101bd3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101bd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101be3:	89 fa                	mov    %edi,%edx
80101be5:	c1 ea 09             	shr    $0x9,%edx
80101be8:	89 d8                	mov    %ebx,%eax
80101bea:	e8 51 f9 ff ff       	call   80101540 <bmap>
80101bef:	83 ec 08             	sub    $0x8,%esp
80101bf2:	50                   	push   %eax
80101bf3:	ff 33                	push   (%ebx)
80101bf5:	e8 d6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bfa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bfd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c02:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c04:	89 f8                	mov    %edi,%eax
80101c06:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c0b:	29 f3                	sub    %esi,%ebx
80101c0d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c0f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c13:	39 d9                	cmp    %ebx,%ecx
80101c15:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c18:	83 c4 0c             	add    $0xc,%esp
80101c1b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c1c:	01 de                	add    %ebx,%esi
80101c1e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101c20:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101c23:	50                   	push   %eax
80101c24:	ff 75 e0             	push   -0x20(%ebp)
80101c27:	e8 c4 2c 00 00       	call   801048f0 <memmove>
    brelse(bp);
80101c2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c2f:	89 14 24             	mov    %edx,(%esp)
80101c32:	e8 b9 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c37:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c3a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c3d:	83 c4 10             	add    $0x10,%esp
80101c40:	39 de                	cmp    %ebx,%esi
80101c42:	72 9c                	jb     80101be0 <readi+0x60>
80101c44:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101c46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c49:	5b                   	pop    %ebx
80101c4a:	5e                   	pop    %esi
80101c4b:	5f                   	pop    %edi
80101c4c:	5d                   	pop    %ebp
80101c4d:	c3                   	ret
80101c4e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c50:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101c54:	66 83 fa 09          	cmp    $0x9,%dx
80101c58:	77 17                	ja     80101c71 <readi+0xf1>
80101c5a:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80101c61:	85 d2                	test   %edx,%edx
80101c63:	74 0c                	je     80101c71 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c65:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c6f:	ff e2                	jmp    *%edx
      return -1;
80101c71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c76:	eb ce                	jmp    80101c46 <readi+0xc6>
80101c78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101c7f:	00 

80101c80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	56                   	push   %esi
80101c85:	53                   	push   %ebx
80101c86:	83 ec 1c             	sub    $0x1c,%esp
80101c89:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c8f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c97:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101c9a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c9d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101ca0:	0f 84 ba 00 00 00    	je     80101d60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ca6:	39 78 58             	cmp    %edi,0x58(%eax)
80101ca9:	0f 82 ea 00 00 00    	jb     80101d99 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101caf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101cb2:	89 f2                	mov    %esi,%edx
80101cb4:	01 fa                	add    %edi,%edx
80101cb6:	0f 82 dd 00 00 00    	jb     80101d99 <writei+0x119>
80101cbc:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101cc2:	0f 87 d1 00 00 00    	ja     80101d99 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cc8:	85 f6                	test   %esi,%esi
80101cca:	0f 84 85 00 00 00    	je     80101d55 <writei+0xd5>
80101cd0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101cd7:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ce0:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101ce3:	89 fa                	mov    %edi,%edx
80101ce5:	c1 ea 09             	shr    $0x9,%edx
80101ce8:	89 f0                	mov    %esi,%eax
80101cea:	e8 51 f8 ff ff       	call   80101540 <bmap>
80101cef:	83 ec 08             	sub    $0x8,%esp
80101cf2:	50                   	push   %eax
80101cf3:	ff 36                	push   (%esi)
80101cf5:	e8 d6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101cfd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d00:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d05:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d07:	89 f8                	mov    %edi,%eax
80101d09:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d0e:	29 d3                	sub    %edx,%ebx
80101d10:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d12:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d16:	39 d9                	cmp    %ebx,%ecx
80101d18:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d1b:	83 c4 0c             	add    $0xc,%esp
80101d1e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d1f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101d21:	ff 75 dc             	push   -0x24(%ebp)
80101d24:	50                   	push   %eax
80101d25:	e8 c6 2b 00 00       	call   801048f0 <memmove>
    log_write(bp);
80101d2a:	89 34 24             	mov    %esi,(%esp)
80101d2d:	e8 be 12 00 00       	call   80102ff0 <log_write>
    brelse(bp);
80101d32:	89 34 24             	mov    %esi,(%esp)
80101d35:	e8 b6 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d3a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d40:	83 c4 10             	add    $0x10,%esp
80101d43:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d46:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d49:	39 d8                	cmp    %ebx,%eax
80101d4b:	72 93                	jb     80101ce0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d50:	39 78 58             	cmp    %edi,0x58(%eax)
80101d53:	72 33                	jb     80101d88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d5b:	5b                   	pop    %ebx
80101d5c:	5e                   	pop    %esi
80101d5d:	5f                   	pop    %edi
80101d5e:	5d                   	pop    %ebp
80101d5f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d64:	66 83 f8 09          	cmp    $0x9,%ax
80101d68:	77 2f                	ja     80101d99 <writei+0x119>
80101d6a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101d71:	85 c0                	test   %eax,%eax
80101d73:	74 24                	je     80101d99 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101d75:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7b:	5b                   	pop    %ebx
80101d7c:	5e                   	pop    %esi
80101d7d:	5f                   	pop    %edi
80101d7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d7f:	ff e0                	jmp    *%eax
80101d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d88:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d8b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101d8e:	50                   	push   %eax
80101d8f:	e8 2c fa ff ff       	call   801017c0 <iupdate>
80101d94:	83 c4 10             	add    $0x10,%esp
80101d97:	eb bc                	jmp    80101d55 <writei+0xd5>
      return -1;
80101d99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d9e:	eb b8                	jmp    80101d58 <writei+0xd8>

80101da0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101da6:	6a 0e                	push   $0xe
80101da8:	ff 75 0c             	push   0xc(%ebp)
80101dab:	ff 75 08             	push   0x8(%ebp)
80101dae:	e8 ad 2b 00 00       	call   80104960 <strncmp>
}
80101db3:	c9                   	leave
80101db4:	c3                   	ret
80101db5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101dbc:	00 
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi

80101dc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101dc0:	55                   	push   %ebp
80101dc1:	89 e5                	mov    %esp,%ebp
80101dc3:	57                   	push   %edi
80101dc4:	56                   	push   %esi
80101dc5:	53                   	push   %ebx
80101dc6:	83 ec 1c             	sub    $0x1c,%esp
80101dc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101dd1:	0f 85 85 00 00 00    	jne    80101e5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101dd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101dda:	31 ff                	xor    %edi,%edi
80101ddc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ddf:	85 d2                	test   %edx,%edx
80101de1:	74 3e                	je     80101e21 <dirlookup+0x61>
80101de3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101de8:	6a 10                	push   $0x10
80101dea:	57                   	push   %edi
80101deb:	56                   	push   %esi
80101dec:	53                   	push   %ebx
80101ded:	e8 8e fd ff ff       	call   80101b80 <readi>
80101df2:	83 c4 10             	add    $0x10,%esp
80101df5:	83 f8 10             	cmp    $0x10,%eax
80101df8:	75 55                	jne    80101e4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101dfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101dff:	74 18                	je     80101e19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e01:	83 ec 04             	sub    $0x4,%esp
80101e04:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e07:	6a 0e                	push   $0xe
80101e09:	50                   	push   %eax
80101e0a:	ff 75 0c             	push   0xc(%ebp)
80101e0d:	e8 4e 2b 00 00       	call   80104960 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e12:	83 c4 10             	add    $0x10,%esp
80101e15:	85 c0                	test   %eax,%eax
80101e17:	74 17                	je     80101e30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e19:	83 c7 10             	add    $0x10,%edi
80101e1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e1f:	72 c7                	jb     80101de8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e24:	31 c0                	xor    %eax,%eax
}
80101e26:	5b                   	pop    %ebx
80101e27:	5e                   	pop    %esi
80101e28:	5f                   	pop    %edi
80101e29:	5d                   	pop    %ebp
80101e2a:	c3                   	ret
80101e2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101e30:	8b 45 10             	mov    0x10(%ebp),%eax
80101e33:	85 c0                	test   %eax,%eax
80101e35:	74 05                	je     80101e3c <dirlookup+0x7c>
        *poff = off;
80101e37:	8b 45 10             	mov    0x10(%ebp),%eax
80101e3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e40:	8b 03                	mov    (%ebx),%eax
80101e42:	e8 79 f5 ff ff       	call   801013c0 <iget>
}
80101e47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e4a:	5b                   	pop    %ebx
80101e4b:	5e                   	pop    %esi
80101e4c:	5f                   	pop    %edi
80101e4d:	5d                   	pop    %ebp
80101e4e:	c3                   	ret
      panic("dirlookup read");
80101e4f:	83 ec 0c             	sub    $0xc,%esp
80101e52:	68 5a 7b 10 80       	push   $0x80107b5a
80101e57:	e8 24 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101e5c:	83 ec 0c             	sub    $0xc,%esp
80101e5f:	68 48 7b 10 80       	push   $0x80107b48
80101e64:	e8 17 e5 ff ff       	call   80100380 <panic>
80101e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	57                   	push   %edi
80101e74:	56                   	push   %esi
80101e75:	53                   	push   %ebx
80101e76:	89 c3                	mov    %eax,%ebx
80101e78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e7e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e84:	0f 84 9e 01 00 00    	je     80102028 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e8a:	e8 21 1c 00 00       	call   80103ab0 <myproc>
  acquire(&icache.lock);
80101e8f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e92:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e95:	68 60 09 11 80       	push   $0x80110960
80101e9a:	e8 c1 28 00 00       	call   80104760 <acquire>
  ip->ref++;
80101e9f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ea3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101eaa:	e8 51 28 00 00       	call   80104700 <release>
80101eaf:	83 c4 10             	add    $0x10,%esp
80101eb2:	eb 07                	jmp    80101ebb <namex+0x4b>
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101eb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ebb:	0f b6 03             	movzbl (%ebx),%eax
80101ebe:	3c 2f                	cmp    $0x2f,%al
80101ec0:	74 f6                	je     80101eb8 <namex+0x48>
  if(*path == 0)
80101ec2:	84 c0                	test   %al,%al
80101ec4:	0f 84 06 01 00 00    	je     80101fd0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101eca:	0f b6 03             	movzbl (%ebx),%eax
80101ecd:	84 c0                	test   %al,%al
80101ecf:	0f 84 10 01 00 00    	je     80101fe5 <namex+0x175>
80101ed5:	89 df                	mov    %ebx,%edi
80101ed7:	3c 2f                	cmp    $0x2f,%al
80101ed9:	0f 84 06 01 00 00    	je     80101fe5 <namex+0x175>
80101edf:	90                   	nop
80101ee0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101ee4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101ee7:	3c 2f                	cmp    $0x2f,%al
80101ee9:	74 04                	je     80101eef <namex+0x7f>
80101eeb:	84 c0                	test   %al,%al
80101eed:	75 f1                	jne    80101ee0 <namex+0x70>
  len = path - s;
80101eef:	89 f8                	mov    %edi,%eax
80101ef1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101ef3:	83 f8 0d             	cmp    $0xd,%eax
80101ef6:	0f 8e ac 00 00 00    	jle    80101fa8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101efc:	83 ec 04             	sub    $0x4,%esp
80101eff:	6a 0e                	push   $0xe
80101f01:	53                   	push   %ebx
80101f02:	89 fb                	mov    %edi,%ebx
80101f04:	ff 75 e4             	push   -0x1c(%ebp)
80101f07:	e8 e4 29 00 00       	call   801048f0 <memmove>
80101f0c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f0f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f12:	75 0c                	jne    80101f20 <namex+0xb0>
80101f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f18:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f1b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f1e:	74 f8                	je     80101f18 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f20:	83 ec 0c             	sub    $0xc,%esp
80101f23:	56                   	push   %esi
80101f24:	e8 47 f9 ff ff       	call   80101870 <ilock>
    if(ip->type != T_DIR){
80101f29:	83 c4 10             	add    $0x10,%esp
80101f2c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f31:	0f 85 b7 00 00 00    	jne    80101fee <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f37:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f3a:	85 c0                	test   %eax,%eax
80101f3c:	74 09                	je     80101f47 <namex+0xd7>
80101f3e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f41:	0f 84 f7 00 00 00    	je     8010203e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f47:	83 ec 04             	sub    $0x4,%esp
80101f4a:	6a 00                	push   $0x0
80101f4c:	ff 75 e4             	push   -0x1c(%ebp)
80101f4f:	56                   	push   %esi
80101f50:	e8 6b fe ff ff       	call   80101dc0 <dirlookup>
80101f55:	83 c4 10             	add    $0x10,%esp
80101f58:	89 c7                	mov    %eax,%edi
80101f5a:	85 c0                	test   %eax,%eax
80101f5c:	0f 84 8c 00 00 00    	je     80101fee <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f62:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101f65:	83 ec 0c             	sub    $0xc,%esp
80101f68:	51                   	push   %ecx
80101f69:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f6c:	e8 af 25 00 00       	call   80104520 <holdingsleep>
80101f71:	83 c4 10             	add    $0x10,%esp
80101f74:	85 c0                	test   %eax,%eax
80101f76:	0f 84 02 01 00 00    	je     8010207e <namex+0x20e>
80101f7c:	8b 56 08             	mov    0x8(%esi),%edx
80101f7f:	85 d2                	test   %edx,%edx
80101f81:	0f 8e f7 00 00 00    	jle    8010207e <namex+0x20e>
  releasesleep(&ip->lock);
80101f87:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f8a:	83 ec 0c             	sub    $0xc,%esp
80101f8d:	51                   	push   %ecx
80101f8e:	e8 4d 25 00 00       	call   801044e0 <releasesleep>
  iput(ip);
80101f93:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101f96:	89 fe                	mov    %edi,%esi
  iput(ip);
80101f98:	e8 03 fa ff ff       	call   801019a0 <iput>
80101f9d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101fa0:	e9 16 ff ff ff       	jmp    80101ebb <namex+0x4b>
80101fa5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101fa8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101fae:	83 ec 04             	sub    $0x4,%esp
80101fb1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101fb4:	50                   	push   %eax
80101fb5:	53                   	push   %ebx
    name[len] = 0;
80101fb6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101fb8:	ff 75 e4             	push   -0x1c(%ebp)
80101fbb:	e8 30 29 00 00       	call   801048f0 <memmove>
    name[len] = 0;
80101fc0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101fc3:	83 c4 10             	add    $0x10,%esp
80101fc6:	c6 01 00             	movb   $0x0,(%ecx)
80101fc9:	e9 41 ff ff ff       	jmp    80101f0f <namex+0x9f>
80101fce:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101fd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101fd3:	85 c0                	test   %eax,%eax
80101fd5:	0f 85 93 00 00 00    	jne    8010206e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fde:	89 f0                	mov    %esi,%eax
80101fe0:	5b                   	pop    %ebx
80101fe1:	5e                   	pop    %esi
80101fe2:	5f                   	pop    %edi
80101fe3:	5d                   	pop    %ebp
80101fe4:	c3                   	ret
  while(*path != '/' && *path != 0)
80101fe5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101fe8:	89 df                	mov    %ebx,%edi
80101fea:	31 c0                	xor    %eax,%eax
80101fec:	eb c0                	jmp    80101fae <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fee:	83 ec 0c             	sub    $0xc,%esp
80101ff1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101ff4:	53                   	push   %ebx
80101ff5:	e8 26 25 00 00       	call   80104520 <holdingsleep>
80101ffa:	83 c4 10             	add    $0x10,%esp
80101ffd:	85 c0                	test   %eax,%eax
80101fff:	74 7d                	je     8010207e <namex+0x20e>
80102001:	8b 4e 08             	mov    0x8(%esi),%ecx
80102004:	85 c9                	test   %ecx,%ecx
80102006:	7e 76                	jle    8010207e <namex+0x20e>
  releasesleep(&ip->lock);
80102008:	83 ec 0c             	sub    $0xc,%esp
8010200b:	53                   	push   %ebx
8010200c:	e8 cf 24 00 00       	call   801044e0 <releasesleep>
  iput(ip);
80102011:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102014:	31 f6                	xor    %esi,%esi
  iput(ip);
80102016:	e8 85 f9 ff ff       	call   801019a0 <iput>
      return 0;
8010201b:	83 c4 10             	add    $0x10,%esp
}
8010201e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102021:	89 f0                	mov    %esi,%eax
80102023:	5b                   	pop    %ebx
80102024:	5e                   	pop    %esi
80102025:	5f                   	pop    %edi
80102026:	5d                   	pop    %ebp
80102027:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80102028:	ba 01 00 00 00       	mov    $0x1,%edx
8010202d:	b8 01 00 00 00       	mov    $0x1,%eax
80102032:	e8 89 f3 ff ff       	call   801013c0 <iget>
80102037:	89 c6                	mov    %eax,%esi
80102039:	e9 7d fe ff ff       	jmp    80101ebb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010203e:	83 ec 0c             	sub    $0xc,%esp
80102041:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102044:	53                   	push   %ebx
80102045:	e8 d6 24 00 00       	call   80104520 <holdingsleep>
8010204a:	83 c4 10             	add    $0x10,%esp
8010204d:	85 c0                	test   %eax,%eax
8010204f:	74 2d                	je     8010207e <namex+0x20e>
80102051:	8b 7e 08             	mov    0x8(%esi),%edi
80102054:	85 ff                	test   %edi,%edi
80102056:	7e 26                	jle    8010207e <namex+0x20e>
  releasesleep(&ip->lock);
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	53                   	push   %ebx
8010205c:	e8 7f 24 00 00       	call   801044e0 <releasesleep>
}
80102061:	83 c4 10             	add    $0x10,%esp
}
80102064:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102067:	89 f0                	mov    %esi,%eax
80102069:	5b                   	pop    %ebx
8010206a:	5e                   	pop    %esi
8010206b:	5f                   	pop    %edi
8010206c:	5d                   	pop    %ebp
8010206d:	c3                   	ret
    iput(ip);
8010206e:	83 ec 0c             	sub    $0xc,%esp
80102071:	56                   	push   %esi
      return 0;
80102072:	31 f6                	xor    %esi,%esi
    iput(ip);
80102074:	e8 27 f9 ff ff       	call   801019a0 <iput>
    return 0;
80102079:	83 c4 10             	add    $0x10,%esp
8010207c:	eb a0                	jmp    8010201e <namex+0x1ae>
    panic("iunlock");
8010207e:	83 ec 0c             	sub    $0xc,%esp
80102081:	68 40 7b 10 80       	push   $0x80107b40
80102086:	e8 f5 e2 ff ff       	call   80100380 <panic>
8010208b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102090 <dirlink>:
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 20             	sub    $0x20,%esp
80102099:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010209c:	6a 00                	push   $0x0
8010209e:	ff 75 0c             	push   0xc(%ebp)
801020a1:	53                   	push   %ebx
801020a2:	e8 19 fd ff ff       	call   80101dc0 <dirlookup>
801020a7:	83 c4 10             	add    $0x10,%esp
801020aa:	85 c0                	test   %eax,%eax
801020ac:	75 67                	jne    80102115 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020ae:	8b 7b 58             	mov    0x58(%ebx),%edi
801020b1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020b4:	85 ff                	test   %edi,%edi
801020b6:	74 29                	je     801020e1 <dirlink+0x51>
801020b8:	31 ff                	xor    %edi,%edi
801020ba:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020bd:	eb 09                	jmp    801020c8 <dirlink+0x38>
801020bf:	90                   	nop
801020c0:	83 c7 10             	add    $0x10,%edi
801020c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801020c6:	73 19                	jae    801020e1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020c8:	6a 10                	push   $0x10
801020ca:	57                   	push   %edi
801020cb:	56                   	push   %esi
801020cc:	53                   	push   %ebx
801020cd:	e8 ae fa ff ff       	call   80101b80 <readi>
801020d2:	83 c4 10             	add    $0x10,%esp
801020d5:	83 f8 10             	cmp    $0x10,%eax
801020d8:	75 4e                	jne    80102128 <dirlink+0x98>
    if(de.inum == 0)
801020da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020df:	75 df                	jne    801020c0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801020e1:	83 ec 04             	sub    $0x4,%esp
801020e4:	8d 45 da             	lea    -0x26(%ebp),%eax
801020e7:	6a 0e                	push   $0xe
801020e9:	ff 75 0c             	push   0xc(%ebp)
801020ec:	50                   	push   %eax
801020ed:	e8 be 28 00 00       	call   801049b0 <strncpy>
  de.inum = inum;
801020f2:	8b 45 10             	mov    0x10(%ebp),%eax
801020f5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020f9:	6a 10                	push   $0x10
801020fb:	57                   	push   %edi
801020fc:	56                   	push   %esi
801020fd:	53                   	push   %ebx
801020fe:	e8 7d fb ff ff       	call   80101c80 <writei>
80102103:	83 c4 20             	add    $0x20,%esp
80102106:	83 f8 10             	cmp    $0x10,%eax
80102109:	75 2a                	jne    80102135 <dirlink+0xa5>
  return 0;
8010210b:	31 c0                	xor    %eax,%eax
}
8010210d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102110:	5b                   	pop    %ebx
80102111:	5e                   	pop    %esi
80102112:	5f                   	pop    %edi
80102113:	5d                   	pop    %ebp
80102114:	c3                   	ret
    iput(ip);
80102115:	83 ec 0c             	sub    $0xc,%esp
80102118:	50                   	push   %eax
80102119:	e8 82 f8 ff ff       	call   801019a0 <iput>
    return -1;
8010211e:	83 c4 10             	add    $0x10,%esp
80102121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102126:	eb e5                	jmp    8010210d <dirlink+0x7d>
      panic("dirlink read");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 69 7b 10 80       	push   $0x80107b69
80102130:	e8 4b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 f3 7d 10 80       	push   $0x80107df3
8010213d:	e8 3e e2 ff ff       	call   80100380 <panic>
80102142:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102149:	00 
8010214a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102150 <namei>:

struct inode*
namei(char *path)
{
80102150:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102151:	31 d2                	xor    %edx,%edx
{
80102153:	89 e5                	mov    %esp,%ebp
80102155:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102158:	8b 45 08             	mov    0x8(%ebp),%eax
8010215b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010215e:	e8 0d fd ff ff       	call   80101e70 <namex>
}
80102163:	c9                   	leave
80102164:	c3                   	ret
80102165:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010216c:	00 
8010216d:	8d 76 00             	lea    0x0(%esi),%esi

80102170 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102170:	55                   	push   %ebp
  return namex(path, 1, name);
80102171:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102176:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102178:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010217b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010217e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010217f:	e9 ec fc ff ff       	jmp    80101e70 <namex>
80102184:	66 90                	xchg   %ax,%ax
80102186:	66 90                	xchg   %ax,%ax
80102188:	66 90                	xchg   %ax,%ax
8010218a:	66 90                	xchg   %ax,%ax
8010218c:	66 90                	xchg   %ax,%ax
8010218e:	66 90                	xchg   %ax,%ax

80102190 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	57                   	push   %edi
80102194:	56                   	push   %esi
80102195:	53                   	push   %ebx
80102196:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102199:	85 c0                	test   %eax,%eax
8010219b:	0f 84 b4 00 00 00    	je     80102255 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021a1:	8b 70 08             	mov    0x8(%eax),%esi
801021a4:	89 c3                	mov    %eax,%ebx
801021a6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801021ac:	0f 87 96 00 00 00    	ja     80102248 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021be:	00 
801021bf:	90                   	nop
801021c0:	89 ca                	mov    %ecx,%edx
801021c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021c3:	83 e0 c0             	and    $0xffffffc0,%eax
801021c6:	3c 40                	cmp    $0x40,%al
801021c8:	75 f6                	jne    801021c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021ca:	31 ff                	xor    %edi,%edi
801021cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021d1:	89 f8                	mov    %edi,%eax
801021d3:	ee                   	out    %al,(%dx)
801021d4:	b8 01 00 00 00       	mov    $0x1,%eax
801021d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021de:	ee                   	out    %al,(%dx)
801021df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021e4:	89 f0                	mov    %esi,%eax
801021e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021e7:	89 f0                	mov    %esi,%eax
801021e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021ee:	c1 f8 08             	sar    $0x8,%eax
801021f1:	ee                   	out    %al,(%dx)
801021f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021f7:	89 f8                	mov    %edi,%eax
801021f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021fa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102203:	c1 e0 04             	shl    $0x4,%eax
80102206:	83 e0 10             	and    $0x10,%eax
80102209:	83 c8 e0             	or     $0xffffffe0,%eax
8010220c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010220d:	f6 03 04             	testb  $0x4,(%ebx)
80102210:	75 16                	jne    80102228 <idestart+0x98>
80102212:	b8 20 00 00 00       	mov    $0x20,%eax
80102217:	89 ca                	mov    %ecx,%edx
80102219:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010221a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010221d:	5b                   	pop    %ebx
8010221e:	5e                   	pop    %esi
8010221f:	5f                   	pop    %edi
80102220:	5d                   	pop    %ebp
80102221:	c3                   	ret
80102222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102228:	b8 30 00 00 00       	mov    $0x30,%eax
8010222d:	89 ca                	mov    %ecx,%edx
8010222f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102230:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102235:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102238:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223d:	fc                   	cld
8010223e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102240:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102243:	5b                   	pop    %ebx
80102244:	5e                   	pop    %esi
80102245:	5f                   	pop    %edi
80102246:	5d                   	pop    %ebp
80102247:	c3                   	ret
    panic("incorrect blockno");
80102248:	83 ec 0c             	sub    $0xc,%esp
8010224b:	68 7f 7b 10 80       	push   $0x80107b7f
80102250:	e8 2b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102255:	83 ec 0c             	sub    $0xc,%esp
80102258:	68 76 7b 10 80       	push   $0x80107b76
8010225d:	e8 1e e1 ff ff       	call   80100380 <panic>
80102262:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102269:	00 
8010226a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102270 <ideinit>:
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102276:	68 91 7b 10 80       	push   $0x80107b91
8010227b:	68 00 26 11 80       	push   $0x80112600
80102280:	e8 eb 22 00 00       	call   80104570 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102285:	58                   	pop    %eax
80102286:	a1 c4 30 11 80       	mov    0x801130c4,%eax
8010228b:	5a                   	pop    %edx
8010228c:	83 e8 01             	sub    $0x1,%eax
8010228f:	50                   	push   %eax
80102290:	6a 0e                	push   $0xe
80102292:	e8 99 02 00 00       	call   80102530 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102297:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010229a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010229f:	90                   	nop
801022a0:	89 ca                	mov    %ecx,%edx
801022a2:	ec                   	in     (%dx),%al
801022a3:	83 e0 c0             	and    $0xffffffc0,%eax
801022a6:	3c 40                	cmp    $0x40,%al
801022a8:	75 f6                	jne    801022a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022aa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022af:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022b4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b5:	89 ca                	mov    %ecx,%edx
801022b7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022b8:	84 c0                	test   %al,%al
801022ba:	75 1e                	jne    801022da <ideinit+0x6a>
801022bc:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801022c1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022cd:	00 
801022ce:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801022d0:	83 e9 01             	sub    $0x1,%ecx
801022d3:	74 0f                	je     801022e4 <ideinit+0x74>
801022d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022d6:	84 c0                	test   %al,%al
801022d8:	74 f6                	je     801022d0 <ideinit+0x60>
      havedisk1 = 1;
801022da:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
801022e1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022e4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022e9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022ee:	ee                   	out    %al,(%dx)
}
801022ef:	c9                   	leave
801022f0:	c3                   	ret
801022f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022f8:	00 
801022f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102300 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	57                   	push   %edi
80102304:	56                   	push   %esi
80102305:	53                   	push   %ebx
80102306:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102309:	68 00 26 11 80       	push   $0x80112600
8010230e:	e8 4d 24 00 00       	call   80104760 <acquire>

  if((b = idequeue) == 0){
80102313:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102319:	83 c4 10             	add    $0x10,%esp
8010231c:	85 db                	test   %ebx,%ebx
8010231e:	74 63                	je     80102383 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102320:	8b 43 58             	mov    0x58(%ebx),%eax
80102323:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102328:	8b 33                	mov    (%ebx),%esi
8010232a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102330:	75 2f                	jne    80102361 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102332:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102337:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010233e:	00 
8010233f:	90                   	nop
80102340:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102341:	89 c1                	mov    %eax,%ecx
80102343:	83 e1 c0             	and    $0xffffffc0,%ecx
80102346:	80 f9 40             	cmp    $0x40,%cl
80102349:	75 f5                	jne    80102340 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010234b:	a8 21                	test   $0x21,%al
8010234d:	75 12                	jne    80102361 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010234f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102352:	b9 80 00 00 00       	mov    $0x80,%ecx
80102357:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010235c:	fc                   	cld
8010235d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010235f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102361:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102364:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102367:	83 ce 02             	or     $0x2,%esi
8010236a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010236c:	53                   	push   %ebx
8010236d:	e8 8e 1f 00 00       	call   80104300 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102372:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102377:	83 c4 10             	add    $0x10,%esp
8010237a:	85 c0                	test   %eax,%eax
8010237c:	74 05                	je     80102383 <ideintr+0x83>
    idestart(idequeue);
8010237e:	e8 0d fe ff ff       	call   80102190 <idestart>
    release(&idelock);
80102383:	83 ec 0c             	sub    $0xc,%esp
80102386:	68 00 26 11 80       	push   $0x80112600
8010238b:	e8 70 23 00 00       	call   80104700 <release>

  release(&idelock);
}
80102390:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102393:	5b                   	pop    %ebx
80102394:	5e                   	pop    %esi
80102395:	5f                   	pop    %edi
80102396:	5d                   	pop    %ebp
80102397:	c3                   	ret
80102398:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010239f:	00 

801023a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	53                   	push   %ebx
801023a4:	83 ec 10             	sub    $0x10,%esp
801023a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801023ad:	50                   	push   %eax
801023ae:	e8 6d 21 00 00       	call   80104520 <holdingsleep>
801023b3:	83 c4 10             	add    $0x10,%esp
801023b6:	85 c0                	test   %eax,%eax
801023b8:	0f 84 c3 00 00 00    	je     80102481 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023be:	8b 03                	mov    (%ebx),%eax
801023c0:	83 e0 06             	and    $0x6,%eax
801023c3:	83 f8 02             	cmp    $0x2,%eax
801023c6:	0f 84 a8 00 00 00    	je     80102474 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023cc:	8b 53 04             	mov    0x4(%ebx),%edx
801023cf:	85 d2                	test   %edx,%edx
801023d1:	74 0d                	je     801023e0 <iderw+0x40>
801023d3:	a1 e0 25 11 80       	mov    0x801125e0,%eax
801023d8:	85 c0                	test   %eax,%eax
801023da:	0f 84 87 00 00 00    	je     80102467 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023e0:	83 ec 0c             	sub    $0xc,%esp
801023e3:	68 00 26 11 80       	push   $0x80112600
801023e8:	e8 73 23 00 00       	call   80104760 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023ed:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
801023f2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023f9:	83 c4 10             	add    $0x10,%esp
801023fc:	85 c0                	test   %eax,%eax
801023fe:	74 60                	je     80102460 <iderw+0xc0>
80102400:	89 c2                	mov    %eax,%edx
80102402:	8b 40 58             	mov    0x58(%eax),%eax
80102405:	85 c0                	test   %eax,%eax
80102407:	75 f7                	jne    80102400 <iderw+0x60>
80102409:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010240c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010240e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102414:	74 3a                	je     80102450 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102416:	8b 03                	mov    (%ebx),%eax
80102418:	83 e0 06             	and    $0x6,%eax
8010241b:	83 f8 02             	cmp    $0x2,%eax
8010241e:	74 1b                	je     8010243b <iderw+0x9b>
    sleep(b, &idelock);
80102420:	83 ec 08             	sub    $0x8,%esp
80102423:	68 00 26 11 80       	push   $0x80112600
80102428:	53                   	push   %ebx
80102429:	e8 12 1e 00 00       	call   80104240 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010242e:	8b 03                	mov    (%ebx),%eax
80102430:	83 c4 10             	add    $0x10,%esp
80102433:	83 e0 06             	and    $0x6,%eax
80102436:	83 f8 02             	cmp    $0x2,%eax
80102439:	75 e5                	jne    80102420 <iderw+0x80>
  }


  release(&idelock);
8010243b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102442:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102445:	c9                   	leave
  release(&idelock);
80102446:	e9 b5 22 00 00       	jmp    80104700 <release>
8010244b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102450:	89 d8                	mov    %ebx,%eax
80102452:	e8 39 fd ff ff       	call   80102190 <idestart>
80102457:	eb bd                	jmp    80102416 <iderw+0x76>
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102460:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102465:	eb a5                	jmp    8010240c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102467:	83 ec 0c             	sub    $0xc,%esp
8010246a:	68 c0 7b 10 80       	push   $0x80107bc0
8010246f:	e8 0c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	68 ab 7b 10 80       	push   $0x80107bab
8010247c:	e8 ff de ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102481:	83 ec 0c             	sub    $0xc,%esp
80102484:	68 95 7b 10 80       	push   $0x80107b95
80102489:	e8 f2 de ff ff       	call   80100380 <panic>
8010248e:	66 90                	xchg   %ax,%ax

80102490 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
80102494:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102495:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010249c:	00 c0 fe 
  ioapic->reg = reg;
8010249f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024a6:	00 00 00 
  return ioapic->data;
801024a9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801024af:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024b2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024b8:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024be:	0f b6 15 c0 30 11 80 	movzbl 0x801130c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024c5:	c1 ee 10             	shr    $0x10,%esi
801024c8:	89 f0                	mov    %esi,%eax
801024ca:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801024cd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
801024d0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024d3:	39 c2                	cmp    %eax,%edx
801024d5:	74 16                	je     801024ed <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024d7:	83 ec 0c             	sub    $0xc,%esp
801024da:	68 18 80 10 80       	push   $0x80108018
801024df:	e8 cc e1 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
801024e4:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801024ea:	83 c4 10             	add    $0x10,%esp
{
801024ed:	ba 10 00 00 00       	mov    $0x10,%edx
801024f2:	31 c0                	xor    %eax,%eax
801024f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
801024f8:	89 13                	mov    %edx,(%ebx)
801024fa:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801024fd:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102503:	83 c0 01             	add    $0x1,%eax
80102506:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010250c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010250f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102512:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102515:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102517:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010251d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102524:	39 c6                	cmp    %eax,%esi
80102526:	7d d0                	jge    801024f8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102528:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010252b:	5b                   	pop    %ebx
8010252c:	5e                   	pop    %esi
8010252d:	5d                   	pop    %ebp
8010252e:	c3                   	ret
8010252f:	90                   	nop

80102530 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102530:	55                   	push   %ebp
  ioapic->reg = reg;
80102531:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102537:	89 e5                	mov    %esp,%ebp
80102539:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010253c:	8d 50 20             	lea    0x20(%eax),%edx
8010253f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102543:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102545:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010254b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010254e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102551:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102554:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102556:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010255b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010255e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102561:	5d                   	pop    %ebp
80102562:	c3                   	ret
80102563:	66 90                	xchg   %ax,%ax
80102565:	66 90                	xchg   %ax,%ax
80102567:	66 90                	xchg   %ax,%ax
80102569:	66 90                	xchg   %ax,%ax
8010256b:	66 90                	xchg   %ax,%ax
8010256d:	66 90                	xchg   %ax,%ax
8010256f:	90                   	nop

80102570 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	53                   	push   %ebx
80102574:	83 ec 04             	sub    $0x4,%esp
80102577:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010257a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102580:	75 76                	jne    801025f8 <kfree+0x88>
80102582:	81 fb 10 8f 11 80    	cmp    $0x80118f10,%ebx
80102588:	72 6e                	jb     801025f8 <kfree+0x88>
8010258a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102590:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102595:	77 61                	ja     801025f8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102597:	83 ec 04             	sub    $0x4,%esp
8010259a:	68 00 10 00 00       	push   $0x1000
8010259f:	6a 01                	push   $0x1
801025a1:	53                   	push   %ebx
801025a2:	e8 b9 22 00 00       	call   80104860 <memset>

  if(kmem.use_lock)
801025a7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	85 d2                	test   %edx,%edx
801025b2:	75 1c                	jne    801025d0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801025b4:	a1 78 26 11 80       	mov    0x80112678,%eax
801025b9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801025bb:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801025c0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801025c6:	85 c0                	test   %eax,%eax
801025c8:	75 1e                	jne    801025e8 <kfree+0x78>
    release(&kmem.lock);
}
801025ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025cd:	c9                   	leave
801025ce:	c3                   	ret
801025cf:	90                   	nop
    acquire(&kmem.lock);
801025d0:	83 ec 0c             	sub    $0xc,%esp
801025d3:	68 40 26 11 80       	push   $0x80112640
801025d8:	e8 83 21 00 00       	call   80104760 <acquire>
801025dd:	83 c4 10             	add    $0x10,%esp
801025e0:	eb d2                	jmp    801025b4 <kfree+0x44>
801025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801025e8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801025ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025f2:	c9                   	leave
    release(&kmem.lock);
801025f3:	e9 08 21 00 00       	jmp    80104700 <release>
    panic("kfree");
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	68 de 7b 10 80       	push   $0x80107bde
80102600:	e8 7b dd ff ff       	call   80100380 <panic>
80102605:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010260c:	00 
8010260d:	8d 76 00             	lea    0x0(%esi),%esi

80102610 <freerange>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102615:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102618:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010261b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102621:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102627:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262d:	39 de                	cmp    %ebx,%esi
8010262f:	72 23                	jb     80102654 <freerange+0x44>
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102647:	50                   	push   %eax
80102648:	e8 23 ff ff ff       	call   80102570 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	39 de                	cmp    %ebx,%esi
80102652:	73 e4                	jae    80102638 <freerange+0x28>
}
80102654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102657:	5b                   	pop    %ebx
80102658:	5e                   	pop    %esi
80102659:	5d                   	pop    %ebp
8010265a:	c3                   	ret
8010265b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102660 <kinit2>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
80102664:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102665:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102668:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010266b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102671:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102677:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010267d:	39 de                	cmp    %ebx,%esi
8010267f:	72 23                	jb     801026a4 <kinit2+0x44>
80102681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102688:	83 ec 0c             	sub    $0xc,%esp
8010268b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102691:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102697:	50                   	push   %eax
80102698:	e8 d3 fe ff ff       	call   80102570 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010269d:	83 c4 10             	add    $0x10,%esp
801026a0:	39 de                	cmp    %ebx,%esi
801026a2:	73 e4                	jae    80102688 <kinit2+0x28>
  kmem.use_lock = 1;
801026a4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801026ab:	00 00 00 
}
801026ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026b1:	5b                   	pop    %ebx
801026b2:	5e                   	pop    %esi
801026b3:	5d                   	pop    %ebp
801026b4:	c3                   	ret
801026b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026bc:	00 
801026bd:	8d 76 00             	lea    0x0(%esi),%esi

801026c0 <kinit1>:
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	56                   	push   %esi
801026c4:	53                   	push   %ebx
801026c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801026c8:	83 ec 08             	sub    $0x8,%esp
801026cb:	68 e4 7b 10 80       	push   $0x80107be4
801026d0:	68 40 26 11 80       	push   $0x80112640
801026d5:	e8 96 1e 00 00       	call   80104570 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026dd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026e0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801026e7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026fc:	39 de                	cmp    %ebx,%esi
801026fe:	72 1c                	jb     8010271c <kinit1+0x5c>
    kfree(p);
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102709:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010270f:	50                   	push   %eax
80102710:	e8 5b fe ff ff       	call   80102570 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102715:	83 c4 10             	add    $0x10,%esp
80102718:	39 de                	cmp    %ebx,%esi
8010271a:	73 e4                	jae    80102700 <kinit1+0x40>
}
8010271c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010271f:	5b                   	pop    %ebx
80102720:	5e                   	pop    %esi
80102721:	5d                   	pop    %ebp
80102722:	c3                   	ret
80102723:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010272a:	00 
8010272b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102730 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	53                   	push   %ebx
80102734:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102737:	a1 74 26 11 80       	mov    0x80112674,%eax
8010273c:	85 c0                	test   %eax,%eax
8010273e:	75 20                	jne    80102760 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102740:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102746:	85 db                	test   %ebx,%ebx
80102748:	74 07                	je     80102751 <kalloc+0x21>
    kmem.freelist = r->next;
8010274a:	8b 03                	mov    (%ebx),%eax
8010274c:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102751:	89 d8                	mov    %ebx,%eax
80102753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102756:	c9                   	leave
80102757:	c3                   	ret
80102758:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010275f:	00 
    acquire(&kmem.lock);
80102760:	83 ec 0c             	sub    $0xc,%esp
80102763:	68 40 26 11 80       	push   $0x80112640
80102768:	e8 f3 1f 00 00       	call   80104760 <acquire>
  r = kmem.freelist;
8010276d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(kmem.use_lock)
80102773:	a1 74 26 11 80       	mov    0x80112674,%eax
  if(r)
80102778:	83 c4 10             	add    $0x10,%esp
8010277b:	85 db                	test   %ebx,%ebx
8010277d:	74 08                	je     80102787 <kalloc+0x57>
    kmem.freelist = r->next;
8010277f:	8b 13                	mov    (%ebx),%edx
80102781:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102787:	85 c0                	test   %eax,%eax
80102789:	74 c6                	je     80102751 <kalloc+0x21>
    release(&kmem.lock);
8010278b:	83 ec 0c             	sub    $0xc,%esp
8010278e:	68 40 26 11 80       	push   $0x80112640
80102793:	e8 68 1f 00 00       	call   80104700 <release>
}
80102798:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010279a:	83 c4 10             	add    $0x10,%esp
}
8010279d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027a0:	c9                   	leave
801027a1:	c3                   	ret
801027a2:	66 90                	xchg   %ax,%ax
801027a4:	66 90                	xchg   %ax,%ax
801027a6:	66 90                	xchg   %ax,%ax
801027a8:	66 90                	xchg   %ax,%ax
801027aa:	66 90                	xchg   %ax,%ax
801027ac:	66 90                	xchg   %ax,%ax
801027ae:	66 90                	xchg   %ax,%ax

801027b0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027b0:	ba 64 00 00 00       	mov    $0x64,%edx
801027b5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027b6:	a8 01                	test   $0x1,%al
801027b8:	0f 84 c2 00 00 00    	je     80102880 <kbdgetc+0xd0>
{
801027be:	55                   	push   %ebp
801027bf:	ba 60 00 00 00       	mov    $0x60,%edx
801027c4:	89 e5                	mov    %esp,%ebp
801027c6:	53                   	push   %ebx
801027c7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801027c8:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
801027ce:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801027d1:	3c e0                	cmp    $0xe0,%al
801027d3:	74 5b                	je     80102830 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801027d5:	89 da                	mov    %ebx,%edx
801027d7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801027da:	84 c0                	test   %al,%al
801027dc:	78 62                	js     80102840 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027de:	85 d2                	test   %edx,%edx
801027e0:	74 09                	je     801027eb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027e2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027e5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801027e8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801027eb:	0f b6 91 40 83 10 80 	movzbl -0x7fef7cc0(%ecx),%edx
  shift ^= togglecode[data];
801027f2:	0f b6 81 40 82 10 80 	movzbl -0x7fef7dc0(%ecx),%eax
  shift |= shiftcode[data];
801027f9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027fb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027fd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027ff:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102805:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102808:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010280b:	8b 04 85 20 82 10 80 	mov    -0x7fef7de0(,%eax,4),%eax
80102812:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102816:	74 0b                	je     80102823 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102818:	8d 50 9f             	lea    -0x61(%eax),%edx
8010281b:	83 fa 19             	cmp    $0x19,%edx
8010281e:	77 48                	ja     80102868 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102820:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102823:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102826:	c9                   	leave
80102827:	c3                   	ret
80102828:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010282f:	00 
    shift |= E0ESC;
80102830:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102833:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102835:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010283b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010283e:	c9                   	leave
8010283f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102840:	83 e0 7f             	and    $0x7f,%eax
80102843:	85 d2                	test   %edx,%edx
80102845:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102848:	0f b6 81 40 83 10 80 	movzbl -0x7fef7cc0(%ecx),%eax
8010284f:	83 c8 40             	or     $0x40,%eax
80102852:	0f b6 c0             	movzbl %al,%eax
80102855:	f7 d0                	not    %eax
80102857:	21 d8                	and    %ebx,%eax
80102859:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
8010285e:	31 c0                	xor    %eax,%eax
80102860:	eb d9                	jmp    8010283b <kbdgetc+0x8b>
80102862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102868:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010286b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010286e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102871:	c9                   	leave
      c += 'a' - 'A';
80102872:	83 f9 1a             	cmp    $0x1a,%ecx
80102875:	0f 42 c2             	cmovb  %edx,%eax
}
80102878:	c3                   	ret
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102885:	c3                   	ret
80102886:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010288d:	00 
8010288e:	66 90                	xchg   %ax,%ax

80102890 <kbdintr>:

void
kbdintr(void)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102896:	68 b0 27 10 80       	push   $0x801027b0
8010289b:	e8 00 e0 ff ff       	call   801008a0 <consoleintr>
}
801028a0:	83 c4 10             	add    $0x10,%esp
801028a3:	c9                   	leave
801028a4:	c3                   	ret
801028a5:	66 90                	xchg   %ax,%ax
801028a7:	66 90                	xchg   %ax,%ax
801028a9:	66 90                	xchg   %ax,%ax
801028ab:	66 90                	xchg   %ax,%ax
801028ad:	66 90                	xchg   %ax,%ax
801028af:	90                   	nop

801028b0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028b0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028b5:	85 c0                	test   %eax,%eax
801028b7:	0f 84 c3 00 00 00    	je     80102980 <lapicinit+0xd0>
  lapic[index] = value;
801028bd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028c4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ca:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028d1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028de:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801028e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028eb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fe:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102905:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102908:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010290b:	8b 50 30             	mov    0x30(%eax),%edx
8010290e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102914:	75 72                	jne    80102988 <lapicinit+0xd8>
  lapic[index] = value;
80102916:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010291d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102920:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102923:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010292a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010292d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102930:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102937:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010293a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010293d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102944:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102947:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010294a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102951:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102954:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102957:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010295e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102961:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102968:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010296e:	80 e6 10             	and    $0x10,%dh
80102971:	75 f5                	jne    80102968 <lapicinit+0xb8>
  lapic[index] = value;
80102973:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010297a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010297d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102980:	c3                   	ret
80102981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102988:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010298f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102992:	8b 50 20             	mov    0x20(%eax),%edx
}
80102995:	e9 7c ff ff ff       	jmp    80102916 <lapicinit+0x66>
8010299a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029a0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801029a0:	a1 80 26 11 80       	mov    0x80112680,%eax
801029a5:	85 c0                	test   %eax,%eax
801029a7:	74 07                	je     801029b0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801029a9:	8b 40 20             	mov    0x20(%eax),%eax
801029ac:	c1 e8 18             	shr    $0x18,%eax
801029af:	c3                   	ret
    return 0;
801029b0:	31 c0                	xor    %eax,%eax
}
801029b2:	c3                   	ret
801029b3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029ba:	00 
801029bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801029c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029c0:	a1 80 26 11 80       	mov    0x80112680,%eax
801029c5:	85 c0                	test   %eax,%eax
801029c7:	74 0d                	je     801029d6 <lapiceoi+0x16>
  lapic[index] = value;
801029c9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029d6:	c3                   	ret
801029d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029de:	00 
801029df:	90                   	nop

801029e0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801029e0:	c3                   	ret
801029e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029e8:	00 
801029e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029f6:	ba 70 00 00 00       	mov    $0x70,%edx
801029fb:	89 e5                	mov    %esp,%ebp
801029fd:	53                   	push   %ebx
801029fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a04:	ee                   	out    %al,(%dx)
80102a05:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a0a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a0f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a10:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102a12:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a15:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a1b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a1d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102a20:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a22:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a25:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a28:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a2e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a33:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a39:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a3c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a43:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a46:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a49:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a50:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a53:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a56:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a5c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a5f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a65:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a68:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a71:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a77:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a7d:	c9                   	leave
80102a7e:	c3                   	ret
80102a7f:	90                   	nop

80102a80 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a80:	55                   	push   %ebp
80102a81:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a86:	ba 70 00 00 00       	mov    $0x70,%edx
80102a8b:	89 e5                	mov    %esp,%ebp
80102a8d:	57                   	push   %edi
80102a8e:	56                   	push   %esi
80102a8f:	53                   	push   %ebx
80102a90:	83 ec 4c             	sub    $0x4c,%esp
80102a93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a94:	ba 71 00 00 00       	mov    $0x71,%edx
80102a99:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a9a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	bf 70 00 00 00       	mov    $0x70,%edi
80102aa2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102aa5:	8d 76 00             	lea    0x0(%esi),%esi
80102aa8:	31 c0                	xor    %eax,%eax
80102aaa:	89 fa                	mov    %edi,%edx
80102aac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aad:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ab2:	89 ca                	mov    %ecx,%edx
80102ab4:	ec                   	in     (%dx),%al
80102ab5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab8:	89 fa                	mov    %edi,%edx
80102aba:	b8 02 00 00 00       	mov    $0x2,%eax
80102abf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac0:	89 ca                	mov    %ecx,%edx
80102ac2:	ec                   	in     (%dx),%al
80102ac3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac6:	89 fa                	mov    %edi,%edx
80102ac8:	b8 04 00 00 00       	mov    $0x4,%eax
80102acd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ace:	89 ca                	mov    %ecx,%edx
80102ad0:	ec                   	in     (%dx),%al
80102ad1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad4:	89 fa                	mov    %edi,%edx
80102ad6:	b8 07 00 00 00       	mov    $0x7,%eax
80102adb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102adc:	89 ca                	mov    %ecx,%edx
80102ade:	ec                   	in     (%dx),%al
80102adf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae2:	89 fa                	mov    %edi,%edx
80102ae4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ae9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aea:	89 ca                	mov    %ecx,%edx
80102aec:	ec                   	in     (%dx),%al
80102aed:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aef:	89 fa                	mov    %edi,%edx
80102af1:	b8 09 00 00 00       	mov    $0x9,%eax
80102af6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af7:	89 ca                	mov    %ecx,%edx
80102af9:	ec                   	in     (%dx),%al
80102afa:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afd:	89 fa                	mov    %edi,%edx
80102aff:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b04:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b05:	89 ca                	mov    %ecx,%edx
80102b07:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b08:	84 c0                	test   %al,%al
80102b0a:	78 9c                	js     80102aa8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b0c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b10:	89 f2                	mov    %esi,%edx
80102b12:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102b15:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b18:	89 fa                	mov    %edi,%edx
80102b1a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b1d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b21:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102b24:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b27:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b2b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b2e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b35:	31 c0                	xor    %eax,%eax
80102b37:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b38:	89 ca                	mov    %ecx,%edx
80102b3a:	ec                   	in     (%dx),%al
80102b3b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b3e:	89 fa                	mov    %edi,%edx
80102b40:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b43:	b8 02 00 00 00       	mov    $0x2,%eax
80102b48:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b49:	89 ca                	mov    %ecx,%edx
80102b4b:	ec                   	in     (%dx),%al
80102b4c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4f:	89 fa                	mov    %edi,%edx
80102b51:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b54:	b8 04 00 00 00       	mov    $0x4,%eax
80102b59:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5a:	89 ca                	mov    %ecx,%edx
80102b5c:	ec                   	in     (%dx),%al
80102b5d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b60:	89 fa                	mov    %edi,%edx
80102b62:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b65:	b8 07 00 00 00       	mov    $0x7,%eax
80102b6a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6b:	89 ca                	mov    %ecx,%edx
80102b6d:	ec                   	in     (%dx),%al
80102b6e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b71:	89 fa                	mov    %edi,%edx
80102b73:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b76:	b8 08 00 00 00       	mov    $0x8,%eax
80102b7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7c:	89 ca                	mov    %ecx,%edx
80102b7e:	ec                   	in     (%dx),%al
80102b7f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b82:	89 fa                	mov    %edi,%edx
80102b84:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b87:	b8 09 00 00 00       	mov    $0x9,%eax
80102b8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8d:	89 ca                	mov    %ecx,%edx
80102b8f:	ec                   	in     (%dx),%al
80102b90:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b93:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b99:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b9c:	6a 18                	push   $0x18
80102b9e:	50                   	push   %eax
80102b9f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ba2:	50                   	push   %eax
80102ba3:	e8 f8 1c 00 00       	call   801048a0 <memcmp>
80102ba8:	83 c4 10             	add    $0x10,%esp
80102bab:	85 c0                	test   %eax,%eax
80102bad:	0f 85 f5 fe ff ff    	jne    80102aa8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102bb3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102bba:	89 f0                	mov    %esi,%eax
80102bbc:	84 c0                	test   %al,%al
80102bbe:	75 78                	jne    80102c38 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bc0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bc3:	89 c2                	mov    %eax,%edx
80102bc5:	83 e0 0f             	and    $0xf,%eax
80102bc8:	c1 ea 04             	shr    $0x4,%edx
80102bcb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bce:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bd1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102bd4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bd7:	89 c2                	mov    %eax,%edx
80102bd9:	83 e0 0f             	and    $0xf,%eax
80102bdc:	c1 ea 04             	shr    $0x4,%edx
80102bdf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102be2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102be8:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102beb:	89 c2                	mov    %eax,%edx
80102bed:	83 e0 0f             	and    $0xf,%eax
80102bf0:	c1 ea 04             	shr    $0x4,%edx
80102bf3:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bf6:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bf9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bfc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bff:	89 c2                	mov    %eax,%edx
80102c01:	83 e0 0f             	and    $0xf,%eax
80102c04:	c1 ea 04             	shr    $0x4,%edx
80102c07:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c0a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c0d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c10:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c13:	89 c2                	mov    %eax,%edx
80102c15:	83 e0 0f             	and    $0xf,%eax
80102c18:	c1 ea 04             	shr    $0x4,%edx
80102c1b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c1e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c21:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c24:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c27:	89 c2                	mov    %eax,%edx
80102c29:	83 e0 0f             	and    $0xf,%eax
80102c2c:	c1 ea 04             	shr    $0x4,%edx
80102c2f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c32:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c35:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c38:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c3b:	89 03                	mov    %eax,(%ebx)
80102c3d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c40:	89 43 04             	mov    %eax,0x4(%ebx)
80102c43:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c46:	89 43 08             	mov    %eax,0x8(%ebx)
80102c49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c4c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102c4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c52:	89 43 10             	mov    %eax,0x10(%ebx)
80102c55:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c58:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102c5b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c65:	5b                   	pop    %ebx
80102c66:	5e                   	pop    %esi
80102c67:	5f                   	pop    %edi
80102c68:	5d                   	pop    %ebp
80102c69:	c3                   	ret
80102c6a:	66 90                	xchg   %ax,%ax
80102c6c:	66 90                	xchg   %ax,%ax
80102c6e:	66 90                	xchg   %ax,%ax

80102c70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c70:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102c76:	85 c9                	test   %ecx,%ecx
80102c78:	0f 8e 8a 00 00 00    	jle    80102d08 <install_trans+0x98>
{
80102c7e:	55                   	push   %ebp
80102c7f:	89 e5                	mov    %esp,%ebp
80102c81:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c82:	31 ff                	xor    %edi,%edi
{
80102c84:	56                   	push   %esi
80102c85:	53                   	push   %ebx
80102c86:	83 ec 0c             	sub    $0xc,%esp
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c90:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c95:	83 ec 08             	sub    $0x8,%esp
80102c98:	01 f8                	add    %edi,%eax
80102c9a:	83 c0 01             	add    $0x1,%eax
80102c9d:	50                   	push   %eax
80102c9e:	ff 35 e4 26 11 80    	push   0x801126e4
80102ca4:	e8 27 d4 ff ff       	call   801000d0 <bread>
80102ca9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cab:	58                   	pop    %eax
80102cac:	5a                   	pop    %edx
80102cad:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102cb4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cbd:	e8 0e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cc2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cc5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cc7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cca:	68 00 02 00 00       	push   $0x200
80102ccf:	50                   	push   %eax
80102cd0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102cd3:	50                   	push   %eax
80102cd4:	e8 17 1c 00 00       	call   801048f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102cd9:	89 1c 24             	mov    %ebx,(%esp)
80102cdc:	e8 cf d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102ce1:	89 34 24             	mov    %esi,(%esp)
80102ce4:	e8 07 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102ce9:	89 1c 24             	mov    %ebx,(%esp)
80102cec:	e8 ff d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cf1:	83 c4 10             	add    $0x10,%esp
80102cf4:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102cfa:	7f 94                	jg     80102c90 <install_trans+0x20>
  }
}
80102cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cff:	5b                   	pop    %ebx
80102d00:	5e                   	pop    %esi
80102d01:	5f                   	pop    %edi
80102d02:	5d                   	pop    %ebp
80102d03:	c3                   	ret
80102d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d08:	c3                   	ret
80102d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	53                   	push   %ebx
80102d14:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d17:	ff 35 d4 26 11 80    	push   0x801126d4
80102d1d:	ff 35 e4 26 11 80    	push   0x801126e4
80102d23:	e8 a8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d28:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d2b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d2d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102d32:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d35:	85 c0                	test   %eax,%eax
80102d37:	7e 19                	jle    80102d52 <write_head+0x42>
80102d39:	31 d2                	xor    %edx,%edx
80102d3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102d40:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102d47:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d4b:	83 c2 01             	add    $0x1,%edx
80102d4e:	39 d0                	cmp    %edx,%eax
80102d50:	75 ee                	jne    80102d40 <write_head+0x30>
  }
  bwrite(buf);
80102d52:	83 ec 0c             	sub    $0xc,%esp
80102d55:	53                   	push   %ebx
80102d56:	e8 55 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d5b:	89 1c 24             	mov    %ebx,(%esp)
80102d5e:	e8 8d d4 ff ff       	call   801001f0 <brelse>
}
80102d63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d66:	83 c4 10             	add    $0x10,%esp
80102d69:	c9                   	leave
80102d6a:	c3                   	ret
80102d6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102d70 <initlog>:
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 2c             	sub    $0x2c,%esp
80102d77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d7a:	68 e9 7b 10 80       	push   $0x80107be9
80102d7f:	68 a0 26 11 80       	push   $0x801126a0
80102d84:	e8 e7 17 00 00       	call   80104570 <initlock>
  readsb(dev, &sb);
80102d89:	58                   	pop    %eax
80102d8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d8d:	5a                   	pop    %edx
80102d8e:	50                   	push   %eax
80102d8f:	53                   	push   %ebx
80102d90:	e8 7b e8 ff ff       	call   80101610 <readsb>
  log.start = sb.logstart;
80102d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d98:	59                   	pop    %ecx
  log.dev = dev;
80102d99:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102d9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102da2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102da7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102dad:	5a                   	pop    %edx
80102dae:	50                   	push   %eax
80102daf:	53                   	push   %ebx
80102db0:	e8 1b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102db5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102db8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102dbb:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102dc1:	85 db                	test   %ebx,%ebx
80102dc3:	7e 1d                	jle    80102de2 <initlog+0x72>
80102dc5:	31 d2                	xor    %edx,%edx
80102dc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dce:	00 
80102dcf:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102dd0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102dd4:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ddb:	83 c2 01             	add    $0x1,%edx
80102dde:	39 d3                	cmp    %edx,%ebx
80102de0:	75 ee                	jne    80102dd0 <initlog+0x60>
  brelse(buf);
80102de2:	83 ec 0c             	sub    $0xc,%esp
80102de5:	50                   	push   %eax
80102de6:	e8 05 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102deb:	e8 80 fe ff ff       	call   80102c70 <install_trans>
  log.lh.n = 0;
80102df0:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102df7:	00 00 00 
  write_head(); // clear the log
80102dfa:	e8 11 ff ff ff       	call   80102d10 <write_head>
}
80102dff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e02:	83 c4 10             	add    $0x10,%esp
80102e05:	c9                   	leave
80102e06:	c3                   	ret
80102e07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e0e:	00 
80102e0f:	90                   	nop

80102e10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e16:	68 a0 26 11 80       	push   $0x801126a0
80102e1b:	e8 40 19 00 00       	call   80104760 <acquire>
80102e20:	83 c4 10             	add    $0x10,%esp
80102e23:	eb 18                	jmp    80102e3d <begin_op+0x2d>
80102e25:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e28:	83 ec 08             	sub    $0x8,%esp
80102e2b:	68 a0 26 11 80       	push   $0x801126a0
80102e30:	68 a0 26 11 80       	push   $0x801126a0
80102e35:	e8 06 14 00 00       	call   80104240 <sleep>
80102e3a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e3d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102e42:	85 c0                	test   %eax,%eax
80102e44:	75 e2                	jne    80102e28 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e46:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102e4b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102e51:	83 c0 01             	add    $0x1,%eax
80102e54:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e57:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e5a:	83 fa 1e             	cmp    $0x1e,%edx
80102e5d:	7f c9                	jg     80102e28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e5f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e62:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102e67:	68 a0 26 11 80       	push   $0x801126a0
80102e6c:	e8 8f 18 00 00       	call   80104700 <release>
      break;
    }
  }
}
80102e71:	83 c4 10             	add    $0x10,%esp
80102e74:	c9                   	leave
80102e75:	c3                   	ret
80102e76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e7d:	00 
80102e7e:	66 90                	xchg   %ax,%ax

80102e80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	57                   	push   %edi
80102e84:	56                   	push   %esi
80102e85:	53                   	push   %ebx
80102e86:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e89:	68 a0 26 11 80       	push   $0x801126a0
80102e8e:	e8 cd 18 00 00       	call   80104760 <acquire>
  log.outstanding -= 1;
80102e93:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102e98:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102e9e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ea1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ea4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102eaa:	85 f6                	test   %esi,%esi
80102eac:	0f 85 22 01 00 00    	jne    80102fd4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102eb2:	85 db                	test   %ebx,%ebx
80102eb4:	0f 85 f6 00 00 00    	jne    80102fb0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102eba:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102ec1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ec4:	83 ec 0c             	sub    $0xc,%esp
80102ec7:	68 a0 26 11 80       	push   $0x801126a0
80102ecc:	e8 2f 18 00 00       	call   80104700 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ed1:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102ed7:	83 c4 10             	add    $0x10,%esp
80102eda:	85 c9                	test   %ecx,%ecx
80102edc:	7f 42                	jg     80102f20 <end_op+0xa0>
    acquire(&log.lock);
80102ede:	83 ec 0c             	sub    $0xc,%esp
80102ee1:	68 a0 26 11 80       	push   $0x801126a0
80102ee6:	e8 75 18 00 00       	call   80104760 <acquire>
    log.committing = 0;
80102eeb:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102ef2:	00 00 00 
    wakeup(&log);
80102ef5:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102efc:	e8 ff 13 00 00       	call   80104300 <wakeup>
    release(&log.lock);
80102f01:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f08:	e8 f3 17 00 00       	call   80104700 <release>
80102f0d:	83 c4 10             	add    $0x10,%esp
}
80102f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f13:	5b                   	pop    %ebx
80102f14:	5e                   	pop    %esi
80102f15:	5f                   	pop    %edi
80102f16:	5d                   	pop    %ebp
80102f17:	c3                   	ret
80102f18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f1f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f20:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102f25:	83 ec 08             	sub    $0x8,%esp
80102f28:	01 d8                	add    %ebx,%eax
80102f2a:	83 c0 01             	add    $0x1,%eax
80102f2d:	50                   	push   %eax
80102f2e:	ff 35 e4 26 11 80    	push   0x801126e4
80102f34:	e8 97 d1 ff ff       	call   801000d0 <bread>
80102f39:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f3b:	58                   	pop    %eax
80102f3c:	5a                   	pop    %edx
80102f3d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102f44:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f4d:	e8 7e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f52:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f55:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f57:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f5a:	68 00 02 00 00       	push   $0x200
80102f5f:	50                   	push   %eax
80102f60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f63:	50                   	push   %eax
80102f64:	e8 87 19 00 00       	call   801048f0 <memmove>
    bwrite(to);  // write the log
80102f69:	89 34 24             	mov    %esi,(%esp)
80102f6c:	e8 3f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f71:	89 3c 24             	mov    %edi,(%esp)
80102f74:	e8 77 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f79:	89 34 24             	mov    %esi,(%esp)
80102f7c:	e8 6f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102f8a:	7c 94                	jl     80102f20 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f8c:	e8 7f fd ff ff       	call   80102d10 <write_head>
    install_trans(); // Now install writes to home locations
80102f91:	e8 da fc ff ff       	call   80102c70 <install_trans>
    log.lh.n = 0;
80102f96:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f9d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fa0:	e8 6b fd ff ff       	call   80102d10 <write_head>
80102fa5:	e9 34 ff ff ff       	jmp    80102ede <end_op+0x5e>
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102fb0:	83 ec 0c             	sub    $0xc,%esp
80102fb3:	68 a0 26 11 80       	push   $0x801126a0
80102fb8:	e8 43 13 00 00       	call   80104300 <wakeup>
  release(&log.lock);
80102fbd:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102fc4:	e8 37 17 00 00       	call   80104700 <release>
80102fc9:	83 c4 10             	add    $0x10,%esp
}
80102fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fcf:	5b                   	pop    %ebx
80102fd0:	5e                   	pop    %esi
80102fd1:	5f                   	pop    %edi
80102fd2:	5d                   	pop    %ebp
80102fd3:	c3                   	ret
    panic("log.committing");
80102fd4:	83 ec 0c             	sub    $0xc,%esp
80102fd7:	68 ed 7b 10 80       	push   $0x80107bed
80102fdc:	e8 9f d3 ff ff       	call   80100380 <panic>
80102fe1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fe8:	00 
80102fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ff0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	53                   	push   %ebx
80102ff4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ff7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103000:	83 fa 1d             	cmp    $0x1d,%edx
80103003:	7f 7d                	jg     80103082 <log_write+0x92>
80103005:	a1 d8 26 11 80       	mov    0x801126d8,%eax
8010300a:	83 e8 01             	sub    $0x1,%eax
8010300d:	39 c2                	cmp    %eax,%edx
8010300f:	7d 71                	jge    80103082 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103011:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80103016:	85 c0                	test   %eax,%eax
80103018:	7e 75                	jle    8010308f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010301a:	83 ec 0c             	sub    $0xc,%esp
8010301d:	68 a0 26 11 80       	push   $0x801126a0
80103022:	e8 39 17 00 00       	call   80104760 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103027:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010302a:	83 c4 10             	add    $0x10,%esp
8010302d:	31 c0                	xor    %eax,%eax
8010302f:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103035:	85 d2                	test   %edx,%edx
80103037:	7f 0e                	jg     80103047 <log_write+0x57>
80103039:	eb 15                	jmp    80103050 <log_write+0x60>
8010303b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103040:	83 c0 01             	add    $0x1,%eax
80103043:	39 c2                	cmp    %eax,%edx
80103045:	74 29                	je     80103070 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103047:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010304e:	75 f0                	jne    80103040 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103050:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80103057:	39 c2                	cmp    %eax,%edx
80103059:	74 1c                	je     80103077 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010305b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010305e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103061:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103068:	c9                   	leave
  release(&log.lock);
80103069:	e9 92 16 00 00       	jmp    80104700 <release>
8010306e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103070:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103077:	83 c2 01             	add    $0x1,%edx
8010307a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103080:	eb d9                	jmp    8010305b <log_write+0x6b>
    panic("too big a transaction");
80103082:	83 ec 0c             	sub    $0xc,%esp
80103085:	68 fc 7b 10 80       	push   $0x80107bfc
8010308a:	e8 f1 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010308f:	83 ec 0c             	sub    $0xc,%esp
80103092:	68 12 7c 10 80       	push   $0x80107c12
80103097:	e8 e4 d2 ff ff       	call   80100380 <panic>
8010309c:	66 90                	xchg   %ax,%ax
8010309e:	66 90                	xchg   %ax,%ax

801030a0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	53                   	push   %ebx
801030a4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801030a7:	e8 e4 09 00 00       	call   80103a90 <cpuid>
801030ac:	89 c3                	mov    %eax,%ebx
801030ae:	e8 dd 09 00 00       	call   80103a90 <cpuid>
801030b3:	83 ec 04             	sub    $0x4,%esp
801030b6:	53                   	push   %ebx
801030b7:	50                   	push   %eax
801030b8:	68 2d 7c 10 80       	push   $0x80107c2d
801030bd:	e8 ee d5 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801030c2:	e8 89 2f 00 00       	call   80106050 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030c7:	e8 64 09 00 00       	call   80103a30 <mycpu>
801030cc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030ce:	b8 01 00 00 00       	mov    $0x1,%eax
801030d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030da:	e8 01 0a 00 00       	call   80103ae0 <scheduler>
801030df:	90                   	nop

801030e0 <mpenter>:
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030e6:	e8 95 41 00 00       	call   80107280 <switchkvm>
  seginit();
801030eb:	e8 10 40 00 00       	call   80107100 <seginit>
  lapicinit();
801030f0:	e8 bb f7 ff ff       	call   801028b0 <lapicinit>
  mpmain();
801030f5:	e8 a6 ff ff ff       	call   801030a0 <mpmain>
801030fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103100 <msgqueue_init>:
void msgqueue_init(void) {
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	83 ec 10             	sub    $0x10,%esp
    initlock(&msgq.lock, "msgqueue");
80103106:	68 41 7c 10 80       	push   $0x80107c41
8010310b:	68 80 27 11 80       	push   $0x80112780
80103110:	e8 5b 14 00 00       	call   80104570 <initlock>
    cprintf("Message queue initialized.\n");
80103115:	c7 04 24 4a 7c 10 80 	movl   $0x80107c4a,(%esp)
    msgq.head = 0;
8010311c:	c7 05 b4 30 11 80 00 	movl   $0x0,0x801130b4
80103123:	00 00 00 
    msgq.tail = 0;
80103126:	c7 05 b8 30 11 80 00 	movl   $0x0,0x801130b8
8010312d:	00 00 00 
    msgq.count = 0;
80103130:	c7 05 bc 30 11 80 00 	movl   $0x0,0x801130bc
80103137:	00 00 00 
    cprintf("Message queue initialized.\n");
8010313a:	e8 71 d5 ff ff       	call   801006b0 <cprintf>
}
8010313f:	83 c4 10             	add    $0x10,%esp
80103142:	c9                   	leave
80103143:	c3                   	ret
80103144:	66 90                	xchg   %ax,%ax
80103146:	66 90                	xchg   %ax,%ax
80103148:	66 90                	xchg   %ax,%ax
8010314a:	66 90                	xchg   %ax,%ax
8010314c:	66 90                	xchg   %ax,%ax
8010314e:	66 90                	xchg   %ax,%ax

80103150 <main>:
{
80103150:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103154:	83 e4 f0             	and    $0xfffffff0,%esp
80103157:	ff 71 fc             	push   -0x4(%ecx)
8010315a:	55                   	push   %ebp
8010315b:	89 e5                	mov    %esp,%ebp
8010315d:	53                   	push   %ebx
8010315e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024));          // Initialize physical page allocator
8010315f:	83 ec 08             	sub    $0x8,%esp
80103162:	68 00 00 40 80       	push   $0x80400000
80103167:	68 10 8f 11 80       	push   $0x80118f10
8010316c:	e8 4f f5 ff ff       	call   801026c0 <kinit1>
  kvmalloc();                             // Set up kernel page table
80103171:	e8 ca 45 00 00       	call   80107740 <kvmalloc>
  mpinit();                               // Detect other processors
80103176:	e8 85 01 00 00       	call   80103300 <mpinit>
  lapicinit();                            // Initialize local APIC (interrupt controller)
8010317b:	e8 30 f7 ff ff       	call   801028b0 <lapicinit>
  seginit();                              // Set up segment descriptors
80103180:	e8 7b 3f 00 00       	call   80107100 <seginit>
  picinit();                              // Disable legacy PIC
80103185:	e8 86 03 00 00       	call   80103510 <picinit>
  ioapicinit();                           // Initialize I/O APIC (interrupt controller)
8010318a:	e8 01 f3 ff ff       	call   80102490 <ioapicinit>
  consoleinit();                          // Initialize console hardware
8010318f:	e8 1c d9 ff ff       	call   80100ab0 <consoleinit>
  uartinit();                             // Initialize serial port
80103194:	e8 c7 32 00 00       	call   80106460 <uartinit>
  msgqueue_init();                        // Initialize message queue
80103199:	e8 62 ff ff ff       	call   80103100 <msgqueue_init>
  pinit();                                // Initialize process table
8010319e:	e8 6d 08 00 00       	call   80103a10 <pinit>
  tvinit();                               // Initialize trap vectors
801031a3:	e8 28 2e 00 00       	call   80105fd0 <tvinit>
  binit();                                // Initialize buffer cache
801031a8:	e8 93 ce ff ff       	call   80100040 <binit>
  fileinit();                             // Initialize file table
801031ad:	e8 4e dd ff ff       	call   80100f00 <fileinit>
  ideinit();                              // Initialize disk I/O
801031b2:	e8 b9 f0 ff ff       	call   80102270 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031b7:	83 c4 0c             	add    $0xc,%esp
801031ba:	68 8a 00 00 00       	push   $0x8a
801031bf:	68 8c b4 10 80       	push   $0x8010b48c
801031c4:	68 00 70 00 80       	push   $0x80007000
801031c9:	e8 22 17 00 00       	call   801048f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031ce:	83 c4 10             	add    $0x10,%esp
801031d1:	69 05 c4 30 11 80 b0 	imul   $0xb0,0x801130c4,%eax
801031d8:	00 00 00 
801031db:	05 e0 30 11 80       	add    $0x801130e0,%eax
801031e0:	3d e0 30 11 80       	cmp    $0x801130e0,%eax
801031e5:	76 79                	jbe    80103260 <main+0x110>
801031e7:	bb e0 30 11 80       	mov    $0x801130e0,%ebx
801031ec:	eb 1b                	jmp    80103209 <main+0xb9>
801031ee:	66 90                	xchg   %ax,%ax
801031f0:	69 05 c4 30 11 80 b0 	imul   $0xb0,0x801130c4,%eax
801031f7:	00 00 00 
801031fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103200:	05 e0 30 11 80       	add    $0x801130e0,%eax
80103205:	39 c3                	cmp    %eax,%ebx
80103207:	73 57                	jae    80103260 <main+0x110>
    if(c == mycpu())  // We've started already.
80103209:	e8 22 08 00 00       	call   80103a30 <mycpu>
8010320e:	39 c3                	cmp    %eax,%ebx
80103210:	74 de                	je     801031f0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103212:	e8 19 f5 ff ff       	call   80102730 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103217:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010321a:	c7 05 f8 6f 00 80 e0 	movl   $0x801030e0,0x80006ff8
80103221:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103224:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010322b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010322e:	05 00 10 00 00       	add    $0x1000,%eax
80103233:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103238:	0f b6 03             	movzbl (%ebx),%eax
8010323b:	68 00 70 00 00       	push   $0x7000
80103240:	50                   	push   %eax
80103241:	e8 aa f7 ff ff       	call   801029f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103246:	83 c4 10             	add    $0x10,%esp
80103249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103250:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103256:	85 c0                	test   %eax,%eax
80103258:	74 f6                	je     80103250 <main+0x100>
8010325a:	eb 94                	jmp    801031f0 <main+0xa0>
8010325c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // Complete memory initialization
80103260:	83 ec 08             	sub    $0x8,%esp
80103263:	68 00 00 00 8e       	push   $0x8e000000
80103268:	68 00 00 40 80       	push   $0x80400000
8010326d:	e8 ee f3 ff ff       	call   80102660 <kinit2>
  userinit();                             // Initialize the first user process
80103272:	e8 99 09 00 00       	call   80103c10 <userinit>
  mpmain();                               // Finish this processor's setup (non-boot CPUs run scheduler directly)
80103277:	e8 24 fe ff ff       	call   801030a0 <mpmain>
8010327c:	66 90                	xchg   %ax,%ax
8010327e:	66 90                	xchg   %ax,%ax

80103280 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103285:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010328b:	53                   	push   %ebx
  e = addr+len;
8010328c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010328f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103292:	39 de                	cmp    %ebx,%esi
80103294:	72 10                	jb     801032a6 <mpsearch1+0x26>
80103296:	eb 50                	jmp    801032e8 <mpsearch1+0x68>
80103298:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010329f:	00 
801032a0:	89 fe                	mov    %edi,%esi
801032a2:	39 df                	cmp    %ebx,%edi
801032a4:	73 42                	jae    801032e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032a6:	83 ec 04             	sub    $0x4,%esp
801032a9:	8d 7e 10             	lea    0x10(%esi),%edi
801032ac:	6a 04                	push   $0x4
801032ae:	68 66 7c 10 80       	push   $0x80107c66
801032b3:	56                   	push   %esi
801032b4:	e8 e7 15 00 00       	call   801048a0 <memcmp>
801032b9:	83 c4 10             	add    $0x10,%esp
801032bc:	85 c0                	test   %eax,%eax
801032be:	75 e0                	jne    801032a0 <mpsearch1+0x20>
801032c0:	89 f2                	mov    %esi,%edx
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032c8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801032cb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801032ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801032d0:	39 fa                	cmp    %edi,%edx
801032d2:	75 f4                	jne    801032c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032d4:	84 c0                	test   %al,%al
801032d6:	75 c8                	jne    801032a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032db:	89 f0                	mov    %esi,%eax
801032dd:	5b                   	pop    %ebx
801032de:	5e                   	pop    %esi
801032df:	5f                   	pop    %edi
801032e0:	5d                   	pop    %ebp
801032e1:	c3                   	ret
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032eb:	31 f6                	xor    %esi,%esi
}
801032ed:	5b                   	pop    %ebx
801032ee:	89 f0                	mov    %esi,%eax
801032f0:	5e                   	pop    %esi
801032f1:	5f                   	pop    %edi
801032f2:	5d                   	pop    %ebp
801032f3:	c3                   	ret
801032f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032fb:	00 
801032fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103300 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
80103305:	53                   	push   %ebx
80103306:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103309:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103310:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103317:	c1 e0 08             	shl    $0x8,%eax
8010331a:	09 d0                	or     %edx,%eax
8010331c:	c1 e0 04             	shl    $0x4,%eax
8010331f:	75 1b                	jne    8010333c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103321:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103328:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010332f:	c1 e0 08             	shl    $0x8,%eax
80103332:	09 d0                	or     %edx,%eax
80103334:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103337:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010333c:	ba 00 04 00 00       	mov    $0x400,%edx
80103341:	e8 3a ff ff ff       	call   80103280 <mpsearch1>
80103346:	89 c3                	mov    %eax,%ebx
80103348:	85 c0                	test   %eax,%eax
8010334a:	0f 84 58 01 00 00    	je     801034a8 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103350:	8b 73 04             	mov    0x4(%ebx),%esi
80103353:	85 f6                	test   %esi,%esi
80103355:	0f 84 3d 01 00 00    	je     80103498 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010335b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010335e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103364:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103367:	6a 04                	push   $0x4
80103369:	68 6b 7c 10 80       	push   $0x80107c6b
8010336e:	50                   	push   %eax
8010336f:	e8 2c 15 00 00       	call   801048a0 <memcmp>
80103374:	83 c4 10             	add    $0x10,%esp
80103377:	85 c0                	test   %eax,%eax
80103379:	0f 85 19 01 00 00    	jne    80103498 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010337f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103386:	3c 01                	cmp    $0x1,%al
80103388:	74 08                	je     80103392 <mpinit+0x92>
8010338a:	3c 04                	cmp    $0x4,%al
8010338c:	0f 85 06 01 00 00    	jne    80103498 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103392:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103399:	66 85 d2             	test   %dx,%dx
8010339c:	74 22                	je     801033c0 <mpinit+0xc0>
8010339e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801033a1:	89 f0                	mov    %esi,%eax
  sum = 0;
801033a3:	31 d2                	xor    %edx,%edx
801033a5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033a8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801033af:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801033b2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033b4:	39 f8                	cmp    %edi,%eax
801033b6:	75 f0                	jne    801033a8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801033b8:	84 d2                	test   %dl,%dl
801033ba:	0f 85 d8 00 00 00    	jne    80103498 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033c0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801033c9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801033cc:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033d1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801033d8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801033de:	01 d7                	add    %edx,%edi
801033e0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801033e2:	bf 01 00 00 00       	mov    $0x1,%edi
801033e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033ee:	00 
801033ef:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033f0:	39 d0                	cmp    %edx,%eax
801033f2:	73 19                	jae    8010340d <mpinit+0x10d>
    switch(*p){
801033f4:	0f b6 08             	movzbl (%eax),%ecx
801033f7:	80 f9 02             	cmp    $0x2,%cl
801033fa:	0f 84 80 00 00 00    	je     80103480 <mpinit+0x180>
80103400:	77 6e                	ja     80103470 <mpinit+0x170>
80103402:	84 c9                	test   %cl,%cl
80103404:	74 3a                	je     80103440 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103406:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103409:	39 d0                	cmp    %edx,%eax
8010340b:	72 e7                	jb     801033f4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010340d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103410:	85 ff                	test   %edi,%edi
80103412:	0f 84 dd 00 00 00    	je     801034f5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103418:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010341c:	74 15                	je     80103433 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010341e:	b8 70 00 00 00       	mov    $0x70,%eax
80103423:	ba 22 00 00 00       	mov    $0x22,%edx
80103428:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103429:	ba 23 00 00 00       	mov    $0x23,%edx
8010342e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010342f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103432:	ee                   	out    %al,(%dx)
  }
}
80103433:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103436:	5b                   	pop    %ebx
80103437:	5e                   	pop    %esi
80103438:	5f                   	pop    %edi
80103439:	5d                   	pop    %ebp
8010343a:	c3                   	ret
8010343b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103440:	8b 0d c4 30 11 80    	mov    0x801130c4,%ecx
80103446:	83 f9 07             	cmp    $0x7,%ecx
80103449:	7f 19                	jg     80103464 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010344b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103451:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103455:	83 c1 01             	add    $0x1,%ecx
80103458:	89 0d c4 30 11 80    	mov    %ecx,0x801130c4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010345e:	88 9e e0 30 11 80    	mov    %bl,-0x7feecf20(%esi)
      p += sizeof(struct mpproc);
80103464:	83 c0 14             	add    $0x14,%eax
      continue;
80103467:	eb 87                	jmp    801033f0 <mpinit+0xf0>
80103469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103470:	83 e9 03             	sub    $0x3,%ecx
80103473:	80 f9 01             	cmp    $0x1,%cl
80103476:	76 8e                	jbe    80103406 <mpinit+0x106>
80103478:	31 ff                	xor    %edi,%edi
8010347a:	e9 71 ff ff ff       	jmp    801033f0 <mpinit+0xf0>
8010347f:	90                   	nop
      ioapicid = ioapic->apicno;
80103480:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103484:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103487:	88 0d c0 30 11 80    	mov    %cl,0x801130c0
      continue;
8010348d:	e9 5e ff ff ff       	jmp    801033f0 <mpinit+0xf0>
80103492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103498:	83 ec 0c             	sub    $0xc,%esp
8010349b:	68 70 7c 10 80       	push   $0x80107c70
801034a0:	e8 db ce ff ff       	call   80100380 <panic>
801034a5:	8d 76 00             	lea    0x0(%esi),%esi
{
801034a8:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801034ad:	eb 0b                	jmp    801034ba <mpinit+0x1ba>
801034af:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801034b0:	89 f3                	mov    %esi,%ebx
801034b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801034b8:	74 de                	je     80103498 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ba:	83 ec 04             	sub    $0x4,%esp
801034bd:	8d 73 10             	lea    0x10(%ebx),%esi
801034c0:	6a 04                	push   $0x4
801034c2:	68 66 7c 10 80       	push   $0x80107c66
801034c7:	53                   	push   %ebx
801034c8:	e8 d3 13 00 00       	call   801048a0 <memcmp>
801034cd:	83 c4 10             	add    $0x10,%esp
801034d0:	85 c0                	test   %eax,%eax
801034d2:	75 dc                	jne    801034b0 <mpinit+0x1b0>
801034d4:	89 da                	mov    %ebx,%edx
801034d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034dd:	00 
801034de:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801034e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801034e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801034e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801034e8:	39 d6                	cmp    %edx,%esi
801034ea:	75 f4                	jne    801034e0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ec:	84 c0                	test   %al,%al
801034ee:	75 c0                	jne    801034b0 <mpinit+0x1b0>
801034f0:	e9 5b fe ff ff       	jmp    80103350 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801034f5:	83 ec 0c             	sub    $0xc,%esp
801034f8:	68 4c 80 10 80       	push   $0x8010804c
801034fd:	e8 7e ce ff ff       	call   80100380 <panic>
80103502:	66 90                	xchg   %ax,%ax
80103504:	66 90                	xchg   %ax,%ax
80103506:	66 90                	xchg   %ax,%ax
80103508:	66 90                	xchg   %ax,%ax
8010350a:	66 90                	xchg   %ax,%ax
8010350c:	66 90                	xchg   %ax,%ax
8010350e:	66 90                	xchg   %ax,%ax

80103510 <picinit>:
80103510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103515:	ba 21 00 00 00       	mov    $0x21,%edx
8010351a:	ee                   	out    %al,(%dx)
8010351b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103520:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103521:	c3                   	ret
80103522:	66 90                	xchg   %ax,%ax
80103524:	66 90                	xchg   %ax,%ax
80103526:	66 90                	xchg   %ax,%ax
80103528:	66 90                	xchg   %ax,%ax
8010352a:	66 90                	xchg   %ax,%ax
8010352c:	66 90                	xchg   %ax,%ax
8010352e:	66 90                	xchg   %ax,%ax

80103530 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	57                   	push   %edi
80103534:	56                   	push   %esi
80103535:	53                   	push   %ebx
80103536:	83 ec 0c             	sub    $0xc,%esp
80103539:	8b 75 08             	mov    0x8(%ebp),%esi
8010353c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010353f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103545:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010354b:	e8 d0 d9 ff ff       	call   80100f20 <filealloc>
80103550:	89 06                	mov    %eax,(%esi)
80103552:	85 c0                	test   %eax,%eax
80103554:	0f 84 a5 00 00 00    	je     801035ff <pipealloc+0xcf>
8010355a:	e8 c1 d9 ff ff       	call   80100f20 <filealloc>
8010355f:	89 07                	mov    %eax,(%edi)
80103561:	85 c0                	test   %eax,%eax
80103563:	0f 84 84 00 00 00    	je     801035ed <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103569:	e8 c2 f1 ff ff       	call   80102730 <kalloc>
8010356e:	89 c3                	mov    %eax,%ebx
80103570:	85 c0                	test   %eax,%eax
80103572:	0f 84 a0 00 00 00    	je     80103618 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103578:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010357f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103582:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103585:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010358c:	00 00 00 
  p->nwrite = 0;
8010358f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103596:	00 00 00 
  p->nread = 0;
80103599:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035a0:	00 00 00 
  initlock(&p->lock, "pipe");
801035a3:	68 88 7c 10 80       	push   $0x80107c88
801035a8:	50                   	push   %eax
801035a9:	e8 c2 0f 00 00       	call   80104570 <initlock>
  (*f0)->type = FD_PIPE;
801035ae:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035b9:	8b 06                	mov    (%esi),%eax
801035bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035bf:	8b 06                	mov    (%esi),%eax
801035c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035c5:	8b 06                	mov    (%esi),%eax
801035c7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035ca:	8b 07                	mov    (%edi),%eax
801035cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035d2:	8b 07                	mov    (%edi),%eax
801035d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035d8:	8b 07                	mov    (%edi),%eax
801035da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035de:	8b 07                	mov    (%edi),%eax
801035e0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801035e3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035e8:	5b                   	pop    %ebx
801035e9:	5e                   	pop    %esi
801035ea:	5f                   	pop    %edi
801035eb:	5d                   	pop    %ebp
801035ec:	c3                   	ret
  if(*f0)
801035ed:	8b 06                	mov    (%esi),%eax
801035ef:	85 c0                	test   %eax,%eax
801035f1:	74 1e                	je     80103611 <pipealloc+0xe1>
    fileclose(*f0);
801035f3:	83 ec 0c             	sub    $0xc,%esp
801035f6:	50                   	push   %eax
801035f7:	e8 e4 d9 ff ff       	call   80100fe0 <fileclose>
801035fc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801035ff:	8b 07                	mov    (%edi),%eax
80103601:	85 c0                	test   %eax,%eax
80103603:	74 0c                	je     80103611 <pipealloc+0xe1>
    fileclose(*f1);
80103605:	83 ec 0c             	sub    $0xc,%esp
80103608:	50                   	push   %eax
80103609:	e8 d2 d9 ff ff       	call   80100fe0 <fileclose>
8010360e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103611:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103616:	eb cd                	jmp    801035e5 <pipealloc+0xb5>
  if(*f0)
80103618:	8b 06                	mov    (%esi),%eax
8010361a:	85 c0                	test   %eax,%eax
8010361c:	75 d5                	jne    801035f3 <pipealloc+0xc3>
8010361e:	eb df                	jmp    801035ff <pipealloc+0xcf>

80103620 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	56                   	push   %esi
80103624:	53                   	push   %ebx
80103625:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103628:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010362b:	83 ec 0c             	sub    $0xc,%esp
8010362e:	53                   	push   %ebx
8010362f:	e8 2c 11 00 00       	call   80104760 <acquire>
  if(writable){
80103634:	83 c4 10             	add    $0x10,%esp
80103637:	85 f6                	test   %esi,%esi
80103639:	74 65                	je     801036a0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010363b:	83 ec 0c             	sub    $0xc,%esp
8010363e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103644:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010364b:	00 00 00 
    wakeup(&p->nread);
8010364e:	50                   	push   %eax
8010364f:	e8 ac 0c 00 00       	call   80104300 <wakeup>
80103654:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103657:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010365d:	85 d2                	test   %edx,%edx
8010365f:	75 0a                	jne    8010366b <pipeclose+0x4b>
80103661:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103667:	85 c0                	test   %eax,%eax
80103669:	74 15                	je     80103680 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010366b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010366e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103671:	5b                   	pop    %ebx
80103672:	5e                   	pop    %esi
80103673:	5d                   	pop    %ebp
    release(&p->lock);
80103674:	e9 87 10 00 00       	jmp    80104700 <release>
80103679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	53                   	push   %ebx
80103684:	e8 77 10 00 00       	call   80104700 <release>
    kfree((char*)p);
80103689:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010368c:	83 c4 10             	add    $0x10,%esp
}
8010368f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103692:	5b                   	pop    %ebx
80103693:	5e                   	pop    %esi
80103694:	5d                   	pop    %ebp
    kfree((char*)p);
80103695:	e9 d6 ee ff ff       	jmp    80102570 <kfree>
8010369a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801036a9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036b0:	00 00 00 
    wakeup(&p->nwrite);
801036b3:	50                   	push   %eax
801036b4:	e8 47 0c 00 00       	call   80104300 <wakeup>
801036b9:	83 c4 10             	add    $0x10,%esp
801036bc:	eb 99                	jmp    80103657 <pipeclose+0x37>
801036be:	66 90                	xchg   %ax,%ax

801036c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	57                   	push   %edi
801036c4:	56                   	push   %esi
801036c5:	53                   	push   %ebx
801036c6:	83 ec 28             	sub    $0x28,%esp
801036c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036cc:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801036cf:	53                   	push   %ebx
801036d0:	e8 8b 10 00 00       	call   80104760 <acquire>
  for(i = 0; i < n; i++){
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	85 ff                	test   %edi,%edi
801036da:	0f 8e ce 00 00 00    	jle    801037ae <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036e0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801036e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801036e9:	89 7d 10             	mov    %edi,0x10(%ebp)
801036ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036ef:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801036f2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801036f5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036fb:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103701:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103707:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010370d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103710:	0f 85 b6 00 00 00    	jne    801037cc <pipewrite+0x10c>
80103716:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103719:	eb 3b                	jmp    80103756 <pipewrite+0x96>
8010371b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103720:	e8 8b 03 00 00       	call   80103ab0 <myproc>
80103725:	8b 48 24             	mov    0x24(%eax),%ecx
80103728:	85 c9                	test   %ecx,%ecx
8010372a:	75 34                	jne    80103760 <pipewrite+0xa0>
      wakeup(&p->nread);
8010372c:	83 ec 0c             	sub    $0xc,%esp
8010372f:	56                   	push   %esi
80103730:	e8 cb 0b 00 00       	call   80104300 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103735:	58                   	pop    %eax
80103736:	5a                   	pop    %edx
80103737:	53                   	push   %ebx
80103738:	57                   	push   %edi
80103739:	e8 02 0b 00 00       	call   80104240 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010373e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103744:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010374a:	83 c4 10             	add    $0x10,%esp
8010374d:	05 00 02 00 00       	add    $0x200,%eax
80103752:	39 c2                	cmp    %eax,%edx
80103754:	75 2a                	jne    80103780 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103756:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010375c:	85 c0                	test   %eax,%eax
8010375e:	75 c0                	jne    80103720 <pipewrite+0x60>
        release(&p->lock);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	53                   	push   %ebx
80103764:	e8 97 0f 00 00       	call   80104700 <release>
        return -1;
80103769:	83 c4 10             	add    $0x10,%esp
8010376c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103771:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103774:	5b                   	pop    %ebx
80103775:	5e                   	pop    %esi
80103776:	5f                   	pop    %edi
80103777:	5d                   	pop    %ebp
80103778:	c3                   	ret
80103779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103780:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103783:	8d 42 01             	lea    0x1(%edx),%eax
80103786:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010378c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010378f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103795:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103798:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010379c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801037a3:	39 c1                	cmp    %eax,%ecx
801037a5:	0f 85 50 ff ff ff    	jne    801036fb <pipewrite+0x3b>
801037ab:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037ae:	83 ec 0c             	sub    $0xc,%esp
801037b1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037b7:	50                   	push   %eax
801037b8:	e8 43 0b 00 00       	call   80104300 <wakeup>
  release(&p->lock);
801037bd:	89 1c 24             	mov    %ebx,(%esp)
801037c0:	e8 3b 0f 00 00       	call   80104700 <release>
  return n;
801037c5:	83 c4 10             	add    $0x10,%esp
801037c8:	89 f8                	mov    %edi,%eax
801037ca:	eb a5                	jmp    80103771 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801037cf:	eb b2                	jmp    80103783 <pipewrite+0xc3>
801037d1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801037d8:	00 
801037d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	57                   	push   %edi
801037e4:	56                   	push   %esi
801037e5:	53                   	push   %ebx
801037e6:	83 ec 18             	sub    $0x18,%esp
801037e9:	8b 75 08             	mov    0x8(%ebp),%esi
801037ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037ef:	56                   	push   %esi
801037f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037f6:	e8 65 0f 00 00       	call   80104760 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103801:	83 c4 10             	add    $0x10,%esp
80103804:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010380a:	74 2f                	je     8010383b <piperead+0x5b>
8010380c:	eb 37                	jmp    80103845 <piperead+0x65>
8010380e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103810:	e8 9b 02 00 00       	call   80103ab0 <myproc>
80103815:	8b 40 24             	mov    0x24(%eax),%eax
80103818:	85 c0                	test   %eax,%eax
8010381a:	0f 85 80 00 00 00    	jne    801038a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103820:	83 ec 08             	sub    $0x8,%esp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	e8 16 0a 00 00       	call   80104240 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010382a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103830:	83 c4 10             	add    $0x10,%esp
80103833:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103839:	75 0a                	jne    80103845 <piperead+0x65>
8010383b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103841:	85 d2                	test   %edx,%edx
80103843:	75 cb                	jne    80103810 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103845:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103848:	31 db                	xor    %ebx,%ebx
8010384a:	85 c9                	test   %ecx,%ecx
8010384c:	7f 26                	jg     80103874 <piperead+0x94>
8010384e:	eb 2c                	jmp    8010387c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103850:	8d 48 01             	lea    0x1(%eax),%ecx
80103853:	25 ff 01 00 00       	and    $0x1ff,%eax
80103858:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010385e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103863:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103866:	83 c3 01             	add    $0x1,%ebx
80103869:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010386c:	74 0e                	je     8010387c <piperead+0x9c>
8010386e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103874:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010387a:	75 d4                	jne    80103850 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010387c:	83 ec 0c             	sub    $0xc,%esp
8010387f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103885:	50                   	push   %eax
80103886:	e8 75 0a 00 00       	call   80104300 <wakeup>
  release(&p->lock);
8010388b:	89 34 24             	mov    %esi,(%esp)
8010388e:	e8 6d 0e 00 00       	call   80104700 <release>
  return i;
80103893:	83 c4 10             	add    $0x10,%esp
}
80103896:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103899:	89 d8                	mov    %ebx,%eax
8010389b:	5b                   	pop    %ebx
8010389c:	5e                   	pop    %esi
8010389d:	5f                   	pop    %edi
8010389e:	5d                   	pop    %ebp
8010389f:	c3                   	ret
      release(&p->lock);
801038a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038a8:	56                   	push   %esi
801038a9:	e8 52 0e 00 00       	call   80104700 <release>
      return -1;
801038ae:	83 c4 10             	add    $0x10,%esp
}
801038b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038b4:	89 d8                	mov    %ebx,%eax
801038b6:	5b                   	pop    %ebx
801038b7:	5e                   	pop    %esi
801038b8:	5f                   	pop    %edi
801038b9:	5d                   	pop    %ebp
801038ba:	c3                   	ret
801038bb:	66 90                	xchg   %ax,%ax
801038bd:	66 90                	xchg   %ax,%ax
801038bf:	90                   	nop

801038c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	53                   	push   %ebx
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038c4:	bb 94 36 11 80       	mov    $0x80113694,%ebx
{
801038c9:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
801038cc:	68 60 36 11 80       	push   $0x80113660
801038d1:	e8 8a 0e 00 00       	call   80104760 <acquire>
801038d6:	83 c4 10             	add    $0x10,%esp
801038d9:	eb 17                	jmp    801038f2 <allocproc+0x32>
801038db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e0:	81 c3 00 01 00 00    	add    $0x100,%ebx
801038e6:	81 fb 94 76 11 80    	cmp    $0x80117694,%ebx
801038ec:	0f 84 9f 00 00 00    	je     80103991 <allocproc+0xd1>
        if (p->state == UNUSED)
801038f2:	8b 43 0c             	mov    0xc(%ebx),%eax
801038f5:	85 c0                	test   %eax,%eax
801038f7:	75 e7                	jne    801038e0 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
801038f9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    p->state = EMBRYO;
801038fe:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)

    // Initialize signal fields
    p->pending_signals = 0;
80103905:	c7 83 fc 00 00 00 00 	movl   $0x0,0xfc(%ebx)
8010390c:	00 00 00 
    p->pid = nextpid++;
8010390f:	8d 50 01             	lea    0x1(%eax),%edx
80103912:	89 43 10             	mov    %eax,0x10(%ebx)
    for (int i = 0; i < NUMSIGNALS; i++) {
80103915:	8d 43 7c             	lea    0x7c(%ebx),%eax
    p->pid = nextpid++;
80103918:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
8010391e:	8d 93 fc 00 00 00    	lea    0xfc(%ebx),%edx
80103924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->signal_handlers[i] = 0; // Default: no custom handler
80103928:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (int i = 0; i < NUMSIGNALS; i++) {
8010392e:	83 c0 08             	add    $0x8,%eax
        p->signal_handlers[i] = 0; // Default: no custom handler
80103931:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for (int i = 0; i < NUMSIGNALS; i++) {
80103938:	39 d0                	cmp    %edx,%eax
8010393a:	75 ec                	jne    80103928 <allocproc+0x68>
    }

    release(&ptable.lock);
8010393c:	83 ec 0c             	sub    $0xc,%esp
8010393f:	68 60 36 11 80       	push   $0x80113660
80103944:	e8 b7 0d 00 00       	call   80104700 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
80103949:	e8 e2 ed ff ff       	call   80102730 <kalloc>
8010394e:	83 c4 10             	add    $0x10,%esp
80103951:	89 43 08             	mov    %eax,0x8(%ebx)
80103954:	85 c0                	test   %eax,%eax
80103956:	74 52                	je     801039aa <allocproc+0xea>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103958:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *)sp;
    memset(p->context, 0, sizeof *p->context);
8010395e:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
80103961:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103966:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint *)sp = (uint)trapret;
80103969:	c7 40 14 b7 5f 10 80 	movl   $0x80105fb7,0x14(%eax)
    p->context = (struct context *)sp;
80103970:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103973:	6a 14                	push   $0x14
80103975:	6a 00                	push   $0x0
80103977:	50                   	push   %eax
80103978:	e8 e3 0e 00 00       	call   80104860 <memset>
    p->context->eip = (uint)forkret;
8010397d:	8b 43 1c             	mov    0x1c(%ebx),%eax

    return p;
80103980:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
80103983:	c7 40 10 c0 39 10 80 	movl   $0x801039c0,0x10(%eax)
}
8010398a:	89 d8                	mov    %ebx,%eax
8010398c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010398f:	c9                   	leave
80103990:	c3                   	ret
    release(&ptable.lock);
80103991:	83 ec 0c             	sub    $0xc,%esp
    return 0;
80103994:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
80103996:	68 60 36 11 80       	push   $0x80113660
8010399b:	e8 60 0d 00 00       	call   80104700 <release>
    return 0;
801039a0:	83 c4 10             	add    $0x10,%esp
}
801039a3:	89 d8                	mov    %ebx,%eax
801039a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a8:	c9                   	leave
801039a9:	c3                   	ret
        p->state = UNUSED;
801039aa:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801039b1:	31 db                	xor    %ebx,%ebx
801039b3:	eb ee                	jmp    801039a3 <allocproc+0xe3>
801039b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039bc:	00 
801039bd:	8d 76 00             	lea    0x0(%esi),%esi

801039c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039c6:	68 60 36 11 80       	push   $0x80113660
801039cb:	e8 30 0d 00 00       	call   80104700 <release>

  if (first) {
801039d0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801039d5:	83 c4 10             	add    $0x10,%esp
801039d8:	85 c0                	test   %eax,%eax
801039da:	75 04                	jne    801039e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039dc:	c9                   	leave
801039dd:	c3                   	ret
801039de:	66 90                	xchg   %ax,%ax
    first = 0;
801039e0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801039e7:	00 00 00 
    iinit(ROOTDEV);
801039ea:	83 ec 0c             	sub    $0xc,%esp
801039ed:	6a 01                	push   $0x1
801039ef:	e8 5c dc ff ff       	call   80101650 <iinit>
    initlog(ROOTDEV);
801039f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039fb:	e8 70 f3 ff ff       	call   80102d70 <initlog>
}
80103a00:	83 c4 10             	add    $0x10,%esp
80103a03:	c9                   	leave
80103a04:	c3                   	ret
80103a05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a0c:	00 
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi

80103a10 <pinit>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a16:	68 8d 7c 10 80       	push   $0x80107c8d
80103a1b:	68 60 36 11 80       	push   $0x80113660
80103a20:	e8 4b 0b 00 00       	call   80104570 <initlock>
}
80103a25:	83 c4 10             	add    $0x10,%esp
80103a28:	c9                   	leave
80103a29:	c3                   	ret
80103a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a30 <mycpu>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a35:	9c                   	pushf
80103a36:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a37:	f6 c4 02             	test   $0x2,%ah
80103a3a:	75 46                	jne    80103a82 <mycpu+0x52>
  apicid = lapicid();
80103a3c:	e8 5f ef ff ff       	call   801029a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a41:	8b 35 c4 30 11 80    	mov    0x801130c4,%esi
80103a47:	85 f6                	test   %esi,%esi
80103a49:	7e 2a                	jle    80103a75 <mycpu+0x45>
80103a4b:	31 d2                	xor    %edx,%edx
80103a4d:	eb 08                	jmp    80103a57 <mycpu+0x27>
80103a4f:	90                   	nop
80103a50:	83 c2 01             	add    $0x1,%edx
80103a53:	39 f2                	cmp    %esi,%edx
80103a55:	74 1e                	je     80103a75 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a57:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a5d:	0f b6 99 e0 30 11 80 	movzbl -0x7feecf20(%ecx),%ebx
80103a64:	39 c3                	cmp    %eax,%ebx
80103a66:	75 e8                	jne    80103a50 <mycpu+0x20>
}
80103a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a6b:	8d 81 e0 30 11 80    	lea    -0x7feecf20(%ecx),%eax
}
80103a71:	5b                   	pop    %ebx
80103a72:	5e                   	pop    %esi
80103a73:	5d                   	pop    %ebp
80103a74:	c3                   	ret
  panic("unknown apicid\n");
80103a75:	83 ec 0c             	sub    $0xc,%esp
80103a78:	68 94 7c 10 80       	push   $0x80107c94
80103a7d:	e8 fe c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a82:	83 ec 0c             	sub    $0xc,%esp
80103a85:	68 6c 80 10 80       	push   $0x8010806c
80103a8a:	e8 f1 c8 ff ff       	call   80100380 <panic>
80103a8f:	90                   	nop

80103a90 <cpuid>:
cpuid() {
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a96:	e8 95 ff ff ff       	call   80103a30 <mycpu>
}
80103a9b:	c9                   	leave
  return mycpu()-cpus;
80103a9c:	2d e0 30 11 80       	sub    $0x801130e0,%eax
80103aa1:	c1 f8 04             	sar    $0x4,%eax
80103aa4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aaa:	c3                   	ret
80103aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ab0 <myproc>:
myproc(void) {
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	53                   	push   %ebx
80103ab4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ab7:	e8 54 0b 00 00       	call   80104610 <pushcli>
  c = mycpu();
80103abc:	e8 6f ff ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103ac1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac7:	e8 94 0b 00 00       	call   80104660 <popcli>
}
80103acc:	89 d8                	mov    %ebx,%eax
80103ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ad1:	c9                   	leave
80103ad2:	c3                   	ret
80103ad3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ada:	00 
80103adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ae0 <scheduler>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	57                   	push   %edi
80103ae4:	56                   	push   %esi
                        p->pending_signals &= ~(1 << i); // Clear the signal
80103ae5:	be 01 00 00 00       	mov    $0x1,%esi
{
80103aea:	53                   	push   %ebx
80103aeb:	83 ec 1c             	sub    $0x1c,%esp
    struct cpu *c = mycpu();
80103aee:	e8 3d ff ff ff       	call   80103a30 <mycpu>
    c->proc = 0;
80103af3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103afa:	00 00 00 
    struct cpu *c = mycpu();
80103afd:	89 c1                	mov    %eax,%ecx
    c->proc = 0;
80103aff:	8d 40 04             	lea    0x4(%eax),%eax
80103b02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                        p->pending_signals &= ~(1 << i); // Clear the signal
80103b05:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  asm volatile("sti");
80103b08:	fb                   	sti
        acquire(&ptable.lock);
80103b09:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103b0c:	bb 94 36 11 80       	mov    $0x80113694,%ebx
        acquire(&ptable.lock);
80103b11:	68 60 36 11 80       	push   $0x80113660
80103b16:	e8 45 0c 00 00       	call   80104760 <acquire>
80103b1b:	83 c4 10             	add    $0x10,%esp
80103b1e:	eb 4a                	jmp    80103b6a <scheduler+0x8a>
            c->proc = p;
80103b20:	8b 7d e0             	mov    -0x20(%ebp),%edi
            switchuvm(p);
80103b23:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
80103b26:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
            switchuvm(p);
80103b2c:	53                   	push   %ebx
80103b2d:	e8 5e 37 00 00       	call   80107290 <switchuvm>
            swtch(&(c->scheduler), p->context);
80103b32:	58                   	pop    %eax
80103b33:	5a                   	pop    %edx
80103b34:	ff 73 1c             	push   0x1c(%ebx)
80103b37:	ff 75 e4             	push   -0x1c(%ebp)
            p->state = RUNNING;
80103b3a:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80103b41:	e8 25 0f 00 00       	call   80104a6b <swtch>
            switchkvm();
80103b46:	e8 35 37 00 00       	call   80107280 <switchkvm>
            c->proc = 0;
80103b4b:	83 c4 10             	add    $0x10,%esp
80103b4e:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80103b55:	00 00 00 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103b58:	81 c3 00 01 00 00    	add    $0x100,%ebx
80103b5e:	81 fb 94 76 11 80    	cmp    $0x80117694,%ebx
80103b64:	0f 84 8f 00 00 00    	je     80103bf9 <scheduler+0x119>
            if (p->state != RUNNABLE)
80103b6a:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b6e:	75 e8                	jne    80103b58 <scheduler+0x78>
            if (p->pending_signals) {
80103b70:	8b 83 fc 00 00 00    	mov    0xfc(%ebx),%eax
80103b76:	85 c0                	test   %eax,%eax
80103b78:	74 a6                	je     80103b20 <scheduler+0x40>
                for (int i = 0; i < NUMSIGNALS; i++) {
80103b7a:	31 ff                	xor    %edi,%edi
80103b7c:	eb 36                	jmp    80103bb4 <scheduler+0xd4>
80103b7e:	66 90                	xchg   %ax,%ax
                            release(&ptable.lock);
80103b80:	83 ec 0c             	sub    $0xc,%esp
80103b83:	89 cf                	mov    %ecx,%edi
80103b85:	68 60 36 11 80       	push   $0x80113660
80103b8a:	e8 71 0b 00 00       	call   80104700 <release>
                            p->signal_handlers[i]();
80103b8f:	ff 54 bb 7c          	call   *0x7c(%ebx,%edi,4)
                            acquire(&ptable.lock);
80103b93:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
80103b9a:	e8 c1 0b 00 00       	call   80104760 <acquire>
80103b9f:	83 c4 10             	add    $0x10,%esp
                for (int i = 0; i < NUMSIGNALS; i++) {
80103ba2:	83 c7 01             	add    $0x1,%edi
80103ba5:	83 ff 20             	cmp    $0x20,%edi
80103ba8:	0f 84 72 ff ff ff    	je     80103b20 <scheduler+0x40>
                    if (p->pending_signals & (1 << i)) {
80103bae:	8b 83 fc 00 00 00    	mov    0xfc(%ebx),%eax
80103bb4:	0f a3 f8             	bt     %edi,%eax
80103bb7:	73 e9                	jae    80103ba2 <scheduler+0xc2>
80103bb9:	89 c2                	mov    %eax,%edx
80103bbb:	89 f9                	mov    %edi,%ecx
                        p->pending_signals &= ~(1 << i); // Clear the signal
80103bbd:	89 f0                	mov    %esi,%eax
80103bbf:	d3 e0                	shl    %cl,%eax
80103bc1:	f7 d0                	not    %eax
80103bc3:	21 d0                	and    %edx,%eax
80103bc5:	89 83 fc 00 00 00    	mov    %eax,0xfc(%ebx)
                        if (p->signal_handlers[i]) {
80103bcb:	8b 7c 8b 7c          	mov    0x7c(%ebx,%ecx,4),%edi
80103bcf:	85 ff                	test   %edi,%edi
80103bd1:	75 ad                	jne    80103b80 <scheduler+0xa0>
                        } else if (i == 2) {  // Default SIGINT behavior
80103bd3:	83 f9 02             	cmp    $0x2,%ecx
80103bd6:	74 08                	je     80103be0 <scheduler+0x100>
80103bd8:	89 cf                	mov    %ecx,%edi
80103bda:	eb c6                	jmp    80103ba2 <scheduler+0xc2>
80103bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                            p->killed = 1;  // Mark the process as killed
80103be0:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
                    if (p->pending_signals & (1 << i)) {
80103be7:	89 c2                	mov    %eax,%edx
                for (int i = 0; i < NUMSIGNALS; i++) {
80103be9:	b9 03 00 00 00       	mov    $0x3,%ecx
                    if (p->pending_signals & (1 << i)) {
80103bee:	a8 08                	test   $0x8,%al
80103bf0:	75 cb                	jne    80103bbd <scheduler+0xdd>
                for (int i = 0; i < NUMSIGNALS; i++) {
80103bf2:	bf 04 00 00 00       	mov    $0x4,%edi
80103bf7:	eb b5                	jmp    80103bae <scheduler+0xce>
        release(&ptable.lock);
80103bf9:	83 ec 0c             	sub    $0xc,%esp
80103bfc:	68 60 36 11 80       	push   $0x80113660
80103c01:	e8 fa 0a 00 00       	call   80104700 <release>
        sti();
80103c06:	83 c4 10             	add    $0x10,%esp
80103c09:	e9 fa fe ff ff       	jmp    80103b08 <scheduler+0x28>
80103c0e:	66 90                	xchg   %ax,%ax

80103c10 <userinit>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	53                   	push   %ebx
80103c14:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103c17:	e8 a4 fc ff ff       	call   801038c0 <allocproc>
80103c1c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c1e:	a3 94 76 11 80       	mov    %eax,0x80117694
  if((p->pgdir = setupkvm()) == 0)
80103c23:	e8 98 3a 00 00       	call   801076c0 <setupkvm>
80103c28:	89 43 04             	mov    %eax,0x4(%ebx)
80103c2b:	85 c0                	test   %eax,%eax
80103c2d:	0f 84 bd 00 00 00    	je     80103cf0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c33:	83 ec 04             	sub    $0x4,%esp
80103c36:	68 2c 00 00 00       	push   $0x2c
80103c3b:	68 60 b4 10 80       	push   $0x8010b460
80103c40:	50                   	push   %eax
80103c41:	e8 5a 37 00 00       	call   801073a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c46:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c49:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c4f:	6a 4c                	push   $0x4c
80103c51:	6a 00                	push   $0x0
80103c53:	ff 73 18             	push   0x18(%ebx)
80103c56:	e8 05 0c 00 00       	call   80104860 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c5b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c5e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c63:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c66:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c6b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c6f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c72:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c76:	8b 43 18             	mov    0x18(%ebx),%eax
80103c79:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c7d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c81:	8b 43 18             	mov    0x18(%ebx),%eax
80103c84:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c88:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c8c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c8f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c96:	8b 43 18             	mov    0x18(%ebx),%eax
80103c99:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ca0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ca3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103caa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103cad:	6a 10                	push   $0x10
80103caf:	68 bd 7c 10 80       	push   $0x80107cbd
80103cb4:	50                   	push   %eax
80103cb5:	e8 56 0d 00 00       	call   80104a10 <safestrcpy>
  p->cwd = namei("/");
80103cba:	c7 04 24 c6 7c 10 80 	movl   $0x80107cc6,(%esp)
80103cc1:	e8 8a e4 ff ff       	call   80102150 <namei>
80103cc6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103cc9:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
80103cd0:	e8 8b 0a 00 00       	call   80104760 <acquire>
  p->state = RUNNABLE;
80103cd5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103cdc:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
80103ce3:	e8 18 0a 00 00       	call   80104700 <release>
}
80103ce8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ceb:	83 c4 10             	add    $0x10,%esp
80103cee:	c9                   	leave
80103cef:	c3                   	ret
    panic("userinit: out of memory?");
80103cf0:	83 ec 0c             	sub    $0xc,%esp
80103cf3:	68 a4 7c 10 80       	push   $0x80107ca4
80103cf8:	e8 83 c6 ff ff       	call   80100380 <panic>
80103cfd:	8d 76 00             	lea    0x0(%esi),%esi

80103d00 <growproc>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	56                   	push   %esi
80103d04:	53                   	push   %ebx
80103d05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d08:	e8 03 09 00 00       	call   80104610 <pushcli>
  c = mycpu();
80103d0d:	e8 1e fd ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103d12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d18:	e8 43 09 00 00       	call   80104660 <popcli>
  sz = curproc->sz;
80103d1d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d1f:	85 f6                	test   %esi,%esi
80103d21:	7f 1d                	jg     80103d40 <growproc+0x40>
  } else if(n < 0){
80103d23:	75 3b                	jne    80103d60 <growproc+0x60>
  switchuvm(curproc);
80103d25:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d28:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d2a:	53                   	push   %ebx
80103d2b:	e8 60 35 00 00       	call   80107290 <switchuvm>
  return 0;
80103d30:	83 c4 10             	add    $0x10,%esp
80103d33:	31 c0                	xor    %eax,%eax
}
80103d35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d38:	5b                   	pop    %ebx
80103d39:	5e                   	pop    %esi
80103d3a:	5d                   	pop    %ebp
80103d3b:	c3                   	ret
80103d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d40:	83 ec 04             	sub    $0x4,%esp
80103d43:	01 c6                	add    %eax,%esi
80103d45:	56                   	push   %esi
80103d46:	50                   	push   %eax
80103d47:	ff 73 04             	push   0x4(%ebx)
80103d4a:	e8 a1 37 00 00       	call   801074f0 <allocuvm>
80103d4f:	83 c4 10             	add    $0x10,%esp
80103d52:	85 c0                	test   %eax,%eax
80103d54:	75 cf                	jne    80103d25 <growproc+0x25>
      return -1;
80103d56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d5b:	eb d8                	jmp    80103d35 <growproc+0x35>
80103d5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d60:	83 ec 04             	sub    $0x4,%esp
80103d63:	01 c6                	add    %eax,%esi
80103d65:	56                   	push   %esi
80103d66:	50                   	push   %eax
80103d67:	ff 73 04             	push   0x4(%ebx)
80103d6a:	e8 a1 38 00 00       	call   80107610 <deallocuvm>
80103d6f:	83 c4 10             	add    $0x10,%esp
80103d72:	85 c0                	test   %eax,%eax
80103d74:	75 af                	jne    80103d25 <growproc+0x25>
80103d76:	eb de                	jmp    80103d56 <growproc+0x56>
80103d78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d7f:	00 

80103d80 <fork>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d89:	e8 82 08 00 00       	call   80104610 <pushcli>
  c = mycpu();
80103d8e:	e8 9d fc ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103d93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d99:	e8 c2 08 00 00       	call   80104660 <popcli>
    if ((np = allocproc()) == 0) {
80103d9e:	e8 1d fb ff ff       	call   801038c0 <allocproc>
80103da3:	85 c0                	test   %eax,%eax
80103da5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103da8:	0f 84 fa 00 00 00    	je     80103ea8 <fork+0x128>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103dae:	83 ec 08             	sub    $0x8,%esp
80103db1:	ff 33                	push   (%ebx)
80103db3:	ff 73 04             	push   0x4(%ebx)
80103db6:	e8 f5 39 00 00       	call   801077b0 <copyuvm>
80103dbb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dbe:	83 c4 10             	add    $0x10,%esp
80103dc1:	89 42 04             	mov    %eax,0x4(%edx)
80103dc4:	85 c0                	test   %eax,%eax
80103dc6:	0f 84 bd 00 00 00    	je     80103e89 <fork+0x109>
    np->sz = curproc->sz;
80103dcc:	8b 03                	mov    (%ebx),%eax
    *np->tf = *curproc->tf;
80103dce:	8b 7a 18             	mov    0x18(%edx),%edi
    np->parent = curproc;
80103dd1:	89 5a 14             	mov    %ebx,0x14(%edx)
    *np->tf = *curproc->tf;
80103dd4:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->sz = curproc->sz;
80103dd9:	89 02                	mov    %eax,(%edx)
    *np->tf = *curproc->tf;
80103ddb:	8b 73 18             	mov    0x18(%ebx),%esi
    for (i = 0; i < NUMSIGNALS; i++) {
80103dde:	31 c0                	xor    %eax,%eax
    *np->tf = *curproc->tf;
80103de0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NUMSIGNALS; i++) {
80103de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        np->signal_handlers[i] = curproc->signal_handlers[i];
80103de8:	8b 4c 83 7c          	mov    0x7c(%ebx,%eax,4),%ecx
80103dec:	89 4c 82 7c          	mov    %ecx,0x7c(%edx,%eax,4)
    for (i = 0; i < NUMSIGNALS; i++) {
80103df0:	83 c0 01             	add    $0x1,%eax
80103df3:	83 f8 20             	cmp    $0x20,%eax
80103df6:	75 f0                	jne    80103de8 <fork+0x68>
    np->tf->eax = 0;
80103df8:	8b 42 18             	mov    0x18(%edx),%eax
    for (i = 0; i < NOFILE; i++)
80103dfb:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
80103dfd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    for (i = 0; i < NOFILE; i++)
80103e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[i])
80103e08:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e0c:	85 c0                	test   %eax,%eax
80103e0e:	74 16                	je     80103e26 <fork+0xa6>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103e10:	83 ec 0c             	sub    $0xc,%esp
80103e13:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103e16:	50                   	push   %eax
80103e17:	e8 74 d1 ff ff       	call   80100f90 <filedup>
80103e1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e1f:	83 c4 10             	add    $0x10,%esp
80103e22:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103e26:	83 c6 01             	add    $0x1,%esi
80103e29:	83 fe 10             	cmp    $0x10,%esi
80103e2c:	75 da                	jne    80103e08 <fork+0x88>
    np->cwd = idup(curproc->cwd);
80103e2e:	83 ec 0c             	sub    $0xc,%esp
80103e31:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e34:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
80103e37:	ff 73 fc             	push   -0x4(%ebx)
80103e3a:	e8 01 da ff ff       	call   80101840 <idup>
80103e3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e42:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
80103e45:	89 42 68             	mov    %eax,0x68(%edx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e48:	8d 42 6c             	lea    0x6c(%edx),%eax
80103e4b:	6a 10                	push   $0x10
80103e4d:	53                   	push   %ebx
80103e4e:	50                   	push   %eax
80103e4f:	e8 bc 0b 00 00       	call   80104a10 <safestrcpy>
    pid = np->pid;
80103e54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e57:	8b 5a 10             	mov    0x10(%edx),%ebx
    acquire(&ptable.lock);
80103e5a:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
80103e61:	e8 fa 08 00 00       	call   80104760 <acquire>
    np->state = RUNNABLE;
80103e66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e69:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
    release(&ptable.lock);
80103e70:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
80103e77:	e8 84 08 00 00       	call   80104700 <release>
    return pid;
80103e7c:	83 c4 10             	add    $0x10,%esp
}
80103e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e82:	89 d8                	mov    %ebx,%eax
80103e84:	5b                   	pop    %ebx
80103e85:	5e                   	pop    %esi
80103e86:	5f                   	pop    %edi
80103e87:	5d                   	pop    %ebp
80103e88:	c3                   	ret
        kfree(np->kstack);
80103e89:	83 ec 0c             	sub    $0xc,%esp
80103e8c:	ff 72 08             	push   0x8(%edx)
80103e8f:	e8 dc e6 ff ff       	call   80102570 <kfree>
        np->kstack = 0;
80103e94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        return -1;
80103e97:	83 c4 10             	add    $0x10,%esp
        np->kstack = 0;
80103e9a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
        np->state = UNUSED;
80103ea1:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
        return -1;
80103ea8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ead:	eb d0                	jmp    80103e7f <fork+0xff>
80103eaf:	90                   	nop

80103eb0 <sched>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
  pushcli();
80103eb5:	e8 56 07 00 00       	call   80104610 <pushcli>
  c = mycpu();
80103eba:	e8 71 fb ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103ebf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ec5:	e8 96 07 00 00       	call   80104660 <popcli>
  if(!holding(&ptable.lock))
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 60 36 11 80       	push   $0x80113660
80103ed2:	e8 e9 07 00 00       	call   801046c0 <holding>
80103ed7:	83 c4 10             	add    $0x10,%esp
80103eda:	85 c0                	test   %eax,%eax
80103edc:	74 4f                	je     80103f2d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103ede:	e8 4d fb ff ff       	call   80103a30 <mycpu>
80103ee3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eea:	75 68                	jne    80103f54 <sched+0xa4>
  if(p->state == RUNNING)
80103eec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ef0:	74 55                	je     80103f47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ef2:	9c                   	pushf
80103ef3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ef4:	f6 c4 02             	test   $0x2,%ah
80103ef7:	75 41                	jne    80103f3a <sched+0x8a>
  intena = mycpu()->intena;
80103ef9:	e8 32 fb ff ff       	call   80103a30 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103efe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f07:	e8 24 fb ff ff       	call   80103a30 <mycpu>
80103f0c:	83 ec 08             	sub    $0x8,%esp
80103f0f:	ff 70 04             	push   0x4(%eax)
80103f12:	53                   	push   %ebx
80103f13:	e8 53 0b 00 00       	call   80104a6b <swtch>
  mycpu()->intena = intena;
80103f18:	e8 13 fb ff ff       	call   80103a30 <mycpu>
}
80103f1d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f29:	5b                   	pop    %ebx
80103f2a:	5e                   	pop    %esi
80103f2b:	5d                   	pop    %ebp
80103f2c:	c3                   	ret
    panic("sched ptable.lock");
80103f2d:	83 ec 0c             	sub    $0xc,%esp
80103f30:	68 c8 7c 10 80       	push   $0x80107cc8
80103f35:	e8 46 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 f4 7c 10 80       	push   $0x80107cf4
80103f42:	e8 39 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	68 e6 7c 10 80       	push   $0x80107ce6
80103f4f:	e8 2c c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	68 da 7c 10 80       	push   $0x80107cda
80103f5c:	e8 1f c4 ff ff       	call   80100380 <panic>
80103f61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f68:	00 
80103f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f70 <exit>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	57                   	push   %edi
80103f74:	56                   	push   %esi
80103f75:	53                   	push   %ebx
80103f76:	83 ec 0c             	sub    $0xc,%esp
    struct proc *curproc = myproc();
80103f79:	e8 32 fb ff ff       	call   80103ab0 <myproc>
    if (curproc == initproc)
80103f7e:	39 05 94 76 11 80    	cmp    %eax,0x80117694
80103f84:	0f 84 27 01 00 00    	je     801040b1 <exit+0x141>
80103f8a:	89 c3                	mov    %eax,%ebx
80103f8c:	8d 70 28             	lea    0x28(%eax),%esi
80103f8f:	8d 78 68             	lea    0x68(%eax),%edi
80103f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (curproc->ofile[fd]) {
80103f98:	8b 06                	mov    (%esi),%eax
80103f9a:	85 c0                	test   %eax,%eax
80103f9c:	74 12                	je     80103fb0 <exit+0x40>
            fileclose(curproc->ofile[fd]);
80103f9e:	83 ec 0c             	sub    $0xc,%esp
80103fa1:	50                   	push   %eax
80103fa2:	e8 39 d0 ff ff       	call   80100fe0 <fileclose>
            curproc->ofile[fd] = 0;
80103fa7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103fad:	83 c4 10             	add    $0x10,%esp
    for (fd = 0; fd < NOFILE; fd++) {
80103fb0:	83 c6 04             	add    $0x4,%esi
80103fb3:	39 fe                	cmp    %edi,%esi
80103fb5:	75 e1                	jne    80103f98 <exit+0x28>
    begin_op();
80103fb7:	e8 54 ee ff ff       	call   80102e10 <begin_op>
    iput(curproc->cwd);
80103fbc:	83 ec 0c             	sub    $0xc,%esp
80103fbf:	ff 73 68             	push   0x68(%ebx)
80103fc2:	e8 d9 d9 ff ff       	call   801019a0 <iput>
    end_op();
80103fc7:	e8 b4 ee ff ff       	call   80102e80 <end_op>
    curproc->cwd = 0;
80103fcc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
    acquire(&ptable.lock);
80103fd3:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
80103fda:	e8 81 07 00 00       	call   80104760 <acquire>
    for (int i = 0; i < NUMSIGNALS; i++) {
80103fdf:	8d 43 7c             	lea    0x7c(%ebx),%eax
80103fe2:	8d 93 fc 00 00 00    	lea    0xfc(%ebx),%edx
80103fe8:	83 c4 10             	add    $0x10,%esp
80103feb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        curproc->signal_handlers[i] = 0;
80103ff0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (int i = 0; i < NUMSIGNALS; i++) {
80103ff6:	83 c0 08             	add    $0x8,%eax
        curproc->signal_handlers[i] = 0;
80103ff9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for (int i = 0; i < NUMSIGNALS; i++) {
80104000:	39 c2                	cmp    %eax,%edx
80104002:	75 ec                	jne    80103ff0 <exit+0x80>
    wakeup1(curproc->parent);
80104004:	8b 53 14             	mov    0x14(%ebx),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104007:	b8 94 36 11 80       	mov    $0x80113694,%eax
8010400c:	eb 0e                	jmp    8010401c <exit+0xac>
8010400e:	66 90                	xchg   %ax,%ax
80104010:	05 00 01 00 00       	add    $0x100,%eax
80104015:	3d 94 76 11 80       	cmp    $0x80117694,%eax
8010401a:	74 1e                	je     8010403a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
8010401c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104020:	75 ee                	jne    80104010 <exit+0xa0>
80104022:	3b 50 20             	cmp    0x20(%eax),%edx
80104025:	75 e9                	jne    80104010 <exit+0xa0>
      p->state = RUNNABLE;
80104027:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010402e:	05 00 01 00 00       	add    $0x100,%eax
80104033:	3d 94 76 11 80       	cmp    $0x80117694,%eax
80104038:	75 e2                	jne    8010401c <exit+0xac>
            p->parent = initproc;
8010403a:	8b 0d 94 76 11 80    	mov    0x80117694,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104040:	ba 94 36 11 80       	mov    $0x80113694,%edx
80104045:	eb 17                	jmp    8010405e <exit+0xee>
80104047:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010404e:	00 
8010404f:	90                   	nop
80104050:	81 c2 00 01 00 00    	add    $0x100,%edx
80104056:	81 fa 94 76 11 80    	cmp    $0x80117694,%edx
8010405c:	74 3a                	je     80104098 <exit+0x128>
        if (p->parent == curproc) {
8010405e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104061:	75 ed                	jne    80104050 <exit+0xe0>
            if (p->state == ZOMBIE)
80104063:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
80104067:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
8010406a:	75 e4                	jne    80104050 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010406c:	b8 94 36 11 80       	mov    $0x80113694,%eax
80104071:	eb 11                	jmp    80104084 <exit+0x114>
80104073:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104078:	05 00 01 00 00       	add    $0x100,%eax
8010407d:	3d 94 76 11 80       	cmp    $0x80117694,%eax
80104082:	74 cc                	je     80104050 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80104084:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104088:	75 ee                	jne    80104078 <exit+0x108>
8010408a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010408d:	75 e9                	jne    80104078 <exit+0x108>
      p->state = RUNNABLE;
8010408f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104096:	eb e0                	jmp    80104078 <exit+0x108>
    curproc->state = ZOMBIE;
80104098:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
    sched();
8010409f:	e8 0c fe ff ff       	call   80103eb0 <sched>
    panic("zombie exit");
801040a4:	83 ec 0c             	sub    $0xc,%esp
801040a7:	68 15 7d 10 80       	push   $0x80107d15
801040ac:	e8 cf c2 ff ff       	call   80100380 <panic>
        panic("init exiting");
801040b1:	83 ec 0c             	sub    $0xc,%esp
801040b4:	68 08 7d 10 80       	push   $0x80107d08
801040b9:	e8 c2 c2 ff ff       	call   80100380 <panic>
801040be:	66 90                	xchg   %ax,%ax

801040c0 <wait>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	56                   	push   %esi
801040c4:	53                   	push   %ebx
  pushcli();
801040c5:	e8 46 05 00 00       	call   80104610 <pushcli>
  c = mycpu();
801040ca:	e8 61 f9 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
801040cf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040d5:	e8 86 05 00 00       	call   80104660 <popcli>
  acquire(&ptable.lock);
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	68 60 36 11 80       	push   $0x80113660
801040e2:	e8 79 06 00 00       	call   80104760 <acquire>
801040e7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040ea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ec:	bb 94 36 11 80       	mov    $0x80113694,%ebx
801040f1:	eb 13                	jmp    80104106 <wait+0x46>
801040f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801040f8:	81 c3 00 01 00 00    	add    $0x100,%ebx
801040fe:	81 fb 94 76 11 80    	cmp    $0x80117694,%ebx
80104104:	74 1e                	je     80104124 <wait+0x64>
      if(p->parent != curproc)
80104106:	39 73 14             	cmp    %esi,0x14(%ebx)
80104109:	75 ed                	jne    801040f8 <wait+0x38>
      if(p->state == ZOMBIE){
8010410b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010410f:	74 5f                	je     80104170 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104111:	81 c3 00 01 00 00    	add    $0x100,%ebx
      havekids = 1;
80104117:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411c:	81 fb 94 76 11 80    	cmp    $0x80117694,%ebx
80104122:	75 e2                	jne    80104106 <wait+0x46>
    if(!havekids || curproc->killed){
80104124:	85 c0                	test   %eax,%eax
80104126:	0f 84 9a 00 00 00    	je     801041c6 <wait+0x106>
8010412c:	8b 46 24             	mov    0x24(%esi),%eax
8010412f:	85 c0                	test   %eax,%eax
80104131:	0f 85 8f 00 00 00    	jne    801041c6 <wait+0x106>
  pushcli();
80104137:	e8 d4 04 00 00       	call   80104610 <pushcli>
  c = mycpu();
8010413c:	e8 ef f8 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80104141:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104147:	e8 14 05 00 00       	call   80104660 <popcli>
  if(p == 0)
8010414c:	85 db                	test   %ebx,%ebx
8010414e:	0f 84 89 00 00 00    	je     801041dd <wait+0x11d>
  p->chan = chan;
80104154:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104157:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010415e:	e8 4d fd ff ff       	call   80103eb0 <sched>
  p->chan = 0;
80104163:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010416a:	e9 7b ff ff ff       	jmp    801040ea <wait+0x2a>
8010416f:	90                   	nop
        kfree(p->kstack);
80104170:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104173:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104176:	ff 73 08             	push   0x8(%ebx)
80104179:	e8 f2 e3 ff ff       	call   80102570 <kfree>
        p->kstack = 0;
8010417e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104185:	5a                   	pop    %edx
80104186:	ff 73 04             	push   0x4(%ebx)
80104189:	e8 b2 34 00 00       	call   80107640 <freevm>
        p->pid = 0;
8010418e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104195:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010419c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041a0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041a7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041ae:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
801041b5:	e8 46 05 00 00       	call   80104700 <release>
        return pid;
801041ba:	83 c4 10             	add    $0x10,%esp
}
801041bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041c0:	89 f0                	mov    %esi,%eax
801041c2:	5b                   	pop    %ebx
801041c3:	5e                   	pop    %esi
801041c4:	5d                   	pop    %ebp
801041c5:	c3                   	ret
      release(&ptable.lock);
801041c6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041c9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041ce:	68 60 36 11 80       	push   $0x80113660
801041d3:	e8 28 05 00 00       	call   80104700 <release>
      return -1;
801041d8:	83 c4 10             	add    $0x10,%esp
801041db:	eb e0                	jmp    801041bd <wait+0xfd>
    panic("sleep");
801041dd:	83 ec 0c             	sub    $0xc,%esp
801041e0:	68 21 7d 10 80       	push   $0x80107d21
801041e5:	e8 96 c1 ff ff       	call   80100380 <panic>
801041ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041f0 <yield>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	53                   	push   %ebx
801041f4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801041f7:	68 60 36 11 80       	push   $0x80113660
801041fc:	e8 5f 05 00 00       	call   80104760 <acquire>
  pushcli();
80104201:	e8 0a 04 00 00       	call   80104610 <pushcli>
  c = mycpu();
80104206:	e8 25 f8 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010420b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104211:	e8 4a 04 00 00       	call   80104660 <popcli>
  myproc()->state = RUNNABLE;
80104216:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010421d:	e8 8e fc ff ff       	call   80103eb0 <sched>
  release(&ptable.lock);
80104222:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
80104229:	e8 d2 04 00 00       	call   80104700 <release>
}
8010422e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104231:	83 c4 10             	add    $0x10,%esp
80104234:	c9                   	leave
80104235:	c3                   	ret
80104236:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010423d:	00 
8010423e:	66 90                	xchg   %ax,%ax

80104240 <sleep>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	57                   	push   %edi
80104244:	56                   	push   %esi
80104245:	53                   	push   %ebx
80104246:	83 ec 0c             	sub    $0xc,%esp
80104249:	8b 7d 08             	mov    0x8(%ebp),%edi
8010424c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010424f:	e8 bc 03 00 00       	call   80104610 <pushcli>
  c = mycpu();
80104254:	e8 d7 f7 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80104259:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010425f:	e8 fc 03 00 00       	call   80104660 <popcli>
  if(p == 0)
80104264:	85 db                	test   %ebx,%ebx
80104266:	0f 84 87 00 00 00    	je     801042f3 <sleep+0xb3>
  if(lk == 0)
8010426c:	85 f6                	test   %esi,%esi
8010426e:	74 76                	je     801042e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104270:	81 fe 60 36 11 80    	cmp    $0x80113660,%esi
80104276:	74 50                	je     801042c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104278:	83 ec 0c             	sub    $0xc,%esp
8010427b:	68 60 36 11 80       	push   $0x80113660
80104280:	e8 db 04 00 00       	call   80104760 <acquire>
    release(lk);
80104285:	89 34 24             	mov    %esi,(%esp)
80104288:	e8 73 04 00 00       	call   80104700 <release>
  p->chan = chan;
8010428d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104290:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104297:	e8 14 fc ff ff       	call   80103eb0 <sched>
  p->chan = 0;
8010429c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042a3:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
801042aa:	e8 51 04 00 00       	call   80104700 <release>
    acquire(lk);
801042af:	89 75 08             	mov    %esi,0x8(%ebp)
801042b2:	83 c4 10             	add    $0x10,%esp
}
801042b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b8:	5b                   	pop    %ebx
801042b9:	5e                   	pop    %esi
801042ba:	5f                   	pop    %edi
801042bb:	5d                   	pop    %ebp
    acquire(lk);
801042bc:	e9 9f 04 00 00       	jmp    80104760 <acquire>
801042c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042d2:	e8 d9 fb ff ff       	call   80103eb0 <sched>
  p->chan = 0;
801042d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e1:	5b                   	pop    %ebx
801042e2:	5e                   	pop    %esi
801042e3:	5f                   	pop    %edi
801042e4:	5d                   	pop    %ebp
801042e5:	c3                   	ret
    panic("sleep without lk");
801042e6:	83 ec 0c             	sub    $0xc,%esp
801042e9:	68 27 7d 10 80       	push   $0x80107d27
801042ee:	e8 8d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
801042f3:	83 ec 0c             	sub    $0xc,%esp
801042f6:	68 21 7d 10 80       	push   $0x80107d21
801042fb:	e8 80 c0 ff ff       	call   80100380 <panic>

80104300 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 10             	sub    $0x10,%esp
80104307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010430a:	68 60 36 11 80       	push   $0x80113660
8010430f:	e8 4c 04 00 00       	call   80104760 <acquire>
80104314:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104317:	b8 94 36 11 80       	mov    $0x80113694,%eax
8010431c:	eb 0e                	jmp    8010432c <wakeup+0x2c>
8010431e:	66 90                	xchg   %ax,%ax
80104320:	05 00 01 00 00       	add    $0x100,%eax
80104325:	3d 94 76 11 80       	cmp    $0x80117694,%eax
8010432a:	74 1e                	je     8010434a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010432c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104330:	75 ee                	jne    80104320 <wakeup+0x20>
80104332:	3b 58 20             	cmp    0x20(%eax),%ebx
80104335:	75 e9                	jne    80104320 <wakeup+0x20>
      p->state = RUNNABLE;
80104337:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010433e:	05 00 01 00 00       	add    $0x100,%eax
80104343:	3d 94 76 11 80       	cmp    $0x80117694,%eax
80104348:	75 e2                	jne    8010432c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010434a:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80104351:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104354:	c9                   	leave
  release(&ptable.lock);
80104355:	e9 a6 03 00 00       	jmp    80104700 <release>
8010435a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104360 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 10             	sub    $0x10,%esp
80104367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010436a:	68 60 36 11 80       	push   $0x80113660
8010436f:	e8 ec 03 00 00       	call   80104760 <acquire>
80104374:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104377:	b8 94 36 11 80       	mov    $0x80113694,%eax
8010437c:	eb 0e                	jmp    8010438c <kill+0x2c>
8010437e:	66 90                	xchg   %ax,%ax
80104380:	05 00 01 00 00       	add    $0x100,%eax
80104385:	3d 94 76 11 80       	cmp    $0x80117694,%eax
8010438a:	74 34                	je     801043c0 <kill+0x60>
    if(p->pid == pid){
8010438c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010438f:	75 ef                	jne    80104380 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104391:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104395:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010439c:	75 07                	jne    801043a5 <kill+0x45>
        p->state = RUNNABLE;
8010439e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043a5:	83 ec 0c             	sub    $0xc,%esp
801043a8:	68 60 36 11 80       	push   $0x80113660
801043ad:	e8 4e 03 00 00       	call   80104700 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043b5:	83 c4 10             	add    $0x10,%esp
801043b8:	31 c0                	xor    %eax,%eax
}
801043ba:	c9                   	leave
801043bb:	c3                   	ret
801043bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801043c0:	83 ec 0c             	sub    $0xc,%esp
801043c3:	68 60 36 11 80       	push   $0x80113660
801043c8:	e8 33 03 00 00       	call   80104700 <release>
}
801043cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043d0:	83 c4 10             	add    $0x10,%esp
801043d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043d8:	c9                   	leave
801043d9:	c3                   	ret
801043da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043e0 <procdump>:

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	bb 00 37 11 80       	mov    $0x80113700,%ebx
801043e9:	83 ec 04             	sub    $0x4,%esp
801043ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  };
  struct proc *p;


  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->state == UNUSED)
801043f0:	8b 43 a0             	mov    -0x60(%ebx),%eax
801043f3:	85 c0                	test   %eax,%eax
801043f5:	74 33                	je     8010442a <procdump+0x4a>
      continue;

    const char *state = (p->state >= 0 && p->state < NELEM(states)) ? states[p->state] : "???";
801043f7:	b9 38 7d 10 80       	mov    $0x80107d38,%ecx
801043fc:	83 f8 05             	cmp    $0x5,%eax
801043ff:	77 07                	ja     80104408 <procdump+0x28>
80104401:	8b 0c 85 40 84 10 80 	mov    -0x7fef7bc0(,%eax,4),%ecx
    int ppid = (p->parent) ? p->parent->pid : 0;
80104408:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010440b:	31 c0                	xor    %eax,%eax
8010440d:	85 d2                	test   %edx,%edx
8010440f:	74 03                	je     80104414 <procdump+0x34>
80104411:	8b 42 10             	mov    0x10(%edx),%eax

    cprintf("%d\t%d\t%s\t%s\n", p->pid, ppid, state, p->name);
80104414:	83 ec 0c             	sub    $0xc,%esp
80104417:	53                   	push   %ebx
80104418:	51                   	push   %ecx
80104419:	50                   	push   %eax
8010441a:	ff 73 a4             	push   -0x5c(%ebx)
8010441d:	68 3c 7d 10 80       	push   $0x80107d3c
80104422:	e8 89 c2 ff ff       	call   801006b0 <cprintf>
80104427:	83 c4 20             	add    $0x20,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010442a:	81 c3 00 01 00 00    	add    $0x100,%ebx
80104430:	81 fb 00 77 11 80    	cmp    $0x80117700,%ebx
80104436:	75 b8                	jne    801043f0 <procdump+0x10>
  }
80104438:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010443b:	c9                   	leave
8010443c:	c3                   	ret
8010443d:	66 90                	xchg   %ax,%ax
8010443f:	90                   	nop

80104440 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	53                   	push   %ebx
80104444:	83 ec 0c             	sub    $0xc,%esp
80104447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010444a:	68 78 7d 10 80       	push   $0x80107d78
8010444f:	8d 43 04             	lea    0x4(%ebx),%eax
80104452:	50                   	push   %eax
80104453:	e8 18 01 00 00       	call   80104570 <initlock>
  lk->name = name;
80104458:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010445b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104461:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104464:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010446b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010446e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104471:	c9                   	leave
80104472:	c3                   	ret
80104473:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010447a:	00 
8010447b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104480 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104488:	8d 73 04             	lea    0x4(%ebx),%esi
8010448b:	83 ec 0c             	sub    $0xc,%esp
8010448e:	56                   	push   %esi
8010448f:	e8 cc 02 00 00       	call   80104760 <acquire>
  while (lk->locked) {
80104494:	8b 13                	mov    (%ebx),%edx
80104496:	83 c4 10             	add    $0x10,%esp
80104499:	85 d2                	test   %edx,%edx
8010449b:	74 16                	je     801044b3 <acquiresleep+0x33>
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801044a0:	83 ec 08             	sub    $0x8,%esp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
801044a5:	e8 96 fd ff ff       	call   80104240 <sleep>
  while (lk->locked) {
801044aa:	8b 03                	mov    (%ebx),%eax
801044ac:	83 c4 10             	add    $0x10,%esp
801044af:	85 c0                	test   %eax,%eax
801044b1:	75 ed                	jne    801044a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801044b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044b9:	e8 f2 f5 ff ff       	call   80103ab0 <myproc>
801044be:	8b 40 10             	mov    0x10(%eax),%eax
801044c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044ca:	5b                   	pop    %ebx
801044cb:	5e                   	pop    %esi
801044cc:	5d                   	pop    %ebp
  release(&lk->lk);
801044cd:	e9 2e 02 00 00       	jmp    80104700 <release>
801044d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044d9:	00 
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	56                   	push   %esi
801044e4:	53                   	push   %ebx
801044e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044e8:	8d 73 04             	lea    0x4(%ebx),%esi
801044eb:	83 ec 0c             	sub    $0xc,%esp
801044ee:	56                   	push   %esi
801044ef:	e8 6c 02 00 00       	call   80104760 <acquire>
  lk->locked = 0;
801044f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104501:	89 1c 24             	mov    %ebx,(%esp)
80104504:	e8 f7 fd ff ff       	call   80104300 <wakeup>
  release(&lk->lk);
80104509:	89 75 08             	mov    %esi,0x8(%ebp)
8010450c:	83 c4 10             	add    $0x10,%esp
}
8010450f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104512:	5b                   	pop    %ebx
80104513:	5e                   	pop    %esi
80104514:	5d                   	pop    %ebp
  release(&lk->lk);
80104515:	e9 e6 01 00 00       	jmp    80104700 <release>
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104520 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	31 ff                	xor    %edi,%edi
80104526:	56                   	push   %esi
80104527:	53                   	push   %ebx
80104528:	83 ec 18             	sub    $0x18,%esp
8010452b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010452e:	8d 73 04             	lea    0x4(%ebx),%esi
80104531:	56                   	push   %esi
80104532:	e8 29 02 00 00       	call   80104760 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104537:	8b 03                	mov    (%ebx),%eax
80104539:	83 c4 10             	add    $0x10,%esp
8010453c:	85 c0                	test   %eax,%eax
8010453e:	75 18                	jne    80104558 <holdingsleep+0x38>
  release(&lk->lk);
80104540:	83 ec 0c             	sub    $0xc,%esp
80104543:	56                   	push   %esi
80104544:	e8 b7 01 00 00       	call   80104700 <release>
  return r;
}
80104549:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010454c:	89 f8                	mov    %edi,%eax
8010454e:	5b                   	pop    %ebx
8010454f:	5e                   	pop    %esi
80104550:	5f                   	pop    %edi
80104551:	5d                   	pop    %ebp
80104552:	c3                   	ret
80104553:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104558:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010455b:	e8 50 f5 ff ff       	call   80103ab0 <myproc>
80104560:	39 58 10             	cmp    %ebx,0x10(%eax)
80104563:	0f 94 c0             	sete   %al
80104566:	0f b6 c0             	movzbl %al,%eax
80104569:	89 c7                	mov    %eax,%edi
8010456b:	eb d3                	jmp    80104540 <holdingsleep+0x20>
8010456d:	66 90                	xchg   %ax,%ax
8010456f:	90                   	nop

80104570 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104576:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010457f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104582:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104589:	5d                   	pop    %ebp
8010458a:	c3                   	ret
8010458b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104590 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	8b 45 08             	mov    0x8(%ebp),%eax
80104597:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010459a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010459d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801045a2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801045a7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045ac:	76 10                	jbe    801045be <getcallerpcs+0x2e>
801045ae:	eb 28                	jmp    801045d8 <getcallerpcs+0x48>
801045b0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801045b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045bc:	77 1a                	ja     801045d8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045be:	8b 5a 04             	mov    0x4(%edx),%ebx
801045c1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801045c4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801045c7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801045c9:	83 f8 0a             	cmp    $0xa,%eax
801045cc:	75 e2                	jne    801045b0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801045ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d1:	c9                   	leave
801045d2:	c3                   	ret
801045d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801045d8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801045db:	83 c1 28             	add    $0x28,%ecx
801045de:	89 ca                	mov    %ecx,%edx
801045e0:	29 c2                	sub    %eax,%edx
801045e2:	83 e2 04             	and    $0x4,%edx
801045e5:	74 11                	je     801045f8 <getcallerpcs+0x68>
    pcs[i] = 0;
801045e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045ed:	83 c0 04             	add    $0x4,%eax
801045f0:	39 c1                	cmp    %eax,%ecx
801045f2:	74 da                	je     801045ce <getcallerpcs+0x3e>
801045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801045f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045fe:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104601:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104608:	39 c1                	cmp    %eax,%ecx
8010460a:	75 ec                	jne    801045f8 <getcallerpcs+0x68>
8010460c:	eb c0                	jmp    801045ce <getcallerpcs+0x3e>
8010460e:	66 90                	xchg   %ax,%ax

80104610 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	83 ec 04             	sub    $0x4,%esp
80104617:	9c                   	pushf
80104618:	5b                   	pop    %ebx
  asm volatile("cli");
80104619:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010461a:	e8 11 f4 ff ff       	call   80103a30 <mycpu>
8010461f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104625:	85 c0                	test   %eax,%eax
80104627:	74 17                	je     80104640 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104629:	e8 02 f4 ff ff       	call   80103a30 <mycpu>
8010462e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104635:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104638:	c9                   	leave
80104639:	c3                   	ret
8010463a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104640:	e8 eb f3 ff ff       	call   80103a30 <mycpu>
80104645:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010464b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104651:	eb d6                	jmp    80104629 <pushcli+0x19>
80104653:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010465a:	00 
8010465b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104660 <popcli>:

void
popcli(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104666:	9c                   	pushf
80104667:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104668:	f6 c4 02             	test   $0x2,%ah
8010466b:	75 35                	jne    801046a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010466d:	e8 be f3 ff ff       	call   80103a30 <mycpu>
80104672:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104679:	78 34                	js     801046af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010467b:	e8 b0 f3 ff ff       	call   80103a30 <mycpu>
80104680:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104686:	85 d2                	test   %edx,%edx
80104688:	74 06                	je     80104690 <popcli+0x30>
    sti();
}
8010468a:	c9                   	leave
8010468b:	c3                   	ret
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104690:	e8 9b f3 ff ff       	call   80103a30 <mycpu>
80104695:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010469b:	85 c0                	test   %eax,%eax
8010469d:	74 eb                	je     8010468a <popcli+0x2a>
  asm volatile("sti");
8010469f:	fb                   	sti
}
801046a0:	c9                   	leave
801046a1:	c3                   	ret
    panic("popcli - interruptible");
801046a2:	83 ec 0c             	sub    $0xc,%esp
801046a5:	68 83 7d 10 80       	push   $0x80107d83
801046aa:	e8 d1 bc ff ff       	call   80100380 <panic>
    panic("popcli");
801046af:	83 ec 0c             	sub    $0xc,%esp
801046b2:	68 9a 7d 10 80       	push   $0x80107d9a
801046b7:	e8 c4 bc ff ff       	call   80100380 <panic>
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <holding>:
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	8b 75 08             	mov    0x8(%ebp),%esi
801046c8:	31 db                	xor    %ebx,%ebx
  pushcli();
801046ca:	e8 41 ff ff ff       	call   80104610 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046cf:	8b 06                	mov    (%esi),%eax
801046d1:	85 c0                	test   %eax,%eax
801046d3:	75 0b                	jne    801046e0 <holding+0x20>
  popcli();
801046d5:	e8 86 ff ff ff       	call   80104660 <popcli>
}
801046da:	89 d8                	mov    %ebx,%eax
801046dc:	5b                   	pop    %ebx
801046dd:	5e                   	pop    %esi
801046de:	5d                   	pop    %ebp
801046df:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801046e0:	8b 5e 08             	mov    0x8(%esi),%ebx
801046e3:	e8 48 f3 ff ff       	call   80103a30 <mycpu>
801046e8:	39 c3                	cmp    %eax,%ebx
801046ea:	0f 94 c3             	sete   %bl
  popcli();
801046ed:	e8 6e ff ff ff       	call   80104660 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801046f2:	0f b6 db             	movzbl %bl,%ebx
}
801046f5:	89 d8                	mov    %ebx,%eax
801046f7:	5b                   	pop    %ebx
801046f8:	5e                   	pop    %esi
801046f9:	5d                   	pop    %ebp
801046fa:	c3                   	ret
801046fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104700 <release>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
80104705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104708:	e8 03 ff ff ff       	call   80104610 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010470d:	8b 03                	mov    (%ebx),%eax
8010470f:	85 c0                	test   %eax,%eax
80104711:	75 15                	jne    80104728 <release+0x28>
  popcli();
80104713:	e8 48 ff ff ff       	call   80104660 <popcli>
    panic("release");
80104718:	83 ec 0c             	sub    $0xc,%esp
8010471b:	68 a1 7d 10 80       	push   $0x80107da1
80104720:	e8 5b bc ff ff       	call   80100380 <panic>
80104725:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104728:	8b 73 08             	mov    0x8(%ebx),%esi
8010472b:	e8 00 f3 ff ff       	call   80103a30 <mycpu>
80104730:	39 c6                	cmp    %eax,%esi
80104732:	75 df                	jne    80104713 <release+0x13>
  popcli();
80104734:	e8 27 ff ff ff       	call   80104660 <popcli>
  lk->pcs[0] = 0;
80104739:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104740:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104747:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010474c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104752:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104755:	5b                   	pop    %ebx
80104756:	5e                   	pop    %esi
80104757:	5d                   	pop    %ebp
  popcli();
80104758:	e9 03 ff ff ff       	jmp    80104660 <popcli>
8010475d:	8d 76 00             	lea    0x0(%esi),%esi

80104760 <acquire>:
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	53                   	push   %ebx
80104764:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104767:	e8 a4 fe ff ff       	call   80104610 <pushcli>
  if(holding(lk))
8010476c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010476f:	e8 9c fe ff ff       	call   80104610 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104774:	8b 03                	mov    (%ebx),%eax
80104776:	85 c0                	test   %eax,%eax
80104778:	0f 85 b2 00 00 00    	jne    80104830 <acquire+0xd0>
  popcli();
8010477e:	e8 dd fe ff ff       	call   80104660 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104783:	b9 01 00 00 00       	mov    $0x1,%ecx
80104788:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010478f:	00 
  while(xchg(&lk->locked, 1) != 0)
80104790:	8b 55 08             	mov    0x8(%ebp),%edx
80104793:	89 c8                	mov    %ecx,%eax
80104795:	f0 87 02             	lock xchg %eax,(%edx)
80104798:	85 c0                	test   %eax,%eax
8010479a:	75 f4                	jne    80104790 <acquire+0x30>
  __sync_synchronize();
8010479c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047a4:	e8 87 f2 ff ff       	call   80103a30 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801047ac:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801047ae:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047b1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801047b7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801047bc:	77 32                	ja     801047f0 <acquire+0x90>
  ebp = (uint*)v - 2;
801047be:	89 e8                	mov    %ebp,%eax
801047c0:	eb 14                	jmp    801047d6 <acquire+0x76>
801047c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047c8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047ce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047d4:	77 1a                	ja     801047f0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801047d6:	8b 58 04             	mov    0x4(%eax),%ebx
801047d9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801047dd:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047e0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047e2:	83 fa 0a             	cmp    $0xa,%edx
801047e5:	75 e1                	jne    801047c8 <acquire+0x68>
}
801047e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047ea:	c9                   	leave
801047eb:	c3                   	ret
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
801047f4:	83 c1 34             	add    $0x34,%ecx
801047f7:	89 ca                	mov    %ecx,%edx
801047f9:	29 c2                	sub    %eax,%edx
801047fb:	83 e2 04             	and    $0x4,%edx
801047fe:	74 10                	je     80104810 <acquire+0xb0>
    pcs[i] = 0;
80104800:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104806:	83 c0 04             	add    $0x4,%eax
80104809:	39 c1                	cmp    %eax,%ecx
8010480b:	74 da                	je     801047e7 <acquire+0x87>
8010480d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104810:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104816:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104819:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104820:	39 c1                	cmp    %eax,%ecx
80104822:	75 ec                	jne    80104810 <acquire+0xb0>
80104824:	eb c1                	jmp    801047e7 <acquire+0x87>
80104826:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010482d:	00 
8010482e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104830:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104833:	e8 f8 f1 ff ff       	call   80103a30 <mycpu>
80104838:	39 c3                	cmp    %eax,%ebx
8010483a:	0f 85 3e ff ff ff    	jne    8010477e <acquire+0x1e>
  popcli();
80104840:	e8 1b fe ff ff       	call   80104660 <popcli>
    panic("acquire");
80104845:	83 ec 0c             	sub    $0xc,%esp
80104848:	68 a9 7d 10 80       	push   $0x80107da9
8010484d:	e8 2e bb ff ff       	call   80100380 <panic>
80104852:	66 90                	xchg   %ax,%ax
80104854:	66 90                	xchg   %ax,%ax
80104856:	66 90                	xchg   %ax,%ax
80104858:	66 90                	xchg   %ax,%ax
8010485a:	66 90                	xchg   %ax,%ax
8010485c:	66 90                	xchg   %ax,%ax
8010485e:	66 90                	xchg   %ax,%ax

80104860 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	57                   	push   %edi
80104864:	8b 55 08             	mov    0x8(%ebp),%edx
80104867:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010486a:	89 d0                	mov    %edx,%eax
8010486c:	09 c8                	or     %ecx,%eax
8010486e:	a8 03                	test   $0x3,%al
80104870:	75 1e                	jne    80104890 <memset+0x30>
    c &= 0xFF;
80104872:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104876:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104879:	89 d7                	mov    %edx,%edi
8010487b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104881:	fc                   	cld
80104882:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104884:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104887:	89 d0                	mov    %edx,%eax
80104889:	c9                   	leave
8010488a:	c3                   	ret
8010488b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104890:	8b 45 0c             	mov    0xc(%ebp),%eax
80104893:	89 d7                	mov    %edx,%edi
80104895:	fc                   	cld
80104896:	f3 aa                	rep stos %al,%es:(%edi)
80104898:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010489b:	89 d0                	mov    %edx,%eax
8010489d:	c9                   	leave
8010489e:	c3                   	ret
8010489f:	90                   	nop

801048a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	8b 75 10             	mov    0x10(%ebp),%esi
801048a7:	8b 45 08             	mov    0x8(%ebp),%eax
801048aa:	53                   	push   %ebx
801048ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048ae:	85 f6                	test   %esi,%esi
801048b0:	74 2e                	je     801048e0 <memcmp+0x40>
801048b2:	01 c6                	add    %eax,%esi
801048b4:	eb 14                	jmp    801048ca <memcmp+0x2a>
801048b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048bd:	00 
801048be:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048c0:	83 c0 01             	add    $0x1,%eax
801048c3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048c6:	39 f0                	cmp    %esi,%eax
801048c8:	74 16                	je     801048e0 <memcmp+0x40>
    if(*s1 != *s2)
801048ca:	0f b6 08             	movzbl (%eax),%ecx
801048cd:	0f b6 1a             	movzbl (%edx),%ebx
801048d0:	38 d9                	cmp    %bl,%cl
801048d2:	74 ec                	je     801048c0 <memcmp+0x20>
      return *s1 - *s2;
801048d4:	0f b6 c1             	movzbl %cl,%eax
801048d7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048d9:	5b                   	pop    %ebx
801048da:	5e                   	pop    %esi
801048db:	5d                   	pop    %ebp
801048dc:	c3                   	ret
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
801048e0:	5b                   	pop    %ebx
  return 0;
801048e1:	31 c0                	xor    %eax,%eax
}
801048e3:	5e                   	pop    %esi
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret
801048e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048ed:	00 
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	8b 55 08             	mov    0x8(%ebp),%edx
801048f7:	8b 45 10             	mov    0x10(%ebp),%eax
801048fa:	56                   	push   %esi
801048fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048fe:	39 d6                	cmp    %edx,%esi
80104900:	73 26                	jae    80104928 <memmove+0x38>
80104902:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104905:	39 ca                	cmp    %ecx,%edx
80104907:	73 1f                	jae    80104928 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104909:	85 c0                	test   %eax,%eax
8010490b:	74 0f                	je     8010491c <memmove+0x2c>
8010490d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104910:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104914:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104917:	83 e8 01             	sub    $0x1,%eax
8010491a:	73 f4                	jae    80104910 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010491c:	5e                   	pop    %esi
8010491d:	89 d0                	mov    %edx,%eax
8010491f:	5f                   	pop    %edi
80104920:	5d                   	pop    %ebp
80104921:	c3                   	ret
80104922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104928:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010492b:	89 d7                	mov    %edx,%edi
8010492d:	85 c0                	test   %eax,%eax
8010492f:	74 eb                	je     8010491c <memmove+0x2c>
80104931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104938:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104939:	39 ce                	cmp    %ecx,%esi
8010493b:	75 fb                	jne    80104938 <memmove+0x48>
}
8010493d:	5e                   	pop    %esi
8010493e:	89 d0                	mov    %edx,%eax
80104940:	5f                   	pop    %edi
80104941:	5d                   	pop    %ebp
80104942:	c3                   	ret
80104943:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010494a:	00 
8010494b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104950 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104950:	eb 9e                	jmp    801048f0 <memmove>
80104952:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104959:	00 
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104960 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	53                   	push   %ebx
80104964:	8b 55 10             	mov    0x10(%ebp),%edx
80104967:	8b 45 08             	mov    0x8(%ebp),%eax
8010496a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010496d:	85 d2                	test   %edx,%edx
8010496f:	75 16                	jne    80104987 <strncmp+0x27>
80104971:	eb 2d                	jmp    801049a0 <strncmp+0x40>
80104973:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104978:	3a 19                	cmp    (%ecx),%bl
8010497a:	75 12                	jne    8010498e <strncmp+0x2e>
    n--, p++, q++;
8010497c:	83 c0 01             	add    $0x1,%eax
8010497f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104982:	83 ea 01             	sub    $0x1,%edx
80104985:	74 19                	je     801049a0 <strncmp+0x40>
80104987:	0f b6 18             	movzbl (%eax),%ebx
8010498a:	84 db                	test   %bl,%bl
8010498c:	75 ea                	jne    80104978 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010498e:	0f b6 00             	movzbl (%eax),%eax
80104991:	0f b6 11             	movzbl (%ecx),%edx
}
80104994:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104997:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104998:	29 d0                	sub    %edx,%eax
}
8010499a:	c3                   	ret
8010499b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801049a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801049a3:	31 c0                	xor    %eax,%eax
}
801049a5:	c9                   	leave
801049a6:	c3                   	ret
801049a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049ae:	00 
801049af:	90                   	nop

801049b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	56                   	push   %esi
801049b5:	8b 75 08             	mov    0x8(%ebp),%esi
801049b8:	53                   	push   %ebx
801049b9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049bc:	89 f0                	mov    %esi,%eax
801049be:	eb 15                	jmp    801049d5 <strncpy+0x25>
801049c0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049c4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049c7:	83 c0 01             	add    $0x1,%eax
801049ca:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
801049ce:	88 48 ff             	mov    %cl,-0x1(%eax)
801049d1:	84 c9                	test   %cl,%cl
801049d3:	74 13                	je     801049e8 <strncpy+0x38>
801049d5:	89 d3                	mov    %edx,%ebx
801049d7:	83 ea 01             	sub    $0x1,%edx
801049da:	85 db                	test   %ebx,%ebx
801049dc:	7f e2                	jg     801049c0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
801049de:	5b                   	pop    %ebx
801049df:	89 f0                	mov    %esi,%eax
801049e1:	5e                   	pop    %esi
801049e2:	5f                   	pop    %edi
801049e3:	5d                   	pop    %ebp
801049e4:	c3                   	ret
801049e5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
801049e8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
801049eb:	83 e9 01             	sub    $0x1,%ecx
801049ee:	85 d2                	test   %edx,%edx
801049f0:	74 ec                	je     801049de <strncpy+0x2e>
801049f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
801049f8:	83 c0 01             	add    $0x1,%eax
801049fb:	89 ca                	mov    %ecx,%edx
801049fd:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104a01:	29 c2                	sub    %eax,%edx
80104a03:	85 d2                	test   %edx,%edx
80104a05:	7f f1                	jg     801049f8 <strncpy+0x48>
}
80104a07:	5b                   	pop    %ebx
80104a08:	89 f0                	mov    %esi,%eax
80104a0a:	5e                   	pop    %esi
80104a0b:	5f                   	pop    %edi
80104a0c:	5d                   	pop    %ebp
80104a0d:	c3                   	ret
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	8b 55 10             	mov    0x10(%ebp),%edx
80104a17:	8b 75 08             	mov    0x8(%ebp),%esi
80104a1a:	53                   	push   %ebx
80104a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a1e:	85 d2                	test   %edx,%edx
80104a20:	7e 25                	jle    80104a47 <safestrcpy+0x37>
80104a22:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a26:	89 f2                	mov    %esi,%edx
80104a28:	eb 16                	jmp    80104a40 <safestrcpy+0x30>
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a30:	0f b6 08             	movzbl (%eax),%ecx
80104a33:	83 c0 01             	add    $0x1,%eax
80104a36:	83 c2 01             	add    $0x1,%edx
80104a39:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a3c:	84 c9                	test   %cl,%cl
80104a3e:	74 04                	je     80104a44 <safestrcpy+0x34>
80104a40:	39 d8                	cmp    %ebx,%eax
80104a42:	75 ec                	jne    80104a30 <safestrcpy+0x20>
    ;
  *s = 0;
80104a44:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a47:	89 f0                	mov    %esi,%eax
80104a49:	5b                   	pop    %ebx
80104a4a:	5e                   	pop    %esi
80104a4b:	5d                   	pop    %ebp
80104a4c:	c3                   	ret
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi

80104a50 <strlen>:

int
strlen(const char *s)
{
80104a50:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a51:	31 c0                	xor    %eax,%eax
{
80104a53:	89 e5                	mov    %esp,%ebp
80104a55:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a58:	80 3a 00             	cmpb   $0x0,(%edx)
80104a5b:	74 0c                	je     80104a69 <strlen+0x19>
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi
80104a60:	83 c0 01             	add    $0x1,%eax
80104a63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a67:	75 f7                	jne    80104a60 <strlen+0x10>
    ;
  return n;
}
80104a69:	5d                   	pop    %ebp
80104a6a:	c3                   	ret

80104a6b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a6b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a6f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a73:	55                   	push   %ebp
  pushl %ebx
80104a74:	53                   	push   %ebx
  pushl %esi
80104a75:	56                   	push   %esi
  pushl %edi
80104a76:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a77:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a79:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a7b:	5f                   	pop    %edi
  popl %esi
80104a7c:	5e                   	pop    %esi
  popl %ebx
80104a7d:	5b                   	pop    %ebx
  popl %ebp
80104a7e:	5d                   	pop    %ebp
  ret
80104a7f:	c3                   	ret

80104a80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
80104a84:	83 ec 04             	sub    $0x4,%esp
80104a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a8a:	e8 21 f0 ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a8f:	8b 00                	mov    (%eax),%eax
80104a91:	39 c3                	cmp    %eax,%ebx
80104a93:	73 1b                	jae    80104ab0 <fetchint+0x30>
80104a95:	8d 53 04             	lea    0x4(%ebx),%edx
80104a98:	39 d0                	cmp    %edx,%eax
80104a9a:	72 14                	jb     80104ab0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a9f:	8b 13                	mov    (%ebx),%edx
80104aa1:	89 10                	mov    %edx,(%eax)
  return 0;
80104aa3:	31 c0                	xor    %eax,%eax
}
80104aa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aa8:	c9                   	leave
80104aa9:	c3                   	ret
80104aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ab5:	eb ee                	jmp    80104aa5 <fetchint+0x25>
80104ab7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104abe:	00 
80104abf:	90                   	nop

80104ac0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 04             	sub    $0x4,%esp
80104ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104aca:	e8 e1 ef ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz)
80104acf:	3b 18                	cmp    (%eax),%ebx
80104ad1:	73 2d                	jae    80104b00 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ad6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ad8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104ada:	39 d3                	cmp    %edx,%ebx
80104adc:	73 22                	jae    80104b00 <fetchstr+0x40>
80104ade:	89 d8                	mov    %ebx,%eax
80104ae0:	eb 0d                	jmp    80104aef <fetchstr+0x2f>
80104ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ae8:	83 c0 01             	add    $0x1,%eax
80104aeb:	39 d0                	cmp    %edx,%eax
80104aed:	73 11                	jae    80104b00 <fetchstr+0x40>
    if(*s == 0)
80104aef:	80 38 00             	cmpb   $0x0,(%eax)
80104af2:	75 f4                	jne    80104ae8 <fetchstr+0x28>
      return s - *pp;
80104af4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104af6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af9:	c9                   	leave
80104afa:	c3                   	ret
80104afb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b08:	c9                   	leave
80104b09:	c3                   	ret
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b15:	e8 96 ef ff ff       	call   80103ab0 <myproc>
80104b1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b1d:	8b 40 18             	mov    0x18(%eax),%eax
80104b20:	8b 40 44             	mov    0x44(%eax),%eax
80104b23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b26:	e8 85 ef ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b2e:	8b 00                	mov    (%eax),%eax
80104b30:	39 c6                	cmp    %eax,%esi
80104b32:	73 1c                	jae    80104b50 <argint+0x40>
80104b34:	8d 53 08             	lea    0x8(%ebx),%edx
80104b37:	39 d0                	cmp    %edx,%eax
80104b39:	72 15                	jb     80104b50 <argint+0x40>
  *ip = *(int*)(addr);
80104b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b3e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b41:	89 10                	mov    %edx,(%eax)
  return 0;
80104b43:	31 c0                	xor    %eax,%eax
}
80104b45:	5b                   	pop    %ebx
80104b46:	5e                   	pop    %esi
80104b47:	5d                   	pop    %ebp
80104b48:	c3                   	ret
80104b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b55:	eb ee                	jmp    80104b45 <argint+0x35>
80104b57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b5e:	00 
80104b5f:	90                   	nop

80104b60 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	57                   	push   %edi
80104b64:	56                   	push   %esi
80104b65:	53                   	push   %ebx
80104b66:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b69:	e8 42 ef ff ff       	call   80103ab0 <myproc>
80104b6e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b70:	e8 3b ef ff ff       	call   80103ab0 <myproc>
80104b75:	8b 55 08             	mov    0x8(%ebp),%edx
80104b78:	8b 40 18             	mov    0x18(%eax),%eax
80104b7b:	8b 40 44             	mov    0x44(%eax),%eax
80104b7e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b81:	e8 2a ef ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b86:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b89:	8b 00                	mov    (%eax),%eax
80104b8b:	39 c7                	cmp    %eax,%edi
80104b8d:	73 31                	jae    80104bc0 <argptr+0x60>
80104b8f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b92:	39 c8                	cmp    %ecx,%eax
80104b94:	72 2a                	jb     80104bc0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b96:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b99:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b9c:	85 d2                	test   %edx,%edx
80104b9e:	78 20                	js     80104bc0 <argptr+0x60>
80104ba0:	8b 16                	mov    (%esi),%edx
80104ba2:	39 d0                	cmp    %edx,%eax
80104ba4:	73 1a                	jae    80104bc0 <argptr+0x60>
80104ba6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ba9:	01 c3                	add    %eax,%ebx
80104bab:	39 da                	cmp    %ebx,%edx
80104bad:	72 11                	jb     80104bc0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104baf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bb2:	89 02                	mov    %eax,(%edx)
  return 0;
80104bb4:	31 c0                	xor    %eax,%eax
}
80104bb6:	83 c4 0c             	add    $0xc,%esp
80104bb9:	5b                   	pop    %ebx
80104bba:	5e                   	pop    %esi
80104bbb:	5f                   	pop    %edi
80104bbc:	5d                   	pop    %ebp
80104bbd:	c3                   	ret
80104bbe:	66 90                	xchg   %ax,%ax
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc5:	eb ef                	jmp    80104bb6 <argptr+0x56>
80104bc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bce:	00 
80104bcf:	90                   	nop

80104bd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd5:	e8 d6 ee ff ff       	call   80103ab0 <myproc>
80104bda:	8b 55 08             	mov    0x8(%ebp),%edx
80104bdd:	8b 40 18             	mov    0x18(%eax),%eax
80104be0:	8b 40 44             	mov    0x44(%eax),%eax
80104be3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104be6:	e8 c5 ee ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104beb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bee:	8b 00                	mov    (%eax),%eax
80104bf0:	39 c6                	cmp    %eax,%esi
80104bf2:	73 44                	jae    80104c38 <argstr+0x68>
80104bf4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bf7:	39 d0                	cmp    %edx,%eax
80104bf9:	72 3d                	jb     80104c38 <argstr+0x68>
  *ip = *(int*)(addr);
80104bfb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104bfe:	e8 ad ee ff ff       	call   80103ab0 <myproc>
  if(addr >= curproc->sz)
80104c03:	3b 18                	cmp    (%eax),%ebx
80104c05:	73 31                	jae    80104c38 <argstr+0x68>
  *pp = (char*)addr;
80104c07:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c0a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c0c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c0e:	39 d3                	cmp    %edx,%ebx
80104c10:	73 26                	jae    80104c38 <argstr+0x68>
80104c12:	89 d8                	mov    %ebx,%eax
80104c14:	eb 11                	jmp    80104c27 <argstr+0x57>
80104c16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c1d:	00 
80104c1e:	66 90                	xchg   %ax,%ax
80104c20:	83 c0 01             	add    $0x1,%eax
80104c23:	39 d0                	cmp    %edx,%eax
80104c25:	73 11                	jae    80104c38 <argstr+0x68>
    if(*s == 0)
80104c27:	80 38 00             	cmpb   $0x0,(%eax)
80104c2a:	75 f4                	jne    80104c20 <argstr+0x50>
      return s - *pp;
80104c2c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c2e:	5b                   	pop    %ebx
80104c2f:	5e                   	pop    %esi
80104c30:	5d                   	pop    %ebp
80104c31:	c3                   	ret
80104c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c38:	5b                   	pop    %ebx
    return -1;
80104c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c3e:	5e                   	pop    %esi
80104c3f:	5d                   	pop    %ebp
80104c40:	c3                   	ret
80104c41:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c48:	00 
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c50 <syscall>:
[SYS_copy] sys_copy,
};

void
syscall(void)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	53                   	push   %ebx
80104c54:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c57:	e8 54 ee ff ff       	call   80103ab0 <myproc>
80104c5c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c5e:	8b 40 18             	mov    0x18(%eax),%eax
80104c61:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c64:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c67:	83 fa 1d             	cmp    $0x1d,%edx
80104c6a:	77 24                	ja     80104c90 <syscall+0x40>
80104c6c:	8b 14 85 60 84 10 80 	mov    -0x7fef7ba0(,%eax,4),%edx
80104c73:	85 d2                	test   %edx,%edx
80104c75:	74 19                	je     80104c90 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c77:	ff d2                	call   *%edx
80104c79:	89 c2                	mov    %eax,%edx
80104c7b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c7e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c84:	c9                   	leave
80104c85:	c3                   	ret
80104c86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c8d:	00 
80104c8e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104c90:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c91:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c94:	50                   	push   %eax
80104c95:	ff 73 10             	push   0x10(%ebx)
80104c98:	68 b1 7d 10 80       	push   $0x80107db1
80104c9d:	e8 0e ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104ca2:	8b 43 18             	mov    0x18(%ebx),%eax
80104ca5:	83 c4 10             	add    $0x10,%esp
80104ca8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb2:	c9                   	leave
80104cb3:	c3                   	ret
80104cb4:	66 90                	xchg   %ax,%ax
80104cb6:	66 90                	xchg   %ax,%ax
80104cb8:	66 90                	xchg   %ax,%ax
80104cba:	66 90                	xchg   %ax,%ax
80104cbc:	66 90                	xchg   %ax,%ax
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104cc5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104cc8:	53                   	push   %ebx
80104cc9:	83 ec 34             	sub    $0x34,%esp
80104ccc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104ccf:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cd2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104cd5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104cd8:	57                   	push   %edi
80104cd9:	50                   	push   %eax
80104cda:	e8 91 d4 ff ff       	call   80102170 <nameiparent>
80104cdf:	83 c4 10             	add    $0x10,%esp
80104ce2:	85 c0                	test   %eax,%eax
80104ce4:	74 5e                	je     80104d44 <create+0x84>
    return 0;
  ilock(dp);
80104ce6:	83 ec 0c             	sub    $0xc,%esp
80104ce9:	89 c3                	mov    %eax,%ebx
80104ceb:	50                   	push   %eax
80104cec:	e8 7f cb ff ff       	call   80101870 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104cf1:	83 c4 0c             	add    $0xc,%esp
80104cf4:	6a 00                	push   $0x0
80104cf6:	57                   	push   %edi
80104cf7:	53                   	push   %ebx
80104cf8:	e8 c3 d0 ff ff       	call   80101dc0 <dirlookup>
80104cfd:	83 c4 10             	add    $0x10,%esp
80104d00:	89 c6                	mov    %eax,%esi
80104d02:	85 c0                	test   %eax,%eax
80104d04:	74 4a                	je     80104d50 <create+0x90>
    iunlockput(dp);
80104d06:	83 ec 0c             	sub    $0xc,%esp
80104d09:	53                   	push   %ebx
80104d0a:	e8 f1 cd ff ff       	call   80101b00 <iunlockput>
    ilock(ip);
80104d0f:	89 34 24             	mov    %esi,(%esp)
80104d12:	e8 59 cb ff ff       	call   80101870 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d17:	83 c4 10             	add    $0x10,%esp
80104d1a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d1f:	75 17                	jne    80104d38 <create+0x78>
80104d21:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d26:	75 10                	jne    80104d38 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d2b:	89 f0                	mov    %esi,%eax
80104d2d:	5b                   	pop    %ebx
80104d2e:	5e                   	pop    %esi
80104d2f:	5f                   	pop    %edi
80104d30:	5d                   	pop    %ebp
80104d31:	c3                   	ret
80104d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d38:	83 ec 0c             	sub    $0xc,%esp
80104d3b:	56                   	push   %esi
80104d3c:	e8 bf cd ff ff       	call   80101b00 <iunlockput>
    return 0;
80104d41:	83 c4 10             	add    $0x10,%esp
}
80104d44:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d47:	31 f6                	xor    %esi,%esi
}
80104d49:	5b                   	pop    %ebx
80104d4a:	89 f0                	mov    %esi,%eax
80104d4c:	5e                   	pop    %esi
80104d4d:	5f                   	pop    %edi
80104d4e:	5d                   	pop    %ebp
80104d4f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104d50:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d54:	83 ec 08             	sub    $0x8,%esp
80104d57:	50                   	push   %eax
80104d58:	ff 33                	push   (%ebx)
80104d5a:	e8 a1 c9 ff ff       	call   80101700 <ialloc>
80104d5f:	83 c4 10             	add    $0x10,%esp
80104d62:	89 c6                	mov    %eax,%esi
80104d64:	85 c0                	test   %eax,%eax
80104d66:	0f 84 bc 00 00 00    	je     80104e28 <create+0x168>
  ilock(ip);
80104d6c:	83 ec 0c             	sub    $0xc,%esp
80104d6f:	50                   	push   %eax
80104d70:	e8 fb ca ff ff       	call   80101870 <ilock>
  ip->major = major;
80104d75:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d79:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d7d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d81:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d85:	b8 01 00 00 00       	mov    $0x1,%eax
80104d8a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d8e:	89 34 24             	mov    %esi,(%esp)
80104d91:	e8 2a ca ff ff       	call   801017c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d96:	83 c4 10             	add    $0x10,%esp
80104d99:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d9e:	74 30                	je     80104dd0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104da0:	83 ec 04             	sub    $0x4,%esp
80104da3:	ff 76 04             	push   0x4(%esi)
80104da6:	57                   	push   %edi
80104da7:	53                   	push   %ebx
80104da8:	e8 e3 d2 ff ff       	call   80102090 <dirlink>
80104dad:	83 c4 10             	add    $0x10,%esp
80104db0:	85 c0                	test   %eax,%eax
80104db2:	78 67                	js     80104e1b <create+0x15b>
  iunlockput(dp);
80104db4:	83 ec 0c             	sub    $0xc,%esp
80104db7:	53                   	push   %ebx
80104db8:	e8 43 cd ff ff       	call   80101b00 <iunlockput>
  return ip;
80104dbd:	83 c4 10             	add    $0x10,%esp
}
80104dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dc3:	89 f0                	mov    %esi,%eax
80104dc5:	5b                   	pop    %ebx
80104dc6:	5e                   	pop    %esi
80104dc7:	5f                   	pop    %edi
80104dc8:	5d                   	pop    %ebp
80104dc9:	c3                   	ret
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104dd0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104dd3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104dd8:	53                   	push   %ebx
80104dd9:	e8 e2 c9 ff ff       	call   801017c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dde:	83 c4 0c             	add    $0xc,%esp
80104de1:	ff 76 04             	push   0x4(%esi)
80104de4:	68 e9 7d 10 80       	push   $0x80107de9
80104de9:	56                   	push   %esi
80104dea:	e8 a1 d2 ff ff       	call   80102090 <dirlink>
80104def:	83 c4 10             	add    $0x10,%esp
80104df2:	85 c0                	test   %eax,%eax
80104df4:	78 18                	js     80104e0e <create+0x14e>
80104df6:	83 ec 04             	sub    $0x4,%esp
80104df9:	ff 73 04             	push   0x4(%ebx)
80104dfc:	68 e8 7d 10 80       	push   $0x80107de8
80104e01:	56                   	push   %esi
80104e02:	e8 89 d2 ff ff       	call   80102090 <dirlink>
80104e07:	83 c4 10             	add    $0x10,%esp
80104e0a:	85 c0                	test   %eax,%eax
80104e0c:	79 92                	jns    80104da0 <create+0xe0>
      panic("create dots");
80104e0e:	83 ec 0c             	sub    $0xc,%esp
80104e11:	68 dc 7d 10 80       	push   $0x80107ddc
80104e16:	e8 65 b5 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104e1b:	83 ec 0c             	sub    $0xc,%esp
80104e1e:	68 eb 7d 10 80       	push   $0x80107deb
80104e23:	e8 58 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e28:	83 ec 0c             	sub    $0xc,%esp
80104e2b:	68 cd 7d 10 80       	push   $0x80107dcd
80104e30:	e8 4b b5 ff ff       	call   80100380 <panic>
80104e35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e3c:	00 
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi

80104e40 <sys_dup>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e45:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e4b:	50                   	push   %eax
80104e4c:	6a 00                	push   $0x0
80104e4e:	e8 bd fc ff ff       	call   80104b10 <argint>
80104e53:	83 c4 10             	add    $0x10,%esp
80104e56:	85 c0                	test   %eax,%eax
80104e58:	78 36                	js     80104e90 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e5e:	77 30                	ja     80104e90 <sys_dup+0x50>
80104e60:	e8 4b ec ff ff       	call   80103ab0 <myproc>
80104e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e6c:	85 f6                	test   %esi,%esi
80104e6e:	74 20                	je     80104e90 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104e70:	e8 3b ec ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e75:	31 db                	xor    %ebx,%ebx
80104e77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e7e:	00 
80104e7f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104e80:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e84:	85 d2                	test   %edx,%edx
80104e86:	74 18                	je     80104ea0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104e88:	83 c3 01             	add    $0x1,%ebx
80104e8b:	83 fb 10             	cmp    $0x10,%ebx
80104e8e:	75 f0                	jne    80104e80 <sys_dup+0x40>
}
80104e90:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e93:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e98:	89 d8                	mov    %ebx,%eax
80104e9a:	5b                   	pop    %ebx
80104e9b:	5e                   	pop    %esi
80104e9c:	5d                   	pop    %ebp
80104e9d:	c3                   	ret
80104e9e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104ea0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104ea3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ea7:	56                   	push   %esi
80104ea8:	e8 e3 c0 ff ff       	call   80100f90 <filedup>
  return fd;
80104ead:	83 c4 10             	add    $0x10,%esp
}
80104eb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eb3:	89 d8                	mov    %ebx,%eax
80104eb5:	5b                   	pop    %ebx
80104eb6:	5e                   	pop    %esi
80104eb7:	5d                   	pop    %ebp
80104eb8:	c3                   	ret
80104eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ec0 <sys_read>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ec5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ec8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ecb:	53                   	push   %ebx
80104ecc:	6a 00                	push   $0x0
80104ece:	e8 3d fc ff ff       	call   80104b10 <argint>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	85 c0                	test   %eax,%eax
80104ed8:	78 5e                	js     80104f38 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ede:	77 58                	ja     80104f38 <sys_read+0x78>
80104ee0:	e8 cb eb ff ff       	call   80103ab0 <myproc>
80104ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ee8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104eec:	85 f6                	test   %esi,%esi
80104eee:	74 48                	je     80104f38 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ef0:	83 ec 08             	sub    $0x8,%esp
80104ef3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ef6:	50                   	push   %eax
80104ef7:	6a 02                	push   $0x2
80104ef9:	e8 12 fc ff ff       	call   80104b10 <argint>
80104efe:	83 c4 10             	add    $0x10,%esp
80104f01:	85 c0                	test   %eax,%eax
80104f03:	78 33                	js     80104f38 <sys_read+0x78>
80104f05:	83 ec 04             	sub    $0x4,%esp
80104f08:	ff 75 f0             	push   -0x10(%ebp)
80104f0b:	53                   	push   %ebx
80104f0c:	6a 01                	push   $0x1
80104f0e:	e8 4d fc ff ff       	call   80104b60 <argptr>
80104f13:	83 c4 10             	add    $0x10,%esp
80104f16:	85 c0                	test   %eax,%eax
80104f18:	78 1e                	js     80104f38 <sys_read+0x78>
  return fileread(f, p, n);
80104f1a:	83 ec 04             	sub    $0x4,%esp
80104f1d:	ff 75 f0             	push   -0x10(%ebp)
80104f20:	ff 75 f4             	push   -0xc(%ebp)
80104f23:	56                   	push   %esi
80104f24:	e8 e7 c1 ff ff       	call   80101110 <fileread>
80104f29:	83 c4 10             	add    $0x10,%esp
}
80104f2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f2f:	5b                   	pop    %ebx
80104f30:	5e                   	pop    %esi
80104f31:	5d                   	pop    %ebp
80104f32:	c3                   	ret
80104f33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f3d:	eb ed                	jmp    80104f2c <sys_read+0x6c>
80104f3f:	90                   	nop

80104f40 <sys_write>:
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f45:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f4b:	53                   	push   %ebx
80104f4c:	6a 00                	push   $0x0
80104f4e:	e8 bd fb ff ff       	call   80104b10 <argint>
80104f53:	83 c4 10             	add    $0x10,%esp
80104f56:	85 c0                	test   %eax,%eax
80104f58:	78 5e                	js     80104fb8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f5e:	77 58                	ja     80104fb8 <sys_write+0x78>
80104f60:	e8 4b eb ff ff       	call   80103ab0 <myproc>
80104f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f6c:	85 f6                	test   %esi,%esi
80104f6e:	74 48                	je     80104fb8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f70:	83 ec 08             	sub    $0x8,%esp
80104f73:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f76:	50                   	push   %eax
80104f77:	6a 02                	push   $0x2
80104f79:	e8 92 fb ff ff       	call   80104b10 <argint>
80104f7e:	83 c4 10             	add    $0x10,%esp
80104f81:	85 c0                	test   %eax,%eax
80104f83:	78 33                	js     80104fb8 <sys_write+0x78>
80104f85:	83 ec 04             	sub    $0x4,%esp
80104f88:	ff 75 f0             	push   -0x10(%ebp)
80104f8b:	53                   	push   %ebx
80104f8c:	6a 01                	push   $0x1
80104f8e:	e8 cd fb ff ff       	call   80104b60 <argptr>
80104f93:	83 c4 10             	add    $0x10,%esp
80104f96:	85 c0                	test   %eax,%eax
80104f98:	78 1e                	js     80104fb8 <sys_write+0x78>
  return filewrite(f, p, n);
80104f9a:	83 ec 04             	sub    $0x4,%esp
80104f9d:	ff 75 f0             	push   -0x10(%ebp)
80104fa0:	ff 75 f4             	push   -0xc(%ebp)
80104fa3:	56                   	push   %esi
80104fa4:	e8 f7 c1 ff ff       	call   801011a0 <filewrite>
80104fa9:	83 c4 10             	add    $0x10,%esp
}
80104fac:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104faf:	5b                   	pop    %ebx
80104fb0:	5e                   	pop    %esi
80104fb1:	5d                   	pop    %ebp
80104fb2:	c3                   	ret
80104fb3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fbd:	eb ed                	jmp    80104fac <sys_write+0x6c>
80104fbf:	90                   	nop

80104fc0 <sys_close>:
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104fc8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fcb:	50                   	push   %eax
80104fcc:	6a 00                	push   $0x0
80104fce:	e8 3d fb ff ff       	call   80104b10 <argint>
80104fd3:	83 c4 10             	add    $0x10,%esp
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	78 3e                	js     80105018 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fde:	77 38                	ja     80105018 <sys_close+0x58>
80104fe0:	e8 cb ea ff ff       	call   80103ab0 <myproc>
80104fe5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fe8:	8d 5a 08             	lea    0x8(%edx),%ebx
80104feb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104fef:	85 f6                	test   %esi,%esi
80104ff1:	74 25                	je     80105018 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104ff3:	e8 b8 ea ff ff       	call   80103ab0 <myproc>
  fileclose(f);
80104ff8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ffb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105002:	00 
  fileclose(f);
80105003:	56                   	push   %esi
80105004:	e8 d7 bf ff ff       	call   80100fe0 <fileclose>
  return 0;
80105009:	83 c4 10             	add    $0x10,%esp
8010500c:	31 c0                	xor    %eax,%eax
}
8010500e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105011:	5b                   	pop    %ebx
80105012:	5e                   	pop    %esi
80105013:	5d                   	pop    %ebp
80105014:	c3                   	ret
80105015:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501d:	eb ef                	jmp    8010500e <sys_close+0x4e>
8010501f:	90                   	nop

80105020 <sys_fstat>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105025:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105028:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010502b:	53                   	push   %ebx
8010502c:	6a 00                	push   $0x0
8010502e:	e8 dd fa ff ff       	call   80104b10 <argint>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 46                	js     80105080 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010503a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010503e:	77 40                	ja     80105080 <sys_fstat+0x60>
80105040:	e8 6b ea ff ff       	call   80103ab0 <myproc>
80105045:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105048:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010504c:	85 f6                	test   %esi,%esi
8010504e:	74 30                	je     80105080 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105050:	83 ec 04             	sub    $0x4,%esp
80105053:	6a 14                	push   $0x14
80105055:	53                   	push   %ebx
80105056:	6a 01                	push   $0x1
80105058:	e8 03 fb ff ff       	call   80104b60 <argptr>
8010505d:	83 c4 10             	add    $0x10,%esp
80105060:	85 c0                	test   %eax,%eax
80105062:	78 1c                	js     80105080 <sys_fstat+0x60>
  return filestat(f, st);
80105064:	83 ec 08             	sub    $0x8,%esp
80105067:	ff 75 f4             	push   -0xc(%ebp)
8010506a:	56                   	push   %esi
8010506b:	e8 50 c0 ff ff       	call   801010c0 <filestat>
80105070:	83 c4 10             	add    $0x10,%esp
}
80105073:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105076:	5b                   	pop    %ebx
80105077:	5e                   	pop    %esi
80105078:	5d                   	pop    %ebp
80105079:	c3                   	ret
8010507a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105085:	eb ec                	jmp    80105073 <sys_fstat+0x53>
80105087:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010508e:	00 
8010508f:	90                   	nop

80105090 <sys_link>:
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	57                   	push   %edi
80105094:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105095:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105098:	53                   	push   %ebx
80105099:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010509c:	50                   	push   %eax
8010509d:	6a 00                	push   $0x0
8010509f:	e8 2c fb ff ff       	call   80104bd0 <argstr>
801050a4:	83 c4 10             	add    $0x10,%esp
801050a7:	85 c0                	test   %eax,%eax
801050a9:	0f 88 fb 00 00 00    	js     801051aa <sys_link+0x11a>
801050af:	83 ec 08             	sub    $0x8,%esp
801050b2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050b5:	50                   	push   %eax
801050b6:	6a 01                	push   $0x1
801050b8:	e8 13 fb ff ff       	call   80104bd0 <argstr>
801050bd:	83 c4 10             	add    $0x10,%esp
801050c0:	85 c0                	test   %eax,%eax
801050c2:	0f 88 e2 00 00 00    	js     801051aa <sys_link+0x11a>
  begin_op();
801050c8:	e8 43 dd ff ff       	call   80102e10 <begin_op>
  if((ip = namei(old)) == 0){
801050cd:	83 ec 0c             	sub    $0xc,%esp
801050d0:	ff 75 d4             	push   -0x2c(%ebp)
801050d3:	e8 78 d0 ff ff       	call   80102150 <namei>
801050d8:	83 c4 10             	add    $0x10,%esp
801050db:	89 c3                	mov    %eax,%ebx
801050dd:	85 c0                	test   %eax,%eax
801050df:	0f 84 df 00 00 00    	je     801051c4 <sys_link+0x134>
  ilock(ip);
801050e5:	83 ec 0c             	sub    $0xc,%esp
801050e8:	50                   	push   %eax
801050e9:	e8 82 c7 ff ff       	call   80101870 <ilock>
  if(ip->type == T_DIR){
801050ee:	83 c4 10             	add    $0x10,%esp
801050f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050f6:	0f 84 b5 00 00 00    	je     801051b1 <sys_link+0x121>
  iupdate(ip);
801050fc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801050ff:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105104:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105107:	53                   	push   %ebx
80105108:	e8 b3 c6 ff ff       	call   801017c0 <iupdate>
  iunlock(ip);
8010510d:	89 1c 24             	mov    %ebx,(%esp)
80105110:	e8 3b c8 ff ff       	call   80101950 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105115:	58                   	pop    %eax
80105116:	5a                   	pop    %edx
80105117:	57                   	push   %edi
80105118:	ff 75 d0             	push   -0x30(%ebp)
8010511b:	e8 50 d0 ff ff       	call   80102170 <nameiparent>
80105120:	83 c4 10             	add    $0x10,%esp
80105123:	89 c6                	mov    %eax,%esi
80105125:	85 c0                	test   %eax,%eax
80105127:	74 5b                	je     80105184 <sys_link+0xf4>
  ilock(dp);
80105129:	83 ec 0c             	sub    $0xc,%esp
8010512c:	50                   	push   %eax
8010512d:	e8 3e c7 ff ff       	call   80101870 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105132:	8b 03                	mov    (%ebx),%eax
80105134:	83 c4 10             	add    $0x10,%esp
80105137:	39 06                	cmp    %eax,(%esi)
80105139:	75 3d                	jne    80105178 <sys_link+0xe8>
8010513b:	83 ec 04             	sub    $0x4,%esp
8010513e:	ff 73 04             	push   0x4(%ebx)
80105141:	57                   	push   %edi
80105142:	56                   	push   %esi
80105143:	e8 48 cf ff ff       	call   80102090 <dirlink>
80105148:	83 c4 10             	add    $0x10,%esp
8010514b:	85 c0                	test   %eax,%eax
8010514d:	78 29                	js     80105178 <sys_link+0xe8>
  iunlockput(dp);
8010514f:	83 ec 0c             	sub    $0xc,%esp
80105152:	56                   	push   %esi
80105153:	e8 a8 c9 ff ff       	call   80101b00 <iunlockput>
  iput(ip);
80105158:	89 1c 24             	mov    %ebx,(%esp)
8010515b:	e8 40 c8 ff ff       	call   801019a0 <iput>
  end_op();
80105160:	e8 1b dd ff ff       	call   80102e80 <end_op>
  return 0;
80105165:	83 c4 10             	add    $0x10,%esp
80105168:	31 c0                	xor    %eax,%eax
}
8010516a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010516d:	5b                   	pop    %ebx
8010516e:	5e                   	pop    %esi
8010516f:	5f                   	pop    %edi
80105170:	5d                   	pop    %ebp
80105171:	c3                   	ret
80105172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105178:	83 ec 0c             	sub    $0xc,%esp
8010517b:	56                   	push   %esi
8010517c:	e8 7f c9 ff ff       	call   80101b00 <iunlockput>
    goto bad;
80105181:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105184:	83 ec 0c             	sub    $0xc,%esp
80105187:	53                   	push   %ebx
80105188:	e8 e3 c6 ff ff       	call   80101870 <ilock>
  ip->nlink--;
8010518d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105192:	89 1c 24             	mov    %ebx,(%esp)
80105195:	e8 26 c6 ff ff       	call   801017c0 <iupdate>
  iunlockput(ip);
8010519a:	89 1c 24             	mov    %ebx,(%esp)
8010519d:	e8 5e c9 ff ff       	call   80101b00 <iunlockput>
  end_op();
801051a2:	e8 d9 dc ff ff       	call   80102e80 <end_op>
  return -1;
801051a7:	83 c4 10             	add    $0x10,%esp
    return -1;
801051aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051af:	eb b9                	jmp    8010516a <sys_link+0xda>
    iunlockput(ip);
801051b1:	83 ec 0c             	sub    $0xc,%esp
801051b4:	53                   	push   %ebx
801051b5:	e8 46 c9 ff ff       	call   80101b00 <iunlockput>
    end_op();
801051ba:	e8 c1 dc ff ff       	call   80102e80 <end_op>
    return -1;
801051bf:	83 c4 10             	add    $0x10,%esp
801051c2:	eb e6                	jmp    801051aa <sys_link+0x11a>
    end_op();
801051c4:	e8 b7 dc ff ff       	call   80102e80 <end_op>
    return -1;
801051c9:	eb df                	jmp    801051aa <sys_link+0x11a>
801051cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801051d0 <sys_unlink>:
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	57                   	push   %edi
801051d4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801051d5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801051d8:	53                   	push   %ebx
801051d9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801051dc:	50                   	push   %eax
801051dd:	6a 00                	push   $0x0
801051df:	e8 ec f9 ff ff       	call   80104bd0 <argstr>
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	85 c0                	test   %eax,%eax
801051e9:	0f 88 54 01 00 00    	js     80105343 <sys_unlink+0x173>
  begin_op();
801051ef:	e8 1c dc ff ff       	call   80102e10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051f4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801051f7:	83 ec 08             	sub    $0x8,%esp
801051fa:	53                   	push   %ebx
801051fb:	ff 75 c0             	push   -0x40(%ebp)
801051fe:	e8 6d cf ff ff       	call   80102170 <nameiparent>
80105203:	83 c4 10             	add    $0x10,%esp
80105206:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105209:	85 c0                	test   %eax,%eax
8010520b:	0f 84 58 01 00 00    	je     80105369 <sys_unlink+0x199>
  ilock(dp);
80105211:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105214:	83 ec 0c             	sub    $0xc,%esp
80105217:	57                   	push   %edi
80105218:	e8 53 c6 ff ff       	call   80101870 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010521d:	58                   	pop    %eax
8010521e:	5a                   	pop    %edx
8010521f:	68 e9 7d 10 80       	push   $0x80107de9
80105224:	53                   	push   %ebx
80105225:	e8 76 cb ff ff       	call   80101da0 <namecmp>
8010522a:	83 c4 10             	add    $0x10,%esp
8010522d:	85 c0                	test   %eax,%eax
8010522f:	0f 84 fb 00 00 00    	je     80105330 <sys_unlink+0x160>
80105235:	83 ec 08             	sub    $0x8,%esp
80105238:	68 e8 7d 10 80       	push   $0x80107de8
8010523d:	53                   	push   %ebx
8010523e:	e8 5d cb ff ff       	call   80101da0 <namecmp>
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	85 c0                	test   %eax,%eax
80105248:	0f 84 e2 00 00 00    	je     80105330 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010524e:	83 ec 04             	sub    $0x4,%esp
80105251:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105254:	50                   	push   %eax
80105255:	53                   	push   %ebx
80105256:	57                   	push   %edi
80105257:	e8 64 cb ff ff       	call   80101dc0 <dirlookup>
8010525c:	83 c4 10             	add    $0x10,%esp
8010525f:	89 c3                	mov    %eax,%ebx
80105261:	85 c0                	test   %eax,%eax
80105263:	0f 84 c7 00 00 00    	je     80105330 <sys_unlink+0x160>
  ilock(ip);
80105269:	83 ec 0c             	sub    $0xc,%esp
8010526c:	50                   	push   %eax
8010526d:	e8 fe c5 ff ff       	call   80101870 <ilock>
  if(ip->nlink < 1)
80105272:	83 c4 10             	add    $0x10,%esp
80105275:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010527a:	0f 8e 0a 01 00 00    	jle    8010538a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105280:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105285:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105288:	74 66                	je     801052f0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010528a:	83 ec 04             	sub    $0x4,%esp
8010528d:	6a 10                	push   $0x10
8010528f:	6a 00                	push   $0x0
80105291:	57                   	push   %edi
80105292:	e8 c9 f5 ff ff       	call   80104860 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105297:	6a 10                	push   $0x10
80105299:	ff 75 c4             	push   -0x3c(%ebp)
8010529c:	57                   	push   %edi
8010529d:	ff 75 b4             	push   -0x4c(%ebp)
801052a0:	e8 db c9 ff ff       	call   80101c80 <writei>
801052a5:	83 c4 20             	add    $0x20,%esp
801052a8:	83 f8 10             	cmp    $0x10,%eax
801052ab:	0f 85 cc 00 00 00    	jne    8010537d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801052b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052b6:	0f 84 94 00 00 00    	je     80105350 <sys_unlink+0x180>
  iunlockput(dp);
801052bc:	83 ec 0c             	sub    $0xc,%esp
801052bf:	ff 75 b4             	push   -0x4c(%ebp)
801052c2:	e8 39 c8 ff ff       	call   80101b00 <iunlockput>
  ip->nlink--;
801052c7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052cc:	89 1c 24             	mov    %ebx,(%esp)
801052cf:	e8 ec c4 ff ff       	call   801017c0 <iupdate>
  iunlockput(ip);
801052d4:	89 1c 24             	mov    %ebx,(%esp)
801052d7:	e8 24 c8 ff ff       	call   80101b00 <iunlockput>
  end_op();
801052dc:	e8 9f db ff ff       	call   80102e80 <end_op>
  return 0;
801052e1:	83 c4 10             	add    $0x10,%esp
801052e4:	31 c0                	xor    %eax,%eax
}
801052e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052e9:	5b                   	pop    %ebx
801052ea:	5e                   	pop    %esi
801052eb:	5f                   	pop    %edi
801052ec:	5d                   	pop    %ebp
801052ed:	c3                   	ret
801052ee:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801052f0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801052f4:	76 94                	jbe    8010528a <sys_unlink+0xba>
801052f6:	be 20 00 00 00       	mov    $0x20,%esi
801052fb:	eb 0b                	jmp    80105308 <sys_unlink+0x138>
801052fd:	8d 76 00             	lea    0x0(%esi),%esi
80105300:	83 c6 10             	add    $0x10,%esi
80105303:	3b 73 58             	cmp    0x58(%ebx),%esi
80105306:	73 82                	jae    8010528a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105308:	6a 10                	push   $0x10
8010530a:	56                   	push   %esi
8010530b:	57                   	push   %edi
8010530c:	53                   	push   %ebx
8010530d:	e8 6e c8 ff ff       	call   80101b80 <readi>
80105312:	83 c4 10             	add    $0x10,%esp
80105315:	83 f8 10             	cmp    $0x10,%eax
80105318:	75 56                	jne    80105370 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010531a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010531f:	74 df                	je     80105300 <sys_unlink+0x130>
    iunlockput(ip);
80105321:	83 ec 0c             	sub    $0xc,%esp
80105324:	53                   	push   %ebx
80105325:	e8 d6 c7 ff ff       	call   80101b00 <iunlockput>
    goto bad;
8010532a:	83 c4 10             	add    $0x10,%esp
8010532d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105330:	83 ec 0c             	sub    $0xc,%esp
80105333:	ff 75 b4             	push   -0x4c(%ebp)
80105336:	e8 c5 c7 ff ff       	call   80101b00 <iunlockput>
  end_op();
8010533b:	e8 40 db ff ff       	call   80102e80 <end_op>
  return -1;
80105340:	83 c4 10             	add    $0x10,%esp
    return -1;
80105343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105348:	eb 9c                	jmp    801052e6 <sys_unlink+0x116>
8010534a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105350:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105353:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105356:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010535b:	50                   	push   %eax
8010535c:	e8 5f c4 ff ff       	call   801017c0 <iupdate>
80105361:	83 c4 10             	add    $0x10,%esp
80105364:	e9 53 ff ff ff       	jmp    801052bc <sys_unlink+0xec>
    end_op();
80105369:	e8 12 db ff ff       	call   80102e80 <end_op>
    return -1;
8010536e:	eb d3                	jmp    80105343 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	68 0d 7e 10 80       	push   $0x80107e0d
80105378:	e8 03 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010537d:	83 ec 0c             	sub    $0xc,%esp
80105380:	68 1f 7e 10 80       	push   $0x80107e1f
80105385:	e8 f6 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010538a:	83 ec 0c             	sub    $0xc,%esp
8010538d:	68 fb 7d 10 80       	push   $0x80107dfb
80105392:	e8 e9 af ff ff       	call   80100380 <panic>
80105397:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010539e:	00 
8010539f:	90                   	nop

801053a0 <sys_open>:

int
sys_open(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053a8:	53                   	push   %ebx
801053a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053ac:	50                   	push   %eax
801053ad:	6a 00                	push   $0x0
801053af:	e8 1c f8 ff ff       	call   80104bd0 <argstr>
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	85 c0                	test   %eax,%eax
801053b9:	0f 88 8e 00 00 00    	js     8010544d <sys_open+0xad>
801053bf:	83 ec 08             	sub    $0x8,%esp
801053c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053c5:	50                   	push   %eax
801053c6:	6a 01                	push   $0x1
801053c8:	e8 43 f7 ff ff       	call   80104b10 <argint>
801053cd:	83 c4 10             	add    $0x10,%esp
801053d0:	85 c0                	test   %eax,%eax
801053d2:	78 79                	js     8010544d <sys_open+0xad>
    return -1;

  begin_op();
801053d4:	e8 37 da ff ff       	call   80102e10 <begin_op>

  if(omode & O_CREATE){
801053d9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801053dd:	75 79                	jne    80105458 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801053df:	83 ec 0c             	sub    $0xc,%esp
801053e2:	ff 75 e0             	push   -0x20(%ebp)
801053e5:	e8 66 cd ff ff       	call   80102150 <namei>
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	89 c6                	mov    %eax,%esi
801053ef:	85 c0                	test   %eax,%eax
801053f1:	0f 84 7e 00 00 00    	je     80105475 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801053f7:	83 ec 0c             	sub    $0xc,%esp
801053fa:	50                   	push   %eax
801053fb:	e8 70 c4 ff ff       	call   80101870 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105400:	83 c4 10             	add    $0x10,%esp
80105403:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105408:	0f 84 ba 00 00 00    	je     801054c8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010540e:	e8 0d bb ff ff       	call   80100f20 <filealloc>
80105413:	89 c7                	mov    %eax,%edi
80105415:	85 c0                	test   %eax,%eax
80105417:	74 23                	je     8010543c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105419:	e8 92 e6 ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010541e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105420:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105424:	85 d2                	test   %edx,%edx
80105426:	74 58                	je     80105480 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105428:	83 c3 01             	add    $0x1,%ebx
8010542b:	83 fb 10             	cmp    $0x10,%ebx
8010542e:	75 f0                	jne    80105420 <sys_open+0x80>
    if(f)
      fileclose(f);
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	57                   	push   %edi
80105434:	e8 a7 bb ff ff       	call   80100fe0 <fileclose>
80105439:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010543c:	83 ec 0c             	sub    $0xc,%esp
8010543f:	56                   	push   %esi
80105440:	e8 bb c6 ff ff       	call   80101b00 <iunlockput>
    end_op();
80105445:	e8 36 da ff ff       	call   80102e80 <end_op>
    return -1;
8010544a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010544d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105452:	eb 65                	jmp    801054b9 <sys_open+0x119>
80105454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105458:	83 ec 0c             	sub    $0xc,%esp
8010545b:	31 c9                	xor    %ecx,%ecx
8010545d:	ba 02 00 00 00       	mov    $0x2,%edx
80105462:	6a 00                	push   $0x0
80105464:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105467:	e8 54 f8 ff ff       	call   80104cc0 <create>
    if(ip == 0){
8010546c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010546f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105471:	85 c0                	test   %eax,%eax
80105473:	75 99                	jne    8010540e <sys_open+0x6e>
      end_op();
80105475:	e8 06 da ff ff       	call   80102e80 <end_op>
      return -1;
8010547a:	eb d1                	jmp    8010544d <sys_open+0xad>
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105480:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105483:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105487:	56                   	push   %esi
80105488:	e8 c3 c4 ff ff       	call   80101950 <iunlock>
  end_op();
8010548d:	e8 ee d9 ff ff       	call   80102e80 <end_op>

  f->type = FD_INODE;
80105492:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105498:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010549b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010549e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054a1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054a3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054aa:	f7 d0                	not    %eax
801054ac:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054af:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054b2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054b5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801054b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054bc:	89 d8                	mov    %ebx,%eax
801054be:	5b                   	pop    %ebx
801054bf:	5e                   	pop    %esi
801054c0:	5f                   	pop    %edi
801054c1:	5d                   	pop    %ebp
801054c2:	c3                   	ret
801054c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801054c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801054cb:	85 c9                	test   %ecx,%ecx
801054cd:	0f 84 3b ff ff ff    	je     8010540e <sys_open+0x6e>
801054d3:	e9 64 ff ff ff       	jmp    8010543c <sys_open+0x9c>
801054d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054df:	00 

801054e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801054e6:	e8 25 d9 ff ff       	call   80102e10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801054eb:	83 ec 08             	sub    $0x8,%esp
801054ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f1:	50                   	push   %eax
801054f2:	6a 00                	push   $0x0
801054f4:	e8 d7 f6 ff ff       	call   80104bd0 <argstr>
801054f9:	83 c4 10             	add    $0x10,%esp
801054fc:	85 c0                	test   %eax,%eax
801054fe:	78 30                	js     80105530 <sys_mkdir+0x50>
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105506:	31 c9                	xor    %ecx,%ecx
80105508:	ba 01 00 00 00       	mov    $0x1,%edx
8010550d:	6a 00                	push   $0x0
8010550f:	e8 ac f7 ff ff       	call   80104cc0 <create>
80105514:	83 c4 10             	add    $0x10,%esp
80105517:	85 c0                	test   %eax,%eax
80105519:	74 15                	je     80105530 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010551b:	83 ec 0c             	sub    $0xc,%esp
8010551e:	50                   	push   %eax
8010551f:	e8 dc c5 ff ff       	call   80101b00 <iunlockput>
  end_op();
80105524:	e8 57 d9 ff ff       	call   80102e80 <end_op>
  return 0;
80105529:	83 c4 10             	add    $0x10,%esp
8010552c:	31 c0                	xor    %eax,%eax
}
8010552e:	c9                   	leave
8010552f:	c3                   	ret
    end_op();
80105530:	e8 4b d9 ff ff       	call   80102e80 <end_op>
    return -1;
80105535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010553a:	c9                   	leave
8010553b:	c3                   	ret
8010553c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_mknod>:

int
sys_mknod(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105546:	e8 c5 d8 ff ff       	call   80102e10 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010554b:	83 ec 08             	sub    $0x8,%esp
8010554e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105551:	50                   	push   %eax
80105552:	6a 00                	push   $0x0
80105554:	e8 77 f6 ff ff       	call   80104bd0 <argstr>
80105559:	83 c4 10             	add    $0x10,%esp
8010555c:	85 c0                	test   %eax,%eax
8010555e:	78 60                	js     801055c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105560:	83 ec 08             	sub    $0x8,%esp
80105563:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105566:	50                   	push   %eax
80105567:	6a 01                	push   $0x1
80105569:	e8 a2 f5 ff ff       	call   80104b10 <argint>
  if((argstr(0, &path)) < 0 ||
8010556e:	83 c4 10             	add    $0x10,%esp
80105571:	85 c0                	test   %eax,%eax
80105573:	78 4b                	js     801055c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105575:	83 ec 08             	sub    $0x8,%esp
80105578:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010557b:	50                   	push   %eax
8010557c:	6a 02                	push   $0x2
8010557e:	e8 8d f5 ff ff       	call   80104b10 <argint>
     argint(1, &major) < 0 ||
80105583:	83 c4 10             	add    $0x10,%esp
80105586:	85 c0                	test   %eax,%eax
80105588:	78 36                	js     801055c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010558a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010558e:	83 ec 0c             	sub    $0xc,%esp
80105591:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105595:	ba 03 00 00 00       	mov    $0x3,%edx
8010559a:	50                   	push   %eax
8010559b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010559e:	e8 1d f7 ff ff       	call   80104cc0 <create>
     argint(2, &minor) < 0 ||
801055a3:	83 c4 10             	add    $0x10,%esp
801055a6:	85 c0                	test   %eax,%eax
801055a8:	74 16                	je     801055c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055aa:	83 ec 0c             	sub    $0xc,%esp
801055ad:	50                   	push   %eax
801055ae:	e8 4d c5 ff ff       	call   80101b00 <iunlockput>
  end_op();
801055b3:	e8 c8 d8 ff ff       	call   80102e80 <end_op>
  return 0;
801055b8:	83 c4 10             	add    $0x10,%esp
801055bb:	31 c0                	xor    %eax,%eax
}
801055bd:	c9                   	leave
801055be:	c3                   	ret
801055bf:	90                   	nop
    end_op();
801055c0:	e8 bb d8 ff ff       	call   80102e80 <end_op>
    return -1;
801055c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ca:	c9                   	leave
801055cb:	c3                   	ret
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055d0 <sys_chdir>:

int
sys_chdir(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	56                   	push   %esi
801055d4:	53                   	push   %ebx
801055d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801055d8:	e8 d3 e4 ff ff       	call   80103ab0 <myproc>
801055dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801055df:	e8 2c d8 ff ff       	call   80102e10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801055e4:	83 ec 08             	sub    $0x8,%esp
801055e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ea:	50                   	push   %eax
801055eb:	6a 00                	push   $0x0
801055ed:	e8 de f5 ff ff       	call   80104bd0 <argstr>
801055f2:	83 c4 10             	add    $0x10,%esp
801055f5:	85 c0                	test   %eax,%eax
801055f7:	78 77                	js     80105670 <sys_chdir+0xa0>
801055f9:	83 ec 0c             	sub    $0xc,%esp
801055fc:	ff 75 f4             	push   -0xc(%ebp)
801055ff:	e8 4c cb ff ff       	call   80102150 <namei>
80105604:	83 c4 10             	add    $0x10,%esp
80105607:	89 c3                	mov    %eax,%ebx
80105609:	85 c0                	test   %eax,%eax
8010560b:	74 63                	je     80105670 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010560d:	83 ec 0c             	sub    $0xc,%esp
80105610:	50                   	push   %eax
80105611:	e8 5a c2 ff ff       	call   80101870 <ilock>
  if(ip->type != T_DIR){
80105616:	83 c4 10             	add    $0x10,%esp
80105619:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010561e:	75 30                	jne    80105650 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	53                   	push   %ebx
80105624:	e8 27 c3 ff ff       	call   80101950 <iunlock>
  iput(curproc->cwd);
80105629:	58                   	pop    %eax
8010562a:	ff 76 68             	push   0x68(%esi)
8010562d:	e8 6e c3 ff ff       	call   801019a0 <iput>
  end_op();
80105632:	e8 49 d8 ff ff       	call   80102e80 <end_op>
  curproc->cwd = ip;
80105637:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	31 c0                	xor    %eax,%eax
}
8010563f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105642:	5b                   	pop    %ebx
80105643:	5e                   	pop    %esi
80105644:	5d                   	pop    %ebp
80105645:	c3                   	ret
80105646:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010564d:	00 
8010564e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	53                   	push   %ebx
80105654:	e8 a7 c4 ff ff       	call   80101b00 <iunlockput>
    end_op();
80105659:	e8 22 d8 ff ff       	call   80102e80 <end_op>
    return -1;
8010565e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105666:	eb d7                	jmp    8010563f <sys_chdir+0x6f>
80105668:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010566f:	00 
    end_op();
80105670:	e8 0b d8 ff ff       	call   80102e80 <end_op>
    return -1;
80105675:	eb ea                	jmp    80105661 <sys_chdir+0x91>
80105677:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010567e:	00 
8010567f:	90                   	nop

80105680 <sys_exec>:

int
sys_exec(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	57                   	push   %edi
80105684:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105685:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010568b:	53                   	push   %ebx
8010568c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105692:	50                   	push   %eax
80105693:	6a 00                	push   $0x0
80105695:	e8 36 f5 ff ff       	call   80104bd0 <argstr>
8010569a:	83 c4 10             	add    $0x10,%esp
8010569d:	85 c0                	test   %eax,%eax
8010569f:	0f 88 87 00 00 00    	js     8010572c <sys_exec+0xac>
801056a5:	83 ec 08             	sub    $0x8,%esp
801056a8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056ae:	50                   	push   %eax
801056af:	6a 01                	push   $0x1
801056b1:	e8 5a f4 ff ff       	call   80104b10 <argint>
801056b6:	83 c4 10             	add    $0x10,%esp
801056b9:	85 c0                	test   %eax,%eax
801056bb:	78 6f                	js     8010572c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056bd:	83 ec 04             	sub    $0x4,%esp
801056c0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801056c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801056c8:	68 80 00 00 00       	push   $0x80
801056cd:	6a 00                	push   $0x0
801056cf:	56                   	push   %esi
801056d0:	e8 8b f1 ff ff       	call   80104860 <memset>
801056d5:	83 c4 10             	add    $0x10,%esp
801056d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056df:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801056e0:	83 ec 08             	sub    $0x8,%esp
801056e3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801056e9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801056f0:	50                   	push   %eax
801056f1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801056f7:	01 f8                	add    %edi,%eax
801056f9:	50                   	push   %eax
801056fa:	e8 81 f3 ff ff       	call   80104a80 <fetchint>
801056ff:	83 c4 10             	add    $0x10,%esp
80105702:	85 c0                	test   %eax,%eax
80105704:	78 26                	js     8010572c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105706:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010570c:	85 c0                	test   %eax,%eax
8010570e:	74 30                	je     80105740 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105710:	83 ec 08             	sub    $0x8,%esp
80105713:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105716:	52                   	push   %edx
80105717:	50                   	push   %eax
80105718:	e8 a3 f3 ff ff       	call   80104ac0 <fetchstr>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	85 c0                	test   %eax,%eax
80105722:	78 08                	js     8010572c <sys_exec+0xac>
  for(i=0;; i++){
80105724:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105727:	83 fb 20             	cmp    $0x20,%ebx
8010572a:	75 b4                	jne    801056e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010572c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010572f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105734:	5b                   	pop    %ebx
80105735:	5e                   	pop    %esi
80105736:	5f                   	pop    %edi
80105737:	5d                   	pop    %ebp
80105738:	c3                   	ret
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105740:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105747:	00 00 00 00 
  return exec(path, argv);
8010574b:	83 ec 08             	sub    $0x8,%esp
8010574e:	56                   	push   %esi
8010574f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105755:	e8 26 b4 ff ff       	call   80100b80 <exec>
8010575a:	83 c4 10             	add    $0x10,%esp
}
8010575d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105760:	5b                   	pop    %ebx
80105761:	5e                   	pop    %esi
80105762:	5f                   	pop    %edi
80105763:	5d                   	pop    %ebp
80105764:	c3                   	ret
80105765:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010576c:	00 
8010576d:	8d 76 00             	lea    0x0(%esi),%esi

80105770 <sys_pipe>:

int
sys_pipe(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105775:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105778:	53                   	push   %ebx
80105779:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010577c:	6a 08                	push   $0x8
8010577e:	50                   	push   %eax
8010577f:	6a 00                	push   $0x0
80105781:	e8 da f3 ff ff       	call   80104b60 <argptr>
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	85 c0                	test   %eax,%eax
8010578b:	0f 88 8b 00 00 00    	js     8010581c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105791:	83 ec 08             	sub    $0x8,%esp
80105794:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105797:	50                   	push   %eax
80105798:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010579b:	50                   	push   %eax
8010579c:	e8 8f dd ff ff       	call   80103530 <pipealloc>
801057a1:	83 c4 10             	add    $0x10,%esp
801057a4:	85 c0                	test   %eax,%eax
801057a6:	78 74                	js     8010581c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057ab:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057ad:	e8 fe e2 ff ff       	call   80103ab0 <myproc>
    if(curproc->ofile[fd] == 0){
801057b2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057b6:	85 f6                	test   %esi,%esi
801057b8:	74 16                	je     801057d0 <sys_pipe+0x60>
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057c0:	83 c3 01             	add    $0x1,%ebx
801057c3:	83 fb 10             	cmp    $0x10,%ebx
801057c6:	74 3d                	je     80105805 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801057c8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057cc:	85 f6                	test   %esi,%esi
801057ce:	75 f0                	jne    801057c0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801057d0:	8d 73 08             	lea    0x8(%ebx),%esi
801057d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801057da:	e8 d1 e2 ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057df:	31 d2                	xor    %edx,%edx
801057e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801057e8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801057ec:	85 c9                	test   %ecx,%ecx
801057ee:	74 38                	je     80105828 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
801057f0:	83 c2 01             	add    $0x1,%edx
801057f3:	83 fa 10             	cmp    $0x10,%edx
801057f6:	75 f0                	jne    801057e8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801057f8:	e8 b3 e2 ff ff       	call   80103ab0 <myproc>
801057fd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105804:	00 
    fileclose(rf);
80105805:	83 ec 0c             	sub    $0xc,%esp
80105808:	ff 75 e0             	push   -0x20(%ebp)
8010580b:	e8 d0 b7 ff ff       	call   80100fe0 <fileclose>
    fileclose(wf);
80105810:	58                   	pop    %eax
80105811:	ff 75 e4             	push   -0x1c(%ebp)
80105814:	e8 c7 b7 ff ff       	call   80100fe0 <fileclose>
    return -1;
80105819:	83 c4 10             	add    $0x10,%esp
    return -1;
8010581c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105821:	eb 16                	jmp    80105839 <sys_pipe+0xc9>
80105823:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105828:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010582c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010582f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105831:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105834:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105837:	31 c0                	xor    %eax,%eax
}
80105839:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010583c:	5b                   	pop    %ebx
8010583d:	5e                   	pop    %esi
8010583e:	5f                   	pop    %edi
8010583f:	5d                   	pop    %ebp
80105840:	c3                   	ret
80105841:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105848:	00 
80105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105850 <sys_copy>:

int sys_copy(void) {
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	57                   	push   %edi
80105854:	56                   	push   %esi
    char *src, *dst;

    if (argstr(0, &src) < 0 || argstr(1, &dst) < 0) {
80105855:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
int sys_copy(void) {
8010585b:	53                   	push   %ebx
8010585c:	81 ec 34 02 00 00    	sub    $0x234,%esp
    if (argstr(0, &src) < 0 || argstr(1, &dst) < 0) {
80105862:	50                   	push   %eax
80105863:	6a 00                	push   $0x0
80105865:	e8 66 f3 ff ff       	call   80104bd0 <argstr>
8010586a:	83 c4 10             	add    $0x10,%esp
8010586d:	85 c0                	test   %eax,%eax
8010586f:	0f 88 6f 01 00 00    	js     801059e4 <sys_copy+0x194>
80105875:	83 ec 08             	sub    $0x8,%esp
80105878:	8d 85 e4 fd ff ff    	lea    -0x21c(%ebp),%eax
8010587e:	50                   	push   %eax
8010587f:	6a 01                	push   $0x1
80105881:	e8 4a f3 ff ff       	call   80104bd0 <argstr>
80105886:	83 c4 10             	add    $0x10,%esp
80105889:	85 c0                	test   %eax,%eax
8010588b:	0f 88 53 01 00 00    	js     801059e4 <sys_copy+0x194>
        cprintf("sys_copy: invalid arguments\n");
        return -1;
    }
    cprintf("sys_copy: src=%s, dst=%s\n", src, dst);
80105891:	83 ec 04             	sub    $0x4,%esp
80105894:	ff b5 e4 fd ff ff    	push   -0x21c(%ebp)
8010589a:	ff b5 e0 fd ff ff    	push   -0x220(%ebp)
801058a0:	68 4b 7e 10 80       	push   $0x80107e4b
801058a5:	e8 06 ae ff ff       	call   801006b0 <cprintf>
    char buffer[512];
    int n;


    // Open the source file
    begin_op();
801058aa:	e8 61 d5 ff ff       	call   80102e10 <begin_op>
    if ((src_inode = namei(src)) == 0) {
801058af:	5e                   	pop    %esi
801058b0:	ff b5 e0 fd ff ff    	push   -0x220(%ebp)
801058b6:	e8 95 c8 ff ff       	call   80102150 <namei>
801058bb:	83 c4 10             	add    $0x10,%esp
801058be:	89 c3                	mov    %eax,%ebx
801058c0:	85 c0                	test   %eax,%eax
801058c2:	0f 84 54 01 00 00    	je     80105a1c <sys_copy+0x1cc>
        end_op();
        return -1;  // Source file not found
    }
    ilock(src_inode);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	50                   	push   %eax
801058cc:	e8 9f bf ff ff       	call   80101870 <ilock>

    if ((src_file = filealloc()) == 0) {
801058d1:	e8 4a b6 ff ff       	call   80100f20 <filealloc>
801058d6:	83 c4 10             	add    $0x10,%esp
801058d9:	89 c6                	mov    %eax,%esi
801058db:	85 c0                	test   %eax,%eax
801058dd:	0f 84 26 01 00 00    	je     80105a09 <sys_copy+0x1b9>
        end_op();
        return -1;  // Unable to allocate file structure for source
    }

    src_file->type = FD_INODE;
    src_file->ip = src_inode;
801058e3:	89 58 10             	mov    %ebx,0x10(%eax)
    src_file->off = 0;
    src_file->readable = 1;
    src_file->writable = 0;

    // Create or overwrite the destination file
    if ((dst_inode = create(dst, T_FILE, 0, 0)) == 0) {
801058e6:	83 ec 0c             	sub    $0xc,%esp
    src_file->readable = 1;
801058e9:	bb 01 00 00 00       	mov    $0x1,%ebx
    if ((dst_inode = create(dst, T_FILE, 0, 0)) == 0) {
801058ee:	31 c9                	xor    %ecx,%ecx
    src_file->readable = 1;
801058f0:	66 89 58 08          	mov    %bx,0x8(%eax)
    if ((dst_inode = create(dst, T_FILE, 0, 0)) == 0) {
801058f4:	ba 02 00 00 00       	mov    $0x2,%edx
    src_file->type = FD_INODE;
801058f9:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    src_file->off = 0;
801058ff:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    if ((dst_inode = create(dst, T_FILE, 0, 0)) == 0) {
80105906:	6a 00                	push   $0x0
80105908:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
8010590e:	e8 ad f3 ff ff       	call   80104cc0 <create>
80105913:	83 c4 10             	add    $0x10,%esp
80105916:	89 c3                	mov    %eax,%ebx
80105918:	85 c0                	test   %eax,%eax
8010591a:	0f 84 d6 00 00 00    	je     801059f6 <sys_copy+0x1a6>
        fileclose(src_file);
        end_op();
        return -1;  // Unable to create destination file
    }

    if ((dst_file = filealloc()) == 0) {
80105920:	e8 fb b5 ff ff       	call   80100f20 <filealloc>
80105925:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
8010592b:	85 c0                	test   %eax,%eax
8010592d:	0f 84 f0 00 00 00    	je     80105a23 <sys_copy+0x1d3>
        iunlockput(dst_inode);
        end_op();
        return -1;  // Unable to allocate file structure for destination
    }

    dst_file->type = FD_INODE;
80105933:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
    dst_file->ip = dst_inode;
    dst_file->off = 0;
    dst_file->readable = 0;
80105939:	b9 00 01 00 00       	mov    $0x100,%ecx
    dst_file->ip = dst_inode;
8010593e:	89 58 10             	mov    %ebx,0x10(%eax)
80105941:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
    dst_file->type = FD_INODE;
80105947:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    dst_file->off = 0;
8010594d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    dst_file->readable = 0;
80105954:	66 89 48 08          	mov    %cx,0x8(%eax)
    dst_file->writable = 1;

    // Copy data from source to destination
    while ((n = fileread(src_file, buffer, sizeof(buffer))) > 0) {
80105958:	eb 1d                	jmp    80105977 <sys_copy+0x127>
8010595a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (filewrite(dst_file, buffer, n) != n) {
80105960:	83 ec 04             	sub    $0x4,%esp
80105963:	57                   	push   %edi
80105964:	53                   	push   %ebx
80105965:	ff b5 d4 fd ff ff    	push   -0x22c(%ebp)
8010596b:	e8 30 b8 ff ff       	call   801011a0 <filewrite>
80105970:	83 c4 10             	add    $0x10,%esp
80105973:	39 f8                	cmp    %edi,%eax
80105975:	75 49                	jne    801059c0 <sys_copy+0x170>
    while ((n = fileread(src_file, buffer, sizeof(buffer))) > 0) {
80105977:	83 ec 04             	sub    $0x4,%esp
8010597a:	68 00 02 00 00       	push   $0x200
8010597f:	53                   	push   %ebx
80105980:	56                   	push   %esi
80105981:	e8 8a b7 ff ff       	call   80101110 <fileread>
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	89 c7                	mov    %eax,%edi
8010598b:	85 c0                	test   %eax,%eax
8010598d:	7f d1                	jg     80105960 <sys_copy+0x110>
            return -1;  // Write error
        }
    }

    // Close the files
    fileclose(src_file);
8010598f:	83 ec 0c             	sub    $0xc,%esp
80105992:	56                   	push   %esi
80105993:	e8 48 b6 ff ff       	call   80100fe0 <fileclose>
    fileclose(dst_file);
80105998:	58                   	pop    %eax
80105999:	ff b5 d4 fd ff ff    	push   -0x22c(%ebp)
8010599f:	e8 3c b6 ff ff       	call   80100fe0 <fileclose>
    end_op();
801059a4:	e8 d7 d4 ff ff       	call   80102e80 <end_op>

    return 0;  // Success
801059a9:	83 c4 10             	add    $0x10,%esp
801059ac:	31 c0                	xor    %eax,%eax
}
801059ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059b1:	5b                   	pop    %ebx
801059b2:	5e                   	pop    %esi
801059b3:	5f                   	pop    %edi
801059b4:	5d                   	pop    %ebp
801059b5:	c3                   	ret
801059b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059bd:	00 
801059be:	66 90                	xchg   %ax,%ax
            fileclose(src_file);
801059c0:	83 ec 0c             	sub    $0xc,%esp
801059c3:	56                   	push   %esi
801059c4:	e8 17 b6 ff ff       	call   80100fe0 <fileclose>
            fileclose(dst_file);
801059c9:	5a                   	pop    %edx
801059ca:	ff b5 d4 fd ff ff    	push   -0x22c(%ebp)
801059d0:	e8 0b b6 ff ff       	call   80100fe0 <fileclose>
            end_op();
801059d5:	e8 a6 d4 ff ff       	call   80102e80 <end_op>
            return -1;  // Write error
801059da:	83 c4 10             	add    $0x10,%esp
        return -1;
801059dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e2:	eb ca                	jmp    801059ae <sys_copy+0x15e>
        cprintf("sys_copy: invalid arguments\n");
801059e4:	83 ec 0c             	sub    $0xc,%esp
801059e7:	68 2e 7e 10 80       	push   $0x80107e2e
801059ec:	e8 bf ac ff ff       	call   801006b0 <cprintf>
        return -1;
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	eb e7                	jmp    801059dd <sys_copy+0x18d>
        fileclose(src_file);
801059f6:	83 ec 0c             	sub    $0xc,%esp
801059f9:	56                   	push   %esi
801059fa:	e8 e1 b5 ff ff       	call   80100fe0 <fileclose>
        end_op();
801059ff:	e8 7c d4 ff ff       	call   80102e80 <end_op>
        return -1;  // Unable to create destination file
80105a04:	83 c4 10             	add    $0x10,%esp
80105a07:	eb d4                	jmp    801059dd <sys_copy+0x18d>
        iunlockput(src_inode);
80105a09:	83 ec 0c             	sub    $0xc,%esp
80105a0c:	53                   	push   %ebx
80105a0d:	e8 ee c0 ff ff       	call   80101b00 <iunlockput>
        end_op();
80105a12:	e8 69 d4 ff ff       	call   80102e80 <end_op>
        return -1;  // Unable to allocate file structure for source
80105a17:	83 c4 10             	add    $0x10,%esp
80105a1a:	eb c1                	jmp    801059dd <sys_copy+0x18d>
        end_op();
80105a1c:	e8 5f d4 ff ff       	call   80102e80 <end_op>
        return -1;  // Source file not found
80105a21:	eb ba                	jmp    801059dd <sys_copy+0x18d>
        fileclose(src_file);
80105a23:	83 ec 0c             	sub    $0xc,%esp
80105a26:	56                   	push   %esi
80105a27:	e8 b4 b5 ff ff       	call   80100fe0 <fileclose>
        iunlockput(dst_inode);
80105a2c:	89 1c 24             	mov    %ebx,(%esp)
80105a2f:	e8 cc c0 ff ff       	call   80101b00 <iunlockput>
        end_op();
80105a34:	e8 47 d4 ff ff       	call   80102e80 <end_op>
        return -1;  // Unable to allocate file structure for destination
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	eb 9f                	jmp    801059dd <sys_copy+0x18d>
80105a3e:	66 90                	xchg   %ax,%ax

80105a40 <sys_fork>:
// VGA memory location
#define VGA_MEMORY 0xB8000
#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 25
int sys_fork(void) {
    return fork();
80105a40:	e9 3b e3 ff ff       	jmp    80103d80 <fork>
80105a45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a4c:	00 
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi

80105a50 <sys_exit>:
}

int sys_exit(void) {
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 08             	sub    $0x8,%esp
    exit();
80105a56:	e8 15 e5 ff ff       	call   80103f70 <exit>
    return 0;  // not reached
}
80105a5b:	31 c0                	xor    %eax,%eax
80105a5d:	c9                   	leave
80105a5e:	c3                   	ret
80105a5f:	90                   	nop

80105a60 <sys_wait>:

int sys_wait(void) {
    return wait();
80105a60:	e9 5b e6 ff ff       	jmp    801040c0 <wait>
80105a65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a6c:	00 
80105a6d:	8d 76 00             	lea    0x0(%esi),%esi

80105a70 <sys_kill>:
}

int sys_kill(void) {
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	83 ec 20             	sub    $0x20,%esp
    int pid;

    if (argint(0, &pid) < 0)
80105a76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a79:	50                   	push   %eax
80105a7a:	6a 00                	push   $0x0
80105a7c:	e8 8f f0 ff ff       	call   80104b10 <argint>
80105a81:	83 c4 10             	add    $0x10,%esp
80105a84:	85 c0                	test   %eax,%eax
80105a86:	78 18                	js     80105aa0 <sys_kill+0x30>
        return -1;
    return kill(pid);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	ff 75 f4             	push   -0xc(%ebp)
80105a8e:	e8 cd e8 ff ff       	call   80104360 <kill>
80105a93:	83 c4 10             	add    $0x10,%esp
}
80105a96:	c9                   	leave
80105a97:	c3                   	ret
80105a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a9f:	00 
80105aa0:	c9                   	leave
        return -1;
80105aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa6:	c3                   	ret
80105aa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aae:	00 
80105aaf:	90                   	nop

80105ab0 <sys_getpid>:

int sys_getpid(void) {
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
80105ab6:	e8 f5 df ff ff       	call   80103ab0 <myproc>
80105abb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105abe:	c9                   	leave
80105abf:	c3                   	ret

80105ac0 <sys_sbrk>:

int sys_sbrk(void) {
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
    int addr;
    int n;

    if (argint(0, &n) < 0)
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sbrk(void) {
80105ac7:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0)
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 3e f0 ff ff       	call   80104b10 <argint>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 27                	js     80105b00 <sys_sbrk+0x40>
        return -1;
    addr = myproc()->sz;
80105ad9:	e8 d2 df ff ff       	call   80103ab0 <myproc>
    if (growproc(n) < 0)
80105ade:	83 ec 0c             	sub    $0xc,%esp
    addr = myproc()->sz;
80105ae1:	8b 18                	mov    (%eax),%ebx
    if (growproc(n) < 0)
80105ae3:	ff 75 f4             	push   -0xc(%ebp)
80105ae6:	e8 15 e2 ff ff       	call   80103d00 <growproc>
80105aeb:	83 c4 10             	add    $0x10,%esp
80105aee:	85 c0                	test   %eax,%eax
80105af0:	78 0e                	js     80105b00 <sys_sbrk+0x40>
        return -1;
    return addr;
}
80105af2:	89 d8                	mov    %ebx,%eax
80105af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af7:	c9                   	leave
80105af8:	c3                   	ret
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105b00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b05:	eb eb                	jmp    80105af2 <sys_sbrk+0x32>
80105b07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b0e:	00 
80105b0f:	90                   	nop

80105b10 <sys_sleep>:

int sys_sleep(void) {
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
80105b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
80105b17:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0)
80105b1a:	50                   	push   %eax
80105b1b:	6a 00                	push   $0x0
80105b1d:	e8 ee ef ff ff       	call   80104b10 <argint>
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	85 c0                	test   %eax,%eax
80105b27:	78 64                	js     80105b8d <sys_sleep+0x7d>
        return -1;
    acquire(&tickslock);
80105b29:	83 ec 0c             	sub    $0xc,%esp
80105b2c:	68 c0 76 11 80       	push   $0x801176c0
80105b31:	e8 2a ec ff ff       	call   80104760 <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
80105b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
    ticks0 = ticks;
80105b39:	8b 1d a0 76 11 80    	mov    0x801176a0,%ebx
    while (ticks - ticks0 < n) {
80105b3f:	83 c4 10             	add    $0x10,%esp
80105b42:	85 d2                	test   %edx,%edx
80105b44:	75 2b                	jne    80105b71 <sys_sleep+0x61>
80105b46:	eb 58                	jmp    80105ba0 <sys_sleep+0x90>
80105b48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b4f:	00 
        if (myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
80105b50:	83 ec 08             	sub    $0x8,%esp
80105b53:	68 c0 76 11 80       	push   $0x801176c0
80105b58:	68 a0 76 11 80       	push   $0x801176a0
80105b5d:	e8 de e6 ff ff       	call   80104240 <sleep>
    while (ticks - ticks0 < n) {
80105b62:	a1 a0 76 11 80       	mov    0x801176a0,%eax
80105b67:	83 c4 10             	add    $0x10,%esp
80105b6a:	29 d8                	sub    %ebx,%eax
80105b6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b6f:	73 2f                	jae    80105ba0 <sys_sleep+0x90>
        if (myproc()->killed) {
80105b71:	e8 3a df ff ff       	call   80103ab0 <myproc>
80105b76:	8b 40 24             	mov    0x24(%eax),%eax
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	74 d3                	je     80105b50 <sys_sleep+0x40>
            release(&tickslock);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	68 c0 76 11 80       	push   $0x801176c0
80105b85:	e8 76 eb ff ff       	call   80104700 <release>
            return -1;
80105b8a:	83 c4 10             	add    $0x10,%esp
    }
    release(&tickslock);
    return 0;
}
80105b8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        return -1;
80105b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b95:	c9                   	leave
80105b96:	c3                   	ret
80105b97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b9e:	00 
80105b9f:	90                   	nop
    release(&tickslock);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	68 c0 76 11 80       	push   $0x801176c0
80105ba8:	e8 53 eb ff ff       	call   80104700 <release>
}
80105bad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80105bb0:	83 c4 10             	add    $0x10,%esp
80105bb3:	31 c0                	xor    %eax,%eax
}
80105bb5:	c9                   	leave
80105bb6:	c3                   	ret
80105bb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bbe:	00 
80105bbf:	90                   	nop

80105bc0 <sys_uptime>:

int sys_uptime(void) {
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	53                   	push   %ebx
80105bc4:	83 ec 10             	sub    $0x10,%esp
    uint xticks;

    acquire(&tickslock);
80105bc7:	68 c0 76 11 80       	push   $0x801176c0
80105bcc:	e8 8f eb ff ff       	call   80104760 <acquire>
    xticks = ticks;
80105bd1:	8b 1d a0 76 11 80    	mov    0x801176a0,%ebx
    release(&tickslock);
80105bd7:	c7 04 24 c0 76 11 80 	movl   $0x801176c0,(%esp)
80105bde:	e8 1d eb ff ff       	call   80104700 <release>
    return xticks;
}
80105be3:	89 d8                	mov    %ebx,%eax
80105be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105be8:	c9                   	leave
80105be9:	c3                   	ret
80105bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bf0 <sys_getppid>:

int sys_getppid(void) {
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 08             	sub    $0x8,%esp
    return myproc()->parent->pid;
80105bf6:	e8 b5 de ff ff       	call   80103ab0 <myproc>
80105bfb:	8b 40 14             	mov    0x14(%eax),%eax
80105bfe:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c01:	c9                   	leave
80105c02:	c3                   	ret
80105c03:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c0a:	00 
80105c0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105c10 <sys_shmget>:

// Shared memory allocation
int sys_shmget(void) {
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	53                   	push   %ebx
80105c14:	83 ec 04             	sub    $0x4,%esp
    if (!shared_memory) {
80105c17:	8b 1d 98 76 11 80    	mov    0x80117698,%ebx
80105c1d:	85 db                	test   %ebx,%ebx
80105c1f:	74 3f                	je     80105c60 <sys_shmget+0x50>
            return -1; // Memory allocation failed
        }
        memset(shared_memory, 0, PGSIZE);
    }

    if (mappages(myproc()->pgdir, (void *)SHMEM, PGSIZE, V2P(shared_memory), PTE_W | PTE_U) < 0) {
80105c21:	e8 8a de ff ff       	call   80103ab0 <myproc>
80105c26:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80105c2c:	83 ec 0c             	sub    $0xc,%esp
80105c2f:	6a 06                	push   $0x6
80105c31:	53                   	push   %ebx
80105c32:	68 00 10 00 00       	push   $0x1000
80105c37:	68 00 00 00 80       	push   $0x80000000
80105c3c:	ff 70 04             	push   0x4(%eax)
80105c3f:	e8 4c 15 00 00       	call   80107190 <mappages>
80105c44:	83 c4 20             	add    $0x20,%esp
80105c47:	89 c2                	mov    %eax,%edx
        cprintf("sys_shmget: mappages failed\n");
        return -1; // Mapping failed
    }

    return SHMEM; // Success
80105c49:	b8 00 00 00 80       	mov    $0x80000000,%eax
    if (mappages(myproc()->pgdir, (void *)SHMEM, PGSIZE, V2P(shared_memory), PTE_W | PTE_U) < 0) {
80105c4e:	85 d2                	test   %edx,%edx
80105c50:	78 3e                	js     80105c90 <sys_shmget+0x80>
}
80105c52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c55:	c9                   	leave
80105c56:	c3                   	ret
80105c57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c5e:	00 
80105c5f:	90                   	nop
        shared_memory = kalloc();
80105c60:	e8 cb ca ff ff       	call   80102730 <kalloc>
80105c65:	a3 98 76 11 80       	mov    %eax,0x80117698
        if (!shared_memory) {
80105c6a:	85 c0                	test   %eax,%eax
80105c6c:	74 42                	je     80105cb0 <sys_shmget+0xa0>
        memset(shared_memory, 0, PGSIZE);
80105c6e:	83 ec 04             	sub    $0x4,%esp
80105c71:	68 00 10 00 00       	push   $0x1000
80105c76:	6a 00                	push   $0x0
80105c78:	50                   	push   %eax
80105c79:	e8 e2 eb ff ff       	call   80104860 <memset>
    if (mappages(myproc()->pgdir, (void *)SHMEM, PGSIZE, V2P(shared_memory), PTE_W | PTE_U) < 0) {
80105c7e:	8b 1d 98 76 11 80    	mov    0x80117698,%ebx
80105c84:	83 c4 10             	add    $0x10,%esp
80105c87:	eb 98                	jmp    80105c21 <sys_shmget+0x11>
80105c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf("sys_shmget: mappages failed\n");
80105c90:	83 ec 0c             	sub    $0xc,%esp
80105c93:	68 80 7e 10 80       	push   $0x80107e80
80105c98:	e8 13 aa ff ff       	call   801006b0 <cprintf>
        return -1; // Mapping failed
80105c9d:	83 c4 10             	add    $0x10,%esp
}
80105ca0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return -1; // Memory allocation failed
80105ca3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ca8:	c9                   	leave
80105ca9:	c3                   	ret
80105caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            cprintf("sys_shmget: kalloc failed\n");
80105cb0:	83 ec 0c             	sub    $0xc,%esp
80105cb3:	68 65 7e 10 80       	push   $0x80107e65
80105cb8:	e8 f3 a9 ff ff       	call   801006b0 <cprintf>
            return -1; // Memory allocation failed
80105cbd:	83 c4 10             	add    $0x10,%esp
80105cc0:	eb de                	jmp    80105ca0 <sys_shmget+0x90>
80105cc2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cc9:	00 
80105cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cd0 <sys_shmrem>:

// Free shared memory
int sys_shmrem(void) {
    if (!shared_memory)
80105cd0:	a1 98 76 11 80       	mov    0x80117698,%eax
80105cd5:	85 c0                	test   %eax,%eax
80105cd7:	74 1d                	je     80105cf6 <sys_shmrem+0x26>
int sys_shmrem(void) {
80105cd9:	55                   	push   %ebp
80105cda:	89 e5                	mov    %esp,%ebp
80105cdc:	83 ec 14             	sub    $0x14,%esp
        return -1;  // Shared memory is not allocated

    kfree(shared_memory);
80105cdf:	50                   	push   %eax
80105ce0:	e8 8b c8 ff ff       	call   80102570 <kfree>
    shared_memory = 0;

    return 0;  // Success
80105ce5:	83 c4 10             	add    $0x10,%esp
80105ce8:	31 c0                	xor    %eax,%eax
    shared_memory = 0;
80105cea:	c7 05 98 76 11 80 00 	movl   $0x0,0x80117698
80105cf1:	00 00 00 
}
80105cf4:	c9                   	leave
80105cf5:	c3                   	ret
        return -1;  // Shared memory is not allocated
80105cf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cfb:	c3                   	ret
80105cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d00 <sys_signal>:

// Signal handling
int sys_signal(void) {
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	83 ec 20             	sub    $0x20,%esp
    int signum;
    void (*handler)(void);

    if (argint(0, &signum) < 0 || argptr(1, (void *)&handler, sizeof(void *)) < 0) {
80105d06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d09:	50                   	push   %eax
80105d0a:	6a 00                	push   $0x0
80105d0c:	e8 ff ed ff ff       	call   80104b10 <argint>
80105d11:	83 c4 10             	add    $0x10,%esp
80105d14:	85 c0                	test   %eax,%eax
80105d16:	78 38                	js     80105d50 <sys_signal+0x50>
80105d18:	83 ec 04             	sub    $0x4,%esp
80105d1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d1e:	6a 04                	push   $0x4
80105d20:	50                   	push   %eax
80105d21:	6a 01                	push   $0x1
80105d23:	e8 38 ee ff ff       	call   80104b60 <argptr>
80105d28:	83 c4 10             	add    $0x10,%esp
80105d2b:	85 c0                	test   %eax,%eax
80105d2d:	78 21                	js     80105d50 <sys_signal+0x50>
        return -1;
    }

    if (signum < 0 || signum >= NUMSIGNALS) {
80105d2f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
80105d33:	77 1b                	ja     80105d50 <sys_signal+0x50>
        return -1;  // Invalid signal number
    }

    myproc()->signal_handlers[signum] = handler;  // Set the handler
80105d35:	e8 76 dd ff ff       	call   80103ab0 <myproc>
80105d3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d3d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105d40:	89 4c 90 7c          	mov    %ecx,0x7c(%eax,%edx,4)
    return 0;
80105d44:	31 c0                	xor    %eax,%eax
}
80105d46:	c9                   	leave
80105d47:	c3                   	ret
80105d48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d4f:	00 
80105d50:	c9                   	leave
        return -1;
80105d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d56:	c3                   	ret
80105d57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d5e:	00 
80105d5f:	90                   	nop

80105d60 <sys_send>:

// Send message to the queue
int sys_send(void) {
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 20             	sub    $0x20,%esp
    int type;
    char *msg;

    // Retrieve arguments from user space
    if (argint(0, &type) < 0 || argptr(1, &msg, MSG_SIZE) < 0) {
80105d66:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d69:	50                   	push   %eax
80105d6a:	6a 00                	push   $0x0
80105d6c:	e8 9f ed ff ff       	call   80104b10 <argint>
80105d71:	83 c4 10             	add    $0x10,%esp
80105d74:	85 c0                	test   %eax,%eax
80105d76:	0f 88 9d 00 00 00    	js     80105e19 <sys_send+0xb9>
80105d7c:	83 ec 04             	sub    $0x4,%esp
80105d7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d82:	6a 20                	push   $0x20
80105d84:	50                   	push   %eax
80105d85:	6a 01                	push   $0x1
80105d87:	e8 d4 ed ff ff       	call   80104b60 <argptr>
80105d8c:	83 c4 10             	add    $0x10,%esp
80105d8f:	85 c0                	test   %eax,%eax
80105d91:	0f 88 82 00 00 00    	js     80105e19 <sys_send+0xb9>
        return -1;  // Invalid arguments
    }

    acquire(&msgq.lock);
80105d97:	83 ec 0c             	sub    $0xc,%esp
80105d9a:	68 80 27 11 80       	push   $0x80112780
80105d9f:	e8 bc e9 ff ff       	call   80104760 <acquire>

    // Check if the queue is full
    if (msgq.count == MAX_MESSAGES) {
80105da4:	83 c4 10             	add    $0x10,%esp
80105da7:	83 3d bc 30 11 80 40 	cmpl   $0x40,0x801130bc
80105dae:	74 59                	je     80105e09 <sys_send+0xa9>
        release(&msgq.lock);
        return -1;  // Queue is full
    }

    // Add the message to the queue
    msgq.messages[msgq.tail].type = type;
80105db0:	a1 b8 30 11 80       	mov    0x801130b8,%eax
80105db5:	8b 55 f0             	mov    -0x10(%ebp),%edx
    safestrcpy(msgq.messages[msgq.tail].data, msg, MSG_SIZE);
80105db8:	83 ec 04             	sub    $0x4,%esp
80105dbb:	6a 20                	push   $0x20
    msgq.messages[msgq.tail].type = type;
80105dbd:	8d 04 c0             	lea    (%eax,%eax,8),%eax
    safestrcpy(msgq.messages[msgq.tail].data, msg, MSG_SIZE);
80105dc0:	ff 75 f4             	push   -0xc(%ebp)
    msgq.messages[msgq.tail].type = type;
80105dc3:	c1 e0 02             	shl    $0x2,%eax
80105dc6:	89 90 b4 27 11 80    	mov    %edx,-0x7feed84c(%eax)
    safestrcpy(msgq.messages[msgq.tail].data, msg, MSG_SIZE);
80105dcc:	05 b8 27 11 80       	add    $0x801127b8,%eax
80105dd1:	50                   	push   %eax
80105dd2:	e8 39 ec ff ff       	call   80104a10 <safestrcpy>
    msgq.tail = (msgq.tail + 1) % MAX_MESSAGES;
80105dd7:	a1 b8 30 11 80       	mov    0x801130b8,%eax
    msgq.count++;

    release(&msgq.lock);
80105ddc:	c7 04 24 80 27 11 80 	movl   $0x80112780,(%esp)
    msgq.count++;
80105de3:	83 05 bc 30 11 80 01 	addl   $0x1,0x801130bc
    msgq.tail = (msgq.tail + 1) % MAX_MESSAGES;
80105dea:	83 c0 01             	add    $0x1,%eax
80105ded:	99                   	cltd
80105dee:	c1 ea 1a             	shr    $0x1a,%edx
80105df1:	01 d0                	add    %edx,%eax
80105df3:	83 e0 3f             	and    $0x3f,%eax
80105df6:	29 d0                	sub    %edx,%eax
80105df8:	a3 b8 30 11 80       	mov    %eax,0x801130b8
    release(&msgq.lock);
80105dfd:	e8 fe e8 ff ff       	call   80104700 <release>
    return 0;  // Success
80105e02:	83 c4 10             	add    $0x10,%esp
80105e05:	31 c0                	xor    %eax,%eax
}
80105e07:	c9                   	leave
80105e08:	c3                   	ret
        release(&msgq.lock);
80105e09:	83 ec 0c             	sub    $0xc,%esp
80105e0c:	68 80 27 11 80       	push   $0x80112780
80105e11:	e8 ea e8 ff ff       	call   80104700 <release>
        return -1;  // Queue is full
80105e16:	83 c4 10             	add    $0x10,%esp
}
80105e19:	c9                   	leave
        return -1;  // Invalid arguments
80105e1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e1f:	c3                   	ret

80105e20 <sys_recv>:

// Receive message from the queue
int sys_recv(void) {
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	56                   	push   %esi
80105e24:	53                   	push   %ebx
    int type;
    char *msg;

    // Retrieve arguments from user space
    if (argint(0, &type) < 0 || argptr(1, &msg, MSG_SIZE) < 0) {
80105e25:	8d 45 f0             	lea    -0x10(%ebp),%eax
int sys_recv(void) {
80105e28:	83 ec 18             	sub    $0x18,%esp
    if (argint(0, &type) < 0 || argptr(1, &msg, MSG_SIZE) < 0) {
80105e2b:	50                   	push   %eax
80105e2c:	6a 00                	push   $0x0
80105e2e:	e8 dd ec ff ff       	call   80104b10 <argint>
80105e33:	83 c4 10             	add    $0x10,%esp
80105e36:	85 c0                	test   %eax,%eax
80105e38:	0f 88 32 01 00 00    	js     80105f70 <sys_recv+0x150>
80105e3e:	83 ec 04             	sub    $0x4,%esp
80105e41:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e44:	6a 20                	push   $0x20
80105e46:	50                   	push   %eax
80105e47:	6a 01                	push   $0x1
80105e49:	e8 12 ed ff ff       	call   80104b60 <argptr>
80105e4e:	83 c4 10             	add    $0x10,%esp
80105e51:	85 c0                	test   %eax,%eax
80105e53:	0f 88 17 01 00 00    	js     80105f70 <sys_recv+0x150>
        return -1;  // Invalid arguments
    }

    acquire(&msgq.lock);
80105e59:	83 ec 0c             	sub    $0xc,%esp
80105e5c:	68 80 27 11 80       	push   $0x80112780
80105e61:	e8 fa e8 ff ff       	call   80104760 <acquire>

    // Search for a message with the specified type
    for (int i = 0; i < msgq.count; i++) {
80105e66:	8b 0d bc 30 11 80    	mov    0x801130bc,%ecx
80105e6c:	83 c4 10             	add    $0x10,%esp
80105e6f:	85 c9                	test   %ecx,%ecx
80105e71:	0f 8e e9 00 00 00    	jle    80105f60 <sys_recv+0x140>
80105e77:	a1 b4 30 11 80       	mov    0x801130b4,%eax
        int index = (msgq.head + i) % MAX_MESSAGES;
        if (msgq.messages[index].type == type) {
80105e7c:	8b 75 f0             	mov    -0x10(%ebp),%esi
80105e7f:	01 c1                	add    %eax,%ecx
80105e81:	eb 10                	jmp    80105e93 <sys_recv+0x73>
80105e83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    for (int i = 0; i < msgq.count; i++) {
80105e88:	83 c0 01             	add    $0x1,%eax
80105e8b:	39 c1                	cmp    %eax,%ecx
80105e8d:	0f 84 cd 00 00 00    	je     80105f60 <sys_recv+0x140>
        int index = (msgq.head + i) % MAX_MESSAGES;
80105e93:	99                   	cltd
80105e94:	c1 ea 1a             	shr    $0x1a,%edx
80105e97:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
80105e9a:	83 e3 3f             	and    $0x3f,%ebx
80105e9d:	29 d3                	sub    %edx,%ebx
        if (msgq.messages[index].type == type) {
80105e9f:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80105ea2:	c1 e2 02             	shl    $0x2,%edx
80105ea5:	39 b2 b4 27 11 80    	cmp    %esi,-0x7feed84c(%edx)
80105eab:	75 db                	jne    80105e88 <sys_recv+0x68>
            // Copy the message to user space
            safestrcpy(msg, msgq.messages[index].data, MSG_SIZE);
80105ead:	83 ec 04             	sub    $0x4,%esp
80105eb0:	81 c2 b8 27 11 80    	add    $0x801127b8,%edx
80105eb6:	6a 20                	push   $0x20
80105eb8:	52                   	push   %edx
80105eb9:	ff 75 f4             	push   -0xc(%ebp)
80105ebc:	e8 4f eb ff ff       	call   80104a10 <safestrcpy>

            // Remove the message from the queue
            for (int j = index; j != msgq.tail; j = (j + 1) % MAX_MESSAGES) {
80105ec1:	8b 0d b8 30 11 80    	mov    0x801130b8,%ecx
80105ec7:	83 c4 10             	add    $0x10,%esp
80105eca:	39 d9                	cmp    %ebx,%ecx
80105ecc:	74 64                	je     80105f32 <sys_recv+0x112>
80105ece:	66 90                	xchg   %ax,%ax
                msgq.messages[j] = msgq.messages[(j + 1) % MAX_MESSAGES];
80105ed0:	89 da                	mov    %ebx,%edx
80105ed2:	8d 5b 01             	lea    0x1(%ebx),%ebx
80105ed5:	89 d8                	mov    %ebx,%eax
80105ed7:	c1 f8 1f             	sar    $0x1f,%eax
80105eda:	c1 e8 1a             	shr    $0x1a,%eax
80105edd:	01 c3                	add    %eax,%ebx
80105edf:	83 e3 3f             	and    $0x3f,%ebx
80105ee2:	29 c3                	sub    %eax,%ebx
80105ee4:	8d 04 d2             	lea    (%edx,%edx,8),%eax
80105ee7:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80105eea:	8d 04 85 b0 27 11 80 	lea    -0x7feed850(,%eax,4),%eax
80105ef1:	8d 14 95 b0 27 11 80 	lea    -0x7feed850(,%edx,4),%edx
80105ef8:	8b 72 04             	mov    0x4(%edx),%esi
80105efb:	89 70 04             	mov    %esi,0x4(%eax)
80105efe:	8b 72 08             	mov    0x8(%edx),%esi
80105f01:	89 70 08             	mov    %esi,0x8(%eax)
80105f04:	8b 72 0c             	mov    0xc(%edx),%esi
80105f07:	89 70 0c             	mov    %esi,0xc(%eax)
80105f0a:	8b 72 10             	mov    0x10(%edx),%esi
80105f0d:	89 70 10             	mov    %esi,0x10(%eax)
80105f10:	8b 72 14             	mov    0x14(%edx),%esi
80105f13:	89 70 14             	mov    %esi,0x14(%eax)
80105f16:	8b 72 18             	mov    0x18(%edx),%esi
80105f19:	89 70 18             	mov    %esi,0x18(%eax)
80105f1c:	8b 72 1c             	mov    0x1c(%edx),%esi
80105f1f:	89 70 1c             	mov    %esi,0x1c(%eax)
80105f22:	8b 72 20             	mov    0x20(%edx),%esi
80105f25:	89 70 20             	mov    %esi,0x20(%eax)
80105f28:	8b 52 24             	mov    0x24(%edx),%edx
80105f2b:	89 50 24             	mov    %edx,0x24(%eax)
            for (int j = index; j != msgq.tail; j = (j + 1) % MAX_MESSAGES) {
80105f2e:	39 cb                	cmp    %ecx,%ebx
80105f30:	75 9e                	jne    80105ed0 <sys_recv+0xb0>
            }
            msgq.tail = (msgq.tail - 1 + MAX_MESSAGES) % MAX_MESSAGES;
80105f32:	83 c1 3f             	add    $0x3f,%ecx
            msgq.count--;

            release(&msgq.lock);
80105f35:	83 ec 0c             	sub    $0xc,%esp
            msgq.count--;
80105f38:	83 2d bc 30 11 80 01 	subl   $0x1,0x801130bc
            msgq.tail = (msgq.tail - 1 + MAX_MESSAGES) % MAX_MESSAGES;
80105f3f:	83 e1 3f             	and    $0x3f,%ecx
80105f42:	89 0d b8 30 11 80    	mov    %ecx,0x801130b8
            release(&msgq.lock);
80105f48:	68 80 27 11 80       	push   $0x80112780
80105f4d:	e8 ae e7 ff ff       	call   80104700 <release>
            return 0;  // Success
80105f52:	83 c4 10             	add    $0x10,%esp
        }
    }

    release(&msgq.lock);
    return -1;  // No message of the specified type
}
80105f55:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 0;  // Success
80105f58:	31 c0                	xor    %eax,%eax
}
80105f5a:	5b                   	pop    %ebx
80105f5b:	5e                   	pop    %esi
80105f5c:	5d                   	pop    %ebp
80105f5d:	c3                   	ret
80105f5e:	66 90                	xchg   %ax,%ax
    release(&msgq.lock);
80105f60:	83 ec 0c             	sub    $0xc,%esp
80105f63:	68 80 27 11 80       	push   $0x80112780
80105f68:	e8 93 e7 ff ff       	call   80104700 <release>
    return -1;  // No message of the specified type
80105f6d:	83 c4 10             	add    $0x10,%esp
}
80105f70:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return -1;  // Invalid arguments
80105f73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f78:	5b                   	pop    %ebx
80105f79:	5e                   	pop    %esi
80105f7a:	5d                   	pop    %ebp
80105f7b:	c3                   	ret
80105f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f80 <sys_clear_console>:


int sys_clear_console(void) {
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	83 ec 08             	sub    $0x8,%esp
    consoleclear();  // Clear the console
80105f86:	e8 75 ab ff ff       	call   80100b00 <consoleclear>
    return 0;        // Return success
}
80105f8b:	31 c0                	xor    %eax,%eax
80105f8d:	c9                   	leave
80105f8e:	c3                   	ret
80105f8f:	90                   	nop

80105f90 <sys_ps>:


int sys_ps(void) {
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	83 ec 08             	sub    $0x8,%esp
  procdump();  // Call the procdump function
80105f96:	e8 45 e4 ff ff       	call   801043e0 <procdump>
  return 0;    // Success
80105f9b:	31 c0                	xor    %eax,%eax
80105f9d:	c9                   	leave
80105f9e:	c3                   	ret

80105f9f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f9f:	1e                   	push   %ds
  pushl %es
80105fa0:	06                   	push   %es
  pushl %fs
80105fa1:	0f a0                	push   %fs
  pushl %gs
80105fa3:	0f a8                	push   %gs
  pushal
80105fa5:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105fa6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105faa:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105fac:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105fae:	54                   	push   %esp
  call trap
80105faf:	e8 cc 00 00 00       	call   80106080 <trap>
  addl $4, %esp
80105fb4:	83 c4 04             	add    $0x4,%esp

80105fb7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105fb7:	61                   	popa
  popl %gs
80105fb8:	0f a9                	pop    %gs
  popl %fs
80105fba:	0f a1                	pop    %fs
  popl %es
80105fbc:	07                   	pop    %es
  popl %ds
80105fbd:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105fbe:	83 c4 08             	add    $0x8,%esp
  iret
80105fc1:	cf                   	iret
80105fc2:	66 90                	xchg   %ax,%ax
80105fc4:	66 90                	xchg   %ax,%ax
80105fc6:	66 90                	xchg   %ax,%ax
80105fc8:	66 90                	xchg   %ax,%ax
80105fca:	66 90                	xchg   %ax,%ax
80105fcc:	66 90                	xchg   %ax,%ax
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105fd0:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
80105fd1:	31 c0                	xor    %eax,%eax
{
80105fd3:	89 e5                	mov    %esp,%ebp
80105fd5:	83 ec 08             	sub    $0x8,%esp
80105fd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105fdf:	00 
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105fe0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105fe7:	c7 04 c5 02 77 11 80 	movl   $0x8e000008,-0x7fee88fe(,%eax,8)
80105fee:	08 00 00 8e 
80105ff2:	66 89 14 c5 00 77 11 	mov    %dx,-0x7fee8900(,%eax,8)
80105ff9:	80 
80105ffa:	c1 ea 10             	shr    $0x10,%edx
80105ffd:	66 89 14 c5 06 77 11 	mov    %dx,-0x7fee88fa(,%eax,8)
80106004:	80 
  for (i = 0; i < 256; i++)
80106005:	83 c0 01             	add    $0x1,%eax
80106008:	3d 00 01 00 00       	cmp    $0x100,%eax
8010600d:	75 d1                	jne    80105fe0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010600f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106012:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106017:	c7 05 02 79 11 80 08 	movl   $0xef000008,0x80117902
8010601e:	00 00 ef 
  initlock(&tickslock, "time");
80106021:	68 9d 7e 10 80       	push   $0x80107e9d
80106026:	68 c0 76 11 80       	push   $0x801176c0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010602b:	66 a3 00 79 11 80    	mov    %ax,0x80117900
80106031:	c1 e8 10             	shr    $0x10,%eax
80106034:	66 a3 06 79 11 80    	mov    %ax,0x80117906
  initlock(&tickslock, "time");
8010603a:	e8 31 e5 ff ff       	call   80104570 <initlock>
}
8010603f:	83 c4 10             	add    $0x10,%esp
80106042:	c9                   	leave
80106043:	c3                   	ret
80106044:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010604b:	00 
8010604c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106050 <idtinit>:

void
idtinit(void)
{
80106050:	55                   	push   %ebp
  pd[0] = size-1;
80106051:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106056:	89 e5                	mov    %esp,%ebp
80106058:	83 ec 10             	sub    $0x10,%esp
8010605b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010605f:	b8 00 77 11 80       	mov    $0x80117700,%eax
80106064:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106068:	c1 e8 10             	shr    $0x10,%eax
8010606b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010606f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106072:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106075:	c9                   	leave
80106076:	c3                   	ret
80106077:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010607e:	00 
8010607f:	90                   	nop

80106080 <trap>:

void
trap(struct trapframe *tf)
{
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
80106083:	57                   	push   %edi
80106084:	56                   	push   %esi
80106085:	53                   	push   %ebx
80106086:	83 ec 1c             	sub    $0x1c,%esp
80106089:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (tf->trapno == T_SYSCALL) {
8010608c:	8b 43 30             	mov    0x30(%ebx),%eax
8010608f:	83 f8 40             	cmp    $0x40,%eax
80106092:	0f 84 d0 01 00 00    	je     80106268 <trap+0x1e8>
    if (myproc() && myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno) {
80106098:	83 f8 3f             	cmp    $0x3f,%eax
8010609b:	0f 87 4f 01 00 00    	ja     801061f0 <trap+0x170>
801060a1:	ff 24 85 dc 84 10 80 	jmp    *-0x7fef7b24(,%eax,4)
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801060a8:	e8 53 c2 ff ff       	call   80102300 <ideintr>
    lapiceoi();
801060ad:	e8 0e c9 ff ff       	call   801029c0 <lapiceoi>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Deliver pending signals to the process if applicable.
  if (myproc() && myproc()->pending_signals) {
801060b2:	e8 f9 d9 ff ff       	call   80103ab0 <myproc>
801060b7:	85 c0                	test   %eax,%eax
801060b9:	0f 84 89 00 00 00    	je     80106148 <trap+0xc8>
801060bf:	e8 ec d9 ff ff       	call   80103ab0 <myproc>
801060c4:	8b b0 fc 00 00 00    	mov    0xfc(%eax),%esi
801060ca:	85 f6                	test   %esi,%esi
801060cc:	74 7a                	je     80106148 <trap+0xc8>
    for (int i = 0; i < NUMSIGNALS; i++) {
801060ce:	31 ff                	xor    %edi,%edi
801060d0:	eb 0e                	jmp    801060e0 <trap+0x60>
801060d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801060d8:	83 c7 01             	add    $0x1,%edi
801060db:	83 ff 20             	cmp    $0x20,%edi
801060de:	74 68                	je     80106148 <trap+0xc8>
      if (myproc()->pending_signals & (1 << i)) {
801060e0:	e8 cb d9 ff ff       	call   80103ab0 <myproc>
801060e5:	8b 80 fc 00 00 00    	mov    0xfc(%eax),%eax
801060eb:	0f a3 f8             	bt     %edi,%eax
801060ee:	73 e8                	jae    801060d8 <trap+0x58>
        myproc()->pending_signals &= ~(1 << i);  // Clear the signal bit
801060f0:	e8 bb d9 ff ff       	call   80103ab0 <myproc>
801060f5:	89 f9                	mov    %edi,%ecx

        if (myproc()->signal_handlers[i]) {
801060f7:	8d 77 1c             	lea    0x1c(%edi),%esi
        myproc()->pending_signals &= ~(1 << i);  // Clear the signal bit
801060fa:	89 c2                	mov    %eax,%edx
801060fc:	b8 01 00 00 00       	mov    $0x1,%eax
80106101:	d3 e0                	shl    %cl,%eax
80106103:	f7 d0                	not    %eax
80106105:	21 82 fc 00 00 00    	and    %eax,0xfc(%edx)
        if (myproc()->signal_handlers[i]) {
8010610b:	e8 a0 d9 ff ff       	call   80103ab0 <myproc>
80106110:	8b 4c b8 7c          	mov    0x7c(%eax,%edi,4),%ecx
80106114:	85 c9                	test   %ecx,%ecx
80106116:	0f 84 94 00 00 00    	je     801061b0 <trap+0x130>
          // Invoke the registered signal handler
          void (*handler)(void) = myproc()->signal_handlers[i];
8010611c:	e8 8f d9 ff ff       	call   80103ab0 <myproc>
    for (int i = 0; i < NUMSIGNALS; i++) {
80106121:	83 c7 01             	add    $0x1,%edi
          void (*handler)(void) = myproc()->signal_handlers[i];
80106124:	8b 54 b0 0c          	mov    0xc(%eax,%esi,4),%edx
80106128:	89 55 e4             	mov    %edx,-0x1c(%ebp)
          myproc()->signal_handlers[i] = 0;  // Reset to default
8010612b:	e8 80 d9 ff ff       	call   80103ab0 <myproc>
          handler();
80106130:	8b 55 e4             	mov    -0x1c(%ebp),%edx
          myproc()->signal_handlers[i] = 0;  // Reset to default
80106133:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
8010613a:	00 
          handler();
8010613b:	ff d2                	call   *%edx
    for (int i = 0; i < NUMSIGNALS; i++) {
8010613d:	83 ff 20             	cmp    $0x20,%edi
80106140:	75 9e                	jne    801060e0 <trap+0x60>
80106142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }
  }

  // Force process exit if it has been killed and is in user space.
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106148:	e8 63 d9 ff ff       	call   80103ab0 <myproc>
8010614d:	85 c0                	test   %eax,%eax
8010614f:	74 1a                	je     8010616b <trap+0xeb>
80106151:	e8 5a d9 ff ff       	call   80103ab0 <myproc>
80106156:	8b 50 24             	mov    0x24(%eax),%edx
80106159:	85 d2                	test   %edx,%edx
8010615b:	74 0e                	je     8010616b <trap+0xeb>
8010615d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106161:	f7 d0                	not    %eax
80106163:	a8 03                	test   $0x3,%al
80106165:	0f 84 7e 02 00 00    	je     801063e9 <trap+0x369>
    exit();

  // Force process to give up CPU on clock tick.
  if (myproc() && myproc()->state == RUNNING &&
8010616b:	e8 40 d9 ff ff       	call   80103ab0 <myproc>
80106170:	85 c0                	test   %eax,%eax
80106172:	74 0f                	je     80106183 <trap+0x103>
80106174:	e8 37 d9 ff ff       	call   80103ab0 <myproc>
80106179:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010617d:	0f 84 25 02 00 00    	je     801063a8 <trap+0x328>
      tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106183:	e8 28 d9 ff ff       	call   80103ab0 <myproc>
80106188:	85 c0                	test   %eax,%eax
8010618a:	74 1a                	je     801061a6 <trap+0x126>
8010618c:	e8 1f d9 ff ff       	call   80103ab0 <myproc>
80106191:	8b 40 24             	mov    0x24(%eax),%eax
80106194:	85 c0                	test   %eax,%eax
80106196:	74 0e                	je     801061a6 <trap+0x126>
80106198:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010619c:	f7 d0                	not    %eax
8010619e:	a8 03                	test   $0x3,%al
801061a0:	0f 84 05 01 00 00    	je     801062ab <trap+0x22b>
    exit();
}
801061a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061a9:	5b                   	pop    %ebx
801061aa:	5e                   	pop    %esi
801061ab:	5f                   	pop    %edi
801061ac:	5d                   	pop    %ebp
801061ad:	c3                   	ret
801061ae:	66 90                	xchg   %ax,%ax
        } else if (i == 2) {  // Default behavior for SIGINT
801061b0:	83 ff 02             	cmp    $0x2,%edi
801061b3:	0f 84 07 02 00 00    	je     801063c0 <trap+0x340>
        } else if (i == 8) {  // Default behavior for SIGFPE
801061b9:	83 ff 08             	cmp    $0x8,%edi
801061bc:	0f 85 16 ff ff ff    	jne    801060d8 <trap+0x58>
          cprintf("SIGFPE received: terminating process %d\n", myproc()->pid);
801061c2:	e8 e9 d8 ff ff       	call   80103ab0 <myproc>
801061c7:	83 ec 08             	sub    $0x8,%esp
801061ca:	ff 70 10             	push   0x10(%eax)
801061cd:	68 b4 81 10 80       	push   $0x801081b4
801061d2:	e8 d9 a4 ff ff       	call   801006b0 <cprintf>
          myproc()->killed = 1;  // Mark the process as killed
801061d7:	e8 d4 d8 ff ff       	call   80103ab0 <myproc>
801061dc:	83 c4 10             	add    $0x10,%esp
801061df:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    for (int i = 0; i < NUMSIGNALS; i++) {
801061e6:	83 c7 01             	add    $0x1,%edi
801061e9:	e9 f2 fe ff ff       	jmp    801060e0 <trap+0x60>
801061ee:	66 90                	xchg   %ax,%ax
    if (myproc() == 0 || (tf->cs & 3) == 0) {
801061f0:	e8 bb d8 ff ff       	call   80103ab0 <myproc>
801061f5:	8b 7b 38             	mov    0x38(%ebx),%edi
801061f8:	85 c0                	test   %eax,%eax
801061fa:	0f 84 fd 01 00 00    	je     801063fd <trap+0x37d>
80106200:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106204:	0f 84 f3 01 00 00    	je     801063fd <trap+0x37d>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010620a:	0f 20 d1             	mov    %cr2,%ecx
8010620d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106210:	e8 7b d8 ff ff       	call   80103a90 <cpuid>
80106215:	8b 73 30             	mov    0x30(%ebx),%esi
80106218:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010621b:	8b 43 34             	mov    0x34(%ebx),%eax
8010621e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106221:	e8 8a d8 ff ff       	call   80103ab0 <myproc>
80106226:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106229:	e8 82 d8 ff ff       	call   80103ab0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010622e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106231:	51                   	push   %ecx
80106232:	57                   	push   %edi
80106233:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106236:	52                   	push   %edx
80106237:	ff 75 e4             	push   -0x1c(%ebp)
8010623a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010623b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010623e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106241:	56                   	push   %esi
80106242:	ff 70 10             	push   0x10(%eax)
80106245:	68 3c 81 10 80       	push   $0x8010813c
8010624a:	e8 61 a4 ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
8010624f:	83 c4 20             	add    $0x20,%esp
80106252:	e8 59 d8 ff ff       	call   80103ab0 <myproc>
80106257:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010625e:	e9 4f fe ff ff       	jmp    801060b2 <trap+0x32>
80106263:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (myproc() && myproc()->killed)
80106268:	e8 43 d8 ff ff       	call   80103ab0 <myproc>
8010626d:	85 c0                	test   %eax,%eax
8010626f:	74 10                	je     80106281 <trap+0x201>
80106271:	e8 3a d8 ff ff       	call   80103ab0 <myproc>
80106276:	8b 40 24             	mov    0x24(%eax),%eax
80106279:	85 c0                	test   %eax,%eax
8010627b:	0f 85 72 01 00 00    	jne    801063f3 <trap+0x373>
    myproc()->tf = tf;
80106281:	e8 2a d8 ff ff       	call   80103ab0 <myproc>
80106286:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106289:	e8 c2 e9 ff ff       	call   80104c50 <syscall>
    if (myproc() && myproc()->killed)
8010628e:	e8 1d d8 ff ff       	call   80103ab0 <myproc>
80106293:	85 c0                	test   %eax,%eax
80106295:	0f 84 0b ff ff ff    	je     801061a6 <trap+0x126>
8010629b:	e8 10 d8 ff ff       	call   80103ab0 <myproc>
801062a0:	8b 78 24             	mov    0x24(%eax),%edi
801062a3:	85 ff                	test   %edi,%edi
801062a5:	0f 84 fb fe ff ff    	je     801061a6 <trap+0x126>
}
801062ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062ae:	5b                   	pop    %ebx
801062af:	5e                   	pop    %esi
801062b0:	5f                   	pop    %edi
801062b1:	5d                   	pop    %ebp
      exit();
801062b2:	e9 b9 dc ff ff       	jmp    80103f70 <exit>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062b7:	8b 7b 38             	mov    0x38(%ebx),%edi
801062ba:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801062be:	e8 cd d7 ff ff       	call   80103a90 <cpuid>
801062c3:	57                   	push   %edi
801062c4:	56                   	push   %esi
801062c5:	50                   	push   %eax
801062c6:	68 e4 80 10 80       	push   $0x801080e4
801062cb:	e8 e0 a3 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801062d0:	e8 eb c6 ff ff       	call   801029c0 <lapiceoi>
    break;
801062d5:	83 c4 10             	add    $0x10,%esp
801062d8:	e9 d5 fd ff ff       	jmp    801060b2 <trap+0x32>
    uartintr();
801062dd:	e8 ce 02 00 00       	call   801065b0 <uartintr>
    lapiceoi();
801062e2:	e8 d9 c6 ff ff       	call   801029c0 <lapiceoi>
    break;
801062e7:	e9 c6 fd ff ff       	jmp    801060b2 <trap+0x32>
    kbdintr();
801062ec:	e8 9f c5 ff ff       	call   80102890 <kbdintr>
    if (myproc()) {
801062f1:	e8 ba d7 ff ff       	call   80103ab0 <myproc>
801062f6:	85 c0                	test   %eax,%eax
801062f8:	0f 84 af fd ff ff    	je     801060ad <trap+0x2d>
      myproc()->pending_signals |= (1 << 2);  // Raise SIGINT (signal number 2)
801062fe:	e8 ad d7 ff ff       	call   80103ab0 <myproc>
80106303:	83 88 fc 00 00 00 04 	orl    $0x4,0xfc(%eax)
      cprintf("SIGINT triggered by Shift+C for process %d\n", myproc()->pid);
8010630a:	e8 a1 d7 ff ff       	call   80103ab0 <myproc>
8010630f:	83 ec 08             	sub    $0x8,%esp
80106312:	ff 70 10             	push   0x10(%eax)
80106315:	68 94 80 10 80       	push   $0x80108094
8010631a:	e8 91 a3 ff ff       	call   801006b0 <cprintf>
8010631f:	83 c4 10             	add    $0x10,%esp
80106322:	e9 86 fd ff ff       	jmp    801060ad <trap+0x2d>
    if (cpuid() == 0) {
80106327:	e8 64 d7 ff ff       	call   80103a90 <cpuid>
8010632c:	85 c0                	test   %eax,%eax
8010632e:	0f 85 79 fd ff ff    	jne    801060ad <trap+0x2d>
      acquire(&tickslock);
80106334:	83 ec 0c             	sub    $0xc,%esp
80106337:	68 c0 76 11 80       	push   $0x801176c0
8010633c:	e8 1f e4 ff ff       	call   80104760 <acquire>
      ticks++;
80106341:	83 05 a0 76 11 80 01 	addl   $0x1,0x801176a0
      wakeup(&ticks);
80106348:	c7 04 24 a0 76 11 80 	movl   $0x801176a0,(%esp)
8010634f:	e8 ac df ff ff       	call   80104300 <wakeup>
      release(&tickslock);
80106354:	c7 04 24 c0 76 11 80 	movl   $0x801176c0,(%esp)
8010635b:	e8 a0 e3 ff ff       	call   80104700 <release>
80106360:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106363:	e9 45 fd ff ff       	jmp    801060ad <trap+0x2d>
    if (myproc()) {
80106368:	e8 43 d7 ff ff       	call   80103ab0 <myproc>
8010636d:	85 c0                	test   %eax,%eax
8010636f:	0f 84 3d fd ff ff    	je     801060b2 <trap+0x32>
      myproc()->pending_signals |= (1 << 8);  // Raise SIGFPE (signal number 8)
80106375:	e8 36 d7 ff ff       	call   80103ab0 <myproc>
8010637a:	81 88 fc 00 00 00 00 	orl    $0x100,0xfc(%eax)
80106381:	01 00 00 
      cprintf("SIGFPE triggered for process %d\n", myproc()->pid);
80106384:	e8 27 d7 ff ff       	call   80103ab0 <myproc>
80106389:	83 ec 08             	sub    $0x8,%esp
8010638c:	ff 70 10             	push   0x10(%eax)
8010638f:	68 c0 80 10 80       	push   $0x801080c0
80106394:	e8 17 a3 ff ff       	call   801006b0 <cprintf>
80106399:	83 c4 10             	add    $0x10,%esp
8010639c:	e9 11 fd ff ff       	jmp    801060b2 <trap+0x32>
801063a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if (myproc() && myproc()->state == RUNNING &&
801063a8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801063ac:	0f 85 d1 fd ff ff    	jne    80106183 <trap+0x103>
    yield();
801063b2:	e8 39 de ff ff       	call   801041f0 <yield>
801063b7:	e9 c7 fd ff ff       	jmp    80106183 <trap+0x103>
801063bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          cprintf("SIGINT received (Shift+C): terminating process %d\n", myproc()->pid);
801063c0:	e8 eb d6 ff ff       	call   80103ab0 <myproc>
801063c5:	83 ec 08             	sub    $0x8,%esp
801063c8:	ff 70 10             	push   0x10(%eax)
801063cb:	68 80 81 10 80       	push   $0x80108180
801063d0:	e8 db a2 ff ff       	call   801006b0 <cprintf>
          myproc()->killed = 1;  // Mark the process as killed
801063d5:	e8 d6 d6 ff ff       	call   80103ab0 <myproc>
801063da:	83 c4 10             	add    $0x10,%esp
801063dd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801063e4:	e9 fd fd ff ff       	jmp    801061e6 <trap+0x166>
    exit();
801063e9:	e8 82 db ff ff       	call   80103f70 <exit>
801063ee:	e9 78 fd ff ff       	jmp    8010616b <trap+0xeb>
      exit();
801063f3:	e8 78 db ff ff       	call   80103f70 <exit>
801063f8:	e9 84 fe ff ff       	jmp    80106281 <trap+0x201>
801063fd:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106400:	e8 8b d6 ff ff       	call   80103a90 <cpuid>
80106405:	83 ec 0c             	sub    $0xc,%esp
80106408:	56                   	push   %esi
80106409:	57                   	push   %edi
8010640a:	50                   	push   %eax
8010640b:	ff 73 30             	push   0x30(%ebx)
8010640e:	68 08 81 10 80       	push   $0x80108108
80106413:	e8 98 a2 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106418:	83 c4 14             	add    $0x14,%esp
8010641b:	68 a2 7e 10 80       	push   $0x80107ea2
80106420:	e8 5b 9f ff ff       	call   80100380 <panic>
80106425:	66 90                	xchg   %ax,%ax
80106427:	66 90                	xchg   %ax,%ax
80106429:	66 90                	xchg   %ax,%ax
8010642b:	66 90                	xchg   %ax,%ax
8010642d:	66 90                	xchg   %ax,%ax
8010642f:	90                   	nop

80106430 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106430:	a1 00 7f 11 80       	mov    0x80117f00,%eax
80106435:	85 c0                	test   %eax,%eax
80106437:	74 17                	je     80106450 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106439:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010643e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010643f:	a8 01                	test   $0x1,%al
80106441:	74 0d                	je     80106450 <uartgetc+0x20>
80106443:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106448:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106449:	0f b6 c0             	movzbl %al,%eax
8010644c:	c3                   	ret
8010644d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106455:	c3                   	ret
80106456:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010645d:	00 
8010645e:	66 90                	xchg   %ax,%ax

80106460 <uartinit>:
{
80106460:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106461:	31 c9                	xor    %ecx,%ecx
80106463:	89 c8                	mov    %ecx,%eax
80106465:	89 e5                	mov    %esp,%ebp
80106467:	57                   	push   %edi
80106468:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010646d:	56                   	push   %esi
8010646e:	89 fa                	mov    %edi,%edx
80106470:	53                   	push   %ebx
80106471:	83 ec 1c             	sub    $0x1c,%esp
80106474:	ee                   	out    %al,(%dx)
80106475:	be fb 03 00 00       	mov    $0x3fb,%esi
8010647a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010647f:	89 f2                	mov    %esi,%edx
80106481:	ee                   	out    %al,(%dx)
80106482:	b8 0c 00 00 00       	mov    $0xc,%eax
80106487:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010648c:	ee                   	out    %al,(%dx)
8010648d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106492:	89 c8                	mov    %ecx,%eax
80106494:	89 da                	mov    %ebx,%edx
80106496:	ee                   	out    %al,(%dx)
80106497:	b8 03 00 00 00       	mov    $0x3,%eax
8010649c:	89 f2                	mov    %esi,%edx
8010649e:	ee                   	out    %al,(%dx)
8010649f:	ba fc 03 00 00       	mov    $0x3fc,%edx
801064a4:	89 c8                	mov    %ecx,%eax
801064a6:	ee                   	out    %al,(%dx)
801064a7:	b8 01 00 00 00       	mov    $0x1,%eax
801064ac:	89 da                	mov    %ebx,%edx
801064ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064af:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064b4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801064b5:	3c ff                	cmp    $0xff,%al
801064b7:	0f 84 7c 00 00 00    	je     80106539 <uartinit+0xd9>
  uart = 1;
801064bd:	c7 05 00 7f 11 80 01 	movl   $0x1,0x80117f00
801064c4:	00 00 00 
801064c7:	89 fa                	mov    %edi,%edx
801064c9:	ec                   	in     (%dx),%al
801064ca:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064cf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801064d0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801064d3:	bf a7 7e 10 80       	mov    $0x80107ea7,%edi
801064d8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801064dd:	6a 00                	push   $0x0
801064df:	6a 04                	push   $0x4
801064e1:	e8 4a c0 ff ff       	call   80102530 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801064e6:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801064ea:	83 c4 10             	add    $0x10,%esp
801064ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
801064f0:	a1 00 7f 11 80       	mov    0x80117f00,%eax
801064f5:	85 c0                	test   %eax,%eax
801064f7:	74 32                	je     8010652b <uartinit+0xcb>
801064f9:	89 f2                	mov    %esi,%edx
801064fb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064fc:	a8 20                	test   $0x20,%al
801064fe:	75 21                	jne    80106521 <uartinit+0xc1>
80106500:	bb 80 00 00 00       	mov    $0x80,%ebx
80106505:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106508:	83 ec 0c             	sub    $0xc,%esp
8010650b:	6a 0a                	push   $0xa
8010650d:	e8 ce c4 ff ff       	call   801029e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106512:	83 c4 10             	add    $0x10,%esp
80106515:	83 eb 01             	sub    $0x1,%ebx
80106518:	74 07                	je     80106521 <uartinit+0xc1>
8010651a:	89 f2                	mov    %esi,%edx
8010651c:	ec                   	in     (%dx),%al
8010651d:	a8 20                	test   $0x20,%al
8010651f:	74 e7                	je     80106508 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106521:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106526:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010652a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010652b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010652f:	83 c7 01             	add    $0x1,%edi
80106532:	88 45 e7             	mov    %al,-0x19(%ebp)
80106535:	84 c0                	test   %al,%al
80106537:	75 b7                	jne    801064f0 <uartinit+0x90>
}
80106539:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010653c:	5b                   	pop    %ebx
8010653d:	5e                   	pop    %esi
8010653e:	5f                   	pop    %edi
8010653f:	5d                   	pop    %ebp
80106540:	c3                   	ret
80106541:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106548:	00 
80106549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106550 <uartputc>:
  if(!uart)
80106550:	a1 00 7f 11 80       	mov    0x80117f00,%eax
80106555:	85 c0                	test   %eax,%eax
80106557:	74 4f                	je     801065a8 <uartputc+0x58>
{
80106559:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010655a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010655f:	89 e5                	mov    %esp,%ebp
80106561:	56                   	push   %esi
80106562:	53                   	push   %ebx
80106563:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106564:	a8 20                	test   $0x20,%al
80106566:	75 29                	jne    80106591 <uartputc+0x41>
80106568:	bb 80 00 00 00       	mov    $0x80,%ebx
8010656d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106578:	83 ec 0c             	sub    $0xc,%esp
8010657b:	6a 0a                	push   $0xa
8010657d:	e8 5e c4 ff ff       	call   801029e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106582:	83 c4 10             	add    $0x10,%esp
80106585:	83 eb 01             	sub    $0x1,%ebx
80106588:	74 07                	je     80106591 <uartputc+0x41>
8010658a:	89 f2                	mov    %esi,%edx
8010658c:	ec                   	in     (%dx),%al
8010658d:	a8 20                	test   $0x20,%al
8010658f:	74 e7                	je     80106578 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106591:	8b 45 08             	mov    0x8(%ebp),%eax
80106594:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106599:	ee                   	out    %al,(%dx)
}
8010659a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010659d:	5b                   	pop    %ebx
8010659e:	5e                   	pop    %esi
8010659f:	5d                   	pop    %ebp
801065a0:	c3                   	ret
801065a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065a8:	c3                   	ret
801065a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065b0 <uartintr>:

void
uartintr(void)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065b6:	68 30 64 10 80       	push   $0x80106430
801065bb:	e8 e0 a2 ff ff       	call   801008a0 <consoleintr>
}
801065c0:	83 c4 10             	add    $0x10,%esp
801065c3:	c9                   	leave
801065c4:	c3                   	ret

801065c5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065c5:	6a 00                	push   $0x0
  pushl $0
801065c7:	6a 00                	push   $0x0
  jmp alltraps
801065c9:	e9 d1 f9 ff ff       	jmp    80105f9f <alltraps>

801065ce <vector1>:
.globl vector1
vector1:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $1
801065d0:	6a 01                	push   $0x1
  jmp alltraps
801065d2:	e9 c8 f9 ff ff       	jmp    80105f9f <alltraps>

801065d7 <vector2>:
.globl vector2
vector2:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $2
801065d9:	6a 02                	push   $0x2
  jmp alltraps
801065db:	e9 bf f9 ff ff       	jmp    80105f9f <alltraps>

801065e0 <vector3>:
.globl vector3
vector3:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $3
801065e2:	6a 03                	push   $0x3
  jmp alltraps
801065e4:	e9 b6 f9 ff ff       	jmp    80105f9f <alltraps>

801065e9 <vector4>:
.globl vector4
vector4:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $4
801065eb:	6a 04                	push   $0x4
  jmp alltraps
801065ed:	e9 ad f9 ff ff       	jmp    80105f9f <alltraps>

801065f2 <vector5>:
.globl vector5
vector5:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $5
801065f4:	6a 05                	push   $0x5
  jmp alltraps
801065f6:	e9 a4 f9 ff ff       	jmp    80105f9f <alltraps>

801065fb <vector6>:
.globl vector6
vector6:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $6
801065fd:	6a 06                	push   $0x6
  jmp alltraps
801065ff:	e9 9b f9 ff ff       	jmp    80105f9f <alltraps>

80106604 <vector7>:
.globl vector7
vector7:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $7
80106606:	6a 07                	push   $0x7
  jmp alltraps
80106608:	e9 92 f9 ff ff       	jmp    80105f9f <alltraps>

8010660d <vector8>:
.globl vector8
vector8:
  pushl $8
8010660d:	6a 08                	push   $0x8
  jmp alltraps
8010660f:	e9 8b f9 ff ff       	jmp    80105f9f <alltraps>

80106614 <vector9>:
.globl vector9
vector9:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $9
80106616:	6a 09                	push   $0x9
  jmp alltraps
80106618:	e9 82 f9 ff ff       	jmp    80105f9f <alltraps>

8010661d <vector10>:
.globl vector10
vector10:
  pushl $10
8010661d:	6a 0a                	push   $0xa
  jmp alltraps
8010661f:	e9 7b f9 ff ff       	jmp    80105f9f <alltraps>

80106624 <vector11>:
.globl vector11
vector11:
  pushl $11
80106624:	6a 0b                	push   $0xb
  jmp alltraps
80106626:	e9 74 f9 ff ff       	jmp    80105f9f <alltraps>

8010662b <vector12>:
.globl vector12
vector12:
  pushl $12
8010662b:	6a 0c                	push   $0xc
  jmp alltraps
8010662d:	e9 6d f9 ff ff       	jmp    80105f9f <alltraps>

80106632 <vector13>:
.globl vector13
vector13:
  pushl $13
80106632:	6a 0d                	push   $0xd
  jmp alltraps
80106634:	e9 66 f9 ff ff       	jmp    80105f9f <alltraps>

80106639 <vector14>:
.globl vector14
vector14:
  pushl $14
80106639:	6a 0e                	push   $0xe
  jmp alltraps
8010663b:	e9 5f f9 ff ff       	jmp    80105f9f <alltraps>

80106640 <vector15>:
.globl vector15
vector15:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $15
80106642:	6a 0f                	push   $0xf
  jmp alltraps
80106644:	e9 56 f9 ff ff       	jmp    80105f9f <alltraps>

80106649 <vector16>:
.globl vector16
vector16:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $16
8010664b:	6a 10                	push   $0x10
  jmp alltraps
8010664d:	e9 4d f9 ff ff       	jmp    80105f9f <alltraps>

80106652 <vector17>:
.globl vector17
vector17:
  pushl $17
80106652:	6a 11                	push   $0x11
  jmp alltraps
80106654:	e9 46 f9 ff ff       	jmp    80105f9f <alltraps>

80106659 <vector18>:
.globl vector18
vector18:
  pushl $0
80106659:	6a 00                	push   $0x0
  pushl $18
8010665b:	6a 12                	push   $0x12
  jmp alltraps
8010665d:	e9 3d f9 ff ff       	jmp    80105f9f <alltraps>

80106662 <vector19>:
.globl vector19
vector19:
  pushl $0
80106662:	6a 00                	push   $0x0
  pushl $19
80106664:	6a 13                	push   $0x13
  jmp alltraps
80106666:	e9 34 f9 ff ff       	jmp    80105f9f <alltraps>

8010666b <vector20>:
.globl vector20
vector20:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $20
8010666d:	6a 14                	push   $0x14
  jmp alltraps
8010666f:	e9 2b f9 ff ff       	jmp    80105f9f <alltraps>

80106674 <vector21>:
.globl vector21
vector21:
  pushl $0
80106674:	6a 00                	push   $0x0
  pushl $21
80106676:	6a 15                	push   $0x15
  jmp alltraps
80106678:	e9 22 f9 ff ff       	jmp    80105f9f <alltraps>

8010667d <vector22>:
.globl vector22
vector22:
  pushl $0
8010667d:	6a 00                	push   $0x0
  pushl $22
8010667f:	6a 16                	push   $0x16
  jmp alltraps
80106681:	e9 19 f9 ff ff       	jmp    80105f9f <alltraps>

80106686 <vector23>:
.globl vector23
vector23:
  pushl $0
80106686:	6a 00                	push   $0x0
  pushl $23
80106688:	6a 17                	push   $0x17
  jmp alltraps
8010668a:	e9 10 f9 ff ff       	jmp    80105f9f <alltraps>

8010668f <vector24>:
.globl vector24
vector24:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $24
80106691:	6a 18                	push   $0x18
  jmp alltraps
80106693:	e9 07 f9 ff ff       	jmp    80105f9f <alltraps>

80106698 <vector25>:
.globl vector25
vector25:
  pushl $0
80106698:	6a 00                	push   $0x0
  pushl $25
8010669a:	6a 19                	push   $0x19
  jmp alltraps
8010669c:	e9 fe f8 ff ff       	jmp    80105f9f <alltraps>

801066a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801066a1:	6a 00                	push   $0x0
  pushl $26
801066a3:	6a 1a                	push   $0x1a
  jmp alltraps
801066a5:	e9 f5 f8 ff ff       	jmp    80105f9f <alltraps>

801066aa <vector27>:
.globl vector27
vector27:
  pushl $0
801066aa:	6a 00                	push   $0x0
  pushl $27
801066ac:	6a 1b                	push   $0x1b
  jmp alltraps
801066ae:	e9 ec f8 ff ff       	jmp    80105f9f <alltraps>

801066b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $28
801066b5:	6a 1c                	push   $0x1c
  jmp alltraps
801066b7:	e9 e3 f8 ff ff       	jmp    80105f9f <alltraps>

801066bc <vector29>:
.globl vector29
vector29:
  pushl $0
801066bc:	6a 00                	push   $0x0
  pushl $29
801066be:	6a 1d                	push   $0x1d
  jmp alltraps
801066c0:	e9 da f8 ff ff       	jmp    80105f9f <alltraps>

801066c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801066c5:	6a 00                	push   $0x0
  pushl $30
801066c7:	6a 1e                	push   $0x1e
  jmp alltraps
801066c9:	e9 d1 f8 ff ff       	jmp    80105f9f <alltraps>

801066ce <vector31>:
.globl vector31
vector31:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $31
801066d0:	6a 1f                	push   $0x1f
  jmp alltraps
801066d2:	e9 c8 f8 ff ff       	jmp    80105f9f <alltraps>

801066d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $32
801066d9:	6a 20                	push   $0x20
  jmp alltraps
801066db:	e9 bf f8 ff ff       	jmp    80105f9f <alltraps>

801066e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801066e0:	6a 00                	push   $0x0
  pushl $33
801066e2:	6a 21                	push   $0x21
  jmp alltraps
801066e4:	e9 b6 f8 ff ff       	jmp    80105f9f <alltraps>

801066e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801066e9:	6a 00                	push   $0x0
  pushl $34
801066eb:	6a 22                	push   $0x22
  jmp alltraps
801066ed:	e9 ad f8 ff ff       	jmp    80105f9f <alltraps>

801066f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801066f2:	6a 00                	push   $0x0
  pushl $35
801066f4:	6a 23                	push   $0x23
  jmp alltraps
801066f6:	e9 a4 f8 ff ff       	jmp    80105f9f <alltraps>

801066fb <vector36>:
.globl vector36
vector36:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $36
801066fd:	6a 24                	push   $0x24
  jmp alltraps
801066ff:	e9 9b f8 ff ff       	jmp    80105f9f <alltraps>

80106704 <vector37>:
.globl vector37
vector37:
  pushl $0
80106704:	6a 00                	push   $0x0
  pushl $37
80106706:	6a 25                	push   $0x25
  jmp alltraps
80106708:	e9 92 f8 ff ff       	jmp    80105f9f <alltraps>

8010670d <vector38>:
.globl vector38
vector38:
  pushl $0
8010670d:	6a 00                	push   $0x0
  pushl $38
8010670f:	6a 26                	push   $0x26
  jmp alltraps
80106711:	e9 89 f8 ff ff       	jmp    80105f9f <alltraps>

80106716 <vector39>:
.globl vector39
vector39:
  pushl $0
80106716:	6a 00                	push   $0x0
  pushl $39
80106718:	6a 27                	push   $0x27
  jmp alltraps
8010671a:	e9 80 f8 ff ff       	jmp    80105f9f <alltraps>

8010671f <vector40>:
.globl vector40
vector40:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $40
80106721:	6a 28                	push   $0x28
  jmp alltraps
80106723:	e9 77 f8 ff ff       	jmp    80105f9f <alltraps>

80106728 <vector41>:
.globl vector41
vector41:
  pushl $0
80106728:	6a 00                	push   $0x0
  pushl $41
8010672a:	6a 29                	push   $0x29
  jmp alltraps
8010672c:	e9 6e f8 ff ff       	jmp    80105f9f <alltraps>

80106731 <vector42>:
.globl vector42
vector42:
  pushl $0
80106731:	6a 00                	push   $0x0
  pushl $42
80106733:	6a 2a                	push   $0x2a
  jmp alltraps
80106735:	e9 65 f8 ff ff       	jmp    80105f9f <alltraps>

8010673a <vector43>:
.globl vector43
vector43:
  pushl $0
8010673a:	6a 00                	push   $0x0
  pushl $43
8010673c:	6a 2b                	push   $0x2b
  jmp alltraps
8010673e:	e9 5c f8 ff ff       	jmp    80105f9f <alltraps>

80106743 <vector44>:
.globl vector44
vector44:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $44
80106745:	6a 2c                	push   $0x2c
  jmp alltraps
80106747:	e9 53 f8 ff ff       	jmp    80105f9f <alltraps>

8010674c <vector45>:
.globl vector45
vector45:
  pushl $0
8010674c:	6a 00                	push   $0x0
  pushl $45
8010674e:	6a 2d                	push   $0x2d
  jmp alltraps
80106750:	e9 4a f8 ff ff       	jmp    80105f9f <alltraps>

80106755 <vector46>:
.globl vector46
vector46:
  pushl $0
80106755:	6a 00                	push   $0x0
  pushl $46
80106757:	6a 2e                	push   $0x2e
  jmp alltraps
80106759:	e9 41 f8 ff ff       	jmp    80105f9f <alltraps>

8010675e <vector47>:
.globl vector47
vector47:
  pushl $0
8010675e:	6a 00                	push   $0x0
  pushl $47
80106760:	6a 2f                	push   $0x2f
  jmp alltraps
80106762:	e9 38 f8 ff ff       	jmp    80105f9f <alltraps>

80106767 <vector48>:
.globl vector48
vector48:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $48
80106769:	6a 30                	push   $0x30
  jmp alltraps
8010676b:	e9 2f f8 ff ff       	jmp    80105f9f <alltraps>

80106770 <vector49>:
.globl vector49
vector49:
  pushl $0
80106770:	6a 00                	push   $0x0
  pushl $49
80106772:	6a 31                	push   $0x31
  jmp alltraps
80106774:	e9 26 f8 ff ff       	jmp    80105f9f <alltraps>

80106779 <vector50>:
.globl vector50
vector50:
  pushl $0
80106779:	6a 00                	push   $0x0
  pushl $50
8010677b:	6a 32                	push   $0x32
  jmp alltraps
8010677d:	e9 1d f8 ff ff       	jmp    80105f9f <alltraps>

80106782 <vector51>:
.globl vector51
vector51:
  pushl $0
80106782:	6a 00                	push   $0x0
  pushl $51
80106784:	6a 33                	push   $0x33
  jmp alltraps
80106786:	e9 14 f8 ff ff       	jmp    80105f9f <alltraps>

8010678b <vector52>:
.globl vector52
vector52:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $52
8010678d:	6a 34                	push   $0x34
  jmp alltraps
8010678f:	e9 0b f8 ff ff       	jmp    80105f9f <alltraps>

80106794 <vector53>:
.globl vector53
vector53:
  pushl $0
80106794:	6a 00                	push   $0x0
  pushl $53
80106796:	6a 35                	push   $0x35
  jmp alltraps
80106798:	e9 02 f8 ff ff       	jmp    80105f9f <alltraps>

8010679d <vector54>:
.globl vector54
vector54:
  pushl $0
8010679d:	6a 00                	push   $0x0
  pushl $54
8010679f:	6a 36                	push   $0x36
  jmp alltraps
801067a1:	e9 f9 f7 ff ff       	jmp    80105f9f <alltraps>

801067a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801067a6:	6a 00                	push   $0x0
  pushl $55
801067a8:	6a 37                	push   $0x37
  jmp alltraps
801067aa:	e9 f0 f7 ff ff       	jmp    80105f9f <alltraps>

801067af <vector56>:
.globl vector56
vector56:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $56
801067b1:	6a 38                	push   $0x38
  jmp alltraps
801067b3:	e9 e7 f7 ff ff       	jmp    80105f9f <alltraps>

801067b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801067b8:	6a 00                	push   $0x0
  pushl $57
801067ba:	6a 39                	push   $0x39
  jmp alltraps
801067bc:	e9 de f7 ff ff       	jmp    80105f9f <alltraps>

801067c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801067c1:	6a 00                	push   $0x0
  pushl $58
801067c3:	6a 3a                	push   $0x3a
  jmp alltraps
801067c5:	e9 d5 f7 ff ff       	jmp    80105f9f <alltraps>

801067ca <vector59>:
.globl vector59
vector59:
  pushl $0
801067ca:	6a 00                	push   $0x0
  pushl $59
801067cc:	6a 3b                	push   $0x3b
  jmp alltraps
801067ce:	e9 cc f7 ff ff       	jmp    80105f9f <alltraps>

801067d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $60
801067d5:	6a 3c                	push   $0x3c
  jmp alltraps
801067d7:	e9 c3 f7 ff ff       	jmp    80105f9f <alltraps>

801067dc <vector61>:
.globl vector61
vector61:
  pushl $0
801067dc:	6a 00                	push   $0x0
  pushl $61
801067de:	6a 3d                	push   $0x3d
  jmp alltraps
801067e0:	e9 ba f7 ff ff       	jmp    80105f9f <alltraps>

801067e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801067e5:	6a 00                	push   $0x0
  pushl $62
801067e7:	6a 3e                	push   $0x3e
  jmp alltraps
801067e9:	e9 b1 f7 ff ff       	jmp    80105f9f <alltraps>

801067ee <vector63>:
.globl vector63
vector63:
  pushl $0
801067ee:	6a 00                	push   $0x0
  pushl $63
801067f0:	6a 3f                	push   $0x3f
  jmp alltraps
801067f2:	e9 a8 f7 ff ff       	jmp    80105f9f <alltraps>

801067f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $64
801067f9:	6a 40                	push   $0x40
  jmp alltraps
801067fb:	e9 9f f7 ff ff       	jmp    80105f9f <alltraps>

80106800 <vector65>:
.globl vector65
vector65:
  pushl $0
80106800:	6a 00                	push   $0x0
  pushl $65
80106802:	6a 41                	push   $0x41
  jmp alltraps
80106804:	e9 96 f7 ff ff       	jmp    80105f9f <alltraps>

80106809 <vector66>:
.globl vector66
vector66:
  pushl $0
80106809:	6a 00                	push   $0x0
  pushl $66
8010680b:	6a 42                	push   $0x42
  jmp alltraps
8010680d:	e9 8d f7 ff ff       	jmp    80105f9f <alltraps>

80106812 <vector67>:
.globl vector67
vector67:
  pushl $0
80106812:	6a 00                	push   $0x0
  pushl $67
80106814:	6a 43                	push   $0x43
  jmp alltraps
80106816:	e9 84 f7 ff ff       	jmp    80105f9f <alltraps>

8010681b <vector68>:
.globl vector68
vector68:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $68
8010681d:	6a 44                	push   $0x44
  jmp alltraps
8010681f:	e9 7b f7 ff ff       	jmp    80105f9f <alltraps>

80106824 <vector69>:
.globl vector69
vector69:
  pushl $0
80106824:	6a 00                	push   $0x0
  pushl $69
80106826:	6a 45                	push   $0x45
  jmp alltraps
80106828:	e9 72 f7 ff ff       	jmp    80105f9f <alltraps>

8010682d <vector70>:
.globl vector70
vector70:
  pushl $0
8010682d:	6a 00                	push   $0x0
  pushl $70
8010682f:	6a 46                	push   $0x46
  jmp alltraps
80106831:	e9 69 f7 ff ff       	jmp    80105f9f <alltraps>

80106836 <vector71>:
.globl vector71
vector71:
  pushl $0
80106836:	6a 00                	push   $0x0
  pushl $71
80106838:	6a 47                	push   $0x47
  jmp alltraps
8010683a:	e9 60 f7 ff ff       	jmp    80105f9f <alltraps>

8010683f <vector72>:
.globl vector72
vector72:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $72
80106841:	6a 48                	push   $0x48
  jmp alltraps
80106843:	e9 57 f7 ff ff       	jmp    80105f9f <alltraps>

80106848 <vector73>:
.globl vector73
vector73:
  pushl $0
80106848:	6a 00                	push   $0x0
  pushl $73
8010684a:	6a 49                	push   $0x49
  jmp alltraps
8010684c:	e9 4e f7 ff ff       	jmp    80105f9f <alltraps>

80106851 <vector74>:
.globl vector74
vector74:
  pushl $0
80106851:	6a 00                	push   $0x0
  pushl $74
80106853:	6a 4a                	push   $0x4a
  jmp alltraps
80106855:	e9 45 f7 ff ff       	jmp    80105f9f <alltraps>

8010685a <vector75>:
.globl vector75
vector75:
  pushl $0
8010685a:	6a 00                	push   $0x0
  pushl $75
8010685c:	6a 4b                	push   $0x4b
  jmp alltraps
8010685e:	e9 3c f7 ff ff       	jmp    80105f9f <alltraps>

80106863 <vector76>:
.globl vector76
vector76:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $76
80106865:	6a 4c                	push   $0x4c
  jmp alltraps
80106867:	e9 33 f7 ff ff       	jmp    80105f9f <alltraps>

8010686c <vector77>:
.globl vector77
vector77:
  pushl $0
8010686c:	6a 00                	push   $0x0
  pushl $77
8010686e:	6a 4d                	push   $0x4d
  jmp alltraps
80106870:	e9 2a f7 ff ff       	jmp    80105f9f <alltraps>

80106875 <vector78>:
.globl vector78
vector78:
  pushl $0
80106875:	6a 00                	push   $0x0
  pushl $78
80106877:	6a 4e                	push   $0x4e
  jmp alltraps
80106879:	e9 21 f7 ff ff       	jmp    80105f9f <alltraps>

8010687e <vector79>:
.globl vector79
vector79:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $79
80106880:	6a 4f                	push   $0x4f
  jmp alltraps
80106882:	e9 18 f7 ff ff       	jmp    80105f9f <alltraps>

80106887 <vector80>:
.globl vector80
vector80:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $80
80106889:	6a 50                	push   $0x50
  jmp alltraps
8010688b:	e9 0f f7 ff ff       	jmp    80105f9f <alltraps>

80106890 <vector81>:
.globl vector81
vector81:
  pushl $0
80106890:	6a 00                	push   $0x0
  pushl $81
80106892:	6a 51                	push   $0x51
  jmp alltraps
80106894:	e9 06 f7 ff ff       	jmp    80105f9f <alltraps>

80106899 <vector82>:
.globl vector82
vector82:
  pushl $0
80106899:	6a 00                	push   $0x0
  pushl $82
8010689b:	6a 52                	push   $0x52
  jmp alltraps
8010689d:	e9 fd f6 ff ff       	jmp    80105f9f <alltraps>

801068a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $83
801068a4:	6a 53                	push   $0x53
  jmp alltraps
801068a6:	e9 f4 f6 ff ff       	jmp    80105f9f <alltraps>

801068ab <vector84>:
.globl vector84
vector84:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $84
801068ad:	6a 54                	push   $0x54
  jmp alltraps
801068af:	e9 eb f6 ff ff       	jmp    80105f9f <alltraps>

801068b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801068b4:	6a 00                	push   $0x0
  pushl $85
801068b6:	6a 55                	push   $0x55
  jmp alltraps
801068b8:	e9 e2 f6 ff ff       	jmp    80105f9f <alltraps>

801068bd <vector86>:
.globl vector86
vector86:
  pushl $0
801068bd:	6a 00                	push   $0x0
  pushl $86
801068bf:	6a 56                	push   $0x56
  jmp alltraps
801068c1:	e9 d9 f6 ff ff       	jmp    80105f9f <alltraps>

801068c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801068c6:	6a 00                	push   $0x0
  pushl $87
801068c8:	6a 57                	push   $0x57
  jmp alltraps
801068ca:	e9 d0 f6 ff ff       	jmp    80105f9f <alltraps>

801068cf <vector88>:
.globl vector88
vector88:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $88
801068d1:	6a 58                	push   $0x58
  jmp alltraps
801068d3:	e9 c7 f6 ff ff       	jmp    80105f9f <alltraps>

801068d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801068d8:	6a 00                	push   $0x0
  pushl $89
801068da:	6a 59                	push   $0x59
  jmp alltraps
801068dc:	e9 be f6 ff ff       	jmp    80105f9f <alltraps>

801068e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801068e1:	6a 00                	push   $0x0
  pushl $90
801068e3:	6a 5a                	push   $0x5a
  jmp alltraps
801068e5:	e9 b5 f6 ff ff       	jmp    80105f9f <alltraps>

801068ea <vector91>:
.globl vector91
vector91:
  pushl $0
801068ea:	6a 00                	push   $0x0
  pushl $91
801068ec:	6a 5b                	push   $0x5b
  jmp alltraps
801068ee:	e9 ac f6 ff ff       	jmp    80105f9f <alltraps>

801068f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $92
801068f5:	6a 5c                	push   $0x5c
  jmp alltraps
801068f7:	e9 a3 f6 ff ff       	jmp    80105f9f <alltraps>

801068fc <vector93>:
.globl vector93
vector93:
  pushl $0
801068fc:	6a 00                	push   $0x0
  pushl $93
801068fe:	6a 5d                	push   $0x5d
  jmp alltraps
80106900:	e9 9a f6 ff ff       	jmp    80105f9f <alltraps>

80106905 <vector94>:
.globl vector94
vector94:
  pushl $0
80106905:	6a 00                	push   $0x0
  pushl $94
80106907:	6a 5e                	push   $0x5e
  jmp alltraps
80106909:	e9 91 f6 ff ff       	jmp    80105f9f <alltraps>

8010690e <vector95>:
.globl vector95
vector95:
  pushl $0
8010690e:	6a 00                	push   $0x0
  pushl $95
80106910:	6a 5f                	push   $0x5f
  jmp alltraps
80106912:	e9 88 f6 ff ff       	jmp    80105f9f <alltraps>

80106917 <vector96>:
.globl vector96
vector96:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $96
80106919:	6a 60                	push   $0x60
  jmp alltraps
8010691b:	e9 7f f6 ff ff       	jmp    80105f9f <alltraps>

80106920 <vector97>:
.globl vector97
vector97:
  pushl $0
80106920:	6a 00                	push   $0x0
  pushl $97
80106922:	6a 61                	push   $0x61
  jmp alltraps
80106924:	e9 76 f6 ff ff       	jmp    80105f9f <alltraps>

80106929 <vector98>:
.globl vector98
vector98:
  pushl $0
80106929:	6a 00                	push   $0x0
  pushl $98
8010692b:	6a 62                	push   $0x62
  jmp alltraps
8010692d:	e9 6d f6 ff ff       	jmp    80105f9f <alltraps>

80106932 <vector99>:
.globl vector99
vector99:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $99
80106934:	6a 63                	push   $0x63
  jmp alltraps
80106936:	e9 64 f6 ff ff       	jmp    80105f9f <alltraps>

8010693b <vector100>:
.globl vector100
vector100:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $100
8010693d:	6a 64                	push   $0x64
  jmp alltraps
8010693f:	e9 5b f6 ff ff       	jmp    80105f9f <alltraps>

80106944 <vector101>:
.globl vector101
vector101:
  pushl $0
80106944:	6a 00                	push   $0x0
  pushl $101
80106946:	6a 65                	push   $0x65
  jmp alltraps
80106948:	e9 52 f6 ff ff       	jmp    80105f9f <alltraps>

8010694d <vector102>:
.globl vector102
vector102:
  pushl $0
8010694d:	6a 00                	push   $0x0
  pushl $102
8010694f:	6a 66                	push   $0x66
  jmp alltraps
80106951:	e9 49 f6 ff ff       	jmp    80105f9f <alltraps>

80106956 <vector103>:
.globl vector103
vector103:
  pushl $0
80106956:	6a 00                	push   $0x0
  pushl $103
80106958:	6a 67                	push   $0x67
  jmp alltraps
8010695a:	e9 40 f6 ff ff       	jmp    80105f9f <alltraps>

8010695f <vector104>:
.globl vector104
vector104:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $104
80106961:	6a 68                	push   $0x68
  jmp alltraps
80106963:	e9 37 f6 ff ff       	jmp    80105f9f <alltraps>

80106968 <vector105>:
.globl vector105
vector105:
  pushl $0
80106968:	6a 00                	push   $0x0
  pushl $105
8010696a:	6a 69                	push   $0x69
  jmp alltraps
8010696c:	e9 2e f6 ff ff       	jmp    80105f9f <alltraps>

80106971 <vector106>:
.globl vector106
vector106:
  pushl $0
80106971:	6a 00                	push   $0x0
  pushl $106
80106973:	6a 6a                	push   $0x6a
  jmp alltraps
80106975:	e9 25 f6 ff ff       	jmp    80105f9f <alltraps>

8010697a <vector107>:
.globl vector107
vector107:
  pushl $0
8010697a:	6a 00                	push   $0x0
  pushl $107
8010697c:	6a 6b                	push   $0x6b
  jmp alltraps
8010697e:	e9 1c f6 ff ff       	jmp    80105f9f <alltraps>

80106983 <vector108>:
.globl vector108
vector108:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $108
80106985:	6a 6c                	push   $0x6c
  jmp alltraps
80106987:	e9 13 f6 ff ff       	jmp    80105f9f <alltraps>

8010698c <vector109>:
.globl vector109
vector109:
  pushl $0
8010698c:	6a 00                	push   $0x0
  pushl $109
8010698e:	6a 6d                	push   $0x6d
  jmp alltraps
80106990:	e9 0a f6 ff ff       	jmp    80105f9f <alltraps>

80106995 <vector110>:
.globl vector110
vector110:
  pushl $0
80106995:	6a 00                	push   $0x0
  pushl $110
80106997:	6a 6e                	push   $0x6e
  jmp alltraps
80106999:	e9 01 f6 ff ff       	jmp    80105f9f <alltraps>

8010699e <vector111>:
.globl vector111
vector111:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $111
801069a0:	6a 6f                	push   $0x6f
  jmp alltraps
801069a2:	e9 f8 f5 ff ff       	jmp    80105f9f <alltraps>

801069a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $112
801069a9:	6a 70                	push   $0x70
  jmp alltraps
801069ab:	e9 ef f5 ff ff       	jmp    80105f9f <alltraps>

801069b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801069b0:	6a 00                	push   $0x0
  pushl $113
801069b2:	6a 71                	push   $0x71
  jmp alltraps
801069b4:	e9 e6 f5 ff ff       	jmp    80105f9f <alltraps>

801069b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801069b9:	6a 00                	push   $0x0
  pushl $114
801069bb:	6a 72                	push   $0x72
  jmp alltraps
801069bd:	e9 dd f5 ff ff       	jmp    80105f9f <alltraps>

801069c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $115
801069c4:	6a 73                	push   $0x73
  jmp alltraps
801069c6:	e9 d4 f5 ff ff       	jmp    80105f9f <alltraps>

801069cb <vector116>:
.globl vector116
vector116:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $116
801069cd:	6a 74                	push   $0x74
  jmp alltraps
801069cf:	e9 cb f5 ff ff       	jmp    80105f9f <alltraps>

801069d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801069d4:	6a 00                	push   $0x0
  pushl $117
801069d6:	6a 75                	push   $0x75
  jmp alltraps
801069d8:	e9 c2 f5 ff ff       	jmp    80105f9f <alltraps>

801069dd <vector118>:
.globl vector118
vector118:
  pushl $0
801069dd:	6a 00                	push   $0x0
  pushl $118
801069df:	6a 76                	push   $0x76
  jmp alltraps
801069e1:	e9 b9 f5 ff ff       	jmp    80105f9f <alltraps>

801069e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $119
801069e8:	6a 77                	push   $0x77
  jmp alltraps
801069ea:	e9 b0 f5 ff ff       	jmp    80105f9f <alltraps>

801069ef <vector120>:
.globl vector120
vector120:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $120
801069f1:	6a 78                	push   $0x78
  jmp alltraps
801069f3:	e9 a7 f5 ff ff       	jmp    80105f9f <alltraps>

801069f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801069f8:	6a 00                	push   $0x0
  pushl $121
801069fa:	6a 79                	push   $0x79
  jmp alltraps
801069fc:	e9 9e f5 ff ff       	jmp    80105f9f <alltraps>

80106a01 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a01:	6a 00                	push   $0x0
  pushl $122
80106a03:	6a 7a                	push   $0x7a
  jmp alltraps
80106a05:	e9 95 f5 ff ff       	jmp    80105f9f <alltraps>

80106a0a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $123
80106a0c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a0e:	e9 8c f5 ff ff       	jmp    80105f9f <alltraps>

80106a13 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $124
80106a15:	6a 7c                	push   $0x7c
  jmp alltraps
80106a17:	e9 83 f5 ff ff       	jmp    80105f9f <alltraps>

80106a1c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a1c:	6a 00                	push   $0x0
  pushl $125
80106a1e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a20:	e9 7a f5 ff ff       	jmp    80105f9f <alltraps>

80106a25 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a25:	6a 00                	push   $0x0
  pushl $126
80106a27:	6a 7e                	push   $0x7e
  jmp alltraps
80106a29:	e9 71 f5 ff ff       	jmp    80105f9f <alltraps>

80106a2e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $127
80106a30:	6a 7f                	push   $0x7f
  jmp alltraps
80106a32:	e9 68 f5 ff ff       	jmp    80105f9f <alltraps>

80106a37 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $128
80106a39:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a3e:	e9 5c f5 ff ff       	jmp    80105f9f <alltraps>

80106a43 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $129
80106a45:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a4a:	e9 50 f5 ff ff       	jmp    80105f9f <alltraps>

80106a4f <vector130>:
.globl vector130
vector130:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $130
80106a51:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a56:	e9 44 f5 ff ff       	jmp    80105f9f <alltraps>

80106a5b <vector131>:
.globl vector131
vector131:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $131
80106a5d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a62:	e9 38 f5 ff ff       	jmp    80105f9f <alltraps>

80106a67 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $132
80106a69:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a6e:	e9 2c f5 ff ff       	jmp    80105f9f <alltraps>

80106a73 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $133
80106a75:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a7a:	e9 20 f5 ff ff       	jmp    80105f9f <alltraps>

80106a7f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $134
80106a81:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a86:	e9 14 f5 ff ff       	jmp    80105f9f <alltraps>

80106a8b <vector135>:
.globl vector135
vector135:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $135
80106a8d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a92:	e9 08 f5 ff ff       	jmp    80105f9f <alltraps>

80106a97 <vector136>:
.globl vector136
vector136:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $136
80106a99:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a9e:	e9 fc f4 ff ff       	jmp    80105f9f <alltraps>

80106aa3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $137
80106aa5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106aaa:	e9 f0 f4 ff ff       	jmp    80105f9f <alltraps>

80106aaf <vector138>:
.globl vector138
vector138:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $138
80106ab1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ab6:	e9 e4 f4 ff ff       	jmp    80105f9f <alltraps>

80106abb <vector139>:
.globl vector139
vector139:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $139
80106abd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ac2:	e9 d8 f4 ff ff       	jmp    80105f9f <alltraps>

80106ac7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $140
80106ac9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106ace:	e9 cc f4 ff ff       	jmp    80105f9f <alltraps>

80106ad3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $141
80106ad5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106ada:	e9 c0 f4 ff ff       	jmp    80105f9f <alltraps>

80106adf <vector142>:
.globl vector142
vector142:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $142
80106ae1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106ae6:	e9 b4 f4 ff ff       	jmp    80105f9f <alltraps>

80106aeb <vector143>:
.globl vector143
vector143:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $143
80106aed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106af2:	e9 a8 f4 ff ff       	jmp    80105f9f <alltraps>

80106af7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $144
80106af9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106afe:	e9 9c f4 ff ff       	jmp    80105f9f <alltraps>

80106b03 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $145
80106b05:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b0a:	e9 90 f4 ff ff       	jmp    80105f9f <alltraps>

80106b0f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $146
80106b11:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b16:	e9 84 f4 ff ff       	jmp    80105f9f <alltraps>

80106b1b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $147
80106b1d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b22:	e9 78 f4 ff ff       	jmp    80105f9f <alltraps>

80106b27 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $148
80106b29:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b2e:	e9 6c f4 ff ff       	jmp    80105f9f <alltraps>

80106b33 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $149
80106b35:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b3a:	e9 60 f4 ff ff       	jmp    80105f9f <alltraps>

80106b3f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $150
80106b41:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b46:	e9 54 f4 ff ff       	jmp    80105f9f <alltraps>

80106b4b <vector151>:
.globl vector151
vector151:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $151
80106b4d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b52:	e9 48 f4 ff ff       	jmp    80105f9f <alltraps>

80106b57 <vector152>:
.globl vector152
vector152:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $152
80106b59:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b5e:	e9 3c f4 ff ff       	jmp    80105f9f <alltraps>

80106b63 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $153
80106b65:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b6a:	e9 30 f4 ff ff       	jmp    80105f9f <alltraps>

80106b6f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $154
80106b71:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b76:	e9 24 f4 ff ff       	jmp    80105f9f <alltraps>

80106b7b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $155
80106b7d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b82:	e9 18 f4 ff ff       	jmp    80105f9f <alltraps>

80106b87 <vector156>:
.globl vector156
vector156:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $156
80106b89:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b8e:	e9 0c f4 ff ff       	jmp    80105f9f <alltraps>

80106b93 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $157
80106b95:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b9a:	e9 00 f4 ff ff       	jmp    80105f9f <alltraps>

80106b9f <vector158>:
.globl vector158
vector158:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $158
80106ba1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106ba6:	e9 f4 f3 ff ff       	jmp    80105f9f <alltraps>

80106bab <vector159>:
.globl vector159
vector159:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $159
80106bad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bb2:	e9 e8 f3 ff ff       	jmp    80105f9f <alltraps>

80106bb7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $160
80106bb9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106bbe:	e9 dc f3 ff ff       	jmp    80105f9f <alltraps>

80106bc3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $161
80106bc5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bca:	e9 d0 f3 ff ff       	jmp    80105f9f <alltraps>

80106bcf <vector162>:
.globl vector162
vector162:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $162
80106bd1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106bd6:	e9 c4 f3 ff ff       	jmp    80105f9f <alltraps>

80106bdb <vector163>:
.globl vector163
vector163:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $163
80106bdd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106be2:	e9 b8 f3 ff ff       	jmp    80105f9f <alltraps>

80106be7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $164
80106be9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106bee:	e9 ac f3 ff ff       	jmp    80105f9f <alltraps>

80106bf3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $165
80106bf5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106bfa:	e9 a0 f3 ff ff       	jmp    80105f9f <alltraps>

80106bff <vector166>:
.globl vector166
vector166:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $166
80106c01:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c06:	e9 94 f3 ff ff       	jmp    80105f9f <alltraps>

80106c0b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $167
80106c0d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c12:	e9 88 f3 ff ff       	jmp    80105f9f <alltraps>

80106c17 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $168
80106c19:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c1e:	e9 7c f3 ff ff       	jmp    80105f9f <alltraps>

80106c23 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $169
80106c25:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c2a:	e9 70 f3 ff ff       	jmp    80105f9f <alltraps>

80106c2f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $170
80106c31:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c36:	e9 64 f3 ff ff       	jmp    80105f9f <alltraps>

80106c3b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $171
80106c3d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c42:	e9 58 f3 ff ff       	jmp    80105f9f <alltraps>

80106c47 <vector172>:
.globl vector172
vector172:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $172
80106c49:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c4e:	e9 4c f3 ff ff       	jmp    80105f9f <alltraps>

80106c53 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $173
80106c55:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c5a:	e9 40 f3 ff ff       	jmp    80105f9f <alltraps>

80106c5f <vector174>:
.globl vector174
vector174:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $174
80106c61:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c66:	e9 34 f3 ff ff       	jmp    80105f9f <alltraps>

80106c6b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $175
80106c6d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c72:	e9 28 f3 ff ff       	jmp    80105f9f <alltraps>

80106c77 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $176
80106c79:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c7e:	e9 1c f3 ff ff       	jmp    80105f9f <alltraps>

80106c83 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $177
80106c85:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c8a:	e9 10 f3 ff ff       	jmp    80105f9f <alltraps>

80106c8f <vector178>:
.globl vector178
vector178:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $178
80106c91:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c96:	e9 04 f3 ff ff       	jmp    80105f9f <alltraps>

80106c9b <vector179>:
.globl vector179
vector179:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $179
80106c9d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ca2:	e9 f8 f2 ff ff       	jmp    80105f9f <alltraps>

80106ca7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $180
80106ca9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cae:	e9 ec f2 ff ff       	jmp    80105f9f <alltraps>

80106cb3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $181
80106cb5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cba:	e9 e0 f2 ff ff       	jmp    80105f9f <alltraps>

80106cbf <vector182>:
.globl vector182
vector182:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $182
80106cc1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106cc6:	e9 d4 f2 ff ff       	jmp    80105f9f <alltraps>

80106ccb <vector183>:
.globl vector183
vector183:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $183
80106ccd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106cd2:	e9 c8 f2 ff ff       	jmp    80105f9f <alltraps>

80106cd7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $184
80106cd9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106cde:	e9 bc f2 ff ff       	jmp    80105f9f <alltraps>

80106ce3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $185
80106ce5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106cea:	e9 b0 f2 ff ff       	jmp    80105f9f <alltraps>

80106cef <vector186>:
.globl vector186
vector186:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $186
80106cf1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106cf6:	e9 a4 f2 ff ff       	jmp    80105f9f <alltraps>

80106cfb <vector187>:
.globl vector187
vector187:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $187
80106cfd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d02:	e9 98 f2 ff ff       	jmp    80105f9f <alltraps>

80106d07 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $188
80106d09:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d0e:	e9 8c f2 ff ff       	jmp    80105f9f <alltraps>

80106d13 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $189
80106d15:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d1a:	e9 80 f2 ff ff       	jmp    80105f9f <alltraps>

80106d1f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $190
80106d21:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d26:	e9 74 f2 ff ff       	jmp    80105f9f <alltraps>

80106d2b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $191
80106d2d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d32:	e9 68 f2 ff ff       	jmp    80105f9f <alltraps>

80106d37 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $192
80106d39:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d3e:	e9 5c f2 ff ff       	jmp    80105f9f <alltraps>

80106d43 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $193
80106d45:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d4a:	e9 50 f2 ff ff       	jmp    80105f9f <alltraps>

80106d4f <vector194>:
.globl vector194
vector194:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $194
80106d51:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d56:	e9 44 f2 ff ff       	jmp    80105f9f <alltraps>

80106d5b <vector195>:
.globl vector195
vector195:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $195
80106d5d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d62:	e9 38 f2 ff ff       	jmp    80105f9f <alltraps>

80106d67 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $196
80106d69:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d6e:	e9 2c f2 ff ff       	jmp    80105f9f <alltraps>

80106d73 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $197
80106d75:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d7a:	e9 20 f2 ff ff       	jmp    80105f9f <alltraps>

80106d7f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $198
80106d81:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d86:	e9 14 f2 ff ff       	jmp    80105f9f <alltraps>

80106d8b <vector199>:
.globl vector199
vector199:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $199
80106d8d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d92:	e9 08 f2 ff ff       	jmp    80105f9f <alltraps>

80106d97 <vector200>:
.globl vector200
vector200:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $200
80106d99:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d9e:	e9 fc f1 ff ff       	jmp    80105f9f <alltraps>

80106da3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $201
80106da5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106daa:	e9 f0 f1 ff ff       	jmp    80105f9f <alltraps>

80106daf <vector202>:
.globl vector202
vector202:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $202
80106db1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106db6:	e9 e4 f1 ff ff       	jmp    80105f9f <alltraps>

80106dbb <vector203>:
.globl vector203
vector203:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $203
80106dbd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106dc2:	e9 d8 f1 ff ff       	jmp    80105f9f <alltraps>

80106dc7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $204
80106dc9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106dce:	e9 cc f1 ff ff       	jmp    80105f9f <alltraps>

80106dd3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $205
80106dd5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106dda:	e9 c0 f1 ff ff       	jmp    80105f9f <alltraps>

80106ddf <vector206>:
.globl vector206
vector206:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $206
80106de1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106de6:	e9 b4 f1 ff ff       	jmp    80105f9f <alltraps>

80106deb <vector207>:
.globl vector207
vector207:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $207
80106ded:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106df2:	e9 a8 f1 ff ff       	jmp    80105f9f <alltraps>

80106df7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $208
80106df9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106dfe:	e9 9c f1 ff ff       	jmp    80105f9f <alltraps>

80106e03 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $209
80106e05:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e0a:	e9 90 f1 ff ff       	jmp    80105f9f <alltraps>

80106e0f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $210
80106e11:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e16:	e9 84 f1 ff ff       	jmp    80105f9f <alltraps>

80106e1b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $211
80106e1d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e22:	e9 78 f1 ff ff       	jmp    80105f9f <alltraps>

80106e27 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $212
80106e29:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e2e:	e9 6c f1 ff ff       	jmp    80105f9f <alltraps>

80106e33 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $213
80106e35:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e3a:	e9 60 f1 ff ff       	jmp    80105f9f <alltraps>

80106e3f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $214
80106e41:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e46:	e9 54 f1 ff ff       	jmp    80105f9f <alltraps>

80106e4b <vector215>:
.globl vector215
vector215:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $215
80106e4d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e52:	e9 48 f1 ff ff       	jmp    80105f9f <alltraps>

80106e57 <vector216>:
.globl vector216
vector216:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $216
80106e59:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e5e:	e9 3c f1 ff ff       	jmp    80105f9f <alltraps>

80106e63 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $217
80106e65:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e6a:	e9 30 f1 ff ff       	jmp    80105f9f <alltraps>

80106e6f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $218
80106e71:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e76:	e9 24 f1 ff ff       	jmp    80105f9f <alltraps>

80106e7b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $219
80106e7d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e82:	e9 18 f1 ff ff       	jmp    80105f9f <alltraps>

80106e87 <vector220>:
.globl vector220
vector220:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $220
80106e89:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e8e:	e9 0c f1 ff ff       	jmp    80105f9f <alltraps>

80106e93 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $221
80106e95:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e9a:	e9 00 f1 ff ff       	jmp    80105f9f <alltraps>

80106e9f <vector222>:
.globl vector222
vector222:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $222
80106ea1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ea6:	e9 f4 f0 ff ff       	jmp    80105f9f <alltraps>

80106eab <vector223>:
.globl vector223
vector223:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $223
80106ead:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106eb2:	e9 e8 f0 ff ff       	jmp    80105f9f <alltraps>

80106eb7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $224
80106eb9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ebe:	e9 dc f0 ff ff       	jmp    80105f9f <alltraps>

80106ec3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $225
80106ec5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106eca:	e9 d0 f0 ff ff       	jmp    80105f9f <alltraps>

80106ecf <vector226>:
.globl vector226
vector226:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $226
80106ed1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ed6:	e9 c4 f0 ff ff       	jmp    80105f9f <alltraps>

80106edb <vector227>:
.globl vector227
vector227:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $227
80106edd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ee2:	e9 b8 f0 ff ff       	jmp    80105f9f <alltraps>

80106ee7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $228
80106ee9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106eee:	e9 ac f0 ff ff       	jmp    80105f9f <alltraps>

80106ef3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $229
80106ef5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106efa:	e9 a0 f0 ff ff       	jmp    80105f9f <alltraps>

80106eff <vector230>:
.globl vector230
vector230:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $230
80106f01:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f06:	e9 94 f0 ff ff       	jmp    80105f9f <alltraps>

80106f0b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $231
80106f0d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f12:	e9 88 f0 ff ff       	jmp    80105f9f <alltraps>

80106f17 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $232
80106f19:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f1e:	e9 7c f0 ff ff       	jmp    80105f9f <alltraps>

80106f23 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $233
80106f25:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f2a:	e9 70 f0 ff ff       	jmp    80105f9f <alltraps>

80106f2f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $234
80106f31:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f36:	e9 64 f0 ff ff       	jmp    80105f9f <alltraps>

80106f3b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $235
80106f3d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f42:	e9 58 f0 ff ff       	jmp    80105f9f <alltraps>

80106f47 <vector236>:
.globl vector236
vector236:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $236
80106f49:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f4e:	e9 4c f0 ff ff       	jmp    80105f9f <alltraps>

80106f53 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $237
80106f55:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f5a:	e9 40 f0 ff ff       	jmp    80105f9f <alltraps>

80106f5f <vector238>:
.globl vector238
vector238:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $238
80106f61:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f66:	e9 34 f0 ff ff       	jmp    80105f9f <alltraps>

80106f6b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $239
80106f6d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f72:	e9 28 f0 ff ff       	jmp    80105f9f <alltraps>

80106f77 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $240
80106f79:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f7e:	e9 1c f0 ff ff       	jmp    80105f9f <alltraps>

80106f83 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $241
80106f85:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f8a:	e9 10 f0 ff ff       	jmp    80105f9f <alltraps>

80106f8f <vector242>:
.globl vector242
vector242:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $242
80106f91:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f96:	e9 04 f0 ff ff       	jmp    80105f9f <alltraps>

80106f9b <vector243>:
.globl vector243
vector243:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $243
80106f9d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fa2:	e9 f8 ef ff ff       	jmp    80105f9f <alltraps>

80106fa7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $244
80106fa9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fae:	e9 ec ef ff ff       	jmp    80105f9f <alltraps>

80106fb3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $245
80106fb5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fba:	e9 e0 ef ff ff       	jmp    80105f9f <alltraps>

80106fbf <vector246>:
.globl vector246
vector246:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $246
80106fc1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106fc6:	e9 d4 ef ff ff       	jmp    80105f9f <alltraps>

80106fcb <vector247>:
.globl vector247
vector247:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $247
80106fcd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106fd2:	e9 c8 ef ff ff       	jmp    80105f9f <alltraps>

80106fd7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $248
80106fd9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106fde:	e9 bc ef ff ff       	jmp    80105f9f <alltraps>

80106fe3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $249
80106fe5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106fea:	e9 b0 ef ff ff       	jmp    80105f9f <alltraps>

80106fef <vector250>:
.globl vector250
vector250:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $250
80106ff1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ff6:	e9 a4 ef ff ff       	jmp    80105f9f <alltraps>

80106ffb <vector251>:
.globl vector251
vector251:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $251
80106ffd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107002:	e9 98 ef ff ff       	jmp    80105f9f <alltraps>

80107007 <vector252>:
.globl vector252
vector252:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $252
80107009:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010700e:	e9 8c ef ff ff       	jmp    80105f9f <alltraps>

80107013 <vector253>:
.globl vector253
vector253:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $253
80107015:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010701a:	e9 80 ef ff ff       	jmp    80105f9f <alltraps>

8010701f <vector254>:
.globl vector254
vector254:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $254
80107021:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107026:	e9 74 ef ff ff       	jmp    80105f9f <alltraps>

8010702b <vector255>:
.globl vector255
vector255:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $255
8010702d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107032:	e9 68 ef ff ff       	jmp    80105f9f <alltraps>
80107037:	66 90                	xchg   %ax,%ax
80107039:	66 90                	xchg   %ax,%ax
8010703b:	66 90                	xchg   %ax,%ax
8010703d:	66 90                	xchg   %ax,%ax
8010703f:	90                   	nop

80107040 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107046:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010704c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107052:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80107055:	39 d3                	cmp    %edx,%ebx
80107057:	73 56                	jae    801070af <deallocuvm.part.0+0x6f>
80107059:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010705c:	89 c6                	mov    %eax,%esi
8010705e:	89 d7                	mov    %edx,%edi
80107060:	eb 12                	jmp    80107074 <deallocuvm.part.0+0x34>
80107062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107068:	83 c2 01             	add    $0x1,%edx
8010706b:	89 d3                	mov    %edx,%ebx
8010706d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107070:	39 fb                	cmp    %edi,%ebx
80107072:	73 38                	jae    801070ac <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80107074:	89 da                	mov    %ebx,%edx
80107076:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107079:	8b 04 96             	mov    (%esi,%edx,4),%eax
8010707c:	a8 01                	test   $0x1,%al
8010707e:	74 e8                	je     80107068 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80107080:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107082:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107087:	c1 e9 0a             	shr    $0xa,%ecx
8010708a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80107090:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80107097:	85 c0                	test   %eax,%eax
80107099:	74 cd                	je     80107068 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
8010709b:	8b 10                	mov    (%eax),%edx
8010709d:	f6 c2 01             	test   $0x1,%dl
801070a0:	75 1e                	jne    801070c0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
801070a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070a8:	39 fb                	cmp    %edi,%ebx
801070aa:	72 c8                	jb     80107074 <deallocuvm.part.0+0x34>
801070ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801070af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b2:	89 c8                	mov    %ecx,%eax
801070b4:	5b                   	pop    %ebx
801070b5:	5e                   	pop    %esi
801070b6:	5f                   	pop    %edi
801070b7:	5d                   	pop    %ebp
801070b8:	c3                   	ret
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801070c0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801070c6:	74 26                	je     801070ee <deallocuvm.part.0+0xae>
      kfree(v);
801070c8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801070cb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801070d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801070d4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801070da:	52                   	push   %edx
801070db:	e8 90 b4 ff ff       	call   80102570 <kfree>
      *pte = 0;
801070e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
801070e3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801070e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801070ec:	eb 82                	jmp    80107070 <deallocuvm.part.0+0x30>
        panic("kfree");
801070ee:	83 ec 0c             	sub    $0xc,%esp
801070f1:	68 de 7b 10 80       	push   $0x80107bde
801070f6:	e8 85 92 ff ff       	call   80100380 <panic>
801070fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107100 <seginit>:
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107106:	e8 85 c9 ff ff       	call   80103a90 <cpuid>
  pd[0] = size-1;
8010710b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107110:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107116:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
8010711a:	c7 80 58 31 11 80 ff 	movl   $0xffff,-0x7feecea8(%eax)
80107121:	ff 00 00 
80107124:	c7 80 5c 31 11 80 00 	movl   $0xcf9a00,-0x7feecea4(%eax)
8010712b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010712e:	c7 80 60 31 11 80 ff 	movl   $0xffff,-0x7feecea0(%eax)
80107135:	ff 00 00 
80107138:	c7 80 64 31 11 80 00 	movl   $0xcf9200,-0x7feece9c(%eax)
8010713f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107142:	c7 80 68 31 11 80 ff 	movl   $0xffff,-0x7feece98(%eax)
80107149:	ff 00 00 
8010714c:	c7 80 6c 31 11 80 00 	movl   $0xcffa00,-0x7feece94(%eax)
80107153:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107156:	c7 80 70 31 11 80 ff 	movl   $0xffff,-0x7feece90(%eax)
8010715d:	ff 00 00 
80107160:	c7 80 74 31 11 80 00 	movl   $0xcff200,-0x7feece8c(%eax)
80107167:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010716a:	05 50 31 11 80       	add    $0x80113150,%eax
  pd[1] = (uint)p;
8010716f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107173:	c1 e8 10             	shr    $0x10,%eax
80107176:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010717a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010717d:	0f 01 10             	lgdtl  (%eax)
}
80107180:	c9                   	leave
80107181:	c3                   	ret
80107182:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107189:	00 
8010718a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107190 <mappages>:
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	53                   	push   %ebx
80107196:	83 ec 1c             	sub    $0x1c,%esp
80107199:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010719c:	8b 55 10             	mov    0x10(%ebp),%edx
  a = (char*)PGROUNDDOWN((uint)va);
8010719f:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071a1:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
801071a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801071aa:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071b3:	8b 45 14             	mov    0x14(%ebp),%eax
801071b6:	29 d8                	sub    %ebx,%eax
801071b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071bb:	eb 3c                	jmp    801071f9 <mappages+0x69>
801071bd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801071c0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801071c7:	c1 ea 0a             	shr    $0xa,%edx
801071ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071d7:	85 c0                	test   %eax,%eax
801071d9:	74 75                	je     80107250 <mappages+0xc0>
    if(*pte & PTE_P)
801071db:	f6 00 01             	testb  $0x1,(%eax)
801071de:	0f 85 86 00 00 00    	jne    8010726a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801071e4:	0b 75 18             	or     0x18(%ebp),%esi
801071e7:	83 ce 01             	or     $0x1,%esi
801071ea:	89 30                	mov    %esi,(%eax)
    if(a == last)
801071ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071ef:	39 c3                	cmp    %eax,%ebx
801071f1:	74 6d                	je     80107260 <mappages+0xd0>
    a += PGSIZE;
801071f3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801071f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
801071fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
801071ff:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80107202:	89 d8                	mov    %ebx,%eax
80107204:	c1 e8 16             	shr    $0x16,%eax
80107207:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
8010720a:	8b 07                	mov    (%edi),%eax
8010720c:	a8 01                	test   $0x1,%al
8010720e:	75 b0                	jne    801071c0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107210:	e8 1b b5 ff ff       	call   80102730 <kalloc>
80107215:	85 c0                	test   %eax,%eax
80107217:	74 37                	je     80107250 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107219:	83 ec 04             	sub    $0x4,%esp
8010721c:	68 00 10 00 00       	push   $0x1000
80107221:	6a 00                	push   $0x0
80107223:	50                   	push   %eax
80107224:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107227:	e8 34 d6 ff ff       	call   80104860 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010722c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  return &pgtab[PTX(va)];
8010722f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107232:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107238:	83 c8 07             	or     $0x7,%eax
8010723b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010723d:	89 d8                	mov    %ebx,%eax
8010723f:	c1 e8 0a             	shr    $0xa,%eax
80107242:	25 fc 0f 00 00       	and    $0xffc,%eax
80107247:	01 d0                	add    %edx,%eax
80107249:	eb 90                	jmp    801071db <mappages+0x4b>
8010724b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80107250:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107253:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107258:	5b                   	pop    %ebx
80107259:	5e                   	pop    %esi
8010725a:	5f                   	pop    %edi
8010725b:	5d                   	pop    %ebp
8010725c:	c3                   	ret
8010725d:	8d 76 00             	lea    0x0(%esi),%esi
80107260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107263:	31 c0                	xor    %eax,%eax
}
80107265:	5b                   	pop    %ebx
80107266:	5e                   	pop    %esi
80107267:	5f                   	pop    %edi
80107268:	5d                   	pop    %ebp
80107269:	c3                   	ret
      panic("remap");
8010726a:	83 ec 0c             	sub    $0xc,%esp
8010726d:	68 af 7e 10 80       	push   $0x80107eaf
80107272:	e8 09 91 ff ff       	call   80100380 <panic>
80107277:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010727e:	00 
8010727f:	90                   	nop

80107280 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107280:	a1 04 7f 11 80       	mov    0x80117f04,%eax
80107285:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010728a:	0f 22 d8             	mov    %eax,%cr3
}
8010728d:	c3                   	ret
8010728e:	66 90                	xchg   %ax,%ax

80107290 <switchuvm>:
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	56                   	push   %esi
80107295:	53                   	push   %ebx
80107296:	83 ec 1c             	sub    $0x1c,%esp
80107299:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010729c:	85 f6                	test   %esi,%esi
8010729e:	0f 84 cb 00 00 00    	je     8010736f <switchuvm+0xdf>
  if(p->kstack == 0)
801072a4:	8b 46 08             	mov    0x8(%esi),%eax
801072a7:	85 c0                	test   %eax,%eax
801072a9:	0f 84 da 00 00 00    	je     80107389 <switchuvm+0xf9>
  if(p->pgdir == 0)
801072af:	8b 46 04             	mov    0x4(%esi),%eax
801072b2:	85 c0                	test   %eax,%eax
801072b4:	0f 84 c2 00 00 00    	je     8010737c <switchuvm+0xec>
  pushcli();
801072ba:	e8 51 d3 ff ff       	call   80104610 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072bf:	e8 6c c7 ff ff       	call   80103a30 <mycpu>
801072c4:	89 c3                	mov    %eax,%ebx
801072c6:	e8 65 c7 ff ff       	call   80103a30 <mycpu>
801072cb:	89 c7                	mov    %eax,%edi
801072cd:	e8 5e c7 ff ff       	call   80103a30 <mycpu>
801072d2:	83 c7 08             	add    $0x8,%edi
801072d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072d8:	e8 53 c7 ff ff       	call   80103a30 <mycpu>
801072dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072e0:	ba 67 00 00 00       	mov    $0x67,%edx
801072e5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801072ec:	83 c0 08             	add    $0x8,%eax
801072ef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072f6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072fb:	83 c1 08             	add    $0x8,%ecx
801072fe:	c1 e8 18             	shr    $0x18,%eax
80107301:	c1 e9 10             	shr    $0x10,%ecx
80107304:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010730a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107310:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107315:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010731c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107321:	e8 0a c7 ff ff       	call   80103a30 <mycpu>
80107326:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010732d:	e8 fe c6 ff ff       	call   80103a30 <mycpu>
80107332:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107336:	8b 5e 08             	mov    0x8(%esi),%ebx
80107339:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010733f:	e8 ec c6 ff ff       	call   80103a30 <mycpu>
80107344:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107347:	e8 e4 c6 ff ff       	call   80103a30 <mycpu>
8010734c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107350:	b8 28 00 00 00       	mov    $0x28,%eax
80107355:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107358:	8b 46 04             	mov    0x4(%esi),%eax
8010735b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107360:	0f 22 d8             	mov    %eax,%cr3
}
80107363:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107366:	5b                   	pop    %ebx
80107367:	5e                   	pop    %esi
80107368:	5f                   	pop    %edi
80107369:	5d                   	pop    %ebp
  popcli();
8010736a:	e9 f1 d2 ff ff       	jmp    80104660 <popcli>
    panic("switchuvm: no process");
8010736f:	83 ec 0c             	sub    $0xc,%esp
80107372:	68 b5 7e 10 80       	push   $0x80107eb5
80107377:	e8 04 90 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010737c:	83 ec 0c             	sub    $0xc,%esp
8010737f:	68 e0 7e 10 80       	push   $0x80107ee0
80107384:	e8 f7 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107389:	83 ec 0c             	sub    $0xc,%esp
8010738c:	68 cb 7e 10 80       	push   $0x80107ecb
80107391:	e8 ea 8f ff ff       	call   80100380 <panic>
80107396:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010739d:	00 
8010739e:	66 90                	xchg   %ax,%ax

801073a0 <inituvm>:
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	57                   	push   %edi
801073a4:	56                   	push   %esi
801073a5:	53                   	push   %ebx
801073a6:	83 ec 1c             	sub    $0x1c,%esp
801073a9:	8b 75 10             	mov    0x10(%ebp),%esi
801073ac:	8b 55 08             	mov    0x8(%ebp),%edx
801073af:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801073b2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801073b8:	77 50                	ja     8010740a <inituvm+0x6a>
801073ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
801073bd:	e8 6e b3 ff ff       	call   80102730 <kalloc>
  memset(mem, 0, PGSIZE);
801073c2:	83 ec 04             	sub    $0x4,%esp
801073c5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801073ca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801073cc:	6a 00                	push   $0x0
801073ce:	50                   	push   %eax
801073cf:	e8 8c d4 ff ff       	call   80104860 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801073d4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073da:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801073e1:	50                   	push   %eax
801073e2:	68 00 10 00 00       	push   $0x1000
801073e7:	6a 00                	push   $0x0
801073e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801073ec:	52                   	push   %edx
801073ed:	e8 9e fd ff ff       	call   80107190 <mappages>
  memmove(mem, init, sz);
801073f2:	89 75 10             	mov    %esi,0x10(%ebp)
801073f5:	83 c4 20             	add    $0x20,%esp
801073f8:	89 7d 0c             	mov    %edi,0xc(%ebp)
801073fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801073fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107401:	5b                   	pop    %ebx
80107402:	5e                   	pop    %esi
80107403:	5f                   	pop    %edi
80107404:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107405:	e9 e6 d4 ff ff       	jmp    801048f0 <memmove>
    panic("inituvm: more than a page");
8010740a:	83 ec 0c             	sub    $0xc,%esp
8010740d:	68 f4 7e 10 80       	push   $0x80107ef4
80107412:	e8 69 8f ff ff       	call   80100380 <panic>
80107417:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010741e:	00 
8010741f:	90                   	nop

80107420 <loaduvm>:
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
80107426:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107429:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010742c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010742f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107435:	0f 85 a2 00 00 00    	jne    801074dd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010743b:	85 ff                	test   %edi,%edi
8010743d:	74 7d                	je     801074bc <loaduvm+0x9c>
8010743f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107440:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107443:	8b 55 08             	mov    0x8(%ebp),%edx
80107446:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107448:	89 c1                	mov    %eax,%ecx
8010744a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010744d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80107450:	f6 c1 01             	test   $0x1,%cl
80107453:	75 13                	jne    80107468 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80107455:	83 ec 0c             	sub    $0xc,%esp
80107458:	68 0e 7f 10 80       	push   $0x80107f0e
8010745d:	e8 1e 8f ff ff       	call   80100380 <panic>
80107462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107468:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010746b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107471:	25 fc 0f 00 00       	and    $0xffc,%eax
80107476:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010747d:	85 c9                	test   %ecx,%ecx
8010747f:	74 d4                	je     80107455 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80107481:	89 fb                	mov    %edi,%ebx
80107483:	b8 00 10 00 00       	mov    $0x1000,%eax
80107488:	29 f3                	sub    %esi,%ebx
8010748a:	39 c3                	cmp    %eax,%ebx
8010748c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010748f:	53                   	push   %ebx
80107490:	8b 45 14             	mov    0x14(%ebp),%eax
80107493:	01 f0                	add    %esi,%eax
80107495:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80107496:	8b 01                	mov    (%ecx),%eax
80107498:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010749d:	05 00 00 00 80       	add    $0x80000000,%eax
801074a2:	50                   	push   %eax
801074a3:	ff 75 10             	push   0x10(%ebp)
801074a6:	e8 d5 a6 ff ff       	call   80101b80 <readi>
801074ab:	83 c4 10             	add    $0x10,%esp
801074ae:	39 d8                	cmp    %ebx,%eax
801074b0:	75 1e                	jne    801074d0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
801074b2:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074b8:	39 fe                	cmp    %edi,%esi
801074ba:	72 84                	jb     80107440 <loaduvm+0x20>
}
801074bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074bf:	31 c0                	xor    %eax,%eax
}
801074c1:	5b                   	pop    %ebx
801074c2:	5e                   	pop    %esi
801074c3:	5f                   	pop    %edi
801074c4:	5d                   	pop    %ebp
801074c5:	c3                   	ret
801074c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074cd:	00 
801074ce:	66 90                	xchg   %ax,%ax
801074d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074d8:	5b                   	pop    %ebx
801074d9:	5e                   	pop    %esi
801074da:	5f                   	pop    %edi
801074db:	5d                   	pop    %ebp
801074dc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
801074dd:	83 ec 0c             	sub    $0xc,%esp
801074e0:	68 e0 81 10 80       	push   $0x801081e0
801074e5:	e8 96 8e ff ff       	call   80100380 <panic>
801074ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074f0 <allocuvm>:
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	57                   	push   %edi
801074f4:	56                   	push   %esi
801074f5:	53                   	push   %ebx
801074f6:	83 ec 1c             	sub    $0x1c,%esp
801074f9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
801074fc:	85 f6                	test   %esi,%esi
801074fe:	0f 88 9a 00 00 00    	js     8010759e <allocuvm+0xae>
80107504:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107506:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107509:	0f 82 a1 00 00 00    	jb     801075b0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010750f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107512:	05 ff 0f 00 00       	add    $0xfff,%eax
80107517:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010751c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010751e:	39 f0                	cmp    %esi,%eax
80107520:	0f 83 8d 00 00 00    	jae    801075b3 <allocuvm+0xc3>
80107526:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107529:	eb 46                	jmp    80107571 <allocuvm+0x81>
8010752b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107530:	83 ec 04             	sub    $0x4,%esp
80107533:	68 00 10 00 00       	push   $0x1000
80107538:	6a 00                	push   $0x0
8010753a:	50                   	push   %eax
8010753b:	e8 20 d3 ff ff       	call   80104860 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107540:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107546:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
8010754d:	50                   	push   %eax
8010754e:	68 00 10 00 00       	push   $0x1000
80107553:	57                   	push   %edi
80107554:	ff 75 08             	push   0x8(%ebp)
80107557:	e8 34 fc ff ff       	call   80107190 <mappages>
8010755c:	83 c4 20             	add    $0x20,%esp
8010755f:	85 c0                	test   %eax,%eax
80107561:	78 5d                	js     801075c0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80107563:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107569:	39 f7                	cmp    %esi,%edi
8010756b:	0f 83 87 00 00 00    	jae    801075f8 <allocuvm+0x108>
    mem = kalloc();
80107571:	e8 ba b1 ff ff       	call   80102730 <kalloc>
80107576:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107578:	85 c0                	test   %eax,%eax
8010757a:	75 b4                	jne    80107530 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010757c:	83 ec 0c             	sub    $0xc,%esp
8010757f:	68 2c 7f 10 80       	push   $0x80107f2c
80107584:	e8 27 91 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107589:	83 c4 10             	add    $0x10,%esp
8010758c:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010758f:	74 0d                	je     8010759e <allocuvm+0xae>
80107591:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107594:	8b 45 08             	mov    0x8(%ebp),%eax
80107597:	89 f2                	mov    %esi,%edx
80107599:	e8 a2 fa ff ff       	call   80107040 <deallocuvm.part.0>
    return 0;
8010759e:	31 d2                	xor    %edx,%edx
}
801075a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075a3:	89 d0                	mov    %edx,%eax
801075a5:	5b                   	pop    %ebx
801075a6:	5e                   	pop    %esi
801075a7:	5f                   	pop    %edi
801075a8:	5d                   	pop    %ebp
801075a9:	c3                   	ret
801075aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return oldsz;
801075b0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801075b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075b6:	89 d0                	mov    %edx,%eax
801075b8:	5b                   	pop    %ebx
801075b9:	5e                   	pop    %esi
801075ba:	5f                   	pop    %edi
801075bb:	5d                   	pop    %ebp
801075bc:	c3                   	ret
801075bd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801075c0:	83 ec 0c             	sub    $0xc,%esp
801075c3:	68 44 7f 10 80       	push   $0x80107f44
801075c8:	e8 e3 90 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801075cd:	83 c4 10             	add    $0x10,%esp
801075d0:	3b 75 0c             	cmp    0xc(%ebp),%esi
801075d3:	74 0d                	je     801075e2 <allocuvm+0xf2>
801075d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075d8:	8b 45 08             	mov    0x8(%ebp),%eax
801075db:	89 f2                	mov    %esi,%edx
801075dd:	e8 5e fa ff ff       	call   80107040 <deallocuvm.part.0>
      kfree(mem);
801075e2:	83 ec 0c             	sub    $0xc,%esp
801075e5:	53                   	push   %ebx
801075e6:	e8 85 af ff ff       	call   80102570 <kfree>
      return 0;
801075eb:	83 c4 10             	add    $0x10,%esp
    return 0;
801075ee:	31 d2                	xor    %edx,%edx
801075f0:	eb ae                	jmp    801075a0 <allocuvm+0xb0>
801075f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
801075fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075fe:	5b                   	pop    %ebx
801075ff:	5e                   	pop    %esi
80107600:	89 d0                	mov    %edx,%eax
80107602:	5f                   	pop    %edi
80107603:	5d                   	pop    %ebp
80107604:	c3                   	ret
80107605:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010760c:	00 
8010760d:	8d 76 00             	lea    0x0(%esi),%esi

80107610 <deallocuvm>:
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	8b 55 0c             	mov    0xc(%ebp),%edx
80107616:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107619:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010761c:	39 d1                	cmp    %edx,%ecx
8010761e:	73 10                	jae    80107630 <deallocuvm+0x20>
}
80107620:	5d                   	pop    %ebp
80107621:	e9 1a fa ff ff       	jmp    80107040 <deallocuvm.part.0>
80107626:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010762d:	00 
8010762e:	66 90                	xchg   %ax,%ax
80107630:	89 d0                	mov    %edx,%eax
80107632:	5d                   	pop    %ebp
80107633:	c3                   	ret
80107634:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010763b:	00 
8010763c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107640 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	57                   	push   %edi
80107644:	56                   	push   %esi
80107645:	53                   	push   %ebx
80107646:	83 ec 0c             	sub    $0xc,%esp
80107649:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010764c:	85 f6                	test   %esi,%esi
8010764e:	74 59                	je     801076a9 <freevm+0x69>
  if(newsz >= oldsz)
80107650:	31 c9                	xor    %ecx,%ecx
80107652:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107657:	89 f0                	mov    %esi,%eax
80107659:	89 f3                	mov    %esi,%ebx
8010765b:	e8 e0 f9 ff ff       	call   80107040 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107660:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107666:	eb 0f                	jmp    80107677 <freevm+0x37>
80107668:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010766f:	00 
80107670:	83 c3 04             	add    $0x4,%ebx
80107673:	39 fb                	cmp    %edi,%ebx
80107675:	74 23                	je     8010769a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107677:	8b 03                	mov    (%ebx),%eax
80107679:	a8 01                	test   $0x1,%al
8010767b:	74 f3                	je     80107670 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010767d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107682:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107685:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107688:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010768d:	50                   	push   %eax
8010768e:	e8 dd ae ff ff       	call   80102570 <kfree>
80107693:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107696:	39 fb                	cmp    %edi,%ebx
80107698:	75 dd                	jne    80107677 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010769a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010769d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076a0:	5b                   	pop    %ebx
801076a1:	5e                   	pop    %esi
801076a2:	5f                   	pop    %edi
801076a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801076a4:	e9 c7 ae ff ff       	jmp    80102570 <kfree>
    panic("freevm: no pgdir");
801076a9:	83 ec 0c             	sub    $0xc,%esp
801076ac:	68 60 7f 10 80       	push   $0x80107f60
801076b1:	e8 ca 8c ff ff       	call   80100380 <panic>
801076b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801076bd:	00 
801076be:	66 90                	xchg   %ax,%ax

801076c0 <setupkvm>:
{
801076c0:	55                   	push   %ebp
801076c1:	89 e5                	mov    %esp,%ebp
801076c3:	56                   	push   %esi
801076c4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801076c5:	e8 66 b0 ff ff       	call   80102730 <kalloc>
801076ca:	85 c0                	test   %eax,%eax
801076cc:	74 5e                	je     8010772c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801076ce:	83 ec 04             	sub    $0x4,%esp
801076d1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076d3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801076d8:	68 00 10 00 00       	push   $0x1000
801076dd:	6a 00                	push   $0x0
801076df:	50                   	push   %eax
801076e0:	e8 7b d1 ff ff       	call   80104860 <memset>
801076e5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801076e8:	8b 53 04             	mov    0x4(%ebx),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801076eb:	83 ec 0c             	sub    $0xc,%esp
801076ee:	ff 73 0c             	push   0xc(%ebx)
801076f1:	52                   	push   %edx
801076f2:	8b 43 08             	mov    0x8(%ebx),%eax
801076f5:	29 d0                	sub    %edx,%eax
801076f7:	50                   	push   %eax
801076f8:	ff 33                	push   (%ebx)
801076fa:	56                   	push   %esi
801076fb:	e8 90 fa ff ff       	call   80107190 <mappages>
80107700:	83 c4 20             	add    $0x20,%esp
80107703:	85 c0                	test   %eax,%eax
80107705:	78 19                	js     80107720 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107707:	83 c3 10             	add    $0x10,%ebx
8010770a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107710:	75 d6                	jne    801076e8 <setupkvm+0x28>
}
80107712:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107715:	89 f0                	mov    %esi,%eax
80107717:	5b                   	pop    %ebx
80107718:	5e                   	pop    %esi
80107719:	5d                   	pop    %ebp
8010771a:	c3                   	ret
8010771b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107720:	83 ec 0c             	sub    $0xc,%esp
80107723:	56                   	push   %esi
80107724:	e8 17 ff ff ff       	call   80107640 <freevm>
      return 0;
80107729:	83 c4 10             	add    $0x10,%esp
}
8010772c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010772f:	31 f6                	xor    %esi,%esi
}
80107731:	89 f0                	mov    %esi,%eax
80107733:	5b                   	pop    %ebx
80107734:	5e                   	pop    %esi
80107735:	5d                   	pop    %ebp
80107736:	c3                   	ret
80107737:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010773e:	00 
8010773f:	90                   	nop

80107740 <kvmalloc>:
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107746:	e8 75 ff ff ff       	call   801076c0 <setupkvm>
8010774b:	a3 04 7f 11 80       	mov    %eax,0x80117f04
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107750:	05 00 00 00 80       	add    $0x80000000,%eax
80107755:	0f 22 d8             	mov    %eax,%cr3
}
80107758:	c9                   	leave
80107759:	c3                   	ret
8010775a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107760 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	83 ec 08             	sub    $0x8,%esp
80107766:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107769:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010776c:	89 c1                	mov    %eax,%ecx
8010776e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107771:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107774:	f6 c2 01             	test   $0x1,%dl
80107777:	75 17                	jne    80107790 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107779:	83 ec 0c             	sub    $0xc,%esp
8010777c:	68 71 7f 10 80       	push   $0x80107f71
80107781:	e8 fa 8b ff ff       	call   80100380 <panic>
80107786:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010778d:	00 
8010778e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107790:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107793:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107799:	25 fc 0f 00 00       	and    $0xffc,%eax
8010779e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801077a5:	85 c0                	test   %eax,%eax
801077a7:	74 d0                	je     80107779 <clearpteu+0x19>
  *pte &= ~PTE_U;
801077a9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801077ac:	c9                   	leave
801077ad:	c3                   	ret
801077ae:	66 90                	xchg   %ax,%ax

801077b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	57                   	push   %edi
801077b4:	56                   	push   %esi
801077b5:	53                   	push   %ebx
801077b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801077b9:	e8 02 ff ff ff       	call   801076c0 <setupkvm>
801077be:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077c1:	85 c0                	test   %eax,%eax
801077c3:	0f 84 e9 00 00 00    	je     801078b2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801077cc:	85 d2                	test   %edx,%edx
801077ce:	0f 84 b5 00 00 00    	je     80107889 <copyuvm+0xd9>
801077d4:	31 f6                	xor    %esi,%esi
801077d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801077dd:	00 
801077de:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
801077e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801077e3:	89 f0                	mov    %esi,%eax
801077e5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801077e8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801077eb:	a8 01                	test   $0x1,%al
801077ed:	75 11                	jne    80107800 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801077ef:	83 ec 0c             	sub    $0xc,%esp
801077f2:	68 7b 7f 10 80       	push   $0x80107f7b
801077f7:	e8 84 8b ff ff       	call   80100380 <panic>
801077fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107800:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107802:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107807:	c1 ea 0a             	shr    $0xa,%edx
8010780a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107810:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107817:	85 c0                	test   %eax,%eax
80107819:	74 d4                	je     801077ef <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010781b:	8b 38                	mov    (%eax),%edi
8010781d:	f7 c7 01 00 00 00    	test   $0x1,%edi
80107823:	0f 84 9b 00 00 00    	je     801078c4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107829:	89 fb                	mov    %edi,%ebx
    flags = PTE_FLAGS(*pte);
8010782b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80107831:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107834:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
8010783a:	e8 f1 ae ff ff       	call   80102730 <kalloc>
8010783f:	89 c7                	mov    %eax,%edi
80107841:	85 c0                	test   %eax,%eax
80107843:	74 5f                	je     801078a4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107845:	83 ec 04             	sub    $0x4,%esp
80107848:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
8010784e:	68 00 10 00 00       	push   $0x1000
80107853:	53                   	push   %ebx
80107854:	50                   	push   %eax
80107855:	e8 96 d0 ff ff       	call   801048f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010785a:	58                   	pop    %eax
8010785b:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107861:	ff 75 e4             	push   -0x1c(%ebp)
80107864:	50                   	push   %eax
80107865:	68 00 10 00 00       	push   $0x1000
8010786a:	56                   	push   %esi
8010786b:	ff 75 e0             	push   -0x20(%ebp)
8010786e:	e8 1d f9 ff ff       	call   80107190 <mappages>
80107873:	83 c4 20             	add    $0x20,%esp
80107876:	85 c0                	test   %eax,%eax
80107878:	78 1e                	js     80107898 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
8010787a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107880:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107883:	0f 82 57 ff ff ff    	jb     801077e0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107889:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010788c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010788f:	5b                   	pop    %ebx
80107890:	5e                   	pop    %esi
80107891:	5f                   	pop    %edi
80107892:	5d                   	pop    %ebp
80107893:	c3                   	ret
80107894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107898:	83 ec 0c             	sub    $0xc,%esp
8010789b:	57                   	push   %edi
8010789c:	e8 cf ac ff ff       	call   80102570 <kfree>
      goto bad;
801078a1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801078a4:	83 ec 0c             	sub    $0xc,%esp
801078a7:	ff 75 e0             	push   -0x20(%ebp)
801078aa:	e8 91 fd ff ff       	call   80107640 <freevm>
  return 0;
801078af:	83 c4 10             	add    $0x10,%esp
    return 0;
801078b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801078b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078bf:	5b                   	pop    %ebx
801078c0:	5e                   	pop    %esi
801078c1:	5f                   	pop    %edi
801078c2:	5d                   	pop    %ebp
801078c3:	c3                   	ret
      panic("copyuvm: page not present");
801078c4:	83 ec 0c             	sub    $0xc,%esp
801078c7:	68 95 7f 10 80       	push   $0x80107f95
801078cc:	e8 af 8a ff ff       	call   80100380 <panic>
801078d1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801078d8:	00 
801078d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801078e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801078e6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801078e9:	89 c1                	mov    %eax,%ecx
801078eb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801078ee:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801078f1:	f6 c2 01             	test   $0x1,%dl
801078f4:	0f 84 f8 00 00 00    	je     801079f2 <uva2ka.cold>
  return &pgtab[PTX(va)];
801078fa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078fd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107903:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107904:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107909:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107910:	89 d0                	mov    %edx,%eax
80107912:	f7 d2                	not    %edx
80107914:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107919:	05 00 00 00 80       	add    $0x80000000,%eax
8010791e:	83 e2 05             	and    $0x5,%edx
80107921:	ba 00 00 00 00       	mov    $0x0,%edx
80107926:	0f 45 c2             	cmovne %edx,%eax
}
80107929:	c3                   	ret
8010792a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107930 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107930:	55                   	push   %ebp
80107931:	89 e5                	mov    %esp,%ebp
80107933:	57                   	push   %edi
80107934:	56                   	push   %esi
80107935:	53                   	push   %ebx
80107936:	83 ec 0c             	sub    $0xc,%esp
80107939:	8b 75 14             	mov    0x14(%ebp),%esi
8010793c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010793f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107942:	85 f6                	test   %esi,%esi
80107944:	75 51                	jne    80107997 <copyout+0x67>
80107946:	e9 9d 00 00 00       	jmp    801079e8 <copyout+0xb8>
8010794b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107950:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107956:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010795c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107962:	74 74                	je     801079d8 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107964:	89 fb                	mov    %edi,%ebx
80107966:	29 c3                	sub    %eax,%ebx
80107968:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010796e:	39 f3                	cmp    %esi,%ebx
80107970:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107973:	29 f8                	sub    %edi,%eax
80107975:	83 ec 04             	sub    $0x4,%esp
80107978:	01 c1                	add    %eax,%ecx
8010797a:	53                   	push   %ebx
8010797b:	52                   	push   %edx
8010797c:	89 55 10             	mov    %edx,0x10(%ebp)
8010797f:	51                   	push   %ecx
80107980:	e8 6b cf ff ff       	call   801048f0 <memmove>
    len -= n;
    buf += n;
80107985:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107988:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010798e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107991:	01 da                	add    %ebx,%edx
  while(len > 0){
80107993:	29 de                	sub    %ebx,%esi
80107995:	74 51                	je     801079e8 <copyout+0xb8>
  if(*pde & PTE_P){
80107997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010799a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010799c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010799e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801079a1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801079a7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801079aa:	f6 c1 01             	test   $0x1,%cl
801079ad:	0f 84 46 00 00 00    	je     801079f9 <copyout.cold>
  return &pgtab[PTX(va)];
801079b3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079b5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801079bb:	c1 eb 0c             	shr    $0xc,%ebx
801079be:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801079c4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801079cb:	89 d9                	mov    %ebx,%ecx
801079cd:	f7 d1                	not    %ecx
801079cf:	83 e1 05             	and    $0x5,%ecx
801079d2:	0f 84 78 ff ff ff    	je     80107950 <copyout+0x20>
  }
  return 0;
}
801079d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079e0:	5b                   	pop    %ebx
801079e1:	5e                   	pop    %esi
801079e2:	5f                   	pop    %edi
801079e3:	5d                   	pop    %ebp
801079e4:	c3                   	ret
801079e5:	8d 76 00             	lea    0x0(%esi),%esi
801079e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079eb:	31 c0                	xor    %eax,%eax
}
801079ed:	5b                   	pop    %ebx
801079ee:	5e                   	pop    %esi
801079ef:	5f                   	pop    %edi
801079f0:	5d                   	pop    %ebp
801079f1:	c3                   	ret

801079f2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801079f2:	a1 00 00 00 00       	mov    0x0,%eax
801079f7:	0f 0b                	ud2

801079f9 <copyout.cold>:
801079f9:	a1 00 00 00 00       	mov    0x0,%eax
801079fe:	0f 0b                	ud2
