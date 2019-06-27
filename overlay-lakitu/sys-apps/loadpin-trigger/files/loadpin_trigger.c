/*
 * Copyright 2019 The Chromium OS Authors. All rights reserved.
 * Distributed under the terms of the GNU General Public License v2.
 *
 * Module to trigger loadpin. The kernel module calls
 * kernel_read_file_from_path to load a dummy file from rootfs into kernel,
 * which will trigger loadpin.
 */

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/err.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/types.h>
#include <linux/vmalloc.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Ke Wu");
MODULE_DESCRIPTION("A Linux module to trigger loadpin.");
MODULE_VERSION("1");

static const char *root_fs_dummy_path = "/.loadpin_trigger";

static int __init loadpin_trigger_init(void) {
  void *data;
  loff_t size;
  int rc;

  rc = kernel_read_file_from_path(root_fs_dummy_path, &data, &size,
                                  0, READING_UNKNOWN);
  if (rc < 0) {
    pr_err("Unable to read file: %s (%d)", root_fs_dummy_path, rc);
    return -EIO;
  }
  vfree(data);
  return 0;
}

module_init(loadpin_trigger_init);
