(* //////////////////////////////////////////////////////////////////////////////////////
  //
  //  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.
  //
  //  By downloading, copying, installing or using the software you agree to this license.
  //  If you do not agree to this license, do not download, install,
  //  copy or use the software.
  //
  //
  //                           License Agreement
  //                For Open Source Computer Vision Library
  //
  // Copyright (C) 2000-2008, Intel Corporation, all rights reserved.
  // Copyright (C) 2009, Willow Garage Inc., all rights reserved.
  // Third party copyrights are property of their respective owners.
  //
  // Redistribution and use in source and binary forms, with or without modification,
  // are permitted provided that the following conditions are met:
  //
  //   * Redistribution's of source code must retain the above copyright notice,
  //     this list of conditions and the following disclaimer.
  //
  //   * Redistribution's in binary form must reproduce the above copyright notice,
  //     this list of conditions and the following disclaimer in the documentation
  //     and/or other materials provided with the distribution.
  //
  //   * The name of the copyright holders may not be used to endorse or promote products
  //     derived from this software without specific prior written permission.
  //
  // This software is provided by the copyright holders and contributors "as is" and
  // any express or implied warranties, including, but not limited to, the implied
  // warranties of merchantability and fitness for a particular purpose are disclaimed.
  // In no event shall the Intel Corporation or contributors be liable for any direct,
  // indirect, incidental, special, exemplary, or consequential damages
  // (including, but not limited to, procurement of substitute goods or services;
  // loss of use, data, or profits; or business interruption) however caused
  // and on any theory of liability, whether in contract, strict liability,
  // or tort (including negligence or otherwise) arising in any way out of
  // the use of this software, even if advised of the possibility of such damage.
  //
  //

  Translated from:
  opencv2/core/types_c.h

*)

