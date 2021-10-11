unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, TLHelp32, PsAPI, StdCtrls, ImgList, ComObj, ShlObj, ActiveX,
  Shellapi , ToolWin, IniFiles, Menus, ExtCtrls,Registry, XPMan ;

const
WM_NOTIFYTRAYICON = WM_USER + 1;

type
 PTOKEN_USER = ^TOKEN_USER;
 _TOKEN_USER = record
 User : TSidAndAttributes;
end;

TOKEN_USER = _TOKEN_USER;

type
  TIconType = (itSmall, itLarge);

type
  TForm1 = class(TForm)
    Button1: TButton;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    StatusBar1: TStatusBar;
    N3: TMenuItem;
    PopupMenu1: TPopupMenu;
    N4: TMenuItem;
    Button3: TButton;
    N5: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    Windows1: TMenuItem;
    PopupMenu2: TPopupMenu;
    N7: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    ListView1: TListView;
    XPManifest1: TXPManifest;
    procedure Button1Click(Sender: TObject);
    procedure ListView1CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure Windows1Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);

  private
    procedure WMTRAYICONNOTIFY(var Msg: TMessage); message WM_NOTIFYTRAYICON;
  public
    { Public declarations }
  end;

var
  Form1:             TForm1;
  ProcessHandle:     THandle;
  ProcessExePath:    array[0..127] of Char;
  WindowExePath:     array[0..127] of Char;
  buff:              array[0..127] of Char;
  TheIcon:           TIcon;
  Domain, User :     array [0..50] of Char;
  ProcessID:         DWORD;
  chDomain,chUser :  Cardinal;
  ProcColor:         integer;
  pmc:               PPROCESS_MEMORY_COUNTERS;
  cb:                Integer;
  F:                 TIniFile;
  ListItem:          TListItem;
  ProgCap:           string;
  hProcess:          THandle;
  hToken:            THandle;
  Priv,PrivOld:      TOKEN_PRIVILEGES;
  cbPriv:            DWORD;
  dwError:           DWORD;
  hSnapShot:         THandle;
  uProcess:          PROCESSENTRY32;
  r:                 longbool;
  KillProc:          DWORD;
  LvInx:             integer;
  FileDescription:   string;
  P:                 TPoint;
  MayClose:          boolean=false;
  fff:               TStringList ;
  df: string;
implementation

{$R *.dfm}

procedure TForm1.WMTRAYICONNOTIFY(var Msg: TMessage);
begin
case Msg.LParam of
WM_LBUTTONUP:
begin
GetCursorPos(p);
SetForegroundWindow(Application.MainForm.Handle);
MayClose:= false;
Form1.Show;
Application.BringToFront;
end;
WM_RBUTTONUP:
begin
GetCursorPos(p);
SetForegroundWindow(Application.MainForm.Handle);
PopupMenu2.Popup(P.X, P.Y);
end;
end;
end;


//Выключение
procedure ExitWinNT(AShutdown: Boolean);
var
  hToken: THandle;
  tkp: TTokenPrivileges;
  ReturnLength: Cardinal;
begin
  if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or
    TOKEN_QUERY, hToken) then
  begin
    LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tkp.Privileges[0].Luid);
    tkp.PrivilegeCount := 1; 
    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    if AdjustTokenPrivileges(hToken, False, tkp, 0, nil, ReturnLength) then
      ExitWindowsEx(EWX_SHUTDOWN or ewx_force,0);
  end;
end;


//Ждущий режим
procedure NTWait;
var
  hToken: THandle;
  tkp: TTokenPrivileges;
  ReturnLength: Cardinal;
begin
  if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or
    TOKEN_QUERY, hToken) then
  begin
    LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tkp.Privileges[0].Luid);
    tkp.PrivilegeCount := 1;
    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    if AdjustTokenPrivileges(hToken, False, tkp, 0, nil, ReturnLength) then
      SetSystemPowerState(true, true);
  end;
end;
//Перезагрузка
procedure NTReboot;
var
  hToken: THandle;
  tkp: TTokenPrivileges;
  ReturnLength: Cardinal;
begin
  if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or
    TOKEN_QUERY, hToken) then
  begin
    LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tkp.Privileges[0].Luid);
    tkp.PrivilegeCount := 1;
    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    if AdjustTokenPrivileges(hToken, False, tkp, 0, nil, ReturnLength) then
      ExitWindowsEx(EWX_REBOOT or ewx_force,0);
  end;
end;


function GetIcon(const FileName: string; const IconType: TIconType = itSmall):
  TIcon;
