unit Unit1;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

	{ TfrmIconSpacing }

    TfrmIconSpacing = class(TForm)
		btnSave: TButton;
		edtOwn: TEdit;
		rbtnWindow10: TRadioButton;
		rbtnWindows7: TRadioButton;
		rbtnOwn: TRadioButton;
		procedure btnSaveClick(Sender: TObject);
  procedure FormActivate(Sender: TObject);
		procedure rbtnWindow10Change(Sender: TObject);
    private
        function GetIconVerticalSpacing: String;
        function SaveIconVerticalSpacing(IconVerticalSpacing: String): Boolean;
    public
        { public declarations }
    end;

var
    frmIconSpacing: TfrmIconSpacing;

implementation

{$R *.lfm}

uses
    Registry;

procedure TfrmIconSpacing.FormActivate(Sender: TObject);
var
    IconVerticalSpacing: String;
begin
    IconVerticalSpacing := GetIconVerticalSpacing;

    if IconVerticalSpacing = '-1710' then
    begin
        rbtnWindow10.Checked := true;
        edtOwn.Enabled := false;
	end
	else if IconVerticalSpacing = '-1125' then
    begin
        rbtnWindows7.Checked := true;
        edtOwn.Enabled := false;
    end
    else
    begin
        rbtnOwn.Checked := true;
        edtOwn.Text := IconVerticalSpacing;
        edtOwn.Enabled := true;
	end;
end;

procedure TfrmIconSpacing.btnSaveClick(Sender: TObject);
var
    IconVerticalSpacing: String;
    IconVerticalSpacingInteger: Integer;
begin
    if rbtnWindow10.Checked then
        IconVerticalSpacing := '-1710'
    else if rbtnWindows7.Checked then
        IconVerticalSpacing := '-1125'
    else
        IconVerticalSpacing := edtOwn.Text;

    IconVerticalSpacingInteger := StrToInt(IconVerticalSpacing);

    if (IconVerticalSpacingInteger > -480) or (IconVerticalSpacingInteger < -2730) then
        ShowMessage('Die Werte müssen zwischen -480 und -2730 liegen.')
    else
        if SaveIconVerticalSpacing(IconVerticalSpacing) then
            ShowMessage('Speichern erfolgreich, bitte ab- und anmelden.')
        else
            ShowMessage('Es ist ein Fehler aufgetreten.')
end;

procedure TfrmIconSpacing.rbtnWindow10Change(Sender: TObject);
var
    SelectedRadioButton: TRadioButton;
begin
    SelectedRadioButton := Sender as TRadioButton;
    if SelectedRadioButton = rbtnOwn then
    begin
        edtOwn.Enabled := true;
        edtOwn.SetFocus;
	end
	else
    begin
        edtOwn.Enabled := false;
	end;
end;

function TfrmIconSpacing.GetIconVerticalSpacing: String;
var
    Registry: TRegistry;
begin
    GetIconVerticalSpacing := '';

    Registry := TRegistry.Create;

    try
        Registry.RootKey := HKEY_CURRENT_USER;
        if Registry.OpenKeyReadOnly('\Control Panel\Desktop\WindowMetrics') then
            GetIconVerticalSpacing := Registry.ReadString('IconVerticalSpacing')
    finally
        Registry.Free;
    end;
end;

function TfrmIconSpacing.SaveIconVerticalSpacing(IconVerticalSpacing: String): Boolean;
var
    Registry: TRegistry;
begin
    SaveIconVerticalSpacing := false;

    Registry := TRegistry.Create;

    try
        Registry.RootKey := HKEY_CURRENT_USER;
        if Registry.OpenKey('\Control Panel\Desktop\WindowMetrics', true) then
            Registry.WriteString('IconVerticalSpacing', IconVerticalSpacing);
        SaveIconVerticalSpacing := true;
	finally
        Registry.Free;
	end;
end;

end.

