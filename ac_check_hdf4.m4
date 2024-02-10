dnl @synopsis AC_CHECK_HDF4([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl Check whether HDF4 is installed.
dnl HDF4 is available at http://hdf.ncsa.uiuc.edu
dnl
dnl   Set the path for HDF4 with the option
dnl      --with-hdf4[=DIR] | --with-hdf4=INCDIR,LIBDIR
dnl
dnl HDF4 headers should be under DIR/include or INCDIR
dnl HDF4 library should be under DIR/lib or LIBDIR
dnl
dnl Define and set shell variable ac_lib_hdf4 to 'yes' or 'no'
dnl Substitute variables HDF4_CPPFLAGS, HDF4_LDFLAGS, HDF4_LIBS
dnl Define macro HAVE_HDF4
dnl 
dnl @author Patrick Guio <patrick.guio@matnat.uio.no>
dnl


AC_DEFUN([AC_CHECK_HDF4],[

AC_ARG_WITH(hdf4,
AS_HELP_STRING([--with-hdf4@<:@=DIR@:>@],
               [set path for HDF4 library (DIR or INCDIR,LIBDIR)]),
               [dnl action-if-given 
               ],[dnl action-if-not-given default is check
               with_hdf4='check'
							 ])

ac_lib_hdf4='no'

dnl if without-hdf4 not given
if test "$with_hdf4" != no ; then

  saveCPPFLAGS=$CPPFLAGS
  saveLDFLAGS=$LDFLAGS
  saveLIBS=$LIBS

  case "$with_hdf4" in
    check)
      hdf4_incdir=""
      hdf4_libdir=""
			;;
    *,*)
      hdf4_incdir="`echo $with_hdf4 | cut -f1 -d,`"
      hdf4_libdir="`echo $with_hdf4 | cut -f2 -d, -s`"
      ;;
    *)
      if test -n "$with_hdf4" -a "$with_hdf4" != yes ; then
        hdf4_incdir="$with_hdf4/include"
        hdf4_libdir="$with_hdf4/lib"
      fi
      ;;
  esac

  
dnl  if test -n "$hdf4_incdir"; then CPPFLAGS="$CPPFLAGS -I$hdf4_incdir"; fi
	AC_MSG_CHECKING([for mfhdf.h])
  for ac_hdf4_incdir in $hdf4_incdir "" /usr/local/hdf4.2r1/include \
	       /opt/hdf4.2r1/include \
	       /usr/hdf4.2r1/include /usr/local/include/hdf4.2r1 \
				 /opt/include/hdf4.2r1 /usr/include/hdf4.2r1 /usr/local/hdf/include \
				 /opt/hdf/include /usr/hdf/include /usr/local/include/hdf \
				 /opt/include/hdf /usr/include/hdf ; do
				 if test -n "$ac_hdf4_incdir" ; then CPPFLAGS="$CPPFLAGS -I$ac_hdf4_incdir"; fi
				 dnl AC_CHECK_HEADER([mfhdf.h],[],[],[-I$ac_hdf4_incdir])
				 dnl AC_MSG_CHECKING([for mfhdf.h in $ac_hdf4_incdir])
				 AC_COMPILE_IFELSE(
				 [AC_LANG_PROGRAM([[#include <mfhdf.h>]],[[]])],
         [ac_cv_header_mfhdf_h=yes],[ac_cv_header_mfhdf_h=no]
         dnl [AC_MSG_RESULT([yes])],[AC_MSG_RESULT([no])]
				 )
				 if test "$ac_cv_header_mfhdf_h" = "yes"; then
				   dnl AC_MSG_NOTICE([mfhdf.h found in $ac_hdf4_incdir])
				   break
         else
           unset ac_cv_header_mfhdf_h
				 fi
	done
	if test "$ac_cv_header_mfhdf_h" = "yes"; then
		  AC_MSG_RESULT([yes (in $ac_hdf4_incdir)])
     else
      AC_MSG_RESULT([no]) 
	 fi

  if test -n "$hdf4_libdir"; then LDFLAGS="$LDFLAGS -L$hdf4_libdir" ; fi
	LIBS=""
dnl AC_MSG_CHECKING([for -lmfhdf])
  for ac_hdf4_libdir in $hdf4_incdir "" /usr/local/hdf4.2r1/lib64 \
        /opt/hdf4.2r1/lib64 \ 
       /usr/hdf4.2r1/lib64 /usr/local/lib64/hdf4.2r1 /opt/lib64/hdf4.2r1 \
       /usr/lib64/hdf4.2r1 /usr/local/hdf/lib64/ /opt/hdf/lib64 /usr/hdf/lib64 \
       /usr/local/lib64/hdf /opt/lib64/hdf /usr/lib64/hdf \
       /usr/local/hdf4.2r1/lib /opt/hdf4.2r1/lib \ 
       /usr/hdf4.2r1/lib /usr/local/lib/hdf4.2r1 /opt/lib/hdf4.2r1 \
       /usr/lib/hdf4.2r1 /usr/local/hdf/lib/ /opt/hdf/lib /usr/hdf/lib \
       /usr/local/lib/hdf /opt/lib/hdf /usr/lib/hdf ; do
       if test -n "$ac_hdf4_libdir" ; then LDFLAGS="$LDFLAGS -L$ac_hdf4_libdir"; fi
		dnl	 echo LDFLAGS=$LDFLAGS
  AC_CHECK_LIB(mfhdf,SDstart,[lib="-lmfhdf -ldf -ljpeg -lz"],
	[unset ac_cv_lib_mfhdf_SDstart 
	AC_CHECK_LIB(mfhdf,SDstart,[lib="-lmfhdf -ldf -ljpeg -lz -ltirpc"],
		[unset ac_cv_lib_mfhdf_SDstart
	AC_CHECK_LIB(mfhdf,SDstart,[lib="-lmfhdf -ldf -ljpeg -lz -lnsl"],
		[unset ac_cv_lib_mfhdf_SDstart
		AC_CHECK_LIB(mfhdf,SDstart,[lib="-lmfhdf -ldf -lsz -ljpeg -lz"],
			[unset ac_cv_lib_mfhdf_SDstart
			AC_CHECK_LIB(mfhdf,SDstart,[lib="-lmfhdf -noso -ldf -ljpeg -lz -so_archive"],
				[unset ac_cv_lib_mfhdf_SDstart
				AC_CHECK_LIB(mfhdf,SDstart,[lib="-lmfhdf -noso -ldf -lsz -ljpeg -lz -so_archive"],
				    [unset ac_cv_lib_mfhdf_SDstart],[-noso -ldf -lsz -ljpeg -lz -so_archive])
						],
						[-noso -ldf -ljpeg -lz -so_archive])],
						[-ldf -lsz -ljpeg -lz])],
						[-ldf -ljpeg -lz -lnsl])],
						[-ldf -ljpeg -lz -ltirpc])],
						[-ldf -ljpeg -lz])
				if test "$ac_cv_lib_mfhdf_SDstart"="yes"; then
dnl				  echo -L$ac_hdf4_libdir $lib
				  break
				fi
  done

dnl	if test -z "$ac_cv_lib_mfhdf_SDstart" ; then
dnl		AC_SEARCH_LIBS(SDstart,mfhdf,[lib="-lmfhdf -ldf -ljpeg -lz"],
dnl		[unset ac_cv_lib_mfhdf_SDstart],[-ldf -ljpeg -lz])
dnl	fi

dnl	if test -z "$ac_cv_lib_mfhdf_SDstart" ; then
dnl	  AC_CHECK_LIB(mfhdf,SDstart,[lib="-lmfhdf -ldf -ljpeg -lz -lnsl"],
dnl		[unset ac_cv_lib_mfhdf_SDstart],[-ldf -ljpeg -lz -lnsl])
dnl	fi

dnl	if test -z "$ac_cv_lib_mfhdf_SDstart" ; then
dnl		AC_CHECK_LIB(mfhdf,SDstart,[lib="-lmfhdf -ldf -lsz -ljpeg -lz"],
dnl		[unset ac_cv_lib_mfhdf_SDstart],[-ldf -lsz -ljpeg -lz])
dnl	fi

dnl the -noso/-so_archive options are to handle OSF1 machines 
dnl and force not to use dynamic libs
dnl	if test -z "$ac_cv_lib_mfhdf_SDstart" ; then
dnl		AC_CHECK_LIB(mfhdf,SDstart,[lib="-lmfhdf -noso -ldf -ljpeg -lz -so_archive"],
dnl		[unset ac_cv_lib_mfhdf_SDstart],[-noso -ldf -ljpeg -lz -so_archive])
dnl	fi

dnl	if test -z "$ac_cv_lib_mfhdf_SDstart" ; then
dnl		AC_CHECK_LIB(mfhdf,SDstart,[lib="-lmfhdf -noso -ldf -lsz -ljpeg -lz -so_archive"],
dnl		[unset ac_cv_lib_mfhdf_SDstart],[-noso -ldf -lsz -ljpeg -lz -so_archive])
dnl	fi

	CPPFLAGS=$saveCPPFLAGS
	LDFLAGS=$saveLDFLAGS
	LIBS=$saveLIBS

	if test "$ac_cv_lib_mfhdf_SDstart" = yes ; then

	  ac_lib_hdf4='yes'
		AC_DEFINE([HAVE_HDF4],[1],[Define HDF4 support])
		if test -n "$hdf4_incdir" ; then HDF4_CPPFLAGS="-I$hdf4_incdir"; fi
		if test -n "$hdf4_libdir" ; then HDF4_LDFLAGS="-L$hdf4_libdir" ; fi
		if test -n "$lib" ; then HDF4_LIBS="$lib"; fi
		case "$target" in
		*ia64*)
			AC_DEFINE([IA64],[1],[Itanium flag])
			;;
		esac

	fi

fi

AC_SUBST(HDF4_CPPFLAGS)
AC_SUBST(HDF4_LDFLAGS)
AC_SUBST(HDF4_LIBS)

dnl if hdf4 not found or --without-hdf4 given execute [ACTION-IF-FOUND]
dnl otherwise execute [ACTION-IF-NOT-FOUND] if any of these given
AS_IF([test "$ac_lib_hdf4" = no], [$2], [$1])

])


AC_DEFUN([AC_MSG_ERROR_HDF4],[AC_MSG_ERROR([
$PACKAGE_STRING requires the HDF4 library
available at http://hdf.ncsa.uiuc.edu
])])

