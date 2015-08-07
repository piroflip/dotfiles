# load configs
for config (~/.config/zsh/*.zsh) source $config

PATH="/home/piroflip/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/piroflip/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/piroflip/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/piroflip/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/piroflip/perl5"; export PERL_MM_OPT;
