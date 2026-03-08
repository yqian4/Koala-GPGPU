.PHONY: test clean
test_%:
	mkdir build
	cp rtl/*.* build
	cp -r rtl/common build/common
	cp -r rtl/sm_core build/sm_core
	cp -r test build/test
	cp Main.Makefile build/Makefile
	cp Common.Makefile build/Common.Makefile
	make -C build $@

clean:
	rm -rf build
	

