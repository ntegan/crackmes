This crackme
============
Here is a link to this crackme.
I also have the binary (`keygenme`) here in this repo.

Running the program prompts the user for a name and a key.
Enter the correct key for your name.

```
ntegan@otp9010 ~/cmes/02_key_keygen % ./keygen nick
Successfully generated key/password!
Username:       nick
Password:       iUG>72.*(
```

https://crackmes.one/crackme/5d17962b33c5d41c6d56e1f2


For the reader
==============
NOTE: I accidentally deleted my source `keygen.c` and am too lazy
to reboot my computer with the disk unmounted to try using `extundelete`, 
woops. (See the next section).

Everything after this section is my scratch from solving the crackme
using `radare2`. Probably won't make any sense to you and I probably wouldn't
understand it if I read through it again.

I created a keygen program.
It can be compiled with `gcc keygen.c -o keygen` or it is compiled as a side
effect of running my `test.sh` script.

The `test.sh` script takes 1 argument (a username) and tests the password
generated from my keygen by running the `keygenme` program.

Example usage:
```
ntegan@otp9010 ~/cmes/02_key_keygen % bash ./test.sh nick
Trying keygenme program with user:pass = nick:iUG>72.*(


Program output:
Enter name: Enter key: Good job!
Now write keygen)
```

It is equivalent(probably) to doing the following:
```
ntegan@otp9010 ~/cmes/02_key_keygen % gcc keygen.c -o keygen
ntegan@otp9010 ~/cmes/02_key_keygen % ./keygen nick
Successfully generated key/password!
Username:       nick
Password:       iUG>72.*(
ntegan@otp9010 ~/cmes/02_key_keygen % ./keygenme
Enter name: nick
Enter key: iUG>72.*(
Good job!
Now write keygen)
```


Hashes of files in this repo
============================
```
ntegan@otp9010 ~/cmes/02_key_keygen % ls
README.md  keygen  keygenme  test.sh
ntegan@otp9010 ~/cmes/02_key_keygen % sha256sum *
2c272f71aabbbba83921a7b44ebc044e200242372de48fac3ce438721b09eada  keygen
ce8f238c9640ef835813d89d1573b06629d926f24e2c45e920fcd81a338f498f  keygenme
6679bf594017a998f1688ca3609c1fb11db6f3f87da25be78b16215866c217d1  test.sh
```

oh my, I just deleted my keygen.c
```
ntegan@otp9010 ~/cmes/02_key_keygen % ls
README.md  keygen  keygen.c  keygenme  test.sh
ntegan@otp9010 ~/cmes/02_key_keygen % rm keygen.c
ntegan@otp9010 ~/cmes/02_key_keygen % ls
README.md  keygen  keygenme  test.sh
ntegan@otp9010 ~/cmes/02_key_keygen % sha256sum *
2c272f71aabbbba83921a7b44ebc044e200242372de48fac3ce438721b09eada  keygen
ce8f238c9640ef835813d89d1573b06629d926f24e2c45e920fcd81a338f498f  keygenme
c8b036a714a570c1550a891860af22544d58b506679be4ef4b038138f8a66cf5  README.md
6679bf594017a998f1688ca3609c1fb11db6f3f87da25be78b16215866c217d1  test.sh
ntegan@otp9010 ~/cmes/02_key_keygen % vim README.md
ntegan@otp9010 ~/cmes/02_key_keygen %
ntegan@otp9010 ~/cmes/02_key_keygen % ls                                                                                                                                                                         
README.md  keygen  keygenme  test.sh
ntegan@otp9010 ~/cmes/02_key_keygen % sha256sum *
2c272f71aabbbba83921a7b44ebc044e200242372de48fac3ce438721b09eada  keygen
ce8f238c9640ef835813d89d1573b06629d926f24e2c45e920fcd81a338f498f  keygenme
065d07e2d9cfc96bda33fbdf553104b89aaef2d4c954dc754a74e23b00e22818  README.md
6679bf594017a998f1688ca3609c1fb11db6f3f87da25be78b16215866c217d1  test.sh
ntegan@otp9010 ~/cmes/02_key_keygen % vim README.md
ntegan@otp9010 ~/cmes/02_key_keygen % ls
README.md  keygen  keygenme  test.sh
ntegan@otp9010 ~/cmes/02_key_keygen %


```


