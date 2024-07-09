
/*   prog.c - Test case for stripcomment.

   Said program is supposed to remove the entire first multi-line
   comment from this file.

   * Extra marks like this should not be a problem.

   /* This should not be a problem either.

   Not this ***** /*, nor these //* /**

 */
#define This line stays
/* This is the second comment and should not be removed. */

/* Neither this. */

void foo()			/* This comment should remain. */
{
  /* This comment must remain. */
}
