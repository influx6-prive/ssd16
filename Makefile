# (The MIT License)
#
# Copyright (c) 2021 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

.SHELLFLAGS = -e -o pipefail -c
.ONESHELL:

DIRS := $(wildcard [0-9][0-9]-*/.)

all:
	for d in $(DIRS); do
		cd $${d} && latexmk -pdf && cd ..
	done

copy:
	for d in $(DIRS); do
		cp .latexmkrc $${d}
		cp .texsc $${d}
		cp .texqc $${d}
	done

# static:
# 	for d in $(DIRS); do
# 		cd $${d}
# 		for f in $$(ls *.tex); do
# 			sed -i "s/documentclass\\.+{/x/g" $${f}
# 		done
# 		cd ..
# 	done

clean:
	for d in $(DIRS); do
		cd $${d} && latexmk -C && cd ..
	done
