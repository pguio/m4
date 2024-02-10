dnl @synopsis AC_CHECK_BLITZ([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl Check whether Blitz++ is installed.
dnl Blitz++ is available at http://sourceforge.net/projects/blitz
dnl
dnl   Set the path for Blitz++  with the option
dnl      --with-blitz[=DIR] | --with-blitz=INCDIR,LIBDIR
dnl 
dnl   Blitz headers should be under DIR/include or INCDIR
dnl   Blitz library should be under DIR/lib or LIBDIR
dnl  
dnl Define and set shell variable ac_cv_lib_blitz to 'yes' or 'no'
dnl Substitute variables BLITZ_CPPFLAGS, BLITZ_LDFLAGS, BLITZ_LIBS
dnl Define macro HAVE_BLITZ
dnl 
dnl @author Patrick Guio <patrick.guio@matnat.uio.no>
dnl

AC_DEFUN([AC_CHECK_BLITZ],[


AC_ARG_WITH(blitz,
AS_HELP_STRING([--with-blitz@<:@=DIR@:>@], 
               [set path for Blitz++ library (DIR or INCDIR,LIBDIR)]),
               [dnl action-if-given
               ], [dnl action-if-not-given default is yes
               withval='yes'])

if test "$withval" != no ; then

  saveCPPFLAGS=$CPPFLAGS
  saveLDFLAGS=$LDFLAGS
  saveLIBS=$LIBS

  case "$withval" in
	  *,*)
		  blitz_incdir="`echo $withval | cut -f1 -d,`"
			blitz_libdir="`echo $withval | cut -f2 -d, -s`"
			;;
		*)
		  if test -n "$withval" -a "$withval" != yes ; then
			  blitz_incdir="$withval/include"
				blitz_libdir="$withval/lib"
			fi
			;;
	esac

  if test -n "$blitz_incdir"; then CPPFLAGS="$CPPFLAGS -I$blitz_incdir"; fi
  if test -n "$blitz_libdir"; then LDFLAGS="$LDFLAGS -L$blitz_libdir" ; fi
	LIBS="-lblitz"

  dnl new Blitz 
	AC_CACHE_CHECK([whether new Blitz++ is installed],[ac_cv_lib_blitz2],
	[AC_LANG_SAVE
	AC_LANG([C++])
	AC_RUN_IFELSE(
	[AC_LANG_PROGRAM([[
#include <blitz/array.h>
#include <blitz/tinyvec2.h>
]],[[
blitz::Array<int,1> x(10);
x = blitz::tensor::i;
	]])],[ac_cv_lib_blitz2="yes"],[ac_cv_lib_blitz2="no"])
	AC_LANG_RESTORE
	])

  if test "$ac_cv_lib_blitz2" = "yes" ; then
	  AC_DEFINE(BLITZ2,1,[Blitz new machinery enabled])
	else
	  dnl "old" Blitz
	  AC_CACHE_CHECK([whether old Blitz++ is installed],[ac_cv_lib_blitz1],
	  [AC_LANG_SAVE
	  AC_LANG([C++])
	  AC_RUN_IFELSE(
	  [AC_LANG_PROGRAM([[
#include <blitz/array.h>
#include <blitz/tinyvec.h>
]],[[
blitz::Array<int,1> x(10);
x = blitz::tensor::i;
	  ]])],[ac_cv_lib_blitz1="yes"],[ac_cv_lib_blitz1="no"])
	  AC_LANG_RESTORE
	  ])
	fi

	CPPFLAGS=$saveCPPFLAGS
	LDFLAGS=$saveLDFLAGS
	LIBS=$saveLIBS

	if test "$ac_cv_lib_blitz2" = "yes" -o "$ac_cv_lib_blitz1" = "yes"; then
		AC_DEFINE([HAVE_BLITZ], [1],[Define Blitz support])
		if test -n "$blitz_incdir"; then BLITZ_CPPFLAGS="-I$blitz_incdir"; fi
		if test -n "$blitz_libdir"; then BLITZ_LDFLAGS="-L$blitz_libdir" ; fi
		BLITZ_LIBS="-lblitz"
	fi

dnl Option to enable thread-safety (requires thread support or OpenMP)
  AC_MSG_CHECKING([whether to enable Blitz thread-safety features])
	AC_ARG_ENABLE(threadsafe-blitz, AS_HELP_STRING([--enable-threadsafe-blitz],
                [Enable Blitz++ thread-safety features @<:@default no@:>@]),
                [enable_threadsafe_blitz="$enableval"],[enable_threadsafe_blitz="no"])
  AC_MSG_RESULT([$enable_threadsafe_blitz])
  if test "$enable_threadsafe_blitz" = "yes"; then
    AC_DEFINE([BZ_THREADSAFE],[1],[Enable Blitz thread-safety features])
  fi

else dnl $withval = no

  ac_cv_lib_blitz="no" 

fi

AC_SUBST(BLITZ_CPPFLAGS)
AC_SUBST(BLITZ_LDFLAGS)
AC_SUBST(BLITZ_LIBS)

AS_IF([test "$ac_cv_lib_blitz" = no], [$2], [$1])

])

AC_DEFUN([AC_MSG_ERROR_BLITZ],[
AC_MSG_ERROR([
$PACKAGE_STRING requires the Blitz++ template library
available at http://sourceforge.net/projects/blitz
])])

