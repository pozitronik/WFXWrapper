unit Debugger;

interface

uses
	Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ValEdit, Vcl.ExtCtrls, Vcl.Grids, Vcl.StdCtrls, Vcl.Menus, WFXInterface, Plugin_types, Settings, Vcl.ComCtrls, System.ImageList, Vcl.ImgList;

type
	TTOTAL_CMD = class(TForm)
		MainSplitter: TSplitter;
		MainMenu: TMainMenu;
		StartItem: TMenuItem;
		DebugPanel: TListBox;
		LoadItem: TMenuItem;
		LoadPluginDialog: TOpenDialog;
		TMyListBox: TListView;
		IconsList: TImageList;
		procedure FormCreate(Sender: TObject);
		procedure LoadItemClick(Sender: TObject);
	private
		SettingsIniFilePath: WideString;
		{Private declarations}
	public
		{Public declarations}
		Procedure LoadPlugin(FileName: WideString);
		Procedure AddFindDataToFileList(FileList: TListView; FindData: tWIN32FINDDATA);
		Function GetDir(Path: WideString): Boolean;
		Function FileTime2DateTime(FT: _FileTime): TDateTime;
		Function AttrToStr(Attr: Cardinal): WideString;

	end;

var
	TOTAL_CMD: TTOTAL_CMD;
	WFX: TWFX;

implementation

{$R *.dfm}

procedure LogProc(PluginNr, MsgType: integer; LogString: pWideChar); stdcall;
begin
	TOTAL_CMD.DebugPanel.AddItem(WFX.MsgCodeToText(MsgType) + ': ' + LogString, nil);
end;

procedure TTOTAL_CMD.AddFindDataToFileList(FileList: TListView; FindData: tWIN32FINDDATA);
begin
	with FileList.Items.Add do
	begin
		if ((faDirectory and FindData.dwFileAttributes) > 0) then
		begin
			ImageIndex := 0;
			SubItems.Add(FindData.cFileName);
			SubItems.Add('<DIR>')
		end else begin
			ImageIndex := 1;
			SubItems.Add(FindData.cFileName);
			SubItems.Add(IntToStr((FindData.nFileSizeHigh * MAXDWORD) + FindData.nFileSizeLow))
		end;

		if (FindData.ftLastWriteTime.dwLowDateTime <> MAXDWORD - 1) and (FindData.ftLastWriteTime.dwHighDateTime <> MAXDWORD) then
		begin
			SubItems.Add(DateToStr(FileTime2DateTime(FindData.ftLastWriteTime)) + ' ' + TimeToStr(FileTime2DateTime(FindData.ftLastWriteTime)))
		end
		else SubItems.Add('');
		SubItems.Add(AttrToStr(FindData.dwFileAttributes));
	end;

	//Items.Append(FindData.cFileName + (FindData.nFileSizeHigh * MAXDWORD + FindData.nFileSizeLow).ToString);
end;

function TTOTAL_CMD.AttrToStr(Attr: Cardinal): WideString;
begin
	Result:='-------';
	if Attr >= 8192 then Attr:=Attr - 8192;
	if Attr = FILE_ATTRIBUTE_NORMAL then
	begin
		Result:='-------';
		exit;
	end;
	if Attr >= FILE_ATTRIBUTE_OFFLINE then
	begin
		Result[7]:='o';
		Attr:=Attr - FILE_ATTRIBUTE_OFFLINE;
	end;
	if Attr >= FILE_ATTRIBUTE_COMPRESSED then
	begin
		Result[6]:='c';
		Attr:=Attr - FILE_ATTRIBUTE_COMPRESSED;
	end;
	if Attr >= FILE_ATTRIBUTE_TEMPORARY then
	begin
		Result[5]:='t';
		Attr:=Attr - FILE_ATTRIBUTE_TEMPORARY;
	end;
	if Attr >= FILE_ATTRIBUTE_ARCHIVE then
	begin
		Result[2]:='a';
		Attr:=Attr - FILE_ATTRIBUTE_ARCHIVE;
	end;
	if Attr >= FILE_ATTRIBUTE_DIRECTORY then
	begin
		Attr:=Attr - FILE_ATTRIBUTE_DIRECTORY;
	end;
	if Attr >= FILE_ATTRIBUTE_SYSTEM then
	begin
		Result[4]:='s';
		Attr:=Attr - FILE_ATTRIBUTE_SYSTEM;
	end;
	if Attr >= FILE_ATTRIBUTE_HIDDEN then
	begin
		Result[3]:='h';
		Attr:=Attr - FILE_ATTRIBUTE_HIDDEN;
	end;
	if Attr >= FILE_ATTRIBUTE_READONLY then
	begin
		Result[1]:='r';
		//attr:=attr-FILE_ATTRIBUTE_READONLY;
	end;

end;

function TTOTAL_CMD.FileTime2DateTime(FT: _FileTime): TDateTime;
var
	FileTime: _SystemTime;
begin
	FileTimeToLocalFileTime(FT, FT);
	FileTimeToSystemTime(FT, FileTime);
	Result:=EncodeDate(FileTime.wYear, FileTime.wMonth, FileTime.wDay) + EncodeTime(FileTime.wHour, FileTime.wMinute, FileTime.wSecond, FileTime.wMilliseconds);
end;

procedure TTOTAL_CMD.FormCreate(Sender: TObject);
var
	tmp: pWideChar;
begin
	GetMem(tmp, max_path);
	GetModuleFilename(hInstance, tmp, max_path);
	SettingsIniFilePath := tmp + 'wrapper.ini';
	freemem(tmp);
	if (GetSettings(SettingsIniFilePath).PluginFile <> '') then LoadPlugin(GetSettings(SettingsIniFilePath).PluginFile);
end;

function TTOTAL_CMD.GetDir(Path: WideString): Boolean;
var
	FindData: tWIN32FINDDATA;
	Handle: THandle;
begin
	Handle:=WFX.FindFirstW(Path, FindData);
	TMyListBox.Items.Clear;
	AddFindDataToFileList(TMyListBox, FindData);
	while WFX.FindNextW(Handle, FindData) do
	begin
		Application.ProcessMessages;
		AddFindDataToFileList(TMyListBox, FindData);
	end;
	WFX.FindClose(Handle);
end;

procedure TTOTAL_CMD.LoadItemClick(Sender: TObject);
begin
	if (LoadPluginDialog.Execute() and (FileExists(LoadPluginDialog.FileName))) then
	begin
		SetSettingsValue(SettingsIniFilePath, 'PluginFile', LoadPluginDialog.FileName);
		LoadPlugin(GetSettings(SettingsIniFilePath).PluginFile);
	end;
end;

procedure TTOTAL_CMD.LoadPlugin(FileName: WideString);
begin
	LogProc(0, msgtype_details, pWideChar('Loaded file: ' + FileName));
	self.caption := 'Loaded: ' + FileName;
	WFX:=TWFX.create(GetSettings(SettingsIniFilePath).PluginFile, nil, @LogProc);
	WFX.FsInit(0, nil, @LogProc, nil);
	GetDir('\');
end;

end.
