test_all () {
  verbose_file=`mktemp -t test_all.XXXX`

  test_count=0
  success_count=0
  failure_count=0
  error_count=0
  for test_file in $(find testcases -name "*.cmm")  # $test_file is like testcases/foo.html
  do
    test_base=${test_file%.cmm}                  # like testcases/foo
    test_name=${test_file##*/}                    # like foo
    expected_file=${test_base}.out                # like testcases/foo.txt
    expected_errors_file=${test_base}.error_lines # like testcases/foo.error_lines

    let test_count++    # for stdout test of this test case
    if [ ! -f ${expected_file} ]; then
      echo -en "\033[33mE\033[0m"

      let error_count++
      space_out_verbose_file
      echo -e "\033[33mERROR ${error_count}:\033[0m ${test_name}" >> $verbose_file
      echo "    The expected output file, \"${expected_file}\" does not exist." >> $verbose_file
      continue
    fi
    test_stdout

    let test_count++    # for error lines test of this test case
    if [ ! -f ${expected_errors_file} ]; then
      echo -en "\033[33mE\033[0m"

      let error_count++
      space_out_verbose_file
      echo -e "\033[33mERROR ${error_count}:\033[0m ${test_name}" >> $verbose_file
      echo "    The expected error lines file, \"${expected_errors_file}\" does not exist." >> $verbose_file
      continue
    fi
    test_error_lines
  done

  echo ""; echo ""

  print_summary

  if [ ! -z $verbose_file ]; then
    echo ""; echo ""
    cat $verbose_file
  fi
  rm "${verbose_file}"
}

print_summary () {
  echo -e "\033[1m${test_count}\033[0m Tests. \033[32m${success_count} Successes.\033[0m \033[31m${failure_count} Failures.\033[0m \033[33m${error_count} Errors.\033[0m"
}

test_stdout () {
  if diff <($program < ${test_file} |./stdinspim 2>/dev/null) ${expected_file} >/dev/null
  then
    let success_count++
    echo -en "\033[32m.\033[0m"
  else
    let failure_count++
    echo -en "\033[31mF\033[0m"

    space_out_verbose_file
    echo -e "\033[31mFAILURE ${failure_count}:\033[0m ${test_name}" >> $verbose_file
    echo "    The expected output file, \"${expected_file}\" does not match \`$program < ${test_file} |./stdinspim\`:" >> $verbose_file
    diff <($program < ${test_file} |./stdinspim 2>/dev/null) ${expected_file} 2>&1 |sed 's/^/    /' >> $verbose_file
  fi
}

test_error_lines () {
  #if diff <($program < ${test_file} 2>&1 >/dev/null |sed 's/^\([0-9]\+\).*/\1/;s/.*[^0-9]\([0-9]\+\).*/\1/') ${expected_errors_file} >/dev/null
  if grep "Segmentation fault" <(sh -c "$program < ${test_file}" 2>&1 >/dev/null) >/dev/null
  then
    let failure_count++
    echo -en "\033[31mF\033[0m"

    space_out_verbose_file
    echo -e "\033[31mFAILURE ${failure_count}:\033[0m ${test_name}" >> $verbose_file
    echo "    The expected stderr (\`$program < ${test_file} 2>&1 >/dev/null\`), shows a Segfault:" >> $verbose_file
    sh -c "$program < ${test_file}" 2>>$verbose_file >/dev/null
  elif diff <($program < ${test_file} 2>&1 >/dev/null |sed 's/^\([0-9]\+\).*/\1/;s/[^0-9]\+\([0-9]\+\).*/\1/' |uniq) ${expected_errors_file} >/dev/null
  then
    let success_count++
    echo -en "\033[32m.\033[0m"
  else
    let failure_count++
    echo -en "\033[31mF\033[0m"

    space_out_verbose_file
    echo -e "\033[31mFAILURE ${failure_count}:\033[0m ${test_name}" >> $verbose_file
    echo "    The expected error lines file, \"${expected_errors_file}\" does not match \`$program < ${test_file} 2>&1 >/dev/null\`:" >> $verbose_file
    diff <($program < ${test_file} 2>&1 >/dev/null |sed 's/^\([0-9]\+\).*/\1/;s/[^0-9]\+\([0-9]\+\).*/\1/' |uniq) ${expected_errors_file} 2>&1 |sed 's/^/    /' >> $verbose_file
  fi
}

space_out_verbose_file () {
  if [ $(($error_count + $failure_count)) -gt 1 ]; then
    echo "" >> $verbose_file
  fi
}

program=""
if [[ $# -ge 1 ]]; then
  program=$1
  shift
  if [ ! -x "$program" ]; then
    echo "$program is not executable. Please choose an executable program to test."
    exit 2
  fi
else
  if which compile; then
    program=`which compile`
  else
    echo "compile is not in the PATH. Please add it with \`PATH=\$PATH:<path_to_compile_directory>\`,"
    echo "                            or pass it to $0 as the first argument."
    exit 1
  fi
fi

test_all
