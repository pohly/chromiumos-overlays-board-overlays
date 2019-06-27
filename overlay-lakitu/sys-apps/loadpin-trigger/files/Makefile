obj-m := loadpin_trigger.o

modules:
	$(MAKE) CC=$(CC) -C $(KERNEL_SOURCES) M=$(CURDIR) ARCH=$(ARCH) \
		KBUILD_OUTPUT=$(KBUILD_OUTPUT) $@

module: modules
