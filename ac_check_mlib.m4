dnl @synopsis AC_CHECK_FFTW([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl Check whether MLIB is installed.
dnl MLIB is Hewlett-Packard's Mathematical Software Library
dnl
dnl MLIB headers should be under DIR/include or INCDIR
dnl MLIB library should be under DIR/lib or LIBDIR
dnl
dnl Define and set shell variable ac_lib_mlib to 'yes' or 'no'
dnl Substitute variables MLIB_CPPFLAGS, MLIB_LDFLAGS, MLIB_LIBS
dnl Define macro HAVE_MLIB_FFT
dnl 
dnl @author Patrick Guio <patrick.guio@matnat.uio.no>
dnl


AC_DEFUN([AC_CHECK_MLIB],[

AC_ARG_WITH(mlib,
AS_HELP_STRING([--with-mlib@<:@=DIR@:>@],
               [set path for MLIB library (DIR or INCDIR,LIBDIR)]),
               [dnl action-if-given
							 ], [dnl action-if-not-given default is no
               withval='no'])

if test "$withval" != no ; then

	saveCPPFLAGS=$CPPFLAGS
	saveLDFLAGS=$LDFLAGS
	saveLIBS=$LIBS

  case "$withval" in
    *,*)
      mlib_incdir="`echo $withval | cut -f1 -d,`"
      mlib_libdir="`echo $withval | cut -f2 -d, -s`"
      ;;
    *)
      if test -n "$withval" -a "$withval" != yes ; then
        mlib_incdir="$withval/include"
        mlib_libdir="$withval/lib"
      fi
      ;;
  esac

  if test -n "$mlib_incdir"; then CPPFLAGS="$CPPFLAGS -I$mlib_incdir"; fi
  if test -n "$mlib_libdir"; then LDFLAGS="$LDFLAGS -L$mlib_libdir" ; fi
  LIBS=""

	AC_CHECK_LIB(veclib,z1dfft,[ dnl action-if-found
	AC_DEFINE([HAVE_MLIB_FFT],[1],[Define MLIB support])
  if test -n "$mlib_incdir"; then MLIB_CPPFLAGS="-I$mlib_incdir"; fi
  if test -n "$mlib_libdir"; then MLIB_LDFLAGS="-L$mlib_libdir" ; fi
	MLIB_LIBS="-lveclib -lcl" 
	ac_lib_mlib='yes'],[ dnl action-if-not-found
  ac_lib_mlib='no'],[-lcl -lm])

  CPPFLAGS=$saveCPPFLAGS
  LDFLAGS=$saveLDFLAGS
  LIBS=$saveLIBS

else dnl $withval = no

  ac_lib_mlib='no'

fi

AC_SUBST(MLIB_CPPFLAGS)
AC_SUBST(MLIB_LDFLAGS)
AC_SUBST(MLIB_LIBS)

AS_IF([test "$ac_lib_mlib" = no], [$2], [$1])


])
