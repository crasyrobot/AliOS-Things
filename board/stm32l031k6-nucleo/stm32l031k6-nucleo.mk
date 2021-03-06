NAME := stm32l031k6-nucleo

JTAG := jlink_swd

$(NAME)_TYPE := kernel
MODULE               := 1062
HOST_ARCH            := Cortex-M0
HOST_MCU_FAMILY      := stm32l0xx_cube
SUPPORT_BINS         := no
HOST_MCU_NAME        := STM32L031K6-Nucleo


$(NAME)_SOURCES += aos/board_partition.c \
                   aos/soc_init.c \
                   aos/nano_util.c
                   
$(NAME)_SOURCES += Src/stm32l0xx_hal_msp.c 
                   
ifeq ($(COMPILER), armcc)
	$(NAME)_SOURCES += startup_stm32l031xx_keil.s    
else ifeq ($(COMPILER), iar)
	$(NAME)_SOURCES += startup_stm32l031xx_iar.s  
else
	$(NAME)_SOURCES += startup_stm32l031xx.s
endif

GLOBAL_INCLUDES += . \
                   hal/ \
                   aos/ \
                   Inc/
				   
GLOBAL_CFLAGS += -DSTM32L031xx

ifeq ($(COMPILER),armcc)
	GLOBAL_LDFLAGS += -L --scatter=board/stm32l031k6-nucleo/STM32L031.sct
else ifeq ($(COMPILER),iar)
	GLOBAL_LDFLAGS += --config board/stm32l031k6-nucleo/STM32L031.icf
else
	GLOBAL_LDFLAGS += -T board/stm32l031k6-nucleo/STM32L031K6_FLASH.ld
endif

GLOBAL_DEFINES += STDIO_UART=2 CONFIG_NO_TCPIP
GLOBAL_DEFINES += RHINO_CONFIG_TICK_TASK=0 RHINO_CONFIG_WORKQUEUE=0

CONFIG_SYSINFO_PRODUCT_MODEL := ALI_AOS_L031K6-nucleo
CONFIG_SYSINFO_DEVICE_NAME := NUCLEO-L031K6

GLOBAL_CFLAGS += -DSYSINFO_OS_VERSION=\"$(CONFIG_SYSINFO_OS_VERSION)\"
GLOBAL_CFLAGS += -DSYSINFO_PRODUCT_MODEL=\"$(CONFIG_SYSINFO_PRODUCT_MODEL)\"
GLOBAL_CFLAGS += -DSYSINFO_DEVICE_NAME=\"$(CONFIG_SYSINFO_DEVICE_NAME)\"
GLOBAL_CFLAGS += -DSYSINFO_ARCH=\"Cortex-M0+\"
GLOBAL_CFLAGS += -DSYSINFO_MCU=\"STM32L031\"

ifeq ($(COMPILER),armcc)
$(NAME)_LINK_FILES := startup_stm32l031xx_keil.o
endif