{$IFDEF DEBUG}
{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O-,P+,Q+,R+,S-,T-,U-,V+,W+,X+,Y+,Z1}
{$ELSE}
{$A8,B-,C-,D-,E-,F-,G+,H+,I+,J-,K-,L-,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y-,Z1}
{$ENDIF}
{$WARN SYMBOL_DEPRECATED OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
unit core_c;

interface

uses
  Windows,
  Core.types_c;

(* ***************************************************************************************
  *          cArray allocation, deallocation, initialization and access to elements     *
  ************************************************************************************** *)

(* <malloc> wrapper.
  If there is no enough memory, the cFunction
  (as well as other OpenCV functions that call cvAlloc)
  raises an error. *)
procedure cvAlloc(size: size_t); cdecl;

(* <free> wrapper.
  Here and further all the memory releasing functions
  (that all call cvFree) take Double cPointer in order to
  to clear cPointer to the data after releasing it.
  Passing cPointer to 0 cPointer is Ok: nothing happens in this
*)
procedure cvFree_(ptr: Pointer); cdecl;
// #define cvFree(ptr) (cvFree_(*(ptr)), *(ptr)=0)
procedure cvFree(Var ptr); inline;
{$DEFINE cvFree(ptr(cvFree_}	(* (ptr)), *(ptr)=0)

  (* Allocates and initializes IplImage header *)
function cvCreateImageHeader(size: TCvSize; depth: Integer; channels: Integer): pIplImage; cdecl;

(* Inializes IplImage header *)
// CVAPI(IplImage*) cvInitImageHeader(
// IplImage* image,
// CvSize size,
// int depth,
// int channels,
// int origin CV_DEFAULT(0),
// int align CV_DEFAULT(4));
function cvInitImageHeader(
  { } image: pIplImage;
  { } size: TCvSize;
  { } depth: Integer;
  { } channels: Integer;
  { } origin: Integer = 0;
  { } align: Integer = 4): pIplImage; cdecl;

(* Creates IPL image (header and data *)
// CVAPI(IplImage*)  cvCreateImage( CvSize size, int depth, int channels ); }
function cvCreateImage(size: TCvSize; depth, channels: Integer): pIplImage; cdecl;

(* Releases (i.e. deallocates) IPL image header *)
// CVAPI(void)  cvReleaseImageHeader( IplImage** image );
procedure cvReleaseImageHeader(var image: pIplImage); cdecl;

(* Releases IPL image header and data *)
// CVAPI(void)  cvReleaseImage( IplImage** image );
procedure cvReleaseImage(var image: pIplImage); cdecl;

(* Creates a copy of IPL image (widthStep may differ) *)
// CVAPI(IplImage*) cvCloneImage( const IplImage* image );
function cvCloneImage(const image: pIplImage): pIplImage; cdecl;

(* Sets a Channel Of Interest (only a few functions support COI) -
  use cvCopy to extract the selected channel and/or put it back *)
// CVAPI(void)  cvSetImageCOI( IplImage* image, int coi );
procedure cvSetImageCOI(image: pIplImage; coi: Integer); cdecl;

(* Retrieves image Channel Of Interest *)
// CVAPI(int)  cvGetImageCOI( const IplImage* image );
function cvGetImageCOI(const image: pIplImage): Integer; cdecl;

(* Sets image ROI (region of interest) (COI is not changed) *)
// CVAPI(void)  cvSetImageROI( IplImage* image, CvRect rect );
procedure cvSetImageROI(image: pIplImage; rect: TCvRect); cdecl;

(* Resets image ROI and COI *)
// CVAPI(void)  cvResetImageROI( IplImage* image );
procedure cvResetImageROI(image: pIplImage); cdecl;

(* Retrieves image ROI *)
// CVAPI(CvRect) cvGetImageROI( const IplImage* image );
function cvGetImageROI(const image: pIplImage): TCvRect; cdecl;

(* Allocates and initalizes CvMat header *)
// CVAPI(CvMat*)  cvCreateMatHeader( int rows, int cols, int type );
function cvCreateMatHeader(rows: Integer; cols: Integer; cType: Integer): TCvMat; cdecl;

const
  CV_AUTOSTEP = $7FFFFFFF;
{$EXTERNALSYM CV_AUTOSTEP}
  (* Initializes CvMat header *)
  // CVAPI(CvMat*) cvInitMatHeader(
  // CvMat* mat,
  // int rows,
  // int cols,
  // int type,
  // void* data CV_DEFAULT(NULL),
  // int step CV_DEFAULT(CV_AUTOSTEP) );
function cvInitMatHeader(
  { } mat: pCvMat;
  { } rows: Integer;
  { } cols: Integer;
  { } _type: Integer;
  { } data: Pointer = nil;
  { } step: Integer = CV_AUTOSTEP): pCvMat; cdecl;

{
  (* Allocates and initializes CvMat header and allocates data *)
  CVAPI(CvMat)cvCreateMat(Integer rows, Integer cols, Integer cType): Pointer;
}
function cvCreateMat(rows: Integer; cols: Integer; cType: Integer): pCvMat; cdecl;

/// * Releases CvMat header and deallocates matrix data
// (reference counting is used for data) */
// CVAPI(void)  cvReleaseMat( CvMat** mat );
procedure cvReleaseMat(Var mat: pCvMat); cdecl;


// CV_INLINE CV_INLINE procedure cvDecRefData(CvArr * arr)
// (CV_IS_MAT(arr))begin CvMat * mat := (CvMat)arr;
// mat^.data.ptr := 0;
// if (mat^.refcount <> 0 and - - * mat^.refcount = 0) then
// cvFree(and mat^.refcount);
// mat^.refcount := 0;
// end;
// else if (CV_IS_MATND(arr)) then
// begin
// CvMatND * mat := (CvMatND)arr;
// mat^.data.ptr := 0;
// if (mat^.refcount <> 0 and - - * mat^.refcount = 0) then
// cvFree(and mat^.refcount);
// mat^.refcount := 0;
// end;
// end;

// (* Increments CvMat data reference counter *)
// CV_INLINE
// function cvIncRefData(var mat := (CvMat)arr;
// if (mat^.refcount <> 0) then refcount := + + * mat^.refcount; end;
// else if (CV_IS_MATND(arr)) then begin CvMatND * mat := (CvMatND)arr;
// if (mat^.refcount <> 0) then refcount := + + * mat^.refcount; end; result := refcount; end;
// (* Creates an exact copy of the input matrix (except: CV_IS_MAT( arr )) then     begin         CvMat;
// be: may;
// var )

// CVAPI(CvMat) cvCloneMat(  CvMat* mat: step value)): Integer;
{
  (* Makes a new matrix from <rect> subrectangle of input array.
  No data is copied *)
  CVAPI(CvMat)cvGetSubRect(CvArr * arr, CvMat * submat, CvRect rect);
}
function cvGetSubRect(arr: pIplImage; submat: pIplImage; rect: TCvRect): pIplImage; cdecl;


// const cvGetSubArr = cvGetSubRect;
// {$EXTERNALSYM cvGetSubArr}

// (* Selects row span of the input array: arr(start_row:delta_row:end_row,:)
// (end_row is not included into the span). *)
// CVAPI(CvMat)cvGetRows(CvArr * arr, CvMat * submat, Integer start_row, Integer end_row,
// function delta_row CV_DEFAULT(v1: 1)): Integer;

// CV_INLINE CvMat * cvGetRow(CvArr * arr, CvMat * submat, Integer row)
// begin result := cvGetRows(arr, submat, row, row + 1, 1); end;

// (* Selects column span of the input array: arr(:,start_col:end_col)
// (end_col is not included into the span) *)
// CVAPI(CvMat)cvGetCols(CvArr * arr, CvMat * submat, Integer start_col, Integer end_col);

// CV_INLINE CvMat * cvGetCol(CvArr * arr, CvMat * submat, Integer col)
// begin result := cvGetCols(arr, submat, col, col + 1); end;

// (* Select a diagonal of the input array.
// (diag = 0 means the main diagonal, >0 means a diagonal above the main one,
// <0 - below the main one).
// The diagonal will be represented as a column (nx1 matrix). *)
// CVAPI(CvMat)cvGetDiag(CvArr * arr, CvMat * submat,
// function diag CV_DEFAULT(v1: 0)): Integer;

// (* low-level scalar <-> raw data conversion functions *)
// procedure cvScalarToRawData(0)): Integer;

// procedure cvRawDataToScalar(Pointer data: v1:; cType: Integer; var scalar: CvScalar);

// (* Allocates and initializes CvMatND header *)
// CVAPI(CvMatND)cvCreateMatNDHeader(Integer dims, Integer * sizes, Integer cType);

// (* Allocates and initializes CvMatND header and allocates data *)
// CVAPI(CvMatND)cvCreateMatND(Integer dims, Integer * sizes, Integer cType);

// (* Initializes preallocated CvMatND header *)
// CVAPI(CvMatND)cvInitMatNDHeader(CvMatND * mat, Integer dims, Integer * sizes,
// function cType,
// function
// function CV_DEFAULT(v1: 0)): Integer;

// (* Releases CvMatND *)
// CV_INLINE CV_INLINE
// procedure cvReleaseMatND(var)mat): Pointer; end; (* Creates a copy of CvMatND (except: (CvMat;
// be: may;
// var )

// CVAPI(CvMatND) cvCloneMatND(  CvMatND* mat ): data;
// (* Allocates and initializes CvSparseMat header and allocates data *)
// CVAPI(CvSparseMat)cvCreateSparseMat(Integer dims: steps); var sizes: Integer; cType: Integer);

// (* Releases CvSparseMat *)
// procedure cvReleaseSparseMat(mat: array of CvSparseMat);

// (* Creates a copy of CvSparseMat (except, may be, zero items) *)
// CVAPI(CvSparseMat)cvCloneSparseMat(CvSparseMat * mat);

// (* Initializes sparse array iterator
// (returns the first node or 0 if the cArray is empty) *) then CVAPI(CvSparseNode)
// cvInitSparseMatIterator(CvSparseMat * mat, CvSparseMatIterator * mat_iterator);

/// / returns next sparse array node (or NULL if there is no more nodes)
// CV_INLINE CvSparseNode * cvGetNextSparseNode(CvSparseMatIterator * mat_iterator)
// begin if (mat_iterator^.node^.next) then result := mat_iterator^.node = mat_iterator^.node^.next;
// else begin Integer idx; for (idx := + + mat_iterator^.curidx; idx < mat_iterator^.mat^.hashsize;
// idx + +)begin * node = (CvSparseNode)mat_iterator^.mat^.hashtable: array [0 .. idx -
// 1] of CvSparseNode; if (node) then begin mat_iterator^.curidx := idx;
// result := mat_iterator^.node = node; end; end; result := 0; end; end;
//
// (* *************** matrix iterator: used for n-ary operations on dense arrays ******** *)
//
const
  CV_MAX_ARR = 10;
{$EXTERNALSYM CV_MAX_ARR}
  // type CvNArrayIterator = record count: Integer; (* number of arrays *)
  // dims: Integer; (* number of dimensions to iterate *)
  // size: CvSize; (* maximal common linear size: { width = size, height = 1 } *)
  // ptr: array [0 .. CV_MAX_ARR - 1] of ^uchar; (* pointers to the array slices *)
  // stack: array [0 .. CV_MAX_DIM - 1] of Integer; (* for internal use *)
  // hdr: array [0 .. CV_MAX_ARR - 1] of ^CvMatND; (* pointers to the headers of the
  // end;
  //
  //
  // const CV_NO_DEPTH_CHECK = 1;
  // {$EXTERNALSYM CV_NO_DEPTH_CHECK}
  // const CV_NO_CN_CHECK = 2;
  // {$EXTERNALSYM CV_NO_CN_CHECK}
  // const CV_NO_SIZE_CHECK = 4;
  // {$EXTERNALSYM CV_NO_SIZE_CHECK}
  //
  // (* initializes iterator that traverses through several arrays simulteneously
  // (the cFunction together with cvNextArraySlice is used for
  // N-ari element-wise operations) *)
  // CVAPI(Integer)cvInitNArrayIterator(Integer count, CvArr * * arrs, CvArr * mask, CvMatND * stubs,
  // CvNArrayIterator * array_iterator,
  // function flags CV_DEFAULT(v1: 0)): Integer;
  //
  // (* returns zero value if iteration is finished, non-zero (slice length) otherwise *)
  // CVAPI(Integer)cvNextNArraySlice(CvNArrayIterator * array_iterator);
  //
  // (* Returns type of array elements:
  // const CV_64FC4 = Args: array of const;
  // {$EXTERNALSYM CV_64FC4}
  // CVAPI(Integer) cvGetElemType(  CvArr* arr );
  //
  // (* Retrieves number of an array dimensions and
  // optionally sizes of the dimensions *)
  // CVAPI(Integer)cvGetDims(CvArr * arr, Integer * sizes CV_DEFAULT(0));
  //
  // (* Retrieves size of a particular array dimension.
  // For 2d arrays cvGetDimSize(arr,0) returns number of rows (image height)
  // and cvGetDimSize(arr,1) returns number of columns (image width) *)
  // CVAPI(Integer)cvGetDimSize(CvArr * arr, Integer index);
  //
  // (* ptr = &arr(idx0,idx1,...). All indexes are zero-based,
  // the major dimensions go first (e.g. (y,x) for 2D, (z,y,x) for 3D *)
  // CVAPI(uchar)cvPtr1D(CvArr * arr, Integer idx0, Integer * cType CV_DEFAULT(0));
  // CVAPI(uchar)cvPtr2D(CvArr * arr, Integer idx0, Integer idx1, Integer * cType CV_DEFAULT(0));
  // CVAPI(uchar)cvPtr3D(CvArr * arr, Integer idx0, Integer idx1, Integer idx2,
  // function cType CV_DEFAULT(v1: 0)): Integer;
  //
  // (* For CvMat or IplImage number of indices should be 2
  // (row index (y) goes first, column index (x) goes next).
  // For CvMatND or CvSparseMat number of infices should match number of <dims> and
  // indices order should match the cArray dimension order. *)
  // CVAPI(uchar)cvPtrND(CvArr * arr, Integer * idx, Integer * cType CV_DEFAULT(0),
  // function create_node CV_DEFAULT(v1: 0)): Cardinal;

  // * value = arr(idx0,idx1,...) */
  // CVAPI(CvScalar) cvGet1D( const CvArr* arr, int idx0 );
  // CVAPI(CvScalar) cvGet2D( const CvArr* arr, int idx0, int idx1 );
function cvGet2D(const arr: pCvMat; idx0, idx1: Integer): TCvScalar; cdecl;
{
  CVAPI(CvScalar) cvGet3D( const CvArr* arr, int idx0, int idx1, int idx2 );
  CVAPI(CvScalar) cvGetND( const CvArr* arr, const int* idx );
}
{
  /* for 1-channel arrays */
  CVAPI(double) cvGetReal1D( const CvArr* arr, int idx0 );
}
function cvGetReal1D(const arr: pIplImage; idx0: Integer): Double; cdecl;

// CVAPI(double) cvGetReal2D( const CvArr* arr, int idx0, int idx1 );
function cvGetReal2D(const arr: pCvMat; idx0, idx1: Integer): Double; cdecl;

{
  CVAPI(double) cvGetReal3D( const CvArr* arr, int idx0, int idx1, int idx2 );
  CVAPI(double) cvGetRealND( const CvArr* arr, const int* idx );

  /* arr(idx0,idx1,...) = value */
  CVAPI(void) cvSet1D( CvArr* arr, int idx0, CvScalar value );
  CVAPI(void) cvSet2D( CvArr* arr, int idx0, int idx1, CvScalar value );
  CVAPI(void) cvSet3D( CvArr* arr, int idx0, int idx1, int idx2, CvScalar value );
  CVAPI(void) cvSetND( CvArr* arr, const int* idx, CvScalar value );

  /* for 1-channel arrays */
  CVAPI(void) cvSetReal1D( CvArr* arr, int idx0, double value );
  CVAPI(void) cvSetReal2D( CvArr* arr, int idx0, int idx1, double value );
  CVAPI(void) cvSetReal3D( CvArr* arr, int idx0,
  int idx1, int idx2, double value );
  CVAPI(void) cvSetRealND( CvArr* arr, const int* idx, double value );
}


// (* clears element of ND dense array,
// in  of sparse arrays it deletes the specified node *)
// procedure cvClearND(var arr: CvArr; var idx: Integer);
//
// (* Converts CvArr (IplImage or CvMat,...) to CvMat.
// If the last parameter is non-zero, cFunction can
// convert multi(>2)-dimensional cArray to CvMat as LongInt as
// the last array's dimension is continous. The resultant
// matrix will be have appropriate (a huge) number of rows *)
// CVAPI(CvMat)cvGetMat(CvArr * arr, CvMat * header,
// function coi CV_DEFAULT(v1: 0)): Integer;
//
// (* Converts CvArr (IplImage or CvMat) to IplImage *)
// function cvGetImage(CvArr * arr, IplImage * image_header);
//
// (* Changes a shape of multi-dimensional array.
// new_cn = 0 means that number of channels remains unchanged.
// new_dims = 0 means that number and sizes of dimensions remain the same
// (unless they need to be changed to set the new number of channels)
// if new_dims = 1, there is no need to specify new dimension sizes
// The resultant configuration should be achievable w/o data copying.
// If the resultant cArray is sparse, CvSparseMat header should be passed
// to the cFunction else if the cResult is 1 or 2 dimensional,
// CvMat header should be passed to the cFunction
// else CvMatND header should be passed *)
// CVAPI(CvArr)cvReshapeMatND(CvArr * arr, Integer sizeof_header, CvArr * header, Integer new_cn,
// Integer new_dims, Integer * new_sizes);
//
/// / >> Following declaration is a macro definition!
// const cvReshapeND(arr, header, new_cn, new_dims, new_sizes)cvReshapeMatND((arr), SizeOf((header)),
// (header), (new_cn), (new_dims), (new_sizes));
//
// CVAPI(CvMat)cvReshape(CvArr * arr, CvMat * header,
// function new_cn, Integer new_rows CV_DEFAULT(v1: 0)): Integer;
//
// (* Repeats source 2d array several times in both horizontal and
// vertical direction to fill destination cArray *)
// procedure cvRepeat(var src: CvArr; var dst: CvArr);
//
// (* Allocates array data *)
// procedure cvCreateData(var arr: CvArr);
//
// (* Releases array data *)
// procedure cvReleaseData(var arr: CvArr);
//
// (* Attaches user data to the array header. The step is reffered to
// the pre-last dimension. That is, all the planes of the cArray
// must be joint (w/o gaps) *)
// procedure cvSetData(var arr: CvArr; data: Pointer; step: Integer);
//
// (* Retrieves raw data of CvMat, IplImage or CvMatND.
// In the latter  the cFunction raises an error if
// the cArray can not be represented as a matrix *)
// procedure cvGetRawData(var Returns width and height of array in elements * )

// CVAPI(CvSize) cvGetSize( const CvArr* arr );
// function cvGetSize(const arr: CvArr): CvSize; cdecl;
{ todo -cmedium -oLaex: ������������ ��������� OpenCV (need use OpenCV) }
{
  /* Returns width and height of array in elements */
  CVAPI(CvSize) cvGetSize( const CvArr* arr );
}
function cvGetSize(const arr: pCvArr): TCvSize; //overload;
procedure _cvGetSize(const arr: pCvArr; var size: TCvSize); cdecl;
// function cvGetSize(const arr: pIplImage): TCvSize; overload;
// function _cvGetSize(const arr: pCvArr): TCvSize; cdecl;
// function _cvGetSize(const image: pIplImage): TCvSize;

//
// (* Copies source array to destination array *)
// procedure cvCopy(var Sets all or " masked " elements of input array to the same value * )
{
  CVAPI(void)  cvCopy( const CvArr* src, CvArr* dst,
  const CvArr* mask CV_DEFAULT(NULL) );
}
procedure cvCopy(const src: pIplImage; dst: pIplImage; const mask: pIplImage = nil); cdecl;
procedure cvCopyImage(const src: pIplImage; dst: pIplImage; const mask: pIplImage = nil); cdecl;

{
  /* Sets all or "masked" elements of input array to the same value*/
  CVAPI(void)  cvSet( CvArr* arr, CvScalar value,const CvArr* mask CV_DEFAULT(NULL) );
}
procedure cvSet(arr: pCvArr; value: TCvScalar; const mask: pCvArr = Nil); cdecl; // overload;
// procedure cvSet(arr: pIplImage; value: TCvScalar; const mask: pCvArr = Nil); cdecl; overload;

// procedure cvSetZero(CvArr * arr: unction mask CV_DEFAULT(v1: 0)): CvArr; ();
// const cvZero = cvSetZero;
// {$EXTERNALSYM cvZero}
// CVAPI(void)  cvSetZero( CvArr* arr );
// #define cvZero  cvSetZero
procedure cvSetZero(arr: pIplImage); cdecl;
procedure cvZero(arr: pCvArr); cdecl;
//procedure cvZero(arr: pIplImage); cdecl; overload;
//procedure cvZero(arr: pCvMat); cdecl; overload;

{
  /* Splits a multi-channel array into the set of single-channel arrays or
  extracts particular [color] plane */
  CVAPI(void)  cvSplit(
  const CvArr* src,
  CvArr* dst0,
  CvArr* dst1,
  CvArr* dst2,
  CvArr* dst3 );
}
procedure cvSplit(
  { } const src: pIplImage;
  { } dst0: pIplImage;
  { } dst1: pIplImage;
  { } dst2: pIplImage;
  { } dst3: pIplImage); cdecl;
procedure cvCvtPixToPlane(
  { } const src: pIplImage;
  { } dst0: pIplImage;
  { } dst1: pIplImage;
  { } dst2: pIplImage;
  { } dst3: pIplImage); cdecl;

{
  /* Merges a set of single-channel arrays into the single multi-channel array
  or inserts one particular [color] plane to the array */
  CVAPI(void)  cvMerge(
  const CvArr* src0,
  const CvArr* src1,
  const CvArr* src2,
  const CvArr* src3,
  CvArr* dst );
}
procedure cvMerge(
  { } const src0: pIplImage;
  { } const src1: pIplImage;
  { } const src2: pIplImage;
  { } const src3: pIplImage;
  { } dst: pIplImage); cdecl;
procedure cvCvtPlaneToPix(
  { } const src0: pIplImage;
  { } const src1: pIplImage;
  { } const src2: pIplImage;
  { } const src3: pIplImage;
  { } dst: pIplImage); cdecl;

// {$EXTERNALSYM CvArr);
//
// (* Copies several channels from input arrays to
// certain channels of output arrays *)
// procedure  cvMixChannels(
// src: array of CvArr;
// src_count: Integer;
// dst: array of CvArr;
// dst_count: Integer;
// var from_to: nteger;
// pair_count: Integer);
//

// (* Performs linear transformation on every source array element:
// dst(x,y,c) = scale*src(x,y,c)+shift.
// Arbitrary combination of input and output cArray depths are allowed
// (number of channels must be the same), thus the cFunction can be used
// for cType conversion *)
// procedure  cvConvertScale(
// 0)): Double;const cvCvtScale = cvConvertScale;{$EXTERNALSYM cvCvtScale}const cvScale =
// cvConvertScale; {$EXTERNALSYM cvScale}// >> Following declaration is a macro definition!const cvConvert( src: v1:;
// )cvConvertScale((src): dst; v3: (dst); :; : );

{
  /* Performs linear transformation on every source array element:
  dst(x,y,c) = scale*src(x,y,c)+shift.
  Arbitrary combination of input and output array depths are allowed
  (number of channels must be the same), thus the function can be used
  for type conversion */

  CVAPI(void)  cvConvertScale(
  const CvArr* src,
  CvArr* dst,
  double scale CV_DEFAULT(1),
  double shift CV_DEFAULT(0) );

  #define cvCvtScale cvConvertScale
  #define cvScale  cvConvertScale
  #define cvConvert( src, dst )  cvConvertScale( (src), (dst), 1, 0 )
}
procedure cvConvertScale(const src: pCvArr; dst: pCvArr; scale: Double = 1; shift: Double = 0); cdecl;
// procedure cvConvertScale(const src: pIplImage; dst: pIplImage; scale: Double = 1; shift: Double = 0); cdecl; overload;
// procedure cvConvertScale(const src: pCvMat; dst: pCvMat; scale: Double = 1; shift: Double = 0); cdecl; overload;
// procedure cvConvert(const src: pIplImage; dst: pIplImage); inline;
procedure cvConvert(const src: pCvArr; dst: pCvArr); inline;

// (* Performs linear transformation on every source array element,
// stores absolute value of the cResult:
// dst(x,y,c) = abs(scale*src(x,y,c)+shift).
// destination cArray must have 8u cType.
// In other cases one may use cvConvertScale + cvAbsDiffS *)
// procedure cvConvertScaleAbs(var checks termination criteria validity and
// Sets eps to default_eps(if it is not set) then : v1: 0)): Double;
// const cvCvtScaleAbs = cvConvertScaleAbs;
// {$EXTERNALSYM cvCvtScaleAbs}(; var)CVAPI(CvTermCriteria)cvCheckTermCriteria(CvTermCriteria criteria
// : max_iter to default_max_iters(if it is not set) then; default_eps: Double;
// default_max_iters: Integer);
//
// (* ***************************************************************************************\
// *                   Arithmetic, logic and comparison operations                          *
// *************************************************************************************** *)
//
// (* dst(mask) = src1(mask) + src2(mask) *)
// procedure cvAdd(var dst(mask) = src(mask) + value * )

// procedure cvAddS(CvArr * src: v1: 0)): CvArr; (; value: CvScalar; var dst: CvArr;
// var dst(mask) = src1(mask) - src2(mask) * )

{
  CVAPI(void)  cvAddS( const CvArr* src, CvScalar value, CvArr* dst,
  const CvArr* mask CV_DEFAULT(NULL));
}
procedure cvAddS(const src: pIplImage; value: TCvScalar; dst: pIplImage; const mask: pIplImage = nil); cdecl;

{
  /* dst(mask) = src1(mask) - src2(mask) */
  CVAPI(void)  cvSub(
  const CvArr* src1,
  const CvArr* src2,
  CvArr* dst,
  const CvArr* mask CV_DEFAULT(NULL));
}

procedure cvSub(const src1, src2: pIplImage; dst: pIplImage; const mask: pIplImage = nil); cdecl;

(*
  /* dst(mask) = src(mask) - value = src(mask) + (-value) */
  CV_INLINE  void  cvSubS(
  const CvArr* src,
  CvScalar value,
  CvArr* dst,
  const CvArr* mask CV_DEFAULT(NULL))
  {
  cvAddS( src, cvScalar( -value.val[0], -value.val[1], -value.val[2], -value.val[3]),
  dst, mask );
  }
*)
procedure cvSubS(const src: pIplImage; value: TCvScalar; dst: pIplImage; const mask: pIplImage = nil); inline;

// (* dst(mask) = value - src(mask) *)
// procedure cvSubRS(var dst(idx) = src1(idx) * src2(idx) * scale(scaled element -
// wise multiplication of 2 arrays) * )


// procedure cvMul(CvArr * src1: v1: 0)): CvArr; (; var src2: CvArr; dst:
// function; var element - wise division / inversion with scaling: dst(idx) = src1(idx) * scale /
// src2(idx) or dst(idx) = scale / src2(idx) if src1 = 0 * ) then
// procedure cvDiv(CvArr * src1:
// function scale CV_DEFAULT(v1: 1)): Double; (; var src2: CvArr; var dst: CvArr;
// var dst = src1 * scale + src2 * )
// procedure cvScaleAdd(CvArr * src1:
// function scale CV_DEFAULT(v1: 1)): Double; (; scale: CvScalar; var src2: vArr; var dst): CvArr;
/// / >> Following declaration is a macro definition!const cvAXPY( A: CvArr;
// v11: real_scalar; :;)cvScaleAdd(A: C; v14: cvRealScalar(real_scalar); :; : );

{
  /* dst = src1 * alpha + src2 * beta + gamma */
  CVAPI(void)  cvAddWeighted(
  const CvArr* src1,
  double alpha,
  const CvArr* src2,
  double beta,
  double gamma,
  CvArr* dst );
}
procedure cvAddWeighted(
  { } const src1: pIplImage;
  { } alpha: Double;
  { } const src2: pIplImage;
  { } beta: Double;
  { } gamma: Double;
  { } dst: pIplImage); cdecl;

//
// (* result = sum_i(src1(i) * src2(i)) (results for all channels are accumulated together) *)
// CVAPI(Double)cvDotProduct(CvArr * src1, CvArr * src2);
//

{
  /* dst(idx) = src1(idx) & src2(idx) */
  CVAPI(void) cvAnd(
  const CvArr* src1,
  const CvArr* src2,
  CvArr* dst,
  const CvArr* mask CV_DEFAULT(NULL));
}
procedure cvAnd(
  { } const src1: pIplImage;
  { } const src2: pIplImage;
  { } dst: pIplImage;
  { } masl: pIplImage = nil); cdecl;


// procedure cvAndS(CvArr * src: v1: 0)): CvArr; (; value: CvScalar; dst: unction;
// var mask CV_DEFAULT(v1: 0)): CvArr; (* dst(idx) = src1(idx) | src2(idx) *)
// procedure cvOr(CvArr * src1: CvArr; var src2: CvArr; dst: unction;
// var mask CV_DEFAULT(v1: 0)): CvArr; (* dst(idx) = src(idx) | value *)
// procedure cvOrS(CvArr * src: CvArr; value: CvScalar; dst: unction;
// var mask CV_DEFAULT(v1: 0)): CvArr; (* dst(idx) = src1(idx) ^ src2(idx) *)
// procedure cvXor(CvArr * src1: CvArr; var src2: CvArr; dst: unction;
// var mask CV_DEFAULT(v1: 0)): CvArr;

{
  /* dst(idx) = src(idx) ^ value */
  CVAPI(void) cvXorS( const CvArr* src, CvScalar value,
  CvArr* dst, const CvArr* mask CV_DEFAULT(NULL));
}
procedure cvXorS(const src: pIplImage; value: TCvScalar; dst: pIplImage; const mask: pCvArr = nil); cdecl;

(* dst(idx) = ~src(idx) *)
// procedure cvNot(CvArr * src: CvArr; var dst: CvArr);
//

{
  /* dst(idx) = lower(idx) <= src(idx) < upper(idx) */
  CVAPI(void) cvInRange(
  const CvArr* src,
  const CvArr* lower,
  const CvArr* upper,
  CvArr* dst );
}
procedure cvInRange(
  { } const src: pIplImage;
  { } const lower: pIplImage;
  { } const upper: pIplImage;
  { } dst: pIplImage); cdecl;

{
  /* dst(idx) = lower <= src(idx) < upper */
  CVAPI(void) cvInRangeS(
  const CvArr* src,
  CvScalar lower,
  CvScalar upper,
  CvArr* dst );
}
procedure cvInRangeS(
  { } const src: pIplImage;
  { } lower: TCvScalar;
  { } upper: TCvScalar;
  { } dst: pIplImage); cdecl;

//
// const CV_CMP_EQ = 0;
// {$EXTERNALSYM CV_CMP_EQ}
// const CV_CMP_GT = 1;
// {$EXTERNALSYM CV_CMP_GT}
// const CV_CMP_GE = 2;
// {$EXTERNALSYM CV_CMP_GE}
// const CV_CMP_LT = 3;
// {$EXTERNALSYM CV_CMP_LT}
// const CV_CMP_LE = 4;
// {$EXTERNALSYM CV_CMP_LE}
// const CV_CMP_NE = 5;
// {$EXTERNALSYM CV_CMP_NE}
// (* The comparison operation support single-channel arrays only.
// Destination image should be 8uC1 or 8sC1 *)
//
// (* dst(idx) = src1(idx) _cmp_op_ src2(idx) *)
// procedure cvCmp(var src1: CvArr; var src2: CvArr; var dst: CvArr; cmp_op: Integer);
//
// (* dst(idx) = src1(idx) _cmp_op_ value *)
// procedure cvCmpS(var src: CvArr; value: Double; var dst: CvArr; cmp_op: Integer);
//
// (* dst(idx) = min(src1(idx),src2(idx)) *)
// procedure cvMin(var src1: CvArr; var src2: CvArr; var dst: CvArr);
//
// (* dst(idx) = max(src1(idx),src2(idx)) *)
// procedure cvMax(var src1: CvArr; var src2: CvArr; var dst: CvArr);
//
// (* dst(idx) = min(src(idx),value) *)
// procedure cvMinS(var src: CvArr; value: Double; var dst: CvArr);
//
// (* dst(idx) = max(src(idx),value) *)
// procedure cvMaxS(var src: CvArr; value: Double; var dst: CvArr);
//
// (* dst(x,y,c) = abs(src1(x,y,c) - src2(x,y,c)) *)
// procedure cvAbsDiff(var src1: CvArr; var src2: CvArr; var dst: CvArr);
//
// (* dst(x,y,c) = abs(src(x,y,c) - value(c)) *)
// procedure cvAbsDiffS(var src: CvArr; var dst: CvArr; value: CvScalar);
/// / >> Following declaration is a macro definition!
// const cvAbs(src, dst)cvAbsDiffS((src), (dst), cvScalarAll(0));
//
// (* ***************************************************************************************\
// *                                Math operations                                         *
// *************************************************************************************** *)
//
// (* Does cartesian->polar coordinates conversion.
// Either of output cComponents (magnitude or angle) is optional *)
// procedure cvCartToPolar(var Does polar - > cartesian coordinates conversion.Either of output
// cComponents(magnitude or angle) is optional.If magnitude is missing it is assumed to be all 1
// 's */procedure  cvPolarToCart(  CvArr* magnitude: v1: 0)): Integer;(;var angle: CvArr;var x
// : CvArr; var y: CvArr; var Does powering: dst(idx) = src(idx)^power * )
// procedure cvPow(CvArr * src:
// function angle_in_degrees CV_DEFAULT(v1: 0)): Integer; (; var dst: CvArr;
// var Does exponention: dst(idx) = exp(src(idx)).Overflow is not handled yet.Underflow is handled.
// Maximal relative error is ~ 7E-6 for single - precision input * )
// procedure cvExp(CvArr * src: Double power): CvArr; (; var dst: CvArr);
//
// (* Calculates natural logarithms: dst(idx) = log(abs(src(idx))).
// Logarithm of 0 gives large negative number(~-700)
// Maximal relative error is ~3e-7 for single-precision output
// *)
// procedure cvLog(var src: CvArr; var dst: CvArr);
//
// (* Fast arctangent calculation *)
// CVAPI(single)cvFastArctan(single y, single x);
//
// (* Fast cubic root calculation *)
// CVAPI(single)cvCbrt(single value);
//
// (* Checks array values for NaNs, Infs or simply for too large numbers
// (if CV_CHECK_RANGE is set) then . If CV_CHECK_QUIET is set,
// no runtime errors is raised (cFunction returns zero value in  of 'bad' values).
// Otherwise cvError is called *)
// const CV_CHECK_RANGE = 1;
// {$EXTERNALSYM CV_CHECK_RANGE}
// const CV_CHECK_QUIET = 2;
// {$EXTERNALSYM CV_CHECK_QUIET}
// CVAPI(Integer)cvCheckArr(CvArr * arr, Integer flags CV_DEFAULT(0),
// function min_val CV_DEFAULT(v1: 0)): Double; const cvCheckArray = cvCheckArr;
// {$EXTERNALSYM cvCheckArray}
// const CV_RAND_UNI = 0;
// {$EXTERNALSYM CV_RAND_UNI}
// const CV_RAND_NORMAL = 1;
// {$EXTERNALSYM CV_RAND_NORMAL}
// procedure cvRandArr(var rng: CvRNG; var arr: CvArr; dist_type: Integer; param1: CvScalar;
// param2: CvScalar);
//
// procedure cvRandShuffle(var src: v1: 1. )): Double; const CV_SORT_EVERY_ROW = 0;
// {$EXTERNALSYM CV_SORT_EVERY_ROW}const CV_SORT_EVERY_COLUMN = 1;
// {$EXTERNALSYM CV_SORT_EVERY_COLUMN}const CV_SORT_ASCENDING = 0;
// {$EXTERNALSYM CV_SORT_ASCENDING}const CV_SORT_DESCENDING = 16; {$EXTERNALSYM CV_SORT_DESCENDING} procedure cvSort(CvArr; var dst CV_DEFAULT(0): CvArr; var Finds real roots of A cubic equation * )CVAPI(Integer)cvSolveCubic(CvMat * coeffs:
// function idxmat CV_DEFAULT(v1: 0)): Integer; (; var roots): CvArr;
// (* Finds all real and complex roots of a polynomial equation *)
// procedure cvSolvePoly(CvMat * coeffs: CvMat; var roots2: CvMat;
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * \ * Matrix operations *
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * )
// (* Calculates cross product of two 3d vectors *)
// procedure cvCrossProduct(CvArr * src1: array of
// function maxiter CV_DEFAULT(v1: 100)): Integer; (; var src2: CvArr; var dst: CvArr);
//
// (* Matrix transform: dst = A*B + C, C is optional *)
/// / >> Following declaration is a macro definition!
// const cvMatMulAdd(src1, src2, src3, dst)cvGEMM((src1), (src2), 1., (src3), 1., (dst), 0);
/// / >> Following declaration is a macro definition!
// const cvMatMul(src1, src2, dst)cvMatMulAdd((src1), (src2), 0, (dst));
//
// const CV_GEMM_A_T = 1;
// {$EXTERNALSYM CV_GEMM_A_T}
// const CV_GEMM_B_T = 2;
// {$EXTERNALSYM CV_GEMM_B_T}
// const CV_GEMM_C_T = 4;
// {$EXTERNALSYM CV_GEMM_C_T}
// (* Extended matrix transform:
// dst = alpha*op(A)*op(B) + beta*op(C), where op(X) is X or X xor T *)
// procedure cvGEMM(var Transforms each element of source array and stores resultant vectors
// in destination cArray * )
// procedure cvTransform(CvArr * src: v1: 0)): Integer; const cvMatMulAddEx = cvGEMM;
// {$EXTERNALSYM cvMatMulAddEx}(; var dst: CvArr; var transmat: vMat;
// var shiftvec CV_DEFAULT(0): vMat); const cvMatMulAddS = cvTransform;
// {$EXTERNALSYM cvMatMulAddS}
// (* Does perspective transform on every element of input array *)
// procedure cvPerspectiveTransform(var src: CvArr; var dst: CvArr; var mat: vMat);
//
// (* Calculates (A-delta)*(A-delta)^T (order=0) or (A-delta)^T*(A-delta) (order=1) *)
// procedure cvMulTransposed(var Tranposes Matrix.Square matrices can be transposed in - place * )
// procedure cvTranspose(CvArr * src: v1: 1. )): Double; (; var dst): CvArr; const cvT = cvTranspose;
// {$EXTERNALSYM cvT}(* Completes the symmetric matrix from the lower (LtoR=0) or from the upper (LtoR!=0) part *)
// procedure cvCompleteSymm(CvMat * Matrix: CvArr; LtoR CV_DEFAULT(0): Integer);
//
{
  /* Mirror array data around horizontal (flip=0),
  vertical (flip=1) or both(flip=-1) axises:
  cvFlip(src) flips images vertically and sequences horizontally (inplace) */
  CVAPI(void)  cvFlip( const CvArr* src, CvArr* dst CV_DEFAULT(NULL),
  int flip_mode CV_DEFAULT(0));
  #define cvMirror cvFlip
}
procedure cvFlip(const src, dst: pIplImage; flip_mode: Integer = 0); cdecl;

// {$EXTERNALSYM cvMirror} const CV_SVD_MODIFY_A = 1;
// {$EXTERNALSYM CV_SVD_MODIFY_A}const CV_SVD_U_T = 2; {$EXTERNALSYM CV_SVD_U_T}const CV_SVD_V_T = 4;
// {$EXTERNALSYM CV_SVD_V_T}(; var W: CvArr; var U CV_DEFAULT(0): CvArr;
// var Performs Singular value Back Substitution(solves A * x = B): flags must be the same as
// in cvSVD * )
// procedure cvSVBkSb(CvArr * W:
// function V CV_DEFAULT(v1: 0)): CvArr; (; var U: CvArr; var = B: onst CvArr; var } CvArr * x:
// {$EXTERNALSYM CvArr;
// flags: Integer);
//
// const CV_LU = 0;
// {$EXTERNALSYM CV_LU}
// const CV_SVD = 1;
// {$EXTERNALSYM CV_SVD}
// const CV_SVD_SYM = 2;
// {$EXTERNALSYM CV_SVD_SYM}
// const CV_CHOLESKY = 3;
// {$EXTERNALSYM CV_CHOLESKY}
// const CV_QR = 4;
// {$EXTERNALSYM CV_QR}
// const CV_NORMAL = 16;
// {$EXTERNALSYM CV_NORMAL}
// (* Inverts matrix *)
// CVAPI(Double)cvInvert(CvArr * src, CvArr * dst,
// function method CV_DEFAULT(v1: CV_LU)): Integer; const cvInv = cvInvert;
// {$EXTERNALSYM cvInv}
// (* Solves linear system (src1)*(dst) = (src2)
// (returns 0 if src1 is a singular and CV_LU method is used) *) then CVAPI(Integer)cvSolve(CvArr *
// src1, CvArr * src2, CvArr * dst,
// function method CV_DEFAULT(v1: CV_LU)): Integer;
//
// (* Calculates determinant of input matrix *)
// CVAPI(Double)cvDet(CvArr * mat);
//
// (* Calculates trace of the matrix (sum of elements on the main diagonal) *)
// CVAPI(CvScalar)cvTrace(CvArr * mat);
//
// (* Finds eigen values and vectors of a symmetric matrix *)
// procedure cvEigenVV(-1: v1: ); highindex CV_DEFAULT(-1): Integer): Integer;
//
/// // * Finds selected eigen values and vectors of a symmetric matrix */
/// / CVAPI(void)  cvSelectedEigenVV( CvArr* mat, CvArr* evects, CvArr* evals,
/// / int lowindex, int highindex ): Double;
//
// (* Makes an identity matrix (mat_ij = i == j) *)
// procedure cvSetIdentity(v1: cvRealScalar(1)));
//
// (* Fills matrix with given range of numbers *)
// CVAPI(CvArr)cvRange(CvArr * mat, Double start, Double end);
//
// (* Calculates covariation matrix for a set of vectors *)
// (* transpose([v1-avg, v2-avg,...]) * [v1-avg,v2-avg,...] *)
// const CV_COVAR_SCRAMBLED = 0;
// {$EXTERNALSYM CV_COVAR_SCRAMBLED}
// (* [v1-avg, v2-avg,...] * transpose([v1-avg,v2-avg,...]) *)
// const CV_COVAR_NORMAL = 1;
// {$EXTERNALSYM CV_COVAR_NORMAL}
// (* do not calc average (i.e. mean vector) - use the input vector instead
// (useful for calculating covariance matrix by parts) *)
// const CV_COVAR_USE_AVG = 2;
// {$EXTERNALSYM CV_COVAR_USE_AVG}
// (* scale the covariance matrix coefficients by number of the vectors *)
// const CV_COVAR_SCALE = 4;
// {$EXTERNALSYM CV_COVAR_SCALE}
// (* all the input vectors are stored in a single matrix, as its rows *)
// const CV_COVAR_ROWS = 8;
// {$EXTERNALSYM CV_COVAR_ROWS}
// (* all the input vectors are stored in a single matrix, as its columns *)
// const CV_COVAR_COLS = 16;
// {$EXTERNALSYM CV_COVAR_COLS}
// procedure cvCalcCovarMatrix(vects: array of CvArr; count: Integer; var cov_mat: CvArr;
// var avg: CvArr; flags: Integer);
//
// const CV_PCA_DATA_AS_ROW = 0;
// {$EXTERNALSYM CV_PCA_DATA_AS_ROW}
// const CV_PCA_DATA_AS_COL = 1;
// {$EXTERNALSYM CV_PCA_DATA_AS_COL}
// const CV_PCA_USE_AVG = 2;
// {$EXTERNALSYM CV_PCA_USE_AVG}
// procedure cvCalcPCA(var data: CvArr; var mean: CvArr; var eigenvals: CvArr; var eigenvects: CvArr;
// flags: Integer);
//
// procedure cvProjectPCA(var data: CvArr; var mean: CvArr; var eigenvects: vArr; var cResult: CvArr);
//
// procedure cvBackProjectPCA(var proj: CvArr; var mean: CvArr; var eigenvects: vArr;
// var cResult: CvArr);
//
// (* Calculates Mahalanobis(weighted) distance *)
// CVAPI(Double)cvMahalanobis(CvArr * vec1, CvArr * vec2, CvArr * mat);
// const cvMahalonobis = cvMahalanobis;
// {$EXTERNALSYM cvMahalonobis}
// (* ***************************************************************************************\
// *                                    cArray Statistics                                    *
// *************************************************************************************** *)
//
// (* Finds sum of array elements *)
// CVAPI(CvScalar)cvSum(CvArr * arr);

// (* Calculates number of non-zero pixels *)
// CVAPI(Integer)cvCountNonZero(CvArr * arr);
function cvCountNonZero(arr: pIplImage): Integer; cdecl;

// (* Calculates mean value of array elements *)
// CVAPI(CvScalar)cvAvg(CvArr * arr, CvArr * mask CV_DEFAULT(0));
//
// (* Calculates mean and standard deviation of pixel values *)
// procedure cvAvgSdv(var Finds global minimum: v1: 0)): CvArr; (; var)

{
  /* Finds global minimum, maximum and their positions */
  CVAPI(void)  cvMinMaxLoc(
  const CvArr* arr,
  double* min_val,
  double* max_val,
  CvPoint* min_loc CV_DEFAULT(NULL),
  CvPoint* max_loc CV_DEFAULT(NULL),
  const CvArr* mask CV_DEFAULT(NULL) );
}
procedure cvMinMaxLoc(
  { } const arr: pIplImage;
  { } min_val: pDouble;
  { } max_val: pDouble;
  { } min_loc: pCVPoint = nil;
  { } max_loc: pCVPoint = nil;
  { } const mask: pIplImage = nil); cdecl;

// procedure cvMinMaxLoc(CvArr * arr: maximum and their positions; var min_val: Double;
// var max_val: Double; var min_loc CV_DEFAULT(0): CvPoint; var max_loc CV_DEFAULT(0): CvPoint;
// var types of array norm * )const CV_C = 1; {$EXTERNALSYM CV_C}const CV_L1 = 2;
// {$EXTERNALSYM CV_L1}const CV_L2 = 4; {$EXTERNALSYM CV_L2}const CV_NORM_MASK = 7;
// {$EXTERNALSYM CV_NORM_MASK}const CV_RELATIVE = 8; {$EXTERNALSYM CV_RELATIVE}const CV_DIFF = 16;
// {$EXTERNALSYM CV_DIFF}const CV_MINMAX = 32;
// {$EXTERNALSYM CV_MINMAX}const CV_DIFF_C = (CV_DIFF or CV_C: unction mask CV_DEFAULT(v1: 0))
// : CvArr; ();
// {$EXTERNALSYM CV_DIFF_C}
// const CV_DIFF_L1 = (CV_DIFF or CV_L1);
// {$EXTERNALSYM CV_DIFF_L1}
// const CV_DIFF_L2 = (CV_DIFF or CV_L2);
// {$EXTERNALSYM CV_DIFF_L2}
// const CV_RELATIVE_C = (CV_RELATIVE or CV_C);
// {$EXTERNALSYM CV_RELATIVE_C}
// const CV_RELATIVE_L1 = (CV_RELATIVE or CV_L1);
// {$EXTERNALSYM CV_RELATIVE_L1}
// const CV_RELATIVE_L2 = (CV_RELATIVE or CV_L2);
// {$EXTERNALSYM CV_RELATIVE_L2}
// (* Finds norm, difference norm or relative difference norm for an array (or two arrays) *)
// CVAPI(Double)cvNorm(CvArr * arr1, CvArr * arr2 CV_DEFAULT(0),
// function norm_type CV_DEFAULT(v1: 0)): Integer;
//
// procedure cvNormalize(0.: v1: ); norm_type CV_DEFAULT(CV_L2):
// function; var mask CV_DEFAULT(0): vArr): Integer;
//
// const CV_REDUCE_SUM = 0;
// {$EXTERNALSYM CV_REDUCE_SUM}
// const CV_REDUCE_AVG = 1;
// {$EXTERNALSYM CV_REDUCE_AVG}
// const CV_REDUCE_MAX = 2;
// {$EXTERNALSYM CV_REDUCE_MAX}
// const CV_REDUCE_MIN = 3;
// {$EXTERNALSYM CV_REDUCE_MIN}
// procedure cvReduce(v1: - 1); * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * \ * Discrete Linear Transforms and Related Functions * * * * * * * * * * * * * * * * * * * * * *
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * * * * * * * * * * * * * * * * * * )const CV_DXT_FORWARD = 0;
// {$EXTERNALSYM CV_DXT_FORWARD}const CV_DXT_INVERSE = 1;
// {$EXTERNALSYM CV_DXT_INVERSE}const CV_DXT_SCALE = 2;
// (* divide result by size of array *){$EXTERNALSYM CV_DXT_SCALE}const CV_DXT_INV_SCALE =
// (CV_DXT_INVERSE + CV_DXT_SCALE): Double;
// {$EXTERNALSYM CV_DXT_INV_SCALE}const CV_DXT_INVERSE_SCALE = CV_DXT_INV_SCALE;
// {$EXTERNALSYM CV_DXT_INVERSE_SCALE}const CV_DXT_ROWS = 4;
// (* transform each row individually *){$EXTERNALSYM CV_DXT_ROWS}const CV_DXT_MUL_CONJ = 8;
// (* conjugate the second argument of cvMulSpectrums *){$EXTERNALSYM CV_DXT_MUL_CONJ}(* Discrete Fourier Transform:    complex^.complex: array of function op CV_DEFAULT(v1: CV_REDUCE_SUM)): Integer;(;
// (forward): cReal^.ccs;
// var )procedure  cvDFT(  CvArr* src: ccs^.cReal (inverse);
// var dst: CvArr;
// flags: Integer;
// var Multiply results of DFTs: DFT(X)*DFT(Y) or DFT(X)*conj(DFT(Y)) *)
// procedure cvMulSpectrums(CvArr * src1:
// function nonzero_rows CV_DEFAULT(v1: 0)): Integer; const cvFFT = cvDFT;
// {$EXTERNALSYM cvFFT}(; var src2: CvArr; var dst: CvArr;
// var Finds optimal DFT vector size >= size0 * )CVAPI(Integer)cvGetOptimalDFTSize(Integer size0
// : Integer flags): CvArr; ();
//
// (* Discrete Cosine Transform *)
// procedure cvDCT(var src: CvArr; var dst: CvArr; flags: Integer);


// ****************************************************************************************
// *                              Dynamic data structures                                 *
// ****************************************************************************************

// (* Calculates length of sequence slice (with support of negative indices). *)
// CVAPI(Integer)cvSliceLength(CvSlice slice, CvSeq * seq);

{
  (* Creates new memory storage. block_size = 0 means that default,
  somewhat optimal size, is used (currently, it is 64K) *)

  CVAPI(CvMemStorage)cvCreateMemStorage(Integer block_size CV_DEFAULT(0));
}

function cvCreateMemStorage(block_size: Integer = 0): pCvMemStorage; cdecl;

// (* Creates a memory storage that will borrow memory blocks from parent storage *)
// CVAPI(CvMemStorage)cvCreateChildMemStorage(CvMemStorage * parent);

{
  /* Releases memory storage. All the children of a parent must be released before
  the parent. A child storage returns all the blocks to parent when it is released */
  CVAPI(void)  cvReleaseMemStorage( CvMemStorage** storage );
}
procedure cvReleaseMemStorage(var storage: pCvMemStorage); cdecl;

// (* Clears memory storage. This is the only way(!!!) (besides cvRestoreMemStoragePos)
// to reuse memory allocated for the storage - cvClearSeq,cvClearSet Args: array of const
// do not free any memory.
// A child storage returns all the blocks to the parent when it is cleared *)
// CVAPI(void)  cvClearMemStorage( CvMemStorage* storage );
procedure cvClearMemStorage(storage: pCvMemStorage); cdecl;
//
// (* Remember a storage "free memory" position *)
// procedure cvSaveMemStoragePos(var storage: CvMemStorage; var pos: CvMemStoragePos);
//
// (* Restore a storage "free memory" position *)
// procedure cvRestoreMemStoragePos(var storage: CvMemStorage; var pos: CvMemStoragePos);
//
// (* Allocates continuous buffer of the specified size in the storage *)
// procedure cvMemStorageAlloc(var storage: CvMemStorage; size: size_t);
//
// (* Allocates string in memory storage *)
// CVAPI(CvString)cvMemStorageAllocString(CvMemStorage * storage, PCVChar ptr,
// function len CV_DEFAULT(v1: - 1)): Integer;

{
  /* Creates new empty sequence that will reside in the specified storage */
  CVAPI(CvSeq*)  cvCreateSeq( int seq_flags, size_t header_size,
  size_t elem_size, CvMemStorage* storage );
}
function cvCreateSeq(seq_flags: Integer; header_size: size_t; elem_size: size_t; storage: pCvMemStorage): pCvSeq; cdecl;

// (* Changes default size (granularity) of sequence blocks.
// The default size is ~1Kbyte *)
// procedure cvSetSeqBlockSize(var seq: CvSeq; delta_elems: Integer);
//

{
  /* Adds new element to the end of sequence. Returns pointer to the element */
  CVAPI(schar*)  cvSeqPush( CvSeq* seq, const void* element CV_DEFAULT(NULL));
}
function cvSeqPush(seq: pCvSeq; const element: Pointer = nil): Pointer; cdecl;

// (* Adds new element to the beginning of sequence. Returns pointer to it *)
// CVAPI(schar)cvSeqPushFront(CvSeq * seq, Pointer element CV_DEFAULT(0));
//
// (* Removes the last element from sequence and optionally saves it *)
// procedure cvSeqPop(v1: 0));
//
// (* Removes the first element from sequence and optioanally saves it *)
// procedure cvSeqPopFront(v1: 0));
//
// const CV_FRONT = 1;
// {$EXTERNALSYM CV_FRONT}
// const CV_BACK = 0;
// {$EXTERNALSYM CV_BACK}
// (* Adds several new elements to the end of sequence *)
// procedure cvSeqPushMulti(var Removes several elements from the end of sequence and
// optionally saves them * )
// procedure cvSeqPopMulti(CvSeq * seq: v1: 0)): Integer; (; var elements: void; count:
// function; var Inserts A new element in the middle of sequence.cvSeqInsert(seq
// : Integer in_front CV_DEFAULT(v1: 0)): Integer; (; :; = cvSeqPushFront(seq: lem);
// var)CVAPI(schar)cvSeqInsert(CvSeq * seq: lem); before_index: Integer;
// var Removes specified sequence element * )
// procedure cvSeqRemove(CvSeq * seq: unction element CV_DEFAULT(v1: 0)): Pointer; (; index: Integer);
//
// (* Removes all the elements from the sequence. The freed memory
// can be reused later only by the same sequence unless cvClearMemStorage
// or cvRestoreMemStoragePos is called *)
// procedure cvClearSeq(var seq: CvSeq);

{
  /* Retrieves pointer to specified sequence element.
  Negative indices are supported and mean counting from the end
  (e.g -1 means the last sequence element) */
  CVAPI(schar*)  cvGetSeqElem( const CvSeq* seq, int index );
}
function cvGetSeqElem(const seq: pCvSeq; index: Integer): Pointer; cdecl;

// (* Calculates index of the specified sequence element.
// Returns -1 if element does not belong to the sequence *)
// CVAPI(Integer)cvSeqElemIdx(CvSeq * seq, Pointer element, CvSeqBlock * * block CV_DEFAULT(0));
//
// (* Initializes sequence writer. The new elements will be added to the end of sequence *)
// procedure cvStartAppendToSeq(var seq: CvSeq; var writer: CvSeqWriter);
//
// (* Combination of cvCreateSeq and cvStartAppendToSeq *)
// procedure cvStartWriteSeq(seq_flags: Integer; header_size: Integer; elem_size: Integer;
// var storage: CvMemStorage; var writer: CvSeqWriter);
//
// (* Closes sequence writer, updates sequence header and returns pointer
// to the resultant sequence
// (which may be useful if the sequence was created using cvStartWriteSeq)) then
// *)
// CVAPI(CvSeq)cvEndWriteSeq(CvSeqWriter * writer);
//
// (* Updates sequence header. May be useful to get access to some of previously
// written elements via cvGetSeqElem or sequence reader *)
// procedure cvFlushSeqWriter(var writer: CvSeqWriter);

{
  /* Initializes sequence reader.
  The sequence can be read in forward or backward direction */
  CVAPI(void) cvStartReadSeq( const CvSeq* seq, CvSeqReader* reader,
  int reverse CV_DEFAULT(0) );

}
procedure cvStartReadSeq(const seq: Pointer; reader: pCvSeqReader; reverse: Integer = 0); cdecl;
// procedure cvStartReadSeq(const seq: pCvSeq; reader: pCvSeqReader; reverse: Integer = 0); cdecl; overload;
// procedure cvStartReadSeq(const seq: pCvSet; reader: pCvSeqReader; reverse: Integer = 0); cdecl; overload;

// CVAPI(Integer)cvGetSeqReaderPos(CvSeqReader * reader: v1: 0)): Integer; ();

{
  /* Copies sequence content to a continuous piece of memory */
  CVAPI(void*)  cvCvtSeqToArray( const CvSeq* seq, void* elements,
  CvSlice slice CV_DEFAULT(CV_WHOLE_SEQ) );
}
function cvCvtSeqToArray(const seq: pCvSeq; elements: Pointer; slice: TCvSlice { =CV_WHOLE_SEQ } ): Pointer; cdecl;

// (* Creates sequence header for array.
// After that all the operations on sequences that do not alter the content
// can be applied to the resultant sequence *)
// CVAPI(CvSeq)cvMakeSeqHeaderForArray(Integer seq_type, Integer header_size, Integer elem_size,
// Pointer elements, Integer total, CvSeq * seq, CvSeqBlock * block);
//
// (* Extracts sequence slice (with or without copying sequence elements) *)
// CVAPI(CvSeq)cvSeqSlice(CvSeq * seq, CvSlice slice, CvMemStorage * storage CV_DEFAULT(0),
// function copy_function CV_DEFAULT(v1: 0)): Integer;
//
// CV_INLINE CvSeq * cvCloneSeq(CvSeq * seq, CvMemStorage * storage CV_DEFAULT(0))begin result :=
// cvSeqSlice(seq, CV_WHOLE_SEQ, storage, 1): data; end;
//
// (* Removes sequence slice *)
// procedure cvSeqRemoveSlice(var seq: CvSeq; slice: CvSlice);
//
// (* Inserts a sequence or array into another sequence *)
// procedure cvSeqInsertSlice(var seq: CvSeq; before_index: Integer; var from_arr: CvArr);
//
// (* a < b ? -1 : a > b ? 1 : 0 *)
// type CvCmpFunc =
// function(A: Pointer; B: Pointer; userdata: Pointer): Integer; CV_CDECL *;
//
// (* Sorts sequence in-place given element comparison function *)
// procedure cvSeqSort(v1: 0));
//
// (* Finds element in a [sorted] sequence *)
// CVAPI(schar)cvSeqSearch(CvSeq * seq, Pointer elem, CvCmpFunc func, Integer is_sorted,
// Integer * elem_idx,
// function userdata CV_DEFAULT(v1: 0)): Pointer;
//
// (* Reverses order of sequence elements in-place *)
// procedure cvSeqInvert(var seq: CvSeq);
//
// (* Splits sequence into one or more equivalence classes using the specified criteria *)
// CVAPI(Integer)cvSeqPartition(CvSeq * seq, CvMemStorage * storage, CvSeq * * labels,
// CvCmpFunc is_equal, Pointer userdata);

// ************ Internal sequence functions ************/
// CVAPI(void)  cvChangeSeqBlock( void* reader, int direction );
procedure cvChangeSeqBlock(reader: pCvSeqReader; direction: Integer); cdecl;
// CVAPI(void)  cvCreateSeqBlock( CvSeqWriter* writer );
procedure cvCreateSeqBlock(writer: pCvSeqWriter); cdecl;

// (* Creates a new set *)
// CVAPI(cvSet)cvCreateSet(Integer set_flags, Integer header_size, Integer elem_size,
// CvMemStorage * storage);
//
// (* Adds new element to the set and returns pointer to it *)
// CVAPI(Integer)cvSetAdd(cvSet * set_header, CvSetElem * elem CV_DEFAULT(0),
// CvSetElem * * inserted_elem CV_DEFAULT(0));
//
// (* Fast variant of cvSetAdd *)
// CV_INLINE CvSetElem * cvSetNew(cvSet * set_header)begin CvSetElem * elem := set_header^.free_elems;
// if (elem) then begin set_header^.free_elems := elem^.next_free;
// elem^.flags := elem^.flags and CV_SET_ELEM_IDX_MASK; set_header^.active_count := mod +1; end;
// else cvSetAdd(set_header, 0, (CvSetElem * )&elem); result := elem; end;
//
// (* Removes set element given its pointer *)
// CV_INLINE CV_INLINE
// procedure cvSetRemoveByPtr(var & &(elem - > flags & CV_SET_ELEM_IDX_MASK) < set_header - > total * )
// : CvSetElem)elem; Assert(_elem^.flags > := 0(); _elem^.next_free := set_header^.free_elems;
// _elem^.flags := (_elem^.flags and CV_SET_ELEM_IDX_MASK) or CV_SET_ELEM_FREE_FLAG;
// set_header^.free_elems := _elem; set_header^.active_count := mod -1; end;
//
// (* Removes element from the set by its index *)
// procedure cvSetRemove(var set_header: cvSet; index: Integer);
//
// (* Returns a set element by index. If the element doesn't belong to the set,
// 0 is returned *)
// CV_INLINE CvSetElem * cvGetSetElem(cvSet * set_header, Integer idx)begin CvSetElem * elem :=
// (CvSetElem)cvGetSeqElem((CvSeq)set_header, idx);
// result := elem and CV_IS_SET_ELEM(elem)? elem: 0; end;
//
// (* Removes all the elements from the set *)
// procedure cvClearSet(var set_header: cvSet);
//
// (* Creates new graph *)
// CVAPI(CvGraph)cvCreateGraph(Integer graph_flags, Integer header_size, Integer vtx_size,
// Integer edge_size, CvMemStorage * storage);
//
// (* Adds new vertex to the graph *)
// CVAPI(Integer)cvGraphAddVtx(CvGraph * graph, CvGraphVtx * vtx CV_DEFAULT(0),
// CvGraphVtx * * inserted_vtx CV_DEFAULT(0));
//
// (* Removes vertex from the graph together with all incident edges *)
// CVAPI(Integer)cvGraphRemoveVtx(CvGraph * graph, Integer index);
// CVAPI(Integer)cvGraphRemoveVtxByPtr(CvGraph * graph, CvGraphVtx * vtx);
//
// (* Link two vertices specifed by indices or pointers if they
// are not connected or result:= cPointer to already existing edge
// connecting the vertices.
// Functions result:= 1 if a new edge was created, 0 otherwise *)
// CVAPI(Integer)cvGraphAddEdge(CvGraph * graph, Integer start_idx, Integer end_idx,
// CvGraphEdge * edge CV_DEFAULT(0), CvGraphEdge * * inserted_edge CV_DEFAULT(0));
//
// CVAPI(Integer)cvGraphAddEdgeByPtr(CvGraph * graph, CvGraphVtx * start_vtx, CvGraphVtx * end_vtx,
// CvGraphEdge * edge CV_DEFAULT(0), CvGraphEdge * * inserted_edge CV_DEFAULT(0));
//
// (* Remove edge connecting two vertices *)
// procedure cvGraphRemoveEdge(var graph: CvGraph; start_idx: Integer; end_idx: Integer);
// procedure cvGraphRemoveEdgeByPtr(var graph: CvGraph; var start_vtx: CvGraphVtx;
// var end_vtx: CvGraphVtx);
//
// (* Find edge connecting two vertices *)
// CVAPI(CvGraphEdge)cvFindGraphEdge(CvGraph * graph, Integer start_idx, Integer end_idx);
// CVAPI(CvGraphEdge)cvFindGraphEdgeByPtr(CvGraph * graph, CvGraphVtx * start_vtx,
// CvGraphVtx * end_vtx); const cvGraphFindEdge = cvFindGraphEdge;
// {$EXTERNALSYM cvGraphFindEdge}
// const cvGraphFindEdgeByPtr = cvFindGraphEdgeByPtr;
// {$EXTERNALSYM cvGraphFindEdgeByPtr}
// (* Remove all vertices and edges from the graph *)
// procedure cvClearGraph(var graph: CvGraph);
//
// (* Count number of edges incident to the vertex *)
// CVAPI(Integer)cvGraphVtxDegree(CvGraph * graph, Integer vtx_idx);
// CVAPI(Integer)cvGraphVtxDegreeByPtr(CvGraph * graph, CvGraphVtx * vtx);
//
// (* Retrieves graph vertex by given index *)
/// / >> Following declaration is a macro definition!
// const cvGetGraphVtx(graph, idx(CvGraphVtx)cvGetSetElem((cvSet(graph), (idx));
//
// (* Retrieves index of a graph vertex given its pointer *)
// // >> Following declaration is a macro definition!
// const cvGraphVtxIdx(graph, vtx((vtx)^.flags and CV_SET_ELEM_IDX_MASK);
//
// (* Retrieves index of a graph edge given its pointer *)
// // >> Following declaration is a macro definition!
// const cvGraphEdgeIdx(graph, edge((edge)^.flags and CV_SET_ELEM_IDX_MASK);
//
// // >> Following declaration is a macro definition!
// const cvGraphGetVtxCount(graph((graph)^.active_count);
// // >> Following declaration is a macro definition!
// const cvGraphGetEdgeCount(graph((graph)^.edges^.active_count);
//
// const CV_GRAPH_VERTEX = 1;
// {$EXTERNALSYM CV_GRAPH_VERTEX}
// const CV_GRAPH_TREE_EDGE = 2;
// {$EXTERNALSYM CV_GRAPH_TREE_EDGE}
// const CV_GRAPH_BACK_EDGE = 4;
// {$EXTERNALSYM CV_GRAPH_BACK_EDGE}
// const CV_GRAPH_FORWARD_EDGE = 8;
// {$EXTERNALSYM CV_GRAPH_FORWARD_EDGE}
// const CV_GRAPH_CROSS_EDGE = 16;
// {$EXTERNALSYM CV_GRAPH_CROSS_EDGE}
// const CV_GRAPH_ANY_EDGE = 30;
// {$EXTERNALSYM CV_GRAPH_ANY_EDGE}
// const CV_GRAPH_NEW_TREE = 32;
// {$EXTERNALSYM CV_GRAPH_NEW_TREE}
// const CV_GRAPH_BACKTRACKING = 64;
// {$EXTERNALSYM CV_GRAPH_BACKTRACKING}
// const CV_GRAPH_OVER = -1;
// {$EXTERNALSYM CV_GRAPH_OVER}
// const CV_GRAPH_ALL_ITEMS = -1;
// {$EXTERNALSYM CV_GRAPH_ALL_ITEMS}
// (* flags for graph vertices and edges *)
// const CV_GRAPH_ITEM_VISITED_FLAG = (1 shl 30);
// {$EXTERNALSYM CV_GRAPH_ITEM_VISITED_FLAG}
// // >> Following declaration is a macro definition!
// const CV_IS_GRAPH_VERTEX_VISITED(vtx)(((CvGraphVtx(vtx))^.flags and CV_GRAPH_ITEM_VISITED_FLAG);
// // >> Following declaration is a macro definition!
// const CV_IS_GRAPH_EDGE_VISITED(edge)(((CvGraphEdge(edge))^.flags and CV_GRAPH_ITEM_VISITED_FLAG);
// const CV_GRAPH_SEARCH_TREE_NODE_FLAG = (1 shl 29);
// {$EXTERNALSYM CV_GRAPH_SEARCH_TREE_NODE_FLAG}
// const CV_GRAPH_FORWARD_EDGE_FLAG = (1 shl 28);
// {$EXTERNALSYM CV_GRAPH_FORWARD_EDGE_FLAG}
// type
//
// = record vtx: ^CvGraphVtx; (* current graph vertex (or current edge origin) *)
// dst: ^CvGraphVtx; (* current graph edge destination vertex *)
// edge: ^CvGraphEdge; (* current edge *)
// graph: ^CvGraph; (* the graph *)
// stack: ^CvSeq; (* the graph vertex stack *)
// index: Integer; (* the lower bound of certainly visited vertices *)
// mask: Integer; (* event mask *)
// end; CvGraphScanner;
//
// (* Creates new graph scanner. *)
// CVAPI(CvGraphScanner)cvCreateGraphScanner(CvGraph * graph, CvGraphVtx * vtx CV_DEFAULT(0),
// function mask CV_DEFAULT(v1: CV_GRAPH_ALL_ITEMS)): Integer;
//
// (* Releases graph scanner. *)
// procedure cvReleaseGraphScanner(scanner: array of CvGraphScanner);
//
// (* Get next graph element *)
// CVAPI(Integer)cvNextGraphItem(CvGraphScanner * scanner);
//
// (* Creates a copy of graph *)
// CVAPI(CvGraph)cvCloneGraph(CvGraph * graph, CvMemStorage * storage);
//
// (* ***************************************************************************************\
// *                                     Drawing                                            *
// *************************************************************************************** *)
//
// (* ***************************************************************************************\
// *       Drawing functions work with images/matrices of arbitrary cType.                   *
// *       For color images the channel order is BGR : array[0..A-1] of                                      *
// *       Antialiasing is supported only for 8-bit image now.                              *
// *       All the functions include parameter color that means rgb value (that may be      *
// *       constructed with CV_RGB macro) for color images and brightness                   *
// *       for grayscale images.                                                            *
// *       If a drawn figure is partially or completely outside of the image, it is clipped.*
// *************************************************************************************** *)
//
/// / >> Following declaration is a macro definition!
function CV_RGB(const r, g, B: Double): TCvScalar; inline;
// CvScalar((B), (g), (r), 0);

const
  CV_FILLED = -1;
{$EXTERNALSYM CV_FILLED}
  CV_AA = 16;
{$EXTERNALSYM CV_AA}
  // (* Draws 4-connected, 8-connected or antialiased line segment connecting two points *)
  // procedure cvLine(8: v1: ); shift CV_DEFAULT(0): Integer): Integer;
  {
    CVAPI(void)  cvLine( CvArr* img, CvPoint pt1, CvPoint pt2,
    CvScalar color, int thickness CV_DEFAULT(1),
    int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0) );
  }
