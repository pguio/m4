dnl @synopsis AC_CHECK_HDF5([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl Check whether HDF5 is installed.
dnl HDF4 is available at http://hdf.ncsa.uiuc.edu
dnl
dnl   Set the path for HDF5 with the option
dnl      --with-hdf5[=DIR] | --with-hdf5=INCDIR,LIBDIR
dnl 
dnl HDF5 headers should be under DIR/include or INCDIR
dnl HDF5 library should be under DIR/lib or LIBDIR
dnl
dnl Define and set shell variable ac_lib_hdf5 to 'yes' or 'no'
dnl Substitute variables HDF5_CPPFLAGS, HDF5_LDFLAGS, HDF5_LIBS
dnl Define macro HAVE_HDF5
dnl 
dnl @author Patrick Guio <patrick.guio@matnat.uio.no>
dnl


AC_DEFUN([AC_CHECK_HDF5],[

AC_ARG_WITH(hdf5,
AS_HELP_STRING([--with-hdf5@<:@=DIR@:>@],
               [set the path for the HDF5 library (DIR or INCDIR,LIBDIR)]),
               [dnl action-if-given
               ],[dnl action-if-not-given default is no
               withval='no'])

if test "$withval" != no ; then

  saveCPPFLAGS=$CPPFLAGS
  saveLDFLAGS=$LDFLAGS
  saveLIBS=$LIBS

  case "$withval" in
    *,*)
      hdf5_incdir="`echo $withval | cut -f1 -d,`"
      hdf5_libdir="`echo $withval | cut -f2 -d, -s`"
      ;;
    *)
      if test -n "$withval" -a "$withval" != yes ; then
        hdf5_incdir="$withval/include"
        hdf5_libdir="$withval/lib"
      fi
      ;;
  esac

  if test -n "$hdf5_incdir"; then CPPFLAGS="$CPPFLAGS -I$hdf5_incdir"; fi
  if test -n "$hdf5_libdir"; then LDFLAGS="$LDFLAGS -L$hdf5_libdir" ; fi
	LIBS=""


	AC_MSG_CHECKING([whether to enable hdf5 high-level library])
	AC_ARG_ENABLE(hdf5-hl, AS_HELP_STRING([--enable-hdf5-hl],
	              [Enable hdf5 high-level library]),
	              [enable_hdf5_hl="yes"
								hdf5="-lhdf5 -lhdf5_hl"],
								[enable_hdf5_hl="no"
								hdf5="-lhdf5"])
	AC_MSG_RESULT([$enable_hdf5_hl])

	if test -z "$ac_cv_lib_hdf5_H5Fcreate" ; then
		AC_CHECK_LIB(hdf5,H5Fcreate,[lib="$hdf5 -lz"],
		[unset ac_cv_lib_hdf5_H5Fcreate],[-lz])
	fi

	if test -z "$ac_cv_lib_hdf5_H5Fcreate" ; then
		AC_CHECK_LIB(hdf5,H5Fcreate,[lib="$hdf5 -lz -lnsl"],
		[unset ac_cv_lib_hdf5_H5Fcreate],[-lz -lnsl])
	fi

	if test -z "$ac_cv_lib_hdf5_H5Fcreate" ; then
		AC_CHECK_LIB(hdf5,H5Fcreate,[lib="$hdf5 -lsz -lz"],
		[unset ac_cv_lib_hdf5_H5Fcreate],[-lsz -lz])
	fi

dnl the -noso/-so_archive options are to handle OSF1 machines 
dnl and force not to use dynamic libs
	if test -z "$ac_cv_lib_hdf5_H5Fcreate" ; then
		AC_CHECK_LIB(hdf5,H5Fcreate,[lib="$hdf5hdf5 -noso -lz -so_archive"],
		[unset ac_cv_lib_hdf5_H5Fcreate],[-noso -lz -so_archive])
	fi

	if test -z "$ac_cv_lib_hdf5_H5Fcreate" ; then
		AC_CHECK_LIB(hdf5,H5Fcreate,[lib="$hdf5 -noso -lsz -lz -so_archive"],
		[unset ac_cv_lib_hdf5_H5Fcreate],[-noso -lsz -lz -so_archive])
	fi

	CPPFLAGS=$saveCPPFLAGS
	LDFLAGS=$saveLDFLAGS
	LIBS=$saveLIBS

	if test "$ac_cv_lib_hdf5_H5Fcreate" = yes ; then

    ac_lib_hdf5='yes'
		AC_DEFINE([HAVE_HDF5],[1],[Define HDF5 support])
		if test -n "$hdf5_incdir" ; then HDF5_CPPFLAGS="-I$hdf5_incdir"; fi
		if test -n "$hdf5_libdir" ; then HDF5_LDFLAGS="-L$hdf5_libdir" ; fi
		if test -n "$lib" ; then HDF5_LIBS="$lib"; fi
		case "$target" in
		*ia64*)
			AC_DEFINE([IA64],[1],[Itanium flag])
			;;
		esac

	else

	  ac_lib_hdf5='no'

	fi

else dnl $withval = no

  ac_lib_hdf5='no'

fi

AC_SUBST(HDF5_CPPFLAGS)
AC_SUBST(HDF5_LDFLAGS)
AC_SUBST(HDF5_LIBS)

AS_IF([test "$ac_lib_hdf5" = no], [$2], [$1])


])

AC_DEFUN([AC_MSG_ERROR_HDF5],[AC_MSG_ERROR([
$PACKAGE_STRING requires the HDF5 library
available at http://hdf.ncsa.uiuc.edu
])])
