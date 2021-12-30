{ ********************************************************************************* }
{ Copyright (c) 2013 Debenu                                                         }
{                                                                                   }
{ The MIT License (MIT)                                                             }
{                                                                                   }
{ Permission is hereby granted, free of charge, to any person obtaining a copy of   }
{ this software and associated documentation files (the "Software"), to deal in     }
{ the Software without restriction, including without limitation the rights to      }
{ use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of  }
{ the Software, and to permit persons to whom the Software is furnished to do so,   }
{ subject to the following conditions:                                              }
{                                                                                   }
{ The above copyright notice and this permission notice shall be included in all    }
{ copies or substantial portions of the Software.                                   }
{                                                                                   }
{ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR        }
{ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS  }
{ FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR    }
{ COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER    }
{ IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN           }
{ CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.        }
{ ********************************************************************************* }

unit ImageToPDF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DebenuPDFLibrary1011, StdCtrls, FileCtrl, ShellApi;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    ListBox1: TListBox;
    btnAddImage: TButton;
    btnRemoveImage: TButton;
    GroupBox2: TGroupBox;
    btnConvert: TButton;
    btnCancel: TButton;
    btnBrowse: TButton;
    txtOutputLocation: TEdit;
    lblOutputStatusDesc: TLabel;
    lblOutputStatus: TLabel;
    dlgOpen: TOpenDialog;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnAddImageClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRemoveImageClick(Sender: TObject);
    procedure btnConvertClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DPL: TDebenuPDFLibrary1011;
    UnlockResult: Integer;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.btnAddImageClick(Sender: TObject);
begin
  dlgOpen.FileName := '';
  dlgOpen.Filter :=
    'Image Files (JPEG,GIF,BMP,PNG,WMF,EMF,TIFF)|*.jpg;*.jpeg;*.gif;*.bmp;*.png;*.tiff;*.wmf;*.emf';

  if dlgOpen.Execute then
  begin
  ListBox1.Items.Add(dlgOpen.FileName);
  lblOutputStatus.Caption := 'There are ' + IntToStr(ListBox1.Count) + ' images in the list ready to be converted.';
  end else
end;

procedure TForm2.btnBrowseClick(Sender: TObject);
var
   dir : string;
begin
 dir :='C:\';
  FileCtrl.SelectDirectory('Select', 'C:\', dir, [sdNewFolder, sdNewUI], Self);
  txtOutputLocation.Text := dir;
 end;

procedure TForm2.btnCancelClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm2.btnConvertClick(Sender: TObject);
var
SaveResult, lWidth, lHeight: Integer;
sFileName, oldName, tempName, newName: AnsiString;
ImageID: Integer;
dpix: Integer;
dpiy: Integer;
ImageWidthInPoints: Double;
ImageHeightInPoints: Double;
begin
if ListBox1.Items.Count < 1 then
begin
  ShowMessage('There are no images to convert. Please add one or more images to the list and try again.');
end;
  DPL := TDebenuPDFLibrary1011.Create;
try
  UnlockResult := DPL.UnlockKey('...INSERT_LICENSE_KEY_HERE...');
  if UnlockResult = 0 then
  begin
    ShowMessage('Debenu Quick PDF Library could not be unlocked, please check your license key and try again.');
  end else
  begin
    for sFileName in ListBox1.Items do
    begin
      // Create a blank document using Debenu Quick PDF Library
      DPL.SelectDocument(DPL.NewDocument());
	  
      // Get the ID of the image
      ImageID := DPL.AddImageFromFile(sFileName, 0);

      // Check if the image ID was retrieved successfully
      if ImageID = 0 then
      begin
        ShowMessage('Debenu Quick PDF Library was unable to load the image.');
      end else

        // Select the image that has just been loaded
        DPL.SelectImage(ImageID);

        // Get the vertical and horizontal resolution of image
        dpix := DPL.ImageHorizontalResolution();
        dpiy := DPL.ImageVerticalResolution();

        // PNG and GIF image files do not have a DPI setting,
        // however, image types such as BMP, JPEG and TIFF all do.
        // A DPI value of 72 is presumed if a DPI setting is not
        // found in the image.

        // Set horizontal DPI value of 72 if no DPI setting found
        if dpix = 0 then
        begin
          dpix := 72;
        end;

        // Set vertical DPI value of 72 if no DPI setting found
        if dpiy = 0 then
        begin
          dpiy := 72;
        end;

	// Get the image width and height in points
        ImageWidthInPoints := DPL.ImageWidth() / dpix * 72.0; // assumming dpi units
        ImageHeightInPoints := DPL.ImageHeight() / dpiy * 72.0;

        // Use width and height of image to set the page dimensions of the new document
        DPL.SetPageDimensions(ImageWidthInPoints, ImageHeightInPoints);

        // Draw the image onto the document using the specified width and height of image
        DPL.DrawImage(0, ImageHeightInPoints, ImageWidthInPoints, ImageHeightInPoints);

        // Remove the the image file type extension and replace with a .PDF extension, then remove the old path of the file
        oldName := sFileName;
        tempName := ChangeFileExt(oldName, '.pdf');
        newName := ExtractFileName(tempName);

        // Save the new document, which now contains the image, to disk
        SaveResult := DPL.SaveToFile(txtOutputLocation.Text + '\' + newName);

        if SaveResult = 1 then
        begin
          lblOutputStatus.Caption := 'The image(s) have been successfully converted to PDF. Opening containg folder now.';
          ShellExecute(Handle,'open', PWideChar(txtOutputLocation.Text), nil, nil, SW_SHOWNORMAL) ;
        end else
        begin
          lblOutputStatus.Caption := 'There was an error converting the image(s).';
        end;
    end;
  end;
finally
  DPL.Free;
end;

end;

procedure TForm2.btnRemoveImageClick(Sender: TObject);
var
Index: Integer;
begin
  Index := ListBox1.ItemIndex;
  ListBox1.Items.Delete(Index);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  txtOutputLocation.Text := 'C:\Output\';
end;

end.
