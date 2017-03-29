      SUBROUTINE DTRRNK( N, R, LDR, RCOND, RANK, WORK, INFO )
*
*     : 1.84 $
*     : 96/12/30 16:59:21 $
*
*     .. Scalar Arguments ..
      INTEGER            LDR, N, RANK, INFO
      DOUBLE PRECISION   RCOND
*     ..
*     .. Array Arguments ..
      DOUBLE PRECISION   R( LDR, * ), WORK( * )
*
*  Purpose
*  =======
*
*  DTRRNK computes an estimate for the numerical rank of a
*  triangular n-by-n matrix R.
*
*  Arguments
*  =========
*
*  N       (input) INTEGER
*          Number of rows and columns of the matrix R.  N >= 0.
*
*  R       (input) DOUBLE PRECISION array, dimension (LDR,N)
*          On entry, the n by n matrix R.
*
*  LDR     (input) INTEGER
*          The leading dimension of the array R. LDR >= max(1,N).
*
*  RCOND   (input) DOUBLE PRECISION
*          Threshold value for the numerical rank.
*
*  RANK    (output) INTEGER
*          Numerical rank for threshold RCOND.
*
*  WORK    (workspace) DOUBLE PRECISION array, dimension (2*N)
*
*  INFO    (output) INTEGER
*          = 0:  Successful exit.
*          < 0:  If INFO = -i, the i-th argument had an illegal value.
*
*  =====================================================================
*
*     .. Parameters ..
      DOUBLE PRECISION   ONE, ZERO
      PARAMETER          ( ONE = 1.0D+0, ZERO = 0.0D+0 )
*     ..
*     .. Local Scalars ..
      INTEGER            I
      DOUBLE PRECISION   C1, C2, SMAX, SMAXPR, SMIN, SMINPR, S1, S2
*     ..
*     .. External Subroutines ..
      EXTERNAL           DLAIC1
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          ABS, MAX, MIN
*     ..
*     .. Executable statements ..
*
*     Test the input arguments
*
      INFO = 0
      IF( N.LT.0 ) THEN
         INFO = -1
      ELSE IF( LDR.LT.MAX( 1, N ) ) THEN
         INFO = -3
      END IF
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'DTRRNK', -INFO )
         RETURN
      END IF
*
*     Determine RANK using incremental condition estimation.
*
      WORK( 1 ) = ONE
      WORK( N+1 ) = ONE
      SMAX = ABS( R( 1, 1 ) )
      SMIN = SMAX
      IF( ABS( R( 1, 1 ) ).EQ.ZERO ) THEN
         RANK = 0
         GO TO 30
      ELSE
         RANK = 1
      END IF
*
   10 CONTINUE
      IF( RANK.LT.N ) THEN
         I = RANK + 1
         CALL DLAIC1( 2, RANK, WORK, SMIN, R( 1, I ),
     $                R( I, I ), SMINPR, S1, C1 )
         CALL DLAIC1( 1, RANK, WORK( N+1 ), SMAX, R( 1, I ),
     $                R( I, I ), SMAXPR, S2, C2 )
*
         IF( ( SMAXPR*RCOND ).LE.SMINPR ) THEN
            DO 20 I = 1, RANK
               WORK( I ) = S1*WORK( I )
               WORK( N+I ) = S2*WORK( N+I )
   20       CONTINUE
            WORK( RANK+1 )   = C1
            WORK( N+RANK+1 ) = C2
            SMIN = SMINPR
            SMAX = SMAXPR
            RANK = RANK + 1
            GO TO 10
         END IF
      END IF
   30 CONTINUE
*
      RETURN
*
*     End of DTRRNK
*
      END
