#!/usr/bin/env python2
# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Walks the directory tree to determine inheritance tree of models.

It outputs all models with their parents in '<parent>/<model>' form, separated
by a space character, in the order that they need to be processed, starting
with the "root".

The "root" is the pseudo-model where default configurations for all subsystems
supported is being stored.

It requires:
 - each model directory must have a parent file containing just the
   parent model as a string
 - one of those models must be the designated root denoted by setting
   its parent to "root".
"""


import os
import sys

PARENT_FILE_NAME = 'parent'
ROOT_NAME = 'root'


def main(model_dir):
  result = ''
  parent_map = _extract_parent_map(model_dir)
  result = _create_model_processing_order(parent_map, ROOT_NAME, result)
  print result


def _create_model_processing_order(parent_map, parent_model, output):
  result = output
  if parent_model not in parent_map:
    return result

  for model in parent_map[parent_model]:
    result += '%s/%s ' % (parent_model, model)
    result = _create_model_processing_order(parent_map, model, result)

  return result


def _extract_parent_map(model_dir):
  """Builds map of models and their children.

  Looks for 'parent' file in folders, extracts the name of parent from it
  and uses it to build the map of models with their children.

  Args:
    model_dir: Path to the directory that contains all the models' config.

  Returns:
    Returns the model/children map.
  """
  result = {}
  for root, dirs, files in os.walk(model_dir):
    if PARENT_FILE_NAME in files:
      del dirs[:]  # don't descend into further sub-directories
      with open(os.path.join(root, PARENT_FILE_NAME)) as parent_file:
        parent = parent_file.readline().rstrip()
        model_name = os.path.basename(root)
        if parent in result:
          result[parent].append(model_name)
        else:
          result[parent] = [model_name]
  return result

if __name__ == '__main__':
  main(sys.argv[1])
