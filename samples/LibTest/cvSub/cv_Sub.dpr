// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_Sub;

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
  filename = 'Resource\cat2.jpg';

Var
  src: pIplImage = nil;
  dst: pIplImage = nil;
  dst2: pIplImage = nil;

begin
try
  // �������� �������� � ��������� ������
  src := cvLoadImage(filename, CV_LOAD_IMAGE_GRAYSCALE);
  WriteLn(Format('[i] image: %s', [filename]));

  // ������� �����������
  cvNamedWindow('original', 1);
  cvShowImage('original', src);

  // ������� �������� �����������
  dst2 := cvCreateImage(cvSize(src^.width, src^.height), IPL_DEPTH_8U, 1);
  cvCanny(src, dst2, 50, 200);

  cvNamedWindow('bin', 1);
  cvShowImage('bin', dst2);

  // cvScale(src, dst);
  cvSub(src, dst2, dst2);
  cvNamedWindow('sub', 1);
  cvShowImage('sub', dst2);

  // ��� ������� �������
  cvWaitKey(0);

  // ����������� �������
  cvReleaseImage(src);
  cvReleaseImage(dst);
  cvReleaseImage(dst2);
  // ������� ����
  cvDestroyAllWindows();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
