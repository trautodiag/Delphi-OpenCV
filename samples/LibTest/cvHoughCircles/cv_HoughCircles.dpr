// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_HoughCircles;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
uLibName in '..\..\..\include\uLibName.pas',
highgui_c in '..\..\..\include\highgui\highgui_c.pas',
core_c in '..\..\..\include\�ore\core_c.pas',
Core.types_c in '..\..\..\include\�ore\Core.types_c.pas',
imgproc.types_c in '..\..\..\include\imgproc\imgproc.types_c.pas',
imgproc_c in '..\..\..\include\imgproc\imgproc_c.pas',
legacy in '..\..\..\include\legacy\legacy.pas',
calib3d in '..\..\..\include\calib3d\calib3d.pas',
imgproc in '..\..\..\include\imgproc\imgproc.pas',
haar in '..\..\..\include\objdetect\haar.pas',
objdetect in '..\..\..\include\objdetect\objdetect.pas',
tracking in '..\..\..\include\video\tracking.pas',
Core in '..\..\..\include\�ore\core.pas'
  ;

const
  filename = 'Resource\opencv_logo_with_text_sm.png';

Type
  TFloatArray = array [0 .. 10] of Single;
  pFloatArray = ^TFloatArray;

Var
  image: pIplImage = nil;
  src: pIplImage = nil;
  storage: pCvMemStorage;
  results: pCvSeq;
  i: Integer;
  p: pFloatArray;
  pt: TCvPoint;

begin
  try
    // �������� �������� (� ��������� ������)
    image := cvLoadImage(filename, CV_LOAD_IMAGE_GRAYSCALE);
    WriteLn(Format('[i] image: %s', [filename]));

    // �������� ������������ �����������
    src := cvLoadImage(filename);

    // ��������� ������ ��� ������
    storage := cvCreateMemStorage(0);
    // ���������� �����������
    cvSmooth(image, image, CV_GAUSSIAN, 5, 5);

    // ����� ������
    results := cvHoughCircles(image, storage, CV_HOUGH_GRADIENT, 10, image^.width / 5);

    // ����������� �� ������ � ������ �� �� ������������ �����������
    for i := 0 to results^.total - 1 do
    begin
      p := pFloatArray(cvGetSeqElem(results, i));
      pt := CvPoint(cvRound(p^[0]), cvRound(p^[1]));
      cvCircle(src, pt, cvRound(p^[2]), CV_RGB(255, 0, 0));
    end;

    // ����������
    cvNamedWindow('cvHoughCircles', 1);
    cvShowImage('cvHoughCircles', src);

    // ��� ������� �������
    cvWaitKey(0);

    // ����������� �������
    cvReleaseMemStorage(storage);
    cvReleaseImage(image);
    cvReleaseImage(src);
    cvDestroyAllWindows();
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
