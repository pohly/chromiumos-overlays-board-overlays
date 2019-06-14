# User Guide: Kernel Crash Dump Collection for COS

[TOC]

## Introducing Kernel Crash Dump Collection on [Container-Optimized OS]  (COS)

Starting from COS LTS 73 ([cos-dev-73-11647-29-0]),
COS images support kernel crash dump feature. This feature, when enabled,
captures a full kernel memory crash dump in the event of a kernel crash and
saves it locally on the instance’s boot disk. You can download the report and
attach it to a [Google Cloud Platform Support Case] to help debug the crash.
You do not need to analyze the report yourself.

The Kernel Crash Dump Collection tool is based on the open source [kdump]
solution, and operates only within the guest OS. It includes a
[secondary dump-capture kernel], a [dump-capture userspace], and
[userspace tools] for managing the kdump functionality.

[Container-Optimized OS]: https://cloud.google.com/container-optimized-os/
[cos-dev-73-11647-29-0]: https://cloud.google.com/container-optimized-os/docs/release-notes#cos-dev-73-11647-29-0
[Google Cloud Platform Support Case]: https://cloud.google.com/support/
[kdump]: https://github.com/torvalds/linux/blob/master/Documentation/kdump/kdump.txt
[secondary dump-capture kernel]: https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/refs/heads/release-R73-11647.B/overlay-lakitu/sys-kernel/dump-capture-kernel/dump-capture-kernel-9999.ebuild
[dump-capture userspace]: https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/refs/heads/release-R73-11647.B/overlay-lakitu/app-admin/kdump-helper/files/kdump-save-dump.service
[userspace tools]: https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/refs/heads/release-R73-11647.B/overlay-lakitu/app-admin/kdump-helper/kdump-helper-0.0.1.ebuild

### Before You Begin

Before you begin, there are some limitations:

1.    The runtime enabling/disabling mechanism is not compatible with the
      [Secure Boot] feature of [Shielded-VMs] on COS.

      Secure Boot feature is disabled by default. But if it is enabled on the
      COS instance, you can disable it via:

      ```
      $ gcloud compute instances stop [INSTANCE_NAME]
      $ gcloud beta compute instances update [INSTANCE_NAME] --no-shielded-vm-secure-boot
      $ gcloud compute instances start [INSTANCE_NAME]
      ```

1.    kdump feature reserves a certain amount of system memory (64MB - 512MB
depending on machine size) that cannot be used for any other purpose.

1.    kdump has a dependency on the boot disk. So if the boot disk is full or
corrupted, kdump may fail.

1.    When booted in the dump-capture kernel, the instance will be inaccessible
to the user. This is because many userspace components (such as sshd, kubelet,
konlet and cloud-init) won’t be started in the dump-capture kernel. The best way
to view the instance’s activity during kdump, is to inspect its
[serial port output].

[Secure Boot]: https://cloud.google.com/security/shielded-cloud/shielded-vm#secure-boot
[Shielded-VMs]: https://cloud.google.com/shielded-vm/
[serial port output]: https://cloud.google.com/compute/docs/instances/viewing-serial-port-output

### For COS nodes managed by [Google Kubernetes Engine]  (GKE)

GKE started using COS 73 since [version 1.13.5-gke.7]. Kernel crash dump
collection feature is only available on 1.13.5-gke.7 or newer GKE clusters.

#### Enabling Kernel Crash Dump on GKE COS Nodes

Enabling Kernel Crash Dump requires a node reboot. So we recommend that you
create a node pool with Kernel Crash Dump enabled, and then migrate the workload
to the new node pool.

To create a node pool with Kernel Crash Dump enabled:

1.    Create a new node pool in your cluster with the node label `cloud.google.com/gke-kdump-enabled=true`:

```
$ gcloud container node-pools create kdump-enabled --cluster=[CLUSTER_NAME] \
    --node-labels=cloud.google.com/gke-kdump-enabled=true
```

1.    Deploy the [DaemonSet] to the new node pool. The DaemonSet will only run
on COS nodes with the `cloud.google.com/gke-kdump-enabled=true` label. It will
enable Kernel Crash Dump and then reboot the node.

```
$ kubectl create -f \
https://raw.githubusercontent.com/GoogleCloudPlatform/\
k8s-node-tools/master/enable-kdump/cos-enable-kdump.yaml
```

1.    Ensure that the DaemonSet pods are in running state:

```
$ kubectl get pods --selector=name=enable-kdump -n kube-system
```

You should get a response similar to:

```
NAME                 READY     STATUS    RESTARTS   AGE

enable-kdump-68bmw   1/1       Running   0          6m
```

1.    Check that "kdump is enabled and ready" appears in the logs of the pods.


```
$ kubectl logs enable-kdump-68bmw enable-kdump -n kube-system

```

You should get a response similar to:

```
kdump enabled: true
kdump ready: true
kdump kernel loaded: true
kdump kernel /boot/kdump/vmlinuz is loaded with command line parameter:
systemd.unit=kdump-save-dump.service noinitrd console=ttyS0 root=PARTUUID=E3438A34-19F5- 3044-897F-4F5428D985F4 maxcpus=1
kdump is enabled and ready. No reboot required.
```

You must keep the DaemonSet running on the node pools so that new nodes created
in the pool will have the changes applied automatically. Node creations can be
triggered by node auto repair, manual or auto upgrade, and auto-scaling.

[version 1.13.5-gke.7]: https://cloud.google.com/kubernetes-engine/docs/release-notes#april_15_2019
[DaemonSet]: https://github.com/GoogleCloudPlatform/k8s-node-tools/blob/master/enable-kdump/cos-enable-kdump.yaml
[Google Kubernetes Engine]: https://cloud.google.com/kubernetes-engine/

#### Disabling Kernel Crash Dump on GKE COS Nodes

To disable Kernel Crash Dump, you will need to recreate the node pool without
deploying the provided DaemonSet, and migrate your workloads to the new node
pool.

To create the new node pool with Kernel Crash Dump disabled:

```
$ gcloud container node-pools create kdump-disabled --cluster=[CLUSTER_NAME]
```

### For COS instances created from [Google Compute Engine]  (GCE) directly

#### Enabling Kernel Crash Dump on GCE COS Instances

To enable the Kernel Crash Dump Collection tool on a GCE COS instance, run the
kdump_helper enable command on the instance, then reboot the system.

*Note: Rebooting is required.*

```
$ sudo kdump_helper enable
$ sudo reboot
```

In the event of a kernel crash, the crash dump will be stored on the instance’s
local boot disk.

[Google Compute Engine]: https://cloud.google.com/compute/

#### Disabling Kernel Crash Dump on GCE COS Instances

To disable the Kernel Crash Dump Collection tool on a GCE COS instance, use the
kdump_helper disable command, then reboot:


```
$ sudo kdump_helper disable
$ sudo reboot
```

Existing crash dumps are not deleted automatically.

### Sharing Kernel Crash Dump with Google

The `sosreport` tool collects crash dumps along with some other debugging
information. See [sosreport documentation] for instructions on sharing the
report with Google.

The dump file can be inspected with the [crash] utility.

[crash]: https://github.com/crash-utility/crash
[sosreport documentation]: https://cloud.google.com/container-optimized-os/docs/how-to/sosreport


## Deleting reports from the instance

To remove all existing reports from the instance, run `kdump_helper cleanup`:

```
$ sudo kdump_helper cleanup
```

## Troubleshooting

The [serial port output] of the COS instance will have the logs from
dump-capture kernel, and will indicate what went wrong:

*    If the logs shows that the boot disk is full, you can remove some content
on it, or increase the boot disk size.
