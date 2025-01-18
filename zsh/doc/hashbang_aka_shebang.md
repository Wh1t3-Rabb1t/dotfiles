# Hashbang aka Shebang

Notes from stack overflow:

---

It's a convention so the *nix shell knows what kind of interpreter to run.

For example, older flavors of ATT defaulted to sh (the Bourne shell), while older versions of BSD defaulted to csh (the C shell).

Even today (where most systems run bash, the "Bourne Again Shell"), scripts can be in bash, python, perl, ruby, PHP, etc, etc. For example, you might see `#!/bin/perl` or `#!/bin/perl5`.

---

The shebang is not a shell convention, it is interpreted by the kernel when handling the `execve(2)` syscall; so the shebang is a kernel convention, not a shell one.

---

I think it's worth noting that this is only executed if you run your script as an executable. So if you set the executable flag and then type ./yourscript.extension, for example, ./helloworld.py or ./helloworld.sh, it will look for the interpreter at that top line, which would be `#!/bin/python` or `!#/bin/bash`, whereas when executing the script like python helloworld.py, the first line will not be observed because it is commented out. So it is a special sequence for the shell/kernel.
