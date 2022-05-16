FROM archlinux

WORKDIR /root
COPY . .
RUN pacman -Sy --noconfirm make
RUN make install

ENTRYPOINT /bin/bash
# just for test.
