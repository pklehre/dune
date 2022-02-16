We test two different aspect of preprocessor:

* The directory in which they run
* How they reference their file dependencies (relative to what?)

  $ cat >dune-project <<EOF
  > (lang dune 2.9)
  > EOF

First, we demonstrate that preprocessors run from the context root:

  $ DIR=1
  $ mkdir $DIR
  $ cat >$DIR/dune <<EOF
  > (test
  >  (name test)
  >  (preprocess (action (run %{project_root}/pp/pp.exe %{input-file}))))
  > EOF
  $ cat >$DIR/test.ml <<EOF
  > print_endline _STRING_
  > EOF
  $ dune runtest $DIR
  running preprocessor in $TESTCASE_ROOT/_build/default
  Hello, world!

While running it from the contet root is good for error messages, it makes
referencing processor dependencies quite awkward:

  $ DIR=2
  $ mkdir $DIR
  $ touch $DIR/dep
  $ cat >$DIR/dune <<EOF
  > (test
  >  (name test)
  >  (preprocessor_deps ./dep)
  >  (preprocess (action (run %{project_root}/pp/pp.exe %{input-file} ./dep))))
  > EOF
  $ cat >$DIR/test.ml <<EOF
  > print_endline _STRING_
  > EOF
  $ dune runtest $DIR
  running preprocessor in $TESTCASE_ROOT/_build/default
  dep ./dep exists = false
  Hello, world!
