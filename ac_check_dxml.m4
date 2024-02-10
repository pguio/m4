dnl @synopsis AC_CHECK_DXML([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl Check whether DXML is available.
dnl The Digital Extended Math Library is a library of linear algebra
dnl and signal processing routines optimized for Alpha AXP platforms.
dnl
dnl dxml headers should be under DIR/include or INCDIR
dnl dxml library should be under DIR/lib or LIBDIR
dnl
dnl Define and set shell variable ac_lib_dxml to 'yes' or 'no'
dnl Substitute variables DXML_CPPFLAGS, DXML_LDFLAGS, DXML_LIBS
dnl Define macro HAVE_DXML_FFT
dnl 
dnl @author Patrick Guio <patrick.guio@matnat.uio.no>
dnl



AC_DEFUN([AC_CHECK_DXML],[

AC_ARG_WITH(dxml,
AS_HELP_STRING([--with-dxml@<:@=DIR@:>@],
               [set path for DXML library (DIR or INCDIR,LIBDIR)]),
               [dnl action-if-given
               ], [dnl action-if-not-given default is no
               withval='no'])

if test "$withval" != no ; then

	saveCPPFLAGS=$CPPFLAGS
	saveLDFLAGS=$LDFLAGS
	saveLIBS=$LIBS

  case "$withval" in
    *,*)
      dxml_incdir="`echo $withval | cut -f1 -d,`"
      dxml_libdir="`echo $withval | cut -f2 -d, -s`"
      ;;
    *)
      if test -n "$withval" -a "$withval" != yes ; then
        dxml_incdir="$withval/include"
        dxml_libdir="$withval/lib"
      fi
      ;;
  esac

  if test -n "$dxml_incdir"; then CPPFLAGS="$CPPFLAGS -I$dxml_incdir"; fi
  if test -n "$dxml_libdir"; then LDFLAGS="$LDFLAGS -L$dxml_libdir" ; fi
  LIBS=""

	AC_CHECK_LIB(dxml,zfft_apply_,[ dnl action-if-found
	AC_DEFINE([HAVE_DXML_FFT],[1],[Define DXML support])
  if test -n "$dxml_incdir"; then DXML_CPPFLAGS="-I$dxml_incdir"; fi
  if test -n "$dxml_libdir"; then DXML_LDFLAGS="-L$dxml_libdir" ; fi
  DXML_LIBS="-ldxml"
	ac_lib_dxml='yes'],[ dnl action-if-not-found
	ac_lib_dxml='no'],[-lm])

  CPPFLAGS=$saveCPPFLAGS
  LDFLAGS=$saveLDFLAGS
  LIBS=$saveLIBS

else dnl $withval = no

  ac_lib_dxml='no'

fi

AC_SUBST(DXML_CPPFLAGS)
AC_SUBST(DXML_LDFLAGS)
AC_SUBST(DXML_LIBS)

AS_IF([test "$ac_lib_dxml" = no], [$2], [$1])

])
