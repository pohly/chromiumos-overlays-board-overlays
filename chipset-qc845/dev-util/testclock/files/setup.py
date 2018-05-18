#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

from setuptools import setup

setup(
    name='testclock',
    version='0.0.1',
    description='Tools for measuring clock frequencies on SDM845',
    py_modules=['testclock'],
    install_requires=['mem'],
    entry_points={
        'console_scripts': [
            'testclock = testclock:main',
        ]
    }
)