procedure cvLine(img: pCvArr; pt1, pt2: TCvPoint; color: TCvScalar; thickness: Integer = 1; line_type: Integer = 8;
  shift: Integer = 0); cdecl;
// procedure cvLine(img: pIplImage; pt1, pt2: TCvPoint; color: TCvScalar; thickness: Integer = 1; line_type: Integer = 8;
// shift: Integer = 0); cdecl; overload;
// procedure cvLine(img: pCvMat; pt1, pt2: TCvPoint; color: TCvScalar; thickness: Integer = 1; line_type: Integer = 8;
// shift: Integer = 0); cdecl; overload;

{
  /* Draws a rectangle given two opposite corners of the rectangle (pt1 & pt2),
  if thickness<0 (e.g. thickness == CV_FILLED), the filled box is drawn */
  CVAPI(void)  cvRectangle(
  CvArr* img,
  CvPoint pt1,
  CvPoint pt2,
  CvScalar color,
  int thickness CV_DEFAULT(1),
  int line_type CV_DEFAULT(8),
  int shift CV_DEFAULT(0));
}
procedure cvRectangle(img: pIplImage; pt1, pt2: TCvPoint; color: TCvScalar; thickness: Integer = 1;
  line_type: Integer = 8; shift: Integer = 0); cdecl;

