dnl @synopsis AC_CHECK_ARMA([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl Check whether Armadillo is installed.
dnl Armadillo is available at http://arma.sourceforge.net
dnl
dnl   Set the path for Armadillo with the option
dnl      --with-arma[=DIR] | --with-arma[=INCDIR,LIBDIR]
dnl 
dnl   Armadillo headers should be under DIR/include or INCDIR
dnl   Armadillo library should be under DIR/lib or LIBDIR
dnl
dnl  
dnl Substitute variables ARMADILLO_CPPFLAGS, ARMADILLO_LDFLAGS, ARMA_LIBS
dnl Define macro HAVE_ARMA
dnl 
dnl @author Patrick Guio <patrick.guio@gmail.com>
dnl

AC_DEFUN([AC_CHECK_ARMA],[


AC_ARG_WITH(arma,
AS_HELP_STRING([--with-arma@<:@=DIR@:>@], 
               [set path for Armadillo library (DIR or INCDIR,LIBDIR)]),
            [dnl action-if-given 
             ],
            [dnl action-if-not-given default is yes
             withval='yes'])

if test "$withval" != no ; then

  saveCPPFLAGS=$CPPFLAGS
	saveLDFLAGS=$LDFLAGS
	saveLIBS=$LIBS

  case "$withval" in
		*,*)
      arma_incdir="`echo $withval | cut -f1 -d,`"
			arma_libdir="`echo $withval | cut -f2 -d, -s`"
			;;
		*)
		  if test -n "$withval" -a "$withval" != yes ; then
			  arma_incdir="$withval/include"
				arma_libdir="$withval/lib"
			fi
			;;
	esac

  if test -n "$arma_incdir"; then CPPFLAGS="-I$arma_incdir"; fi
  if test -n "$arma_libdir"; then LDFLAGS="-L$arma_libdir" ; fi
	if test -z "$ARMA_LIBS"; then
	  LIBS="-larmadillo"
  else
    LIBS=$ARMA_LIBS
  fi

	AC_CACHE_CHECK([whether Armadillo is installed],[ac_cv_lib_arma],
	[AC_LANG_SAVE
	AC_LANG([C++])
	AC_RUN_IFELSE(
	[AC_LANG_PROGRAM([[
#include <armadillo>
]],[[
// matrix construction from a string representation
arma::mat A = \
  "\
  0.555950  0.274690  0.540605  0.798938;\
  0.108929  0.830123  0.891726  0.895283;\
  0.948014  0.973234  0.216504  0.883152;\
  0.023787  0.675382  0.231751  0.450332;\
  ";
arma::mat B = arma::eye(4,4); 
arma::mat C = A + B;
	]])],[ac_cv_lib_arma="yes"],[ac_cv_lib_arma="no"])
	AC_LANG_RESTORE
	])

	if test "$ac_cv_lib_arma" = "yes" ; then
		AC_DEFINE([HAVE_ARMA], [1],[Define Armadillo support])
		if test -n "$arma_incdir"; then ARMA_CPPFLAGS="-I$arma_incdir"; fi
		if test -n "$arma_libdir"; then ARMA_LDFLAGS="-L$arma_libdir" ; fi
		ARMA_LIBS="$LIBS"
	fi

	CPPFLAGS=$saveCPPFLAGS
	LDFLAGS=$saveLDFLAGS
	LIBS=$saveLIBS

else dnl $withval = no

  ac_cv_lib_arma="no" 

fi

AC_SUBST(ARMA_CPPFLAGS)
AC_SUBST(ARMA_LDFLAGS)
AC_SUBST(ARMA_LIBS)

AC_ARG_VAR([ARMA_LIBS],[Armadillo libraries, default value -larmadillo])

AS_IF([test "$ac_cv_lib_arma" = no], [$2], [$1])

])

AC_DEFUN([AC_MSG_ERROR_ARMA],[
AC_MSG_ERROR([
$PACKAGE_STRING requires the Armadillo C++ linear algebra library
available at http://arma.sourceforge.net
])])

