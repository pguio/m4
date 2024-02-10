dnl @synopsis AC_CHECK_FFTW([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl Check whether FFTW is installed.
dnl FFTW is available at http://www.fftw.org
dnl
dnl   Set the path for FFTW  with the option
dnl      --with-fftw[=DIR] | --with-fftw=INCDIR,LIBDIR
dnl
dnl FFTW headers should be under DIR/include or INCDIR
dnl FFTW library should be under DIR/lib or LIBDIR
dnl
dnl Define and set shell variable ac_lib_fftw to 'yes' or 'no'
dnl Substitute variables FFTW_CPPFLAGS, FFTW_LDFLAGS, FFTW_LIBS
dnl Define macro HAVE_FFTW_FFT
dnl 
dnl @author Patrick Guio <patrick.guio@matnat.uio.no>
dnl


AC_DEFUN([AC_CHECK_FFTW],[

AC_ARG_WITH(fftw,
AS_HELP_STRING([--with-fftw@<:@=DIR@:>@],
               [set path for FFTW library (DIR or INCDIR,LIBDIR)]),
               [dnl action-if-given
               ], [dnl action-if-not-given default is no
               withval='no'])

if test "$withval" != no ; then

	saveCPPFLAGS=$CPPFLAGS
	saveLDFLAGS=$LDFLAGS
	saveLIBS=$LIBS

  case "$withval" in
    *,*)
      fftw_incdir="`echo $withval | cut -f1 -d,`"
      fftw_libdir="`echo $withval | cut -f2 -d, -s`"
      ;;
    *)
      if test -n "$withval" -a "$withval" != yes ; then
        fftw_incdir="$withval/include"
        fftw_libdir="$withval/lib"
      fi
      ;;
  esac

  if test -n "$fftw_incdir"; then CPPFLAGS="$CPPFLAGS -I$fftw_incdir"; fi
  if test -n "$fftw_libdir"; then LDFLAGS="$LDFLAGS -L$fftw_libdir" ; fi
	LIBS=""

	AC_CHECK_LIB(fftw,fftw_create_plan,[ dnl action-if-found
	AC_DEFINE([HAVE_FFTW_FFT],[1],[Define FFTW support])
	if test -n "$fftw_incdir"; then FFTW_CPPFLAGS="-I$fftw_incdir"; fi
	if test -n "$fftw_libdir"; then FFTW_LDFLAGS="-L$fftw_libdir" ; fi
	FFTW_LIBS="-lfftw -lrfftw"
	ac_lib_fftw='yes'],[ dnl action-if-not-found
	ac_lib_fftw='no'],[-lrfftw -lm])

	CPPFLAGS=$saveCPPFLAGS
	LDFLAGS=$saveLDFLAGS
	LIBS=$saveLIBS

else dnl $withval = no

  ac_lib_fftw='no'

fi

AC_SUBST(FFTW_CPPFLAGS)
AC_SUBST(FFTW_LDFLAGS)
AC_SUBST(FFTW_LIBS)

AS_IF([test "$ac_lib_fftw" = no], [$2], [$1])


])


AC_DEFUN([AC_MSG_ERROR_FFTW],[AC_MSG_ERROR([
$PACKAGE_STRING requires the FFTW library
available at http://www.fftw.org
])])