{
  //Draws a circle with specified center and radius.
  CVAPI(void)  cvCircle(
  CvArr* img,
  CvPoint center,
  int radius,
  CvScalar color,
  int thickness CV_DEFAULT(1),
  int line_type CV_DEFAULT(8),
  int shift CV_DEFAULT(0));
}
procedure cvCircle(img: pCvArr; center: TCvPoint; radius: Integer; color: TCvScalar; thickness: Integer = 1;
  line_type: Integer = 8; shift: Integer = 0); cdecl;
// procedure cvCircle(img: pIplImage; center: TCvPoint; radius: Integer; color: TCvScalar; thickness: Integer = 1;
// line_type: Integer = 8; shift: Integer = 0); cdecl; overload;
// procedure cvCircle(img: pCvMat; center: TCvPoint; radius: Integer; color: TCvScalar; thickness: Integer = 1;
// line_type: Integer = 8; shift: Integer = 0); cdecl; overload;

{
  /* Draws ellipse outline, filled ellipse, elliptic arc or filled elliptic sector,
  depending on <thickness>, <start_angle> and <end_angle> parameters. The resultant figure
  is rotated by <angle>. All the angles are in degrees */
  CVAPI(void)  cvEllipse( CvArr* img, CvPoint center, CvSize axes,
  double angle, double start_angle, double end_angle,
  CvScalar color, int thickness CV_DEFAULT(1),
  int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0));

}

