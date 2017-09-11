include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = PennyStocksTool
ADDITIONAL_INCLUDE_DIRS += -IBrokerage -ICommon
ADDITIONAL_OBJCFLAGS += -fexceptions -fobjc-nonfragile-abi -fblocks
ADDITIONAL_LDFLAGS += -lCommonCrypto -lgnustep-gui

PennyStocksTool_HEADERS = Helper.h Brokerage.h Calculator.h
PennyStocksTool_OBJC_FILES = main.m Common/Helper.m Brokerage/Brokerage.m Common/Calculator.m
PennyStocksTool_RESOURCES_FILES =

include $(GNUSTEP_MAKEFILES)/tool.make
