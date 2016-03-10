unit proc_messagebox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Forms, Dialogs, Buttons,
  LclProc, LclType, LCLStrConsts,
  proc_msg;

function MessageBoxEmulated(const Msg: string; Flags: Longint): Longint;


implementation

procedure DoLocalizeBtn(F: TForm; const AFrom, ATo: string);
var
  C: TControl;
  i: integer;
begin
  for i:= 0 to F.ControlCount-1 do
  begin
    C:= F.Controls[i];
    if C.Caption=AFrom then
    begin
      C.Caption:= ATo;
      if (C is TBitBtn) then
        (C as TBitBtn).Autosize:= true;
      Break
    end;
  end;
end;

function MessageBoxEmulated(const Msg: string; Flags: Longint): Longint;
var
  Buttons: TMsgDlgButtons;
  DlgType: TMsgDlgType;
  Form: TForm;
begin
  Buttons:= [mbOK];
  if (Flags and $F)=MB_OKCANCEL         then Buttons:= mbOKCancel;
  if (Flags and $F)=MB_ABORTRETRYIGNORE then Buttons:= mbAbortRetryIgnore;
  if (Flags and $F)=MB_YESNO            then Buttons:= mbYesNo;
  if (Flags and $F)=MB_YESNOCANCEL      then Buttons:= mbYesNoCancel;
  if (Flags and $F)=MB_RETRYCANCEL      then Buttons:= [mbRetry, mbCancel];

  DlgType:= mtInformation;
  if (Flags and $F0)=MB_ICONERROR       then DlgType:= mtError;
  if (Flags and $F0)=MB_ICONQUESTION    then DlgType:= mtConfirmation;
  if (Flags and $F0)=MB_ICONWARNING     then DlgType:= mtWarning;
  if (Flags and $F0)=MB_ICONINFORMATION then DlgType:= mtInformation;

  Form:= CreateMessageDialog(Msg, DlgType, Buttons);
  try
    Form.Caption:= msgTitle;
    Form.Position:= poScreenCenter;

    DoLocalizeBtn(Form, rsMbOK, msgButtonOk);
    DoLocalizeBtn(Form, rsMbCancel, msgButtonCancel);
    DoLocalizeBtn(Form, rsMbYes, msgButtonYes);
    DoLocalizeBtn(Form, rsMbNo, msgButtonNo);
    DoLocalizeBtn(Form, rsMbAbort, msgButtonAbort);
    DoLocalizeBtn(Form, rsMbRetry, msgButtonRetry);
    DoLocalizeBtn(Form, rsMbIgnore, msgButtonIgnore);
    DoLocalizeBtn(Form, rsMbYesToAll, msgButtonYesAll);
    DoLocalizeBtn(Form, rsMbNoToAll, msgButtonNoAll);

    Result:= Form.ShowModal;
    //seems no need converting from ModalResult to id_nnn
  finally
    Form.Free;
  end;
end;

end.