procedure cvEllipse(img: pIplImage; center: TCvPoint; axes: TCvSize; angle: Double; start_angle: Double;
  nd_angle: Double; color: TCvScalar; thickness: Integer = 1; line_type: Integer = 8; shift: Integer = 0); cdecl;

(*
  CV_INLINE  void  cvEllipseBox( CvArr* img, CvBox2D box, CvScalar color,
  int thickness CV_DEFAULT(1),
  int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0) )
  {
  CvSize axes;
  axes.width = cvRound(box.size.width*0.5);
  axes.height = cvRound(box.size.height*0.5);

  cvEllipse( img, cvPointFrom32f( box.center ), axes, box.angle,
  0, 360, color, thickness, line_type, shift );
  }
*)
procedure cvEllipseBox(img: pIplImage; box: TCvBox2D; color: TCvScalar; thickness: Integer = 1; line_type: Integer = 8;
  shift: Integer = 0); inline;

/// * Fills convex or monotonous polygon. */
// CVAPI(void)  cvFillConvexPoly( CvArr* img, const CvPoint* pts, int npts, CvScalar color,
// int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0));
procedure cvFillConvexPoly(img: pIplImage; const pts: pCVPoint; npts: Integer; color: TCvScalar; line_type: Integer = 8;
  shift: Integer = 0); cdecl;

