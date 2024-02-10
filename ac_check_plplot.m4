dnl @synopsis AC_CHECK_PLPLOT([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl Check whether PLplot is installed.
dnl PLplot is available at http://plplot.sourceforge.net/
dnl
dnl   Set the path for PLplot  with the option
dnl      --with-plplot[=DIR] | --with-plplot=INCDIR,LIBDIR
dnl
dnl PLplot headers should be under DIR/include or INCDIR
dnl PLplot library should be under DIR/lib or LIBDIR
dnl
dnl Define and set the following shell variables
dnl    ac_lib_plplot to 'yes' or 'no'
dnl    ac_finc_plplot to 'yes' or 'no'
dnl Substitute environment variable PLPLOT_LIBS
dnl Substitute variables PLPLOT_CPPFLAGS, PLPLOT_LDFLAGS, PLPLOT_CXXLIBS
dnl Define macro HAVE_PLPLOT
dnl 
dnl @author Patrick Guio <p.guio@ucl.ac.uk>
dnl


AC_DEFUN([AC_CHECK_PLPLOT],[

AC_ARG_WITH(plplot,
AS_HELP_STRING([--with-plplot@<:@=DIR@:>@],
               [set path for PLplot library (DIR or INCDIR,LIBDIR)]),
               [dnl action-if-given
               ], [dnl action-if-not-given default is no
               withval='no'])

if test "$withval" != no ; then

	AC_LANG_SAVE
	AC_LANG(C)

	saveCPPFLAGS=$CPPFLAGS
	saveLDFLAGS=$LDFLAGS
	saveLIBS=$LIBS

  case "$withval" in
    *,*)
      plplot_incdir="`echo $withval | cut -f1 -d,`"
      plplot_libdir="`echo $withval | cut -f2 -d, -s`"
      ;;
    *)
      if test -n "$withval" -a "$withval" != yes ; then
        plplot_incdir="$withval/include"
        plplot_libdir="$withval/lib"
      fi
      ;;
  esac

  if test -n "$plplot_incdir"; then CPPFLAGS="$CPPFLAGS -I$plplot_incdir"; fi
  if test -n "$plplot_libdir"; then LDFLAGS="$LDFLAGS -L$plplot_libdir" ; fi
	LIBS=""

  if test -z "$PLPLOT_CLIB"; then PLPLOT_CLIB="plplot"; fi
	AC_CHECK_LIB($PLPLOT_CLIB,c_plinit,[ dnl action-if-found
	AC_DEFINE([HAVE_PLPLOT],[1],[Define PLplot support])
	if test -n "$plplot_incdir"; then PLPLOT_CPPFLAGS="-I$plplot_incdir"; fi
	if test -n "$plplot_libdir"; then PLPLOT_LDFLAGS="-L$plplot_libdir" ; fi
	PLPLOT_LIBS="-l$PLPLOT_CLIB"
	ac_lib_plplot='yes'],[ dnl action-if-not-found
	ac_lib_plplot='no'],[-lm])

	AC_LANG(C++)

	saveCPPLAGS=$CPPFLAGS
	if test -n "$plplot_incdir"; then CPPFLAGS="-I$plplot_incdir"; fi

	AC_CACHE_CHECK([whether plstream.h is installed],[ac_cv_cxxinc_plplot],
	[AC_COMPILE_IFELSE(
	[AC_LANG_PROGRAM([[#include "plstream.h"]],[[]])],
	[ac_cv_cxxinc_plplot='yes'],[ac_cv_cxxinc_plplot='no'])
	])

  if test -n "$plplot_libdir"; then LDFLAGS="$LDFLAGS -L$plplot_libdir"; fi
	if test -z "$PLPLOT_CXXLIBS"; then
		LIBS="-lplplotcxxd"
	else
		LIBS=$PLPLOT_CXXLIBS
	fi
	AC_CACHE_CHECK([for plstream in $LIBS],[ac_cv_cxxlib_plplot],
	[AC_LINK_IFELSE(
	[AC_LANG_PROGRAM([[
#include "plstream.h"
]],[[
plstream *pls = new plstream();
pls->sdev("xwin");
	]])],
	[ac_cv_cxxlib_plplot='yes';PLPLOT_CXXLIBS="$LIBS"],[ac_cv_cxxlib_plplot='no'])
	])

	CPPFLAGS=$saveCPPFLAGS
	LDFLAGS=$saveLDFLAGS
	LIBS=$saveLIBS

	AC_LANG_RESTORE

else dnl $withval = no

  ac_lib_plplot='no'

fi

AC_SUBST(PLPLOT_CPPFLAGS)
AC_SUBST(PLPLOT_LDFLAGS)
AC_SUBST(PLPLOT_LIBS)
AC_SUBST(PLPLOT_CXXLIBS)

AC_ARG_VAR(PLPLOT_CLIB,[PLplot C libraries])
AC_ARG_VAR(PLPLOT_CXXLIBS,[PLplot C++ libraries])

AS_IF([test "$ac_lib_plplot" = no], [$2], [$1])


])


AC_DEFUN([AC_MSG_ERROR_PLplot],[AC_MSG_ERROR([
$PACKAGE_STRING requires the PLplot library
available at http://plplot.sourceforge.net/
])])
