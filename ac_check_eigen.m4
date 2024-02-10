dnl @synopsis AC_CHECK_EIGEN([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl Check whether Eigen is installed.
dnl Eigen is available at http://eigen.tuxfamily.org
dnl
dnl   Set the path for Eigen with the option
dnl      --with-eigen[=DIR] 
dnl 
dnl   Eigen headers should be under DIR
dnl  
dnl Substitute variables EIGEN_CPPFLAGS
dnl Define macro HAVE_EIGEN
dnl 
dnl @author Patrick Guio <patrick.guio@gmail.com>
dnl

AC_DEFUN([AC_CHECK_EIGEN],[


AC_ARG_WITH(eigen,
AS_HELP_STRING([--with-eigen@<:@=DIR@:>@], 
               [set path for Eigen library (DIR)]),
               [dnl action-if-given 
               ], [dnl action-if-not-given default is yes
               withval='yes'])

if test "$withval" != no ; then

  saveCPPFLAGS=$CPPFLAGS

  case "$withval" in
		*)
		  if test -n "$withval" -a "$withval" != yes ; then
			  eigen_incdir="$withval"
			fi
			;;
	esac

  if test -n "$eigen_incdir"; then CPPFLAGS="-I$eigen_incdir"; fi
	LIBS=""

  dnl Eigen3
	AC_CACHE_CHECK([whether Eigen3 is installed],[ac_cv_lib_eigen3],
	[AC_LANG_SAVE
	AC_LANG([C++])
	AC_RUN_IFELSE(
	[AC_LANG_PROGRAM([[
// Eigen3
#include <Eigen/Core>
using namespace Eigen;
]],[[
Matrix4f m4 = Matrix4f::Identity();
	]])],[ac_cv_lib_eigen3="yes"],[ac_cv_lib_eigen3="no"])
	AC_LANG_RESTORE
	])

  if test "$ac_cv_lib_eigen3" = "yes" ; then
    AC_DEFINE(EIGEN3,1,[Eigen 3 enabled])
  else
	  dnl Eigen2
		AC_CACHE_CHECK([whether Eigen2 is installed],[ac_cv_lib_eigen2],
		[AC_LANG_SAVE
    AC_LANG([C++])
    AC_RUN_IFELSE(
   [AC_LANG_PROGRAM([[
// Eigen2
#include <Eigen/Core>
// import most common Eigen types
USING_PART_OF_NAMESPACE_EIGEN
]],[[
Matrix4f m4 = Matrix4f::Identity();
  ]])],[ac_cv_lib_eigen2="yes"],[ac_cv_lib_eigen2="no"])
   AC_LANG_RESTORE
   ])
  fi

	CPPFLAGS=$saveCPPFLAGS

	if test "$ac_cv_lib_eigen3" = "yes" -o "$ac_cv_lib_eigen2" = "yes" ; then
		AC_DEFINE([HAVE_EIGEN], [1],[Define Eigen support])
		if test -n "$eigen_incdir"; then EIGEN_CPPFLAGS="-I$eigen_incdir"; fi
	fi

else dnl $withval = no

  ac_cv_lib_eigen="no" 

fi

AC_SUBST(EIGEN_CPPFLAGS)

AS_IF([test "$ac_cv_lib_eigen" = no], [$2], [$1])

])

AC_DEFUN([AC_MSG_ERROR_EIGEN],[
AC_MSG_ERROR([
$PACKAGE_STRING requires the Eigen template library
available at http://eigen.tuxfamily.org/
])])

