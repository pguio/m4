# AC_PROG_MEX
# ---------
# Check for mex compiler
AC_DEFUN([AC_PROG_MEX],
[

AC_ARG_VAR([MEX],     [mex compiler command])dnl
AC_ARG_VAR([MEXFLAGS], [mex compiler flags])dnl
AC_ARG_VAR([MEXLDADD], [mex extra libraries])dnl

if test -z "$MEX"; then
	AC_CHECK_TOOL(MEX, mex)
fi

test -z "$MEX" && AC_MSG_FAILURE([no acceptable mex compiler found in \$PATH])


MEX_MEXEXT
])



# MEX_MEXEXT
# ---------
# Check for MEX-file suffix.
AC_DEFUN([MEX_MEXEXT],
[
AC_CACHE_CHECK([for MEX-file suffix], [mx_cv_mexext],
[if test "${MEXEXT+set}" = set ; then
    mx_cv_mexext="$MEXEXT"
else
    echo 'int mexFunction () {}' > mx_c_test.c
    $MEX $MEXFLAGS mx_c_test.c $MEXLDADD 2> /dev/null 1>&2
		if test -f mx_c_test.dll ; then
			mx_cv_mexext=dll
		elif test -f mx_c_test.mex ; then
			mx_cv_mexext=mex
		elif test -f mx_c_test.mexa64 ; then
			mx_cv_mexext=mexa64
		elif test -f mx_c_test.mexaxp ; then
			mx_cv_mexext=mexaxp
		elif test -f mx_c_test.mexlx ; then
			mx_cv_mexext=mexlx
		elif test -f mx_c_test.mexglx ; then
			mx_cv_mexext=mexglx
		elif test -f mx_c_test.mexhp7 ; then
			mx_cv_mexext=mexhp7
		elif test -f mx_c_test.mexhpux ; then
			mx_cv_mexext=mexhpux
		elif test -f mx_c_test.mexrs6 ; then
			mx_cv_mexext=mexrs6
		elif test -f mx_c_test.mexsg ; then
			mx_cv_mexext=mexsg
		elif test -f mx_c_test.mexsol ; then
			mx_cv_mexext=mexsol
		else
			mx_cv_mexext=unknown
		fi
		rm -f mx_c_test*
fi])
MEXEXT="$mx_cv_mexext"
AC_SUBST(MEXEXT)
])
