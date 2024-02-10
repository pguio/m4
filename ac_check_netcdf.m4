dnl @synopsis AC_CHECK_NETCDF([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl Check whether NetCDF is installed.
	dnl NetCDF is available at http://www.unidata.ucar.edu/software/netcdf
dnl
dnl   Set the path for NetCDF  with the option
dnl      --with-netcdf[=DIR] | --with-netcdf=INCDIR,LIBDIR
dnl
dnl NetCDF headers should be under DIR/include or INCDIR
dnl NetCDF library should be under DIR/lib or LIBDIR
dnl
dnl Define and set the following shell variables
dnl    ac_lib_netcdf to 'yes' or 'no'
dnl    ac_cv_finc_netcdf to 'yes' or 'no'
dnl    ac_cv_flib_netcdf to 'yes' or 'no'
dnl    ac_cv_fclib_netcdf to 'yes' or 'no'
dnl Substitute environment variable NETCDF_FLIBS NETCDF_FCLIBS
dnl Substitute variables NETCDF_CPPFLAGS, NETCDF_LDFLAGS, NETCDF_LIBS, NETCDF_FLIBS NETCDF_FCLIBS
dnl Define macro HAVE_NETCDF
dnl 
dnl @author Patrick Guio <p.guio@ucl.ac.uk>
dnl


AC_DEFUN([AC_CHECK_NETCDF],[

AC_ARG_WITH(netcdf,
AS_HELP_STRING([--with-netcdf@<:@=DIR@:>@],
               [set the path for the NetCDF library (DIR or INCDIR,LIBDIR)]),
               [dnl action-if-given
               ], [dnl action-if-not-given default is no
               withval='no'])

if test "$withval" != no ; then

	AC_LANG_SAVE

  dnl checking for C interface
	AC_LANG(C)

	saveCPPFLAGS=$CPPFLAGS
	saveLDFLAGS=$LDFLAGS
	saveLIBS=$LIBS

  case "$withval" in
    *,*)
      netcdf_incdir="`echo $withval | cut -f1 -d,`"
      netcdf_libdir="`echo $withval | cut -f2 -d, -s`"
      ;;
    *)
      if test -n "$withval" -a "$withval" != yes ; then
        netcdf_incdir="$withval/include"
        netcdf_libdir="$withval/lib"
      fi
      ;;
  esac

  if test -n "$netcdf_incdir"; then CPPFLAGS="$CPPFLAGS -I$netcdf_incdir"; fi
  if test -n "$netcdf_libdir"; then LDFLAGS="$LDFLAGS -L$netcdf_libdir" ; fi
	LIBS=""

	AC_CHECK_LIB(netcdf,ncopen,[ dnl action-if-found
	AC_DEFINE([HAVE_NETCDF],[1],[Define NetCDF support])
	if test -n "$netcdf_incdir"; then NETCDF_CPPFLAGS="-I$netcdf_incdir"; fi
	if test -n "$netcdf_libdir"; then NETCDF_LDFLAGS="-L$netcdf_libdir" ; fi
	NETCDF_LIBS="-lnetcdf"
	ac_lib_netcdf='yes'],[ dnl action-if-not-found
	ac_lib_netcdf='no'],[-lnetcdf -lm])

  dnl checking for Fortran 77 interface
	AC_LANG(Fortran 77)

	saveFFLAGS=$FFLAGS
	if test -n "$netcdf_incdir"; then FFLAGS="-I$netcdf_incdir"; fi

	AC_CACHE_CHECK([whether netcdf.inc is installed],[ac_cv_finc_netcdf],
	[AC_COMPILE_IFELSE(
	[AC_LANG_PROGRAM([],[[      include "netcdf.inc"]])],
	[ac_cv_finc_netcdf='yes'],[ac_cv_finc_netcdf='no'])
	])

	if test -z "$NETCDF_FLIBS"; then
		LIBS="-lnetcdf -lnetcdff"
	else
		LIBS=$NETCDF_FLIBS
	fi
	AC_CACHE_CHECK([for nf_open in $LIBS],[ac_cv_flib_netcdf],
	[AC_LINK_IFELSE(
	[AC_LANG_PROGRAM([],[[
       include "netcdf.inc"
       integer ierr
       character*255 datfile
       integer unetm
       ierr=NF_OPEN(datfile,NF_NOWRITE,unetm)
	]])],
	[ac_cv_flib_netcdf='yes';NETCDF_FLIBS="$LIBS"],[ac_cv_flib_netcdf='no'])
	])

  dnl checking for Fortran 90 interface
	AC_LANG(Fortran)

	saveFCFLAGS=$FCFLAGS
	if test -n "$netcdf_incdir"; then FCFLAGS="-I$netcdf_incdir"; fi

	AC_CACHE_CHECK([whether netcdf.inc is installed],[ac_cv_finc_netcdf],
	[AC_COMPILE_IFELSE(
	[AC_LANG_PROGRAM([],[[      include "netcdf.inc"]])],
	[ac_cv_finc_netcdf='yes'],[ac_cv_finc_netcdf='no'])
	])

	if test -z "$NETCDF_FCLIBS"; then
		LIBS="-lnetcdf -lnetcdff"
	else
		LIBS=$NETCDF_FCLIBS
	fi
	AC_CACHE_CHECK([for nf_open in $LIBS],[ac_cv_fclib_netcdf],
	[AC_LINK_IFELSE(
	[AC_LANG_PROGRAM([],[[
       include "netcdf.inc"
       integer ierr
       character*255 datfile
       integer unetm
       ierr=NF_OPEN(datfile,NF_NOWRITE,unetm)
	]])],
	[ac_cv_fclib_netcdf='yes';NETCDF_FCLIBS="$LIBS"],[ac_cv_fclib_netcdf='no'])
	])

	CPPFLAGS=$saveCPPFLAGS
	CPPFLAGS=$saveCPPFLAGS
	LDFLAGS=$saveLDFLAGS
	LIBS=$saveLIBS
	FFLAGS=$saveFFLAGS
	FCFLAGS=$saveFCFLAGS

	AC_LANG_RESTORE

else dnl $withval = no

  ac_lib_netcdf='no'

fi

AC_SUBST(NETCDF_CPPFLAGS)
AC_SUBST(NETCDF_LDFLAGS)
AC_SUBST(NETCDF_LIBS)
AC_SUBST(NETCDF_FLIBS)
AC_SUBST(NETCDF_FCLIBS)

AC_ARG_VAR(NETCDF_FLIBS,[NetCDF Fortran 77 libraries])
AC_ARG_VAR(NETCDF_FCLIBS,[NetCDF Fortran 90 libraries])

AS_IF([test "$ac_lib_netcdf" = no], [$2], [$1])


])


AC_DEFUN([AC_MSG_ERROR_NETCDF],[AC_MSG_ERROR([
$PACKAGE_STRING requires the NetCDF library
available at http://www.unidata.ucar.edu/software/netcdf
])])
