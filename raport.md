# Raport do zadania opt-randwalk

### Autor: Krzysztof Grynkiewicz
### Numer indeksu: 314736

Konfiguracja
---

Informacje o systemie:

 * Dystrybucja: Ubuntu 20.04
 * Jądro systemu: 5.4.0-33-generic
 * Kompilator: GCC 9.3.0
 * Procesor: i5-10210U
 * Liczba rdzeni: 4

Pamięć podręczna:

 * L1d: 32 KiB, 8-drożny (per rdzeń), rozmiar linii 64B
 * L2: 256 KiB, 4-drożny (per rdzeń), rozmiar linii 64B
 * L3: 6 MiB, 12-drożny (współdzielony), rozmiar linii 64B

Pamięć TLB:

 * L1d: 4KiB strony, 4-drożny, 64 wpisy
 * L2: 4KiB strony, 6-drożny, 1536 wpisów

Informacje o pamięciach podręcznych (oprócz TLB L2) uzyskano na podstawie wydruku programu
`papi_mem_info`.

Wyniki eksperymentów
---

Deasemblacja obu procedur:
```c=
0000000000000000 <randwalk0>:
   0:	f3 0f 1e fa          	endbr64 
   4:	41 57                	push   %r15
   6:	31 c0                	xor    %eax,%eax
   8:	41 89 f7             	mov    %esi,%r15d
   b:	31 c9                	xor    %ecx,%ecx
   d:	41 56                	push   %r14
   f:	49 89 fe             	mov    %rdi,%r14
  12:	8d 7e ff             	lea    -0x1(%rsi),%edi
  15:	41 55                	push   %r13
  17:	45 31 ed             	xor    %r13d,%r13d
  1a:	41 54                	push   %r12
  1c:	41 89 d4             	mov    %edx,%r12d
  1f:	55                   	push   %rbp
  20:	89 f5                	mov    %esi,%ebp
  22:	53                   	push   %rbx
  23:	c1 ed 1f             	shr    $0x1f,%ebp
  26:	01 f5                	add    %esi,%ebp
  28:	d1 fd                	sar    %ebp
  2a:	48 83 ec 18          	sub    $0x18,%rsp
  2e:	89 eb                	mov    %ebp,%ebx
  30:	89 7c 24 0c          	mov    %edi,0xc(%rsp)
  34:	eb 1a                	jmp    50 <randwalk0+0x50>    # skok na początek pętli
  36:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  3d:	00 00 00 
  40:	31 f6                	xor    %esi,%esi
  42:	85 ed                	test   %ebp,%ebp
  44:	40 0f 9f c6          	setg   %sil
  48:	29 f5                	sub    %esi,%ebp
  4a:	41 83 ec 01          	sub    $0x1,%r12d             # while (--len);
  4e:	74 44                	je     94 <randwalk0+0x94>    # wyjście z pętli
  50:	83 e9 02             	sub    $0x2,%ecx              # początek pętli
  53:	78 5b                	js     b0 <randwalk0+0xb0>    # if (k < 0)
  55:	41 89 e8             	mov    %ebp,%r8d
  58:	49 89 c1             	mov    %rax,%r9
  5b:	45 0f af c7          	imul   %r15d,%r8d
  5f:	49 d3 e9             	shr    %cl,%r9
  62:	41 01 d8             	add    %ebx,%r8d
  65:	4d 63 c0             	movslq %r8d,%r8
  68:	43 0f b6 34 06       	movzbl (%r14,%r8,1),%esi      # sum += arr[i * n + j];
  6d:	41 01 f5             	add    %esi,%r13d
  70:	41 83 e1 03          	and    $0x3,%r9d              # int d = (dir >> k) & 3;

  74:	74 ca                	je     40 <randwalk0+0x40>    # if (d == 0)
  76:	41 83 f9 01          	cmp    $0x1,%r9d
  7a:	74 44                	je     c0 <randwalk0+0xc0>    # else if (d == 1)
  7c:	41 83 f9 02          	cmp    $0x2,%r9d
  80:	74 56                	je     d8 <randwalk0+0xd8>    # else if (d == 2)
  82:	31 f6                	xor    %esi,%esi
  84:	39 5c 24 0c          	cmp    %ebx,0xc(%rsp)
  88:	40 0f 9f c6          	setg   %sil
  8c:	01 f3                	add    %esi,%ebx
  8e:	41 83 ec 01          	sub    $0x1,%r12d
  92:	75 bc                	jne    50 <randwalk0+0x50>    # skok na początek pętli
  94:	48 83 c4 18          	add    $0x18,%rsp             # koniec pętli
  98:	44 89 e8             	mov    %r13d,%eax
  9b:	5b                   	pop    %rbx
  9c:	5d                   	pop    %rbp
  9d:	41 5c                	pop    %r12
  9f:	41 5d                	pop    %r13
  a1:	41 5e                	pop    %r14
  a3:	41 5f                	pop    %r15
  a5:	c3                   	retq                          # wyjście
  a6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  ad:	00 00 00 
  b0:	31 c0                	xor    %eax,%eax
  b2:	e8 00 00 00 00       	callq  b7 <randwalk0+0xb7>    # dir = fast_random();
  b7:	b9 3e 00 00 00       	mov    $0x3e,%ecx             # k = 62;
  bc:	eb 97                	jmp    55 <randwalk0+0x55>
  be:	66 90                	xchg   %ax,%ax
  c0:	31 f6                	xor    %esi,%esi
  c2:	39 6c 24 0c          	cmp    %ebp,0xc(%rsp)
  c6:	40 0f 9f c6          	setg   %sil
  ca:	01 f5                	add    %esi,%ebp
  cc:	e9 79 ff ff ff       	jmpq   4a <randwalk0+0x4a>
  d1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  d8:	31 f6                	xor    %esi,%esi
  da:	85 db                	test   %ebx,%ebx
  dc:	40 0f 9f c6          	setg   %sil
  e0:	29 f3                	sub    %esi,%ebx
  e2:	e9 63 ff ff ff       	jmpq   4a <randwalk0+0x4a>
  e7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  ee:	00 00 
```
```c=
00000000000000f0 <randwalk1>:
  f0:	f3 0f 1e fa          	endbr64 
  f4:	41 57                	push   %r15
  f6:	31 c0                	xor    %eax,%eax
  f8:	41 89 f7             	mov    %esi,%r15d
  fb:	31 c9                	xor    %ecx,%ecx
  fd:	41 56                	push   %r14
  ff:	49 89 fe             	mov    %rdi,%r14
 102:	41 55                	push   %r13
 104:	45 31 ed             	xor    %r13d,%r13d
 107:	41 54                	push   %r12
 109:	41 89 d4             	mov    %edx,%r12d
 10c:	8d 56 ff             	lea    -0x1(%rsi),%edx
 10f:	55                   	push   %rbp
 110:	53                   	push   %rbx
 111:	89 f3                	mov    %esi,%ebx
 113:	c1 eb 1f             	shr    $0x1f,%ebx
 116:	01 f3                	add    %esi,%ebx
 118:	d1 fb                	sar    %ebx
 11a:	48 83 ec 18          	sub    $0x18,%rsp
 11e:	89 dd                	mov    %ebx,%ebp
 120:	eb 7e                	jmp    1a0 <randwalk1+0xb0>    # skok na początek pętli
 122:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 128:	41 89 d9             	mov    %ebx,%r9d               # int d = (dir >> k) & 3;
 12b:	49 89 c0             	mov    %rax,%r8
 12e:	45 0f af cf          	imul   %r15d,%r9d
 132:	49 d3 e8             	shr    %cl,%r8
 135:	41 83 e0 03          	and    $0x3,%r8d
 139:	41 01 e9             	add    %ebp,%r9d
 13c:	4d 63 c9             	movslq %r9d,%r9
 13f:	43 0f b6 34 0e       	movzbl (%r14,%r9,1),%esi       # sum += arr[i * n + j];
 144:	41 01 f5             	add    %esi,%r13d
 147:	39 d3                	cmp    %edx,%ebx               # int i3 = (i < n-1)
 149:	40 0f 9c c6          	setl   %sil
 14d:	31 ff                	xor    %edi,%edi
 14f:	41 83 f8 01          	cmp    $0x1,%r8d               # (d == 1)
 153:	40 0f 94 c7          	sete   %dil
 157:	21 fe                	and    %edi,%esi
 159:	39 d5                	cmp    %edx,%ebp               # int j3 = (j < n-1)
 15b:	40 0f 9c c7          	setl   %dil
 15f:	45 31 c9             	xor    %r9d,%r9d
 162:	41 83 f8 03          	cmp    $0x3,%r8d               # (d == 3)
 166:	41 0f 94 c1          	sete   %r9b
 16a:	41 21 f9             	and    %edi,%r9d
 16d:	85 db                	test   %ebx,%ebx               # int i2 = (i > 0)
 16f:	41 0f 9f c2          	setg   %r10b
 173:	31 ff                	xor    %edi,%edi
 175:	45 85 c0             	test   %r8d,%r8d               # (d == 0)
 178:	40 0f 94 c7          	sete   %dil
 17c:	44 21 d7             	and    %r10d,%edi
 17f:	29 fb                	sub    %edi,%ebx               # i = i - i2
 181:	01 f3                	add    %esi,%ebx               #            + i3;
 183:	85 ed                	test   %ebp,%ebp               # int j2 = (j > 0)
 185:	40 0f 9f c7          	setg   %dil
 189:	31 f6                	xor    %esi,%esi
 18b:	41 83 f8 02          	cmp    $0x2,%r8d               # (d == 2)
 18f:	40 0f 94 c6          	sete   %sil
 193:	21 fe                	and    %edi,%esi
 195:	29 f5                	sub    %esi,%ebp               # j = j - j2
 197:	44 01 cd             	add    %r9d,%ebp               #            + j3;
 19a:	41 83 ec 01          	sub    $0x1,%r12d
 19e:	74 20                	je     1c0 <randwalk1+0xd0>    # wyjście z pętli
 1a0:	83 e9 02             	sub    $0x2,%ecx               # początek pętli
 1a3:	79 83                	jns    128 <randwalk1+0x38>    # if (k < 0)
 1a5:	31 c0                	xor    %eax,%eax
 1a7:	89 54 24 0c          	mov    %edx,0xc(%rsp)
 1ab:	e8 00 00 00 00       	callq  1b0 <randwalk1+0xc0>    # dir = fast_random();
 1b0:	8b 54 24 0c          	mov    0xc(%rsp),%edx
 1b4:	b9 3e 00 00 00       	mov    $0x3e,%ecx              # k = 62;
 1b9:	e9 6a ff ff ff       	jmpq   128 <randwalk1+0x38>    # skok do dalszej części pętli
 1be:	66 90                	xchg   %ax,%ax
 1c0:	48 83 c4 18          	add    $0x18,%rsp              # koniec pętli
 1c4:	44 89 e8             	mov    %r13d,%eax
 1c7:	5b                   	pop    %rbx
 1c8:	5d                   	pop    %rbp
 1c9:	41 5c                	pop    %r12
 1cb:	41 5d                	pop    %r13
 1cd:	41 5e                	pop    %r14
 1cf:	41 5f                	pop    %r15
 1d1:	c3                   	retq   
```
```c=32
# Instrukcje, które uległy zmianie przez zamianę kolejności
 147:	39 d3                	cmp    %edx,%ebx        # int i3 = (i < n-1)
 149:	40 0f 9c c7          	setl   %dil
 14d:	31 f6                	xor    %esi,%esi
 14f:	41 83 f8 01          	cmp    $0x1,%r8d        # (d == 1)
 153:	40 0f 94 c6          	sete   %sil
 157:	21 fe                	and    %edi,%esi
 159:	85 db                	test   %ebx,%ebx        # int i2 = (i > 0)
 15b:	41 0f 9f c1          	setg   %r9b
 15f:	31 ff                	xor    %edi,%edi
 161:	45 85 c0             	test   %r8d,%r8d        # (d == 0)
 164:	40 0f 94 c7          	sete   %dil
 168:	44 21 cf             	and    %r9d,%edi
 16b:	29 fb                	sub    %edi,%ebx        # i = i - i2
 16d:	01 f3                	add    %esi,%ebx        #            + i3;
 16f:	39 d5                	cmp    %edx,%ebp        # int j3 = (j < n-1)
 171:	40 0f 9c c6          	setl   %sil
 175:	45 31 c9             	xor    %r9d,%r9d
 178:	41 83 f8 03          	cmp    $0x3,%r8d        # (d == 3)
 17c:	41 0f 94 c1          	sete   %r9b
 180:	41 21 f1             	and    %esi,%r9d
 183:	85 ed                	test   %ebp,%ebp        # int j2 = (j > 0)
 185:	40 0f 9f c7          	setg   %dil
 189:	31 f6                	xor    %esi,%esi
 18b:	41 83 f8 02          	cmp    $0x2,%r8d        # (d == 2)
 18f:	40 0f 94 c6          	sete   %sil
 193:	21 fe                	and    %edi,%esi
 195:	29 f5                	sub    %esi,%ebp        # j = j - j2
 197:	44 01 cd             	add    %r9d,%ebp        #            + j3;
```
```c=75
// randwalk.c randwalk1
    int i2 = (i > 0) & (d == 0);
    int i3 = (i < n-1) & (d == 1);
        
    int j2 = (j > 0) & (d == 2);
    int j3 = (j < n-1) & (d == 3);
    
    i = i - i2 + i3;
    j = j - j2 + j3;
```
```c=75
// randwalk.c randwalk1 (optimized)
    int i2 = (i > 0) & (d == 0);
    int i3 = (i < n-1) & (d == 1);
    
    i = i - i2 + i3;
        
    int j2 = (j > 0) & (d == 2);
    int j3 = (j < n-1) & (d == 3);
    
    j = j - j2 + j3;
```
![](https://i.imgur.com/xmBS52i.png)

![](https://i.imgur.com/L1KMK7i.png)


...

Wnioski
---

* *Ile instrukcji maszynowych ma ciało pętli przed i po optymalizacji?*
  Ciało pętli przed optymalizacją to instrukcje o adresach `0x40` - `0x92` oraz `0xb0` - `0xe2`, czyli $29+16=45$ instrukcji, a po optymalizacji `0x128` - `0x1b9`, czyli $47$ instrukcji.
* *Ile spośród nich to instrukcje warunkowe?*
  Przed optymalizacją pętla ma $6$ instrukcji skoku warunkowego, $4$ instrukcje skoku bezwarunkowego i $4$ instrukcje `set`, a po optymalizacji $2$ instrukcje skoku warunkowego, $2$ instrukcje skoku bezwarunkowego i $8$ instrukcji `set`.
* *Jak optymalizacja wpłynęła na IPC?*
  Jak widać na wykresie, dzięki optymalizacji współczynnik IPC znacznie wzrósł i wynosi około $3$ cykle, nieznacznie spadając wraz ze wzrostem rozmiaru tablicy. 
* *Jak na IPC wpływa zmiana kolejności instrukcji w ciele pętli?*
  Dzięki obliczaniu wartości $i$ tuż po obliczaniu warunków, `gcc` zamienia miejscami linie `int i2 = (i > 0) & (d == 0);` i `int j3 = (j < n-1) & (d == 3);`, co pozwala zwiększyć IPC do nawet $3,5$.
* *Czy rozmiar tablicy ma duży wpływ na działanie programu?*
  Jak widać na wykresie, rozmiar tablicy praktycznie nie wpływa na czas wykonania programu.