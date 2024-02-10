

AC_DEFUN([AC_ENABLE_GNUPLOT],[

AC_MSG_CHECKING([whether to enable Gnuplot support])
AC_ARG_ENABLE(gnuplot,
	AS_HELP_STRING([--enable-gnuplot],[Enable Gnuplot support (default=no)]),,[
	enable_gnuplot="no"])
AC_MSG_RESULT([$enable_gnuplot])

AM_CONDITIONAL(GNUPLOT_ENABLED, [test "$enable_gnuplot" == "yes"])
if test $enable_gnuplot = yes; then
	AC_DEFINE([HAVE_GNUPLOT])
fi

])


