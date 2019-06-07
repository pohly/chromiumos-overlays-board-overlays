# User Guide: Kernel Crash Dump Collection for COS

[TOC]

## Introducing Kernel Crash Dump Collection on COS

Starting from COS LTS 73 ([cos-dev-73-11647-29-0](https://cloud.google.com/container-optimized-os/docs/release-notes#cos-dev-73-11647-29-0)), COS images support kernel crash dump feature. This feature, when enabled, captures a full kernel memory crash dump in the event of a kernel crash and saves it locally on the instance’s boot disk. You can download the report and attach it to a Cloud Support to GCP support case to help debug the cause for the crash. You do not need to attempt to analyze the report yourself.

The Kernel Crash Dump Collection tool is based on the open-sourced [kdump](https://github.com/torvalds/linux/blob/master/Documentation/kdump/kdump.txt) solution, and operates only within the guest OS. It includes a [secondary dump-capture kernel](https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/refs/heads/release-R73-11647.B/overlay-lakitu/sys-kernel/dump-capture-kernel/dump-capture-kernel-9999.ebuild), a [dump-capture userspace](https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/refs/heads/release-R73-11647.B/overlay-lakitu/app-admin/kdump-helper/files/kdump-save-dump.service), and [userspace tools](https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/refs/heads/release-R73-11647.B/overlay-lakitu/app-admin/kdump-helper/kdump-helper-0.0.1.ebuild) for managing the kdump functionality.


### Before You Begin

Before you begin, there are some limitations:

1.  The runtime enabling/disabling mechanism is not compatible with the [Secure Boot](https://cloud.google.com/security/shielded-cloud/shielded-vm#secure-boot) feature of [Shielded-VMs](https://cloud.google.com/shielded-vm/) on COS.

    Secure Boot feature is disabled by default. But if the feature is enabled on the instance, one can disable it via instructions here:

    ```
    $ gcloud compute instances stop <my-instance>
    $ gcloud beta compute instances update <my-instance> --no-shielded-vm-secure-boot
    $ gcloud compute instances start <my-instance>
    ```

1. kdump feature reserves a certain amount of system memory (64MB - 512MB depending on machine size) which cannot be used for any other applications.

1. kdump has a dependency on the boot disk. So if the boot disk is full or corrupted, kdump may fail to work.

1. When booted in dump-capture kernel, the instance will be inaccessible to the user. This is because many userspace components(such as sshd, kubelet, konlet, cloud-init) won’t be started in the dump-capture kernel. The best way to view the instance’s activity during kdump, is to inspect the instance’s [serial port output](https://cloud.google.com/compute/docs/instances/viewing-serial-port-output).


### If you are using COS through GKE:

#### Enabling Kernel Crash Dump on GKE COS Nodes

For GKE users, the Kernel Crash Dump Collection tool is deployed using a DaemonSet similar to [NVIDIA GPU device drivers](https://cloud.google.com/kubernetes-engine/docs/how-to/gpus#installing_drivers). Use the kubectl apply command to apply the enable-kdump.yaml manifest provided by Google.

```
$ kubectl apply -f https://raw.githubusercontent.com/xueweiz/scripts/master/cos-kdump-switch/enable-daemonset.yaml
```

You can examine the manifest by loading it into a web browser or downloading it directly.

After the Kernel Crash Dump Collection tool is enabled, kernel crash dumps are automatically saved on the local boot disk of the GKE node that crashed.

#### Disabling Kernel Crash Dump on GKE COS Nodes

To disable the Kernel Crash Dump Collection tool, apply a different DaemonSet, whose manifest is also provided by Google:

```
$ kubectl apply -f https://raw.githubusercontent.com/xueweiz/scripts/master/cos-kdump-switch/disable-daemonset.yaml
```

### If you are using COS through GCE directly:

#### Enabling Kernel Crash Dump on Standalone COS Instances

To enable the Kernel Crash Dump Collection tool on a standalone COS instance, run the kdump_helper enable command on the instance, then reboot the system.

*Note: Rebooting is required.*

```
$ sudo kdump_helper enable
$ sudo reboot
```

In the event of a kernel crash, the crash dump will be stored on the instance’s local boot disk.

#### Disabling Kernel Crash Dump on Standalone COS Instances

To disable the Kernel Crash Dump Collection tool on a standalone COS instance, use the kdump_helper disable command, then reboot:


```
$ sudo kdump_helper disable
$ sudo reboot
```

Existing crash dumps are not deleted automatically.

### Sharing Kernel Crash Dump with Google

The sosreport tool collects crash dumps along with the other information it collects. See sosreport documentation for instructions on sending the report to Google.

## Deleting reports from the instance

To remove all existing reports from the instance, use the kdump_helper cleanup command:

```
$ sudo kdump_helper cleanup
```

Eventually COS engineers will use the [crash](https://github.com/crash-utility/crash) utility to analyze the dump.

## Troubleshooting

The [serial port output](https://cloud.google.com/compute/docs/instances/viewing-serial-port-output) of the COS instance will have the logs from dump-capture kernel, and will indicate what went wrong:

*    If the logs shows the boot disk is full, one can remove some content on it, or increase boot disk size.
