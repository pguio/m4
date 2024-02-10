

AC_DEFUN([AC_CXX_MPI],[

AC_ARG_ENABLE(mpi,
AS_HELP_STRING([--enable-mpi],[enable compilation with MPI support]),
[enable_mpi=$enableval], [enable_mpi='no'])
if test "$enable_mpi" = "yes"; then 
  AC_MSG_NOTICE([MPI enabled])
fi

AC_ARG_WITH(mpi,
AS_HELP_STRING([--with-mpi@<:@=DIR@:>@],[set path for MPI library (DIR or INCDIR,LIBDIR)]),
               [],[withval='no'])

case "$withval" in
	*,*)
	  mpi_incdir="`echo $withval | cut -f1 -d,`"
	  mpi_libdir="`echo $withval | cut -f2 -d, -s`"
	;;
	*)
		if test -n "$withval" -a "$withval" != yes -a "$withval" != no; then
			mpi_incdir="$withval/include"
			mpi_libdir="$withval/lib"
		fi
	;;
esac

dnl Try to substitute MPILIBS, the libraries to link for MPI support
AC_ARG_WITH(mpilibs,
AS_HELP_STRING([--with-mpilibs@<:@="-llib1 -llib2 ..."@:>@], [set library list for MPI support]), 
[MPILIBS="$withval"],MPILIBS="")

dnl If MPI is enabled

if test "$enable_mpi" = "yes"; then

	saveCXX=$CXX
	saveCPPFLAGS=$CPPFLAGS
	saveLDFLAGS=$LDFLAGS
	saveLIBS=$LIBS

  dnl  First try to see if an mpi/c++ compiler is present
	dnl  variable MPICXX is substituted
  AC_CHECK_PROGS(MPICXX, mpic++ mpiCC mpCC_r mpCC hCC, $CXX)
  CXX="$MPICXX"
	CPPFLAGS=""
	LDFLAGS=""
	LIBS=""

  if test -n "$mpi_incdir"; then CPPFLAGS="-I$mpi_incdir"; fi
	if test -n "$mpi_libdir"; then LDFLAGS="-L$mpi_libdir" ; fi
	if test -n "$MPILIBS"; then LIBS="$MPILIBS"; fi

  if test "X$CXX" = Xcxx && test -z "$MPI" && test -z "$MPILIBS"; then
    LIBS="-lmpi -lrt -pthread"
  fi
  if test "X$CXX" = XCC && test -z "$MPI" && test -z "$MPILIBS"; then
    CPPFLAGS="-DMPI_NO_CPPBIND"
    LIBS="-lmpi"
  fi

	AC_CACHE_CHECK(whether $MPICXX compiler works, ac_cv_cxx_mpi,
	[AC_LANG_SAVE
	AC_LANG([C++])
	AC_COMPILE_IFELSE(
	  [AC_LANG_PROGRAM([[#include <mpi.h>]],
[[
int nargs; 
char **args;
MPI_Init(&nargs,&args);
]])], ac_cv_cxx_mpi=yes, ac_cv_cxx_mpi=no)
	AC_LANG_RESTORE
	])
	if test "$ac_cv_cxx_mpi" = yes; then
  	AC_DEFINE([HAVE_MPI],[1],[Define MPI support])
		CPPFLAGS="$CPPFLAGS $saveCPPFLAGS"
		LDFLAGS="$LDFLAGS $saveLDFLAGS"
		LIBS="$LIBS $saveLIBS"
	fi
	if test "$enable_mpi" = yes && test "$ac_cv_cxx_mpi" = no; then
	  AC_MSG_ERROR([
MPI enabled but $MPICXX compiler does not work properly.
Check the compiler flag:
CXXFLAGS = $CXXFLAGS])
  fi
fi

AC_ARG_VAR([MPICXX],[MPI C++ compiler/compiler wrapper])

])
