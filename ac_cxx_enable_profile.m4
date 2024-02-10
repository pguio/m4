
AC_DEFUN([AC_CXX_ENABLE_PROFILE],[

AC_MSG_CHECKING([whether to enable $CXX profiling flags])
AC_ARG_ENABLE(profile,
AS_HELP_STRING([--enable-profile],[enable compiler profiling flags]),
[if test "$enableval" = yes; then
  AC_MSG_RESULT([yes])
  CXXFLAGS="$CXXFLAGS $CXX_PROFIL_FLAGS"
fi],[AC_MSG_RESULT([no])])
AC_ARG_VAR([CXX_PROFIL_FLAGS],[C++ compiler profiling flags])
])