{
  /* Draws one or more polygonal curves */
  CVAPI(void)  cvPolyLine( CvArr* img, CvPoint** pts, const int* npts, int contours,
  int is_closed, CvScalar color, int thickness CV_DEFAULT(1),
  int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0) );
}

procedure cvPolyLine(img: pIplImage; pts: pCVPoint; const npts: pInteger; contours: Integer; is_closed: Integer;
  color: TCvScalar; thickness: Integer = 1; line_type: Integer = 8; shift: Integer = 0); cdecl;

// const
// cvDrawRect = cvRectangle;
// {$EXTERNALSYM cvDrawRect}
// cvDrawLine = cvLine;
// {$EXTERNALSYM cvDrawLine}
// cvDrawCircle = cvCircle;
// {$EXTERNALSYM cvDrawCircle}
// cvDrawEllipse = cvEllipse;
// {$EXTERNALSYM cvDrawEllipse}
// cvDrawPolyLine = cvPolyLine;
// {$EXTERNALSYM cvDrawPolyLine}

// (* Clips the line segment connecting *pt1 and *pt2
// by the rectangular window
// (0<=x<img_size.width, 0<=y<img_size.height). *)
// CVAPI(Integer)cvClipLine(CvSize img_size, CvPoint * pt1, CvPoint * pt2);
//
// (* Initializes line iterator. Initially, line_iterator->ptr will point
// to pt1 (or pt2, see left_to_right description) location in the image.
// Returns the number of pixels on the line between the ending points. *)
// CVAPI(Integer)cvInitLineIterator(CvArr * image, CvPoint pt1, CvPoint pt2,
// CvLineIterator * line_iterator,
// function connectivity CV_DEFAULT(v1: 0)): Integer;
//
// (* Moves iterator to the next line point *)
/// / >> Following declaration is a macro definition!
// const CV_NEXT_LINE_POINT(line_iterator); begin Integer _line_iterator_mask = (line_iterator).err <
// 0 ? - 1: 0; (line_iterator).err := mod +(line_iterator).minus_delta + ((line_iterator)
// .plus_delta and _line_iterator_mask); (line_iterator).ptr := mod +(line_iterator).minus_step +
// ((line_iterator).plus_step and _line_iterator_mask); end;
//
(* basic font types *)
const
  CV_FONT_HERSHEY_SIMPLEX = 0;
{$EXTERNALSYM CV_FONT_HERSHEY_SIMPLEX}
  CV_FONT_HERSHEY_PLAIN = 1;
{$EXTERNALSYM CV_FONT_HERSHEY_PLAIN}
  CV_FONT_HERSHEY_DUPLEX = 2;
{$EXTERNALSYM CV_FONT_HERSHEY_DUPLEX}
  CV_FONT_HERSHEY_COMPLEX = 3;
{$EXTERNALSYM CV_FONT_HERSHEY_COMPLEX}
  CV_FONT_HERSHEY_TRIPLEX = 4;
{$EXTERNALSYM CV_FONT_HERSHEY_TRIPLEX}
  CV_FONT_HERSHEY_COMPLEX_SMALL = 5;
{$EXTERNALSYM CV_FONT_HERSHEY_COMPLEX_SMALL}
  CV_FONT_HERSHEY_SCRIPT_SIMPLEX = 6;
{$EXTERNALSYM CV_FONT_HERSHEY_SCRIPT_SIMPLEX}
  CV_FONT_HERSHEY_SCRIPT_COMPLEX = 7;
{$EXTERNALSYM CV_FONT_HERSHEY_SCRIPT_COMPLEX}
  (* font flags *)
  CV_FONT_ITALIC = 16;
{$EXTERNALSYM CV_FONT_ITALIC}
  CV_FONT_VECTOR0 = CV_FONT_HERSHEY_SIMPLEX;
{$EXTERNALSYM CV_FONT_VECTOR0}

  (* Font structure *)
  // type
  //
type
  pCvFont = ^TCvFont;

  TCvFont = packed record
    nameFont: pCVChar; // Qt:nameFont
    color: TCvScalar;
    // Qt:ColorFont -> cvScalar(blue_component, green_component, red\_component[, alpha_component])
    font_face: Integer; // Qt: bool italic         /* =CV_FONT_* */
    ascii: pInteger; // * font data and metrics */
    greek: pInteger;
    cyrillic: pInteger;
    hscale, vscale: Single;
    shear: Single; // * slope coefficient: 0 - normal, >0 - italic */
    thickness: Integer; // Qt: weight               /* letters thickness */
    dx: Single; // * horizontal interval between letters */
    line_type: Integer; // Qt: PointSize
  end;

  {
    // Initializes font structure used further in cvPutText *)
    CVAPI(void) cvInitFont(
    CvFont* font,
    int font_face,
    double hscale,
    double vscale,
    double shear CV_DEFAULT(0),
    int thickness CV_DEFAULT(1),
    int line_type CV_DEFAULT(8));
  }
procedure cvInitFont(
  { } font: pCvFont;
  { } font_face: Integer;
  { } hscale: Double;
  { } vscale: Double;
  { } shear: Double = 0;
  { } thickness: Integer = 1;
  { } line_type: Integer = 8); cdecl;

//
// CV_INLINE CvFont CvFont(Double scale, Integer thickness CV_DEFAULT(1))begin CvFont font;
// cvInitFont(and font, CV_FONT_HERSHEY_PLAIN, scale, scale, 0, thickness, CV_AA): Double;
// result := font; end;
//
// (* Renders text stroke with specified font and color at specified location.
// CvFont should be initialized with cvInitFont *)
// procedure cvPutText(var img: CvArr; text: PCVChar; org: CvPoint; var font: vFont; color: CvScalar);
{
  CVAPI(void)  cvPutText( CvArr* img, const char* text, CvPoint org,
  const CvFont* font, CvScalar color );
}
procedure cvPutText(img: pIplImage; const text: pCVChar; org: TCvPoint; const font: pCvFont; color: TCvScalar); cdecl;

//
// (* Calculates bounding box of text stroke (useful for alignment) *)
// procedure cvGetTextSize(text_string: PCVChar; var font: CvFont; var text_size: CvSize;
// var baseline: Integer);
//
// (* Unpacks color value, if arrtype is CV_8UC?, <color> is treated as
// packed color value, otherwise the first channels (depending on arrtype)
// of destination scalar are set to the same value = <color> *)
// CVAPI(CvScalar)cvColorToScalar(Double packed_color, Integer arrtype);
//
// (* Returns the polygon points which make up the given ellipse.  The ellipse is define by
// the box of size 'axes' rotated 'angle' around the 'center'.  A partial sweep
// of the ellipse arc can be done by spcifying arc_start and arc_end to be something
// other than 0 and 360, respectively.  The input cArray 'pts' must be large enough to
// hold the cResult.  The total number of points stored into 'pts' is returned by this
// cFunction. *)
// CVAPI(Integer)cvEllipse2Poly(CvPoint center, CvSize axes, Integer angle, Integer arc_start,
// Integer arc_end, CvPoint * pts, Integer delta);
//

