include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = PennyStocksTool
ADDITIONAL_INCLUDE_DIRS += -IBrokerage -IBrokerage/Categories -ICommon -ICalculator -ICalculator/Categories
ADDITIONAL_OBJCFLAGS += -fexceptions -fobjc-nonfragile-abi -fblocks
ADDITIONAL_LDFLAGS += -lCommonCrypto -lgnustep-gui

PennyStocksTool_HEADERS = \
	Helper.h \
	Brokerage.h \
	Brokerage+Bittrex.h \
	Brokerage+Crypto.h \
	Brokerage+External.h \
	Brokerage+JSON.h \
	Brokerage+Poloniex.h \
	Calculator.h \
	KeychainWrapper.h

PennyStocksTool_OBJC_FILES = \
	main.m \
	Calculator/Calculator.m \
	Calculator/Categories/Calculator+Migration.m \
	Common/Helper.m \
	Common/KeychainWrapper.m \
	Brokerage/Brokerage.m \
	Brokerage/Categories/Brokerage+Bittrex.m \
	Brokerage/Categories/Brokerage+External.m \
	Brokerage/Categories/Brokerage+Crypto.m \
	Brokerage/Categories/Brokerage+Poloniex.m \
	Brokerage/Categories/Brokerage+JSON.m

PennyStocksTool_RESOURCES_FILES =

include $(GNUSTEP_MAKEFILES)/tool.make
