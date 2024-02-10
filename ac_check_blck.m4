dnl @synopsis AC_CHECK_BLCK([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl dnl
dnl dnl Check whether Berkeley Lab chekpointing/restart is installed.
dnl dnl blcr is available at http://sourceforge.net/projects/blitz
dnl dnl
dnl dnl   Set the path for blcr  with the option
dnl dnl      --with-blitz[=DIR] | --with-blitz=INCDIR,LIBDIR
dnl dnl 
dnl dnl   blcr headers should be under DIR/include or INCDIR
dnl dnl   blcr library should be under DIR/lib or LIBDIR
dnl dnl  
dnl dnl Define and set shell variable ac_cv_lib_blitz to 'yes' or 'no'
dnl dnl Substitute variables BLITZ_CPPFLAGS, BLITZ_LDFLAGS, BLITZ_LIBS
dnl dnl Define macro HAVE_BLITZ
dnl dnl 
dnl dnl @author Patrick Guio <p.guio@ucl.ac.uk>
dnl dnl
dnl
