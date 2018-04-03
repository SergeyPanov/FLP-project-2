compile:
	swipl -q -g start -o flp18-log -c stree.pl

test: compile
	bash test.sh
