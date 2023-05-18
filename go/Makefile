
include go/mutex/Makefile
include go/channel/Makefile
include go/channel-mpmc/Makefile

.PHONY: go go_clean

go: go_mutex go_channel go_channel_mpmc

go_clean: go_mutex_clean go_channel_clean go_channel_mpmc_clean
