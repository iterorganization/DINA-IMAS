# Makefile for compilation of DINA components

AR = ar
ARFLAGS = -ru
FC = gfortran

f2c= cc -fpic -w -g -O0

FFLAGS = -w -ffixed-line-length-none -fd-lines-as-comments -fno-automatic -fPIC

CONTROLSRC = t15_2.c t15_2_data.c \
contr_curr.c contr_curr_wrapper.c contr_div.c contr_div_wrapper.c \
contr_lim.c contr_lim_wrapper.c contr_vert_vs3.c contr_vert_vs3_wrapper.c \
pf_lookup3.c pf_lookup3_wrapper.c read_pf.c \
read_gaps.c  read_gaps_wrapper.c read_gaps_term.c  read_gaps_term_wrapper.c \
read_control_data2.c read_control_data2_wrapper.c \
read_tt_kavin2.c read_tt_kavin2_wrapper.c read_Ics1_end.c \
read_Ics1_end_wrapper.c read_volt.c read_volt_wrapper.c rms_noise.c rms_noise_wrapper.c \
pow_sup.c pow_sup_wrapper.c \
rt_look.c rt_look1d.c \
rt_nonfinite.c rt_rand.c rtGetNaN.c rtGetInf.c

CONTROLOBJ = $(CONTROLSRC:.c=.o)

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
DINA_KAV := kmc.a
#DINA_KAV := $(current_dir).a

all: $(DINA_KAV)

$(DINA_KAV): $(CONTROLOBJ)
	$(info Controller library: $@ from $(current_dir))
	$(RM) -r $@
	$(AR) $(ARFLAGS) $@ $^

%.o: %.f
	$(FC) $(FFLAGS) -c $<

%.o: %.c
	$(f2c)  -c $<

clean:
	-rm -f *.o 
	-rm -f *.a
