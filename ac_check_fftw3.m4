dnl @synopsis AC_CHECK_FFTW3([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl Check whether FFTW3 is installed.
dnl FFTW3 is available at http://www.fftw.org
dnl
dnl   Set the path for FFTW  with the option
dnl      --with-fftw3[=DIR] | --with-fftw3=INCDIR,LIBDIR
dnl
dnl FFTW headers should be under DIR/include or INCDIR
dnl FFTW library should be under DIR/lib or LIBDIR
dnl
dnl Define and set shell variable ac_lib_fftw3 to 'yes' or 'no'
dnl Substitute variables FFTW3_CPPFLAGS, FFTW3_LDFLAGS, FFTW3_LIBS
dnl Define macro HAVE_FFTW3_FFT
dnl 
dnl @author Patrick Guio <patrick.guio@matnat.uio.no>
dnl


AC_DEFUN([AC_CHECK_FFTW3],[

AC_ARG_WITH(fftw3,
AS_HELP_STRING([--with-fftw3@<:@=DIR@:>@],
               [set path for FFTW3 library (DIR or INCDIR,LIBDIR)]),
               [dnl action-if-not-given 
               ], [dnl action-if-not-given default is no
               withval='no'])

if test "$withval" != no ; then

	saveCPPFLAGS=$CPPFLAGS
	saveLDFLAGS=$LDFLAGS
	saveLIBS=$LIBS

  case "$withval" in
    *,*)
      fftw3_incdir="`echo $withval | cut -f1 -d,`"
      fftw3_libdir="`echo $withval | cut -f2 -d, -s`"
      ;;
    *)
      if test -n "$withval" -a "$withval" != yes ; then
        fftw3_incdir="$withval/include"
        fftw3_libdir="$withval/lib"
      fi
      ;;
  esac

  if test -n "$fftw3_incdir"; then CPPFLAGS="$CPPFLAGS -I$fftw3_incdir"; fi
  if test -n "$fftw3_libdir"; then LDFLAGS="$LDFLAGS -L$fftw3_libdir" ; fi
	LIBS=""

	AC_CHECK_LIB(fftw3,fftw_plan_dft_1d,[ dnl action-if-found
	AC_DEFINE([HAVE_FFTW3_FFT],[1],[Define FFTW3 support])
	if test -n "$fftw3_incdir"; then FFTW3_CPPFLAGS="-I$fftw3_incdir"; fi
	if test -n "$fftw3_libdir"; then FFTW3_LDFLAGS="-L$fftw3_libdir" ; fi
	FFTW3_LIBS="-lfftw3"
	ac_lib_fftw3='yes'],[ dnl action-if-not-found
	ac_lib_fftw3='no'],[-lm])

	CPPFLAGS="$saveCPPFLAGS"
	LDFLAGS="$saveLDFLAGS"
	LIBS="$saveLIBS"

else dnl $withval = no

  ac_lib_fftw3='no'

fi

AC_SUBST(FFTW3_CPPFLAGS)
AC_SUBST(FFTW3_LDFLAGS)
AC_SUBST(FFTW3_LIBS)

AS_IF([test "$ac_lib_fftw3" = no], [$2], [$1])

])

AC_DEFUN([AC_MSG_ERROR_FFTW3],[AC_MSG_ERROR([
$PACKAGE_STRING requires the FFTW3 library
available at http://www.fftw.org
])])