var
  FileInfo: TShFileInfo;
  ImageList: TImageList;
  IT: DWORD;
begin
  IT := SHGFI_SMALLICON;
  Result := TIcon.Create;
  ImageList := TImageList.Create(nil);
  if (IconType = itLarge) then
  begin
    IT := SHGFI_LARGEICON;
    ImageList.Height := 32;
    ImageList.Width := 32;
  end;
  FillChar(FileInfo, Sizeof(FileInfo), #0);
  ImageList.ShareImages := true;
  ImageList.Handle := SHGetFileInfo(
    PChar(FileName),
    SFGAO_SHARE,
    FileInfo,
    sizeof(FileInfo),
    IT or SHGFI_SYSICONINDEX
    );
  ImageList.GetIcon(FileInfo.iIcon, Result);
  ImageList.Free;
end;

function GetCurrentUserAndDomain (
      szUser : PChar; var chUser: DWORD; szDomain :PChar; var chDomain : DWORD
 ):Boolean;
var
 hToken : THandle;
 cbBuf  : Cardinal;
 ptiUser : PTOKEN_USER;
 snu    : SID_NAME_USE;
begin
 Result:=false;
 if not OpenThreadToken(GetCurrentThread(),TOKEN_QUERY,true,hToken)
  then begin
   if GetLastError()<> ERROR_NO_TOKEN then exit;
   if not OpenProcessToken(ProcessHandle,TOKEN_QUERY,hToken)
    then exit;
  end;
 if not GetTokenInformation(hToken, TokenUser, nil, 0, cbBuf)
  then if GetLastError()<> ERROR_INSUFFICIENT_BUFFER
   then begin
    CloseHandle(hToken); 
    exit;
   end;
 if cbBuf = 0 then exit;
 GetMem(ptiUser,cbBuf);
 if GetTokenInformation(hToken,TokenUser,ptiUser,cbBuf,cbBuf)
  then begin
   if LookupAccountSid(nil,ptiUser.User.Sid,szUser,chUser,szDomain,chDomain,snu)
    then Result:=true;
  end;
 CloseHandle(hToken);
 FreeMem(ptiUser);
end;

procedure FileVersionInfo;
type
 PLangAndCodePage = ^TLangAndCodePage;
 TLangAndCodePage = packed record
   wLanguage: Word;
   wCodePage: Word;
 end;
var
 I, InfoSize, BlockLength: Cardinal;
 pInfo: Pointer;
 pLangCP: PLangAndCodePage;
 pDesc: PChar;
 FileName: string;
begin
 FileName:= ProcessExePath;
 InfoSize:= GetFileVersionInfoSize(PChar(FileName), Cardinal(nil^));
 if InfoSize <> 0 then
 begin
   GetMem(pInfo, InfoSize);
   try
     if GetFileVersionInfo(PChar(FileName), 0, InfoSize, pInfo) then
       if VerQueryValue(pInfo, '\VarFileInfo\Translation', Pointer(pLangCP), BlockLength) then
         for I := 0 to Pred(BlockLength div sizeof(TLangAndCodePage)) do
         begin                                                            //CompanyName,Legalcopyright
           if VerQueryValue(pInfo, PChar(Format('\StringFileInfo\%.4x%.4x\FileDescription',
            [pLangCP.wLanguage, pLangCP.wCodePage])), Pointer(pDesc), BlockLength) then
             FileDescription:= pDesc;
           Inc(pLangCP)
         end
   finally
     FreeMem(pInfo, InfoSize);
   end ;
 end ;
end;


procedure GetProcs(ListView1: TListView; ImageList1: TImageList);
var
  hProcSnap: THandle;
  pe32: TProcessEntry32;

begin
  ListView1.Clear;
  FileDescription:= '';
  hProcSnap := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
  if hProcSnap = INVALID_HANDLE_VALUE then exit;
  pe32.dwSize := SizeOf(ProcessEntry32);
  if Process32First(hProcSnap, pe32) = true then
    while Process32Next(hProcSnap, pe32) = true do
     begin
      ProcessHandle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False,pe32.th32ProcessID );
       chDomain:=50;
        chUser :=50;
         GetCurrentUserAndDomain(User,chuser,Domain,chDomain);
          GetModuleFileNameEx(ProcessHandle, 0, ProcessExePath,127);
           FileVersionInfo;
            TheIcon:= TIcon.Create;
      if pe32.szExeFile = 'winlogon.exe' then
      begin
      TheIcon:= GetIcon('C:\WINDOWS\system32\winlogon.exe');
      end
      else
      begin
      TheIcon:= GetIcon(ProcessExePath);
      end;
      if TheIcon.Handle = 0 then
      TheIcon:= GetIcon('C:\WINDOWS\system32\svchost.exe');
      ImageList1.AddIcon(TheIcon);
      cb := SizeOf(_PROCESS_MEMORY_COUNTERS);
      GetMem(pmc, cb);
      pmc^.cb := cb;
      GetProcessMemoryInfo(ProcessHandle, pmc, cb);
      if  pmc^.PeakPagefileUsage <> 0 then

      with ListView1.Items.Add do begin
      Caption := pe32.szExeFile;
      if User = 'SYSTEM' then
      ProcColor:= 0
      else
      ProcColor:= 1;
      case ProcColor of
      0: Data := Pointer(RGB(255,208,208));
      1: Data := Pointer(clWhite);
      end;

      if pe32.szExeFile = 'winlogon.exe' then
      begin
      SubItems.Add('Windows NT Logon Application');
      end
      else
      begin
      SubItems.Add(FileDescription);
      end;

      SubItems.Add(User {+ '/' + Domain});
      if pe32.szExeFile = 'winlogon.exe' then
      begin
      SubItems.Add('C:\WINDOWS\system32\winlogon.exe');
      end
      else
      begin
      SubItems.Add(ExpandFileName(ProcessExePath));
      end;
      case pe32.pcPriClassBase of
      0: SubItems.Add('Н\Д');
      1..4: SubItems.Add('Низкий [' + FloatToStr(pe32.pcPriClassBase) + ']');
      5, 6: SubItems.Add('Ниже Среднего [' + FloatToStr(pe32.pcPriClassBase) + ']');
      7..9: SubItems.Add('Средний ['+ FloatToStr(pe32.pcPriClassBase) + ']');
      10..12: SubItems.Add('Выше Среднего [' + FloatToStr(pe32.pcPriClassBase) + ']');
      13..23: SubItems.Add('Высокий [' + FloatToStr(pe32.pcPriClassBase) + ']');
      24: SubItems.Add('Реального времени [24]');
      else
      SubItems.Add(FloatToStr(pe32.pcPriClassBase));
      end;
      SubItems.Add(IntToStr(pmc^.WorkingSetSize div 1024) + ' KB');
      SubItems.Add(FloatToStr(pe32.th32ProcessID));
      ImageIndex:= ImageList1.Count- 1;
      TheIcon.Free;
    end;
    end;
  CloseHandle(hProcSnap);
  CloseHandle(ProcessHandle);
