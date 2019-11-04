# include "mex.h"
# include "math.h"
/*[ DAG, K2Score ] = K2( LGObj,Order,u,PreDAG ) */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

  int p,q,i,j,d,t,X,Dim=0,DimC=0,DimF=0,CaseLength,RangeRow,CurrentPos;
  int n,m,ParentLen,MaxParent=0,XLen,VarLen,LocalNode;
  double *K2Score,*Temp,Miss,PoldScore,LocalMax,LocalScore;

  Dim = (int)mxGetScalar( mxGetField( prhs[0],0,"VarNumber") );
  CaseLength = (int)( mxGetScalar( mxGetField( prhs[0],0,"CaseLength" )));

  Miss =  mxGetScalar( mxGetField( prhs[0],0,"Miss") );
  Temp = mxGetPr( mxGetField( prhs[0],0,"VarRange" ));
  RangeRow =  mxGetN( mxGetField( prhs[0],0,"VarRange" ));
  int Range[Dim][RangeRow];
  for(p=0;p<Dim;p++)
      for(q=0;q<RangeRow;q++)
          Range[p][q]=(int)Temp[p+q*Dim];

  Temp = mxGetPr( mxGetField( prhs[0],0,"VarRangeLength" ));
  int VarRangeLength[Dim];
  for(p=0;p<Dim;p++) VarRangeLength[p] = (int)*( Temp+p );

  DimF = mxGetM( prhs[1] ) > mxGetN( prhs[1] ) ? mxGetM( prhs[1] ):mxGetN( prhs[1] );
  MaxParent = (int)mxGetScalar( prhs[2] );
  Temp = mxGetPr( mxGetField( prhs[0],0,"OriginalSample" ));
  double OriginalSample[ CaseLength ][ Dim ];
  for(p=0;p<CaseLength;p++)
      for(q=0;q<Dim;q++)
          OriginalSample[p][q] = Temp[ p+q*CaseLength ];

  if( nrhs == 4 ){ /*if user provides the previous structure for current training.*/
      /*previous DAG inputed by parameter*/
      Dim  = mxGetM( prhs[3]); DimC = Dim-DimF;
  } else { /*traditional training for K2.*/
      Dim = DimF; DimC = 0;
  }

  int DAG[Dim][Dim];
  if( nrhs == 4 ){
      Temp = mxGetPr( prhs[3] );
      for(p=0;p<DimC;p++)
          for(q=0;q<Dim;q++)
             DAG[p][q] = (int)Temp[ p+q*Dim ];
      for(p=DimC;p<Dim;p++)
          for(q=0;q<Dim;q++)
             DAG[p][q] = 0;
  } else{
      for( p=0;p<Dim;p++ )
          for(q=0;q<Dim;q++)
             DAG[p][q] = 0;
  }

  plhs[1] = mxCreateDoubleMatrix( 1, DimF, mxREAL );
  K2Score = mxGetPr( plhs[1] );

  int Parent[Dim], UsefulSample[CaseLength],Frequency[RangeRow],Var[Dim],Order[DimF];
  Temp = mxGetPr( prhs[1] );
  for( p=0;p<DimF;p++ ){
       Order[p] = (int)Temp[p] + DimC - 1;
       K2Score[p] = 0.0;
  /*   mexPrintf("the %d th order is %d\n the K2Score is %f\n",n,Order[n],K2Score[n] );*/
  }

