NAME := lfpkm
lfar:
	lfrt launch lfdev tbfs -c src out.lfar

clean:
	rm out.lfar

release:
	cp out.lfar ref.lfar

install:
	cp out.lfar $(HOME)/.config/lfrt/prg/$(NAME).lfar
	$(MAKE) clean

ALL:
	$(MAKE) lfar
	$(MAKE) install
