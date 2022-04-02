FROM archlinux:base-devel-20220320.0.50753

ARG pandoc_version="2.13"
ARG crossref_version="v0.3.10.0a"

RUN sudo pacman -Syy --noconfirm
RUN sudo pacman -S --needed --noconfirm base-devel git wget

RUN useradd -m pandoc
RUN echo "pandoc ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER pandoc
ENTRYPOINT ["sleep"]
CMD ["1000"]

# RUN cd "/tmp" && git clone "https://aur.archlinux.org/paru.git"
# RUN cd "/tmp/paru" && makepkg -si --noconfirm

RUN sudo pacman -S --needed --noconfirm texlive-core texlive-bin texlive-latexextra texlive-bibtexextra
# RUN sudo pacman -S --needed --noconfirm pandoc pandoc-crossref

RUN cd /tmp && wget "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v2.0.0/Eisvogel-2.0.0.tar.gz" && sudo mkdir eisvogel && sudo tar xf "Eisvogel-2.0.0.tar.gz" --directory "eisvogel" && cd "eisvogel" && sudo mkdir -p "/pandoc/templates" && sudo mv "eisvogel.latex" "/pandoc/templates/eisvogel.latex" && sudo chown pandoc -R /pandoc

RUN cd "/tmp" && git clone "https://aur.archlinux.org/ttf-times-new-roman.git" "tnr"
RUN cd "/tmp/tnr" && makepkg -si --noconfirm

RUN cd "/tmp" && git clone "https://aur.archlinux.org/latex-sourcesanspro-font.git" "sourcesanspro"
RUN cd "/tmp/sourcesanspro" && makepkg -si --noconfirm

RUN cd "/tmp" && git clone "https://aur.archlinux.org/latex-sourcecodepro-font.git" "sourcecodepro"
RUN cd "/tmp/sourcecodepro" && makepkg -si --noconfirm

RUN cd "/tmp" && sudo mkdir pandoc && sudo chown pandoc pandoc && cd pandoc && wget "https://github.com/jgm/pandoc/releases/download/$pandoc_version/pandoc-$pandoc_version-linux-amd64.tar.gz" && tar xf "pandoc-$pandoc_version-linux-amd64.tar.gz" && cd "pandoc-$pandoc_version" && cd "bin" && sudo mv pandoc "/usr/bin"
RUN cd "/tmp" && sudo mkdir crossref && sudo chown pandoc crossref && cd crossref && wget "https://github.com/lierdakil/pandoc-crossref/releases/download/$crossref_version/pandoc-crossref-Linux.tar.xz" && tar xf "pandoc-crossref-Linux.tar.xz" && sudo mv "pandoc-crossref" "/usr/bin"


WORKDIR /data
ENTRYPOINT ["/usr/bin/pandoc"]
