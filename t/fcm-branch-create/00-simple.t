#!/bin/bash
# ------------------------------------------------------------------------------
# (C) British Crown Copyright 2006-2013 Met Office.
#
# This file is part of FCM, tools for managing and building source code.
#
# FCM is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# FCM is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with FCM. If not, see <http://www.gnu.org/licenses/>.
# ------------------------------------------------------------------------------
# Basic tests for "fcm branch-create".
#-------------------------------------------------------------------------------
. $(dirname $0)/test_header
#-------------------------------------------------------------------------------
tests 12
#-------------------------------------------------------------------------------
setup
init_repos ${TEST_PROJECT:-}
REPOS_URL="file://"$(cd $TEST_DIR/test_repos && pwd)
ROOT_URL=$REPOS_URL
if [[ -n ${TEST_PROJECT:-} ]]; then
    ROOT_URL=$REPOS_URL/$TEST_PROJECT
fi
init_branch_wc branch_test $REPOS_URL
cd $TEST_DIR/wc
#-------------------------------------------------------------------------------
# Tests fcm branch-create
TEST_KEY=$TEST_KEY_BASE-fcm-bc
run_pass "$TEST_KEY" fcm branch-create -t SHARE --rev-flag=NONE \
                                        --non-interactive \
                                        my_branch_test
file_xxdiff "$TEST_KEY.out" "$TEST_KEY.out" <<__OUT__
[info] Source: $ROOT_URL/trunk@1 (4)
Change summary:
--------------------------------------------------------------------------------
A    $ROOT_URL/branches/dev/Share/my_branch_test
--------------------------------------------------------------------------------
Commit message is as follows:
--------------------------------------------------------------------------------
Created /branches/dev/Share/my_branch_test from /trunk@1.
--------------------------------------------------------------------------------

Committed revision 5.
[info] Created: $ROOT_URL/branches/dev/Share/my_branch_test
__OUT__
file_xxdiff "$TEST_KEY.err" "$TEST_KEY.err" </dev/null
#-------------------------------------------------------------------------------
# Tests existence of branch
TEST_KEY=$TEST_KEY_BASE-fcm-bc-branch-exists-sw
run_pass "$TEST_KEY" svn switch \
               $ROOT_URL/branches/dev/Share/my_branch_test
file_xxdiff "$TEST_KEY.out" "$TEST_KEY.out" <<'__OUT__'
At revision 5.
__OUT__
file_xxdiff "$TEST_KEY.err" "$TEST_KEY.err" </dev/null
teardown
#-------------------------------------------------------------------------------
init_repos ${TEST_PROJECT:-}
REPOS_URL="file://"$(cd $TEST_DIR/test_repos && pwd)
ROOT_URL=$REPOS_URL
if [[ -n ${TEST_PROJECT:-} ]]; then
    ROOT_URL=$REPOS_URL/$TEST_PROJECT
fi
init_branch_wc branch_test $REPOS_URL
cd $TEST_DIR/wc
#-------------------------------------------------------------------------------
# Tests fcm branch-create --branch-of-branch
TEST_KEY=$TEST_KEY_BASE-fcm-bc-branch-of-branch
run_pass "$TEST_KEY" fcm branch-create -t SHARE --rev-flag=NONE \
                                       --non-interactive \
                                       --branch-of-branch my_branch_test
file_xxdiff "$TEST_KEY.out" "$TEST_KEY.out" <<__OUT__
[info] Source: $ROOT_URL/branches/dev/Share/branch_test@4 (4)
Change summary:
--------------------------------------------------------------------------------
A    $ROOT_URL/branches/dev/Share/my_branch_test
--------------------------------------------------------------------------------
Commit message is as follows:
--------------------------------------------------------------------------------
Created /branches/dev/Share/my_branch_test from /branches/dev/Share/branch_test@4.
--------------------------------------------------------------------------------

Committed revision 5.
[info] Created: $ROOT_URL/branches/dev/Share/my_branch_test
__OUT__
file_xxdiff "$TEST_KEY.err" "$TEST_KEY.err" </dev/null
#-------------------------------------------------------------------------------
# Tests existence of branch
TEST_KEY=$TEST_KEY_BASE-fcm-bc-branch-of-branch-exists-sw
run_pass "$TEST_KEY" svn switch \
               $ROOT_URL/branches/dev/Share/my_branch_test
file_xxdiff "$TEST_KEY.out" "$TEST_KEY.out" <<'__OUT__'
At revision 5.
__OUT__
file_xxdiff "$TEST_KEY.err" "$TEST_KEY.err" </dev/null
teardown
#-------------------------------------------------------------------------------
