
c-------  Common Blocks for divertor

	parameter ( npo1=2)

	common
     *  /c_nrad/n_rad

     *  /c_div7/den(npo),den0(npo),sden(nimp,npo)
     *  /c_div8/difx(npo),sdenx(npo),den_neut1(npo),den0_neut1(npo),
     *  vt0,vt1,den_neut0(npo),den0_neut0(npo),prog_n0

     *  /c_div25/
     *  den_imp(nimp,nimp,npo1),den0_imp(nimp,nimp,npo1),
     *  n_imp(nimp)

     *  /c_div30/
     *  den_imp_n(nimp,npo1),den0_imp_n(nimp,npo1),
     *  den_neut(npo),den0_neut(npo)

     *  /c_div34/z_imp(nimp),n_imp_tot
     *  /c_div35/den_imp_tot(nimp)
     *  /c_div37/f_a(npo)
     *  /c_div38/
     *  yg_imp(nimp,nimp,npo),yf_imp(nimp,nimp,npo)

     *  /c_div39/difx_imp(npo),den_neut_imp(npo),den0_neut_imp(npo)

     *  /c_div40/p_lambda0(npo),p_lambda1(npo)

        common 
     *  /c_halo1/tay_sol(npo)































