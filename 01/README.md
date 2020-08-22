This crackme
============
Here is a link to this crackme.
It is made by the same user as the previous one I did.

https://crackmes.one/crackme/5d1a37a233c5d410dc4d0c3f

Hash  
```
ntegan@otp9010 ~/cmes/gitrepo/01 (git)-[master] % sha256sum CNM 
397392e8d5ebadfed94df8541c92b02bbb1acb6e449b05db784637bf6fc812fd  CNM
```

Virustotal  
https://www.virustotal.com/gui/file/397392e8d5ebadfed94df8541c92b02bbb1acb6e449b05db784637bf6fc812fd/detection










Initial Inspection
==================

lol  
```
ntegan@otp9010 ~/cmes/gitrepo/01 (git)-[master] % r2 -d CNM 
 -- Warning, your trial license is about to expire.
 [0x7f65babdd090]> 
```

Looks like a bunch of string compares and then it opens the 7z archive
that the file came in?


Looks like the first one is "./CNM".
rdx and rax are 2 registers being strcmp'd.
```
:> x 8 @ rdx
- offset -       0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
0x7ffd69ba11aa  2e2f 434e 4d00 4c45                      ./CNM.LE
:> x 8 @ rax
- offset -       0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
0x7ffd69b9f8c0  6e69 636b 0000 0000                      nick....
```

Next one is a number: 1
Next one is a number: 7
Next one is a number: 8
Next one is a number: 5


Got it to say "good key!" and it excreted a `CNP.7z` 
(the `CNM` executable came from `CNM.7z`).