end;



procedure TForm1.Button1Click(Sender: TObject);
begin
GetProcs(ListView1,ImageList1);
StatusBar1.Panels.Items[0].Text := 'Процессов: ' + IntToStr(ListView1.Items.Count);
end;

procedure TForm1.ListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
//Sender.Canvas.Font.Color := TColor(Item.Data);
Sender.Canvas.Brush.Color := TColor(Item.Data);
DefaultDraw:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
tray: TNotifyIconData;
Ic: TIcon;
begin
//Ic:= Image1.Picture.Icon;
with tray do
begin
cbSize := SizeOf(TNotifyIconData);
Wnd := Form1.Handle;
uID := 1;
uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
uCallBackMessage := WM_NOTIFYTRAYICON;
hIcon :=  Application.Icon.Handle;//Ic.Handle
szTip := ('Имя программы');
end;
Shell_NotifyIcon(NIM_ADD, Addr(tray));

ListView1.DoubleBuffered:= true;
Button1.DoubleBuffered:= true;
Form1.Button1Click(Button1);


  F := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'installation.ini');
  Form1.Left := F.ReadInteger('Position', 'left', Form1.Left);
  Form1.Width := F.ReadInteger('Position', 'width', Form1.Width);
  Form1.Top := F.ReadInteger('Position', 'top', Form1.Top);
  Form1.Height := F.ReadInteger('Position', 'height', Form1.Height);
  N3.Checked:= F.Readbool('MainMenu1','SortList', false);
  Windows1.Checked:= F.Readbool('MainMenu1','StartUp', false);
  F.Destroy;
  
