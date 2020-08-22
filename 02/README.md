This crackme
============
Here is a link to this crackme.

https://crackmes.one/crackme/5e74a49833c5d4439bb2def5

https://www.virustotal.com/gui/file/ec7fd2595ee6f582f37e82c718da16c93d2d8c94d91ed70b3ab68a795e2a701f/detection

Goal:  
Get a shell? guess it has a loop that calls os.system()

Description:
```
Description

Welcome to my little crackme! Your goal is to get a shell!
As usual patching is not allowed. 
ld_preload, dll injection and rootkits are not allowed too. 
I hope the crackme is not overrated or underated. Have fun!
```





What to do
==========
looks like the important bit is right here after the stack canary thing setup.

want to get this value at `[0x55db9434a07c]` to == `0xe9a`.
maybe has something to do with the strcmp.
Maybe need to see if my 256 bytes of fgets buffer can overwrite something useful.

```
│           0x55db943471ad      4881ec300100.  sub rsp, 0x130
│           0x55db943471b4      64488b042528.  mov rax, qword fs:[0x28]
│           0x55db943471bd      488945f8       mov qword [var_8h], rax
│           0x55db943471c1      31c0           xor eax, eax
│           0x55db943471c3      488d05b22e00.  lea rax, [0x55db9434a07c]
│           0x55db943471ca      488985d8feff.  mov qword [var_128h], rax
│           0x55db943471d1      488b95d8feff.  mov rdx, qword [var_128h]
│           0x55db943471d8      488d85e0feff.  lea rax, [var_120h]
│           0x55db943471df      4889d6         mov rsi, rdx
│           0x55db943471e2      4889c7         mov rdi, rax
│           0x55db943471e5      e846feffff     call sym.imp.strcpy     ;[1] ; char *strcpy(char *dest, const char *src)
│           0x55db943471ea      488d3d170e00.  lea rdi, str.Welcome_to_the_admin_panel__The_program_which_admins_can__interact_with_on_a_guest_computer_to_do_admin_stuff    ; 0x55db94348008 ; "Welcome to the admin
│           0x55db943471f1      e84afeffff     call sym.imp.puts       ;[2] ; int puts(const char *s)
│           ; CODE XREF from main @ 0x55db943472e3
│           ;-- rip:
│           0x55db943471f6      8b05802e0000   mov eax, dword [0x55db9434a07c]    ; [0x55db9434a07c:4]=0
│           0x55db943471fc      3d9a0e0000     cmp eax, 0xe9a          ; 3738
│
```