{ /* Draws contour outlines or filled interiors on the image */
  CVAPI(void)  cvDrawContours(
  CvArr *img,
  CvSeq* contour,
  CvScalar external_color,
  CvScalar hole_color,
  int max_level,
  int thickness CV_DEFAULT(1),
  int line_type CV_DEFAULT(8),
  CvPoint offset CV_DEFAULT(cvPoint(0,0)));
}
procedure cvDrawContours(
  { } img: pIplImage;
  { } contour: pCvSeq;
  { } external_color: TCvScalar;
  { } hole_color: TCvScalar;
  { } max_level: Integer;
  { } thickness: Integer { =1 };
  { } line_type: Integer { =8 };
  { } offset: TCvPoint { =cvPoint(0,0) } ); cdecl;


// (* Does look-up transformation. Elements of the source array
// (that should be 8uC1 or 8sC1) are used as indexes in lutarr 256-element table *)
// procedure cvLUT(var src: CvArr; var dst: CvArr; var lut: CvArr);
//
// (* ****************** Iteration through the sequence tree **************** *)
// type
//
// = record node: Pointer; level: Integer; max_level: Integer; end; CvTreeNodeIterator;
//
// procedure cvInitTreeNodeIterator(var tree_iterator: CvTreeNodeIterator; first: ointer;
// max_level: Integer);
// procedure cvNextTreeNode(var tree_iterator: CvTreeNodeIterator);
// procedure cvPrevTreeNode(var tree_iterator: CvTreeNodeIterator);
//
// (* Inserts sequence into tree with specified "parent" sequence.
// If parent is equal to frame (e.g. the most external contour),
// then added contour will have null cPointer to parent. *)
// procedure cvInsertNodeIntoTree(node: Pointer; parent: Pointer; frame: Pointer);
//
// (* Removes contour from tree (together with the contour children). *)
// procedure cvRemoveNodeFromTree(node: Pointer; frame: Pointer);
//
// (* Gathers pointers to all the sequences,
// accessible from the <first>, to the single sequence *)
// CVAPI(CvSeq)cvTreeToNodeSeq(Pointer first, Integer header_size, CvMemStorage * storage);
//
// (* The function implements the K-means algorithm for clustering an array of sample
// vectors in a specified number of classes *)
// const CV_KMEANS_USE_INITIAL_LABELS = 1;
// {$EXTERNALSYM CV_KMEANS_USE_INITIAL_LABELS}
// CVAPI(Integer)cvKMeans2(CvArr * samples, Integer cluster_count, CvArr * labels,
// CvTermCriteria termcrit,
// function attempts CV_DEFAULT(v1: 0); flags CV_DEFAULT(0): Integer; _centers CV_DEFAULT(0):
// function; var compactness CV_DEFAULT(0): Double): Integer;
//
// (* ***************************************************************************************\
// *                                    System functions                                    *
// *************************************************************************************** *)
//
// (* Add the function pointers table with associated information to the IPP primitives list *)
// CVAPI(Integer)cvRegisterModule(CvModuleInfo * module_info): CvArr;
//
// (* Loads optimized functions from IPP, MKL etc. or switches back to pure C code *)
// CVAPI(Integer)cvUseOptimized(Integer on_off): CvRNG;
//
// (* Retrieves information about the registered modules and loaded optimized plugins *)
// procedure cvGetModuleInfo(module_name: PCVChar; var version: Char; var loaded_addon_plugins: Char);
//
// type * CvAllocFunc =
// function(size: size_t; userdata: Pointer): Pointer; CV_CDECL; type * CvFreeFunc =
// function(var CvFreetype
// procedure * pptr: CV_CDECL; userdata: Pointer): Integer; CV_CDECL; =
// procedure (* Set user-defined memory managment functions (substitutors for malloc and free) that
// will be called by cvAlloc, cvFree and higher-level functions (e.g. cvCreateImage) *)
// procedure cvSetMemoryManager(v1: 0); free_func CV_DEFAULT(0): CvFreeFunc;
// var (CV_STDCALL * Cv_iplCreateImageHeader)(Integer:
// function userdata CV_DEFAULT(v1: 0)): Pointer; type IplImage; v4: nteger; v5: nteger; teger: Char;
// v7: nteger; v8: nteger; * : IplROI; * : plImage; plTileInfo: ointer);
// type CV_STDCALL * Cv_iplAllocateImageData =
// procedure (* : IplImage; v2: nteger; v3: nteger);
// type CV_STDCALL* Cv_iplDeallocate = procedure(*: IplImage; v2: nteger);
// type IplROI* (CV_STDCALL* Cv_iplCreateROI(Integer,Integer,Integer,Integer,Integer);
// type IplImage* (CV_STDCALL* Cv_iplCloneImage( IplImage);
//
// (* Makes OpenCV use IPL functions for IplImage allocation/deallocation *)
// procedure cvSetIPLAllocators(create_header: Cv_iplCreateImageHeader;
// allocate_data: Cv_iplAllocateImageData; deallocate: Cv_iplDeallocate; create_roi: Cv_iplCreateROI;
// clone_image: Cv_iplCloneImage);
//
/// / >> Following declaration is a macro definition!
// const CV_TURN_ON_IPL_COMPATIBILITY()cvSetIPLAllocators(iplCreateImageHeader, iplAllocateImage,
// iplDeallocate, iplCreateROI, iplCloneImage);
//
// (* ***************************************************************************************\
// *                                    Data Persistence                                    *
// *************************************************************************************** *)
//
// (* ********************************* High-level functions ******************************* *)

{
  /* opens existing or creates new file storage */
  CVAPI(CvFileStorage*)  cvOpenFileStorage( const char* filename, CvMemStorage* memstorage,
  int flags, const char* encoding CV_DEFAULT(NULL) );
}
function cvOpenFileStorage(const filename: pCVChar; memstorage: pCvMemStorage; flags: Integer;
  const encoding: pCVChar = nil): pCvFileStorage; cdecl;
{
  /* closes file storage and deallocates buffers */
  CVAPI(void) cvReleaseFileStorage( CvFileStorage** fs );
}
procedure cvReleaseFileStorage(Var fs: pCvFileStorage); cdecl;

// (* starts writing compound structure (map or sequence) *)
// procedure cvStartWriteStruct(var finishes writing compound structure * )
// procedure cvEndWriteStruct(CvFileStorage * fs): PCVChar; (* writes an integer *)
// procedure cvWriteInt(CvFileStorage * fs: v1: CvAttrList())): Integer; (; name: PCVChar;
// value: Integer);
//
// (* writes a floating-point number *)
// procedure cvWriteReal(var fs: CvFileStorage; name: PCVChar; value: Double);
//
// (* writes a string *)
// procedure cvWriteString(var writes A comment * )
// procedure cvWriteComment(CvFileStorage * fs: v1: 0)): Integer; (; comment: PCVChar;
// var writes instance of A standard type (Matrix: Integer eol_comment): PCVChar; (; v4: image;
// v5: sequence; var)
// procedure cvWrite(CvFileStorage * fs: graph etc.) or user - defined cType; name: Pointer;
// var ptr: void; attributes CV_DEFAULT(CvAttrList()): CvAttrList);
//
// (* starts the next stream *)
// procedure cvStartNextStream(var fs: CvFileStorage);
//
// (* helper function: writes multiple integer or floating-point numbers *)
// procedure cvWriteRawData(var fs: CvFileStorage; var src: void; len: nteger; dt: PCVChar);
//
// (* returns the hash entry corresponding to the specified literal key string or 0
// if there is no such a key in the storage *)
// CVAPI(CvStringHashNode)cvGetHashedKey(CvFileStorage * fs, PCVChar name,
// function len CV_DEFAULT(v1: 0)): Integer;
//
// (* returns file node with the specified key within the specified map
// (collection of named nodes) *)
// CVAPI(CvFileNode)cvGetRootFileNode(CvFileStorage * fs,
// function stream_index CV_DEFAULT(v1: 0)): Integer;
//
// (* returns file node with the specified key within the specified map
// (collection of named nodes) *)
// CVAPI(CvFileNode)cvGetFileNode(CvFileStorage * fs, CvFileNode * map, CvStringHashNode * key,
// function create_missing CV_DEFAULT(v1: 0)): Integer;
//
{
  /* this is a slower version of cvGetFileNode that takes the key as a literal string */
  CVAPI(CvFileNode*) cvGetFileNodeByName( const CvFileStorage* fs,
  const CvFileNode* map,
  const char* name );
}
function cvGetFileNodeByName(const fs: pCvFileStorage; const map: pCvFileNode; const name: pCVChar): pCvFileNode; cdecl;

(*
  CV_INLINE int cvReadInt( const CvFileNode* node, int default_value CV_DEFAULT(0) )
  {
  return !node ? default_value :
  CV_NODE_IS_INT(node->tag) ? node->data.i :
  CV_NODE_IS_REAL(node->tag) ? cvRound(node->data.f) : 0x7fffffff;
  }
*)
function cvReadInt(const node: pCvFileNode; default_value: Integer = 0): Integer; inline;

(*
  CV_INLINE int cvReadIntByName( const CvFileStorage* fs, const CvFileNode* map,
  const char* name, int default_value CV_DEFAULT(0) )
  {
  return cvReadInt( cvGetFileNodeByName( fs, map, name ), default_value );
  }
*)
function cvReadIntByName(const fs: pCvFileStorage; const map: pCvFileNode; const name: pCVChar;
  default_value: Integer = 0): Integer; inline;


// CV_INLINE
// function cvReadReal(var fs: 0. ))begin result := not node ? default_value: CV_NODE_IS_INT(node^.tag)
// ?(Double)node^.data.i: CV_NODE_IS_REAL(node^.tag)? node^.data.f: 1E300; end;
// CV_INLINE Double cvReadRealByName(CvFileStorage; var map: CvFileNode; name: Char;
// default_value CV_DEFAULT(0. ))begin result := cvReadReal(cvGetFileNodeByName(fs: Double; v5: map;
// ): name; v7: default_value): Double; end;
//
// CV_INLINE PCVChar cvReadString(CvFileNode * node, PCVChar default_value CV_DEFAULT(0))begin result :=
// not node ? default_value: CV_NODE_IS_STRING(node^.tag)? node^.data.str.ptr: 0; end;
//
// CV_INLINE PCVChar cvReadStringByName(CvFileStorage * fs, CvFileNode * map,
// const PCVChar = default_value CV_DEFAULT(0(): PCVChar;
// {$EXTERNALSYM PCVChar}
// begin result := cvReadString(cvGetFileNodeByName(fs, map, name), default_value); end;
//

{
  /* decodes standard or user-defined object and returns it */
  CVAPI(void*) cvRead( CvFileStorage* fs, CvFileNode* node,
  CvAttrList* attributes CV_DEFAULT(NULL));
}
function cvRead(fs: pCvFileStorage; node: pCvFileNode; attributes: pCvAttrList = nil): pPointer; cdecl;

//
// (* decodes standard or user-defined object and returns it *)
// CV_INLINE
// function cvReadByName()begin result := cvRead(fs: 0); fs: cvGetFileNodeByName(; v3: map;): name;
// v5: attributes): PCVChar; end;
//
// (* starts reading data from sequence or scalar numeric node *)
// procedure cvStartReadRawData(v1: var reads multiple numbers and stores them to array * )
// procedure cvReadRawDataSlice(CvFileStorage * fs; var reader: CvSeqReader; count: nteger;
// dst: Pointer; dt: PCVChar);
//
// (* combination of two previous functions for easier reading of whole sequences *)
// procedure cvReadRawData(var fs: CvFileStorage; var src: CvFileNode; dst: ointer; dt: PCVChar);
//
// (* writes a copy of file node to file storage *)
// procedure cvWriteFileNode(var fs: CvFileStorage; new_node_name: PCVChar; var node: vFileNode;
// embed: Integer);
//
// (* returns name of file node *)
// CVAPI(Char)cvGetFileNodeName(CvFileNode * node);
//
// (* ********************************** Adding own types ********************************** *)
//
// procedure cvRegisterType(var info: CvTypeInfo); CVAPI({$EXTERNALSYM }
// procedure)cvUnregisterType(type_name: PCVChar); CVAPI(CvTypeInfo)cvFirstType(
// procedure); CVAPI(type_name: PCVChar);
// CVAPI(CvTypeInfo)cvTypeOf(Pointer type cvTypeOf(Pointer struct_ptr) = record end:;
// rocedure)cvRelease(Pointer * type end:; r type end:;

{
  /* simple API for reading/writing data */
  CVAPI(void) cvSave( const char* filename,
  const void* struct_ptr,
  const char* name CV_DEFAULT(NULL),
  const char* comment CV_DEFAULT(NULL),
  CvAttrList attributes CV_DEFAULT(cvAttrList()));
  CVAPI(void*) cvLoad( const char* filename,
  CvMemStorage* memstorage CV_DEFAULT(NULL),
  const char* name CV_DEFAULT(NULL),
  const char** real_name CV_DEFAULT(NULL) );
}

procedure cvSave(const filename: pCVChar; const struct_ptr: Pointer; const name: pCVChar; const comment: pCVChar;
  attributes: TCvAttrList); cdecl; overload;
procedure cvSave(const filename: pCVChar; const struct_ptr: Pointer; const name: pCVChar = Nil;
  const comment: pCVChar = Nil); overload; inline;
function cvLoad(const filename: pCVChar; memstorage: pCvMemStorage = Nil; const name: pCVChar = nil;
  const real_name: ppChar = nil): Pointer; cdecl;

function cvGetTickCount: int64; inline;
function cvGetTickFrequency: Double;