if N3.Checked = true then
begin
ListView1.SortType:= stBoth;
Form1.Button1Click(Button1);
end
else
begin
ListView1.SortType:= stNone;
Form1.Button1Click(Button1);
end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
var
tray: TNotifyIconData;
begin
with tray do
begin
cbSize := SizeOf(TNotifyIconData);
Wnd := Form1.Handle;
uID := 1;
end;
Shell_NotifyIcon(NIM_DELETE, Addr(tray));

  F := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'installation.ini');
  F.WriteInteger('Position', 'left', Form1.Left);
  F.WriteInteger('Position', 'width', Form1.Width);
  F.WriteInteger('Position', 'top', Form1.Top);
  F.WriteInteger('Position', 'height', Form1.Height);
  F.WriteBool('MainMenu1','SortList', N3.Checked);
  F.WriteBool('MainMenu1','StartUp', Windows1.Checked);
  F.Free;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
if N3.Checked = true then
begin
ListView1.SortType:= stBoth;
end
else
begin
ListView1.SortType:= stNone;
end;
Form1.Button1Click(Button1);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
ProgCap:= ListView1.Selected.Caption;
hSnapShot:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
uProcess.dwSize := Sizeof(uProcess);
if(hSnapShot<>0)then
begin
r:=Process32First(hSnapShot, uProcess);
while r <> false do
begin
if  ProgCap = uProcess.szExeFile then
KillProc:= uProcess.th32ProcessID;
r:=Process32Next(hSnapShot, uProcess);
end;
CloseHandle(hProcess);
CloseHandle(hSnapShot);
end;

hProcess:=OpenProcess(PROCESS_TERMINATE,false,KillProc);
if hProcess = 0 then
 begin
  cbPriv:=SizeOf(PrivOld);
  OpenThreadToken(GetCurrentThread,TOKEN_QUERY or TOKEN_ADJUST_PRIVILEGES,false,hToken);
  OpenProcessToken(GetCurrentProcess,TOKEN_QUERY or  TOKEN_ADJUST_PRIVILEGES,hToken);
  Priv.PrivilegeCount:=1;
  Priv.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
  LookupPrivilegeValue(nil,'SeDebugPrivilege',Priv.Privileges[0].Luid);
  AdjustTokenPrivileges(hToken,false,Priv,SizeOf(Priv),PrivOld,cbPriv);
  hProcess:=OpenProcess(PROCESS_TERMINATE,false,KillProc);
  dwError:=GetLastError;
  cbPriv:=0;
  AdjustTokenPrivileges(hToken,false,PrivOld,SizeOf(PrivOld),nil,cbPriv);
  CloseHandle(hToken);
 end;
if TerminateProcess(hProcess,$FFFFFFFF) then
begin
ListView1.Items.Delete(ListView1.Selected.Index );
end
else
begin
Sleep(500);
MessageBeep(MB_ICONHAND);
MessageDlg('Не возможно завешить ' + ProgCap + ' !',
mtInformation	, [mbOK], 0);
end;

StatusBar1.Panels.Items[0].Text := 'Процессов: ' + IntToStr(ListView1.Items.Count);
end;

procedure TForm1.N4Click(Sender: TObject);
begin
Form1.Button3Click(Button3);
end;

procedure TForm1.N6Click(Sender: TObject);
begin
NTWait;
end;

procedure TForm1.N8Click(Sender: TObject);
begin
NTReboot;
end;

procedure TForm1.N9Click(Sender: TObject);
begin
ExitWinNT(True);
end;

procedure TForm1.Windows1Click(Sender: TObject);
var
  reg: TRegistry;
begin
if Windows1.Checked = true then
begin
  Reg := nil;
  try
    reg := TRegistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.LazyWrite := false;
    reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',false);
    reg.WriteString('WinXP Process Manager', Application.ExeName);
reg.CloseKey;
reg.free;
except
if Assigned(Reg) then Reg.Free;
end;
end
else
begin
  Reg := nil;
  try
    reg := TRegistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.LazyWrite := false;
    reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    reg.DeleteValue('WinXP Process Manager');


reg.CloseKey;
reg.free
except
if Assigned(Reg) then Reg.Free;
end;
end;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
MayClose:= true;
Form1.Close;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
if mayClose = false then
begin
CanClose:= false;
MayClose:= true;
Form1.Hide;
end
else
begin
CanClose:= true;
end;
end;



procedure TForm1.N10Click(Sender: TObject);
begin
MayClose:= true;
Form1.Close;
end;

procedure TForm1.N12Click(Sender: TObject);
begin
NTWait;
end;

procedure TForm1.N13Click(Sender: TObject);
begin
NTReboot;
end;

procedure TForm1.N14Click(Sender: TObject);
begin
ExitWinNT(True);
end;

procedure TForm1.N15Click(Sender: TObject);
begin
MayClose:= false;
Form1.Show;
Application.BringToFront;
end;

end.