/*********************************************************************************************/
  for( n=1;n<DimF;n++ ){
       X= Order[ n ]; Var[0]= X; 
       ParentLen = 1;
       for( p=0;p<Dim;p++ ){
            Parent[p] = DAG[p][X];
            if( DAG[p][X] ==1 ){
                Var[ParentLen] = p;
                ParentLen++;
            }
       }
       PoldScore = -1.0 / 0.0;
       XLen = VarRangeLength[X];

       while( ParentLen <= MaxParent ){ /*parent's number is less than MaxParent*/
             LocalMax = -1.0 / 0.0;
             for( m=n-1;m>=0;m-- )
                  if(Parent[ Order[m] ] == 0 ){
                     VarLen = 1 + ParentLen;
                     Var[ ParentLen ] = Order[m];
                     LocalScore = 0.0; /*GClosedFun...*/
                      /*GClosedFun code revised for better computation.*/
                     for( t=0;t<CaseLength;t++ ) UsefulSample[ t ] = 2;
                     d = 0;
                     while( d<CaseLength ){
                            for( t=0;t<XLen;t++ ) Frequency[ t ] = 0;
                            while( d < CaseLength ){
                                   if( UsefulSample[ d ] == 1 ) break;
                                     else if( UsefulSample[ d ] == 2  ){
                                        p = 0;
                                        while( p < VarLen && OriginalSample[d][ Var[p] ] != Miss){
                                               p++;
                                        }
                                        if(p==VarLen) break;
                                       }
                                     d++;
                            }
                            if(d==CaseLength)break;
                            CurrentPos = d;
                            for(t=0;t<XLen;t++)
                                   if(Range[X][t]==OriginalSample[d][X]) break;
                            Frequency[ t ] += 1;
                            d++; 
                            for(p=d;p<CaseLength;p++)
                                 if( UsefulSample[p] == 1 ){
                                     q = 1;
                                     while( q < VarLen ){
                                         if( OriginalSample[CurrentPos][Var[q]] != OriginalSample[p][Var[q]] ) break;
                                               q++;
                                     }
                                     if( q==VarLen ){
                                         for(t=0;t<XLen;t++)
                                              if( Range[Order[n]][t] == OriginalSample[p][X])break;
                                         Frequency[ t ] += 1;
                                         UsefulSample[ p ] = 0;
                                     }
                                   } else if( UsefulSample[p] == 2 ){
                                      q = 0;
                                      while( q < VarLen ){
                                           if( OriginalSample[p][Var[q]] == Miss ) break;
                                           q++;
                                      }
                                      if( q<VarLen)
                                           UsefulSample[ p ] = 0;
                                      else{
                                           UsefulSample[ p ] = 1;
                                           q = 1;
                                           while( q < VarLen ){
                                                 if(OriginalSample[CurrentPos][Var[q]] != OriginalSample[p][Var[q]]) break;
                                                     q++;
                                           }
                                           if(q==VarLen){
                                              for(t=0;t<XLen;t++)
                                                  if( Range[X][t] == OriginalSample[p][X])break;
                                              Frequency[ t ] += 1;
                                              UsefulSample[ p ] = 0;
                                           }
                                      }
                                 }/*if else*/
                                 *Temp = 0;
                                 for(p=0;p<XLen;p++)
                                     if( Frequency[p] != 0 ){
                                         LocalScore +=  lgamma( Frequency[p]+1 );
                                         *Temp += Frequency[p];
                                      }
                                 LocalScore += lgamma( XLen ) - lgamma( *Temp +XLen );
                             }/*the end of while loop*/

                           if( LocalScore > LocalMax ){
                               LocalMax = LocalScore;
                               LocalNode = Order[m];
                            }
                        }

                    /*the global best score*/
              if( LocalMax > PoldScore ){
                  PoldScore = LocalMax;
                  Parent[LocalNode] = 1;
                  Var[ParentLen] = LocalNode;
                  ParentLen ++;
              } else break;
        }
        K2Score[X-DimC] = PoldScore;
        for( q=DimC;q<Dim;q++ ) DAG[q][X] = Parent[ q ];
    }
/***************************************************************************************************/
 plhs[0] = mxCreateDoubleMatrix( Dim,Dim,mxREAL );
 Temp = mxGetPr( plhs[0] );
 for(p=0;p<Dim;p++)
     for(q=0;q<Dim;q++)
         Temp[ p+q*Dim ] = (double)DAG[p][q];
}
