#!/bin/bash
#############################################################################
##
## Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
## Contact: http://www.qt-project.org/
##
## This file is the build configuration utility of the Qt Toolkit.
##
## $QT_BEGIN_LICENSE:LGPL$
## GNU Lesser General Public License Usage
## This file may be used under the terms of the GNU Lesser General Public
## License version 2.1 as published by the Free Software Foundation and
## appearing in the file LICENSE.LGPL included in the packaging of this
## file. Please review the following information to ensure the GNU Lesser
## General Public License version 2.1 requirements will be met:
## http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
##
## In addition, as a special exception, Nokia gives you certain additional
## rights. These rights are described in the Nokia Qt LGPL Exception
## version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
##
## GNU General Public License Usage
## Alternatively, this file may be used under the terms of the GNU General
## Public License version 3.0 as published by the Free Software Foundation
## and appearing in the file LICENSE.GPL included in the packaging of this
## file. Please review the following information to ensure the GNU General
## Public License version 3.0 requirements will be met:
## http://www.gnu.org/copyleft/gpl.html.
##
## Other Usage
## Alternatively, this file may be used in accordance with the terms and
## conditions contained in a signed written agreement between you and Nokia.
##
##
##
##
##
##
## $QT_END_LICENSE$
##
#############################################################################

v8repo=https://github.com/v8/v8.git

if [ "$#" != 1 ]; then
    echo "usage: $0 <commit>"
    exit 1
fi

commit=$1
git cat-file -e $commit
if [ $? != 0 ]; then
    echo "Cannot find commit $commit . Trying to fetch it from the master branch at $v8repo."
    git fetch $v8repo master
    git cat-file -e $commit
    if [ $? != 0 ]; then
        echo "I still cannot find that commit, not even in the master branch. Please run git fetch yourself"
        echo "with the appropriate parameters to get the commit you'd like to cherry-pick into this repo."
        exit 1
    fi
fi

((git format-patch -M -C --relative --stdout "$commit^..$commit" ) | git am -s -3 --directory=src/3rdparty/v8) && git commit --amend