Virustotals if you don't like binaries
======================================
my keygen  
https://www.virustotal.com/gui/file/2c272f71aabbbba83921a7b44ebc044e200242372de48fac3ce438721b09eada/detection

the keygenme program  
https://www.virustotal.com/gui/file/ce8f238c9640ef835813d89d1573b06629d926f24e2c45e920fcd81a338f498f/detection




Studying Control flow
=====================
rdx->rsi holds ptr to malloc'd 10 bytes
rax->rdi holds ptr to usernmae

sym.encr(int64_t arg1  rdi , int64_t arg2  rsi )

first loop thing gets rbx to be length of username.
rbx == rax then continue

next loop does something 8ish times jle 8
also uses strlen of username
looks like this loop calculates something and puts it in [rdx] (malloc mem)
right before it returns
:> x 12 @ rdx
- offset -       0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
- 0x560caed8ca80  6955 473e 3732 2e2a 2800 0000            iUG>72.*(...

for username "nick"

right after call to sym.encr
reloads malloc ptr in rdx,
password ptr to rax,
rdx to rsi,
rax to rdi,
then compares and does the thing.


Next steps
==========
Now decide how want to do the keygen.
First, going back to the first loop and see
if it modifies anything in malloc'd bytes



Looking at first loop again
===========================
Username and malloc'd bytes before get into loop

```
:> x 8 @ [rbp - 0x28]
- offset -       0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
0x7ffd33661b80  6e69 636b 0000 0000                      nick....
:> x 8 @ [rbp - 0x30]
- offset -       0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
0x55c543522a80  0000 0000 0000 0000                      ........
```


rbp - 0x1c is a dword, data
rbp - 0x18 is a dword, counter

```
			;-- rip:
	┌─< 0x5639b8f691c8      eb1a           jmp 0x5639b8f691e4
 ┌──> 0x5639b8f691ca b    8b45e8         mov eax, dword [rbp - 0x18]						mov counter dword to eax
 ╎│   0x5639b8f691cd      4863d0         movsxd rdx, eax												mov counter dword to qword with sign extension
 ╎│   0x5639b8f691d0      488b45d8       mov rax, qword [rbp - 0x28]						mv username ptr to rax
 ╎│   0x5639b8f691d4      4801d0         add rax, rdx														add counter to rax (username ptr)
 ╎│   0x5639b8f691d7      0fb600         movzx eax, byte [rax]									mov current byte with zero extend to dword
 ╎│   0x5639b8f691da      0fbec0         movsx eax, al													mov lowest byte of the byte with sign extend(signextend does nothing?) to itself
 ╎│   0x5639b8f691dd      0145e4         add dword [rbp - 0x1c], eax						add the byte to the data dword
 ╎│   0x5639b8f691e0      8345e801       add dword [rbp - 0x18], 1							increment the data dword
 ╎└─> 0x5639b8f691e4      8b45e8         mov eax, dword [rbp - 0x18]						mov counter dword to eax												<-------------	 start here
 ╎    0x5639b8f691e7      4863d8         movsxd rbx, eax												mov counter dword to qword with sign extension
 ╎    0x5639b8f691ea      488b45d8       mov rax, qword [rbp - 0x28]						mv username ptr to rax
 ╎    0x5639b8f691ee      4889c7         mov rdi, rax														mv username ptr to rdi
 ╎    0x5639b8f691f1      e85afeffff     call sym.imp.strlen     ;[1]						get strlen of username
 ╎    0x5639b8f691f6      4839c3         cmp rbx, rax														compare counter with strlen of username
 └──< 0x5639b8f691f9      72cf           jb 0x5639b8f691ca											if counter less than strlen then loop
			0x5639b8f691fb b    c645e300       mov byte [rbp - 0x1d], 0
```

ok so this loop adds the bytes of username into a dword

result for my user is 
```
:> x 4 @ rbp - 0x1c
- offset -       0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
0x7fffccabe674  a501 0000                                ....

:> ? 'n' + 'i' + 'c' + 'k'
int32   421
uint32  421
hex     0x1a5
```



Looking at second loop again
============================
does something 9 times

rbp - 0x1d is the byte right before dword calculated above (malloced data)
```
      ;-- rip:
      0x5639b8f691fb b    c645e300       mov byte [rbp - 0x1d], 0
      0x5639b8f691ff      c745ec000000.  mov dword [rbp - 0x14], 0
  ┌─< 0x5639b8f69206      eb50           jmp 0x5639b8f69258
 ┌──> 0x5639b8f69208      8b45e4         mov eax, dword [rbp - 0x1c]            Load the data dword into eax
 ╎│   0x5639b8f6920b      4863d8         movsxd rbx, eax                        load it into rbx with sign extend
 ╎│   0x5639b8f6920e      488b45d8       mov rax, qword [rbp - 0x28]            
 ╎│   0x5639b8f69212      4889c7         mov rdi, rax                           get strlen of username
 ╎│   0x5639b8f69215      e836feffff     call sym.imp.strlen     ;[1]
 ╎│   0x5639b8f6921a      4889c2         mov rdx, rax                           put strlen in rdx
 ╎│   0x5639b8f6921d      8b45ec         mov eax, dword [rbp - 0x14]            
 ╎│   0x5639b8f69220      4898           cdqe                                   convert dword to cword sign extend
 ╎│   0x5639b8f69222      488d0c02       lea rcx, [rdx + rax]                   ?? Add strlen(rdx) to data2(rbp-0x14) => store in rcx
 ╎│   0x5639b8f69226      4889d8         mov rax, rbx                           load data1 into rax
 ╎│   0x5639b8f69229      ba00000000     mov edx, 0                             clear out edx
 ╎│   0x5639b8f6922e      48f7f1         div rcx                                divide something?(data1) by rcx => quotient rax, remainder rdx
 ╎│   0x5639b8f69231      8845e3         mov byte [rbp - 0x1d], al              mov the low byte from division into the databyte
 ╎│   0x5639b8f69234      0fbe75e3       movsx esi, byte [rbp - 0x1d]           mov the byte (w/ sign extend) to esi
 ╎│   0x5639b8f69238      8b45e4         mov eax, dword [rbp - 0x1c]            load data1dword to eax
 ╎│   0x5639b8f6923b      99             cdq                                    eax sign extend to edx:eax.   produce qword dividend from a dword b4 dword division
 ╎│   0x5639b8f6923c      f7fe           idiv esi                               signed divide edx:eax by esi(the databyte). quotient eax, remainder edx
 ╎│   0x5639b8f6923e      0145e4         add dword [rbp - 0x1c], eax            add quotient to data1 dword
 ╎│   0x5639b8f69241      8b45ec         mov eax, dword [rbp - 0x14]            mov data2 into eax
 ╎│   0x5639b8f69244      4863d0         movsxd rdx, eax                        load into rdx with sign extend
 ╎│   0x5639b8f69247      488b45d0       mov rax, qword [rbp - 0x30]            mov malloc'd qword PTR into rax
 ╎│   0x5639b8f6924b      4801c2         add rdx, rax                           add malloc'd qword PTR to data2 (rdx) 
 ╎│   0x5639b8f6924e      0fb645e3       movzx eax, byte [rbp - 0x1d]           mov databytebyte with zero extend into eax
 ╎│   0x5639b8f69252      8802           mov byte [rdx], al                     mov the databyte to [malloc ptr + data2]
 ╎│   0x5639b8f69254      8345ec01       add dword [rbp - 0x14], 1              increment data2 (JUST A COUNTER)
 ╎└─> 0x5639b8f69258      837dec08       cmp dword [rbp - 0x14], 8              if counter less than=8, continue (do 9 times)       <----------------- start here
 └──< 0x5639b8f6925c      7eaa           jle 0x5639b8f69208
      0x5639b8f6925e      90             nop
      0x5639b8f6925f      4883c428       add rsp, 0x28
      0x5639b8f69263      5b             pop rbx
      0x5639b8f69264      5d             pop rbp
      0x5639b8f69265      c3             ret
 
```
 


Pseudocode for loop 1
=====================
add bytes of username into a dword



Pseudocode for loop 2
=====================
Do something 9 times (malloc bufer is 10 bytes)

ROUGH PSEUDOCODE BELOW

datadword is stageone.
get strlen of username.
add strlen to counter store in rcx.
load stage1 to rax.
divide stageone by (strlen + counter).
move quotient low byte into databyte.
mov byte (sign extend) to esi.

move stageone to eax.
divide stageone eax by databyte (esi).
add quotient to (acutal stage one in memory).
mov databyte to current pos in mallocedkey.



Conclusion
==========
It appears to fail in some cases.

e.g.
```
bash ./test.sh aa
bash ./test.sh f
```

Works for a good amount of them though, so i'm done.
