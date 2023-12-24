These are the shell scripts used to build the J9.6 pcre2 shared libraries.

In each case, check the paths set in each script for R and S are correct.

The S path is the pcre2 svn, revision 912 at the time of build.

On linux, run:

  makelinux.sh   builds l64 and l32
  makewin.sh     builds w64 and w32 (uses mingw)

On OSX, run:

  makeosx.sh     builds m64

On Android, run:

  copy Android.mk to pcre2 folder
