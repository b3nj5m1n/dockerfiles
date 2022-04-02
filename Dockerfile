FROM archlinux:base-devel-20220320.0.50753

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
RUN sudo pacman -S --needed --noconfirm pandoc pandoc-crossref

RUN cd /tmp && wget "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v2.0.0/Eisvogel-2.0.0.tar.gz" && sudo mkdir eisvogel && sudo tar xf "Eisvogel-2.0.0.tar.gz" --directory "eisvogel" && cd "eisvogel" && sudo mkdir -p "/pandoc/templates" && sudo mv "eisvogel.latex" "/pandoc/templates/eisvogel.latex" && sudo chown pandoc -R /pandoc

RUN cd "/tmp" && git clone "https://aur.archlinux.org/ttf-times-new-roman.git" "tnr"
RUN cd "/tmp/tnr" && makepkg -si --noconfirm

WORKDIR /data
ENTRYPOINT ["/usr/bin/pandoc"]