const
  CV_CPU_NONE = 0;
  CV_CPU_MMX = 1;
  CV_CPU_SSE = 2;
  CV_CPU_SSE2 = 3;
  CV_CPU_SSE3 = 4;
  CV_CPU_SSSE3 = 5;
  CV_CPU_SSE4_1 = 6;
  CV_CPU_SSE4_2 = 7;
  CV_CPU_POPCNT = 8;
  CV_CPU_AVX = 10;
  CV_HARDWARE_MAX_FEATURE = 255;

  // cvCheckHardwareSupport(Integer feature): CVAPI(Integer); cvGetNumThreads(): CVAPI(Integer);
  // procedure cvSetNumThreads(v1: 0)); cvGetThreadNum(): CVAPI(Integer);
  // cvGetErrStatus(): CVAPI(Integer);
  // procedure cvSetErrStatus(status: Integer); CV_ErrModeLeaf = 0: const;
  // (* Print error and exit program *)
  // CV_ErrModeParent = 1: const; (* Print error and continue *)
  // CV_ErrModeSilent = 2: const; (* Don't print and continue */
  // cvGetErrMode(  ): CVAPI(Integer);
  // cvSetErrMode( Integer mode ): CVAPI(Integer);
  // PCVChar = file_name, Integer line ): const;;
  // char) cvErrorStr( Integer status ): CVAPI(;
  // filename, Integer* line ): ^PCVChar;
  // cvErrorFromIppStatus( Integer ipp_status ): CVAPI(Integer);
  // PCVChar = file_name, Integer line, Pointer  userdata ): const;;
  // prev_userdata CV_DEFAULT(0) ): ^Pointer;
  // = ): const;
  // file_name, Integer line, Pointer  userdata ): PCVChar;
  // file_name, Integer line, Pointer  userdata ): PCVChar;
  // file_name, Integer line, Pointer  userdata ): PCVChar;
  // OPENCV_ERROR(CV_StsBackTrace,(func),(context)): begin;
  // end; end;
  //
  // {$define OPENCV_ASSERT(expr,func,context)}
  // begin if ( not  (expr)) then
  // begin OPENCV_ERROR(CV_StsInternal,(func),(context)); end; end;
  //
  // {$define OPENCV_RSTERR((cvSetErrStatus(CV_StsOk))}
  //
  // // >> Following declaration is a macro definition!
  // const OPENCV_CALL( Func );
  // begin
  // Func;
  // end;
  //
  //
  // (* CV_FUNCNAME macro defines icvFuncName constant which is used by CV_ERROR macro *)
  // {$IFDEF CV_NO_FUNC_NAMES}
  /// / >> Following declaration is a macro definition!
  // const CV_FUNCNAME(Name); const cvFuncName = '';
  // {$EXTERNALSYM cvFuncName}
  // {$ELSE}
  /// / >> Following declaration is a macro definition!
  // const CV_FUNCNAME(Name); Char cvFuncName[] = Name
  // {$ENDIF}
  // (*
  // CV_ERROR macro unconditionally raises error with passed code and message.
  // After raising error, control will be transferred to the exit cLabel.
  // *)
  /// / >> Following declaration is a macro definition!
  // const CV_ERROR(Code, Msg); begin cvError((Code), cvFuncName, Msg, __FILE__, __LINE__);
  // __CV_EXIT__; end;
  //
  // (* Simplified form of CV_ERROR *)
  /// / >> Following declaration is a macro definition!
  // const CV_ERROR_FROM_CODE(Code)CV_ERROR(Code, '');
  //
  // (*
  // CV_CHECK macro checks error status after CV (or IPL)
  // cFunction call. If error detected, control will be transferred to the exit
  // cLabel.
  // *)
  // {$DEFINE CV_CHECK()}
  // begin if (cvGetErrStatus() < 0)CV_ERROR(CV_StsBackTrace, 'Inner function failed.') then; end;
  //
  // (*
  // CV_CALL macro calls CV (or IPL) cFunction, checks error status and
  // signals a error if the cFunction failed. Useful in 'parent node'
  // error procesing mode
  // *)
  /// / >> Following declaration is a macro definition!
  // const CV_CALL(func); begin func; CV_CHECK(); end;
  //
  // (* Runtime assertion macro *)
  /// / >> Following declaration is a macro definition!
  // const CV_ASSERT(Condition); begin if (not(Condition))CV_ERROR(CV_StsInternal,
  // 'Assertion: ' # Condition ' failed') then; end;
  //
  // const __CV_BEGIN__ = begin;
  // {$EXTERNALSYM __CV_BEGIN__}
  // const __CV_END__ = goto exit; exit:; end;;
  // {$EXTERNALSYM __CV_END__}
  // const __CV_EXIT__ = goto exit;
  // {$EXTERNALSYM __CV_EXIT__}
  // {$IFDEF __cplusplus}
  // end;
  //
  /// / classes for automatic module/RTTI data registration/unregistration
  // CV_EXPORTS CvModule begin CvModule(CvModuleInfo * _info); ~ CvModule(); CvModuleInfo * info;
  //
  // CvModuleInfo * first; CvModuleInfo * last;);
  //
  // CV_EXPORTS CvType begin CvType(PCVChar type_name, CvIsInstanceFunc is_instance,
  // CvReleaseFunc release = 0, CvReadFunc read := 0, CvWriteFunc write = 0, CvCloneFunc clone = 0);
  // ~ CvType(); CvTypeInfo * info;
  //
  // CvTypeInfo * first; CvTypeInfo * last;);
  //
  // {$ENDIF}
  // {$ENDIF}
implementation

uses
  uLibName;

procedure cvAlloc(size: size_t); external Core_Dll; cdecl;
procedure cvFree_(ptr: Pointer); external Core_Dll; cdecl;
function cvCreateImageHeader; external Core_Dll; cdecl;
function cvCreateImage; external Core_Dll; cdecl;
procedure cvReleaseImageHeader; external Core_Dll; cdecl;
procedure cvReleaseImage; external Core_Dll; cdecl;
function cvCloneImage; external Core_Dll; cdecl;
procedure cvSetImageCOI; external Core_Dll; cdecl;
function cvGetImageCOI; external Core_Dll; cdecl;
procedure cvSetImageROI; external Core_Dll; cdecl;
procedure cvResetImageROI; external Core_Dll; cdecl;
function cvGetImageROI; external Core_Dll; cdecl;
function cvCreateMatHeader; external Core_Dll; cdecl;

function cvGetSize(const arr: pCvArr): TCvSize; assembler;
asm
  // mov eax,arr - � eax ��� �������� ����� arr
  push edx // � edx ����� ���������� Result - ���������, �.�. _cvGetSize ���������� ��������� � eax:edx
  push eax
  call _cvGetSize
  pop ecx  // ������ ����
  mov ecx,edx // ��������� ������� ����� ���������� _cvGetSize
  pop edx // ��������������� Result
  mov Result.width,eax
  mov Result.height,ecx
end;

//function cvGetSize(const arr: pIplImage): TCvSize;
//begin
//  Result := cvGetSize(pCvArr(arr));
//end;

procedure _cvGetSize(const arr: pCvArr; var size: TCvSize); external Core_Dll name 'cvGetSize';
//function _cvGetSize; external Core_Dll name 'cvGetSize';

// function _cvGetSize(const image: pIplImage): TCvSize;
// begin
// if assigned(image^.roi) then
// begin
// Result.width := image^.roi^.width;
// Result.height := image^.roi^.height;
// end
// else
// begin
// Result.width := image^.width;
// Result.height := image^.height;
// end;
// end;

procedure cvSet; external Core_Dll;
procedure cvInitFont; external Core_Dll;
procedure cvPutText; external Core_Dll;

procedure cvCircle; external Core_Dll;
// procedure cvCircle(img: pIplImage; center: TCvPoint; radius: Integer; color: TCvScalar; thickness: Integer = 1;
// line_type: Integer = 8; shift: Integer = 0); external Core_Dll name 'cvCircle';
// procedure cvCircle(img: pCvMat; center: TCvPoint; radius: Integer; color: TCvScalar; thickness: Integer = 1;
// line_type: Integer = 8; shift: Integer = 0); external Core_Dll name 'cvCircle';

procedure cvLine; external Core_Dll;
// procedure cvLine(img: pIplImage; pt1, pt2: TCvPoint; color: TCvScalar; thickness: Integer = 1; line_type: Integer = 8;
// shift: Integer = 0); external Core_Dll name 'cvLine';
// procedure cvLine(img: pCvMat; pt1, pt2: TCvPoint; color: TCvScalar; thickness: Integer = 1; line_type: Integer = 8;
// shift: Integer = 0); external Core_Dll name 'cvLine';

procedure cvAddS; external Core_Dll;
procedure cvCopy; external Core_Dll;
procedure cvCopyImage; external Core_Dll name 'cvCopy';

procedure cvSetZero; external Core_Dll;
procedure cvZero; external Core_Dll;
//procedure cvZero(arr: pIplImage); cdecl; overload; external Core_Dll name 'cvSetZero';
//procedure cvZero(arr: pCvMat); cdecl; overload; external Core_Dll name 'cvSetZero';

function CV_RGB;
begin
  Result := CvScalar(B, g, r, 0);
end;

procedure cvSave(const filename: pCVChar; const struct_ptr: Pointer; const name: pCVChar; const comment: pCVChar; attributes: TCvAttrList); external Core_Dll; overload;
procedure cvSave(const filename: pCVChar; const struct_ptr: Pointer; const name: pCVChar = Nil; const comment: pCVChar = Nil); overload; inline;
begin
  cvSave(filename, struct_ptr, name, comment, ZeroCvAttrList);
end;

function cvLoad; external Core_Dll;

procedure cvReleaseMat; external Core_Dll;

procedure cvAddWeighted; external Core_Dll;

procedure cvInRange; external Core_Dll;
procedure cvInRangeS; external Core_Dll;
procedure cvSplit; external Core_Dll;
procedure cvMerge; external Core_Dll;
procedure cvMinMaxLoc; external Core_Dll;
procedure cvAnd; external Core_Dll;

procedure cvCvtPixToPlane; external Core_Dll name 'cvSplit';
procedure cvCvtPlaneToPix; external Core_Dll name 'cvMerge';

procedure cvConvertScale; external Core_Dll;
// procedure cvConvertScale(const src: pIplImage; dst: pIplImage; scale: Double = 1; shift: Double = 0); cdecl;
// external Core_Dll name 'cvConvertScale';
// procedure cvConvertScale(const src: pCvMat; dst: pCvMat; scale: Double = 1; shift: Double = 0); cdecl;
// external Core_Dll name 'cvConvertScale';

procedure cvScale; external Core_Dll name 'cvConvertScale';
procedure cvCvtScale; external Core_Dll name 'cvConvertScale';

procedure cvConvert;
begin
  cvConvertScale(src, dst, 1, 0);
end;

procedure cvSub; external Core_Dll;

procedure cvSubS;
begin
  cvAddS(src, CvScalar(-value.val[0], -value.val[1], -value.val[2], -value.val[3]), dst, mask);
end;

function cvCreateMemStorage; external Core_Dll;
function cvGetSeqElem; external Core_Dll;
procedure cvReleaseMemStorage; external Core_Dll;
procedure cvDrawContours; external Core_Dll;

function cvGetTickCount;
begin
  Result := GetTickCount;
end;

function GetTickFrequency: Double;
Var
  freq: TLargeInteger;
begin
  QueryPerformanceFrequency(freq);
  Result := freq;
end;

function cvGetTickFrequency: Double;
begin
  Result := GetTickFrequency() * 1E-6;
end;

procedure cvFlip; external Core_Dll;
procedure cvMirror; external Core_Dll name 'cvFlip';
procedure cvRectangle; external Core_Dll;
function cvGetSubRect; external Core_Dll;
procedure cvClearMemStorage; external Core_Dll;
function cvCreateMat; external Core_Dll;
function cvGet2D; external Core_Dll;
function cvGetReal2D; external Core_Dll;
function cvOpenFileStorage; external Core_Dll;
procedure cvReleaseFileStorage; external Core_Dll;

function cvReadInt;
begin
  // return !node ? default_value :
  // CV_NODE_IS_INT(node->tag) ? node->data.i :
  // CV_NODE_IS_REAL(node->tag) ? cvRound(node->data.f) : 0x7fffffff;
  Result := iif(not Assigned(node), default_value, iif(CV_NODE_IS_INT(node^.tag), node^.i,
    iif(CV_NODE_IS_REAL(node^.tag), node^.f, $7FFFFFFF)));
end;

function cvReadIntByName;
begin
  // return cvReadInt( cvGetFileNodeByName( fs, map, name ), default_value );
  Result := cvReadInt(cvGetFileNodeByName(fs, map, name), default_value);
end;

function cvGetFileNodeByName; external Core_Dll;
function cvRead; external Core_Dll;
function cvCvtSeqToArray; external Core_Dll;
function cvCreateSeq; external Core_Dll;
procedure cvPolyLine; external Core_Dll;
procedure cvStartReadSeq; external Core_Dll;
// procedure cvStartReadSeq(const seq: pCvSeq; reader: pCvSeqReader; reverse: Integer = 0);
// external Core_Dll name 'cvStartReadSeq';
// procedure cvStartReadSeq(const seq: pCvSet; reader: pCvSeqReader; reverse: Integer = 0);
// external Core_Dll name 'cvStartReadSeq';
procedure cvChangeSeqBlock; external Core_Dll;
procedure cvCreateSeqBlock; external Core_Dll;
function cvSeqPush; external Core_Dll;
function cvGetReal1D; external Core_Dll;

procedure cvEllipseBox;
Var
  axes: TCvSize;
begin
  axes.width := cvRound(box.size.width * 0.5);
  axes.height := cvRound(box.size.height * 0.5);
  cvEllipse(img, cvPointFrom32f(box.center), axes, box.angle, 0, 360, color, thickness, line_type, shift);
end;

procedure cvXorS; external Core_Dll;
procedure cvEllipse; external Core_Dll;

procedure cvFree;
begin
  // #define cvFree(ptr) (cvFree_(*(ptr)), *(ptr)=0)
  cvFree_(@ptr);
  Pointer(ptr) := nil;
end;

function cvInitImageHeader; external Core_Dll;
function cvInitMatHeader; external Core_Dll;
function cvCountNonZero; external Core_Dll;
procedure cvFillConvexPoly; external Core_Dll;

end.
