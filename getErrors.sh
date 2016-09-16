#!/bin/bash

mkdir reports -p

for i in $(ls $1 | grep sh); do
  echo 'We recently found an invalid memory access parsing and executing fuzzed bash code in Busybox 1.25.0.' > reports/rep.$i
  echo "We tested this issue on Ubuntu 14.04.5 (x86_64) but other configurations could be affected. Please find attached the full .config file" >> reports/rep.$i
  echo "Technical details about the issue are:" >> reports/rep.$i
  echo "" >> reports/rep.$i
  ./busybox_unstripped sh $1/$i 2>&1 >/dev/null | grep -A1 AddressSanitizer >> reports/rep.$i
  echo "" >> reports/rep.$i
  echo "gdb backtrace is as follows:" >> reports/rep.$i
  echo "" >> reports/rep.$i
  env -i ASAN_OPTIONS='abort_on_error=1' gdb -batch -ex 'tty /dev/null' -ex run -ex 'bt 25' --args ./busybox_unstripped sh $1/$i 2> /dev/null >> reports/rep.$i
  echo "" >> reports/rep.$i
  echo "This issue was found using QuickFuzz, the file to reproduce it is attached." >> reports/rep.$i
  echo "Regards." >> reports/rep.$i
done
